<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
                        <span class="fs-5 fw-bold text-success" id="detailBookingCode">BK0000</span>
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
                        <span class="fs-5 fw-extrabold text-success" id="detailTotalPrice">650,000 VNĐ</span>
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
