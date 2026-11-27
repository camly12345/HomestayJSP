<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

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
