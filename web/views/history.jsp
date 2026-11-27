<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-5">
    <div class="mb-4">
        <h2 class="fw-bold text-dark mb-1">Lịch sử & Tra cứu đặt phòng</h2>
        <p class="text-muted small">Theo dõi trạng thái các đơn đặt phòng của bạn tại Núi Homestay</p>
    </div>

    <!-- Ô tra cứu bằng SĐT nếu chưa đăng nhập -->
    <c:if test="${empty sessionScope.user}">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white" style="max-width: 600px;">
            <form action="${pageContext.request.contextPath}/history" method="GET" class="d-flex gap-2">
                <input type="tel" name="phone" class="form-control" placeholder="Nhập số điện thoại đã đặt phòng..." required value="${phone}">
                <button type="submit" class="btn btn-success-custom text-nowrap px-4">
                    <i class="bi bi-search me-1"></i> Tra cứu
                </button>
            </form>
        </div>
    </c:if>

    <!-- Danh sách đơn đặt -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Mã đơn</th>
                        <th>Loại phòng</th>
                        <th>Thời gian</th>
                        <th>Khách đặt</th>
                        <th>Tổng tiền</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái</th>
                        <th class="pe-4 text-end">Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty bookings}">
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td class="ps-4 fw-bold text-success">${b.code}</td>
                                    <td>
                                        <div class="fw-semibold text-dark">${b.roomTypeName}</div>
                                        <c:if test="${not empty b.roomCode}">
                                            <span class="badge bg-secondary-subtle text-secondary small">Phòng: ${b.roomCode}</span>
                                        </c:if>
                                    </td>
                                    <td class="small text-secondary">
                                        <div><i class="bi bi-calendar-event me-1"></i> ${b.checkIn}</div>
                                        <div><i class="bi bi-calendar2-check me-1"></i> ${b.checkOut} (${b.nights} đêm)</div>
                                    </td>
                                    <td class="small">
                                        <div class="fw-medium text-dark">${b.guestName}</div>
                                        <div class="text-muted">${b.guestPhone}</div>
                                    </td>
                                    <td class="fw-bold text-dark">${b.formattedTotal}</td>
                                    <td>
                                        <span class="badge ${b.payStatus == 'paid' ? 'bg-success' : 'bg-warning text-dark'}">
                                            ${b.payStatus == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${b.status == 'checkedin'}"><span class="badge" style="background-color: #059669;">Đang ở</span></c:when>
                                            <c:when test="${b.status == 'checkedout'}"><span class="badge bg-secondary">Đã trả phòng</span></c:when>
                                            <c:when test="${b.status == 'confirmed'}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
                                            <c:when test="${b.status == 'cancelled'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">Chờ duyệt</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <a href="${pageContext.request.contextPath}/success?code=${b.code}" class="btn btn-sm btn-outline-secondary rounded-pill">
                                            Xem biên nhận
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                    Chưa tìm thấy đơn đặt phòng nào phù hợp.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="/inc/footer.jsp" />
