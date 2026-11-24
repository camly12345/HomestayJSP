package data.dao;

import java.sql.Date;
import java.util.List;
import model.Room;

public interface RoomDao {
    List<Room> findAll();
    List<Room> findByRoomTypeId(int roomTypeId);
    Room findById(int id);
    Room findByCode(String code);
    int countAvailable(int roomTypeId, Date checkIn, Date checkOut);
    Room findFirstAvailableRoom(int roomTypeId, Date checkIn, Date checkOut);
    boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut);
    boolean insert(Room room);
    boolean update(Room room);
    boolean updateStatus(int id, int status);
    boolean delete(int id);
}
