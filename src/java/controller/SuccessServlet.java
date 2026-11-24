package controller;

import data.dao.BookingDao;
import data.dao.Database;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Booking;

@WebServlet(name = "SuccessServlet", urlPatterns = {"/success"})
public class SuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        BookingDao bookingDao = Database.getBookingDao();
        Booking booking = bookingDao.findByCode(code);
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("booking", booking);
        request.setAttribute("title", "Đặt Phòng Thành Công - Núi Homestay");
        request.getRequestDispatcher("/views/booking_success.jsp").forward(request, response);
    }
}
