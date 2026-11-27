<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Client-Side Scripts (Pagination, Duplicate Check, Chart.js) -->
<script>
    // Danh sách phòng hiện có để check trùng lặp mã phòng
    const existingRoomCodes = [
        <c:forEach var="r" items="${rooms}" varStatus="loop">
            "${r.code.toUpperCase()}"${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    // Xem trước ảnh khi người dùng chọn file
    function previewUploadImage(input, previewId) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById(previewId).src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Mở Modal Sửa Phòng
    function openEditRoomModal(id, code, roomTypeId, area, status) {
        document.getElementById('editRoomId').value = id;
        document.getElementById('editRoomCode').value = code;
        document.getElementById('editRoomTypeId').value = roomTypeId;
        document.getElementById('editRoomArea').value = area;
        document.getElementById('editRoomStatus').value = status;
        new bootstrap.Modal(document.getElementById('editRoomModal')).show();
    }

    // Mở Modal Sửa Loại Phòng
    function openEditRoomTypeModal(id, name, price, capacity, bed, desc, image) {
        document.getElementById('editTypeId').value = id;
        document.getElementById('editTypeName').value = name;
        document.getElementById('editTypePrice').value = price;
        document.getElementById('editTypeCapacity').value = capacity;
        document.getElementById('editTypeBed').value = bed;
        document.getElementById('editTypeDescription').value = desc || '';
        document.getElementById('editTypeOldImage').value = image || '';
        document.getElementById('editTypeImagePreview').src = image || 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000';
        new bootstrap.Modal(document.getElementById('editRoomTypeModal')).show();
    }

    // Kiểm tra trùng mã phòng khi submit thêm phòng
    const formAddRoom = document.getElementById('formAddRoom');
    if (formAddRoom) {
        formAddRoom.addEventListener('submit', function(e) {
            const codeInput = document.getElementById('addRoomCode');
            const val = codeInput.value.trim().toUpperCase();
            if (existingRoomCodes.includes(val)) {
                e.preventDefault();
                codeInput.classList.add('is-invalid');
            } else {
                codeInput.classList.remove('is-invalid');
            }
        });
    }

    // ==================== GENERIC PAGINATION FUNCTION ====================
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

            // Update info text
            const infoElem = document.getElementById(infoId);
            if (infoElem) {
                const startItem = totalItems === 0 ? 0 : start + 1;
                const endItem = Math.min(end, totalItems);
                infoElem.innerText = `Hiển thị ` + startItem + ` - ` + endItem + ` trong tổng số ` + totalItems + ` ` + itemName;
            }

            // Update buttons
            const btnContainer = document.getElementById(buttonsId);
            if (!btnContainer) return;

            btnContainer.innerHTML = '';
            if (totalPages <= 1) return;

            // Prev button
            const prevBtn = document.createElement('button');
            prevBtn.type = 'button';
            prevBtn.className = 'page-num-btn';
            prevBtn.innerHTML = '<i class="bi bi-chevron-left"></i>';
            prevBtn.disabled = (currentPage === 1);
            prevBtn.onclick = () => { currentPage--; render(); };
            btnContainer.appendChild(prevBtn);

            // Page numbers
            for (let i = 1; i <= totalPages; i++) {
                const pBtn = document.createElement('button');
                pBtn.type = 'button';
                pBtn.className = 'page-num-btn ' + (currentPage === i ? 'active' : '');
                pBtn.innerText = i;
                pBtn.onclick = () => { currentPage = i; render(); };
                btnContainer.appendChild(pBtn);
            }

            // Next button
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

    // Setup Pagination for each tab
    document.addEventListener('DOMContentLoaded', () => {
        setupPagination('room-row', 'roomPaginationInfo', 'roomPaginationButtons', 5, 'phòng');
        setupPagination('type-row', 'typePaginationInfo', 'typePaginationButtons', 5, 'loại phòng');
        setupPagination('customer-row', 'customerPaginationInfo', 'customerPaginationButtons', 10, 'khách hàng');
        setupPagination('booking-row', 'bookingPaginationInfo', 'bookingPaginationButtons', 10, 'đơn');
    });

    // ==================== SEARCH BOOKINGS ====================
    function filterBookings() {
        const keyword = document.getElementById('bookingSearchInput').value.trim().toLowerCase();
        const rows = document.querySelectorAll('.booking-row');
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

    // ==================== TAB 5: STATS CHART ENGINE ====================
    const allBookings = [
        <c:forEach var="b" items="${bookings}" varStatus="loop">
        {
            id: ${b.id},
            code: "${b.code}",
            guestName: "${b.guestName}",
            total: ${b.totalPrice},
            status: "${b.status}",
            payStatus: "${b.payStatus}",
            checkIn: "${b.checkIn}",
            checkOut: "${b.checkOut}",
            created: "${b.createdAt}"
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    let revenueChart = null;

    function updateStatsChart() {
        const modeSelect = document.getElementById('statModeSelect');
        if (!modeSelect) return;

        const mode = modeSelect.value;
        const monthSelect = document.getElementById('statMonthSelect');
        const yearSelect = document.getElementById('statYearSelect');

        const selectedMonth = parseInt(monthSelect.value);
        const selectedYear = parseInt(yearSelect.value);

        // Ẩn/hiện dropdown tháng theo mode
        if (mode === 'month') {
            monthSelect.style.display = 'inline-block';
        } else {
            monthSelect.style.display = 'none';
        }

        // Chỉ tính các đơn đã hoàn tất trả phòng (checkedout)
        const checkedOutBookings = allBookings.filter(b => b.status === 'checkedout' && b.checkOut);

        let totalRev = 0;
        let compCount = 0;
        let labels = [];
        let chartValues = [];

        if (mode === 'month') {
            // Theo ngày trong tháng
            const daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate();
            const dayMap = {};
            for (let d = 1; d <= daysInMonth; d++) {
                dayMap[d] = 0;
            }

            checkedOutBookings.forEach(b => {
                const d = new Date(b.checkOut);
                if (d.getFullYear() === selectedYear && (d.getMonth() + 1) === selectedMonth) {
                    const day = d.getDate();
                    const amount = Number(b.total) || 0;
                    dayMap[day] = (dayMap[day] || 0) + amount;
                    totalRev += amount;
                    compCount++;
                }
            });

            labels = Object.keys(dayMap).map(d => d + '/' + selectedMonth);
            chartValues = Object.values(dayMap);

            document.getElementById('statRevenueLabel').innerText = 'Doanh thu T' + selectedMonth + '/' + selectedYear;
            document.getElementById('statChartTitle').innerText = 'Chi tiết doanh thu Tháng ' + selectedMonth + '/' + selectedYear + ' (Đơn vị: VNĐ)';
        } else {
            // Theo 12 tháng trong năm
            const monthMap = {};
            for (let m = 1; m <= 12; m++) {
                monthMap[m] = 0;
            }

            checkedOutBookings.forEach(b => {
                const d = new Date(b.checkOut);
                if (d.getFullYear() === selectedYear) {
                    const m = d.getMonth() + 1;
                    const amount = Number(b.total) || 0;
                    monthMap[m] = (monthMap[m] || 0) + amount;
                    totalRev += amount;
                    compCount++;
                }
            });

            labels = Object.keys(monthMap).map(m => 'Thg ' + m);
            chartValues = Object.values(monthMap);

            document.getElementById('statRevenueLabel').innerText = 'Doanh thu năm ' + selectedYear;
            document.getElementById('statChartTitle').innerText = 'Doanh thu 12 tháng năm ' + selectedYear + ' (Đơn vị: VNĐ)';
        }

        // Cập nhật 2 Cards thống kê
        document.getElementById('statRevenueValue').innerText = new Intl.NumberFormat('vi-VN').format(totalRev) + ' VNĐ';
        document.getElementById('statCompletedCount').innerText = compCount;

        // Render Chart.js
        const ctx = document.getElementById('revenueBarChart');
        if (!ctx) return;

        if (revenueChart) {
            revenueChart.destroy();
        }

        revenueChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: chartValues,
                    backgroundColor: '#10b981',
                    hoverBackgroundColor: '#059669',
                    borderRadius: 6,
                    maxBarThickness: 36
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.raw) + ' VNĐ';
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                if (value >= 1000000) return (value / 1000000) + 'M';
                                if (value >= 1000) return (value / 1000) + 'k';
                                return value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Tự khởi chạy biểu đồ nếu đang ở Tab stats
    document.addEventListener('DOMContentLoaded', () => {
        const now = new Date();
        const currentMonth = now.getMonth() + 1;
        const monthSelect = document.getElementById('statMonthSelect');
        if (monthSelect) {
            monthSelect.value = currentMonth;
        }
        updateStatsChart();
    });
</script>
