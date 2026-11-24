package data.dao;

import data.impl.BookingImpl;
import data.impl.RoomImpl;
import data.impl.RoomTypeImpl;
import data.impl.UserImpl;

public class Database {
    public static UserDao getUserDao() {
        return new UserImpl();
    }

    public static RoomTypeDao getRoomTypeDao() {
        return new RoomTypeImpl();
    }

    public static RoomDao getRoomDao() {
        return new RoomImpl();
    }

    public static BookingDao getBookingDao() {
        return new BookingImpl();
    }
}
