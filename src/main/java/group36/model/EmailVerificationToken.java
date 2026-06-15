package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class EmailVerificationToken implements Serializable {
    private int id;
    private int userId;
    private String token;
    private Timestamp expireAt;

    public EmailVerificationToken() {
    }

    public EmailVerificationToken(int id, int userId, String token, Timestamp expireAt) {
        this.id = id;
        this.userId = userId;
        this.token = token;
        this.expireAt = expireAt;
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

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpireAt() {
        return expireAt;
    }

    public void setExpireAt(Timestamp expireAt) {
        this.expireAt = expireAt;
    }
}
