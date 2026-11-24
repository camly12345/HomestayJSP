package data.impl;

import data.dao.UserDao;
import data.driver.MySQLDriver;
import data.utils.API;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserImpl implements UserDao {

    @Override
    public User findUser(String emailOrPhone, String password) {
        String md5 = API.getMd5(password);
        String sql = "SELECT * FROM users WHERE (email = ? OR phone = ?) AND (password = ? OR password = ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, emailOrPhone);
            sttm.setString(2, emailOrPhone);
            sttm.setString(3, md5);
            sttm.setString(4, password); // fallback in case plain text
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new User(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public User findUserByEmailOrPhone(String emailOrPhone) {
        String sql = "SELECT * FROM users WHERE email = ? OR phone = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, emailOrPhone);
            sttm.setString(2, emailOrPhone);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new User(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setInt(1, id);
            try (ResultSet rs = sttm.executeQuery()) {
                if (rs.next()) {
                    return new User(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insertUser(String name, String email, String phone, String password, String role) {
        String md5 = API.getMd5(password);
        String sql = "INSERT INTO users(name, email, phone, password, role) VALUES(?, ?, ?, ?, ?)";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql)) {
            sttm.setString(1, name);
            sttm.setString(2, email);
            sttm.setString(3, phone);
            sttm.setString(4, md5);
            sttm.setString(5, (role == null || role.isEmpty()) ? "customer" : role);
            return sttm.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public List<User> findAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'customer' OR role = '' ORDER BY id DESC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            while (rs.next()) {
                list.add(new User(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection con = MySQLDriver.getConnection();
             PreparedStatement sttm = con.prepareStatement(sql);
             ResultSet rs = sttm.executeQuery()) {
            while (rs.next()) {
                list.add(new User(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ? AND role != 'admin'";
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
