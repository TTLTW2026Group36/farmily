package group36.dao;

import group36.model.EmailVerificationToken;
import java.sql.Timestamp;

public class EmailVerificationTokenDAO extends BaseDao {
    public void deleteByUserId(int userId) {
        get().useHandle(h -> h.createUpdate("DELETE FROM email_verification_tokens WHERE user_id = :userId")
                .bind("userId", userId)
                .execute());
    }

    public void insertToken(int userId, String token, Timestamp expireAt) {
        get().useHandle(h -> h.createUpdate(
                "INSERT INTO email_verification_tokens (user_id, token, expire_at) VALUES (:userId, :token, :expireAt)")
                .bind("userId", userId)
                .bind("token", token)
                .bind("expireAt", expireAt)
                .execute());
    }

    public EmailVerificationToken findByToken(String token) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM email_verification_tokens WHERE token = :token")
                .bind("token", token)
                .mapToBean(EmailVerificationToken.class)
                .stream().findFirst().orElse(null));
    }

    public EmailVerificationToken findByUserId(int userId) {
        return get().withHandle(h -> h.createQuery("SELECT * FROM email_verification_tokens WHERE user_id = :userId")
                .bind("userId", userId)
                .mapToBean(EmailVerificationToken.class)
                .stream().findFirst().orElse(null));
    }

    public void deleteByToken(String token) {
        get().useHandle(h -> h.createUpdate("DELETE FROM email_verification_tokens WHERE token = :token")
                .bind("token", token)
                .execute());
    }
}
