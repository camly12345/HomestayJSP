package controller;

import data.dao.BookingDao;
import data.dao.Database;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.User;

@WebServlet(name = "HistoryServlet", urlPatterns = {"/history", "/lich-su"})
public class HistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String phone = request.getParameter("phone");
        BookingDao bookingDao = Database.getBookingDao();
        List<Booking> list = new ArrayList<>();

        if (user != null) {
            list = bookingDao.findByUserId(user.getId());
        } else if (phone != null && !phone.trim().isEmpty()) {
            list = bookingDao.findByPhone(phone.trim());
        }

        request.setAttribute("bookings", list);
        request.setAttribute("phone", phone);
        request.setAttribute("title", "Lịch Sử Đặt Phòng - Núi Homestay");
        request.getRequestDispatcher("/views/history.jsp").forward(request, response);
    }
}
