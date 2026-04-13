package group36.model;

import java.sql.Timestamp;

public class RefreshToken {
    private int id;
    private int user_id;
    private String token;
    private Timestamp expires_at;
    private boolean revoked;
    private String replaced_by_token;
    private Timestamp issued_at;

    public RefreshToken() {}

    public RefreshToken(int id, int user_id, String token, Timestamp expires_at, boolean revoked, String replaced_by_token, Timestamp issued_at) {
        this.id = id;
        this.user_id = user_id;
        this.token = token;
        this.expires_at = expires_at;
        this.revoked = revoked;
        this.replaced_by_token = replaced_by_token;
        this.issued_at = issued_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpires_at() {
        return expires_at;
    }

    public void setExpires_at(Timestamp expires_at) {
        this.expires_at = expires_at;
    }

    public boolean isRevoked() {
        return revoked;
    }

    public void setRevoked(boolean revoked) {
        this.revoked = revoked;
    }

    public String getReplaced_by_token() {
        return replaced_by_token;
    }

    public void setReplaced_by_token(String replaced_by_token) {
        this.replaced_by_token = replaced_by_token;
    }

    public Timestamp getIssued_at() {
        return issued_at;
    }

    public void setIssued_at(Timestamp issued_at) {
        this.issued_at = issued_at;
    }
}
