package group36.controller.auth;

import group36.util.EmailUtil;
import jakarta.mail.MessagingException;
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
            String otp = passwordResetService.generateOTP(email); // tao OTP 6 số
            String title = "Mã xác nhận bảo mật Farmily";
            String content = "Chào bạn, mã OTP để đặt lại mật khẩu của bạn là: " + otp 
                           + "\n(Mã này có tác dụng trong 5 phút, đừng chia sẻ cho ai nhé!)";
            
            EmailUtil.sendEmail(email, title, content);
            request.setAttribute("emailSent", email);
            request.setAttribute("message", "Chúng tôi đã gửi mã OTP vào email của bạn.");
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi email. Vui lòng kiểm tra cấu hình SMTP (Email/Mật khẩu ứng dụng).");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        }
    }
}
