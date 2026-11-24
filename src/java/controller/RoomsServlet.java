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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.RoomType;

@WebServlet(name = "RoomsServlet", urlPatterns = {"/rooms"})
public class RoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");
        if (guestsStr == null || guestsStr.isEmpty()) {
            guestsStr = request.getParameter("capacity");
        }

        Date checkInDate = null;
        Date checkOutDate = null;
        try {
            if (checkInStr != null && !checkInStr.isEmpty()) {
                checkInDate = Date.valueOf(checkInStr);
            }
            if (checkOutStr != null && !checkOutStr.isEmpty()) {
                checkOutDate = Date.valueOf(checkOutStr);
            }
        } catch (IllegalArgumentException ignored) {}

        int minGuests = 1;
        try {
            if (guestsStr != null && !guestsStr.isEmpty()) {
                minGuests = Integer.parseInt(guestsStr);
            }
        } catch (NumberFormatException ignored) {}

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        RoomDao roomDao = Database.getRoomDao();
        List<RoomType> allTypes = roomTypeDao.findAll();

        List<RoomType> filteredList = new java.util.ArrayList<>();
        Map<Integer, Integer> availableMap = new HashMap<>();

        for (RoomType rt : allTypes) {
            // 1. Kiểm tra sức chứa (loại phòng phải chứa được số khách yêu cầu)
            if (rt.getCapacity() >= minGuests) {
                int count = roomDao.countAvailable(rt.getId(), checkInDate, checkOutDate);
                // 2. Chỉ hiện loại phòng còn phòng trống (khả dụng > 0)
                // (Nếu người dùng chưa chọn ngày thì vẫn hiển thị những loại phòng có tổng số phòng > 0)
                if (checkInDate == null || count > 0) {
                    filteredList.add(rt);
                    availableMap.put(rt.getId(), count);
                }
            }
        }

        request.setAttribute("roomTypes", filteredList);
        request.setAttribute("availableMap", availableMap);
        request.setAttribute("checkIn", checkInStr);
        request.setAttribute("checkOut", checkOutStr);
        request.setAttribute("guests", guestsStr != null ? guestsStr : "1");
        request.setAttribute("title", "Danh Sách Phòng - Núi Homestay");
        request.getRequestDispatcher("/views/rooms.jsp").forward(request, response);
    }
}
