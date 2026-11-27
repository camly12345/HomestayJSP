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
            <c:remove var="adminSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.adminError}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div>${sessionScope.adminError}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="adminError" scope="session"/>
        </c:if>

        <!-- ==================== TAB 1: TỔNG QUAN ==================== -->
        <c:if test="${tab == 'overview'}">
            <%@include file="admin/tab_overview.jsp" %>
        </c:if>

        <!-- ==================== TAB 2: PHÒNG (DANH SÁCH & LOẠI PHÒNG) ==================== -->
        <c:if test="${tab == 'rooms'}">
            <%@include file="admin/tab_rooms.jsp" %>
        </c:if>

        <!-- ==================== TAB 3: KHÁCH HÀNG ==================== -->
        <c:if test="${tab == 'customers'}">
            <%@include file="admin/tab_customers.jsp" %>
        </c:if>

        <!-- ==================== TAB 4: ĐẶT PHÒNG ==================== -->
        <c:if test="${tab == 'bookings'}">
            <%@include file="admin/tab_bookings.jsp" %>
        </c:if>

        <!-- ==================== TAB 5: THỐNG KÊ ==================== -->
        <c:if test="${tab == 'stats'}">
            <%@include file="admin/tab_stats.jsp" %>
        </c:if>

    </main>

    <!-- ==================== MODALS ==================== -->
    <%@include file="admin/modals.jsp" %>

    <!-- ==================== SCRIPTS ==================== -->
    <%@include file="admin/scripts.jsp" %>

</body>
</html>
