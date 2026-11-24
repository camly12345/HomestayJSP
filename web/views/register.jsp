<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-5 d-flex align-items-center justify-content-center" style="min-height: 70vh;">
    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 480px;">
        <div class="text-center mb-4">
            <i class="bi bi-tree-fill text-success" style="font-size: 2.5rem;"></i>
            <h3 class="fw-bold text-dark mt-2">Đăng Ký Tài Khoản</h3>
            <p class="text-muted small">Tạo tài khoản để quản lý đơn đặt phòng thuận tiện hơn</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger small py-2 px-3 rounded-3 mb-3">
                <i class="bi bi-exclamation-circle-fill me-1"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="POST">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Họ và tên</label>
                <input type="text" name="name" class="form-control" required placeholder="Nguyễn Văn A" value="${name}">
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Địa chỉ Email</label>
                <input type="email" name="email" class="form-control" required placeholder="user@gmail.com" value="${email}">
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Số điện thoại</label>
                <input type="tel" name="phone" class="form-control" required placeholder="0912345678" value="${phone}">
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-secondary">Mật khẩu</label>
                <input type="password" name="password" class="form-control" required placeholder="••••••••">
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-secondary">Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" class="form-control" required placeholder="••••••••">
            </div>

            <button type="submit" class="btn btn-success-custom w-100 py-2 fw-bold">
                Tạo tài khoản
            </button>
        </form>

        <div class="text-center mt-4 pt-3 border-top small text-muted">
            Đã có tài khoản? 
            <a href="${pageContext.request.contextPath}/login" class="text-success fw-semibold text-decoration-none">Đăng nhập</a>
        </div>
    </div>
</main>

<jsp:include page="/inc/footer.jsp" />
