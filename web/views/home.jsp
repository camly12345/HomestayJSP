<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main>
    <!-- HERO SECTION -->
    <section class="hero-banner">
        <div class="container">
            <span class="badge bg-warning text-dark fw-bold text-uppercase px-3 py-2 mb-3">Chào mừng đến Huế</span>
            <h1 class="display-3 fw-bolder mb-3">Núi Homestay</h1>
            <p class="lead text-light max-w-xl mx-auto" style="max-width: 600px;">
                Nghỉ dưỡng yên bình giữa thiên nhiên xanh mát, chỉ cách trung tâm cố đô 3,6km.
            </p>
        </div>
    </section>

    <!-- SEARCH BAR OVERLAP -->
    <div class="container">
        <div class="search-overlap-card p-4 mx-auto" style="max-width: 950px; border-radius: 20px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);">
            <form action="${pageContext.request.contextPath}/rooms" method="GET" class="row g-3 align-items-center">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-calendar-event text-success me-1"></i> Ngày nhận
                    </label>
                    <input type="date" name="checkIn" class="form-control rounded-3" required value="${checkIn}">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-calendar-check text-success me-1"></i> Ngày trả
                    </label>
                    <input type="date" name="checkOut" class="form-control rounded-3" required value="${checkOut}">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-people text-success me-1"></i> Sức chứa
                    </label>
                    <input type="number" name="guests" class="form-control rounded-3" min="1" max="20" value="1" required>
                </div>
                <div class="col-md-3 pt-md-4">
                    <button type="submit" class="btn w-100 py-2 fw-bold text-white rounded-3 shadow-sm d-flex align-items-center justify-content-center gap-2" style="background: #10b981; border: none;">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- PHÒNG NỔI BẬT -->
    <section class="container py-5 my-3">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="badge bg-success-subtle text-success fw-bold px-3 py-1 mb-2">Lựa chọn hàng đầu</span>
                <h2 class="fw-bold text-dark mb-1">Phòng nổi bật</h2>
                <p class="text-muted small mb-0">Khám phá không gian lưu trú thoải mái và ấm cúng nhất</p>
            </div>
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-outline-success rounded-pill px-3">
                Xem tất cả phòng <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <c:forEach var="r" items="${featuredRooms}">
                <div class="col-lg-4 col-md-6">
                    <div class="homestay-card h-100 d-flex flex-column">
                        <div class="position-relative">
                            <img src="${r.image}" class="card-img-top" alt="${r.name}" style="height: 240px; object-fit: cover;">
                            <span class="position-absolute top-0 end-0 m-3 badge bg-white text-dark shadow-sm px-3 py-2 fw-bold">
                                ${r.formattedPrice} <small class="text-muted fw-normal">/ đêm</small>
                            </span>
                        </div>
                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                            <h5 class="fw-bold text-dark mb-2">${r.name}</h5>
<!--                            <p class="text-muted small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                ${r.description}
                            </p>-->
                            
                            <div class="d-flex flex-wrap gap-2 py-2 border-top border-bottom my-3 text-secondary small">
                                <span><i class="bi bi-people me-1 text-success"></i> ${r.capacity} khách</span>
                                <span class="mx-1">•</span>
                                <span><i class="bi bi-door-closed me-1 text-success"></i> ${r.formattedBed}</span>
                            </div>

                            <a href="${pageContext.request.contextPath}/room-detail?id=${r.id}" class="btn btn-success-custom w-100">
                                Xem chi tiết & Đặt phòng
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- TIỆN NGHI TỔNG QUAN -->
    <section class="bg-white py-5 border-top border-bottom">
        <div class="container text-center">
            <h3 class="fw-bold text-dark mb-4">Tiện nghi tiêu chuẩn tại Núi Homestay</h3>
            <div class="row g-4 justify-content-center">
                <div class="col-6 col-md-3">
                    <div class="p-3 border rounded-3 bg-light">
                        <i class="bi bi-wifi fs-2 text-success mb-2 d-block"></i>
                        <h6 class="fw-semibold mb-0">Wifi tốc độ cao</h6>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 border rounded-3 bg-light">
                        <i class="bi bi-tv fs-2 text-success mb-2 d-block"></i>
                        <h6 class="fw-semibold mb-0">Smart TV truyền hình</h6>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 border rounded-3 bg-light">
                        <i class="bi bi-snow fs-2 text-success mb-2 d-block"></i>
                        <h6 class="fw-semibold mb-0">Điều hòa hai chiều</h6>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 border rounded-3 bg-light">
                        <i class="bi bi-droplet-half fs-2 text-success mb-2 d-block"></i>
                        <h6 class="fw-semibold mb-0">Nước nóng 24/7</h6>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- VỀ CHÚNG TÔI -->
    <section id="about" class="container py-5 my-4">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <img src="${pageContext.request.contextPath}/images/background.jpg" class="img-fluid rounded-4 shadow-sm w-100" alt="Về Núi Homestay" style="max-height: 420px; object-fit: cover;">
            </div>
            <div class="col-lg-6">
                <span class="badge bg-success-subtle text-success fw-bold px-3 py-1 mb-2">Giới thiệu</span>
                <h2 class="display-6 fw-bold text-dark mb-3">Về chúng tôi</h2>
                <p class="text-secondary leading-relaxed mb-4">
                    Núi Homestay là điểm dừng chân lý tưởng cho những ai yêu thích sự yên tĩnh và gần gũi thiên nhiên. Với hệ thống phòng đầy đủ tiện nghi, cảnh quan xanh mát và vị trí thuận tiện, chúng tôi cam kết mang đến cho bạn kỳ nghỉ trọn vẹn tại Huế.
                </p>
                <div class="d-flex align-items-center gap-3 text-success fw-semibold">
                    <i class="bi bi-geo-alt-fill fs-4"></i>
                    <span>Chỉ cách trung tâm TP. Huế 3,6km</span>
                </div>
            </div>
        </div>
    </section>

    <!-- LIÊN HỆ & BẢN ĐỒ -->
    <section id="contact" class="container py-4 mb-5">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="row g-0">
                <div class="col-lg-4 bg-success bg-gradient text-white p-5 d-flex flex-column justify-content-center">
                    <span class="badge bg-white text-success fw-bold px-3 py-1 mb-3 align-self-start">Liên hệ</span>
                    <h3 class="fw-bold mb-3">Núi Homestay</h3>
                    <p class="small text-white-50 mb-4">Hãy liên hệ với chúng tôi nếu bạn cần tư vấn chọn phòng hoặc hỗ trợ đặt phòng nghỉ dưỡng.</p>
                    <div class="space-y-3">
                        <p class="mb-2"><i class="bi bi-telephone-fill me-2"></i> 035 356 600</p>
                        <p class="mb-2"><i class="bi bi-envelope-fill me-2"></i> Nuihomstay@gmail.com</p>
                        <p class="mb-0"><i class="bi bi-geo-alt-fill me-2"></i> 2 Ngự Bình, An Cựu, TP. Huế</p>
                    </div>
                </div>
                <div class="col-lg-8" style="min-height: 320px;">
                    <iframe title="Google Maps Nui Homestay" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3826.438763543748!2d107.59792107460758!3d16.453306129042545!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3141a16a340ff1fb%3A0xb694d9c639f5f39f!2zMiBOZ-G7sSBCw6xuaCwgdOG7lSA2LCBBbiBD4buxdSwgSHXhur8sIFZp4buHdCBOYW0!5e0!3m2!1svi!2s!4v1786464347463!5m2!1svi!2s" width="100%" height="100%" style="border:0; min-height: 320px;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-cross-origin"></iframe>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/inc/footer.jsp" />
