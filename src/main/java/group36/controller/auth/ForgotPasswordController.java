package group36.controller.auth;

import group36.dao.AuthDao;
import group36.dao.RefreshTokenDao;
import group36.model.User;
import group36.util.EmailUtil;
import jakarta.mail.MessagingException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.service.PasswordResetService;
import java.io.IOException;

@WebServlet(name = "ForgotPasswordController", value = { "/forgot-password", "/quen-mat-khau" })
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
        String baseUrl = request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) + request.getContextPath();
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
            return;
        }
        try {
            String resetLink = passwordResetService.createResetLink(email, baseUrl);
            String content = "Chào bạn, vui lòng click vào link sau để đặt lại mật khẩu: " + resetLink;
            EmailUtil.sendEmail(email, "Đặt lại mật khẩu Farmily", content);
            try {
                AuthDao authDao = new AuthDao();
                User u = authDao.getUserByUsername(email.trim());
                if(u != null){
                    RefreshTokenDao tokenDao =  new RefreshTokenDao();
                    tokenDao.revokeAllByUserId(u.getId());
                }
            } catch (Exception e) {
                System.err.println("Session revocation failed: " + e.getMessage());
            }
            request.setAttribute("message", "Vui lòng kiểm tra email để đặt lại mật khẩu.");
            request.getRequestDispatcher("/Notice.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi email. Vui lòng kiểm tra cấu hình SMTP (Email/Mật khẩu ứng dụng).");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        }
    }
}
