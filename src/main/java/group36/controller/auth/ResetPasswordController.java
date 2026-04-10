package group36.controller.auth;

import group36.dao.AuthDao;
import group36.dao.RefreshTokenDao;
import group36.model.RefreshToken;
import group36.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.service.PasswordResetService;

import java.io.IOException;





@WebServlet(name = "ResetPasswordController", value = { "/reset-password", "/dat-lai-mat-khau" })
public class ResetPasswordController extends HttpServlet {
    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String email = (String) session.getAttribute("resetEmail");

        if (otpVerified == null || !otpVerified || email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.setAttribute("email", email);
        request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String otp = (String) session.getAttribute("verifiedOtp");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || otp == null || otpVerified == null || !otpVerified) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        
        if (newPassword == null || newPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }

        try {
            
            passwordResetService.resetPassword(email, otp, newPassword);

            AuthDao authDao = new AuthDao();
            User u = authDao.getUserByUsername(email);
            if(u != null) {
                RefreshTokenDao tokenDao = new RefreshTokenDao();
                tokenDao.revokeAllByUserId(u.getId());
            }

            session.removeAttribute("resetEmail");
            session.removeAttribute("verifiedOtp");
            session.removeAttribute("otpVerified");
            session.removeAttribute("resetOtpGenerated");

            
            session.setAttribute("passwordResetSuccess",
                    "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/dang-nhap");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        }
    }
}
