package controller;

import data.dao.Database;
import data.dao.RoomTypeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.RoomType;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        List<RoomType> featuredRooms = roomTypeDao.findFeatured(3);
        List<RoomType> allRoomTypes = roomTypeDao.findAll();

        request.setAttribute("featuredRooms", featuredRooms);
        request.setAttribute("allRoomTypes", allRoomTypes);
        request.setAttribute("title", "Núi Homestay - Nghỉ Dưỡng Yên Bình Tại Huế");
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
