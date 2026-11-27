<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- ==================== MODAL 2: ĐẶT PHÒNG TRỰC TIẾP (WALK-IN) ==================== -->
<div class="modal fade" id="walkInModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <form action="${pageContext.request.contextPath}/reception" method="POST" id="formWalkIn">
                <input type="hidden" name="action" value="walkInBooking">
                <input type="hidden" name="view" value="${view}">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-success">
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
                    <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold" id="btnSubmitWalkIn">Xác nhận đặt phòng</button>
                </div>
            </form>
        </div>
    </div>
</div>
