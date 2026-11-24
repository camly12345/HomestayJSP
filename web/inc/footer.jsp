<%@page contentType="text/html" pageEncoding="UTF-8"%>

<footer class="bg-white border-top mt-5 py-5 text-secondary">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-tree-fill fs-4 text-success"></i>
                    <h5 class="fw-bold text-dark mb-0">Núi Homestay</h5>
                </div>
                <p class="small text-muted leading-relaxed">
                    Homestay yên bình giữa lòng cố đô Huế. Cách trung tâm 3,6km, không gian xanh mát, phòng nghỉ tiện nghi và dịch vụ tận tâm cho kỳ nghỉ trọn vẹn.
                </p>
            </div>

            <div class="col-lg-4 col-md-6">
                <h6 class="fw-bold text-dark mb-3">Kết nối với chúng tôi</h6>
                <ul class="list-unstyled small space-y-2">
                    <li class="mb-2"><i class="bi bi-facebook text-primary me-2"></i>Facebook: <strong>Núi Homestay</strong></li>
                    <li class="mb-2"><i class="bi bi-tiktok text-dark me-2"></i>TikTok: <strong>Nui@123</strong></li>
                    <li class="mb-2"><i class="bi bi-shield-check text-success me-2"></i>Giờ mở cửa: 24/7 luôn sẵn sàng đón khách</li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-12">
                <h6 class="fw-bold text-dark mb-3">Thông tin liên hệ</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><i class="bi bi-telephone-fill text-success me-2"></i>Điện thoại: <strong>035 356 600</strong></li>
                    <li class="mb-2"><i class="bi bi-envelope-fill text-success me-2"></i>Email: <strong>Nuihomstay@gmail.com</strong></li>
                    <li class="mb-2"><i class="bi bi-geo-alt-fill text-success me-2"></i>Địa chỉ: <strong>2 Ngự Bình, An Cựu, TP. Huế</strong></li>
                </ul>
            </div>
        </div>

       
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle -->
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

<!-- SCRIPT TOÀN CỤC ĐỒNG BỘ DATEPICKER (KHÓA NGÀY QUÁ KHỨ & RÀNG BUỘC NGÀY TRẢ >= NGÀY NHẬN) -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Lấy ngày hôm nay theo định dạng YYYY-MM-DD
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const todayStr = year + '-' + month + '-' + day;

        // Tìm tất cả các cặp ô ngày nhận & ngày trả trên trang
        const checkInInputs = document.querySelectorAll('input[type="date"][name="checkIn"], #searchCheckIn, #detailCheckIn');
        const checkOutInputs = document.querySelectorAll('input[type="date"][name="checkOut"], #searchCheckOut, #detailCheckOut');

        checkInInputs.forEach(function (checkInInput, idx) {
            const checkOutInput = checkOutInputs[idx] || document.querySelector('input[type="date"][name="checkOut"]');
            
            // 1. Ô ngày nhận: Ẩn/khóa toàn bộ các ngày trước ngày hôm nay (không tự điền giá trị)
            checkInInput.min = todayStr;

            // 2. Ô ngày trả: Cập nhật min phải từ ngày nhận trở đi (ngày nhận + 1 ngày)
            function syncCheckOut() {
                const currentCheckIn = checkInInput.value;
                if (!currentCheckIn) {
                    // Nếu chưa chọn ngày nhận, ngày trả cũng chỉ cần min từ ngày mai
                    const d = new Date();
                    d.setDate(d.getDate() + 1);
                    const tmrStr = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
                    if (checkOutInput) checkOutInput.min = tmrStr;
                    return;
                }

                const d = new Date(currentCheckIn);
                d.setDate(d.getDate() + 1);
                
                const nextYear = d.getFullYear();
                const nextMonth = String(d.getMonth() + 1).padStart(2, '0');
                const nextDay = String(d.getDate()).padStart(2, '0');
                const nextDayStr = nextYear + '-' + nextMonth + '-' + nextDay;

                if (checkOutInput) {
                    checkOutInput.min = nextDayStr;
                    if (checkOutInput.value && checkOutInput.value <= currentCheckIn) {
                        checkOutInput.value = nextDayStr;
                    }
                }
            }

            // Gọi đồng bộ ràng buộc min khi load trang và khi người dùng thay đổi ngày nhận
            syncCheckOut();
            checkInInput.addEventListener('change', syncCheckOut);
            checkInInput.addEventListener('input', syncCheckOut);
        });
    });
</script>
</body>
</html>
