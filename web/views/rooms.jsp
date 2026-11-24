<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<style>
    .rooms-page-wrapper {
        background-color: #f8fafc;
        min-height: calc(100vh - 120px);
    }
    .filter-search-box {
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        border: 1px solid #eef2f6;
    }
    .room-card-box {
        background: #ffffff;
        border-radius: 20px;
        border: 1px solid #eef2f6;
        transition: all 0.25s ease-in-out;
        overflow: hidden;
    }
    .room-card-box:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
    }
    .room-img-container {
        position: relative;
        width: 100%;
        height: 240px;
    }
    .room-img-container img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .room-code-tag {
        position: absolute;
        top: 14px;
        left: 14px;
        background: rgba(255, 255, 255, 0.95);
        color: #0f172a;
        font-weight: 700;
        font-size: 0.8rem;
        padding: 4px 10px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .btn-search-room {
        background: #0d8abc;
        color: #ffffff;
        font-weight: 600;
        border: none;
        border-radius: 12px;
        padding: 10px 24px;
        transition: all 0.2s;
    }
    .btn-search-room:hover {
        background: #09739d;
        color: #ffffff;
    }
    .btn-detail-room {
        background: #0d8abc;
        color: #ffffff;
        font-weight: 600;
        border: none;
        border-radius: 12px;
        padding: 10px 24px;
        transition: all 0.2s;
    }
    .btn-detail-room:hover {
        background: #09739d;
        color: #ffffff;
    }
    .tag-facility {
        background: #f0f9ff;
        color: #0284c7;
        font-size: 0.8rem;
        padding: 4px 10px;
        border-radius: 8px;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 4px;
    }
</style>

<div class="rooms-page-wrapper py-5">
    <div class="container" style="max-width: 1100px;">
        <!-- TIÊU ĐỀ CHÍNH -->
        <div class="text-center mb-4">
            <h2 class="fw-bold text-dark mb-2">Danh Sách Loại Phòng</h2>
            <p class="text-muted small">Tìm kiếm không gian nghỉ dưỡng lý tưởng phù hợp với lịch trình của bạn</p>
        </div>

        <!-- THANH TÌM KIẾM THEO NGÀY VÀ SỨC CHỨA -->
        <div class="filter-search-box p-3 p-md-4 mb-5">
            <form action="${pageContext.request.contextPath}/rooms" method="GET" class="row g-3 align-items-center">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-calendar-event text-primary me-1"></i> Ngày nhận
                    </label>
                    <input type="date" id="searchCheckIn" name="checkIn" class="form-control rounded-3" 
                           value="${checkIn}" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-calendar-check text-primary me-1"></i> Ngày trả
                    </label>
                    <input type="date" id="searchCheckOut" name="checkOut" class="form-control rounded-3" 
                           value="${checkOut}" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-secondary mb-1">
                        <i class="bi bi-people text-primary me-1"></i> Sức chứa
                    </label>
                    <input type="number" name="guests" class="form-control rounded-3" min="1" max="20" 
                           value="${not empty guests ? guests : 1}" required>
                </div>
                <div class="col-md-3 pt-md-4">
                    <button type="submit" class="btn btn-search-room w-100 d-flex align-items-center justify-content-center gap-2">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>

        <!-- DANH SÁCH LOẠI PHÒNG (DẠNG NGANG THEO REACTJS) -->
        <div class="d-flex flex-column gap-4">
            <c:choose>
                <c:when test="${not empty roomTypes}">
                    <c:forEach var="rt" items="${roomTypes}">
                        <c:set var="availCount" value="${availableMap[rt.id]}" />
                        <div class="room-card-box">
                            <div class="row g-0 align-items-center">
                                <div class="col-md-4">
                                    <div class="room-img-container">
                                        <img src="${rt.image}" alt="${rt.name}">
                                    </div>
                                </div>
                                <div class="col-md-8 p-4">
                                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-start mb-2">
                                        <div>
                                            <h4 class="fw-bold text-dark mb-2">${rt.name}</h4>
                                            <div class="text-secondary small mb-3 d-flex align-items-center gap-3">
                                                <span><i class="bi bi-people me-1"></i> ${rt.capacity} người</span>
                                                <span>•</span>
                                                <span><i class="bi bi-door-open me-1"></i> ${rt.bed} giường</span>
                                                <c:if test="${availCount > 0}">
                                                    <span>•</span>
                                                    <span class="text-success fw-bold"><i class="bi bi-check-circle me-1"></i> Còn ${availCount} phòng trống</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="text-md-end mb-3 mb-md-0">
                                            <h3 class="fw-bold mb-0" style="color: #0d8abc;">
                                                <fmt:formatNumber value="${rt.price}" pattern="#,###" />đ
                                            </h3>
                                            <small class="text-muted">/ Đêm</small>
                                        </div>
                                    </div>

                                    <!-- TIỆN ÍCH DẠNG TAGS -->
                                    <div class="d-flex flex-wrap gap-2 mb-4">
                                        <span class="tag-facility"><i class="bi bi-wifi"></i> Wifi</span>
                                        <span class="tag-facility"><i class="bi bi-snow"></i> Điều hòa</span>
                                        <span class="tag-facility"><i class="bi bi-tv"></i> Tivi</span>
                                        <span class="tag-facility"><i class="bi bi-droplet"></i> Nóng lạnh</span>
                                    </div>

                                    <!-- NÚT XEM CHI TIẾT -->
                                    <div class="text-end">
                                        <a href="${pageContext.request.contextPath}/room-detail?id=${rt.id}&checkIn=${checkIn}&checkOut=${checkOut}&guests=${guests}" 
                                           class="btn btn-detail-room px-4">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- THÔNG BÁO KHI KHÔNG TÌM THẤY PHÒNG THỎA MÃN -->
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
                        <div class="mb-3">
                            <i class="bi bi-calendar-x text-muted" style="font-size: 3.5rem;"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-2">Không tìm thấy phòng phù hợp</h4>
                        <p class="text-secondary small mb-4 mx-auto" style="max-width: 500px;">
                            Rất tiếc, hiện tại không có loại phòng nào trống đáp ứng đủ sức chứa <strong>${guests} người</strong> 
                            từ ngày <strong>${checkIn}</strong> đến <strong>${checkOut}</strong>.
                        </p>
                        <div>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-outline-primary rounded-pill px-4">
                                <i class="bi bi-arrow-clockwise me-1"></i> Xem tất cả phòng
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/inc/footer.jsp" />
