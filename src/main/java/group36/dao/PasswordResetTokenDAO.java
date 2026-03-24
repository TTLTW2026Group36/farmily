package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.PasswordResetToken;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;





public class PasswordResetTokenDAO extends BaseDao {

    


    private static class TokenMapper implements RowMapper<PasswordResetToken> {
        @Override
        public PasswordResetToken map(ResultSet rs, StatementContext ctx) throws SQLException {
            PasswordResetToken token = new PasswordResetToken();
            token.setId(rs.getInt("id"));
            token.setUserId(rs.getInt("user_id"));
            token.setEmail(rs.getString("email"));
            token.setOtpCode(rs.getString("otp_code"));
            token.setCreatedAt(rs.getTimestamp("created_at"));
            token.setExpiresAt(rs.getTimestamp("expires_at"));
            token.setUsed(rs.getBoolean("is_used"));
            return token;
        }
    }

    


    public void createTableIfNotExists() {
        String sql = """
                CREATE TABLE IF NOT EXISTS password_reset_tokens (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    user_id INT NOT NULL,
                    email VARCHAR(255) NOT NULL,
                    otp_code VARCHAR(6) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    expires_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    is_used BOOLEAN DEFAULT FALSE,
                    INDEX idx_email (email),
                    INDEX idx_otp_code (otp_code),
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
                )
                """;
        get().withHandle(handle -> handle.createUpdate(sql).execute());
    }

    





    public int insert(PasswordResetToken token) {
        String sql = """
                INSERT INTO password_reset_tokens (user_id, email, otp_code, expires_at, is_used)
                VALUES (:userId, :email, :otpCode, :expiresAt, :isUsed)
                """;
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", token.getUserId())
                .bind("email", token.getEmail())
                .bind("otpCode", token.getOtpCode())
                .bind("expiresAt", token.getExpiresAt())
                .bind("isUsed", token.isUsed())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    






    public Optional<PasswordResetToken> findByEmailAndOtp(String email, String otpCode) {
        String sql = """
                SELECT * FROM password_reset_tokens
                WHERE email = :email AND otp_code = :otpCode AND is_used = FALSE
                ORDER BY created_at DESC LIMIT 1
                """;
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .bind("otpCode", otpCode)
                .map(new TokenMapper())
                .findOne());
    }

    





    public Optional<PasswordResetToken> findLatestByEmail(String email) {
        String sql = """
                SELECT * FROM password_reset_tokens
                WHERE email = :email AND is_used = FALSE
                ORDER BY created_at DESC LIMIT 1
                """;
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .map(new TokenMapper())
                .findOne());
    }

    





    public int markAsUsed(int id) {
        String sql = "UPDATE password_reset_tokens SET is_used = TRUE WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    




    public int deleteExpired() {
        String sql = "DELETE FROM password_reset_tokens WHERE expires_at < NOW()";
        return get().withHandle(handle -> handle.createUpdate(sql).execute());
    }

    





    public int invalidateAllByEmail(String email) {
        String sql = "UPDATE password_reset_tokens SET is_used = TRUE WHERE email = :email AND is_used = FALSE";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("email", email)
                .execute());
    }
}
