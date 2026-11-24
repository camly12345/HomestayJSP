package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import data.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Booking;
import model.Room;
import model.RoomType;
import model.User;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
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

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();
        UserDao userDao = Database.getUserDao();

        List<RoomType> roomTypes = roomTypeDao.findAll();
        List<Room> rooms = roomDao.findAll();
        List<Booking> bookings = bookingDao.findAll();
        List<User> customers = userDao.findAllCustomers();

        int totalBookings = bookingDao.countTotalBookings();
        int activeGuests = bookingDao.countActiveGuests();
        double totalRevenue = bookingDao.calculateTotalRevenue();

        request.setAttribute("tab", tab);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rooms", rooms);
        request.setAttribute("bookings", bookings);
        request.setAttribute("customers", customers);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("activeGuests", activeGuests);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("title", "Quản Trị Hệ Thống - Núi Homestay");

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

        RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
        RoomDao roomDao = Database.getRoomDao();
        BookingDao bookingDao = Database.getBookingDao();

        if ("addRoomType".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int cap = Integer.parseInt(request.getParameter("capacity"));
            int bed = Integer.parseInt(request.getParameter("bed"));
            String img = request.getParameter("image");
            roomTypeDao.insert(new RoomType(0, name, desc, price, cap, bed, img));
            tab = "rooms";
        } else if ("editRoomType".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int cap = Integer.parseInt(request.getParameter("capacity"));
            int bed = Integer.parseInt(request.getParameter("bed"));
            String img = request.getParameter("image");
            roomTypeDao.update(new RoomType(id, name, desc, price, cap, bed, img));
            tab = "rooms";
        } else if ("deleteRoomType".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            roomTypeDao.delete(id);
            tab = "rooms";
        } else if ("addRoom".equalsIgnoreCase(action)) {
            String code = request.getParameter("code");
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            roomDao.insert(new Room(0, code, roomTypeId, 1));
            tab = "rooms";
        } else if ("deleteRoom".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            roomDao.delete(id);
            tab = "rooms";
        } else if ("updateBookingStatus".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            bookingDao.updateStatus(id, status);
            tab = "bookings";
        } else if ("updatePayStatus".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String payStatus = request.getParameter("payStatus");
            bookingDao.updatePayStatus(id, payStatus);
            tab = "bookings";
        }

        response.sendRedirect(request.getContextPath() + "/admin?tab=" + tab);
    }
}
