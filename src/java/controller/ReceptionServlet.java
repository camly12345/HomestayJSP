package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import data.utils.API;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
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

        List<Room> rooms = roomDao.findAll();
        List<RoomType> roomTypes = roomTypeDao.findAll();
        List<Booking> bookings = bookingDao.findAll();

        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("bookings", bookings);
        request.setAttribute("title", "Bàn Lễ Tân - Núi Homestay");

        request.getRequestDispatcher("/views/reception.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkReception(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();

        if ("walkInBooking".equalsIgnoreCase(action)) {
            try {
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                Room r = roomDao.findById(roomId);
                if (r != null) {
                    String guestName = request.getParameter("guestName");
                    String guestPhone = request.getParameter("guestPhone");
                    String checkInStr = request.getParameter("checkIn");
                    String checkOutStr = request.getParameter("checkOut");
                    String payMethod = request.getParameter("payMethod");
                    String note = request.getParameter("note");

                    Date checkIn = Date.valueOf(checkInStr);
                    Date checkOut = Date.valueOf(checkOutStr);

                    int nights = API.nights(checkIn, checkOut);
                    double total = nights * r.getPrice();

                    Booking bk = new Booking();
                    bk.setCode(API.genBookingCode());
                    bk.setRoomId(roomId);
                    bk.setRoomTypeId(r.getRoomTypeId());
                    bk.setGuestName(guestName);
                    bk.setGuestPhone(guestPhone);
                    bk.setCheckIn(checkIn);
                    bk.setCheckOut(checkOut);
                    bk.setGuests(2);
                    bk.setTotalPrice(total);
                    bk.setPayStatus("paid");
                    bk.setPayMethod(payMethod != null ? payMethod : "cash");
                    bk.setStatus("checkedin");
                    bk.setNote(note);

                    bookingDao.insert(bk);
                    roomDao.updateStatus(roomId, 0); // 0 = occupied (đang có khách)
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("checkIn".equalsIgnoreCase(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            bookingDao.updateStatus(bookingId, "checkedin");
        } else if ("checkOut".equalsIgnoreCase(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            bookingDao.updateStatus(bookingId, "checkedout");
            bookingDao.updatePayStatus(bookingId, "paid");
        } else if ("changeRoomStatus".equalsIgnoreCase(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int status = Integer.parseInt(request.getParameter("status"));
            roomDao.updateStatus(roomId, status);
        }

        response.sendRedirect(request.getContextPath() + "/reception");
    }
}
