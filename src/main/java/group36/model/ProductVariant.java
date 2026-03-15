package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;






public class ProductVariant implements Serializable {
    private int id;
    private int productId;
    private String optionsValue; 
    private int stock;
    private double price;
    private Timestamp createdAt;

    
    public ProductVariant() {
    }

    public ProductVariant(int productId, String optionsValue, int stock, double price) {
        this.productId = productId;
        this.optionsValue = optionsValue;
        this.stock = stock;
        this.price = price;
    }

    public ProductVariant(int id, int productId, String optionsValue, int stock, double price, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.optionsValue = optionsValue;
        this.stock = stock;
        this.price = price;
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

    public String getOptionsValue() {
        return optionsValue;
    }

    public void setOptionsValue(String optionsValue) {
        this.optionsValue = optionsValue;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    




    public boolean isInStock() {
        return stock > 0;
    }

    




    public String getFormattedPrice() {
        return String.format("%,.0f", price).replace(",", ".") + "đ";
    }

    





    public double getSalePrice(double discountPercent) {
        return price * (1 - discountPercent / 100);
    }

    @Override
    public String toString() {
        return "ProductVariant{" +
                "id=" + id +
                ", productId=" + productId +
                ", optionsValue='" + optionsValue + '\'' +
                ", stock=" + stock +
                ", price=" + price +
                ", createdAt=" + createdAt +
                '}';
    }
}
