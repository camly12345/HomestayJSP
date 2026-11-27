<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title != null ? title : 'Quản Trị Hệ Thống - Núi Homestay'}</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Chart.js for Statistics -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --primary: #10b981;
            --primary-dark: #059669;
            --dark-color: #0f172a;
            --light-bg: #f8fafc;
            --card-border: #e2e8f0;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: #334155;
            min-height: 100vh;
        }
        .admin-header {
            background-color: #059669;
            height: 56px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }
        .admin-brand {
            font-weight: 800;
            color: #ffffff !important;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1.05rem;
        }
        .admin-tab-btn {
            color: #ffffff;
            text-decoration: none;
            font-size: 0.875rem;
            padding: 6px 14px;
            border-radius: 9999px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }
        .admin-tab-btn:hover {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        .admin-tab-btn.active {
            background-color: rgba(255, 255, 255, 0.25);
            font-weight: 700;
            color: #ffffff;
        }
        .admin-stat-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 20px 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            transition: transform 0.2s;
        }
        .admin-stat-card:hover {
            transform: translateY(-2px);
        }
        .admin-stat-label {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .admin-stat-value {
            font-size: 1.85rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
        }
        .admin-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            overflow: hidden;
        }
        .table thead th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 0.825rem;
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 16px;
        }
        .table tbody td {
            padding: 12px 16px;
            font-size: 0.875rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }
        .btn-sky {
            background-color: #10b981;
            color: #ffffff;
            font-weight: 700;
            border: none;
            padding: 8px 18px;
            border-radius: 10px;
            transition: background-color 0.2s;
        }
        .btn-sky:hover {
            background-color: #059669;
            color: #ffffff;
        }
        .sub-tab-btn {
            font-weight: 600;
            font-size: 0.9rem;
            padding: 8px 20px;
            border-radius: 12px;
            border: 1px solid transparent;
            text-decoration: none;
            color: #64748b;
            background-color: #f1f5f9;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .sub-tab-btn.active {
            background-color: #10b981;
            color: #ffffff;
            font-weight: 700;
        }
        .badge-active {
            background-color: #dcfce7;
            color: #166534;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 9999px;
            border: 1px solid #bbf7d0;
        }
        .badge-inactive {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 9999px;
            border: 1px solid #e2e8f0;
        }
        /* Pagination bar */
        .pagination-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            background-color: #ffffff;
            border-top: 1px solid #f1f5f9;
            font-size: 0.85rem;
        }
        .page-num-btn {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            border: 1px solid #e2e8f0;
            background: #ffffff;
            color: #334155;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin: 0 2px;
        }
        .page-num-btn:hover {
            border-color: #cbd5e1;
            background-color: #f8fafc;
        }
        .page-num-btn.active {
            background-color: #10b981;
            color: #ffffff;
            border-color: #10b981;
        }
        .page-num-btn:disabled {
            opacity: 0.35;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

    <!-- ADMIN HEADER NAVBAR -->
    <header class="admin-header d-flex align-items-center justify-content-between px-3 px-md-4">
        <div class="d-flex align-items-center gap-3 overflow-x-auto">
            <a href="${pageContext.request.contextPath}/admin?tab=overview" class="admin-brand me-2">
                <i class="bi bi-tree-fill text-warning fs-5"></i> Núi Homestay (Admin)
            </a>

            <!-- 5 TABS REQUIRED -->
            <a href="${pageContext.request.contextPath}/admin?tab=overview" class="admin-tab-btn ${tab == 'overview' ? 'active' : ''}">
                <i class="bi bi-grid"></i> Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin?tab=rooms&subTab=${subTab != null ? subTab : 'roomList'}" class="admin-tab-btn ${tab == 'rooms' ? 'active' : ''}">
                <i class="bi bi-door-open"></i> Phòng
            </a>
            <a href="${pageContext.request.contextPath}/admin?tab=customers" class="admin-tab-btn ${tab == 'customers' ? 'active' : ''}">
                <i class="bi bi-people"></i> Khách hàng
            </a>
            <a href="${pageContext.request.contextPath}/admin?tab=bookings" class="admin-tab-btn ${tab == 'bookings' ? 'active' : ''}">
                <i class="bi bi-calendar2-range"></i> Đặt phòng
            </a>
            <a href="${pageContext.request.contextPath}/admin?tab=stats" class="admin-tab-btn ${tab == 'stats' ? 'active' : ''}">
                <i class="bi bi-graph-up"></i> Thống kê
            </a>
        </div>

        <div class="d-flex align-items-center gap-3 text-white">
            <span class="d-none d-sm-inline fw-semibold small">Quản Lý</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light rounded-pill px-3 py-1 d-flex align-items-center gap-1 small">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </div>
    </header>

    <!-- MAIN CONTAINER -->
    <main class="container-fluid max-w-7xl px-3 px-md-4 py-4" style="max-width: 1280px; margin: 0 auto;">

        <!-- Alert messages -->
        <c:if test="${not empty sessionScope.adminSuccess}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 border-0 shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div>${sessionScope.adminSuccess}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("adminSuccess"); %>
        </c:if>
        <c:if test="${not empty sessionScope.adminError}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div>${sessionScope.adminError}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("adminError"); %>
        </c:if>

        <!-- ==================== TAB 1: TỔNG QUAN ==================== -->
        <c:if test="${tab == 'overview'}">
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
        </c:if>

        <!-- ==================== TAB 2: PHÒNG (DANH SÁCH & LOẠI PHÒNG) ==================== -->
        <c:if test="${tab == 'rooms'}">
            <!-- Sub-tab Navigation -->
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-4">
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin?tab=rooms&subTab=roomList" class="sub-tab-btn ${subTab != 'roomTypes' ? 'active' : ''}">
                        <i class="bi bi-door-open"></i> Danh sách phòng
                    </a>
                    <a href="${pageContext.request.contextPath}/admin?tab=rooms&subTab=roomTypes" class="sub-tab-btn ${subTab == 'roomTypes' ? 'active' : ''}">
                        <i class="bi bi-columns-gap"></i> Loại phòng
                    </a>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${subTab == 'roomTypes'}">
                            <button type="button" class="btn btn-sky d-flex align-items-center gap-1 shadow-sm" data-bs-toggle="modal" data-bs-target="#addRoomTypeModal">
                                <i class="bi bi-plus-lg"></i> Thêm loại phòng
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-sky d-flex align-items-center gap-1 shadow-sm" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                                <i class="bi bi-plus-lg"></i> Thêm phòng
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- SUB-TAB 1: DANH SÁCH PHÒNG VẬT LÝ -->
            <c:if test="${subTab != 'roomTypes'}">
                <div class="admin-card">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="roomTable">
                            <thead>
                                <tr>
                                    <th>Tên phòng</th>
                                    <th>Tên loại phòng</th>
                                    <th>Giá phòng</th>
                                    <th>Khu vực</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="roomTableBody">
                                <c:forEach var="rm" items="${rooms}">
                                    <tr class="room-row">
                                        <td class="fw-bold text-dark">${rm.code}</td>
                                        <td>${rm.roomTypeName}</td>
                                        <td class="fw-semibold text-success">
                                            <fmt:formatNumber value="${rm.price}" pattern="#,###" /> VNĐ
                                        </td>
                                        <td>${rm.area}</td>
                                        <td>
                                            <span class="${rm.status == 1 ? 'badge-active' : 'badge-inactive'}">
                                                ${rm.status == 1 ? 'Hoạt động' : 'Tạm dừng'}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <!-- Sửa phòng -->
                                            <button type="button" class="btn btn-sm btn-link text-success p-1 me-1" title="Chỉnh sửa"
                                                    onclick="openEditRoomModal(${rm.id}, '${rm.code}', ${rm.roomTypeId}, '${rm.area}', ${rm.status})">
                                                <i class="bi bi-pencil-square fs-6"></i>
                                            </button>
                                            <!-- Bật/Dừng hoạt động -->
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="toggleRoomStatus">
                                                <input type="hidden" name="id" value="${rm.id}">
                                                <input type="hidden" name="status" value="${rm.status}">
                                                <input type="hidden" name="tab" value="rooms">
                                                <input type="hidden" name="subTab" value="roomList">
                                                <button type="submit" class="btn btn-sm btn-link p-1 me-1 ${rm.status == 1 ? 'text-success' : 'text-secondary'}" 
                                                        title="${rm.status == 1 ? 'Dừng hoạt động' : 'Bật hoạt động'}">
                                                    <i class="bi bi-power fs-6"></i>
                                                </button>
                                            </form>
                                            <!-- Xóa phòng -->
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa phòng này?');">
                                                <input type="hidden" name="action" value="deleteRoom">
                                                <input type="hidden" name="id" value="${rm.id}">
                                                <input type="hidden" name="tab" value="rooms">
                                                <input type="hidden" name="subTab" value="roomList">
                                                <button type="submit" class="btn btn-sm btn-link text-danger p-1" title="Xóa phòng">
                                                    <i class="bi bi-trash fs-6"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty rooms}">
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">Chưa có phòng nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Client-Side Pagination (5 items / page) -->
                    <div class="pagination-container" id="roomPagination">
                        <div class="text-muted small" id="roomPaginationInfo">Hiển thị 1 - 5 trong tổng số ${rooms.size()} phòng</div>
                        <div class="d-flex align-items-center" id="roomPaginationButtons"></div>
                    </div>
                </div>
            </c:if>

            <!-- SUB-TAB 2: DANH SÁCH LOẠI PHÒNG -->
            <c:if test="${subTab == 'roomTypes'}">
                <div class="admin-card">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="typeTable">
                            <thead>
                                <tr>
                                    <th>Mã loại (id)</th>
                                    <th>Tên loại</th>
                                    <th>Giá</th>
                                    <th>Sức chứa</th>
                                    <th>Số giường</th>
                                    <th>Hình ảnh</th>
                                    <th class="text-end">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="typeTableBody">
                                <c:forEach var="rt" items="${roomTypes}">
                                    <tr class="type-row">
                                        <td class="font-monospace fw-bold text-secondary">L00${rt.id}</td>
                                        <td class="fw-semibold text-dark">${rt.name}</td>
                                        <td class="fw-bold text-success">${rt.formattedPrice}</td>
                                        <td>${rt.capacity} người</td>
                                        <td>${rt.formattedBed}</td>
                                        <td>
                                            <img src="${rt.image}" alt="${rt.name}" style="width: 48px; height: 36px; object-fit: cover;" class="rounded-2 border">
                                        </td>
                                        <td class="text-end">
                                            <!-- Sửa loại phòng -->
                                            <button type="button" class="btn btn-sm btn-link text-success p-1 me-1" title="Sửa loại phòng"
                                                    onclick='openEditRoomTypeModal(${rt.id}, "${rt.name}", ${rt.price}, ${rt.capacity}, ${rt.bed}, `${rt.description}`, "${rt.image}")'>
                                                <i class="bi bi-pencil-square fs-6"></i>
                                            </button>
                                            <!-- Xóa loại phòng (Ràng buộc: xóa loại phòng sẽ xóa cả các phòng thuộc loại này) -->
                                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="d-inline" 
                                                  onsubmit="return confirm('CẢNH BÁO: Giữa phòng và loại phòng có ràng buộc! Khi xóa loại phòng này, TẤT CẢ các phòng vật lý thuộc loại này cũng sẽ bị xóa theo. Bạn có chắc chắn muốn xóa?');">
                                                <input type="hidden" name="action" value="deleteRoomType">
                                                <input type="hidden" name="id" value="${rt.id}">
                                                <input type="hidden" name="tab" value="rooms">
                                                <input type="hidden" name="subTab" value="roomTypes">
                                                <button type="submit" class="btn btn-sm btn-link text-danger p-1" title="Xóa loại phòng">
                                                    <i class="bi bi-trash fs-6"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty roomTypes}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">Chưa có loại phòng nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Client-Side Pagination (5 items / page) -->
                    <div class="pagination-container" id="typePagination">
                        <div class="text-muted small" id="typePaginationInfo">Hiển thị 1 - 5 trong tổng số ${roomTypes.size()} loại phòng</div>
                        <div class="d-flex align-items-center" id="typePaginationButtons"></div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <!-- ==================== TAB 3: KHÁCH HÀNG ==================== -->
        <c:if test="${tab == 'customers'}">
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
        </c:if>

        <!-- ==================== TAB 4: ĐẶT PHÒNG ==================== -->
        <c:if test="${tab == 'bookings'}">
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
        </c:if>

        <!-- ==================== TAB 5: THỐNG KÊ ==================== -->
        <c:if test="${tab == 'stats'}">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                <h4 class="fw-bold text-dark mb-0">Thống kê doanh thu</h4>

                <!-- FILTER CONTROLS -->
                <div class="d-flex flex-wrap align-items-center gap-2 bg-white p-2 rounded-4 border shadow-sm">
                    <select id="statModeSelect" class="form-select form-select-sm fw-semibold" style="width: auto;" onchange="updateStatsChart()">
                        <option value="month">Theo ngày trong tháng</option>
                        <option value="year">Theo 12 tháng trong năm</option>
                    </select>

                    <select id="statMonthSelect" class="form-select form-select-sm fw-semibold" style="width: auto;" onchange="updateStatsChart()">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}">Tháng ${m}</option>
                        </c:forEach>
                    </select>

                    <select id="statYearSelect" class="form-select form-select-sm fw-semibold" style="width: auto;" onchange="updateStatsChart()">
                        <option value="2025">Năm 2025</option>
                        <option value="2026" selected>Năm 2026</option>
                        <option value="2027">Năm 2027</option>
                    </select>
                </div>
            </div>

            <!-- 2 STAT CARDS -->
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <div class="admin-stat-card">
                        <div class="admin-stat-label" id="statRevenueLabel">Doanh thu</div>
                        <h2 class="admin-stat-value text-success" id="statRevenueValue">0 VNĐ</h2>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="admin-stat-card">
                        <div class="admin-stat-label">Số đơn hoàn tất trả phòng</div>
                        <h2 class="admin-stat-value text-dark" id="statCompletedCount">0</h2>
                    </div>
                </div>
            </div>

            <!-- BARCHART -->
            <div class="admin-card p-4">
                <h5 class="fw-bold text-dark mb-4" id="statChartTitle">Chi tiết doanh thu (Đơn vị: VNĐ)</h5>
                <div style="height: 360px; width: 100%;">
                    <canvas id="revenueBarChart"></canvas>
                </div>
            </div>
        </c:if>
    </main>

    <!-- ==================== MODALS ==================== -->

    <!-- 1. Modal Thêm Mới Phòng Vật Lý -->
    <div class="modal fade" id="addRoomModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin" method="POST" id="formAddRoom">
                    <input type="hidden" name="action" value="addRoom">
                    <input type="hidden" name="tab" value="rooms">
                    <input type="hidden" name="subTab" value="roomList">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold">Thêm mới phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body space-y-3 pt-3">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Tên phòng / Số phòng (Mã phòng)</label>
                            <input type="text" name="code" id="addRoomCode" class="form-control" placeholder="P001" required>
                            <div class="invalid-feedback" id="roomCodeFeedback">Mã phòng đã tồn tại trên hệ thống!</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Loại phòng</label>
                            <select name="roomTypeId" class="form-select" required>
                                <c:forEach var="t" items="${roomTypes}">
                                    <option value="${t.id}">${t.name} (${t.formattedPrice})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Khu vực</label>
                            <input type="text" name="area" class="form-control" value="Tầng 1" placeholder="Tầng 1 / Ngoài vườn" required>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-sky rounded-pill px-4">Lưu phòng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 2. Modal Chỉnh Sửa Phòng Vật Lý -->
    <div class="modal fade" id="editRoomModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin" method="POST">
                    <input type="hidden" name="action" value="editRoom">
                    <input type="hidden" name="id" id="editRoomId">
                    <input type="hidden" name="tab" value="rooms">
                    <input type="hidden" name="subTab" value="roomList">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold">Chỉnh sửa thông tin phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Tên phòng / Số phòng</label>
                            <input type="text" name="code" id="editRoomCode" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Loại phòng</label>
                            <select name="roomTypeId" id="editRoomTypeId" class="form-select" required>
                                <c:forEach var="t" items="${roomTypes}">
                                    <option value="${t.id}">${t.name} (${t.formattedPrice})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Khu vực</label>
                            <input type="text" name="area" id="editRoomArea" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-secondary">Trạng thái hoạt động</label>
                            <select name="status" id="editRoomStatus" class="form-select">
                                <option value="1">1 - Hoạt động</option>
                                <option value="0">0 - Tạm ngưng</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-sky rounded-pill px-4">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 3. Modal Thêm Mới Loại Phòng (Kèm Upload Ảnh, Quy định, Tiện ích) -->
    <div class="modal fade" id="addRoomTypeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="addRoomType">
                    <input type="hidden" name="tab" value="rooms">
                    <input type="hidden" name="subTab" value="roomTypes">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold">Thêm mới loại phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Tên loại phòng</label>
                                <input type="text" name="name" class="form-control" placeholder="Phòng Deluxe Garden View" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Giá mỗi đêm (VNĐ)</label>
                                <input type="number" name="price" class="form-control" placeholder="650000" required min="1000">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Sức chứa (người)</label>
                                <input type="number" name="capacity" class="form-control" value="2" required min="1">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Số giường</label>
                                <input type="number" name="bed" class="form-control" value="1" required min="1">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-secondary">Mô tả loại phòng</label>
                                <textarea name="description" class="form-control" rows="2" placeholder="Không gian nghỉ dưỡng tuyệt vời giữa cố đô..."></textarea>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small fw-semibold text-secondary">Tải hình ảnh lên từ máy tính</label>
                                <input type="file" name="imageFile" id="addTypeImageFile" class="form-control" accept="image/*" onchange="previewUploadImage(this, 'addTypeImagePreview')">
                                <small class="text-muted">Hoặc dùng ảnh mặc định nếu không chọn tệp</small>
                            </div>
                            <div class="col-md-4 text-center">
                                <label class="form-label small fw-semibold text-secondary d-block">Xem trước ảnh</label>
                                <img id="addTypeImagePreview" src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000" class="rounded-3 border" style="width: 120px; height: 80px; object-fit: cover;" alt="Preview">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-sky rounded-pill px-4">Lưu loại phòng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 4. Modal Chỉnh Sửa Loại Phòng -->
    <div class="modal fade" id="editRoomTypeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="editRoomType">
                    <input type="hidden" name="id" id="editTypeId">
                    <input type="hidden" name="oldImage" id="editTypeOldImage">
                    <input type="hidden" name="tab" value="rooms">
                    <input type="hidden" name="subTab" value="roomTypes">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold">Chỉnh sửa loại phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body pt-3">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Tên loại phòng</label>
                                <input type="text" name="name" id="editTypeName" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Giá mỗi đêm (VNĐ)</label>
                                <input type="number" name="price" id="editTypePrice" class="form-control" required min="1000">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Sức chứa (người)</label>
                                <input type="number" name="capacity" id="editTypeCapacity" class="form-control" required min="1">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Số giường</label>
                                <input type="number" name="bed" id="editTypeBed" class="form-control" required min="1">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-semibold text-secondary">Mô tả</label>
                                <textarea name="description" id="editTypeDescription" class="form-control" rows="2"></textarea>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small fw-semibold text-secondary">Đổi hình ảnh mới (Nếu muốn thay đổi)</label>
                                <input type="file" name="imageFile" id="editTypeImageFile" class="form-control" accept="image/*" onchange="previewUploadImage(this, 'editTypeImagePreview')">
                            </div>
                            <div class="col-md-4 text-center">
                                <label class="form-label small fw-semibold text-secondary d-block">Ảnh hiện tại</label>
                                <img id="editTypeImagePreview" src="" class="rounded-3 border" style="width: 120px; height: 80px; object-fit: cover;" alt="Preview">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-sky rounded-pill px-4">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Scripts (Pagination, Duplicate Check, Chart.js) -->
    <script>
        // Danh sách phòng hiện có để check trùng lặp mã phòng
        const existingRoomCodes = [
            <c:forEach var="r" items="${rooms}" varStatus="loop">
                "${r.code.toUpperCase()}"${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        // Xem trước ảnh khi người dùng chọn file
        function previewUploadImage(input, previewId) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(previewId).src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Mở Modal Sửa Phòng
        function openEditRoomModal(id, code, roomTypeId, area, status) {
            document.getElementById('editRoomId').value = id;
            document.getElementById('editRoomCode').value = code;
            document.getElementById('editRoomTypeId').value = roomTypeId;
            document.getElementById('editRoomArea').value = area;
            document.getElementById('editRoomStatus').value = status;
            new bootstrap.Modal(document.getElementById('editRoomModal')).show();
        }

        // Mở Modal Sửa Loại Phòng
        function openEditRoomTypeModal(id, name, price, capacity, bed, desc, image) {
            document.getElementById('editTypeId').value = id;
            document.getElementById('editTypeName').value = name;
            document.getElementById('editTypePrice').value = price;
            document.getElementById('editTypeCapacity').value = capacity;
            document.getElementById('editTypeBed').value = bed;
            document.getElementById('editTypeDescription').value = desc || '';
            document.getElementById('editTypeOldImage').value = image || '';
            document.getElementById('editTypeImagePreview').src = image || 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000';
            new bootstrap.Modal(document.getElementById('editRoomTypeModal')).show();
        }

        // Kiểm tra trùng mã phòng khi submit thêm phòng
        const formAddRoom = document.getElementById('formAddRoom');
        if (formAddRoom) {
            formAddRoom.addEventListener('submit', function(e) {
                const codeInput = document.getElementById('addRoomCode');
                const val = codeInput.value.trim().toUpperCase();
                if (existingRoomCodes.includes(val)) {
                    e.preventDefault();
                    codeInput.classList.add('is-invalid');
                } else {
                    codeInput.classList.remove('is-invalid');
                }
            });
        }

        // ==================== GENERIC PAGINATION FUNCTION ====================
        function setupPagination(rowClass, infoId, buttonsId, itemsPerPage, itemName) {
            const rows = Array.from(document.querySelectorAll('.' + rowClass));
            const totalItems = rows.length;
            if (totalItems === 0) return;

            let currentPage = 1;
            const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

            function render() {
                const start = (currentPage - 1) * itemsPerPage;
                const end = start + itemsPerPage;

                rows.forEach((row, index) => {
                    if (index >= start && index < end) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });

                // Update info text
                const infoElem = document.getElementById(infoId);
                if (infoElem) {
                    const startItem = totalItems === 0 ? 0 : start + 1;
                    const endItem = Math.min(end, totalItems);
                    infoElem.innerText = `Hiển thị ` + startItem + ` - ` + endItem + ` trong tổng số ` + totalItems + ` ` + itemName;
                }

                // Update buttons
                const btnContainer = document.getElementById(buttonsId);
                if (!btnContainer) return;

                btnContainer.innerHTML = '';
                if (totalPages <= 1) return;

                // Prev button
                const prevBtn = document.createElement('button');
                prevBtn.type = 'button';
                prevBtn.className = 'page-num-btn';
                prevBtn.innerHTML = '<i class="bi bi-chevron-left"></i>';
                prevBtn.disabled = (currentPage === 1);
                prevBtn.onclick = () => { currentPage--; render(); };
                btnContainer.appendChild(prevBtn);

                // Page numbers
                for (let i = 1; i <= totalPages; i++) {
                    const pBtn = document.createElement('button');
                    pBtn.type = 'button';
                    pBtn.className = 'page-num-btn ' + (currentPage === i ? 'active' : '');
                    pBtn.innerText = i;
                    pBtn.onclick = () => { currentPage = i; render(); };
                    btnContainer.appendChild(pBtn);
                }

                // Next button
                const nextBtn = document.createElement('button');
                nextBtn.type = 'button';
                nextBtn.className = 'page-num-btn';
                nextBtn.innerHTML = '<i class="bi bi-chevron-right"></i>';
                nextBtn.disabled = (currentPage === totalPages);
                nextBtn.onclick = () => { currentPage++; render(); };
                btnContainer.appendChild(nextBtn);
            }

            render();
        }

        // Setup Pagination for each tab
        document.addEventListener('DOMContentLoaded', () => {
            setupPagination('room-row', 'roomPaginationInfo', 'roomPaginationButtons', 5, 'phòng');
            setupPagination('type-row', 'typePaginationInfo', 'typePaginationButtons', 5, 'loại phòng');
            setupPagination('customer-row', 'customerPaginationInfo', 'customerPaginationButtons', 10, 'khách hàng');
            setupPagination('booking-row', 'bookingPaginationInfo', 'bookingPaginationButtons', 10, 'đơn');
        });

        // ==================== SEARCH BOOKINGS ====================
        function filterBookings() {
            const keyword = document.getElementById('bookingSearchInput').value.trim().toLowerCase();
            const rows = document.querySelectorAll('.booking-row');
            rows.forEach(r => {
                const code = r.getAttribute('data-code') || '';
                const name = r.getAttribute('data-name') || '';
                if (code.includes(keyword) || name.includes(keyword)) {
                    r.style.display = '';
                } else {
                    r.style.display = 'none';
                }
            });
        }

        // ==================== TAB 5: STATS CHART ENGINE ====================
        const allBookings = [
            <c:forEach var="b" items="${bookings}" varStatus="loop">
            {
                id: ${b.id},
                code: "${b.code}",
                guestName: "${b.guestName}",
                total: ${b.totalPrice},
                status: "${b.status}",
                payStatus: "${b.payStatus}",
                checkIn: "${b.checkIn}",
                checkOut: "${b.checkOut}",
                created: "${b.createdAt}"
            }${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        let revenueChart = null;

        function updateStatsChart() {
            const modeSelect = document.getElementById('statModeSelect');
            if (!modeSelect) return;

            const mode = modeSelect.value;
            const monthSelect = document.getElementById('statMonthSelect');
            const yearSelect = document.getElementById('statYearSelect');

            const selectedMonth = parseInt(monthSelect.value);
            const selectedYear = parseInt(yearSelect.value);

            // Ẩn/hiện dropdown tháng theo mode
            if (mode === 'month') {
                monthSelect.style.display = 'inline-block';
            } else {
                monthSelect.style.display = 'none';
            }

            // Chỉ tính các đơn đã hoàn tất trả phòng (checkedout)
            const checkedOutBookings = allBookings.filter(b => b.status === 'checkedout' && b.checkOut);

            let totalRev = 0;
            let compCount = 0;
            let labels = [];
            let chartValues = [];

            if (mode === 'month') {
                // Theo ngày trong tháng
                const daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate();
                const dayMap = {};
                for (let d = 1; d <= daysInMonth; d++) {
                    dayMap[d] = 0;
                }

                checkedOutBookings.forEach(b => {
                    const d = new Date(b.checkOut);
                    if (d.getFullYear() === selectedYear && (d.getMonth() + 1) === selectedMonth) {
                        const day = d.getDate();
                        const amount = Number(b.total) || 0;
                        dayMap[day] = (dayMap[day] || 0) + amount;
                        totalRev += amount;
                        compCount++;
                    }
                });

                labels = Object.keys(dayMap).map(d => d + '/' + selectedMonth);
                chartValues = Object.values(dayMap);

                document.getElementById('statRevenueLabel').innerText = 'Doanh thu T' + selectedMonth + '/' + selectedYear;
                document.getElementById('statChartTitle').innerText = 'Chi tiết doanh thu Tháng ' + selectedMonth + '/' + selectedYear + ' (Đơn vị: VNĐ)';
            } else {
                // Theo 12 tháng trong năm
                const monthMap = {};
                for (let m = 1; m <= 12; m++) {
                    monthMap[m] = 0;
                }

                checkedOutBookings.forEach(b => {
                    const d = new Date(b.checkOut);
                    if (d.getFullYear() === selectedYear) {
                        const m = d.getMonth() + 1;
                        const amount = Number(b.total) || 0;
                        monthMap[m] = (monthMap[m] || 0) + amount;
                        totalRev += amount;
                        compCount++;
                    }
                });

                labels = Object.keys(monthMap).map(m => 'Thg ' + m);
                chartValues = Object.values(monthMap);

                document.getElementById('statRevenueLabel').innerText = 'Doanh thu năm ' + selectedYear;
                document.getElementById('statChartTitle').innerText = 'Doanh thu 12 tháng năm ' + selectedYear + ' (Đơn vị: VNĐ)';
            }

            // Cập nhật 2 Cards thống kê
            document.getElementById('statRevenueValue').innerText = new Intl.NumberFormat('vi-VN').format(totalRev) + ' VNĐ';
            document.getElementById('statCompletedCount').innerText = compCount;

            // Render Chart.js
            const ctx = document.getElementById('revenueBarChart');
            if (!ctx) return;

            if (revenueChart) {
                revenueChart.destroy();
            }

            revenueChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: chartValues,
                        backgroundColor: '#10b981',
                        hoverBackgroundColor: '#059669',
                        borderRadius: 6,
                        maxBarThickness: 36
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.raw) + ' VNĐ';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { display: false }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    if (value >= 1000000) return (value / 1000000) + 'M';
                                    if (value >= 1000) return (value / 1000) + 'k';
                                    return value;
                                }
                            }
                        }
                    }
                }
            });
        }

        // Tự khởi chạy biểu đồ nếu đang ở Tab stats
        document.addEventListener('DOMContentLoaded', () => {
            const now = new Date();
            const currentMonth = now.getMonth() + 1;
            const monthSelect = document.getElementById('statMonthSelect');
            if (monthSelect) {
                monthSelect.value = currentMonth;
            }
            updateStatsChart();
        });
    </script>
</body>
</html>
