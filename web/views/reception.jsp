<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title != null ? title : 'Bàn Lễ Tân - Núi Homestay'}</title>
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #10b981;
            --primary-dark: #059669;
            --dark-color: #0f172a;
            --light-bg: #f8fafc;
            --card-border: #e2e8f0;
            --status-coming: #ef4444;
            --status-staying: #f59e0b;
            --status-empty: #10b981;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: #334155;
            min-height: 100vh;
        }
        .reception-header {
            background-color: #059669;
            height: 56px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }
        .reception-brand {
            font-weight: 800;
            color: #ffffff !important;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1.05rem;
        }
        .btn-walkin {
            background-color: #f59e0b;
            color: #0f172a;
            font-weight: 700;
            font-size: 0.85rem;
            padding: 6px 14px;
            border-radius: 9999px;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-walkin:hover {
            background-color: #d97706;
            color: #ffffff;
        }
        .view-btn {
            background: transparent;
            color: #ffffff;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            text-decoration: none;
        }
        .view-btn:hover {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        .view-btn.active {
            background-color: #ffffff;
            color: #0f172a;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* Status Colors */
        .bg-status-empty { background-color: #10b981 !important; color: #ffffff !important; }
        .bg-status-staying { background-color: #f59e0b !important; color: #ffffff !important; }
        .bg-status-coming { background-color: #ef4444 !important; color: #ffffff !important; }

        .border-status-empty { border-color: #10b981 !important; }
        .border-status-staying { border-color: #f59e0b !important; }
        .border-status-coming { border-color: #ef4444 !important; }

        /* Grid Room Card */
        .room-grid-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-column: column;
            justify-content: space-between;
        }
        .room-grid-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        .room-grid-header {
            padding: 12px 16px;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .room-grid-body {
            padding: 16px;
        }
        .room-grid-footer {
            padding: 10px 16px;
            background-color: #f8fafc;
            border-top: 1px solid #f1f5f9;
        }

        /* Timeline View */
        .timeline-container {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            overflow-x: auto;
            position: relative;
        }
        .timeline-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }
        .timeline-table th, .timeline-table td {
            border: 1px solid #f1f5f9;
        }
        .timeline-cell-room {
            width: 140px;
            min-width: 140px;
            padding: 12px 14px;
            font-weight: 700;
            background: #ffffff;
            position: sticky;
            left: 0;
            z-index: 10;
            border-right: 2px solid #e2e8f0 !important;
            box-shadow: 2px 0 4px rgba(0,0,0,0.02);
        }
        .timeline-header-day {
            padding: 10px 4px;
            text-align: center;
            font-size: 0.75rem;
            font-weight: 600;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            border-right: 1px solid #e2e8f0;
        }
        .timeline-header-day.today {
            background-color: #ecfdf5;
            color: #059669;
            font-weight: 800;
        }
        .timeline-cell-day {
            border-bottom: 1px solid #f1f5f9;
            border-right: 1px solid #f1f5f9;
            height: 48px;
            position: relative;
            cursor: pointer;
            transition: background-color 0.15s;
        }
        .timeline-cell-day:hover {
            background-color: #fef08a; /* highlight on hover */
        }
        .timeline-cell-day.today {
            background-color: #f0fdf4;
        }
        .timeline-booking-bar {
            position: absolute;
            top: 6px;
            bottom: 6px;
            border-radius: 8px;
            padding: 2px 8px;
            font-size: 0.75rem;
            font-weight: 700;
            color: #ffffff;
            display: flex;
            align-items: center;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
            z-index: 5;
            cursor: pointer;
            transition: transform 0.15s;
        }
        .timeline-booking-bar:hover {
            transform: scaleY(1.08);
            z-index: 6;
        }

        /* Table Card */
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

    <!-- RECEPTION HEADER NAVBAR -->
    <header class="reception-header d-flex align-items-center justify-content-between px-3 px-md-4">
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/reception" class="reception-brand">
                <i class="bi bi-tree-fill text-warning fs-5"></i> Núi Homestay (Lễ Tân)
            </a>

            <!-- Nút Tạo đặt phòng trực tiếp -->
            <button type="button" class="btn btn-walkin" onclick="openWalkInModal()">
                <i class="bi bi-person-plus-fill"></i> Đặt phòng trực tiếp
            </button>
        </div>

        <div class="d-flex align-items-center gap-2">
            <!-- View Switcher -->
            <div class="d-flex bg-black bg-opacity-20 rounded-3 p-1">
                <a href="${pageContext.request.contextPath}/reception?view=grid" class="view-btn ${view == 'grid' ? 'active' : ''}" title="Sơ đồ phòng (Lưới)">
                    <i class="bi bi-grid-fill fs-6"></i>
                </a>
                <a href="${pageContext.request.contextPath}/reception?view=timeline" class="view-btn ${view == 'timeline' ? 'active' : ''}" title="Dòng thời gian (Timeline)">
                    <i class="bi bi-calendar2-range-fill fs-6"></i>
                </a>
                <a href="${pageContext.request.contextPath}/reception?view=table" class="view-btn ${view == 'table' ? 'active' : ''}" title="Danh sách đặt phòng (Bảng)">
                    <i class="bi bi-table fs-6"></i>
                </a>
            </div>

            <div class="vr bg-white bg-opacity-25 my-2 mx-1" style="height: 24px;"></div>

            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light rounded-pill px-3 py-1 d-flex align-items-center gap-1 small">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </div>
    </header>

    <!-- MAIN BODY -->
    <main class="container-fluid max-w-7xl px-3 px-md-4 py-4" style="max-width: 1300px; margin: 0 auto;">

        <!-- Alert messages -->
        <c:if test="${not empty sessionScope.receptionSuccess}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 border-0 shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div>${sessionScope.receptionSuccess}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("receptionSuccess"); %>
        </c:if>
        <c:if test="${not empty sessionScope.receptionError}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div>${sessionScope.receptionError}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("receptionError"); %>
        </c:if>

        <!-- STATUS LEGEND CARD -->
        <div class="admin-card p-3 mb-4">
            <div class="d-flex flex-wrap align-items-center gap-4 text-sm">
                <span class="fw-bold text-dark"><i class="bi bi-info-circle me-1 text-success"></i> Trạng thái phòng:</span>
                <span class="d-flex align-items-center gap-2">
                    <span class="badge bg-status-empty rounded-pill px-2.5 py-1">Phòng trống</span>
                </span>
                <span class="d-flex align-items-center gap-2">
                    <span class="badge bg-status-staying rounded-pill px-2.5 py-1">Đang ở</span>
                </span>
                <span class="d-flex align-items-center gap-2">
                    <span class="badge bg-status-coming rounded-pill px-2.5 py-1">Sắp đến</span>
                </span>
            </div>
        </div>

        <!-- ==================== VIEW 1: SƠ ĐỒ PHÒNG (GRID VIEW) ==================== -->
        <c:if test="${view == 'grid'}">
            <%@include file="reception/view_grid.jsp" %>
        </c:if>

        <!-- ==================== VIEW 2: DÒNG THỜI GIAN (TIMELINE VIEW) ==================== -->
        <c:if test="${view == 'timeline'}">
            <%@include file="reception/view_timeline.jsp" %>
        </c:if>

        <!-- ==================== VIEW 3: DANH SÁCH BẢNG (TABLE VIEW) ==================== -->
        <c:if test="${view == 'table'}">
            <%@include file="reception/view_table.jsp" %>
        </c:if>

    </main>

    <!-- ==================== MODAL 1: CHI TIẾT ĐẶT PHÒNG ==================== -->
    <%@include file="reception/modal_detail.jsp" %>

    <!-- ==================== MODAL 2: ĐẶT PHÒNG TRỰC TIẾP (WALK-IN) ==================== -->
    <%@include file="reception/modal_walkin.jsp" %>

    <!-- ==================== SCRIPTS ==================== -->
    <%@include file="reception/scripts.jsp" %>

</body>
</html>
