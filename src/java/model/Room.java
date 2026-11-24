package model;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Room {
    private int id;
    private String code;
    private int roomTypeId;
    private String roomTypeName;
    private double price;
    private int status; // 1: active, 0: inactive

    public Room() {}

    public Room(int id, String code, int roomTypeId, int status) {
        this.id = id;
        this.code = code;
        this.roomTypeId = roomTypeId;
        this.status = status;
    }

    public Room(ResultSet rs) throws SQLException {
        this.id = rs.getInt("id");
        this.code = rs.getString("code");
        this.roomTypeId = rs.getInt("room_type_id");
        this.status = rs.getInt("status");
        try {
            this.roomTypeName = rs.getString("room_type_name");
        } catch (Exception ignored) {}
        try {
            this.price = rs.getDouble("price");
        } catch (Exception ignored) {}
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public boolean isActive() { return status == 1; }
    public String getStatusText() { return status == 1 ? "Active" : "Inactive"; }
}
