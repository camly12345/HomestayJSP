package data.dao;

import java.util.List;
import model.User;

public interface UserDao {
    User findUser(String emailOrPhone, String password);
    User findUserByEmailOrPhone(String emailOrPhone);
    User findById(int id);
    boolean insertUser(String name, String email, String phone, String password, String role);
    List<User> findAllCustomers();
    List<User> findAll();
}
