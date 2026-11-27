<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<style>
    .success-wrapper {
        background-color: #f7fafc;
        min-height: calc(100vh - 120px);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .success-card {
        border-radius: 24px;
        border: 1px solid #eef2f6;
        background: #ffffff;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        max-width: 680px;
        width: 100%;
        padding: 40px;
    }
    .icon-success-circle {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        background-color: #d1fae5;
        color: #059669;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        margin-bottom: 16px;
    }
    .booking-code-box {
        background: #f8fafc;
        border: 1.5px dashed #cbd5e1;
        border-radius: 16px;
        padding: 14px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }
    .btn-action-primary {
        background: #10b981;
        color: #ffffff;
        border: none;
        border-radius: 12px;
        padding: 10px 24px;
        font-weight: 600;
        transition: all 0.2s;
    }
    .btn-action-primary:hover {
        background: #059669;
        color: #ffffff;
    }
</style>

<div class="success-wrapper py-5">
    <div class="success-card text-center">
        <!-- ICON CHECK -->
        <div class="icon-success-circle">
            <i class="bi bi-check2"></i>
        </div>

        <h3 class="fw-bold text-dark mb-2">Đặt Phòng Thành Công!</h3>
        <p class="text-secondary small mb-4">
            Thông tin đặt phòng của bạn đã được ghi nhận. Vui lòng lưu lại mã đặt phòng bên dưới.
        </p>

        <!-- MÃ ĐẶT PHÒNG & TRẠNG THÁI THANH TOÁN -->
        <div class="booking-code-box">
            <div class="d-flex align-items-center gap-3">
                <div class="bg-white border rounded-3 p-2 text-success fw-bold">#</div>
                <div class="text-start">
                    <span class="text-muted d-block" style="font-size: 0.75rem; text-transform: uppercase;">MÃ ĐẶT PHÒNG</span>
                    <strong class="text-success fs-5">${booking.code}</strong>
                </div>
            </div>
            <div>
                <span class="badge ${booking.payStatus == 'paid' ? 'bg-success' : 'bg-light text-dark border'} px-3 py-2 rounded-pill fw-semibold">
                    <c:choose>
                        <c:when test="${booking.payStatus == 'paid'}">Đã thanh toán (Chuyển khoản)</c:when>
                        <c:otherwise>Thanh toán khi nhận phòng</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <!-- CHI TIẾT 2 CỘT -->
        <div class="row g-4 text-start mb-4">
            <!-- Cột trái: Thông tin khách hàng -->
            <div class="col-md-6 border-end">
                <h6 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-person-fill text-success"></i> Thông tin khách hàng
                </h6>
                <div class="small text-secondary mb-2">
                    <span>Họ và tên:</span>
                    <div class="fw-bold text-dark">${booking.guestName}</div>
                </div>
                <div class="small text-secondary mb-2">
                    <span>Số điện thoại:</span>
                    <div class="fw-bold text-dark">${booking.guestPhone}</div>
                </div>
                <div class="small text-secondary mb-2">
                    <span>Email:</span>
                    <div class="fw-bold text-dark">${not empty booking.guestEmail ? booking.guestEmail : '---'}</div>
                </div>
                <div class="small text-secondary">
                    <span>Địa chỉ:</span>
                    <div class="fw-bold text-dark">${not empty booking.address ? booking.address : '---'}</div>
                </div>
            </div>

            <!-- Cột phải: Chi tiết thanh toán -->
            <div class="col-md-6">
                <h6 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-credit-card-fill text-success"></i> Chi tiết thanh toán
                </h6>
                <div class="small text-secondary mb-2 d-flex justify-content-between">
                    <span>Hình thức:</span>
                    <strong class="text-dark">
                        <c:choose>
                            <c:when test="${booking.payMethod == 'transfer'}">Chuyển khoản</c:when>
                            <c:otherwise>Thanh toán khi nhận phòng</c:otherwise>
                        </c:choose>
                    </strong>
                </div>
                <div class="small text-secondary mb-3 d-flex justify-content-between align-items-center">
                    <span>Tổng tiền:</span>
                    <span class="fs-5 fw-bold" style="color: #059669;">
                        <fmt:formatNumber value="${booking.totalPrice}" pattern="#,###" /> VNĐ
                    </span>
                </div>
                <div class="alert alert-light border small text-muted p-2 rounded-3 mb-0">
                    * Vui lòng xuất trình mã đặt phòng hoặc giấy tờ tùy thân khi làm thủ tục nhận phòng tại Homestay.
                </div>
            </div>
        </div>

        <!-- CHI TIẾT LƯU TRÚ -->
        <div class="bg-light rounded-4 p-3 text-start mb-4">
            <h6 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-calendar-check-fill text-success"></i> Chi tiết lưu trú
            </h6>
            <div class="row g-3 small">
                <div class="col-6 col-sm-3">
                    <span class="text-muted d-block">Tên phòng</span>
                    <strong class="text-dark">${not empty booking.roomCode ? booking.roomCode : 'Chờ gán'}</strong>
                </div>
                <div class="col-6 col-sm-3">
                    <span class="text-muted d-block">Loại phòng</span>
                    <strong class="text-dark">${booking.roomTypeName}</strong>
                </div>
                <div class="col-6 col-sm-3">
                    <span class="text-muted d-block">Ngày nhận</span>
                    <strong class="text-dark">${booking.checkIn}</strong>
                </div>
                <div class="col-6 col-sm-3">
                    <span class="text-muted d-block">Ngày trả</span>
                    <strong class="text-dark">${booking.checkOut}</strong>
                </div>
            </div>
            <div class="border-top mt-3 pt-2 d-flex justify-content-between small">
                <span>Tổng thời gian lưu trú:</span>
                <span class="badge bg-white text-success border fw-bold px-2 py-1">${booking.nights} Ngày</span>
            </div>
        </div>

        <!-- NÚT THAO TÁC -->
        <div class="d-flex justify-content-center">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-action-primary d-flex align-items-center gap-2 px-5 py-2">
                <i class="bi bi-house-door"></i> Về trang chủ
            </a>
        </div>
    </div>
</div>

<jsp:include page="/inc/footer.jsp" />
