package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;






public class ProductImage implements Serializable {
    private int id;
    private int productId;
    private String imageUrl;
    private Timestamp createdAt;

    
    public ProductImage() {
    }

    public ProductImage(int productId, String imageUrl) {
        this.productId = productId;
        this.imageUrl = imageUrl;
    }

    public ProductImage(int id, int productId, String imageUrl, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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
        return "ProductImage{" +
                "id=" + id +
                ", productId=" + productId +
                ", imageUrl='" + imageUrl + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
