package group36.service;

import group36.dao.PasswordResetTokenDAO;
import group36.dao.UserDAO;
import group36.model.PasswordResetToken;
import group36.model.User;
import group36.util.PasswordUtil;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.UUID;

public class PasswordResetService {
    private final PasswordResetTokenDAO tokenDAO;
    private final UserDAO userDAO;
    private static final SecureRandom random = new SecureRandom();

    public PasswordResetService() {
        this.tokenDAO = new PasswordResetTokenDAO();
        this.userDAO = new UserDAO();
    }

    public String resetPassword(String tokenStr, String newPassword) {
        PasswordResetToken tokenObj = validateToken(tokenStr);
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có ít nhất 8 ký tự");
        }
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(tokenObj.getUserId(), hashedPassword);
        tokenDAO.markAsUsed(tokenObj.getId());

        System.out.println("Password reset successful for user: " + tokenObj.getEmail());
        return tokenObj.getEmail();
    }

    public void cleanupExpiredTokens() {
        int deleted = tokenDAO.deleteExpired();
        if (deleted > 0) {
            System.out.println("Cleaned up " + deleted + " expired password reset tokens");
        }
    }

    public String createResetLink(String email, String baseUrl) {
        User user = userDAO.findByEmail(email).orElseThrow(() -> new IllegalArgumentException("Email không tồn tại"));

        tokenDAO.invalidateAllByEmail(email);

        String token = UUID.randomUUID().toString();
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (30 * 60 * 1000)); // 30p
        PasswordResetToken resetToken = new PasswordResetToken(user.getId(), email, token, expiresAt);
        tokenDAO.insert(resetToken);
        return baseUrl + "/reset-password?token=" + token;
    }
    public PasswordResetToken validateToken(String token) {
        PasswordResetToken t = tokenDAO.findByToken(token)
                .orElseThrow(() -> new IllegalArgumentException("Liên kết không hợp lệ"));

        if (!t.isValid()) {
            throw new IllegalArgumentException("Liên kết đã hết hạn hoặc đã được sử dụng");
        }
        return t;
    }
}
