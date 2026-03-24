package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;





public class Cart implements Serializable {
    private int id;
    private int userId;
    private Timestamp createdAt;

    
    private List<CartItem> items;

    
    public Cart() {
        this.items = new ArrayList<>();
    }

    public Cart(int userId) {
        this.userId = userId;
        this.items = new ArrayList<>();
    }

    public Cart(int id, int userId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.items = new ArrayList<>();
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items != null ? items : new ArrayList<>();
    }

    

    




    public int getTotalItems() {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        return items.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    




    public double getTotalAmount() {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        return items.stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
    }

    




    public String getFormattedTotalAmount() {
        return String.format("%,.0f", getTotalAmount()).replace(",", ".") + "đ";
    }

    




    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }

    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", userId=" + userId +
                ", createdAt=" + createdAt +
                ", itemCount=" + (items != null ? items.size() : 0) +
                '}';
    }
}
