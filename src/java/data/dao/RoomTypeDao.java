package data.dao;

import java.util.List;
import model.RoomType;

public interface RoomTypeDao {
    List<RoomType> findAll();
    List<RoomType> findFeatured(int limit);
    RoomType findById(int id);
    boolean insert(RoomType type);
    boolean update(RoomType type);
    boolean delete(int id);
}
