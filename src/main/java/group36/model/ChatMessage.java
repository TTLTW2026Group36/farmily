package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;

public class ChatMessage implements Serializable {

    public static final String SENDER_CUSTOMER = "customer";
    public static final String SENDER_ADMIN    = "admin";

    private int id;
    private int conversationId;
    private int senderId;
    private String senderType;
    private String content;
    private boolean isRead;
    private Timestamp createdAt;

    private User sender;

    public ChatMessage() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public User getSender() { return sender; }
    public void setSender(User sender) { this.sender = sender; }

    public boolean isFromCustomer() { return SENDER_CUSTOMER.equals(senderType); }
    public boolean isFromAdmin()    { return SENDER_ADMIN.equals(senderType); }

    public String getTimeAgo() {
        if (createdAt == null) return "";
        Duration d = Duration.between(createdAt.toInstant(), Instant.now());
        long s = d.getSeconds();
        if (s < 60)     return "Vừa xong";
        if (s < 3600)   return (s / 60) + " phút trước";
        if (s < 86400)  return (s / 3600) + " giờ trước";
        return (s / 86400) + " ngày trước";
    }

    public String getFormattedTime() {
        if (createdAt == null) return "";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm dd/MM");
        return sdf.format(createdAt);
    }

    @Override
    public String toString() {
        return "ChatMessage{id=" + id + ", conversationId=" + conversationId + ", senderType='" + senderType + "'}";
    }
}
