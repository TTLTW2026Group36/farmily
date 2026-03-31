package group36.service;

import group36.dao.PasswordResetTokenDAO;
import group36.dao.UserDAO;
import group36.model.PasswordResetToken;
import group36.model.User;
import group36.util.PasswordUtil;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.Optional;

public class PasswordResetService {
    private final PasswordResetTokenDAO tokenDAO;
    private final UserDAO userDAO;
    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRY_MINUTES = 15;
    private static final SecureRandom random = new SecureRandom();

    public PasswordResetService() {
        this.tokenDAO = new PasswordResetTokenDAO();
        this.userDAO = new UserDAO();

        initializeTable();
    }

    private void initializeTable() {
        try {
            tokenDAO.createTableIfNotExists();
        } catch (Exception e) {
            System.err.println("Warning: Could not create password_reset_tokens table: " + e.getMessage());
        }
    }

    public String generateOTP(String email) {

        Optional<User> userOpt = userDAO.findByEmail(email.trim().toLowerCase());
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("Email không tồn tại trong hệ thống");
        }

        User user = userOpt.get();

        tokenDAO.invalidateAllByEmail(email);

        String otpCode = generateRandomOTP();

        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000));

        PasswordResetToken token = new PasswordResetToken(user.getId(), email.trim().toLowerCase(), otpCode, expiresAt);
        tokenDAO.insert(token);

        System.out.println("==============================================");
        System.out.println("📧 [MOCK EMAIL] Password Reset OTP for: " + email);
        System.out.println("📧 OTP Code: " + otpCode);
        System.out.println("📧 Expires at: " + expiresAt);
        System.out.println("==============================================");

        return otpCode;
    }

    public PasswordResetToken verifyOTP(String email, String otpCode) {
        Optional<PasswordResetToken> tokenOpt = tokenDAO.findByEmailAndOtp(
                email.trim().toLowerCase(),
                otpCode.trim());

        if (tokenOpt.isEmpty()) {
            throw new IllegalArgumentException("Mã OTP không đúng");
        }

        PasswordResetToken token = tokenOpt.get();

        if (token.isExpired()) {
            throw new IllegalArgumentException("Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
        }

        if (token.isUsed()) {
            throw new IllegalArgumentException("Mã OTP đã được sử dụng. Vui lòng yêu cầu mã mới.");
        }

        return token;
    }

    public void resetPassword(String email, String otpCode, String newPassword) {

        PasswordResetToken token = verifyOTP(email, otpCode);

        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu mới phải có ít nhất 6 ký tự");
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(token.getUserId(), hashedPassword);

        tokenDAO.markAsUsed(token.getId());

        System.out.println("✅ Password reset successful for user: " + email);
    }

    public boolean hasValidOTP(String email) {
        Optional<PasswordResetToken> tokenOpt = tokenDAO.findLatestByEmail(email.trim().toLowerCase());
        return tokenOpt.isPresent() && tokenOpt.get().isValid();
    }

    public long getRemainingTimeSeconds(String email) {
        Optional<PasswordResetToken> tokenOpt = tokenDAO.findLatestByEmail(email.trim().toLowerCase());
        if (tokenOpt.isEmpty() || !tokenOpt.get().isValid()) {
            return 0;
        }
        long remaining = tokenOpt.get().getExpiresAt().getTime() - System.currentTimeMillis();
        return Math.max(0, remaining / 1000);
    }

    private String generateRandomOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }

    public void cleanupExpiredTokens() {
        int deleted = tokenDAO.deleteExpired();
        if (deleted > 0) {
            System.out.println("Cleaned up " + deleted + " expired password reset tokens");
        }
    }
}
