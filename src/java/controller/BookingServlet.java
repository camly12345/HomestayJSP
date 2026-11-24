package controller;

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
import model.Booking;
import model.Room;
import model.RoomType;
import model.User;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            String queryString = request.getQueryString();
            String returnUrl = request.getRequestURI() + (queryString != null ? "?" + queryString : "");
            request.getSession(true).setAttribute("returnUrl", returnUrl);
            response.sendRedirect(request.getContextPath() + "/login?message=login_required");
            return;
        }

        String roomTypeIdStr = request.getParameter("roomTypeId");
        if (roomTypeIdStr == null || roomTypeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        try {
            int roomTypeId = Integer.parseInt(roomTypeIdStr);
            RoomType rt = Database.getRoomTypeDao().findById(roomTypeId);
            if (rt == null) {
                response.sendRedirect(request.getContextPath() + "/rooms");
                return;
            }

            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            String guestsStr = request.getParameter("guests");

            Date checkInDate = null;
            Date checkOutDate = null;
            try {
                if (checkInStr != null && !checkInStr.isEmpty()) checkInDate = Date.valueOf(checkInStr);
                if (checkOutStr != null && !checkOutStr.isEmpty()) checkOutDate = Date.valueOf(checkOutStr);
            } catch (Exception ignored) {}

            int nights = API.nights(checkInDate, checkOutDate);
            if (nights <= 0) nights = 1;
            double estimatedTotal = nights * rt.getPrice();

            RoomDao roomDao = Database.getRoomDao();
            Room availableRoom = roomDao.findFirstAvailableRoom(roomTypeId, checkInDate, checkOutDate);

            request.setAttribute("roomType", rt);
            request.setAttribute("availableRoom", availableRoom);
            request.setAttribute("checkIn", checkInStr);
            request.setAttribute("checkOut", checkOutStr);
            request.setAttribute("guests", guestsStr != null ? guestsStr : "2");
            request.setAttribute("nights", nights);
            request.setAttribute("estimatedTotal", estimatedTotal);
            request.setAttribute("title", "Đặt Phòng - " + rt.getName());

            request.getRequestDispatcher("/views/booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            int guests = Integer.parseInt(request.getParameter("guests"));
            String guestName = request.getParameter("guestName");
            String guestPhone = request.getParameter("guestPhone");
            String guestEmail = request.getParameter("guestEmail");
            String address = request.getParameter("address");
            String payMethod = request.getParameter("payMethod");
            String note = request.getParameter("note");

            Date checkInDate = Date.valueOf(checkInStr);
            Date checkOutDate = Date.valueOf(checkOutStr);

            RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
            RoomType rt = roomTypeDao.findById(roomTypeId);
            if (rt == null) {
                response.sendRedirect(request.getContextPath() + "/rooms");
                return;
            }

            RoomDao roomDao = Database.getRoomDao();
            Room availableRoom = roomDao.findFirstAvailableRoom(roomTypeId, checkInDate, checkOutDate);

            // Kiểm tra còn phòng trống không
            if (availableRoom == null) {
                request.setAttribute("error", "Rất tiếc, không còn phòng trống cho loại phòng này trong khoảng thời gian bạn chọn. Vui lòng chọn ngày khác!");
                request.setAttribute("roomType", rt);
                request.setAttribute("checkIn", checkInStr);
                request.setAttribute("checkOut", checkOutStr);
                request.setAttribute("guests", String.valueOf(guests));
                request.setAttribute("nights", API.nights(checkInDate, checkOutDate));
                request.setAttribute("estimatedTotal", API.nights(checkInDate, checkOutDate) * rt.getPrice());
                request.setAttribute("title", "Đặt Phòng - " + rt.getName());
                request.getRequestDispatcher("/views/booking.jsp").forward(request, response);
                return;
            }

            int nights = API.nights(checkInDate, checkOutDate);
            double totalPrice = nights * rt.getPrice();
            String code = API.genBookingCode();

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

            Booking bk = new Booking();
            bk.setCode(code);
            if (currentUser != null) {
                bk.setUserId(currentUser.getId());
            }
            if (availableRoom != null) {
                bk.setRoomId(availableRoom.getId());
            }
            bk.setRoomTypeId(roomTypeId);
            bk.setGuestName(guestName);
            bk.setGuestPhone(guestPhone);
            bk.setGuestEmail(guestEmail != null ? guestEmail : "");
            bk.setAddress(address != null ? address : "");
            bk.setCheckIn(checkInDate);
            bk.setCheckOut(checkOutDate);
            bk.setGuests(guests);
            bk.setTotalPrice(totalPrice);
            bk.setPayStatus("unpaid");
            bk.setPayMethod(payMethod != null ? payMethod : "cash");
            bk.setStatus("confirmed");
            bk.setNote(note);

            boolean success = Database.getBookingDao().insert(bk);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/success?code=" + code);
            } else {
                request.setAttribute("error", "Không thể hoàn tất đặt phòng. Vui lòng thử lại!");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }
}
