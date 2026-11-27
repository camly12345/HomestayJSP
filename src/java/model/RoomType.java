package model;

import data.utils.API;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RoomType {
    private int id;
    private String name;
    private String description;
    private double price;
    private int capacity;
    private int bed;
    private String image;

    public RoomType() {}

    public RoomType(int id, String name, String description, double price, int capacity, int bed, String image) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.capacity = capacity;
        this.bed = bed;
        this.image = image;
    }

    public RoomType(ResultSet rs) throws SQLException {
        this.id = rs.getInt("id");
        this.name = rs.getString("name");
        this.description = rs.getString("description");
        this.price = rs.getDouble("price");
        this.capacity = rs.getInt("capacity");
        this.bed = rs.getInt("bed");
        this.image = rs.getString("image");
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description != null ? description : ""; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getBed() { return bed; }
    public void setBed(int bed) { this.bed = bed; }

    public String getImage() {
        if (image == null || image.trim().isEmpty()) {
            return "https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000";
        }
        String img = image.trim();
        // Xử lý tự động nếu người dùng vô tình lưu đường dẫn tuyệt đối của máy tính (C:\...)
        if (img.startsWith("C:") || img.startsWith("c:") || img.contains("\\")) {
            int lastSlash = Math.max(img.lastIndexOf('\\'), img.lastIndexOf('/'));
            String fileName = (lastSlash >= 0) ? img.substring(lastSlash + 1) : img;
            if (!fileName.contains(".")) {
                fileName += ".jpg";
            }
            return "/Homestay/images/rooms/" + fileName;
        }
        if (img.startsWith("http://") || img.startsWith("https://") || img.startsWith("/")) {
            return img;
        }
        return "/Homestay/" + img;
    }

    public void setImage(String image) { this.image = image; }

    public String getFormattedPrice() {
        return API.formatCurrency(this.price);
    }

    public String getFormattedBed() {
        return this.bed + " giường";
    }
}
