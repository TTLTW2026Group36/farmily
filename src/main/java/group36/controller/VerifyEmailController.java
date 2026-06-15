package group36.controller;

import group36.model.User;
import group36.service.EmailVerificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyEmailController", urlPatterns = { "/verify-email" })
public class VerifyEmailController extends HttpServlet {
    private EmailVerificationService emailVerificationService;

    @Override
    public void init() throws ServletException {
        emailVerificationService = new EmailVerificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so?verification_error=missing_token");
            return;
        }

        try {
            boolean success = emailVerificationService.verifyToken(token);
            if (success) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    User user = (User) session.getAttribute("auth");
                    if (user != null) {
                        user.setEmailVerified(true);
                        session.setAttribute("auth", user);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/ho-so?verification_success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/ho-so?verification_error=invalid_token");
            }
        } catch (Exception e) {
            System.err.println("Error verifying email token: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ho-so?verification_error=server_error");
        }
    }
}
