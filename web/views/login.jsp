<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-5 d-flex align-items-center justify-content-center" style="min-height: 70vh;">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 450px;">
        <div class="text-center mb-4">
            <i class="bi bi-tree-fill text-success" style="font-size: 2.5rem;"></i>
            <h3 class="fw-bold text-dark mt-2">Đăng Nhập</h3>
            <p class="text-muted small">Chào mừng bạn quay lại với Núi Homestay</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger small py-2 px-3 rounded-3 mb-3">
                <i class="bi bi-exclamation-circle-fill me-1"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Email hoặc Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-person"></i></span>
                    <input type="text" name="account" class="form-control border-start-0" required placeholder="admin@homestay.com" value="${account}">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control border-start-0" required placeholder="••••••••">
                </div>
            </div>

            <button type="submit" class="btn btn-success-custom w-100 py-2 fw-bold">
                Đăng nhập
            </button>
        </form>

        <div class="text-center mt-4 pt-3 border-top small text-muted">
            Chưa có tài khoản? 
            <a href="${pageContext.request.contextPath}/register" class="text-success fw-semibold text-decoration-none">Đăng ký ngay</a>
        </div>
    </div>
</main>

<jsp:include page="/inc/footer.jsp" />
