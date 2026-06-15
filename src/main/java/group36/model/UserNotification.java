package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;

public class UserNotification implements Serializable {

    private int id;
    private int userId;
    private String type;
    private String title;
    private String message;
    private String link;
    private Integer referenceId;
    private String referenceType;
    private boolean isRead;
    private Timestamp createdAt;

    public static final String TYPE_ORDER_STATUS = "order_status";
    public static final String TYPE_FLASH_SALE   = "flash_sale";
    public static final String TYPE_COUPON       = "coupon";
    public static final String TYPE_BROADCAST    = "broadcast";

    public UserNotification() {
        this.isRead = false;
    }

    public UserNotification(int userId, String type, String title, String message, String link) {
        this.userId = userId;
        this.type = type;
        this.title = title;
        this.message = message;
        this.link = link;
        this.isRead = false;
    }

    public static UserNotification forOrderStatus(int userId, int orderId, String newStatus, String contextPath) {
        UserNotification n = new UserNotification();
        n.setUserId(userId);
        n.setType(TYPE_ORDER_STATUS);
        n.setReferenceId(orderId);
        n.setReferenceType("order");
        n.setLink(contextPath + "/ho-so/don-hang/" + orderId);

        switch (newStatus) {
            case Order.STATUS_CONFIRMED:
                n.setTitle("Đơn hàng #" + orderId + " đã được xác nhận");
                n.setMessage("Đơn hàng của bạn đang được xử lý bởi cửa hàng.");
                break;
            case Order.STATUS_PROCESSING:
                n.setTitle("Đơn hàng #" + orderId + " đang được xử lý");
                n.setMessage("Cửa hàng đang chuẩn bị hàng cho bạn.");
                break;
            case Order.STATUS_SHIPPING:
                n.setTitle("Đơn hàng #" + orderId + " đang được giao");
                n.setMessage("Đơn hàng đã được giao cho đơn vị vận chuyển.");
                break;
            case Order.STATUS_DELIVERED:
                n.setTitle("Đơn hàng #" + orderId + " hoàn thành");
                n.setMessage("Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua hàng!");
                break;
            case Order.STATUS_CANCELLED_BY_ADMIN:
                n.setTitle("Đơn hàng #" + orderId + " đã bị hủy");
                n.setMessage("Đơn hàng của bạn đã bị hủy bởi cửa hàng. Vui lòng liên hệ để biết thêm.");
                break;
            case Order.STATUS_DELIVERY_FAILED:
                n.setTitle("Đơn hàng #" + orderId + " giao không thành công");
                n.setMessage("Đơn hàng giao không thành công. Vui lòng liên hệ với cửa hàng.");
                break;
            case Order.STATUS_RETURNED:
                n.setTitle("Đơn hàng #" + orderId + " đã được hoàn trả");
                n.setMessage("Đơn hàng của bạn đã được tiếp nhận hoàn trả.");
                break;
            case Order.STATUS_REFUNDED:
                n.setTitle("Đơn hàng #" + orderId + " đã được hoàn tiền");
                n.setMessage("Yêu cầu hoàn tiền của bạn đã được xử lý thành công.");
                break;
            default:
                n.setTitle("Đơn hàng #" + orderId + " đã cập nhật");
                n.setMessage("Trạng thái đơn hàng của bạn đã thay đổi.");
        }
        return n;
    }

    public String getIcon() {
        if (type == null) return "fa-bell";
        switch (type) {
            case TYPE_ORDER_STATUS: return "fa-box";
            case TYPE_FLASH_SALE:  return "fa-bolt";
            case TYPE_COUPON:      return "fa-ticket-alt";
            case TYPE_BROADCAST:   return "fa-bullhorn";
            default:               return "fa-bell";
        }
    }

    public String getIconClass() {
        if (type == null) return "info";
        switch (type) {
            case TYPE_ORDER_STATUS: return "order";
            case TYPE_FLASH_SALE:   return "warning";
            case TYPE_COUPON:       return "success";
            case TYPE_BROADCAST:    return "info";
            default:                return "info";
        }
    }

    public String getTimeAgo() {
        if (createdAt == null) return "";
        Instant now = Instant.now();
        Instant created = createdAt.toInstant();
        long seconds = Duration.between(created, now).getSeconds();

        if (seconds < 60)     return "Vừa xong";
        if (seconds < 3600)   return (seconds / 60) + " phút trước";
        if (seconds < 86400)  return (seconds / 3600) + " giờ trước";
        if (seconds < 604800) return (seconds / 86400) + " ngày trước";
        return (seconds / 604800) + " tuần trước";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public Integer getReferenceId() { return referenceId; }
    public void setReferenceId(Integer referenceId) { this.referenceId = referenceId; }

    public String getReferenceType() { return referenceType; }
    public void setReferenceType(String referenceType) { this.referenceType = referenceType; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "UserNotification{id=" + id + ", userId=" + userId
                + ", type='" + type + "', title='" + title
                + "', isRead=" + isRead + ", createdAt=" + createdAt + '}';
    }
}
