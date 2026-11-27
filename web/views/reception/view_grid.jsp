<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- ==================== VIEW 1: SƠ ĐỒ PHÒNG (GRID VIEW) ==================== -->
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
