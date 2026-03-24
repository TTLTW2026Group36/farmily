package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;





public class FlashSale implements Serializable {
    private int id;
    private int productId;
    private double discountPercent;
    private int soldCount;
    private int stockLimit;
    private Timestamp startTime;
    private Timestamp endTime;

    
    private Product product;

    
    public FlashSale() {
    }

    public FlashSale(int productId, double discountPercent,
            int stockLimit, Timestamp startTime, Timestamp endTime) {
        this.productId = productId;
        this.discountPercent = discountPercent;
        this.stockLimit = stockLimit;
        this.startTime = startTime;
        this.endTime = endTime;
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

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(int soldCount) {
        this.soldCount = soldCount;
    }

    public int getStockLimit() {
        return stockLimit;
    }

    public void setStockLimit(int stockLimit) {
        this.stockLimit = stockLimit;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    

    





    public double getSalePrice(double originalPrice) {
        if (discountPercent <= 0 || discountPercent >= 100) {
            return originalPrice;
        }
        return originalPrice * (1 - discountPercent / 100);
    }

    




    public double getOriginalPrice() {
        return product != null ? product.getMinPrice() : 0;
    }

    




    public double getSalePrice() {
        return getSalePrice(getOriginalPrice());
    }

    




    public int getSoldPercentage() {
        if (stockLimit <= 0) {
            return 0;
        }
        return Math.min(100, (soldCount * 100) / stockLimit);
    }

    




    public int getRemainingStock() {
        return Math.max(0, stockLimit - soldCount);
    }

    




    public boolean isActive() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return now.after(startTime) && now.before(endTime);
    }

    @Override
    public String toString() {
        return "FlashSale{" +
                "id=" + id +
                ", productId=" + productId +
                ", discountPercent=" + discountPercent +
                ", soldCount=" + soldCount +
                ", stockLimit=" + stockLimit +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                '}';
    }
}
