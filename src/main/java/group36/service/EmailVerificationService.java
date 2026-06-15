package group36.service;

import group36.dao.AuthDao;
import group36.dao.EmailVerificationTokenDAO;
import group36.model.EmailVerificationToken;
import group36.model.User;
import group36.util.EmailUtil;
import group36.util.FarmilyConstants;
import java.sql.Timestamp;
import java.util.UUID;

public class EmailVerificationService {
    private final EmailVerificationTokenDAO tokenDao = new EmailVerificationTokenDAO();
    private final AuthDao authDao = new AuthDao();

    public void sendVerificationEmail(User user) {
        EmailVerificationToken existingToken = tokenDao.findByUserId(user.getId());
        if (existingToken != null) {
            long remainingMs = existingToken.getExpireAt().getTime() - System.currentTimeMillis();
            long totalDurationMs = 24L * 60 * 60 * 1000;
            long ageMs = totalDurationMs - remainingMs;
            if (ageMs < 60L * 1000) {
                long secondsLeft = 60 - (ageMs / 1000);
                throw new IllegalArgumentException("Vui lòng đợi " + secondsLeft + " giây trước khi yêu cầu lại.");
            }
        }
        tokenDao.deleteByUserId(user.getId());
        String token = UUID.randomUUID().toString();
        Timestamp expireAt = new Timestamp(System.currentTimeMillis() + 24L * 60 * 60 * 1000);
        tokenDao.insertToken(user.getId(), token, expireAt);

        String verifyLink = FarmilyConstants.BASE_URL + "/verify-email?token=" + token;
        String content = """
                <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;">
                  <div style="text-align: center; margin-bottom: 20px;">
                    <h2 style="color: #2e7d32; margin: 0;">Nông Sản Farmily</h2>
                  </div>
                  <div style="background-color: #f9f9f9; padding: 20px; border-radius: 6px; border-left: 4px solid #2e7d32;">
                    <h3 style="color: #333; margin-top: 0;">Xác minh địa chỉ Email</h3>
                    <p style="color: #555; line-height: 1.5;">Chào bạn,</p>
                    <p style="color: #555; line-height: 1.5;">Cảm ơn bạn đã lựa chọn mua sắm tại Farmily. Vui lòng nhấp vào nút dưới đây để xác thực tài khoản email của bạn:</p>
                    <div style="text-align: center; margin: 24px 0;">
                      <a href="%s" style="background-color: #2e7d32; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: 500; display: inline-block; box-shadow: 0 2px 8px rgba(46,125,50,0.3);">Xác thực ngay</a>
                    </div>
                    <p style="color: #777; font-size: 13px; line-height: 1.5;">Liên kết này có hiệu lực trong vòng <strong>24 giờ</strong>.</p>
                  </div>
                  <div style="margin-top: 20px; text-align: center; color: #999; font-size: 12px;">
                    <p>Nếu bạn không thực hiện đăng ký hoặc liên kết tài khoản này, vui lòng bỏ qua email.</p>
                  </div>
                </div>
                """.formatted(verifyLink);

        EmailUtil.sendEmailAsync(user.getEmail(), "Xác thực email tài khoản Farmily", content);
    }

    public boolean verifyToken(String token) {
        EmailVerificationToken evToken = tokenDao.findByToken(token);
        if (evToken == null) {
            return false;
        }
        if (evToken.getExpireAt().before(new Timestamp(System.currentTimeMillis()))) {
            tokenDao.deleteByToken(token);
            return false;
        }
        authDao.updateEmailVerificationStatus(evToken.getUserId(), true);
        tokenDao.deleteByToken(token);
        return true;
    }
}
