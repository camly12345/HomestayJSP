package controller;

import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import model.RoomType;

@WebServlet(name = "RoomDetailServlet", urlPatterns = {"/room-detail"})
public class RoomDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/rooms");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
            RoomType roomType = roomTypeDao.findById(id);

            if (roomType == null) {
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

            RoomDao roomDao = Database.getRoomDao();
            int availableRooms = roomDao.countAvailable(id, checkInDate, checkOutDate);

            request.setAttribute("roomType", roomType);
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("checkIn", checkInStr);
            request.setAttribute("checkOut", checkOutStr);
            request.setAttribute("guests", guestsStr != null ? guestsStr : "2");
            request.setAttribute("title", roomType.getName() + " - Núi Homestay");

            request.getRequestDispatcher("/views/room_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }
}
