<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!-- ==================== VIEW 2: DÒNG THỜI GIAN (TIMELINE VIEW) ==================== -->
<!-- Timeline Navigation Controls -->
<div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-3">
    <div class="d-flex align-items-center gap-2">
        <button type="button" class="btn btn-sm btn-light border fw-semibold" onclick="shiftTimeline(-7)">
            <i class="bi bi-chevron-left"></i> Tuần trước
        </button>
        <button type="button" class="btn btn-sm btn-outline-success fw-bold" onclick="resetTimelineToToday()">
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
