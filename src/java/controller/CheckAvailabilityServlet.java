package controller;

import data.dao.Database;
import data.dao.RoomDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

@WebServlet(name = "CheckAvailabilityServlet", urlPatterns = {"/api/check-availability"})
public class CheckAvailabilityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String roomTypeIdStr = request.getParameter("roomTypeId");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");

        if (roomTypeIdStr == null || roomTypeIdStr.isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing roomTypeId\"}");
            return;
        }

        try {
            int roomTypeId = Integer.parseInt(roomTypeIdStr);
            Date checkIn = (checkInStr != null && !checkInStr.isEmpty()) ? Date.valueOf(checkInStr) : null;
            Date checkOut = (checkOutStr != null && !checkOutStr.isEmpty()) ? Date.valueOf(checkOutStr) : null;

            RoomDao roomDao = Database.getRoomDao();
            int count = roomDao.countAvailable(roomTypeId, checkIn, checkOut);

            out.print("{\"success\":true,\"availableRooms\":" + count + "}");
        } catch (Exception e) {
            out.print("{\"success\":false,\"availableRooms\":0,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
