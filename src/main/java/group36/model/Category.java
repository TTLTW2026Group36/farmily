package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;





public class Category implements Serializable {
    private int id;
    private String name;
    private String imageUrl;
    private Timestamp createdAt;

    
    public Category() {
    }

    public Category(int id, String name, String imageUrl, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    public Category(String name, String imageUrl) {
        this.name = name;
        this.imageUrl = imageUrl;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
