package group36.service;

import group36.dao.PasswordResetTokenDAO;
import group36.dao.UserDAO;
import group36.model.PasswordResetToken;
import group36.model.User;
import group36.util.PasswordUtil;
import java.security.SecureRandom;
import java.sql.Timestamp;

public class PasswordResetService {
    private final PasswordResetTokenDAO tokenDAO;
    private final UserDAO userDAO;
    private static final SecureRandom random = new SecureRandom();

    public PasswordResetService() {
        this.tokenDAO = new PasswordResetTokenDAO();
        this.userDAO = new UserDAO();
    }

    public String generateOTP(String email) {
        User user = userDAO.findByEmail(email).orElseThrow(() -> new IllegalArgumentException("Email không tồn tại"));
        tokenDAO.invalidateAllByEmail(email);

        int otpValue = 100000 + random.nextInt(900000);
        String otp = String.valueOf(otpValue);

        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (5 * 60 * 1000)); 
        PasswordResetToken resetToken = new PasswordResetToken(user.getId(), email, otp, expiresAt);
        tokenDAO.insert(resetToken);
        return otp;
    }

    public String resetPassword(String otp, String newPassword) {
        PasswordResetToken tokenObj = tokenDAO.findByToken(otp)
                .orElseThrow(() -> new IllegalArgumentException("Mã xác nhận không hợp lệ"));
        if (!tokenObj.isValid()) {
            throw new IllegalArgumentException("Mã xác nhận đã hết hạn hoặc đã dùng rồi");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có ít nhất 8 ký tự");
        }
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(tokenObj.getUserId(), hashedPassword);
        tokenDAO.markAsUsed(tokenObj.getId());

        return tokenObj.getEmail();
    }

    public void validateOTP(String email, String otp) {
        PasswordResetToken t = tokenDAO.findLatestByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy yêu cầu đổi mật khẩu"));

        if (!t.getToken().equals(otp)) {
            throw new IllegalArgumentException("Mã OTP bạn nhập không đúng");
        }

        if (!t.isValid()) {
            throw new IllegalArgumentException("Mã OTP đã hết hạn");
        }
    }

    public void validateRateLimit(String email) {
        tokenDAO.findLatestByEmail(email).ifPresent(token -> {
            long diff = System.currentTimeMillis() - token.getCreatedAt().getTime();
            if (diff < 60 * 1000) { 
                long wait = 60 - (diff / 1000);
                throw new IllegalArgumentException("Vui lòng đợi " + wait + " giây nữa mới được gửi lại mã");
            }
        });
    }
}
