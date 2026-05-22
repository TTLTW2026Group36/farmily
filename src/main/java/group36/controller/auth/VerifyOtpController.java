package group36.controller.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.service.PasswordResetService;
import java.io.IOException;

@WebServlet(name = "VerifyOtpController", value = "/verify-otp")
public class VerifyOtpController extends HttpServlet {
    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        try {
            // checkOTP vs Db
            passwordResetService.validateOTP(email, otp);
            request.setAttribute("email", email);
            request.setAttribute("token", otp);
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("emailSent", email);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/forgot-password");
    }
}
