<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<style>
    .booking-wrapper {
        background-color: #f7fafc;
        min-height: calc(100vh - 120px);
    }
    .booking-card {
        border-radius: 20px;
        border: 1px solid #eef2f6;
        background: #ffffff;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
    }
    .booking-title {
        color: #065f46;
        font-weight: 700;
        font-size: 1.15rem;
    }
    .custom-input {
        border-radius: 12px;
        border: 1.5px solid #e2e8f0;
        padding: 10px 14px;
        font-size: 0.95rem;
        background-color: #fcfdfe;
        transition: all 0.2s;
    }
    .custom-input:focus {
        border-color: #10b981;
        box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
        background-color: #ffffff;
    }
    .custom-input[readonly] {
        background-color: #f8fafc;
        color: #475569;
        cursor: not-allowed;
    }
    .pay-option {
        border: 1.5px solid #e2e8f0;
        border-radius: 14px;
        padding: 14px 18px;
        cursor: pointer;
        transition: all 0.2s;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .pay-option:hover {
        border-color: #10b981;
        background-color: #f0fdf4;
    }
    .pay-option.selected {
        border-color: #10b981;
        background-color: #f0fdf4;
        box-shadow: 0 2px 10px rgba(16, 185, 129, 0.15);
    }
    .pay-option input[type="radio"] {
        width: 18px;
        height: 18px;
        accent-color: #10b981;
    }
    .btn-submit-booking {
        background: #10b981;
        border: none;
        color: #ffffff;
        font-weight: 700;
        border-radius: 14px;
        padding: 12px 20px;
        font-size: 1rem;
        width: 100%;
        transition: all 0.2s;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
    }
    .btn-submit-booking:hover {
        background: #059669;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(16, 185, 129, 0.35);
    }
    .room-badge-pill {
        background: #d1fae5;
        color: #065f46;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.85rem;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    .qr-container-box {
        border: 1.5px solid #a7f3d0;
        background: #f0fdf4;
        border-radius: 18px;
        padding: 24px;
        text-align: center;
        margin-top: 18px;
    }
    .qr-img-wrapper {
        background: #ffffff;
        padding: 14px;
        border-radius: 14px;
        display: inline-block;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    }
    .countdown-pill {
        background: #fef3c7;
        color: #92400e;
        border: 1px solid #fde68a;
        padding: 8px 16px;
        border-radius: 30px;
        font-size: 0.85rem;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
</style>

<div class="booking-wrapper py-4">
    <div class="container" style="max-width: 1100px;">
        <c:if test="${not empty error}">
            <div class="alert alert-danger rounded-4 mb-4 shadow-sm">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
            </div>
        </c:if>

        <form id="bookingForm" action="${pageContext.request.contextPath}/booking" method="POST">
            <input type="hidden" name="roomTypeId" value="${roomType.id}">
            <input type="hidden" name="checkIn" value="${checkIn}">
            <input type="hidden" name="checkOut" value="${checkOut}">
            <input type="hidden" name="guests" value="${guests}">

            <div class="row g-4">
                <!-- CỘT TRÁI: ĐIỀN THÔNG TIN & PHƯƠNG THỨC THANH TOÁN -->
                <div class="col-lg-7">
                    <!-- KHỐI 1: THÔNG TIN KHÁCH HÀNG -->
                    <div class="booking-card p-4 mb-4">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <i class="bi bi-person-lines-fill text-success fs-5"></i>
                            <h5 class="booking-title mb-0">Điền thông tin đặt phòng</h5>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Họ và tên *</label>
                                <input type="text" name="guestName" class="form-control custom-input" required 
                                       placeholder="Họ và tên"
                                       value="${not empty sessionScope.user ? sessionScope.user.name : ''}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Số điện thoại *</label>
                                <input type="tel" name="guestPhone" class="form-control custom-input" required 
                                       placeholder="0901234567"
                                       value="${not empty sessionScope.user ? sessionScope.user.phone : ''}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Email *</label>
                                <input type="email" name="guestEmail" class="form-control custom-input" required 
                                       placeholder="email@example.com"
                                       value="${not empty sessionScope.user ? sessionScope.user.email : ''}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-secondary">Địa chỉ *</label>
                                <input type="text" name="address" class="form-control custom-input" required 
                                       placeholder="Hà Nội, Huế, TP.HCM...">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-secondary">Ghi chú thêm</label>
                                <textarea name="note" class="form-control custom-input" rows="2" 
                                          placeholder="Yêu cầu riêng, giờ dự kiến đến..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- KHỐI 2: PHƯƠNG THỨC THANH TOÁN -->
                    <div class="booking-card p-4">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <i class="bi bi-wallet2 text-success fs-5"></i>
                            <h5 class="booking-title mb-0">Phương thức thanh toán</h5>
                        </div>

                        <!-- Option 1: Tiền mặt -->
                        <label class="pay-option selected" id="optCash">
                            <input type="radio" name="payMethod" value="cash" checked onchange="togglePayment('cash')">
                            <div>
                                <div class="fw-bold text-dark"><i class="bi bi-cash-stack text-success me-2"></i>Thanh toán khi nhận phòng</div>
                            </div>
                        </label>

                        <!-- Option 2: Chuyển khoản QR -->
                        <label class="pay-option" id="optTransfer">
                            <input type="radio" name="payMethod" value="transfer" onchange="togglePayment('transfer')">
                            <div>
                                <div class="fw-bold text-dark"><i class="bi bi-qr-code text-success me-2"></i>Chuyển khoản (100%)</div>
                            </div>
                        </label>

                        <!-- KHUNG HIỂN THỊ MÃ QR KHI CHỌN CHUYỂN KHOẢN -->
                        <div id="qrSection" class="qr-container-box" style="display: none;">
                            <div class="fw-bold text-success mb-2">
                                <i class="bi bi-qr-code-scan me-1"></i> Quét mã QR này để Chuyển khoản
                            </div>
                            
                            <!-- Loading spinner trong lúc chờ gọi PayOS -->
                            <div id="qrLoading" class="py-4">
                                <div class="spinner-border text-success" role="status"></div>
                                <div class="small text-muted mt-2">Đang khởi tạo mã QR thanh toán PayOS...</div>
                            </div>

                            <div id="qrContent" style="display: none;">
                                <div class="qr-img-wrapper mb-3">
                                    <!-- Hiển thị mã QR PayOS trực tiếp qua ảnh -->
                                    <img id="payOsQrImage" src="" alt="Mã QR PayOS" style="max-width: 240px; width: 100%; height: auto; border-radius: 8px;">
                                </div>

                                <div class="bg-white rounded-3 p-3 mb-3 border d-inline-block text-start w-100" style="max-width: 400px;">
                                    <div class="d-flex justify-content-between mb-1 small">
                                        <span class="text-secondary">Mã đơn hàng:</span>
                                        <strong class="text-success font-monospace" id="txtOrderCode">---</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small">
                                        <span class="text-secondary">Số tiền:</span>
                                        <strong class="text-success"><fmt:formatNumber value="${estimatedTotal}" pattern="#,###" /> VNĐ</strong>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <a id="payOsCheckoutLink" href="#" target="_blank" class="btn btn-outline-success btn-sm rounded-pill px-3">
                                        <i class="bi bi-box-arrow-up-right me-1"></i> Mở trang thanh toán PayOS
                                    </a>
                                </div>

                                <div class="countdown-pill">
                                    <i class="bi bi-arrow-repeat spin-icon"></i>
                                    <span>Hệ thống đang chờ giao dịch. <span class="text-danger fw-bold" id="timerText">Vui lòng thanh toán trước 1:00.</span></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: CHI TIẾT ĐẶT PHÒNG (TÓM TẮT ĐƠN) -->
                <div class="col-lg-5">
                    <div class="booking-card p-4 sticky-top" style="top: 90px;">
                        <div class="text-center mb-3">
                            <h5 class="booking-title mb-2">Chi tiết đặt phòng</h5>
                            <c:if test="${not empty availableRoom}">
                                <span class="room-badge-pill">
                                    <i class="bi bi-door-open-fill"></i> Phòng ${availableRoom.code}
                                </span>
                            </c:if>
                        </div>

                        <div class="small text-secondary space-y-2 mb-3">
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Loại phòng</span>
                                <strong class="text-dark">${roomType.name}</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Nhận phòng</span>
                                <strong class="text-dark">${checkIn}</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Trả phòng</span>
                                <strong class="text-dark">${checkOut}</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Thời gian</span>
                                <strong class="text-dark">${nights} Ngày</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Số lượng khách</span>
                                <strong class="text-dark">${guests} người</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Giá phòng / đêm</span>
                                <span class="text-dark"><fmt:formatNumber value="${roomType.price}" pattern="#,###" /> VNĐ</span>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span>Tiền phòng tạm tính</span>
                                <span class="text-dark"><fmt:formatNumber value="${estimatedTotal}" pattern="#,###" /> VNĐ</span>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-2 mb-4">
                            <span class="fw-bold fs-6 text-dark">Tổng thanh toán</span>
                            <span class="fs-4 fw-bold" style="color: #059669;">
                                <fmt:formatNumber value="${estimatedTotal}" pattern="#,###" /> VNĐ
                            </span>
                        </div>

                        <button type="submit" id="btnSubmit" class="btn btn-submit-booking">
                            Xác nhận đặt phòng
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    let checkPaymentInterval = null;
    let secondsLeft = 300; // 5 phút
    let currentBookingCode = "";
    let isCreatingPayOS = false;

    function togglePayment(method) {
        const optCash = document.getElementById('optCash');
        const optTransfer = document.getElementById('optTransfer');
        const qrSection = document.getElementById('qrSection');
        const btnSubmit = document.getElementById('btnSubmit');

        if (method === 'cash') {
            optCash.classList.add('selected');
            optTransfer.classList.remove('selected');
            qrSection.style.display = 'none';
            btnSubmit.innerHTML = 'Xác nhận đặt phòng';
            btnSubmit.disabled = false;
            if (checkPaymentInterval) clearInterval(checkPaymentInterval);
        } else {
            optTransfer.classList.add('selected');
            optCash.classList.remove('selected');
            qrSection.style.display = 'block';
            btnSubmit.innerHTML = 'Quét mã QR để hoàn tất';
            btnSubmit.disabled = true;

            // Kiểm tra validate thông tin trước khi gọi PayOS
            const guestName = document.querySelector('input[name="guestName"]').value;
            const guestPhone = document.querySelector('input[name="guestPhone"]').value;
            const address = document.querySelector('input[name="address"]').value;

            if (!guestName || !guestPhone || !address) {
                alert('Vui lòng điền đầy đủ Họ tên, Số điện thoại và Địa chỉ để tạo mã thanh toán chuyển khoản!');
                document.querySelector('input[name="payMethod"][value="cash"]').checked = true;
                togglePayment('cash');
                return;
            }

            // Gọi API PayOS để lấy chuỗi QR thật từ tài khoản PayOS của bạn
            initPayOSPayment();
        }
    }

    function initPayOSPayment() {
        if (isCreatingPayOS) return;
        isCreatingPayOS = true;

        const qrLoading = document.getElementById('qrLoading');
        const qrContent = document.getElementById('qrContent');
        qrLoading.style.display = 'block';
        qrContent.style.display = 'none';

        const formData = new URLSearchParams();
        formData.append('roomTypeId', '${roomType.id}');
        formData.append('checkIn', '${checkIn}');
        formData.append('checkOut', '${checkOut}');
        formData.append('guests', '${guests}');
        formData.append('guestName', document.querySelector('input[name="guestName"]').value);
        formData.append('guestPhone', document.querySelector('input[name="guestPhone"]').value);
        formData.append('guestEmail', document.querySelector('input[name="guestEmail"]').value);
        formData.append('address', document.querySelector('input[name="address"]').value);
        formData.append('note', document.querySelector('textarea[name="note"]').value);

        fetch('${pageContext.request.contextPath}/api/create-payos-payment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: formData.toString()
        })
        .then(async res => {
            const isJson = res.headers.get('content-type')?.includes('application/json');
            const data = isJson ? await res.json() : null;
            if (!res.ok) {
                const errorMsg = (data && data.message) || 'Mã lỗi HTTP: ' + res.status;
                throw new Error(errorMsg);
            }
            return data;
        })
        .then(data => {
            isCreatingPayOS = false;
            qrLoading.style.display = 'none';

            if (data && data.success && data.qrCode) {
                currentBookingCode = data.bookingCode;
                qrContent.style.display = 'block';

                document.getElementById('txtOrderCode').innerText = data.orderCode;
                document.getElementById('payOsCheckoutLink').href = data.checkoutUrl;

                // Sử dụng API tạo ảnh QR trực tiếp từ chuỗi vietqr của PayOS, không phụ thuộc thư viện JS
                const qrImg = document.getElementById('payOsQrImage');
                qrImg.src = "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=" + encodeURIComponent(data.qrCode);

                // Bắt đầu lắng nghe trạng thái thanh toán tự động
                startPaymentPolling(currentBookingCode, data.orderCode);
            } else {
                alert(data.message || 'Không thể khởi tạo cổng PayOS');
                document.querySelector('input[name="payMethod"][value="cash"]').checked = true;
                togglePayment('cash');
            }
        })
        .catch(err => {
            isCreatingPayOS = false;
            qrLoading.style.display = 'none';
            console.error('Lỗi gọi API PayOS:', err);
            alert('Lỗi tạo cổng thanh toán PayOS: ' + err.message);
            document.querySelector('input[name="payMethod"][value="cash"]').checked = true;
            togglePayment('cash');
        });
    }

    function startPaymentPolling(bookingCode, orderCode) {
        if (checkPaymentInterval) clearInterval(checkPaymentInterval);

        const timerText = document.getElementById('timerText');
        secondsLeft = 60; // 1 phút (60 giây)

        checkPaymentInterval = setInterval(() => {
            secondsLeft--;
            const mins = Math.floor(secondsLeft / 60);
            const secs = secondsLeft % 60;
            timerText.innerText = "Vui lòng thanh toán trước " + mins + ":" + (secs < 10 ? "0" : "") + secs;

            if (secondsLeft <= 0) {
                clearInterval(checkPaymentInterval);
                timerText.innerText = "Mã QR đã hết hạn (quá 1 phút). Đơn đã bị hủy để nhường phòng.";
                
                // Gửi yêu cầu hủy đơn quá hạn và vô hiệu nút
                fetch('${pageContext.request.contextPath}/api/cancel-expired?code=' + bookingCode, { method: 'POST' });
                
                const qrContent = document.getElementById('qrContent');
                if (qrContent) {
                    qrContent.innerHTML = '<div class="alert alert-warning border-0 rounded-3 p-3 my-3 small text-dark">' +
                                          '<i class="bi bi-clock-history me-1 text-danger"></i> ' +
                                          '<strong>Mã QR đã hết hạn thanh toán (quá 1 phút).</strong><br>' +
                                          'Đơn đặt phòng này đã tự động hủy để mở lại phòng cho khách khác. Vui lòng tải lại trang nếu muốn đặt lại.' +
                                          '</div>' +
                                          '<a href="javascript:location.reload()" class="btn btn-success btn-sm rounded-pill px-4 mt-2">Tải lại trang</a>';
                }
                return;
            }

            // Gọi API kiểm tra thanh toán (kết hợp tra cứu trực tiếp từ PayOS)
            fetch('${pageContext.request.contextPath}/api/payment-status?code=' + bookingCode + '&orderCode=' + (orderCode || ''))
                .then(res => res.json())
                .then(data => {
                    if (data && data.isPaid) {
                        clearInterval(checkPaymentInterval);
                        // Chuyển thẳng sang trang booking success
                        window.location.href = '${pageContext.request.contextPath}/success?code=' + bookingCode;
                    }
                })
                .catch(err => console.log('Polling err:', err));
        }, 2000);
    }
</script>

<jsp:include page="/inc/footer.jsp" />
