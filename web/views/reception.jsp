<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-4">
    <!-- Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
        <div>
            <h2 class="fw-bold text-dark mb-1"><i class="bi bi-calendar-check text-success me-2"></i> Bàn Làm Việc Lễ Tân</h2>
            <p class="text-muted small mb-0">Theo dõi trạng thái phòng trực tiếp, nhận phòng (Check-in), trả phòng (Check-out) và đặt phòng tại quầy</p>
        </div>
        <button class="btn btn-success-custom" data-bs-toggle="modal" data-bs-target="#walkInModal">
            <i class="bi bi-person-plus-fill me-1"></i> Đặt phòng tại quầy (Walk-in)
        </button>
    </div>

    <!-- Status Legend -->
    <div class="d-flex flex-wrap gap-4 p-3 bg-white rounded-4 shadow-sm mb-4 align-items-center small">
        <span class="fw-semibold text-dark">Chú thích phòng:</span>
        <span class="d-flex align-items-center gap-1"><span class="badge bg-success rounded-circle p-1"> </span> Phòng hoạt động (Active)</span>
        <span class="d-flex align-items-center gap-1"><span class="badge bg-secondary rounded-circle p-1"> </span> Phòng ngưng hoạt động (Inactive)</span>
    </div>

    <!-- ROOM GRID VIEW -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
        <h5 class="fw-bold text-dark mb-4"><i class="bi bi-grid-3x3-gap-fill text-success me-2"></i> Sơ đồ phòng hiện tại</h5>
        
        <div class="row g-3">
            <c:forEach var="rm" items="${rooms}">
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="card border h-100 rounded-3 p-3 text-center ${rm.status == 1 ? 'border-success-subtle bg-success-subtle bg-opacity-10' : 'border-secondary-subtle bg-secondary-subtle bg-opacity-10'}">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fs-4 fw-bold text-dark">${rm.code}</span>
                            <span class="badge ${rm.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                ${rm.status == 1 ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                        <p class="small text-muted mb-2">${rm.roomTypeName}</p>
                        <p class="fw-bold text-success small mb-3"><fmt:formatNumber value="${rm.price}" pattern="#,###" /> đ</p>
                        
                        <!-- Actions -->
                        <form action="${pageContext.request.contextPath}/reception" method="POST">
                            <input type="hidden" name="action" value="changeRoomStatus">
                            <input type="hidden" name="roomId" value="${rm.id}">
                            <div class="btn-group btn-group-sm w-100">
                                <button type="submit" name="status" value="1" class="btn btn-outline-success ${rm.status == 1 ? 'active' : ''}">Active</button>
                                <button type="submit" name="status" value="0" class="btn btn-outline-secondary ${rm.status == 0 ? 'active' : ''}">Inactive</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- BOOKINGS MANAGEMENT -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-4">
        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-list-check text-success me-2"></i> Danh sách xử lý khách đến / đi</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Phòng / Loại</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                        <th>Thanh toán</th>
                        <th class="text-end">Xử lý nhanh</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td class="fw-bold text-success">${b.code}</td>
                            <td>
                                <strong>${b.guestName}</strong>
                                <small class="text-muted d-block">${b.guestPhone}</small>
                            </td>
                            <td>
                                <div class="fw-semibold">${b.roomTypeName}</div>
                                <small class="text-muted">Phòng: <strong>${not empty b.roomCode ? b.roomCode : 'Chưa gán'}</strong></small>
                            </td>
                            <td class="small">
                                ${b.checkIn} đến ${b.checkOut}
                            </td>
                            <td>
                                <span class="badge ${b.status == 'checkedin' ? 'bg-primary' : (b.status == 'checkedout' ? 'bg-secondary' : 'bg-warning text-dark')}">
                                    ${b.status}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${b.payStatus == 'paid' ? 'bg-success' : 'bg-danger'}">
                                    ${b.payStatus == 'paid' ? 'Đã thu' : 'Chưa thu'}
                                </span>
                            </td>
                            <td class="text-end">
                                <c:if test="${b.status == 'confirmed' || b.status == 'pending'}">
                                    <form action="${pageContext.request.contextPath}/reception" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="checkIn">
                                        <input type="hidden" name="bookingId" value="${b.id}">
                                        <button type="submit" class="btn btn-sm btn-primary">Check-in</button>
                                    </form>
                                </c:if>
                                <c:if test="${b.status == 'checkedin'}">
                                    <form action="${pageContext.request.contextPath}/reception" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="checkOut">
                                        <input type="hidden" name="bookingId" value="${b.id}">
                                        <button type="submit" class="btn btn-sm btn-success">Check-out</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Walk-in Modal -->
    <div class="modal fade" id="walkInModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0">
                <form action="${pageContext.request.contextPath}/reception" method="POST">
                    <input type="hidden" name="action" value="walkInBooking">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Đặt phòng trực tiếp tại quầy</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body space-y-3">
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Chọn phòng trống</label>
                            <select name="roomId" class="form-select" required>
                                <c:forEach var="rm" items="${rooms}">
                                    <c:if test="${rm.status == 1}">
                                        <option value="${rm.id}">${rm.code} - ${rm.roomTypeName} (<fmt:formatNumber value="${rm.price}" pattern="#,###" /> đ)</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Họ tên khách</label>
                            <input type="text" name="guestName" class="form-control" required placeholder="Nguyễn Văn A">
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Số điện thoại</label>
                            <input type="tel" name="guestPhone" class="form-control" required placeholder="0912345678">
                        </div>
                        <div class="row g-2 mb-2">
                            <div class="col-6">
                                <label class="form-label small fw-semibold">Ngày nhận</label>
                                <input type="date" name="checkIn" class="form-control" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-semibold">Ngày trả</label>
                                <input type="date" name="checkOut" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Thanh toán</label>
                            <select name="payMethod" class="form-select">
                                <option value="cash">Tiền mặt</option>
                                <option value="transfer">Chuyển khoản</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-semibold">Ghi chú</label>
                            <input type="text" name="note" class="form-control" placeholder="Yêu cầu riêng của khách...">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success-custom">Check-in ngay</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/inc/footer.jsp" />
