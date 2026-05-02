package group36.controller.auth;

import group36.dao.AuthDao;
import group36.dao.RefreshTokenDao;
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
        String token = request.getParameter("token");
        try {
            passwordResetService.validateToken(token);
            request.setAttribute("token", token);
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("forgot-password?error=Link_Invalid");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (newPassword == null || newPassword.isEmpty()) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
            return;
        }
        try {
            String email = passwordResetService.resetPassword(token, newPassword);
            try {
                AuthDao authDao = new AuthDao();
                User u = authDao.getUserByUsername(email);
                if(u != null) {
                    RefreshTokenDao tokenDao = new RefreshTokenDao();
                    tokenDao.revokeAllByUserId(u.getId());
                }
            } catch (Exception e) {
                System.err.println("Session revocation failed: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/dang-nhap");

        } catch (IllegalArgumentException e) {
            request.setAttribute("token", token);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("token", token);
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        }
    }
}
