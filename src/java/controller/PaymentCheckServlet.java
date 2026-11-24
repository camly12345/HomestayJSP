package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.driver.MySQLDriver;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Booking;

@WebServlet(name = "PaymentCheckServlet", urlPatterns = {"/api/payment-status", "/api/simulate-payment"})
public class PaymentCheckServlet extends HttpServlet {

    private static final String CLIENT_ID = "55f0c23c-5bbc-4c2e-b6d9-a2470b307a14";
    private static final String API_KEY = "33ac70d5-cf1b-4837-aa4d-1f0da058df81";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String code = request.getParameter("code");
        String orderCode = request.getParameter("orderCode");

        PrintWriter out = response.getWriter();
        if (code == null || code.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing booking code\"}");
            return;
        }

        BookingDao bookingDao = Database.getBookingDao();
        Booking booking = bookingDao.findByCode(code.trim());

        if (booking == null) {
            out.print("{\"success\":false,\"message\":\"Booking not found\"}");
            return;
        }

        // 1. Nếu trong DB đã là paid rồi thì trả về ngay
        if ("paid".equalsIgnoreCase(booking.getPayStatus())) {
            out.print("{\"success\":true,\"code\":\"" + booking.getCode() + "\",\"payStatus\":\"paid\",\"isPaid\":true}");
            return;
        }

        // 2. Nếu DB chưa paid, tự động gọi trực tiếp PayOS kiểm tra xem khách đã chuyển khoản thành công chưa (Không cần ngrok Webhook!)
        if (orderCode == null || orderCode.isEmpty()) {
            if (code.startsWith("BK")) {
                orderCode = code.substring(2);
            }
        }

        boolean isPaidOnPayOS = false;
        if (orderCode != null && !orderCode.isEmpty()) {
            try {
                URL url = new URL("https://api-merchant.payos.vn/v2/payment-requests/" + orderCode);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("x-client-id", CLIENT_ID);
                conn.setRequestProperty("x-api-key", API_KEY);
                conn.setConnectTimeout(3000);
                conn.setReadTimeout(3000);

                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                    StringBuilder res = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) res.append(line);
                    in.close();

                    String json = res.toString();
                    if (json.contains("\"status\":\"PAID\"")) {
                        isPaidOnPayOS = true;
                    }
                }
            } catch (Exception ignored) {}
        }

        // Nếu PayOS báo đã nhận được tiền -> Cập nhật Database ngay và trả về isPaid: true để client tự nhảy trang!
        if (isPaidOnPayOS) {
            bookingDao.updatePayStatus(booking.getId(), "paid");
            bookingDao.updateStatus(booking.getId(), "confirmed");
            out.print("{\"success\":true,\"code\":\"" + booking.getCode() + "\",\"payStatus\":\"paid\",\"isPaid\":true}");
        } else {
            out.print("{\"success\":true,\"code\":\"" + booking.getCode() + "\",\"payStatus\":\"unpaid\",\"isPaid\":false}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String code = request.getParameter("code");
        PrintWriter out = response.getWriter();

        if (code == null || code.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing booking code\"}");
            return;
        }

        BookingDao bookingDao = Database.getBookingDao();
        Booking booking = bookingDao.findByCode(code.trim());
        if (booking == null) {
            out.print("{\"success\":false,\"message\":\"Booking not found\"}");
            return;
        }

        // Cập nhật booking thành paid
        bookingDao.updatePayStatus(booking.getId(), "paid");
        bookingDao.updateStatus(booking.getId(), "confirmed");

        out.print("{\"success\":true,\"code\":\"" + booking.getCode() + "\",\"status\":\"PAID\"}");
    }
}
