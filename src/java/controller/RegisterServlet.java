package controller;

import data.dao.Database;
import data.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("title", "Đăng Ký Tài Khoản - Núi Homestay");
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            doGet(request, response);
            return;
        }

        UserDao userDao = Database.getUserDao();
        if (userDao.findUserByEmailOrPhone(email) != null) {
            request.setAttribute("error", "Email đã tồn tại trên hệ thống!");
            doGet(request, response);
            return;
        }

        boolean ok = userDao.insertUser(name, email, phone, password, "customer");
        if (ok) {
            User newUser = userDao.findUser(email, password);
            HttpSession session = request.getSession(true);
            session.setAttribute("user", newUser);
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Đăng ký không thành công, vui lòng thử lại!");
            doGet(request, response);
        }
    }
}
