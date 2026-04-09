package group36.model;

import java.sql.Timestamp;

public class RefreshToken {
    private int id;
    private int userId;
    private String token;
    private Timestamp expireAt;
    private boolean revoked;
    private String replacedByToken;
    private Timestamp issueAt;

    public RefreshToken(int id, int userId, String token, Timestamp expireAt, boolean revoked, String replacedByToken, Timestamp issueAt) {
        this.id = id;
        this.userId = userId;
        this.token = token;
        this.expireAt = expireAt;
        this.revoked = revoked;
        this.replacedByToken = replacedByToken;
        this.issueAt = issueAt;
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

    public boolean isRevoked() {
        return revoked;
    }

    public void setRevoked(boolean revoked) {
        this.revoked = revoked;
    }

    public String getReplacedByToken() {
        return replacedByToken;
    }

    public void setReplacedByToken(String replacedByToken) {
        this.replacedByToken = replacedByToken;
    }

    public Timestamp getIssueAt() {
        return issueAt;
    }

    public void setIssueAt(Timestamp issueAt) {
        this.issueAt = issueAt;
    }
}
