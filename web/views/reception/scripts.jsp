<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Client-Side Engine for Reception -->
<script>
    const todayStr = "${today}"; // e.g. "2026-11-24"

    // Danh sách phòng
    const roomsList = [
        <c:forEach var="r" items="${rooms}" varStatus="loop">
        {
            id: ${r.id},
            code: "${r.code}",
            roomTypeId: ${r.roomTypeId},
            typeName: "${r.roomTypeName}",
            price: ${r.price},
            area: "${r.area}",
            status: ${r.status}
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    // Danh sách đơn đặt phòng
    const bookingsList = [
        <c:forEach var="b" items="${bookings}" varStatus="loop">
        {
            id: ${b.id},
            code: "${b.code}",
            roomId: ${b.roomId != null ? b.roomId : 'null'},
            roomCode: "${b.roomCode != null ? b.roomCode : ''}",
            roomTypeName: "${b.roomTypeName}",
            guestName: "${b.guestName}",
            guestPhone: "${b.guestPhone}",
            guestEmail: "${b.guestEmail != null ? b.guestEmail : ''}",
            address: "${b.address != null ? b.address : ''}",
            checkIn: "${b.checkIn}",
            checkOut: "${b.checkOut}",
            guests: ${b.guests},
            totalPrice: ${b.totalPrice},
            formattedTotal: "${b.formattedTotal}",
            payStatus: "${b.payStatus}",
            payMethod: "${b.payMethod}",
            status: "${b.status}",
            note: "${b.note != null ? b.note : ''}"
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    // ==================== 1. POPULATE GRID VIEW STATUS TODAY ====================
    function populateGridView() {
        roomsList.forEach(r => {
            const header = document.getElementById("gridHeader_" + r.id);
            const statusText = document.getElementById("gridStatusText_" + r.id);
            const guestInfo = document.getElementById("gridGuestInfo_" + r.id);
            const footer = document.getElementById("gridFooter_" + r.id);

            if (!header) return;

            // Tìm booking của phòng này bao trùm hôm nay
            const activeBooking = bookingsList.find(b => {
                if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                if (b.status === 'cancelled' || b.status === 'checkedout') return false;
                return (b.checkIn <= todayStr && b.checkOut > todayStr);
            });

            // Tìm booking sắp đến hôm nay (checkIn == todayStr)
            const comingBooking = bookingsList.find(b => {
                if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                if (b.status === 'cancelled' || b.status === 'checkedout') return false;
                return (b.checkIn === todayStr && b.status !== 'checkedin');
            });

            if (activeBooking && activeBooking.status === 'checkedin') {
                // Đang ở (Amber/Yellow)
                header.className = "room-grid-header bg-status-staying";
                statusText.innerText = "ĐANG Ở";
                guestInfo.innerHTML = '<span class="fw-bold text-dark"><i class="bi bi-person-fill me-1"></i> ' + activeBooking.guestName + '</span>';
                footer.innerHTML = '<button type="button" class="btn btn-sm btn-dark w-100 fw-bold" onclick="showBookingDetailById(' + activeBooking.id + ')">Xem chi tiết</button>';
            } else if (comingBooking || (activeBooking && activeBooking.status !== 'checkedin')) {
                // Sắp đến (Red)
                const bk = comingBooking || activeBooking;
                header.className = "room-grid-header bg-status-coming";
                statusText.innerText = "SẮP ĐẾN";
                guestInfo.innerHTML = '<span class="fw-bold text-danger"><i class="bi bi-person-fill me-1"></i> ' + bk.guestName + '</span>';
                footer.innerHTML = '<button type="button" class="btn btn-sm btn-danger w-100 fw-bold" onclick="showBookingDetailById(' + bk.id + ')">Xem chi tiết</button>';
            } else {
                // Trống (Green)
                header.className = "room-grid-header bg-status-empty";
                statusText.innerText = "PHÒNG TRỐNG";
                guestInfo.innerHTML = '<span class="text-muted"><i class="bi bi-door-open me-1"></i> Phòng sẵn sàng</span>';
                footer.innerHTML = '<button type="button" class="btn btn-sm btn-outline-success w-100 fw-bold" onclick="openWalkInForRoom(' + r.id + ', \'' + r.code + '\')"><i class="bi bi-plus-circle me-1"></i> Tạo đặt phòng</button>';
            }
        });
    }

    // ==================== 2. TIMELINE VIEW ENGINE ====================
    let timelineStartDate = new Date();
    timelineStartDate.setHours(0, 0, 0, 0);

    function formatDateYYYYMMDD(d) {
        const y = d.getFullYear();
        const m = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return y + '-' + m + '-' + day;
    }

    function renderTimeline() {
        const headerRow = document.getElementById("timelineHeaderRow");
        const tbody = document.getElementById("timelineBody");
        const rangeText = document.getElementById("timelineRangeText");

        if (!headerRow || !tbody) return;

        // Generate 14 days
        const daysCount = 14;
        const days = [];
        for (let i = 0; i < daysCount; i++) {
            const cur = new Date(timelineStartDate);
            cur.setDate(cur.getDate() + i);
            days.push(cur);
        }

        // Update range text
        const first = days[0];
        const last = days[daysCount - 1];
        rangeText.innerText = first.getDate() + '/' + (first.getMonth() + 1) + '/' + first.getFullYear() + ' – ' + last.getDate() + '/' + (last.getMonth() + 1) + '/' + last.getFullYear();

        // Render Header
        headerRow.innerHTML = '<th class="timeline-cell-room">Phòng</th>';
        days.forEach(d => {
            const dateStr = formatDateYYYYMMDD(d);
            const isToday = (dateStr === todayStr);
            const th = document.createElement("th");
            th.className = "timeline-header-day" + (isToday ? " today" : "");
            th.innerHTML = '<div class="small">' + (d.getDate() + '/' + (d.getMonth() + 1)) + '</div><div class="text-xs text-muted" style="font-size: 10px;">' + (isToday ? 'Hôm nay' : 'T' + (d.getDay() === 0 ? 'CN' : d.getDay() + 1)) + '</div>';
            headerRow.appendChild(th);
        });

        // Render Rows for each room
        tbody.innerHTML = '';
        roomsList.forEach(r => {
            const tr = document.createElement("tr");

            // Cột Tên phòng
            const tdRoom = document.createElement("td");
            tdRoom.className = "timeline-cell-room";
            tdRoom.innerHTML = '<div class="text-dark">' + r.code + '</div><div class="text-muted text-xs" style="font-size: 11px;">' + r.typeName + '</div>';
            tr.appendChild(tdRoom);

            // Cột bao trùm 14 ngày (relative container)
            const tdDaysContainer = document.createElement("td");
            tdDaysContainer.colSpan = daysCount;
            tdDaysContainer.className = "p-0 position-relative";
            tdDaysContainer.style.height = "52px";

            // Sub-grid chứa 14 ô ngày
            const subGrid = document.createElement("div");
            subGrid.className = "d-flex h-100 w-100";

            days.forEach(d => {
                const dateStr = formatDateYYYYMMDD(d);
                const isToday = (dateStr === todayStr);
                const dayCell = document.createElement("div");
                dayCell.className = "flex-fill timeline-cell-day" + (isToday ? " today" : "");
                dayCell.title = "Bấm để đặt phòng " + r.code + " ngày " + dateStr;
                dayCell.onclick = () => {
                    const nextDay = new Date(d);
                    nextDay.setDate(nextDay.getDate() + 1);
                    openWalkInWithDates(r.id, r.code, dateStr, formatDateYYYYMMDD(nextDay));
                };
                subGrid.appendChild(dayCell);
            });
            tdDaysContainer.appendChild(subGrid);

            // Vẽ các thanh booking nằm vắt qua các ngày của phòng này
            const roomBookings = bookingsList.filter(b => {
                if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                return b.status !== 'cancelled' && b.status !== 'checkedout';
            });

            const startTimelineMs = days[0].getTime();
            const oneDayMs = 24 * 60 * 60 * 1000;

            roomBookings.forEach(b => {
                const bIn = new Date(b.checkIn).getTime();
                const bOut = new Date(b.checkOut).getTime();

                const dayOffsetIn = Math.round((bIn - startTimelineMs) / oneDayMs);
                const dayOffsetOut = Math.round((bOut - startTimelineMs) / oneDayMs);

                if (dayOffsetOut <= 0 || dayOffsetIn >= daysCount) return; // Nằm ngoài phạm vi 14 ngày

                const startCol = Math.max(0, dayOffsetIn);
                const endCol = Math.min(daysCount, dayOffsetOut);
                const durationCols = endCol - startCol;

                const leftPercent = (startCol / daysCount) * 100;
                const widthPercent = (durationCols / daysCount) * 100;

                const isStaying = (b.status === 'checkedin');
                const bgClass = isStaying ? 'bg-status-staying' : 'bg-status-coming';

                const bar = document.createElement("div");
                bar.className = "timeline-booking-bar " + bgClass;
                bar.style.left = leftPercent + "%";
                bar.style.width = widthPercent + "%";
                bar.innerHTML = '<span class="truncate">' + b.code + ' · ' + b.guestName + '</span>';
                bar.title = b.code + " - " + b.guestName + " (" + b.checkIn + " → " + b.checkOut + ")";
                bar.onclick = (e) => {
                    e.stopPropagation();
                    showBookingDetailById(b.id);
                };

                tdDaysContainer.appendChild(bar);
            });

            tr.appendChild(tdDaysContainer);
            tbody.appendChild(tr);
        });
    }

    function shiftTimeline(deltaDays) {
        timelineStartDate.setDate(timelineStartDate.getDate() + deltaDays);
        renderTimeline();
    }

    function resetTimelineToToday() {
        timelineStartDate = new Date();
        timelineStartDate.setHours(0, 0, 0, 0);
        renderTimeline();
    }

    // ==================== 3. MODAL CHI TIẾT ĐẶT PHÒNG ====================
    function showBookingDetailById(bookingId) {
        const b = bookingsList.find(x => x.id === bookingId);
        if (!b) return;

        document.getElementById("detailBookingCode").innerText = b.code;
        document.getElementById("detailRoomCode").innerText = b.roomCode || b.roomId || "Chưa gán";
        document.getElementById("detailRoomType").innerText = b.roomTypeName;
        document.getElementById("detailGuestName").innerText = b.guestName;
        document.getElementById("detailGuestPhone").innerText = b.guestPhone;

        // Email & Address
        if (b.guestEmail && b.guestEmail.trim() !== '') {
            document.getElementById("detailEmailWrapper").style.display = '';
            document.getElementById("detailGuestEmail").innerText = b.guestEmail;
        } else {
            document.getElementById("detailEmailWrapper").style.display = 'none';
        }

        if (b.address && b.address.trim() !== '') {
            document.getElementById("detailAddressWrapper").style.display = '';
            document.getElementById("detailGuestAddress").innerText = b.address;
        } else {
            document.getElementById("detailAddressWrapper").style.display = 'none';
        }

        document.getElementById("detailCheckIn").innerText = b.checkIn;
        document.getElementById("detailCheckOut").innerText = b.checkOut;
        document.getElementById("detailTotalPrice").innerText = b.formattedTotal;
        document.getElementById("detailPayMethod").innerText = (b.payMethod === 'transfer' ? 'Chuyển khoản' : 'Tiền mặt');
        document.getElementById("detailPayStatus").innerText = (b.payStatus === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán');
        document.getElementById("detailPayStatus").className = (b.payStatus === 'paid' ? 'fw-bold text-success' : 'fw-bold text-danger');

        // Ghi chú
        if (b.note && b.note.trim() !== '') {
            document.getElementById("detailNoteWrapper").style.display = '';
            document.getElementById("detailNote").innerText = b.note;
        } else {
            document.getElementById("detailNoteWrapper").style.display = 'none';
        }

        // Trạng thái Badge
        const badge = document.getElementById("detailStatusBadge");
        if (b.status === 'checkedin') {
            badge.className = "badge bg-status-staying";
            badge.innerText = "ĐANG Ở";
        } else if (b.status === 'checkedout') {
            badge.className = "badge bg-secondary";
            badge.innerText = "ĐÃ TRẢ PHÒNG";
        } else if (b.status === 'cancelled') {
            badge.className = "badge bg-dark";
            badge.innerText = "ĐÃ HỦY";
        } else {
            badge.className = "badge bg-status-coming";
            badge.innerText = "ĐÃ XÁC NHẬN";
        }

        // So sánh ngày nhận phòng với ngày hôm nay: today >= checkIn
        const canCheckIn = (todayStr >= b.checkIn);
        const warnBox = document.getElementById("checkInDateWarning");
        if (!canCheckIn && b.status !== 'checkedin' && b.status !== 'checkedout' && b.status !== 'cancelled') {
            warnBox.classList.remove('d-none');
            document.getElementById("warnCheckInDate").innerText = b.checkIn;
        } else {
            warnBox.classList.add('d-none');
        }

        // Các nút hành động nghiệp vụ
        const footer = document.getElementById("detailActionFooter");
        footer.innerHTML = '';

        if (b.status === 'pending' || b.status === 'confirmed') {
            // Nút Nhận phòng: khi đã đến ngày nhận phòng thì mới cho nhấn, chưa đến thì disabled
            const checkInBtnHtml = `
                <form action="${pageContext.request.contextPath}/reception" method="POST" class="flex-fill">
                    <input type="hidden" name="action" value="checkIn">
                    <input type="hidden" name="bookingId" value="` + b.id + `">
                    <input type="hidden" name="view" value="${view}">
                    <button type="submit" class="btn btn-warning w-100 fw-bold shadow-sm" ` + (!canCheckIn ? 'disabled title="Chưa đến ngày nhận phòng"' : '') + `>
                        <i class="bi bi-check-circle-fill me-1"></i> Nhận phòng
                    </button>
                </form>
            `;

            // Nút Hủy đặt
            const cancelBtnHtml = `
                <form action="${pageContext.request.contextPath}/reception" method="POST" class="flex-fill" onsubmit="return confirm('Xác nhận hủy đơn đặt phòng này?');">
                    <input type="hidden" name="action" value="cancelBooking">
                    <input type="hidden" name="bookingId" value="` + b.id + `">
                    <input type="hidden" name="view" value="${view}">
                    <button type="submit" class="btn btn-outline-danger w-100 fw-bold">
                        <i class="bi bi-x-circle-fill me-1"></i> Hủy đặt
                    </button>
                </form>
            `;

            footer.innerHTML = checkInBtnHtml + cancelBtnHtml;

        } else if (b.status === 'checkedin') {
            // Nút Trả phòng & Thanh toán
            footer.innerHTML = `
                <form action="${pageContext.request.contextPath}/reception" method="POST" class="w-100" onsubmit="return confirm('Xác nhận trả phòng và thu tiền hoàn tất?');">
                    <input type="hidden" name="action" value="checkOut">
                    <input type="hidden" name="bookingId" value="` + b.id + `">
                    <input type="hidden" name="view" value="${view}">
                    <button type="submit" class="btn btn-success w-100 fw-bold py-2 shadow-sm">
                        <i class="bi bi-box-arrow-right me-1"></i> Trả phòng & Thanh toán
                    </button>
                </form>
            `;
        } else {
            footer.innerHTML = '<button type="button" class="btn btn-light rounded-pill px-4 ms-auto" data-bs-dismiss="modal">Đóng</button>';
        }

        new bootstrap.Modal(document.getElementById("bookingDetailModal")).show();
    }

    // ==================== 4. MODAL ĐẶT PHÒNG TRỰC TIẾP (WALK-IN) ====================
    function openWalkInModal() {
        // Thiết lập mặc định
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);

        document.getElementById("walkInCheckIn").value = todayStr;
        document.getElementById("walkInCheckOut").value = formatDateYYYYMMDD(tomorrow);
        document.getElementById("walkInCheckIn").min = todayStr;
        document.getElementById("walkInCheckOut").min = todayStr;

        calculateWalkInPrice();
        validateWalkInDates();

        new bootstrap.Modal(document.getElementById("walkInModal")).show();
    }

    function openWalkInForRoom(roomId, roomCode) {
        openWalkInModal();
        document.getElementById("walkInRoomSelect").value = roomId;
        calculateWalkInPrice();
        validateWalkInDates();
    }

    function openWalkInWithDates(roomId, roomCode, checkIn, checkOut) {
        openWalkInModal();
        document.getElementById("walkInRoomSelect").value = roomId;
        document.getElementById("walkInCheckIn").value = checkIn;
        document.getElementById("walkInCheckOut").value = checkOut;
        calculateWalkInPrice();
        validateWalkInDates();
    }

    function calculateWalkInPrice() {
        const roomSelect = document.getElementById("walkInRoomSelect");
        const selectedOpt = roomSelect.options[roomSelect.selectedIndex];
        const price = parseFloat(selectedOpt.getAttribute("data-price")) || 0;

        const checkInVal = document.getElementById("walkInCheckIn").value;
        const checkOutVal = document.getElementById("walkInCheckOut").value;

        let nights = 1;
        if (checkInVal && checkOutVal) {
            const d1 = new Date(checkInVal);
            const d2 = new Date(checkOutVal);
            const diffTime = d2.getTime() - d1.getTime();
            nights = Math.max(1, Math.round(diffTime / (1000 * 60 * 60 * 24)));
        }

        const total = price * nights;

        document.getElementById("walkInUnitPriceText").innerText = new Intl.NumberFormat('vi-VN').format(price) + ' VNĐ';
        document.getElementById("walkInNightsText").innerText = nights + ' Ngày';
        document.getElementById("walkInTotalPriceText").innerText = new Intl.NumberFormat('vi-VN').format(total) + ' VNĐ';
    }

    function validateWalkInDates() {
        const checkInInput = document.getElementById("walkInCheckIn");
        const checkOutInput = document.getElementById("walkInCheckOut");
        const checkInVal = checkInInput.value;
        const checkOutVal = checkOutInput.value;
        const roomSelect = document.getElementById("walkInRoomSelect");
        const roomId = parseInt(roomSelect.value);

        const conflictAlert = document.getElementById("conflictAlert");
        const conflictMsg = document.getElementById("conflictAlertMsg");
        const submitBtn = document.getElementById("btnSubmitWalkIn");

        calculateWalkInPrice();

        if (!checkInVal || !checkOutVal) return;

        // Kiểm tra ngày trả phải sau ngày nhận
        if (checkOutVal <= checkInVal) {
            conflictAlert.classList.remove('d-none');
            conflictMsg.innerText = "Ngày trả phòng phải sau ngày nhận phòng!";
            submitBtn.disabled = true;
            return;
        }

        // Kiểm tra xem phòng có bị trùng với đơn nào trong bookingsList không
        const hasConflict = bookingsList.some(b => {
            if (b.roomId !== roomId) return false;
            if (b.status === 'cancelled' || b.status === 'checkedout') return false;
            return (b.checkIn < checkOutVal && b.checkOut > checkInVal);
        });

        if (hasConflict) {
            conflictAlert.classList.remove('d-none');
            conflictMsg.innerText = "Phòng đã có khách đặt trong khoảng thời gian này! Vui lòng chọn ngày hoặc phòng khác.";
            submitBtn.disabled = true;
        } else {
            conflictAlert.classList.add('d-none');
            submitBtn.disabled = false;
        }
    }

    // ==================== 5. TABLE SEARCH & PAGINATION ====================
    function filterReceptionBookings() {
        const keyword = document.getElementById('receptionSearchInput').value.trim().toLowerCase();
        const rows = document.querySelectorAll('.reception-booking-row');
        rows.forEach(r => {
            const code = r.getAttribute('data-code') || '';
            const name = r.getAttribute('data-name') || '';
            if (code.includes(keyword) || name.includes(keyword)) {
                r.style.display = '';
            } else {
                r.style.display = 'none';
            }
        });
    }

    function setupPagination(rowClass, infoId, buttonsId, itemsPerPage, itemName) {
        const rows = Array.from(document.querySelectorAll('.' + rowClass));
        const totalItems = rows.length;
        if (totalItems === 0) return;

        let currentPage = 1;
        const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

        function render() {
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;

            rows.forEach((row, index) => {
                if (index >= start && index < end) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            const infoElem = document.getElementById(infoId);
            if (infoElem) {
                const startItem = totalItems === 0 ? 0 : start + 1;
                const endItem = Math.min(end, totalItems);
                infoElem.innerText = `Hiển thị ` + startItem + ` - ` + endItem + ` trong tổng số ` + totalItems + ` ` + itemName;
            }

            const btnContainer = document.getElementById(buttonsId);
            if (!btnContainer) return;

            btnContainer.innerHTML = '';
            if (totalPages <= 1) return;

            // Prev
            const prevBtn = document.createElement('button');
            prevBtn.type = 'button';
            prevBtn.className = 'page-num-btn';
            prevBtn.innerHTML = '<i class="bi bi-chevron-left"></i>';
            prevBtn.disabled = (currentPage === 1);
            prevBtn.onclick = () => { currentPage--; render(); };
            btnContainer.appendChild(prevBtn);

            // Pages
            for (let i = 1; i <= totalPages; i++) {
                const pBtn = document.createElement('button');
                pBtn.type = 'button';
                pBtn.className = 'page-num-btn ' + (currentPage === i ? 'active' : '');
                pBtn.innerText = i;
                pBtn.onclick = () => { currentPage = i; render(); };
                btnContainer.appendChild(pBtn);
            }

            // Next
            const nextBtn = document.createElement('button');
            nextBtn.type = 'button';
            nextBtn.className = 'page-num-btn';
            nextBtn.innerHTML = '<i class="bi bi-chevron-right"></i>';
            nextBtn.disabled = (currentPage === totalPages);
            nextBtn.onclick = () => { currentPage++; render(); };
            btnContainer.appendChild(nextBtn);
        }

        render();
    }

    // ==================== INITIALIZATION ====================
    document.addEventListener('DOMContentLoaded', () => {
        populateGridView();
        renderTimeline();
        setupPagination('reception-booking-row', 'receptionPaginationInfo', 'receptionPaginationButtons', 10, 'đơn');
    });
</script>
