package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import data.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.Room;
import model.RoomType;
import model.User;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AdminServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";

        String subTab = request.getParameter("subTab");
        if (subTab == null || subTab.isEmpty()) subTab = "roomList";

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();
        UserDao userDao = Database.getUserDao();

        // Tự động quét và hủy booking quá hạn 1 phút
        bookingDao.cancelExpiredBookings();

        List<RoomType> roomTypes = roomTypeDao.findAll();
        List<Room> rooms = roomDao.findAll();
        List<Booking> bookings = bookingDao.findAll();
        List<User> customers = userDao.findAllCustomers();

        // Thống kê tổng quan
        int occupied = 0;
        for (Booking b : bookings) {
            if ("checkedin".equalsIgnoreCase(b.getStatus())) {
                occupied++;
            }
        }
        int totalRooms = rooms.size();
        int vacant = Math.max(0, totalRooms - occupied);

        // 5 đơn đặt phòng gần nhất
        List<Booking> recentBookings = new ArrayList<>();
        for (int i = 0; i < Math.min(5, bookings.size()); i++) {
            recentBookings.add(bookings.get(i));
        }

        request.setAttribute("tab", tab);
        request.setAttribute("subTab", subTab);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rooms", rooms);
        request.setAttribute("bookings", bookings);
        request.setAttribute("customers", customers);
        request.setAttribute("occupied", occupied);
        request.setAttribute("vacant", vacant);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("title", "Quản Trị Núi Homestay");

        request.getRequestDispatcher("/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "overview";

        String subTab = request.getParameter("subTab");
        if (subTab == null || subTab.isEmpty()) subTab = "roomList";

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();
        UserDao userDao = Database.getUserDao();

        HttpSession session = request.getSession();

        try {
            if ("addRoom".equalsIgnoreCase(action)) {
                String code = request.getParameter("code");
                int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
                String area = request.getParameter("area");
                if (area == null || area.trim().isEmpty()) area = "Tầng 1";

                if (code != null) code = code.trim().toUpperCase();

                // Kiểm tra trùng mã phòng
                Room existing = roomDao.findByCode(code);
                if (existing != null) {
                    session.setAttribute("adminError", "Tên phòng / Mã phòng '" + code + "' đã tồn tại!");
                } else {
                    roomDao.insert(new Room(0, code, roomTypeId, area, 1));
                    session.setAttribute("adminSuccess", "Thêm phòng mới thành công!");
                }
                tab = "rooms";
                subTab = "roomList";

            } else if ("editRoom".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
                String area = request.getParameter("area");
                int status = Integer.parseInt(request.getParameter("status"));

                if (code != null) code = code.trim().toUpperCase();

                // Kiểm tra trùng mã phòng với phòng khác
                Room existing = roomDao.findByCode(code);
                if (existing != null && existing.getId() != id) {
                    session.setAttribute("adminError", "Tên phòng / Mã phòng '" + code + "' đã được sử dụng!");
                } else {
                    roomDao.update(new Room(id, code, roomTypeId, area, status));
                    session.setAttribute("adminSuccess", "Cập nhật phòng thành công!");
                }
                tab = "rooms";
                subTab = "roomList";

            } else if ("toggleRoomStatus".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int currentStatus = Integer.parseInt(request.getParameter("status"));
                int newStatus = (currentStatus == 1) ? 0 : 1;
                roomDao.updateStatus(id, newStatus);
                session.setAttribute("adminSuccess", "Đã chuyển trạng thái phòng thành " + (newStatus == 1 ? "Hoạt động" : "Tạm dừng") + "!");
                tab = "rooms";
                subTab = "roomList";

            } else if ("deleteRoom".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                roomDao.delete(id);
                session.setAttribute("adminSuccess", "Đã xóa phòng thành công!");
                tab = "rooms";
                subTab = "roomList";

            } else if ("addRoomType".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                int bed = Integer.parseInt(request.getParameter("bed"));
                String description = request.getParameter("description");
                String imageUrl = handleFileUpload(request, "imageFile", request.getParameter("image"));

                roomTypeDao.insert(new RoomType(0, name, description, price, capacity, bed, imageUrl));
                session.setAttribute("adminSuccess", "Thêm loại phòng mới thành công!");
                tab = "rooms";
                subTab = "roomTypes";

            } else if ("editRoomType".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                int bed = Integer.parseInt(request.getParameter("bed"));
                String description = request.getParameter("description");
                String oldImage = request.getParameter("oldImage");
                String imageUrl = handleFileUpload(request, "imageFile", oldImage);

                roomTypeDao.update(new RoomType(id, name, description, price, capacity, bed, imageUrl));
                session.setAttribute("adminSuccess", "Cập nhật loại phòng thành công!");
                tab = "rooms";
                subTab = "roomTypes";

            } else if ("deleteRoomType".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                // Khi xóa loại phòng, các phòng thuộc loại phòng đó sẽ tự động xóa theo (Cascade)
                roomTypeDao.delete(id);
                session.setAttribute("adminSuccess", "Đã xóa loại phòng và các phòng vật lý liên kết!");
                tab = "rooms";
                subTab = "roomTypes";

            } else if ("deleteUser".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                userDao.delete(id);
                session.setAttribute("adminSuccess", "Đã xóa khách hàng!");
                tab = "customers";

            } else if ("deleteBooking".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                bookingDao.delete(id);
                session.setAttribute("adminSuccess", "Đã xóa đơn đặt phòng!");
                tab = "bookings";

            } else if ("updateBookingStatus".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                bookingDao.updateStatus(id, status);
                if ("checkedout".equalsIgnoreCase(status)) {
                    bookingDao.updatePayStatus(id, "paid");
                }
                session.setAttribute("adminSuccess", "Đã cập nhật trạng thái đơn phòng!");
                tab = "bookings";
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("adminError", "Lỗi xử lý: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin?tab=" + tab + "&subTab=" + subTab);
    }

    private String handleFileUpload(HttpServletRequest request, String partName, String fallback) {
        try {
            Part part = request.getPart(partName);
            if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty()) {
                String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = "";
                int dotIdx = submittedName.lastIndexOf('.');
                if (dotIdx >= 0) {
                    ext = submittedName.substring(dotIdx);
                }
                String newFileName = "room_" + System.currentTimeMillis() + ext;

                // Lưu vào thư mục deployed
                String uploadDir = request.getServletContext().getRealPath("/images/rooms");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                File destFile = new File(dir, newFileName);
                try (InputStream input = part.getInputStream()) {
                    Files.copy(input, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                // Lưu thêm bản sao vào thư mục source web/images/rooms nếu có để NetBeans giữ file
                try {
                    String rootApp = request.getServletContext().getRealPath("/");
                    File sourceDir = new File("C:/Users/HP/LY/javanc/Homestay/web/images/rooms");
                    if (sourceDir.exists()) {
                        File sourceFile = new File(sourceDir, newFileName);
                        Files.copy(destFile.toPath(), sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                } catch (Exception ignored) {}

                return request.getContextPath() + "/images/rooms/" + newFileName;
            }
        } catch (Exception ex) {
            System.err.println("handleFileUpload error: " + ex.getMessage());
        }
        return (fallback != null && !fallback.trim().isEmpty()) ? fallback : "https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000";
    }
}
