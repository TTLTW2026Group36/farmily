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
import java.io.PrintWriter;

@WebServlet(name = "RequestEmailVerificationController", urlPatterns = { "/api/user/verify-email/request" })
public class RequestEmailVerificationController extends HttpServlet {
    private EmailVerificationService emailVerificationService;

    @Override
    public void init() throws ServletException {
        emailVerificationService = new EmailVerificationService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            emailVerificationService.sendVerificationEmail(user);
            out.print("{\"success\":true,\"message\":\"Yêu cầu đã được gửi thành công\"}");
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.err.println("Error requesting email verification: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống\"}");
        }
    }
}
