package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;

public class ChatConversation implements Serializable {

    public static final String STATUS_OPEN   = "open";
    public static final String STATUS_CLOSED = "closed";

    private int id;
    private int userId;
    private Integer refundRequestId;
    private String subject;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private User user;
    private RefundRequest refundRequest;
    private ChatMessage lastMessage;
    private int unreadCount;

    public ChatConversation() {
        this.status = STATUS_OPEN;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getRefundRequestId() { return refundRequestId; }
    public void setRefundRequestId(Integer refundRequestId) { this.refundRequestId = refundRequestId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public RefundRequest getRefundRequest() { return refundRequest; }
    public void setRefundRequest(RefundRequest refundRequest) { this.refundRequest = refundRequest; }

    public ChatMessage getLastMessage() { return lastMessage; }
    public void setLastMessage(ChatMessage lastMessage) { this.lastMessage = lastMessage; }

    public int getUnreadCount() { return unreadCount; }
    public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }

    public boolean isOpen()   { return STATUS_OPEN.equals(status); }
    public boolean isClosed() { return STATUS_CLOSED.equals(status); }

    public String getStatusText() {
        if (STATUS_OPEN.equals(status))   return "Đang mở";
        if (STATUS_CLOSED.equals(status)) return "Đã đóng";
        return status != null ? status : "";
    }

    public String getTimeAgo() {
        Timestamp ts = updatedAt != null ? updatedAt : createdAt;
        if (ts == null) return "";
        Duration d = Duration.between(ts.toInstant(), Instant.now());
        long s = d.getSeconds();
        if (s < 60)     return "Vừa xong";
        if (s < 3600)   return (s / 60) + " phút trước";
        if (s < 86400)  return (s / 3600) + " giờ trước";
        if (s < 604800) return (s / 86400) + " ngày trước";
        return (s / 604800) + " tuần trước";
    }

    public String getDisplaySubject() {
        if (refundRequestId != null) {
            if (refundRequest != null) {
                return "Hỗ trợ hoàn tiền đơn hàng #" + refundRequest.getOrderId();
            }
            return "Hỗ trợ hoàn tiền đơn hàng";
        }
        if (subject != null && !subject.isEmpty()) return subject;
        return "Cuộc hội thoại #" + id;
    }

    @Override
    public String toString() {
        return "ChatConversation{id=" + id + ", userId=" + userId + ", status='" + status + "'}";
    }
}
