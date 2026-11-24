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
    private String rules;
    private String amenities;

    public RoomType() {}

    public RoomType(int id, String name, String description, double price, int capacity, int bed, String image) {
        this(id, name, description, price, capacity, bed, image, "Cấm hút thuốc", "Wifi, Điều hòa");
    }

    public RoomType(int id, String name, String description, double price, int capacity, int bed, String image, String rules, String amenities) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.capacity = capacity;
        this.bed = bed;
        this.image = image;
        this.rules = rules;
        this.amenities = amenities;
    }

    public RoomType(ResultSet rs) throws SQLException {
        this.id = rs.getInt("id");
        this.name = rs.getString("name");
        this.description = rs.getString("description");
        this.price = rs.getDouble("price");
        this.capacity = rs.getInt("capacity");
        this.bed = rs.getInt("bed");
        this.image = rs.getString("image");
        try {
            this.rules = rs.getString("rules");
        } catch (Exception ignored) {
            this.rules = "Cấm hút thuốc";
        }
        try {
            this.amenities = rs.getString("amenities");
        } catch (Exception ignored) {
            this.amenities = "Wifi, Điều hòa";
        }
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

    public String getImage() { return image != null ? image : ""; }
    public void setImage(String image) { this.image = image; }

    public String getRules() { return rules != null ? rules : "Cấm hút thuốc"; }
    public void setRules(String rules) { this.rules = rules; }

    public String getAmenities() { return amenities != null ? amenities : "Wifi, Điều hòa"; }
    public void setAmenities(String amenities) { this.amenities = amenities; }

    public String getFormattedPrice() {
        return API.formatCurrency(this.price);
    }

    public String getFormattedBed() {
        return this.bed + " giường";
    }
}
