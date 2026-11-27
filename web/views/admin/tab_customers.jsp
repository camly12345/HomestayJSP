<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<h4 class="fw-bold text-dark mb-3">Danh sách khách hàng</h4>
<div class="admin-card">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="customerTable">
            <thead>
                <tr>
                    <th>Tên khách hàng</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th class="text-end">Thao tác</th>
                </tr>
            </thead>
            <tbody id="customerTableBody">
                <c:forEach var="c" items="${customers}">
                    <tr class="customer-row">
                        <td class="fw-semibold text-dark">${c.name}</td>
                        <td>${c.phone}</td>
                        <td>${c.email}</td>
                        <td class="text-end">
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?');">
                                <input type="hidden" name="action" value="deleteUser">
                                <input type="hidden" name="id" value="${c.id}">
                                <input type="hidden" name="tab" value="customers">
                                <button type="submit" class="btn btn-sm btn-link text-danger p-1" title="Xóa khách hàng">
                                    <i class="bi bi-trash fs-6"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty customers}">
                    <tr>
                        <td colspan="4" class="text-center py-4 text-muted">Chưa có dữ liệu khách hàng.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Client-Side Pagination (10 items / page) -->
    <div class="pagination-container" id="customerPagination">
        <div class="text-muted small" id="customerPaginationInfo">Hiển thị 1 - 10 trong tổng số ${customers.size()} khách hàng</div>
        <div class="d-flex align-items-center" id="customerPaginationButtons"></div>
    </div>
</div>
