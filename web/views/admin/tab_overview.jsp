<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<h4 class="fw-bold text-dark mb-3">Công suất phòng hiện tại</h4>
<div class="row g-3 mb-5">
    <div class="col-md-4">
        <div class="admin-stat-card">
            <div class="admin-stat-label">Phòng đang có khách</div>
            <h2 class="admin-stat-value" style="color: #047857;">${occupied}</h2>
        </div>
    </div>
    <div class="col-md-4">
        <div class="admin-stat-card">
            <div class="admin-stat-label">Phòng đang trống</div>
            <h2 class="admin-stat-value text-success">${vacant}</h2>
        </div>
    </div>
    <div class="col-md-4">
        <div class="admin-stat-card">
            <div class="admin-stat-label">Tổng số phòng</div>
            <h2 class="admin-stat-value">${totalRooms}</h2>
        </div>
    </div>
</div>

<h4 class="fw-bold text-dark mb-3">Hoạt động gần đây</h4>
<div class="admin-card">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Khách ở</th>
                    <th>Người đặt</th>
                    <th>Phòng</th>
                    <th>Nhận → Trả</th>
                    <th>Tổng</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${recentBookings}">
                    <tr>
                        <td class="fw-bold text-success">${b.code}</td>
                        <td>
                            <div class="fw-semibold text-dark">${b.guestName}</div>
                            <small class="text-muted">${b.guestPhone}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty b.guestEmail}">${b.guestName}</c:when>
                                <c:otherwise><span class="text-muted small">Khách tự đặt</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="badge bg-light text-dark border font-monospace">${not empty b.roomCode ? b.roomCode : b.roomTypeName}</span></td>
                        <td class="text-nowrap small">${b.checkIn} → ${b.checkOut}</td>
                        <td class="fw-bold text-nowrap">${b.formattedTotal}</td>
                        <td>
                            <c:choose>
                                <c:when test="${b.status == 'checkedin'}"><span class="badge" style="background-color: #059669;">Đang ở</span></c:when>
                                <c:when test="${b.status == 'checkedout'}"><span class="badge bg-secondary">Đã trả phòng</span></c:when>
                                <c:when test="${b.status == 'confirmed'}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
                                <c:when test="${b.status == 'cancelled'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                <c:otherwise><span class="badge bg-warning text-dark">Chờ xác nhận</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bản ghi này?');">
                                <input type="hidden" name="action" value="deleteBooking">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="tab" value="overview">
                                <button type="submit" class="btn btn-link text-danger p-0" title="Xóa đơn"><i class="bi bi-trash fs-5"></i></button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentBookings}">
                    <tr>
                        <td colspan="8" class="text-center py-4 text-muted">Chưa có đơn đặt phòng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
