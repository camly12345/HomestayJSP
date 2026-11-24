package data.impl;

import data.dao.BookingDao;
import data.driver.MySQLDriver;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Booking;

public class BookingImpl implements BookingDao {

    private static final String BASE_SELECT = 
        "SELECT b.*, r.code AS room_code, rt.name AS room_type_name " +
        "FROM bookings b " +
        "JOIN room_types rt ON b.room_type_id = rt.id " +
        "LEFT JOIN rooms r ON b.room_id = r.id ";

    @Override
    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY b.id DESC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            while (rs.next()) {
                list.add(new Booking(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Booking> findByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE b.user_id = ? ORDER BY b.id DESC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, userId);
            try (ResultSet rs = sttm.executeQuery()) {
                while (rs.next()) {
                    list.add(new Booking(rs));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Booking> findByPhone(String phone) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE b.guest_phone = ? ORDER BY b.id DESC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, phone);
            try (ResultSet rs = sttm.executeQuery()) {
                while (rs.next()) {
                    list.add(new Booking(rs));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public Booking findById(int id) {
        String sql = BASE_SELECT + "WHERE b.id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, id);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new Booking(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public Booking findByCode(String code) {
        String sql = BASE_SELECT + "WHERE b.code = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, code);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new Booking(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insert(Booking b) {
        String sql = "INSERT INTO bookings(code, user_id, room_id, room_type_id, guest_name, guest_phone, guest_email, address, "
                   + "check_in, check_out, guests, total_price, pay_status, pay_method, status, note) "
                   + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, b.getCode());
            if (b.getUserId() != null) sttm.setInt(2, b.getUserId()); else sttm.setNull(2, Types.INTEGER);
            if (b.getRoomId() != null) sttm.setInt(3, b.getRoomId()); else sttm.setNull(3, Types.INTEGER);
            sttm.setInt(4, b.getRoomTypeId());
            sttm.setString(5, b.getGuestName());
            sttm.setString(6, b.getGuestPhone());
            sttm.setString(7, b.getGuestEmail() != null ? b.getGuestEmail() : "");
            sttm.setString(8, b.getAddress() != null ? b.getAddress() : "");
            sttm.setDate(9, b.getCheckIn());
            sttm.setDate(10, b.getCheckOut());
            sttm.setInt(11, b.getGuests());
            sttm.setDouble(12, b.getTotalPrice());
            sttm.setString(13, b.getPayStatus() != null ? b.getPayStatus() : "unpaid");
            sttm.setString(14, b.getPayMethod() != null ? b.getPayMethod() : "cash");
            sttm.setString(15, b.getStatus() != null ? b.getStatus() : "pending");
            sttm.setString(16, b.getNote() != null ? b.getNote() : "");
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, status);
            sttm.setInt(2, id);
            boolean ok = sttm.executeUpdate() > 0;
            
            // Tự động cập nhật trạng thái phòng tương ứng
            if (ok) {
                Booking bk = findById(id);
                if (bk != null && bk.getRoomId() != null) {
                    if ("checkedin".equalsIgnoreCase(status)) {
                        new RoomImpl().updateStatus(bk.getRoomId(), 0); // 0 = occupied
                    } else if ("checkedout".equalsIgnoreCase(status) || "cancelled".equalsIgnoreCase(status)) {
                        new RoomImpl().updateStatus(bk.getRoomId(), 1); // 1 = available
                    }
                }
            }
            return ok;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePayStatus(int id, String payStatus) {
        String sql = "UPDATE bookings SET pay_status = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, payStatus);
            sttm.setInt(2, id);
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean assignRoom(int bookingId, int roomId) {
        String sql = "UPDATE bookings SET room_id = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, roomId);
            sttm.setInt(2, bookingId);
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public void cancelExpiredBookings() {
        String sql = "UPDATE bookings SET status = 'cancelled' "
                   + "WHERE status = 'pending' AND pay_status = 'unpaid' "
                   + "AND pay_method = 'transfer' "
                   + "AND created_at < DATE_SUB(NOW(), INTERVAL 1 MINUTE)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public int countTotalBookings() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countActiveGuests() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = 'checkedin'";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public double calculateTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE pay_status = 'paid' OR status = 'checkedout'";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }
}
