<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-5">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-muted">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/rooms" class="text-decoration-none text-muted">Phòng</a></li>
            <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">${roomType.name}</li>
        </ol>
    </nav>

    <div class="row g-5">
        <!-- Cột trái: Thông tin phòng -->
        <div class="col-lg-8">
            <div class="rounded-4 overflow-hidden shadow-sm mb-4">
                <img src="${roomType.image}" class="img-fluid w-100" style="max-height: 480px; object-fit: cover;" alt="${roomType.name}">
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="fw-bold text-dark mb-0">${roomType.name}</h1>
                <c:if test="${not empty checkIn && not empty checkOut}">
                    <span id="topAvailabilityBadge" class="badge ${availableRooms > 0 ? 'bg-success' : 'bg-danger'} px-3 py-2 fs-6">
                        <c:choose>
                            <c:when test="${availableRooms > 0}">Còn ${availableRooms} phòng trống</c:when>
                            <c:otherwise>Tạm thời hết phòng</c:otherwise>
                        </c:choose>
                    </span>
                </c:if>
            </div>

            <!-- Thuộc tính phòng -->
            <div class="d-flex flex-wrap gap-4 p-3 bg-white rounded-3 border mb-4 text-secondary">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-people fs-5 text-success"></i>
                    <div>
                        <small class="text-muted d-block">Sức chứa</small>
                        <strong class="text-dark">${roomType.capacity} người</strong>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-door-closed fs-5 text-success"></i>
                    <div>
                        <small class="text-muted d-block">Giường ngủ</small>
                        <strong class="text-dark">${roomType.formattedBed}</strong>
                    </div>
                </div>
            </div>

            <!-- Mô tả phòng -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                <h5 class="fw-bold text-dark mb-3">Mô tả không gian</h5>
                <p class="text-secondary leading-relaxed mb-0">${roomType.description}</p>
            </div>

            <!-- Tiện nghi đi kèm (Đã lược bỏ dịch vụ) -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                <h5 class="fw-bold text-dark mb-3">Tiện nghi sẵn có</h5>
                <div class="row g-3 text-secondary">
                    <div class="col-md-4 col-6"><i class="bi bi-wifi text-success me-2"></i> Wifi miễn phí tốc độ cao</div>
                    <div class="col-md-4 col-6"><i class="bi bi-snow text-success me-2"></i> Điều hòa hai chiều</div>
                    <div class="col-md-4 col-6"><i class="bi bi-tv text-success me-2"></i> Smart TV truyền hình</div>
                    <div class="col-md-4 col-6"><i class="bi bi-droplet-half text-success me-2"></i> Máy nước nóng lạnh</div>
                    <div class="col-md-4 col-6"><i class="bi bi-wind text-success me-2"></i> Máy sấy tóc</div>
                    <div class="col-md-4 col-6"><i class="bi bi-cup-hot text-success me-2"></i> Ấm đun nước siêu tốc</div>
                </div>
            </div>

            <!-- Quy định nhận / trả phòng -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h5 class="fw-bold text-dark mb-3">Quy định lưu trú</h5>
                <ul class="text-secondary small mb-0 space-y-2">
                    <li class="mb-1"><i class="bi bi-clock text-success me-2"></i> Nhận phòng (Check-in): từ <strong>14:00</strong></li>
                    <li class="mb-1"><i class="bi bi-clock-history text-success me-2"></i> Trả phòng (Check-out): trước <strong>12:00</strong></li>
                    <li class="mb-1"><i class="bi bi-x-circle text-danger me-2"></i> Không hút thuốc trong phòng nghỉ</li>
                    <li><i class="bi bi-shield-check text-success me-2"></i> Vui lòng xuất trình CCCD/Hộ chiếu khi làm thủ tục nhận phòng</li>
                </ul>
            </div>
        </div>

        <!-- Cột phải: Khung đặt phòng -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 100px;">
                <div class="text-center mb-3">
                    <h5 class="fw-bold text-dark mb-1">Đặt phòng này</h5>
                    <p class="text-muted small">Chọn khoảng thời gian dự định lưu trú của bạn</p>
                </div>

                <form action="${pageContext.request.contextPath}/booking" method="GET">
                    <input type="hidden" name="roomTypeId" value="${roomType.id}">

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">
                                <i class="bi bi-calendar-event text-primary me-1"></i> Ngày nhận
                            </label>
                            <input type="date" id="detailCheckIn" name="checkIn" class="form-control rounded-3" required value="${checkIn}">
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold text-secondary">
                                <i class="bi bi-calendar-check text-primary me-1"></i> Ngày trả
                            </label>
                            <input type="date" id="detailCheckOut" name="checkOut" class="form-control rounded-3" required value="${checkOut}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">
                            <i class="bi bi-door-closed text-primary me-1"></i> Loại phòng
                        </label>
                        <input type="text" class="form-control rounded-3 bg-light text-dark fw-bold" value="${roomType.name}" readonly>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <label class="form-label small fw-semibold text-secondary">
                                <i class="bi bi-people text-primary me-1"></i> Số lượng khách
                            </label>
                            <span class="text-muted small">Tối đa: ${roomType.capacity} khách</span>
                        </div>
                        <input type="number" name="guests" class="form-control rounded-3" min="1" max="${roomType.capacity}" value="${not empty guests ? guests : 2}" required>
                    </div>

                    <!-- Badge trạng thái phòng khả dụng (chỉ hiện khi đã chọn ngày) -->
                    <div id="availabilityAlertBox" class="mb-4">
                        <c:choose>
                            <c:when test="${not empty checkIn && not empty checkOut}">
                                <c:choose>
                                    <c:when test="${availableRooms > 0}">
                                        <div class="alert alert-success border-0 rounded-3 py-2 px-3 d-flex align-items-center gap-2 mb-0 small text-success">
                                            <i class="bi bi-door-open-fill fs-5"></i>
                                            <span>Còn <strong>${availableRooms}</strong> phòng trống khả dụng.</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-danger border-0 rounded-3 py-2 px-3 d-flex align-items-center gap-2 mb-0 small text-danger">
                                            <i class="bi bi-x-circle-fill fs-5"></i>
                                            <span>Tạm hết phòng trong khoảng thời gian này.</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <!-- Khi chưa chọn ngày thì để trống, không hiện sẵn badge -->
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div id="actionButtonBox">
                        <button type="submit" id="btnSubmitBooking" class="btn w-100 py-3 fw-bold rounded-3 text-white shadow-sm" style="background: #0d8abc;">
                            Tiến hành đặt phòng
                        </button>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <small class="text-muted"><i class="bi bi-telephone me-1"></i> Cần hỗ trợ gấp? Gọi <strong>035 356 600</strong></small>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const checkInEl = document.getElementById("detailCheckIn");
        const checkOutEl = document.getElementById("detailCheckOut");
        const alertBox = document.getElementById("availabilityAlertBox");
        const actionBox = document.getElementById("actionButtonBox");
        const topBadge = document.getElementById("topAvailabilityBadge");
        const roomTypeId = "${roomType.id}";

        function checkAvailabilityRealtime() {
            const inDate = checkInEl.value;
            const outDate = checkOutEl.value;
            if (!inDate || !outDate) {
                // Người dùng chưa chọn đủ ngày -> Ẩn thông báo và mở nút
                alertBox.innerHTML = '';
                actionBox.innerHTML = '<button type="submit" id="btnSubmitBooking" class="btn w-100 py-3 fw-bold rounded-3 text-white shadow-sm" style="background: #0d8abc;">Tiến hành đặt phòng</button>';
                return;
            }

            fetch("${pageContext.request.contextPath}/api/check-availability?roomTypeId=" + roomTypeId + "&checkIn=" + inDate + "&checkOut=" + outDate)
                .then(res => res.json())
                .then(data => {
                    if (data && data.success) {
                        const count = data.availableRooms;
                        if (count > 0) {
                            alertBox.innerHTML = '<div class="alert alert-success border-0 rounded-3 py-2 px-3 d-flex align-items-center gap-2 mb-0 small text-success">' +
                                                 '<i class="bi bi-door-open-fill fs-5"></i>' +
                                                 '<span>Còn <strong>' + count + '</strong> phòng trống khả dụng.</span>' +
                                                 '</div>';
                            actionBox.innerHTML = '<button type="submit" id="btnSubmitBooking" class="btn w-100 py-3 fw-bold rounded-3 text-white shadow-sm" style="background: #0d8abc;">' +
                                                  'Tiến hành đặt phòng' +
                                                  '</button>';
                            if (topBadge) {
                                topBadge.className = 'badge bg-success px-3 py-2 fs-6';
                                topBadge.innerText = 'Còn ' + count + ' phòng trống';
                            }
                        } else {
                            alertBox.innerHTML = '<div class="alert alert-danger border-0 rounded-3 py-2 px-3 d-flex align-items-center gap-2 mb-0 small text-danger">' +
                                                 '<i class="bi bi-x-circle-fill fs-5"></i>' +
                                                 '<span>Tạm hết phòng trong khoảng thời gian này.</span>' +
                                                 '</div>';
                            actionBox.innerHTML = '<button type="button" id="btnSubmitBooking" class="btn btn-secondary w-100 py-3 rounded-3" disabled>' +
                                                  'Hết phòng khả dụng' +
                                                  '</button>';
                            if (topBadge) {
                                topBadge.className = 'badge bg-danger px-3 py-2 fs-6';
                                topBadge.innerText = 'Tạm thời hết phòng';
                            }
                        }
                    }
                })
                .catch(err => console.error("Lỗi kiểm tra phòng trống:", err));
        }

        // Tự động kiểm tra ngay khi vừa vào trang và mỗi khi đổi ngày
        checkAvailabilityRealtime();
        checkInEl.addEventListener("change", checkAvailabilityRealtime);
        checkOutEl.addEventListener("change", checkAvailabilityRealtime);
    });
</script>

<jsp:include page="/inc/footer.jsp" />
