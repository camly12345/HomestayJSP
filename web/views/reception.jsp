<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title != null ? title : 'Bàn Làm Việc Lễ Tân - Núi Homestay'}</title>
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
            --primary: #0ea5e9;
            --primary-dark: #0284c7;
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
            background-color: #0284c7;
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
        .view-btn {
            color: #ffffff;
            border-radius: 8px;
            padding: 6px 10px;
            transition: all 0.2s;
            border: none;
            background: transparent;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .view-btn:hover {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        .view-btn.active {
            background-color: rgba(255, 255, 255, 0.28);
            color: #ffffff;
            font-weight: bold;
        }
        .btn-walkin {
            background-color: #f59e0b;
            color: #000000;
            font-weight: 700;
            border: none;
            padding: 6px 14px;
            border-radius: 9999px;
            font-size: 0.825rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12);
            transition: all 0.2s;
        }
        .btn-walkin:hover {
            background-color: #d97706;
            color: #ffffff;
        }
        .admin-card {
            background: #ffffff;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            overflow: hidden;
        }
        /* Room Grid Styles */
        .room-grid-card {
            border: 1px solid var(--card-border);
            border-radius: 14px;
            overflow: hidden;
            background: #ffffff;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .room-grid-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.06);
        }
        .room-grid-header {
            padding: 8px 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .room-grid-body {
            padding: 14px;
        }
        .room-grid-footer {
            padding: 10px 14px 14px;
        }
        /* Status Colors */
        .bg-status-empty { background-color: #10b981; color: #ffffff; }
        .bg-status-staying { background-color: #f59e0b; color: #000000; }
        .bg-status-coming { background-color: #ef4444; color: #ffffff; }

        /* Timeline Styles */
        .timeline-container {
            overflow-x: auto;
            border: 1px solid var(--card-border);
            border-radius: 14px;
            background: #ffffff;
            user-select: none;
        }
        .timeline-table {
            border-collapse: separate;
            border-spacing: 0;
            min-width: 900px;
            width: 100%;
        }
        .timeline-cell-room {
            width: 130px;
            min-width: 130px;
            max-width: 130px;
            padding: 10px 14px;
            font-weight: 700;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            border-right: 1px solid #e2e8f0;
            position: sticky;
            left: 0;
            z-index: 2;
        }
        .timeline-header-day {
            padding: 8px 4px;
            text-align: center;
            font-size: 0.8rem;
            font-weight: 600;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            border-right: 1px solid #e2e8f0;
        }
        .timeline-header-day.today {
            background-color: #e0f2fe;
            color: #0284c7;
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
            border-radius: 6px;
            padding: 2px 8px;
            font-size: 0.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            z-index: 10;
            cursor: pointer;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12);
            transition: opacity 0.15s;
        }
        .timeline-booking-bar:hover {
            opacity: 0.9;
        }
        /* Pagination */
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
            background-color: #0ea5e9;
            color: #ffffff;
            border-color: #0ea5e9;
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
                <span class="fw-bold text-dark"><i class="bi bi-info-circle me-1 text-primary"></i> Trạng thái phòng:</span>
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
            <div class="row g-3" id="roomGridContainer">
                <c:forEach var="rm" items="${rooms}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="room-grid-card h-100" id="gridCard_${rm.id}">
                            <div>
                                <!-- Header will be updated via JS based on booking status today -->
                                <div class="room-grid-header bg-status-empty" id="gridHeader_${rm.id}">
                                    <span class="fs-5">${rm.code}</span>
                                    <span class="small fw-semibold" id="gridStatusText_${rm.id}">PHÒNG TRỐNG</span>
                                </div>
                                <div class="room-grid-body">
                                    <p class="text-muted small mb-1">${rm.roomTypeName}</p>
                                    <p class="fw-bold text-success mb-2">
                                        <fmt:formatNumber value="${rm.price}" pattern="#,###" /> VNĐ/ngày
                                    </p>
                                    <div class="small" id="gridGuestInfo_${rm.id}">
                                        <span class="text-muted"><i class="bi bi-door-open me-1"></i> Phòng sẵn sàng</span>
                                    </div>
                                </div>
                            </div>
                            <div class="room-grid-footer" id="gridFooter_${rm.id}">
                                <button type="button" class="btn btn-sm btn-outline-success w-100 fw-bold" onclick="openWalkInForRoom(${rm.id}, '${rm.code}')">
                                    <i class="bi bi-plus-circle me-1"></i> Tạo đặt phòng
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- ==================== VIEW 2: DÒNG THỜI GIAN (TIMELINE VIEW) ==================== -->
        <c:if test="${view == 'timeline'}">
            <!-- Timeline Navigation Controls -->
            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-3">
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-light border fw-semibold" onclick="shiftTimeline(-7)">
                        <i class="bi bi-chevron-left"></i> Tuần trước
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-primary fw-bold" onclick="resetTimelineToToday()">
                        Hôm nay
                    </button>
                    <button type="button" class="btn btn-sm btn-light border fw-semibold" onclick="shiftTimeline(7)">
                        Tuần sau <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
                <div class="fw-bold text-dark" id="timelineRangeText">
                    <!-- Updated via JS: e.g. 24/11/2026 – 07/12/2026 -->
                </div>
            </div>

            <!-- Timeline Board -->
            <div class="timeline-container shadow-sm mb-4">
                <table class="timeline-table" id="timelineTable">
                    <thead>
                        <tr id="timelineHeaderRow">
                            <th class="timeline-cell-room">Phòng</th>
                            <!-- 14 day headers generated dynamically via JS -->
                        </tr>
                    </thead>
                    <tbody id="timelineBody">
                        <!-- Rows generated dynamically via JS -->
                    </tbody>
                </table>
            </div>
        </c:if>

        <!-- ==================== VIEW 3: DANH SÁCH BẢNG (TABLE VIEW) ==================== -->
        <c:if test="${view == 'table'}">
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
                                    <td class="fw-bold text-primary">${b.code}</td>
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
                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1" onclick="showBookingDetailById(${b.id})">
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
        </c:if>
    </main>

    <!-- ==================== MODAL 1: CHI TIẾT ĐẶT PHÒNG ==================== -->
    <div class="modal fade" id="bookingDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold" id="detailModalTitle">Chi tiết đơn đặt phòng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-3">
                    <!-- Thông tin phòng & khách -->
                    <div class="bg-light p-3 rounded-3 mb-3 border">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fs-5 fw-bold text-primary" id="detailBookingCode">BK0000</span>
                            <span class="badge" id="detailStatusBadge">Đang ở</span>
                        </div>
                        <div class="row g-2 small">
                            <div class="col-6"><span class="text-muted">Phòng:</span> <strong id="detailRoomCode">P101</strong></div>
                            <div class="col-6"><span class="text-muted">Loại:</span> <strong id="detailRoomType">Phòng đơn</strong></div>
                            <div class="col-12"><span class="text-muted">Khách ở:</span> <strong id="detailGuestName">Nguyễn Văn A</strong> (<span id="detailGuestPhone">0912345678</span>)</div>
                            <div class="col-12" id="detailEmailWrapper"><span class="text-muted">Email:</span> <span id="detailGuestEmail">email@domain.com</span></div>
                            <div class="col-12" id="detailAddressWrapper"><span class="text-muted">Địa chỉ:</span> <span id="detailGuestAddress">TP. Huế</span></div>
                        </div>
                    </div>

                    <!-- Thời gian & Chi phí -->
                    <div class="border rounded-3 p-3 mb-3">
                        <div class="d-flex justify-content-between text-sm mb-1">
                            <span class="text-muted">Nhận phòng:</span>
                            <strong id="detailCheckIn">24/11/2026</strong>
                        </div>
                        <div class="d-flex justify-content-between text-sm mb-1">
                            <span class="text-muted">Trả phòng:</span>
                            <strong id="detailCheckOut">25/11/2026</strong>
                        </div>
                        <div class="d-flex justify-content-between text-sm mb-2">
                            <span class="text-muted">Số đêm lưu trú:</span>
                            <span id="detailNights">1 đêm (2 khách)</span>
                        </div>
                        <div class="d-flex justify-content-between text-sm mb-1 pt-2 border-top">
                            <span class="text-muted">Hình thức thanh toán:</span>
                            <strong id="detailPayMethod">Tiền mặt</strong>
                        </div>
                        <div class="d-flex justify-content-between text-sm mb-2">
                            <span class="text-muted">Trạng thái thanh toán:</span>
                            <span id="detailPayStatus" class="fw-bold text-success">Đã thanh toán</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                            <span class="fw-bold">Tổng tiền:</span>
                            <span class="fs-5 fw-extrabold text-primary" id="detailTotalPrice">650,000 VNĐ</span>
                        </div>
                    </div>

                    <!-- Ghi chú nếu có -->
                    <div class="mb-2" id="detailNoteWrapper">
                        <label class="form-label small fw-semibold text-muted">Ghi chú của khách:</label>
                        <div class="small p-2 bg-light rounded border text-muted" id="detailNote">Không có ghi chú.</div>
                    </div>

                    <!-- Cảnh báo khi chưa đến ngày nhận phòng -->
                    <div class="alert alert-warning py-2 px-3 small rounded-3 mb-0 d-none" id="checkInDateWarning">
                        <i class="bi bi-clock-history me-1"></i> <strong>Chưa đến ngày nhận phòng:</strong> Chỉ được xác nhận khi đến hoặc qua ngày nhận phòng (<span id="warnCheckInDate"></span>).
                    </div>
                </div>

                <div class="modal-footer border-top-0 pt-0 d-flex gap-2" id="detailActionFooter">
                    <!-- Action buttons injected dynamically based on booking status & checkIn date -->
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== MODAL 2: ĐẶT PHÒNG TRỰC TIẾP (WALK-IN) ==================== -->
    <div class="modal fade" id="walkInModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/reception" method="POST" id="formWalkIn">
                    <input type="hidden" name="action" value="walkInBooking">
                    <input type="hidden" name="view" value="${view}">
                    <div class="modal-header border-bottom-0 pb-0">
                        <h5 class="modal-title fw-bold text-primary">
                            <i class="bi bi-person-plus-fill me-1"></i> Đặt phòng cho khách trực tiếp
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body pt-3">
                        <!-- Alert kiểm tra trùng lịch realtime -->
                        <div class="alert alert-danger py-2 px-3 small rounded-3 mb-3 d-none" id="conflictAlert">
                            <i class="bi bi-exclamation-octagon-fill me-1"></i> <span id="conflictAlertMsg">Phòng này đã có khách đặt trong khoảng thời gian đã chọn! Vui lòng chọn khoảng ngày hoặc phòng khác.</span>
                        </div>

                        <!-- SECTION 1: LƯU TRÚ -->
                        <h6 class="fw-bold text-secondary text-uppercase small mb-3">1. Thông tin lưu trú</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Chọn phòng *</label>
                                <select name="roomId" id="walkInRoomSelect" class="form-select" required onchange="calculateWalkInPrice()">
                                    <c:forEach var="rm" items="${rooms}">
                                        <option value="${rm.id}" data-price="${rm.price}" data-code="${rm.code}" data-type="${rm.roomTypeName}">
                                            Phòng ${rm.code} (${rm.roomTypeName}) - <fmt:formatNumber value="${rm.price}" pattern="#,###" /> đ
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Số lượng khách</label>
                                <input type="number" name="guests" id="walkInGuests" class="form-control" value="1" min="1" max="10" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Ngày nhận phòng *</label>
                                <input type="date" name="checkIn" id="walkInCheckIn" class="form-control" value="${today}" required onchange="validateWalkInDates()">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Ngày trả phòng *</label>
                                <input type="date" name="checkOut" id="walkInCheckOut" class="form-control" required onchange="validateWalkInDates()">
                            </div>
                        </div>

                        <!-- SECTION 2: KHÁCH HÀNG -->
                        <h6 class="fw-bold text-secondary text-uppercase small mb-3">2. Thông tin khách hàng</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Họ và tên khách *</label>
                                <input type="text" name="guestName" class="form-control" placeholder="Nguyễn Văn A" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Số điện thoại *</label>
                                <input type="tel" name="guestPhone" class="form-control" placeholder="0912345678" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Email (nếu có)</label>
                                <input type="email" name="guestEmail" class="form-control" placeholder="khach@gmail.com">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Địa chỉ</label>
                                <input type="text" name="guestAddress" class="form-control" placeholder="TP. Huế">
                            </div>
                        </div>

                        <!-- SECTION 3: THANH TOÁN & TẠM TÍNH -->
                        <h6 class="fw-bold text-secondary text-uppercase small mb-3">3. Thanh toán & Trạng thái</h6>
                        <div class="row g-3">
                            <div class="col-md-5">
                                <div class="bg-light p-3 rounded-3 border h-100 d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span>Đơn giá:</span>
                                            <strong id="walkInUnitPriceText">0 VNĐ</strong>
                                        </div>
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span>Thời gian:</span>
                                            <strong id="walkInNightsText">1 Ngày</strong>
                                        </div>
                                    </div>
                                    <div class="pt-2 border-top d-flex justify-content-between align-items-baseline">
                                        <span class="fw-bold small">Tạm tính:</span>
                                        <span class="fs-5 fw-extrabold text-success" id="walkInTotalPriceText">0 VNĐ</span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-7">
                                <div class="row g-2 mb-2">
                                    <div class="col-6">
                                        <label class="form-label small fw-semibold text-secondary">Hình thức</label>
                                        <select name="payMethod" class="form-select">
                                            <option value="cash">Tiền mặt</option>
                                            <option value="transfer">Chuyển khoản</option>
                                        </select>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label small fw-semibold text-secondary">Thanh toán</label>
                                        <select name="payStatus" class="form-select">
                                            <option value="paid" selected>Đã thanh toán</option>
                                            <option value="unpaid">Chưa thanh toán</option>
                                        </select>
                                    </div>
                                    <div class="col-12 mt-2">
                                        <label class="form-label small fw-semibold text-secondary">Trạng thái nhận phòng</label>
                                        <select name="status" class="form-select">
                                            <option value="checkedin" selected>Nhận phòng ngay (Đang ở)</option>
                                            <option value="confirmed">Chờ khách đến (Đã xác nhận)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mt-2">
                                    <input type="text" name="note" class="form-control small" placeholder="Ghi chú thêm (yêu cầu riêng...)">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer border-top-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold" id="btnSubmitWalkIn">Xác nhận đặt phòng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Engine for Reception -->
    <script>
        const todayStr = "${today}"; // e.g. "2026-11-24"

        // Danh sách phòng
        const roomsList = [
            <c:forEach var="r" items="${rooms}" varStatus="loop">
            {
                id: ${r.id},
                code: "${r.code}",
                roomTypeId: ${r.roomTypeId},
                typeName: "${r.roomTypeName}",
                price: ${r.price},
                area: "${r.area}",
                status: ${r.status}
            }${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        // Danh sách đơn đặt phòng
        const bookingsList = [
            <c:forEach var="b" items="${bookings}" varStatus="loop">
            {
                id: ${b.id},
                code: "${b.code}",
                roomId: ${b.roomId != null ? b.roomId : 'null'},
                roomCode: "${b.roomCode != null ? b.roomCode : ''}",
                roomTypeName: "${b.roomTypeName}",
                guestName: "${b.guestName}",
                guestPhone: "${b.guestPhone}",
                guestEmail: "${b.guestEmail != null ? b.guestEmail : ''}",
                address: "${b.address != null ? b.address : ''}",
                checkIn: "${b.checkIn}",
                checkOut: "${b.checkOut}",
                guests: ${b.guests},
                totalPrice: ${b.totalPrice},
                formattedTotal: "${b.formattedTotal}",
                payStatus: "${b.payStatus}",
                payMethod: "${b.payMethod}",
                status: "${b.status}",
                note: "${b.note != null ? b.note : ''}"
            }${!loop.last ? ',' : ''}
            </c:forEach>
        ];

        // ==================== 1. POPULATE GRID VIEW STATUS TODAY ====================
        function populateGridView() {
            roomsList.forEach(r => {
                const header = document.getElementById("gridHeader_" + r.id);
                const statusText = document.getElementById("gridStatusText_" + r.id);
                const guestInfo = document.getElementById("gridGuestInfo_" + r.id);
                const footer = document.getElementById("gridFooter_" + r.id);

                if (!header) return;

                // Tìm booking của phòng này bao trùm hôm nay
                const activeBooking = bookingsList.find(b => {
                    if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                    if (b.status === 'cancelled' || b.status === 'checkedout') return false;
                    return (b.checkIn <= todayStr && b.checkOut > todayStr);
                });

                // Tìm booking sắp đến hôm nay (checkIn == todayStr)
                const comingBooking = bookingsList.find(b => {
                    if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                    if (b.status === 'cancelled' || b.status === 'checkedout') return false;
                    return (b.checkIn === todayStr && b.status !== 'checkedin');
                });

                if (activeBooking && activeBooking.status === 'checkedin') {
                    // Đang ở (Amber/Yellow)
                    header.className = "room-grid-header bg-status-staying";
                    statusText.innerText = "ĐANG Ở";
                    guestInfo.innerHTML = '<span class="fw-bold text-dark"><i class="bi bi-person-fill me-1"></i> ' + activeBooking.guestName + '</span>';
                    footer.innerHTML = '<button type="button" class="btn btn-sm btn-dark w-100 fw-bold" onclick="showBookingDetailById(' + activeBooking.id + ')">Xem chi tiết</button>';
                } else if (comingBooking || (activeBooking && activeBooking.status !== 'checkedin')) {
                    // Sắp đến (Red)
                    const bk = comingBooking || activeBooking;
                    header.className = "room-grid-header bg-status-coming";
                    statusText.innerText = "SẮP ĐẾN";
                    guestInfo.innerHTML = '<span class="fw-bold text-danger"><i class="bi bi-person-fill me-1"></i> ' + bk.guestName + '</span>';
                    footer.innerHTML = '<button type="button" class="btn btn-sm btn-danger w-100 fw-bold" onclick="showBookingDetailById(' + bk.id + ')">Xem chi tiết</button>';
                } else {
                    // Trống (Green)
                    header.className = "room-grid-header bg-status-empty";
                    statusText.innerText = "PHÒNG TRỐNG";
                    guestInfo.innerHTML = '<span class="text-muted"><i class="bi bi-door-open me-1"></i> Phòng sẵn sàng</span>';
                    footer.innerHTML = '<button type="button" class="btn btn-sm btn-outline-success w-100 fw-bold" onclick="openWalkInForRoom(' + r.id + ', \'' + r.code + '\')"><i class="bi bi-plus-circle me-1"></i> Tạo đặt phòng</button>';
                }
            });
        }

        // ==================== 2. TIMELINE VIEW ENGINE ====================
        let timelineStartDate = new Date();
        timelineStartDate.setHours(0, 0, 0, 0);

        function formatDateYYYYMMDD(d) {
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + day;
        }

        function renderTimeline() {
            const headerRow = document.getElementById("timelineHeaderRow");
            const tbody = document.getElementById("timelineBody");
            const rangeText = document.getElementById("timelineRangeText");

            if (!headerRow || !tbody) return;

            // Generate 14 days
            const daysCount = 14;
            const days = [];
            for (let i = 0; i < daysCount; i++) {
                const cur = new Date(timelineStartDate);
                cur.setDate(cur.getDate() + i);
                days.push(cur);
            }

            // Update range text
            const first = days[0];
            const last = days[daysCount - 1];
            rangeText.innerText = first.getDate() + '/' + (first.getMonth() + 1) + '/' + first.getFullYear() + ' – ' + last.getDate() + '/' + (last.getMonth() + 1) + '/' + last.getFullYear();

            // Render Header
            headerRow.innerHTML = '<th class="timeline-cell-room">Phòng</th>';
            days.forEach(d => {
                const dateStr = formatDateYYYYMMDD(d);
                const isToday = (dateStr === todayStr);
                const th = document.createElement("th");
                th.className = "timeline-header-day" + (isToday ? " today" : "");
                th.innerHTML = '<div class="small">' + (d.getDate() + '/' + (d.getMonth() + 1)) + '</div><div class="text-xs text-muted" style="font-size: 10px;">' + (isToday ? 'Hôm nay' : 'T' + (d.getDay() === 0 ? 'CN' : d.getDay() + 1)) + '</div>';
                headerRow.appendChild(th);
            });

            // Render Rows for each room
            tbody.innerHTML = '';
            roomsList.forEach(r => {
                const tr = document.createElement("tr");

                // Cột Tên phòng
                const tdRoom = document.createElement("td");
                tdRoom.className = "timeline-cell-room";
                tdRoom.innerHTML = '<div class="text-dark">' + r.code + '</div><div class="text-muted text-xs" style="font-size: 11px;">' + r.typeName + '</div>';
                tr.appendChild(tdRoom);

                // Cột bao trùm 14 ngày (relative container)
                const tdDaysContainer = document.createElement("td");
                tdDaysContainer.colSpan = daysCount;
                tdDaysContainer.className = "p-0 position-relative";
                tdDaysContainer.style.height = "52px";

                // Sub-grid chứa 14 ô ngày
                const subGrid = document.createElement("div");
                subGrid.className = "d-flex h-100 w-100";

                days.forEach(d => {
                    const dateStr = formatDateYYYYMMDD(d);
                    const isToday = (dateStr === todayStr);
                    const dayCell = document.createElement("div");
                    dayCell.className = "flex-fill timeline-cell-day" + (isToday ? " today" : "");
                    dayCell.title = "Bấm để đặt phòng " + r.code + " ngày " + dateStr;
                    dayCell.onclick = () => {
                        const nextDay = new Date(d);
                        nextDay.setDate(nextDay.getDate() + 1);
                        openWalkInWithDates(r.id, r.code, dateStr, formatDateYYYYMMDD(nextDay));
                    };
                    subGrid.appendChild(dayCell);
                });
                tdDaysContainer.appendChild(subGrid);

                // Vẽ các thanh booking nằm vắt qua các ngày của phòng này
                const roomBookings = bookingsList.filter(b => {
                    if (b.roomId !== r.id && b.roomCode !== r.code) return false;
                    return b.status !== 'cancelled' && b.status !== 'checkedout';
                });

                const startTimelineMs = days[0].getTime();
                const oneDayMs = 24 * 60 * 60 * 1000;

                roomBookings.forEach(b => {
                    const bIn = new Date(b.checkIn).getTime();
                    const bOut = new Date(b.checkOut).getTime();

                    const dayOffsetIn = Math.round((bIn - startTimelineMs) / oneDayMs);
                    const dayOffsetOut = Math.round((bOut - startTimelineMs) / oneDayMs);

                    if (dayOffsetOut <= 0 || dayOffsetIn >= daysCount) return; // Nằm ngoài phạm vi 14 ngày

                    const startCol = Math.max(0, dayOffsetIn);
                    const endCol = Math.min(daysCount, dayOffsetOut);
                    const durationCols = endCol - startCol;

                    const leftPercent = (startCol / daysCount) * 100;
                    const widthPercent = (durationCols / daysCount) * 100;

                    const isStaying = (b.status === 'checkedin');
                    const bgClass = isStaying ? 'bg-status-staying' : 'bg-status-coming';

                    const bar = document.createElement("div");
                    bar.className = "timeline-booking-bar " + bgClass;
                    bar.style.left = leftPercent + "%";
                    bar.style.width = widthPercent + "%";
                    bar.innerHTML = '<span class="truncate">' + b.code + ' · ' + b.guestName + '</span>';
                    bar.title = b.code + " - " + b.guestName + " (" + b.checkIn + " → " + b.checkOut + ")";
                    bar.onclick = (e) => {
                        e.stopPropagation();
                        showBookingDetailById(b.id);
                    };

                    tdDaysContainer.appendChild(bar);
                });

                tr.appendChild(tdDaysContainer);
                tbody.appendChild(tr);
            });
        }

        function shiftTimeline(deltaDays) {
            timelineStartDate.setDate(timelineStartDate.getDate() + deltaDays);
            renderTimeline();
        }

        function resetTimelineToToday() {
            timelineStartDate = new Date();
            timelineStartDate.setHours(0, 0, 0, 0);
            renderTimeline();
        }

        // ==================== 3. MODAL CHI TIẾT ĐẶT PHÒNG ====================
        function showBookingDetailById(bookingId) {
            const b = bookingsList.find(x => x.id === bookingId);
            if (!b) return;

            document.getElementById("detailBookingCode").innerText = b.code;
            document.getElementById("detailRoomCode").innerText = b.roomCode || b.roomId || "Chưa gán";
            document.getElementById("detailRoomType").innerText = b.roomTypeName;
            document.getElementById("detailGuestName").innerText = b.guestName;
            document.getElementById("detailGuestPhone").innerText = b.guestPhone;

            // Email & Address
            if (b.guestEmail && b.guestEmail.trim() !== '') {
                document.getElementById("detailEmailWrapper").style.display = '';
                document.getElementById("detailGuestEmail").innerText = b.guestEmail;
            } else {
                document.getElementById("detailEmailWrapper").style.display = 'none';
            }

            if (b.address && b.address.trim() !== '') {
                document.getElementById("detailAddressWrapper").style.display = '';
                document.getElementById("detailGuestAddress").innerText = b.address;
            } else {
                document.getElementById("detailAddressWrapper").style.display = 'none';
            }

            document.getElementById("detailCheckIn").innerText = b.checkIn;
            document.getElementById("detailCheckOut").innerText = b.checkOut;
            document.getElementById("detailTotalPrice").innerText = b.formattedTotal;
            document.getElementById("detailPayMethod").innerText = (b.payMethod === 'transfer' ? 'Chuyển khoản' : 'Tiền mặt');
            document.getElementById("detailPayStatus").innerText = (b.payStatus === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán');
            document.getElementById("detailPayStatus").className = (b.payStatus === 'paid' ? 'fw-bold text-success' : 'fw-bold text-danger');

            // Ghi chú
            if (b.note && b.note.trim() !== '') {
                document.getElementById("detailNoteWrapper").style.display = '';
                document.getElementById("detailNote").innerText = b.note;
            } else {
                document.getElementById("detailNoteWrapper").style.display = 'none';
            }

            // Trạng thái Badge
            const badge = document.getElementById("detailStatusBadge");
            if (b.status === 'checkedin') {
                badge.className = "badge bg-status-staying";
                badge.innerText = "ĐANG Ở";
            } else if (b.status === 'checkedout') {
                badge.className = "badge bg-secondary";
                badge.innerText = "ĐÃ TRẢ PHÒNG";
            } else if (b.status === 'cancelled') {
                badge.className = "badge bg-dark";
                badge.innerText = "ĐÃ HỦY";
            } else {
                badge.className = "badge bg-status-coming";
                badge.innerText = "ĐÃ XÁC NHẬN";
            }

            // So sánh ngày nhận phòng với ngày hôm nay: today >= checkIn
            const canCheckIn = (todayStr >= b.checkIn);
            const warnBox = document.getElementById("checkInDateWarning");
            if (!canCheckIn && b.status !== 'checkedin' && b.status !== 'checkedout' && b.status !== 'cancelled') {
                warnBox.classList.remove('d-none');
                document.getElementById("warnCheckInDate").innerText = b.checkIn;
            } else {
                warnBox.classList.add('d-none');
            }

            // Các nút hành động nghiệp vụ
            const footer = document.getElementById("detailActionFooter");
            footer.innerHTML = '';

            if (b.status === 'pending' || b.status === 'confirmed') {
                // Nút Nhận phòng: khi đã đến ngày nhận phòng thì mới cho nhấn, chưa đến thì disabled
                const checkInBtnHtml = `
                    <form action="${pageContext.request.contextPath}/reception" method="POST" class="flex-fill">
                        <input type="hidden" name="action" value="checkIn">
                        <input type="hidden" name="bookingId" value="` + b.id + `">
                        <input type="hidden" name="view" value="${view}">
                        <button type="submit" class="btn btn-warning w-100 fw-bold shadow-sm" ` + (!canCheckIn ? 'disabled title="Chưa đến ngày nhận phòng"' : '') + `>
                            <i class="bi bi-check-circle-fill me-1"></i> Nhận phòng
                        </button>
                    </form>
                `;

                // Nút Hủy đặt
                const cancelBtnHtml = `
                    <form action="${pageContext.request.contextPath}/reception" method="POST" class="flex-fill" onsubmit="return confirm('Xác nhận hủy đơn đặt phòng này?');">
                        <input type="hidden" name="action" value="cancelBooking">
                        <input type="hidden" name="bookingId" value="` + b.id + `">
                        <input type="hidden" name="view" value="${view}">
                        <button type="submit" class="btn btn-outline-danger w-100 fw-bold">
                            <i class="bi bi-x-circle-fill me-1"></i> Hủy đặt
                        </button>
                    </form>
                `;

                footer.innerHTML = checkInBtnHtml + cancelBtnHtml;

            } else if (b.status === 'checkedin') {
                // Nút Trả phòng & Thanh toán
                footer.innerHTML = `
                    <form action="${pageContext.request.contextPath}/reception" method="POST" class="w-100" onsubmit="return confirm('Xác nhận trả phòng và thu tiền hoàn tất?');">
                        <input type="hidden" name="action" value="checkOut">
                        <input type="hidden" name="bookingId" value="` + b.id + `">
                        <input type="hidden" name="view" value="${view}">
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">
                            <i class="bi bi-box-arrow-right me-1"></i> Trả phòng & Thanh toán
                        </button>
                    </form>
                `;
            } else {
                footer.innerHTML = '<button type="button" class="btn btn-light rounded-pill px-4 ms-auto" data-bs-dismiss="modal">Đóng</button>';
            }

            new bootstrap.Modal(document.getElementById("bookingDetailModal")).show();
        }

        // ==================== 4. MODAL ĐẶT PHÒNG TRỰC TIẾP (WALK-IN) ====================
        function openWalkInModal() {
            // Thiết lập mặc định
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);

            document.getElementById("walkInCheckIn").value = todayStr;
            document.getElementById("walkInCheckOut").value = formatDateYYYYMMDD(tomorrow);
            document.getElementById("walkInCheckIn").min = todayStr;
            document.getElementById("walkInCheckOut").min = todayStr;

            calculateWalkInPrice();
            validateWalkInDates();

            new bootstrap.Modal(document.getElementById("walkInModal")).show();
        }

        function openWalkInForRoom(roomId, roomCode) {
            openWalkInModal();
            document.getElementById("walkInRoomSelect").value = roomId;
            calculateWalkInPrice();
            validateWalkInDates();
        }

        function openWalkInWithDates(roomId, roomCode, checkIn, checkOut) {
            openWalkInModal();
            document.getElementById("walkInRoomSelect").value = roomId;
            document.getElementById("walkInCheckIn").value = checkIn;
            document.getElementById("walkInCheckOut").value = checkOut;
            calculateWalkInPrice();
            validateWalkInDates();
        }

        function calculateWalkInPrice() {
            const roomSelect = document.getElementById("walkInRoomSelect");
            const selectedOpt = roomSelect.options[roomSelect.selectedIndex];
            const price = parseFloat(selectedOpt.getAttribute("data-price")) || 0;

            const checkInVal = document.getElementById("walkInCheckIn").value;
            const checkOutVal = document.getElementById("walkInCheckOut").value;

            let nights = 1;
            if (checkInVal && checkOutVal) {
                const d1 = new Date(checkInVal);
                const d2 = new Date(checkOutVal);
                const diffTime = d2.getTime() - d1.getTime();
                nights = Math.max(1, Math.round(diffTime / (1000 * 60 * 60 * 24)));
            }

            const total = price * nights;

            document.getElementById("walkInUnitPriceText").innerText = new Intl.NumberFormat('vi-VN').format(price) + ' VNĐ';
            document.getElementById("walkInNightsText").innerText = nights + ' Ngày';
            document.getElementById("walkInTotalPriceText").innerText = new Intl.NumberFormat('vi-VN').format(total) + ' VNĐ';
        }

        function validateWalkInDates() {
            const checkInInput = document.getElementById("walkInCheckIn");
            const checkOutInput = document.getElementById("walkInCheckOut");
            const checkInVal = checkInInput.value;
            const checkOutVal = checkOutInput.value;
            const roomSelect = document.getElementById("walkInRoomSelect");
            const roomId = parseInt(roomSelect.value);

            const conflictAlert = document.getElementById("conflictAlert");
            const conflictMsg = document.getElementById("conflictAlertMsg");
            const submitBtn = document.getElementById("btnSubmitWalkIn");

            calculateWalkInPrice();

            if (!checkInVal || !checkOutVal) return;

            // Kiểm tra ngày trả phải sau ngày nhận
            if (checkOutVal <= checkInVal) {
                conflictAlert.classList.remove('d-none');
                conflictMsg.innerText = "Ngày trả phòng phải sau ngày nhận phòng!";
                submitBtn.disabled = true;
                return;
            }

            // Kiểm tra xem phòng có bị trùng với đơn nào trong bookingsList không
            const hasConflict = bookingsList.some(b => {
                if (b.roomId !== roomId) return false;
                if (b.status === 'cancelled' || b.status === 'checkedout') return false;
                return (b.checkIn < checkOutVal && b.checkOut > checkInVal);
            });

            if (hasConflict) {
                conflictAlert.classList.remove('d-none');
                conflictMsg.innerText = "Phòng đã có khách đặt trong khoảng thời gian này! Vui lòng chọn ngày hoặc phòng khác.";
                submitBtn.disabled = true;
            } else {
                conflictAlert.classList.add('d-none');
                submitBtn.disabled = false;
            }
        }

        // ==================== 5. TABLE SEARCH & PAGINATION ====================
        function filterReceptionBookings() {
            const keyword = document.getElementById('receptionSearchInput').value.trim().toLowerCase();
            const rows = document.querySelectorAll('.reception-booking-row');
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

                const infoElem = document.getElementById(infoId);
                if (infoElem) {
                    const startItem = totalItems === 0 ? 0 : start + 1;
                    const endItem = Math.min(end, totalItems);
                    infoElem.innerText = `Hiển thị ` + startItem + ` - ` + endItem + ` trong tổng số ` + totalItems + ` ` + itemName;
                }

                const btnContainer = document.getElementById(buttonsId);
                if (!btnContainer) return;

                btnContainer.innerHTML = '';
                if (totalPages <= 1) return;

                // Prev
                const prevBtn = document.createElement('button');
                prevBtn.type = 'button';
                prevBtn.className = 'page-num-btn';
                prevBtn.innerHTML = '<i class="bi bi-chevron-left"></i>';
                prevBtn.disabled = (currentPage === 1);
                prevBtn.onclick = () => { currentPage--; render(); };
                btnContainer.appendChild(prevBtn);

                // Pages
                for (let i = 1; i <= totalPages; i++) {
                    const pBtn = document.createElement('button');
                    pBtn.type = 'button';
                    pBtn.className = 'page-num-btn ' + (currentPage === i ? 'active' : '');
                    pBtn.innerText = i;
                    pBtn.onclick = () => { currentPage = i; render(); };
                    btnContainer.appendChild(pBtn);
                }

                // Next
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

        // ==================== INITIALIZATION ====================
        document.addEventListener('DOMContentLoaded', () => {
            populateGridView();
            renderTimeline();
            setupPagination('reception-booking-row', 'receptionPaginationInfo', 'receptionPaginationButtons', 10, 'đơn');
        });
    </script>
</body>
</html>
