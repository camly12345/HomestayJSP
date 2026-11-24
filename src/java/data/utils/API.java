package data.utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class API {
    public static String getMd5(String input) {
        if (input == null) return "";
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public static String formatCurrency(double amount) {
        DecimalFormat formatter = new DecimalFormat("#,###");
        return formatter.format(amount) + " đ";
    }

    public static int nights(Date checkIn, Date checkOut) {
        if (checkIn == null || checkOut == null) return 1;
        long diff = checkOut.getTime() - checkIn.getTime();
        int days = (int) (diff / (1000 * 60 * 60 * 24));
        return days > 0 ? days : 1;
    }

    public static String genBookingCode() {
        // Dùng timestamp để tránh trùng mã (tổ hợp 6 chữ số cuối của millis + random 2 số)
        long ts = System.currentTimeMillis() % 100000;
        int rand = (int) (10 + Math.random() * 90);
        return "BK" + ts + rand;
    }
}
