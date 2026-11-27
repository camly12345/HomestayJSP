<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

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
