<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
    <h4 class="fw-bold text-dark mb-0">Tất cả đơn đặt phòng</h4>
    <div class="input-group" style="max-width: 380px;">
        <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
        <input type="text" id="bookingSearchInput" class="form-control border-start-0 ps-0" placeholder="Tìm theo mã booking hoặc tên khách..." onkeyup="filterBookings()">
    </div>
</div>

<div class="admin-card">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0" id="bookingTable">
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
            <tbody id="bookingTableBody">
                <c:forEach var="b" items="${bookings}">
                    <tr class="booking-row" data-code="${b.code.toLowerCase()}" data-name="${b.guestName.toLowerCase()}">
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
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline">
                                <input type="hidden" name="action" value="updateBookingStatus">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="tab" value="bookings">
                                <select name="status" class="form-select form-select-sm fw-semibold" style="width: auto; min-width: 130px;" onchange="this.form.submit()">
                                    <option value="pending" ${b.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="confirmed" ${b.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="checkedin" ${b.status == 'checkedin' ? 'selected' : ''}>Đang ở</option>
                                    <option value="checkedout" ${b.status == 'checkedout' ? 'selected' : ''}>Đã trả phòng</option>
                                    <option value="cancelled" ${b.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </form>
                        </td>
                        <td class="text-end">
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa đơn đặt phòng này?');">
                                <input type="hidden" name="action" value="deleteBooking">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="tab" value="bookings">
                                <button type="submit" class="btn btn-sm btn-link text-danger p-1" title="Xóa đơn">
                                    <i class="bi bi-trash fs-6"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bookings}">
                    <tr>
                        <td colspan="8" class="text-center py-4 text-muted">Chưa có đơn đặt phòng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Client-Side Pagination (10 items / page) -->
    <div class="pagination-container" id="bookingPagination">
        <div class="text-muted small" id="bookingPaginationInfo">Hiển thị 1 - 10 trong tổng số ${bookings.size()} đơn</div>
        <div class="d-flex align-items-center" id="bookingPaginationButtons"></div>
    </div>
</div>
