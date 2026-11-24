package controller;

import data.dao.BookingDao;
import data.dao.Database;
import data.dao.RoomDao;
import data.dao.RoomTypeDao;
import data.driver.MySQLDriver;
import data.utils.API;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import model.Booking;
import model.Room;
import model.RoomType;
import model.User;

@WebServlet(name = "PayOSServlet", urlPatterns = {"/api/create-payos-payment"})
public class PayOSServlet extends HttpServlet {

    // Thông tin cấu hình PayOS lấy từ homestaychatbotai/pb_hooks/payos.pb.js
    private static final String CLIENT_ID = "55f0c23c-5bbc-4c2e-b6d9-a2470b307a14";
    private static final String API_KEY = "33ac70d5-cf1b-4837-aa4d-1f0da058df81";
    private static final String CHECKSUM_KEY = "6e11bad79881ddd21378e69a52988389cbd59d10c3d8ce290056a718e2a0c8e9";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
            String checkInStr = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            int guests = Integer.parseInt(request.getParameter("guests"));
            String guestName = request.getParameter("guestName");
            String guestPhone = request.getParameter("guestPhone");
            String guestEmail = request.getParameter("guestEmail");
            String address = request.getParameter("address");
            String note = request.getParameter("note");

            Date checkInDate = Date.valueOf(checkInStr);
            Date checkOutDate = Date.valueOf(checkOutStr);

            RoomTypeDao roomTypeDao = Database.getRoomTypeDao();
            RoomType rt = roomTypeDao.findById(roomTypeId);
            if (rt == null) {
                out.print("{\"success\":false,\"message\":\"Loại phòng không tồn tại\"}");
                return;
            }

            RoomDao roomDao = Database.getRoomDao();
            Room availableRoom = roomDao.findFirstAvailableRoom(roomTypeId, checkInDate, checkOutDate);
            if (availableRoom == null) {
                out.print("{\"success\":false,\"message\":\"Rất tiếc, phòng vừa được người khác đặt trong khoảng thời gian này!\"}");
                return;
            }

            int nights = API.nights(checkInDate, checkOutDate);
            if (nights <= 0) nights = 1;
            long amount = (long) (nights * rt.getPrice());
            if (amount < 2000) {
                amount = 2000; // PayOS yêu cầu tối thiểu 2.000 VNĐ cho mỗi giao dịch test/thật
            }

            // Sinh mã orderCode số nguyên ngẫu nhiên cho PayOS (phải là số nguyên, max an toàn: 6 chữ số ngẫu nhiên)
            long orderCode = (long) (100000 + Math.random() * 899999);
            String bookingCode = "BK" + orderCode;

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

            // 1. Tạo booking trước với status 'pending', pay_status 'unpaid'
            Booking bk = new Booking();
            bk.setCode(bookingCode);
            if (currentUser != null) bk.setUserId(currentUser.getId());
            bk.setRoomId(availableRoom.getId());
            bk.setRoomTypeId(roomTypeId);
            bk.setGuestName(guestName);
            bk.setGuestPhone(guestPhone);
            bk.setGuestEmail(guestEmail != null ? guestEmail : "");
            bk.setAddress(address != null ? address : "");
            bk.setCheckIn(checkInDate);
            bk.setCheckOut(checkOutDate);
            bk.setGuests(guests);
            bk.setTotalPrice(amount);
            bk.setPayStatus("unpaid");
            bk.setPayMethod("transfer");
            bk.setStatus("pending");
            bk.setNote(note);

            boolean inserted = Database.getBookingDao().insert(bk);
            if (!inserted) {
                out.print("{\"success\":false,\"message\":\"Không thể khởi tạo đơn đặt phòng\"}");
                return;
            }

            // Ghi vết vào bảng payments
            Booking createdBooking = Database.getBookingDao().findByCode(bookingCode);
            if (createdBooking != null) {
                String insertPaySql = "INSERT INTO payments(id_booking, method, transactioncode, amount) VALUES(?, 'transfer', ?, ?)";
                try (Connection con = MySQLDriver.getConnection();
                     PreparedStatement sttm = con.prepareStatement(insertPaySql)) {
                    sttm.setInt(1, createdBooking.getId());
                    sttm.setString(2, String.valueOf(orderCode));
                    sttm.setDouble(3, amount);
                    sttm.executeUpdate();
                } catch (Exception ignored) {}
            }

            // 2. Gọi trực tiếp API PayOS tạo link thanh toán & mã QR chuẩn
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String contextPath = request.getContextPath();
            String baseUrl = scheme + "://" + serverName + (serverPort == 80 || serverPort == 443 ? "" : ":" + serverPort) + contextPath;

            String cancelUrl = baseUrl + "/booking?roomTypeId=" + roomTypeId;
            String returnUrl = baseUrl + "/success?code=" + bookingCode;
            String description = ("Thanh toan don " + orderCode);
            if (description.length() > 25) description = description.substring(0, 25);

            String signData = "amount=" + amount + "&cancelUrl=" + cancelUrl + "&description=" + description + "&orderCode=" + orderCode + "&returnUrl=" + returnUrl;
            String signature = hmacSha256(signData, CHECKSUM_KEY);

            // Gửi HTTP POST tới https://api-merchant.payos.vn/v2/payment-requests
            URL url = new URL("https://api-merchant.payos.vn/v2/payment-requests");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("x-client-id", CLIENT_ID);
            conn.setRequestProperty("x-api-key", API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonPayload = String.format("{\"orderCode\":%d,\"amount\":%d,\"description\":\"%s\",\"cancelUrl\":\"%s\",\"returnUrl\":\"%s\",\"signature\":\"%s\"}",
                    orderCode, amount, description, cancelUrl, returnUrl, signature);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    responseCode >= 200 && responseCode < 300 ? conn.getInputStream() : conn.getErrorStream(), StandardCharsets.UTF_8));
            StringBuilder resStr = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                resStr.append(line);
            }
            in.close();

            // Trích xuất qrCode và checkoutUrl từ JSON trả về của PayOS
            String payOsResponse = resStr.toString();
            String qrCode = extractJsonField(payOsResponse, "qrCode");
            String checkoutUrl = extractJsonField(payOsResponse, "checkoutUrl");

            if (qrCode != null && !qrCode.isEmpty()) {
                out.print(String.format("{\"success\":true,\"bookingCode\":\"%s\",\"orderCode\":%d,\"qrCode\":\"%s\",\"checkoutUrl\":\"%s\"}",
                        bookingCode, orderCode, qrCode, checkoutUrl != null ? checkoutUrl : ""));
            } else {
                out.print("{\"success\":false,\"message\":\"Lỗi khởi tạo cổng PayOS: " + escapeJson(payOsResponse) + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}");
        }
    }

    private static String hmacSha256(String data, String key) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] hmacBytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hmacBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Failed to calculate HMAC-SHA256", e);
        }
    }

    private static String extractJsonField(String json, String field) {
        String pattern = "\"" + field + "\":\"";
        int start = json.indexOf(pattern);
        if (start == -1) return null;
        start += pattern.length();
        int end = json.indexOf("\"", start);
        if (end == -1) return null;
        return json.substring(start, end);
    }

    private static String escapeJson(String s) {
        return s.replace("\"", "\\\"").replace("\n", "").replace("\r", "");
    }
}
