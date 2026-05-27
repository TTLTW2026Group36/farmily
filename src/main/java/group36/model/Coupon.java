package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Coupon implements Serializable {
    private int id;
    private String code;
    private String discountType;
    private double discountValue;
    private Double maxDiscount;
    private double minOrderValue;
    private int quantity;
    private int usedCount;
    private int maxUsagePerUser;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Coupon() {
    }

    public Coupon(String code, String discountType, double discountValue, Double maxDiscount,
                  double minOrderValue, int quantity, int maxUsagePerUser, Timestamp startDate,
                  Timestamp endDate, boolean isActive) {
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.maxDiscount = maxDiscount;
        this.minOrderValue = minOrderValue;
        this.quantity = quantity;
        this.maxUsagePerUser = maxUsagePerUser;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public Double getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(Double maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public int getMaxUsagePerUser() {
        return maxUsagePerUser;
    }

    public void setMaxUsagePerUser(int maxUsagePerUser) {
        this.maxUsagePerUser = maxUsagePerUser;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStatus() {
        if (!isActive) {
            return "disabled";
        }
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (now.before(startDate)) {
            return "upcoming";
        }
        if (now.after(endDate)) {
            return "expired";
        }
        if (usedCount >= quantity) {
            return "exhausted";
        }
        return "active";
    }

    public boolean isValid() {
        return "active".equals(getStatus());
    }

    public String getStatusText() {
        String status = getStatus();
        if ("active".equals(status)) {
            return "Đang hoạt động";
        }
        if ("upcoming".equals(status)) {
            return "Sắp diễn ra";
        }
        if ("expired".equals(status)) {
            return "Đã hết hạn";
        }
        if ("disabled".equals(status)) {
            return "Đã tắt";
        }
        if ("exhausted".equals(status)) {
            return "Đã hết lượt";
        }
        return status;
    }

    public String getStatusBadgeClass() {
        String status = getStatus();
        if ("active".equals(status)) {
            return "active";
        }
        if ("upcoming".equals(status)) {
            return "upcoming";
        }
        if ("expired".equals(status) || "exhausted".equals(status)) {
            return "expired";
        }
        if ("disabled".equals(status)) {
            return "disabled";
        }
        return "expired";
    }

    public String getDiscountTypeText() {
        if ("percent".equals(discountType)) {
            return "Giảm %";
        }
        if ("fixed".equals(discountType)) {
            return "Giảm tiền";
        }
        if ("freeship".equals(discountType)) {
            return "Freeship";
        }
        return discountType;
    }

    public int getRemainingCount() {
        return Math.max(0, quantity - usedCount);
    }
}
