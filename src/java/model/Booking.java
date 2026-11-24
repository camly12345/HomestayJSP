package model;

import data.utils.API;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Booking {
    private int id;
    private String code;
    private Integer userId;
    private Integer roomId;
    private String roomCode;
    private int roomTypeId;
    private String roomTypeName;
    private String guestName;
    private String guestPhone;
    private String guestEmail;
    private String address;
    private Date checkIn;
    private Date checkOut;
    private int guests;
    private double totalPrice;
    private String payStatus; // 'unpaid', 'paid'
    private String payMethod; // 'cash', 'transfer'
    private String status;    // 'pending', 'confirmed', 'checkedin', 'checkedout', 'cancelled'
    private String note;
    private Timestamp createdAt;

    public Booking() {}

    public Booking(ResultSet rs) throws SQLException {
        this.id = rs.getInt("id");
        this.code = rs.getString("code");
        this.userId = (Integer) rs.getObject("user_id");
        this.roomId = (Integer) rs.getObject("room_id");
        this.roomTypeId = rs.getInt("room_type_id");
        this.guestName = rs.getString("guest_name");
        this.guestPhone = rs.getString("guest_phone");
        this.guestEmail = rs.getString("guest_email");
        try {
            this.address = rs.getString("address");
        } catch (Exception ignored) {}
        this.checkIn = rs.getDate("check_in");
        this.checkOut = rs.getDate("check_out");
        this.guests = rs.getInt("guests");
        this.totalPrice = rs.getDouble("total_price");
        this.payStatus = rs.getString("pay_status");
        this.payMethod = rs.getString("pay_method");
        this.status = rs.getString("status");
        this.note = rs.getString("note");
        this.createdAt = rs.getTimestamp("created_at");

        try {
            this.roomCode = rs.getString("room_code");
        } catch (Exception ignored) {}
        try {
            this.roomTypeName = rs.getString("room_type_name");
        } catch (Exception ignored) {}
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }

    public String getRoomCode() { return roomCode; }
    public void setRoomCode(String roomCode) { this.roomCode = roomCode; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }

    public String getGuestEmail() { return guestEmail; }
    public void setGuestEmail(String guestEmail) { this.guestEmail = guestEmail; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }

    public String getPayMethod() { return payMethod; }
    public void setPayMethod(String payMethod) { this.payMethod = payMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getFormattedTotal() {
        return API.formatCurrency(this.totalPrice);
    }

    public int getNights() {
        return API.nights(this.checkIn, this.checkOut);
    }
}
