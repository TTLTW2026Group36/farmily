package group36.controller.auth;

import group36.dao.AuthDao;
import group36.dao.RefreshTokenDao;
import group36.model.User;
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

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
            return;
        }

        try {
            
            String otp = passwordResetService.generateOTP(email.trim());

            AuthDao authDao = new AuthDao();
            User u = authDao.getUserByUsername(email.trim());
            if(u != null){
                RefreshTokenDao tokenDao =  new RefreshTokenDao();
                tokenDao.revokeAllByUserId(u.getId());
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email.trim().toLowerCase());
            session.setAttribute("resetOtpGenerated", true);

            
            
            request.setAttribute("otpDemo", otp);
            request.setAttribute("email", email.trim());

            
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/QuenMatKhau.jsp").forward(request, response);
        }
    }
}
