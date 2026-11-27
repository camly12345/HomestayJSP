<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- ==================== VIEW 3: DANH SÁCH BẢNG (TABLE VIEW) ==================== -->
<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
    <h4 class="fw-bold text-dark mb-0">Tất cả đơn đặt phòng</h4>
    <div class="input-group" style="max-width: 380px;">
        <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
        <input type="text" id="receptionSearchInput" class="form-control border-start-0 ps-0" placeholder="Tìm theo mã booking hoặc tên khách..." onkeyup="filterReceptionBookings()">
    </div>
</div>

<div class="admin-card">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="receptionBookingTable">
            <thead>
                <tr>
                    <th>Mã</th>
                    <th>Khách ở</th>
                    <th>Phòng</th>
                    <th>Nhận → Trả</th>
                    <th>Tổng</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Thao tác</th>
                </tr>
            </thead>
            <tbody id="receptionBookingTableBody">
                <c:forEach var="b" items="${bookings}">
                    <tr class="reception-booking-row" data-code="${b.code.toLowerCase()}" data-name="${b.guestName.toLowerCase()}">
                        <td class="fw-bold text-success">${b.code}</td>
                        <td>
                            <div class="fw-semibold text-dark">${b.guestName}</div>
                            <small class="text-muted">${b.guestPhone}</small>
                        </td>
                        <td><span class="badge bg-light text-dark border font-monospace">${not empty b.roomCode ? b.roomCode : b.roomTypeName}</span></td>
                        <td class="text-nowrap small">${b.checkIn} → ${b.checkOut}</td>
                        <td class="fw-bold text-nowrap">${b.formattedTotal}</td>
                        <td>
                            <c:choose>
                                <c:when test="${b.status == 'checkedin'}"><span class="badge bg-status-staying">Đang ở</span></c:when>
                                <c:when test="${b.status == 'checkedout'}"><span class="badge bg-secondary">Đã trả phòng</span></c:when>
                                <c:when test="${b.status == 'confirmed'}"><span class="badge bg-status-coming">Đã xác nhận</span></c:when>
                                <c:when test="${b.status == 'cancelled'}"><span class="badge bg-dark">Đã hủy</span></c:when>
                                <c:otherwise><span class="badge bg-warning text-dark">Chờ duyệt</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-outline-success rounded-pill px-3 me-1" onclick="showBookingDetailById(${b.id})">
                                Chi tiết
                            </button>
                            <form action="${pageContext.request.contextPath}/reception" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa đơn này?');">
                                <input type="hidden" name="action" value="deleteBooking">
                                <input type="hidden" name="bookingId" value="${b.id}">
                                <input type="hidden" name="view" value="table">
                                <button type="submit" class="btn btn-sm btn-link text-danger p-1" title="Xóa đơn">
                                    <i class="bi bi-trash fs-6"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bookings}">
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">Chưa có đơn đặt phòng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Pagination for Table View -->
    <div class="pagination-container" id="receptionPagination">
        <div class="text-muted small" id="receptionPaginationInfo">Hiển thị 1 - 10 trong tổng số ${bookings.size()} đơn</div>
        <div class="d-flex align-items-center" id="receptionPaginationButtons"></div>
    </div>
</div>
