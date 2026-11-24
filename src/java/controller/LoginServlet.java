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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.setAttribute("title", "Đăng Nhập - Núi Homestay");
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String account = request.getParameter("account");
        String password = request.getParameter("password");

        UserDao userDao = Database.getUserDao();
        User user = userDao.findUser(account, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else if (user.isReceptionist()) {
                response.sendRedirect(request.getContextPath() + "/reception");
            } else {
                String returnUrl = (String) session.getAttribute("returnUrl");
                if (returnUrl != null && !returnUrl.isEmpty()) {
                    session.removeAttribute("returnUrl");
                    response.sendRedirect(returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            }
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không chính xác!");
            request.setAttribute("account", account);
            request.setAttribute("title", "Đăng Nhập - Núi Homestay");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
