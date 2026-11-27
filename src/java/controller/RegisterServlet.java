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

        // Sau khi hiển thị trang xong, xóa thông báo lỗi trong session để khi F5 không bị lặp lại lỗi
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("err_email");
            session.removeAttribute("err_phone");
            session.removeAttribute("err_repassword");
            session.removeAttribute("exist_user");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        if (repassword == null) {
            repassword = request.getParameter("confirmPassword");
        }

        // Regex chuẩn ràng buộc
        String Email_Regex = "^[\\w-\\+]+(\\.[\\w]+)*@[\\w-]+(\\.[\\w]+)*(\\.[a-z]{2,})$";
        String Phone_Regex = "^\\d{10}$";
        boolean err = false;

        // 1. Kiểm tra Email
        if (email == null || !email.matches(Email_Regex)) {
            session.setAttribute("err_email", "Email is invalid!");
            err = true;
        } else {
            session.removeAttribute("err_email");
        }

        // 2. Kiểm tra Phone (10 chữ số)
        if (phone == null || !phone.matches(Phone_Regex)) {
            session.setAttribute("err_phone", "Phone has 10 digits!");
            err = true;
        } else {
            session.removeAttribute("err_phone");
        }

        // 3. Kiểm tra Retype Password khớp Password
        if (password == null || !password.equals(repassword)) {
            session.setAttribute("err_repassword", "Not match password!");
            err = true;
        } else {
            session.removeAttribute("err_repassword");
        }

        // Nếu có lỗi định dạng
        if (err) {
            response.sendRedirect(request.getContextPath() + "/register");
        } else {
            UserDao userDao = Database.getUserDao();
            // 4. Kiểm tra User đã tồn tại trong Database chưa (cả email và phone)
            if (userDao.findUserByEmailOrPhone(email) != null || userDao.findUserByEmailOrPhone(phone) != null) {
                session.setAttribute("exist_user", "User has existed in Database!");
                response.sendRedirect(request.getContextPath() + "/register");
            } else {
                // Đăng ký thành công
                userDao.insertUser(name, email, phone, password, "customer");
                User user = userDao.findUser(email, password);
                session.setAttribute("user", user);

                // Dọn dẹp session
                session.removeAttribute("exist_user");
                session.removeAttribute("err_email");
                session.removeAttribute("err_phone");
                session.removeAttribute("err_repassword");
                session.removeAttribute("reg_name");
                session.removeAttribute("reg_email");
                session.removeAttribute("reg_phone");

                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
    }
}
