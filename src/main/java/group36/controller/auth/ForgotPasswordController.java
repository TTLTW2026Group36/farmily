package group36.controller.auth;

import group36.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.service.PasswordResetService;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordController", value = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fbUrl = "https://www.facebook.com/v19.0/dialog/oauth"
                + "?client_id=" + group36.util.FarmilyConstants.FACEBOOK_CLIENT_ID
                + "&redirect_uri=" + java.net.URLEncoder.encode(group36.util.FarmilyConstants.FACEBOOK_REDIRECT_URI, "UTF-8");

        String ggUrl = "https://accounts.google.com/o/oauth2/auth"
                + "?scope=email%20profile%20openid"
                + "&redirect_uri=" + java.net.URLEncoder.encode(group36.util.FarmilyConstants.GOOGLE_REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&client_id=" + group36.util.FarmilyConstants.GOOGLE_CLIENT_ID
                + "&approval_prompt=force";

        request.setAttribute("facebookOAuthUrl", fbUrl);
        request.setAttribute("googleOAuthUrl", ggUrl);
        request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
            return;
        }
        try {
            passwordResetService.validateRateLimit(email);
            String otp = passwordResetService.generateOTP(email);
            String title = "[Farmily] Mã xác nhận đặt lại mật khẩu";
            String content = """
                    <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;">
                      <div style="text-align: center; margin-bottom: 20px;">
                        <h2 style="color: #2e7d32; margin: 0;">Nông Sản Farmily</h2>
                      </div>
                      <div style="background-color: #f9f9f9; padding: 20px; border-radius: 6px; border-left: 4px solid #2e7d32;">
                        <h3 style="color: #333; margin-top: 0;">Yêu cầu đặt lại mật khẩu</h3>
                        <p style="color: #555; line-height: 1.5;">Chào bạn,</p>
                        <p style="color: #555; line-height: 1.5;">Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản Farmily của bạn. Dưới đây là mã xác minh OTP của bạn:</p>
                        <div style="text-align: center; margin: 24px 0;">
                          <span style="font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #2e7d32; background: #e8f5e9; padding: 10px 24px; border-radius: 6px; border: 1px dashed #2e7d32; display: inline-block;">%s</span>
                        </div>
                        <p style="color: #777; font-size: 13px; line-height: 1.5;">Mã xác minh này có hiệu lực trong vòng <strong>5 phút</strong>. Vì lý do bảo mật, vui lòng tuyệt đối không chia sẻ mã này với bất kỳ ai.</p>
                      </div>
                      <div style="margin-top: 20px; text-align: center; color: #999; font-size: 12px;">
                        <p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này hoặc liên hệ bộ phận hỗ trợ.</p>
                      </div>
                    </div>
                    """.formatted(otp);

            EmailUtil.sendEmailAsync(email, title, content);

            request.setAttribute("emailSent", email);
            request.setAttribute("message", "Chúng tôi đã gửi mã OTP vào email của bạn.");
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[ForgotPassword] Error: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        }
    }
}
