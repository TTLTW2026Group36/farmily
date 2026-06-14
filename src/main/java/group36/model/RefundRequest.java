package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

public class RefundRequest implements Serializable {

    public static final String STATUS_PENDING  = "pending";
    public static final String STATUS_APPROVED = "approved";
    public static final String STATUS_REJECTED = "rejected";
    public static final String STATUS_REFUNDED = "refunded";

    public static final List<String> REASONS = Arrays.asList(
            "Rau củ bị dập nát",
            "Hàng bị mốc mọt",
            "Giao thiếu số lượng",
            "Sai sản phẩm",
            "Lý do khác"
    );

    private int id;
    private int orderId;
    private int userId;
    private String reason;
    private String description;
    private String bankName;
    private String bankAccount;
    private String bankHolder;
    private double refundAmount;
    private String status;
    private String adminNote;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private List<RefundRequestImage> images;
    private Order order;
    private User user;

    public RefundRequest() {
        this.status = STATUS_PENDING;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getBankHolder() { return bankHolder; }
    public void setBankHolder(String bankHolder) { this.bankHolder = bankHolder; }

    public double getRefundAmount() { return refundAmount; }
    public void setRefundAmount(double refundAmount) { this.refundAmount = refundAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public List<RefundRequestImage> getImages() { return images; }
    public void setImages(List<RefundRequestImage> images) { this.images = images; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getStatusText() {
        if (status == null) return "";
        switch (status) {
            case STATUS_PENDING:  return "Chờ duyệt";
            case STATUS_APPROVED: return "Đã duyệt";
            case STATUS_REJECTED: return "Từ chối";
            case STATUS_REFUNDED: return "Đã hoàn tiền";
            default:              return status;
        }
    }

    public String getStatusClass() {
        if (status == null) return "pending";
        return status;
    }

    public String getFormattedRefundAmount() {
        return String.format("%,.0f", refundAmount).replace(",", ".") + "đ";
    }

    public boolean isPending()  { return STATUS_PENDING.equals(status); }
    public boolean isApproved() { return STATUS_APPROVED.equals(status); }
    public boolean isRejected() { return STATUS_REJECTED.equals(status); }
    public boolean isRefunded() { return STATUS_REFUNDED.equals(status); }

    public boolean hasImages() {
        return images != null && !images.isEmpty();
    }

    public String getFormattedDate() {
        if (createdAt == null) return "";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
        return sdf.format(createdAt);
    }

    @Override
    public String toString() {
        return "RefundRequest{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", userId=" + userId +
                ", reason='" + reason + '\'' +
                ", status='" + status + '\'' +
                ", refundAmount=" + refundAmount +
                ", createdAt=" + createdAt +
                '}';
    }
}
