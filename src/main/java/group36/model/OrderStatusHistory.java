package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class OrderStatusHistory implements Serializable {
    private int id;
    private int orderId;
    private String oldStatus;
    private String newStatus;
    private String changedBy;
    private Integer changedById;
    private String note;
    private Timestamp createdAt;

    public OrderStatusHistory() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(String changedBy) {
        this.changedBy = changedBy;
    }

    public Integer getChangedById() {
        return changedById;
    }

    public void setChangedById(Integer changedById) {
        this.changedById = changedById;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getChangedByText() {
        if ("admin".equals(changedBy))
            return "Admin";
        if ("user".equals(changedBy))
            return "Khách hàng";
        if ("system".equals(changedBy))
            return "Hệ thống";
        return changedBy;
    }

    public String getOldStatusText() {
        if (oldStatus == null)
            return "Mới tạo";
        return getStatusText(oldStatus);
    }

    public String getNewStatusText() {
        return getStatusText(newStatus);
    }

    private String getStatusText(String status) {
        if (status == null)
            return "";
        switch (status) {
            case Order.STATUS_PENDING:
                return "Chờ xác nhận";
            case Order.STATUS_CONFIRMED:
                return "Đang xử lý";
            case Order.STATUS_PROCESSING:
                return "Đang xử lý";
            case Order.STATUS_SHIPPING:
                return "Đang giao";
            case Order.STATUS_DELIVERED:
                return "Hoàn thành";
            case Order.STATUS_CANCELLED:
                return "Đã hủy";
            case Order.STATUS_PAYMENT_EXPIRED:
                return "Thanh toán hết hạn";
            case Order.STATUS_DELIVERY_FAILED:
                return "Giao thất bại";
            case Order.STATUS_RETURNED:
                return "Hoàn hàng";
            case Order.STATUS_REFUNDED:
                return "Hoàn tiền";
            case Order.STATUS_CANCELLED_BY_ADMIN:
                return "Hủy bởi admin";
            default:
                return status;
        }
    }
}
