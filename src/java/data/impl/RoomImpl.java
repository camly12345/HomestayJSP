package data.impl;

import data.dao.RoomDao;
import data.driver.MySQLDriver;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Room;

public class RoomImpl implements RoomDao {

    @Override
    public List<Room> findAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id ORDER BY r.code ASC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            while (rs.next()) {
                list.add(new Room(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Room> findByRoomTypeId(int roomTypeId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.room_type_id = ? ORDER BY r.code ASC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, roomTypeId);
            try (ResultSet rs = sttm.executeQuery()) {
                while (rs.next()) {
                    list.add(new Room(rs));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public Room findById(int id) {
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, id);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new Room(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public Room findByCode(String code) {
        String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r JOIN room_types rt ON r.room_type_id = rt.id WHERE r.code = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, code);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new Room(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public int countAvailable(int roomTypeId, Date checkIn, Date checkOut) {
        // Tự động quét và hủy các đơn chuyển khoản quá hạn 1 phút
        data.dao.Database.getBookingDao().cancelExpiredBookings();

        if (checkIn == null || checkOut == null) {
            String sql = "SELECT COUNT(*) FROM rooms WHERE room_type_id = ? AND status = 1";
            try (Connection con = MySQLDriver.getConnection();
                 PreparedStatement sttm = con.prepareStatement(sql)) {
                sttm.setInt(1, roomTypeId);
                try (ResultSet rs = sttm.executeQuery()) {
                    if (rs.next()) return rs.getInt(1);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM rooms r WHERE r.room_type_id = ? AND r.status = 1 "
                   + "AND r.id NOT IN (SELECT b.room_id FROM bookings b WHERE b.room_id IS NOT NULL "
                   + "AND b.status NOT IN ('cancelled', 'checkedout') "
                   + "AND NOT (b.status = 'pending' AND b.pay_status = 'unpaid' AND b.pay_method = 'transfer' AND b.created_at < DATE_SUB(NOW(), INTERVAL 1 MINUTE)) "
                   + "AND b.check_in < ? AND b.check_out > ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, roomTypeId);
            sttm.setDate(2, checkOut);
            sttm.setDate(3, checkIn);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public Room findFirstAvailableRoom(int roomTypeId, Date checkIn, Date checkOut) {
        // Tự động quét và hủy các đơn chuyển khoản quá hạn 1 phút
        data.dao.Database.getBookingDao().cancelExpiredBookings();

        if (checkIn == null || checkOut == null) {
            String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r "
                       + "JOIN room_types rt ON r.room_type_id = rt.id "
                       + "WHERE r.room_type_id = ? AND r.status = 1 LIMIT 1";
            try (Connection con = MySQLDriver.getConnection();
                 PreparedStatement sttm = con.prepareStatement(sql)) {
                sttm.setInt(1, roomTypeId);
                try (ResultSet rs = sttm.executeQuery()) {
                    if (rs.next()) return new Room(rs);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return null;
        }

        String sql = "SELECT r.*, rt.name AS room_type_name, rt.price FROM rooms r "
                   + "JOIN room_types rt ON r.room_type_id = rt.id "
                   + "WHERE r.room_type_id = ? AND r.status = 1 "
                   + "AND r.id NOT IN (SELECT b.room_id FROM bookings b WHERE b.room_id IS NOT NULL "
                   + "AND b.status NOT IN ('cancelled', 'checkedout') "
                   + "AND NOT (b.status = 'pending' AND b.pay_status = 'unpaid' AND b.pay_method = 'transfer' AND b.created_at < DATE_SUB(NOW(), INTERVAL 1 MINUTE)) "
                   + "AND b.check_in < ? AND b.check_out > ?) LIMIT 1";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, roomTypeId);
            sttm.setDate(2, checkOut);
            sttm.setDate(3, checkIn);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) return new Room(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        data.dao.Database.getBookingDao().cancelExpiredBookings();
        String sql = "SELECT COUNT(*) FROM bookings "
                   + "WHERE room_id = ? AND status NOT IN ('cancelled', 'checkedout') "
                   + "AND NOT (status = 'pending' AND pay_status = 'unpaid' AND pay_method = 'transfer' AND created_at < DATE_SUB(NOW(), INTERVAL 1 MINUTE)) "
                   + "AND check_in < ? AND check_out > ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, roomId);
            sttm.setDate(2, checkOut);
            sttm.setDate(3, checkIn);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean insert(Room room) {
        String sql = "INSERT INTO rooms(code, room_type_id, area, status) VALUES(?, ?, ?, ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, room.getCode());
            sttm.setInt(2, room.getRoomTypeId());
            sttm.setString(3, room.getArea() != null ? room.getArea() : "Tầng 1");
            sttm.setInt(4, room.getStatus());
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(Room room) {
        String sql = "UPDATE rooms SET code = ?, room_type_id = ?, area = ?, status = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, room.getCode());
            sttm.setInt(2, room.getRoomTypeId());
            sttm.setString(3, room.getArea() != null ? room.getArea() : "Tầng 1");
            sttm.setInt(4, room.getStatus());
            sttm.setInt(5, room.getId());
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE rooms SET status = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, status);
            sttm.setInt(2, id);
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM rooms WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, id);
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
