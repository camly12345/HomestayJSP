package data.dao;

import java.sql.Date;
import java.util.List;
import model.Booking;

public interface BookingDao {
    List<Booking> findAll();
    List<Booking> findByUserId(int userId);
    List<Booking> findByPhone(String phone);
    Booking findById(int id);
    Booking findByCode(String code);
    boolean insert(Booking booking);
    boolean updateStatus(int id, String status);
    boolean updatePayStatus(int id, String payStatus);
    boolean assignRoom(int bookingId, int roomId);
    int countTotalBookings();
    int countActiveGuests();
    double calculateTotalRevenue();
}
