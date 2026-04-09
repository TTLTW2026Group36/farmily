package group36.dao;

import group36.model.RefreshToken;

import java.sql.Timestamp;

public class RefreshTokenDao extends BaseDao{
    public void insertToken(int userId, String token, Timestamp expireAt) {
        get().useHandle(h -> h.createUpdate("INSERT INTO refresh_tokens (user_id,token,expire_at, revoked, issue_at)" +
                "VALUES (:userId, :token, :expireAt, false, NOW())")
                .bind("userId", userId).bind("token", token).bind("expireAt", expireAt).execute());
    }
    public RefreshToken findByToken(String token) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM refresh_tokens WHERE token = :token")
                .bind("token", token).mapToBean(RefreshToken.class).stream().findFirst().orElse(null));
    }
    //cap token moi
    public void rotakeToken(String oldToken, String newToken, int userId, Timestamp expireAt) {
        get().useHandle(h -> {
            h.createUpdate("UPDATE refresh_tokens SET revoked = true, replaced_by_token = :newToken WHERE token = :oldToken")
                    .bind("newToken", newToken).bind("oldToken", oldToken).execute();
            h.createUpdate("INSERT INTO refresh_tokens (user_id, token, expire_at, revoked, issue_at) "+
                    "VALUES (:userId, :newToken, :expireAt, :false, NOW())")
                    .bind("userId", userId).bind("newToken", newToken).bind("expireAt", expireAt).execute();
        });
    }
    public void revokeAllByUserId(int userId) {
        get().useHandle(h -> h.createUpdate("UPDATE refresh_tokens SET revoked = true WHERE user_id = :userId")
                .bind("userId", userId).execute());
    }
    public void revokeToken(String token) {
        get().useHandle(h -> h.createUpdate("UPDATE refresh_tokens SET revoked = true WHERE token = :token")
                .bind("token", token).execute());
    }
}
















