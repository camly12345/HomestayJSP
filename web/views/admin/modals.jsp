<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

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

<!-- 3. Modal Thêm Mới Loại Phòng -->
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
