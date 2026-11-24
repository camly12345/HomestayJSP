package data.impl;

import data.dao.RoomTypeDao;
import data.driver.MySQLDriver;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RoomType;

public class RoomTypeImpl implements RoomTypeDao {

    @Override
    public List<RoomType> findAll() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY price ASC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            while (rs.next()) {
                list.add(new RoomType(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<RoomType> findFeatured(int limit) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types ORDER BY id ASC LIMIT ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, limit);
            try (ResultSet rs = sttm.executeQuery()) {
                while (rs.next()) {
                    list.add(new RoomType(rs));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public RoomType findById(int id) {
        String sql = "SELECT * FROM room_types WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, id);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new RoomType(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insert(RoomType type) {
        String sql = "INSERT INTO room_types(name, description, price, capacity, bed, image, rules, amenities) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, type.getName());
            sttm.setString(2, type.getDescription());
            sttm.setDouble(3, type.getPrice());
            sttm.setInt(4, type.getCapacity());
            sttm.setInt(5, type.getBed());
            sttm.setString(6, type.getImage());
            sttm.setString(7, type.getRules());
            sttm.setString(8, type.getAmenities());
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(RoomType type) {
        String sql = "UPDATE room_types SET name = ?, description = ?, price = ?, capacity = ?, bed = ?, image = ?, rules = ?, amenities = ? WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, type.getName());
            sttm.setString(2, type.getDescription());
            sttm.setDouble(3, type.getPrice());
            sttm.setInt(4, type.getCapacity());
            sttm.setInt(5, type.getBed());
            sttm.setString(6, type.getImage());
            sttm.setString(7, type.getRules());
            sttm.setString(8, type.getAmenities());
            sttm.setInt(9, type.getId());
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM room_types WHERE id = ?";
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
