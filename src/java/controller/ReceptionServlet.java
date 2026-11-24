package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import data.driver.MySQLDriver;
import data.utils.API;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Booking;
import model.Room;
import model.RoomType;
import model.User;

@WebServlet(name = "ReceptionServlet", urlPatterns = {"/reception"})
public class ReceptionServlet extends HttpServlet {

    private boolean checkReception(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || (!user.isAdmin() && !user.isReceptionist())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkReception(request, response)) return;

        RoomDao roomDao = Database.getRoomDao();
        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        BookingDao bookingDao = Database.getBookingDao();

        // Tự động quét và hủy các đơn chuyển khoản quá hạn 1 phút
        bookingDao.cancelExpiredBookings();

        List<Room> rooms = roomDao.findAll();
        List<RoomType> roomTypes = roomTypeDao.findAll();
        List<Booking> bookings = bookingDao.findAll();

        String today = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        String view = request.getParameter("view");
        if (view == null || view.isEmpty()) {
            view = "grid"; // 'grid', 'timeline', 'table'
        }

        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("bookings", bookings);
        request.setAttribute("today", today);
        request.setAttribute("view", view);
        request.setAttribute("title", "Bàn Lễ Tân - Núi Homestay");

        request.getRequestDispatcher("/views/reception.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkReception(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String view = request.getParameter("view");
        if (view == null || view.isEmpty()) view = "grid";

        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();
        HttpSession session = request.getSession();

        try {
            if ("walkInBooking".equalsIgnoreCase(action)) {
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                Room r = roomDao.findById(roomId);
                if (r == null) {
                    session.setAttribute("receptionError", "Không tìm thấy phòng được chọn!");
                } else {
                    String guestName = request.getParameter("guestName");
                    String guestPhone = request.getParameter("guestPhone");
                    String guestEmail = request.getParameter("guestEmail");
                    String guestAddress = request.getParameter("guestAddress");
                    String checkInStr = request.getParameter("checkIn");
                    String checkOutStr = request.getParameter("checkOut");
                    String payMethod = request.getParameter("payMethod");
                    String payStatus = request.getParameter("payStatus");
                    String status = request.getParameter("status");
                    String note = request.getParameter("note");
                    int guests = 1;
                    try {
                        guests = Integer.parseInt(request.getParameter("guests"));
                    } catch (Exception ignored) {}

                    Date checkIn = Date.valueOf(checkInStr);
                    Date checkOut = Date.valueOf(checkOutStr);

                    if (!checkOut.after(checkIn)) {
                        session.setAttribute("receptionError", "Ngày trả phòng phải sau ngày nhận phòng!");
                    } else if (!roomDao.isRoomAvailable(roomId, checkIn, checkOut)) {
                        session.setAttribute("receptionError", "Phòng " + r.getCode() + " đã có khách đặt trong khoảng thời gian này!");
                    } else {
                        int nights = API.nights(checkIn, checkOut);
                        double total = nights * r.getPrice();

                        Booking bk = new Booking();
                        bk.setCode(API.genBookingCode());
                        bk.setRoomId(roomId);
                        bk.setRoomTypeId(r.getRoomTypeId());
                        bk.setGuestName(guestName);
                        bk.setGuestPhone(guestPhone);
                        bk.setGuestEmail(guestEmail != null ? guestEmail : "");
                        bk.setAddress(guestAddress != null ? guestAddress : "");
                        bk.setCheckIn(checkIn);
                        bk.setCheckOut(checkOut);
                        bk.setGuests(guests);
                        bk.setTotalPrice(total);
                        bk.setPayStatus(payStatus != null ? payStatus : "unpaid");
                        bk.setPayMethod(payMethod != null ? payMethod : "cash");
                        bk.setStatus(status != null ? status : "checkedin");
                        bk.setNote(note);

                        bookingDao.insert(bk);

                        // Lưu thanh toán nếu khách đã trả tiền
                        if ("paid".equalsIgnoreCase(bk.getPayStatus())) {
                            insertPayment(bk.getId(), bk.getPayMethod(), bk.getCode(), total);
                        }

                        session.setAttribute("receptionSuccess", "Đặt phòng trực tiếp thành công cho khách " + guestName + " (Phòng " + r.getCode() + ")!");
                    }
                }

            } else if ("checkIn".equalsIgnoreCase(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                Booking bk = bookingDao.findById(bookingId);
                if (bk != null) {
                    // Kiểm tra điều kiện: hôm nay đã đến ngày nhận phòng chưa
                    Date today = new Date(System.currentTimeMillis());
                    Date checkIn = bk.getCheckIn();

                    // So sánh ngày (bỏ qua giờ phút giây)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    String todayStr = sdf.format(today);
                    String checkInStr = sdf.format(checkIn);

                    if (todayStr.compareTo(checkInStr) < 0) {
                        session.setAttribute("receptionError", "Chưa đến ngày nhận phòng (" + checkInStr + ")! Không thể nhận phòng trước.");
                    } else {
                        bookingDao.updateStatus(bookingId, "checkedin");
                        session.setAttribute("receptionSuccess", "Khách đã nhận phòng thành công (Đơn " + bk.getCode() + ")!");
                    }
                }

            } else if ("checkOut".equalsIgnoreCase(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                Booking bk = bookingDao.findById(bookingId);
                if (bk != null) {
                    bookingDao.updateStatus(bookingId, "checkedout");
                    bookingDao.updatePayStatus(bookingId, "paid");
                    // Lưu payment nếu chưa có
                    insertPayment(bookingId, bk.getPayMethod(), bk.getCode(), bk.getTotalPrice());
                    session.setAttribute("receptionSuccess", "Khách đã trả phòng và hoàn tất thanh toán (Đơn " + bk.getCode() + ")!");
                }

            } else if ("cancelBooking".equalsIgnoreCase(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                Booking bk = bookingDao.findById(bookingId);
                if (bk != null) {
                    bookingDao.updateStatus(bookingId, "cancelled");
                    session.setAttribute("receptionSuccess", "Đã hủy đơn đặt phòng " + bk.getCode() + "!");
                }

            } else if ("deleteBooking".equalsIgnoreCase(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                bookingDao.delete(bookingId);
                session.setAttribute("receptionSuccess", "Đã xóa đơn đặt phòng khỏi hệ thống!");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("receptionError", "Lỗi xử lý: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/reception?view=" + view);
    }

    private void insertPayment(int bookingId, String method, String transCode, double amount) {
        String sql = "INSERT INTO payments(id_booking, method, transactioncode, amount) VALUES(?, ?, ?, ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, bookingId);
            sttm.setString(2, method != null ? method : "cash");
            sttm.setString(3, transCode != null ? transCode : "WALKIN_" + System.currentTimeMillis());
            sttm.setDouble(4, amount);
            sttm.executeUpdate();
        } catch (Exception ignored) {}
    }
}
