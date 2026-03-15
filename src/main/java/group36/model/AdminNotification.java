package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;





public class AdminNotification implements Serializable {
    private int id;
    private String type;
    private String title;
    private String message;
    private Integer referenceId;
    private String referenceType;
    private boolean isRead;
    private Timestamp createdAt;

    
    public static final String TYPE_NEW_ORDER = "new_order";
    public static final String TYPE_ORDER_CANCELLED = "order_cancelled";
    public static final String TYPE_LOW_STOCK = "low_stock";
    public static final String TYPE_NEW_USER = "new_user";
    public static final String TYPE_SYSTEM = "system";

    
    public AdminNotification() {
        this.isRead = false;
    }

    public AdminNotification(String type, String title, String message) {
        this.type = type;
        this.title = title;
        this.message = message;
        this.isRead = false;
    }

    
    public static AdminNotification forNewOrder(int orderId, String customerName, double totalPrice) {
        AdminNotification notification = new AdminNotification();
        notification.setType(TYPE_NEW_ORDER);
        notification.setTitle("Đơn hàng mới #" + orderId);
        notification.setMessage("Khách hàng " + customerName + " đã đặt hàng " +
                String.format("%,.0f", totalPrice).replace(",", ".") + "đ");
        notification.setReferenceId(orderId);
        notification.setReferenceType("order");
        return notification;
    }

    public static AdminNotification forOrderCancelled(int orderId, String customerName) {
        AdminNotification notification = new AdminNotification();
        notification.setType(TYPE_ORDER_CANCELLED);
        notification.setTitle("Đơn hàng #" + orderId + " đã bị hủy");
        notification.setMessage("Khách hàng " + customerName + " đã hủy đơn hàng");
        notification.setReferenceId(orderId);
        notification.setReferenceType("order");
        return notification;
    }

    public static AdminNotification forLowStock(int productId, String productName, int currentStock) {
        AdminNotification notification = new AdminNotification();
        notification.setType(TYPE_LOW_STOCK);
        notification.setTitle("Sản phẩm sắp hết hàng");
        notification.setMessage(productName + " chỉ còn " + currentStock + " trong kho");
        notification.setReferenceId(productId);
        notification.setReferenceType("product");
        return notification;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    

    


    public String getIcon() {
        switch (type) {
            case TYPE_NEW_ORDER:
                return "fa-shopping-cart";
            case TYPE_ORDER_CANCELLED:
                return "fa-times-circle";
            case TYPE_LOW_STOCK:
                return "fa-exclamation-triangle";
            case TYPE_NEW_USER:
                return "fa-user-plus";
            default:
                return "fa-bell";
        }
    }

    


    public String getIconClass() {
        switch (type) {
            case TYPE_NEW_ORDER:
                return "order";
            case TYPE_ORDER_CANCELLED:
                return "danger";
            case TYPE_LOW_STOCK:
                return "warning";
            case TYPE_NEW_USER:
                return "success";
            default:
                return "info";
        }
    }

    


    public String getLink(String contextPath) {
        if (referenceType == null || referenceId == null) {
            return contextPath + "/admin/notifications";
        }

        switch (referenceType) {
            case "order":
                return contextPath + "/admin/orders/detail?id=" + referenceId;
            case "product":
                return contextPath + "/admin/products/edit?id=" + referenceId;
            case "user":
                return contextPath + "/admin/users/detail?id=" + referenceId;
            default:
                return contextPath + "/admin/notifications";
        }
    }

    


    public String getTimeAgo() {
        if (createdAt == null) {
            return "";
        }

        Instant now = Instant.now();
        Instant created = createdAt.toInstant();
        Duration duration = Duration.between(created, now);

        long seconds = duration.getSeconds();

        if (seconds < 60) {
            return "Vừa xong";
        } else if (seconds < 3600) {
            long minutes = seconds / 60;
            return minutes + " phút trước";
        } else if (seconds < 86400) {
            long hours = seconds / 3600;
            return hours + " giờ trước";
        } else if (seconds < 604800) {
            long days = seconds / 86400;
            return days + " ngày trước";
        } else {
            long weeks = seconds / 604800;
            return weeks + " tuần trước";
        }
    }

    @Override
    public String toString() {
        return "AdminNotification{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", title='" + title + '\'' +
                ", isRead=" + isRead +
                ", createdAt=" + createdAt +
                '}';
    }
}
