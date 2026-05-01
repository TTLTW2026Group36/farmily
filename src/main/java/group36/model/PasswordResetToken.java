package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class PasswordResetToken implements Serializable {
    private int id;
    private int userId;
    private String email;
    private String token;
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private boolean used;

    public PasswordResetToken() {
    }

    public PasswordResetToken(int userId, String email, String token, Timestamp expiresAt) {
        this.userId = userId;
        this.email = email;
        this.token = token;
        this.expiresAt = expiresAt;
        this.used = false;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public boolean isExpired() {
        return expiresAt != null && expiresAt.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isValid() {
        return !isExpired() && !isUsed();
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" +
                "id=" + id +
                ", userId=" + userId +
                ", email='" + email + '\'' +
                ", token='" + token + '\'' +
                ", expiresAt=" + expiresAt +
                ", used=" + used +
                '}';
    }
}
