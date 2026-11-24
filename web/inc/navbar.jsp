<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top py-3">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand d-flex items-center gap-2 text-success" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-tree-fill fs-4 text-success"></i>
            <span class="fs-5 fw-bold text-dark">Núi Homestay</span>
        </a>

        <!-- Mobile toggler -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Nav Items -->
        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-lg-3">
                <li class="nav-item">
                    <a class="nav-link fw-medium text-secondary" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-medium text-secondary" href="${pageContext.request.contextPath}/rooms">Phòng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-medium text-secondary" href="${pageContext.request.contextPath}/home#about">Giới thiệu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-medium text-secondary" href="${pageContext.request.contextPath}/home#contact">Liên hệ</a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary rounded-pill dropdown-toggle d-flex align-items-center gap-2 py-1 px-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5 text-success"></i>
                                <span class="fw-semibold text-dark">${sessionScope.user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2">
                                <li class="px-3 py-1 text-muted small">Vai trò: <strong>${sessionScope.user.role}</strong></li>
                                <li><hr class="dropdown-divider"></li>
                                <c:if test="${sessionScope.user.admin}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin"><i class="bi bi-speedometer2 me-2"></i>Quản trị hệ thống</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.admin || sessionScope.user.receptionist}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reception"><i class="bi bi-calendar-check me-2"></i>Bàn lễ tân</a></li>
                                </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history"><i class="bi bi-clock-history me-2"></i>Lịch sử đặt phòng</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-success-custom btn-sm rounded-pill px-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
