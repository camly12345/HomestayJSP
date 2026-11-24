<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/inc/header.jsp" />
<jsp:include page="/inc/navbar.jsp" />

<main class="container py-4">
    <!-- Header Admin -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
        <div>
            <h2 class="fw-bold text-dark mb-1"><i class="bi bi-speedometer2 text-success me-2"></i> Hệ Thống Quản Trị Homestay</h2>
            <p class="text-muted small mb-0">Quản lý đặt phòng, loại phòng, danh sách phòng và khách hàng</p>
        </div>
        <div>
            <span class="badge bg-success fs-6 py-2 px-3"><i class="bi bi-shield-lock-fill me-1"></i> Quản trị viên</span>
        </div>
    </div>

    <!-- Navigation Tabs (BỎ DỊCH VỤ VÀ ĐÁNH GIÁ) -->
    <ul class="nav nav-pills mb-4 gap-2 bg-white p-2 rounded-4 shadow-sm">
        <li class="nav-item">
            <a class="nav-link ${tab == 'overview' ? 'active bg-success' : 'text-secondary fw-semibold'}" href="${pageContext.request.contextPath}/admin?tab=overview">
                <i class="bi bi-grid-fill me-1"></i> Tổng quan
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${tab == 'rooms' ? 'active bg-success' : 'text-secondary fw-semibold'}" href="${pageContext.request.contextPath}/admin?tab=rooms">
                <i class="bi bi-door-open-fill me-1"></i> Quản lý Phòng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${tab == 'bookings' ? 'active bg-success' : 'text-secondary fw-semibold'}" href="${pageContext.request.contextPath}/admin?tab=bookings">
                <i class="bi bi-calendar2-range-fill me-1"></i> Đặt phòng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${tab == 'customers' ? 'active bg-success' : 'text-secondary fw-semibold'}" href="${pageContext.request.contextPath}/admin?tab=customers">
                <i class="bi bi-people-fill me-1"></i> Khách hàng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${tab == 'stats' ? 'active bg-success' : 'text-secondary fw-semibold'}" href="${pageContext.request.contextPath}/admin?tab=stats">
                <i class="bi bi-graph-up-arrow me-1"></i> Thống kê
            </a>
        </li>
    </ul>

    <!-- 1. TAB OVERVIEW -->
    <c:if test="${tab == 'overview'}">
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white text-center">
                    <span class="text-muted small fw-semibold">Tổng doanh thu</span>
                    <h3 class="fw-bold text-success mt-2 mb-0">
                        <fmt:formatNumber value="${totalRevenue}" pattern="#,###" /> đ
                    </h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white text-center">
                    <span class="text-muted small fw-semibold">Tổng đơn đặt</span>
                    <h3 class="fw-bold text-dark mt-2 mb-0">${totalBookings}</h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white text-center">
                    <span class="text-muted small fw-semibold">Khách đang ở</span>
                    <h3 class="fw-bold text-primary mt-2 mb-0">${activeGuests}</h3>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white text-center">
                    <span class="text-muted small fw-semibold">Tổng số phòng</span>
                    <h3 class="fw-bold text-dark mt-2 mb-0">${rooms.size()}</h3>
                </div>
            </div>
        </div>

        <!-- Recent bookings table -->
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <h6 class="fw-bold text-dark mb-0"><i class="bi bi-clock-history me-2 text-success"></i> Đơn đặt phòng gần nhất</h6>
                <a href="${pageContext.request.contextPath}/admin?tab=bookings" class="small text-success fw-semibold text-decoration-none">Xem tất cả</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Mã</th>
                            <th>Khách hàng</th>
                            <th>Loại phòng</th>
                            <th>Ngày đến</th>
                            <th>Ngày đi</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}" end="5">
                            <tr>
                                <td class="ps-3 fw-bold text-success">${b.code}</td>
                                <td>${b.guestName} <small class="text-muted d-block">${b.guestPhone}</small></td>
                                <td>${b.roomTypeName}</td>
                                <td>${b.checkIn}</td>
                                <td>${b.checkOut}</td>
                                <td class="fw-bold">${b.formattedTotal}</td>
                                <td>
                                    <span class="badge ${b.status == 'checkedin' ? 'bg-primary' : (b.status == 'checkedout' ? 'bg-secondary' : 'bg-warning text-dark')}">
                                        ${b.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- 2. TAB ROOMS -->
    <c:if test="${tab == 'rooms'}">
        <div class="row g-4">
            <!-- Cột trái: Loại phòng -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold text-dark mb-0">Danh sách Loại phòng</h5>
                        <button class="btn btn-success-custom btn-sm" data-bs-toggle="modal" data-bs-target="#addRoomTypeModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm loại phòng
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Loại phòng</th>
                                    <th>Giá/đêm</th>
                                    <th>Sức chứa</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rt" items="${roomTypes}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="${rt.image}" style="width: 45px; height: 45px; object-fit: cover;" class="rounded-2" alt="">
                                                <div>
                                                    <strong class="d-block text-dark">${rt.name}</strong>
                                                    <small class="text-muted">${rt.formattedBed}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="fw-bold text-success">${rt.formattedPrice}</td>
                                        <td>${rt.capacity} người</td>
                                        <td>
                                            <span class="badge ${rt.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                ${rt.status == 1 ? '1 (Active)' : '0 (Inactive)'}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa loại phòng này?');">
                                                <input type="hidden" name="action" value="deleteRoomType">
                                                <input type="hidden" name="id" value="${rt.id}">
                                                <input type="hidden" name="tab" value="rooms">
                                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Cột phải: Phòng thực tế -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold text-dark mb-0">Phòng thực tế (${rooms.size()})</h5>
                        <button class="btn btn-outline-success btn-sm" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                            <i class="bi bi-plus-lg me-1"></i> Thêm phòng
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã phòng</th>
                                    <th>Thuộc loại</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rm" items="${rooms}">
                                    <tr>
                                        <td class="fw-bold text-dark">${rm.code}</td>
                                        <td class="small">${rm.roomTypeName}</td>
                                        <td>
                                            <span class="badge ${rm.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                                ${rm.status == 1 ? '1 (Active)' : '0 (Inactive)'}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Xóa phòng này?');">
                                                <input type="hidden" name="action" value="deleteRoom">
                                                <input type="hidden" name="id" value="${rm.id}">
                                                <input type="hidden" name="tab" value="rooms">
                                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Thêm Loại Phòng -->
        <div class="modal fade" id="addRoomTypeModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content rounded-4 border-0">
                    <form action="${pageContext.request.contextPath}/admin" method="POST">
                        <input type="hidden" name="action" value="addRoomType">
                        <input type="hidden" name="tab" value="rooms">
                        <div class="modal-header">
                            <h5 class="modal-title fw-bold">Thêm loại phòng mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body space-y-3">
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Tên loại phòng</label>
                                <input type="text" name="name" class="form-control" required placeholder="Phòng Deluxe...">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Giá mỗi đêm (VNĐ)</label>
                                <input type="number" name="price" class="form-control" required placeholder="500000">
                            </div>
                            <div class="row g-2 mb-2">
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Sức chứa (người)</label>
                                    <input type="number" name="capacity" class="form-control" value="2" required min="1">
                                </div>
                                <div class="col-6">
                                    <label class="form-label small fw-semibold">Số lượng giường</label>
                                    <input type="number" name="bed" class="form-control" value="1" required min="1">
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Link ảnh phòng</label>
                                <input type="text" name="image" class="form-control" value="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="1" selected>1 (Active - Hoạt động)</option>
                                    <option value="0">0 (Inactive - Tạm ngưng)</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Mô tả</label>
                                <textarea name="description" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-success-custom">Lưu loại phòng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Thêm Phòng Thực Tế -->
        <div class="modal fade" id="addRoomModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content rounded-4 border-0">
                    <form action="${pageContext.request.contextPath}/admin" method="POST">
                        <input type="hidden" name="action" value="addRoom">
                        <input type="hidden" name="tab" value="rooms">
                        <div class="modal-header">
                            <h5 class="modal-title fw-bold">Thêm phòng thực tế</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Mã phòng (vd: P103, BG03)</label>
                                <input type="text" name="code" class="form-control" required placeholder="P103">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Thuộc loại phòng</label>
                                <select name="roomTypeId" class="form-select" required>
                                    <c:forEach var="rt" items="${roomTypes}">
                                        <option value="${rt.id}">${rt.name} (${rt.formattedPrice})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-success-custom">Thêm phòng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 3. TAB BOOKINGS -->
    <c:if test="${tab == 'bookings'}">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-4">
            <h5 class="fw-bold text-dark mb-3">Tất cả đơn đặt phòng (${bookings.size()})</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Mã</th>
                            <th>Khách đặt</th>
                            <th>Loại phòng</th>
                            <th>Lịch trình</th>
                            <th>Tổng tiền</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Cập nhật</th>
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
                                <td>${b.roomTypeName}</td>
                                <td class="small">
                                    ${b.checkIn} đến ${b.checkOut}
                                    <span class="text-muted d-block">(${b.nights} đêm)</span>
                                </td>
                                <td class="fw-bold">${b.formattedTotal}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updatePayStatus">
                                        <input type="hidden" name="id" value="${b.id}">
                                        <input type="hidden" name="tab" value="bookings">
                                        <select name="payStatus" class="form-select form-select-sm" onchange="this.form.submit()">
                                            <option value="unpaid" ${b.payStatus == 'unpaid' ? 'selected' : ''}>Chưa trả</option>
                                            <option value="paid" ${b.payStatus == 'paid' ? 'selected' : ''}>Đã trả</option>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateBookingStatus">
                                        <input type="hidden" name="id" value="${b.id}">
                                        <input type="hidden" name="tab" value="bookings">
                                        <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                            <option value="pending" ${b.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                            <option value="confirmed" ${b.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                            <option value="checkedin" ${b.status == 'checkedin' ? 'selected' : ''}>Đã check-in</option>
                                            <option value="checkedout" ${b.status == 'checkedout' ? 'selected' : ''}>Đã check-out</option>
                                            <option value="cancelled" ${b.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/success?code=${b.code}" target="_blank" class="btn btn-sm btn-outline-secondary">
                                        Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- 4. TAB CUSTOMERS -->
    <c:if test="${tab == 'customers'}">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-4">
            <h5 class="fw-bold text-dark mb-3">Danh sách Khách hàng (${customers.size()})</h5>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Vai trò</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${customers}">
                            <tr>
                                <td>#${c.id}</td>
                                <td class="fw-bold">${c.name}</td>
                                <td>${c.email}</td>
                                <td>${c.phone}</td>
                                <td><span class="badge bg-secondary">Khách hàng</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- 5. TAB STATS -->
    <c:if test="${tab == 'stats'}">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                    <h5 class="fw-bold text-dark mb-3">Hiệu suất phòng</h5>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span>Tổng số phòng vật lý:</span>
                        <strong>${rooms.size()} phòng</strong>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span>Phòng ngưng hoạt động (Inactive):</span>
                        <strong class="text-secondary">${activeGuests} phòng</strong>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span>Phòng hoạt động (Active):</span>
                        <strong class="text-success">${rooms.size() - activeGuests} phòng</strong>
                    </div>
                    <div class="d-flex justify-content-between py-2">
                        <span>Tỷ lệ lấp đầy hiện tại:</span>
                        <strong class="text-primary">
                            <fmt:formatNumber value="${rooms.size() > 0 ? (activeGuests * 100.0 / rooms.size()) : 0}" maxFractionDigits="1" /> %
                        </strong>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                    <h5 class="fw-bold text-dark mb-3">Tài chính Homestay</h5>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span>Tổng lượt đặt phòng:</span>
                        <strong>${totalBookings} đơn</strong>
                    </div>
                    <div class="d-flex justify-content-between py-2 border-bottom">
                        <span>Doanh thu thực tế đã thanh toán:</span>
                        <strong class="text-success fs-5">
                            <fmt:formatNumber value="${totalRevenue}" pattern="#,###" /> đ
                        </strong>
                    </div>
                    <div class="d-flex justify-content-between py-2">
                        <span>Địa điểm hoạt động:</span>
                        <strong>2 Ngự Bình, An Cựu, TP. Huế</strong>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</main>

<jsp:include page="/inc/footer.jsp" />
