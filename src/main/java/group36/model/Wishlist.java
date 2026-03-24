package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Wishlist implements Serializable {
    private int id;
    private int userId;
    private int productId;
    private Timestamp createdAt;

    private Product product;

    public Wishlist() {
    }

    public Wishlist(int userId, int productId) {
        this.userId = userId;
        this.productId = productId;
    }

    public Wishlist(int id, int userId, int productId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public String toString() {
        return "Wishlist{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", createdAt=" + createdAt +
                '}';
    }
}
