package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import group36.service.AuthService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;






@WebServlet(name = "AdminLoginController", value = "/admin/login")
public class AdminLoginController extends HttpServlet {

    private static final List<String> ALLOWED_ROLES = Arrays.asList("admin", "manager");
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String redirectUrl = request.getParameter("redirect");

        
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        
        User user = authService.checkLogin(username.trim(), password);

        
        
        if (user == null || !isAuthorized(user)) {
            
            if (user != null && !isAuthorized(user)) {
                System.out.println("[ADMIN LOGIN DENIED] User '" + username
                        + "' attempted admin access without permission. Role: " + user.getRole());
            }

            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        
        
        HttpSession session = request
                .getSession(true);
        session.setAttribute("adminUser", user);
        session.setMaxInactiveInterval(3600); 
                                              
                                              

        
        System.out.println("[ADMIN LOGIN] User: " + user.getEmail() + " | Role: " + user.getRole() + " | Time: "
                + new java.util.Date());

        
        String targetUrl = getRedirectUrl(request, redirectUrl);
        response.sendRedirect(targetUrl);
    }

    


    private boolean isAuthorized(User user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        return ALLOWED_ROLES.contains(user.getRole().toLowerCase());
    }

    


    private String getRedirectUrl(HttpServletRequest request, String redirectUrl) {
        String contextPath = request.getContextPath();

        
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            try {
                
                if (redirectUrl.startsWith(contextPath + "/admin/") &&
                        !redirectUrl.contains(contextPath + "/admin/login")) {
                    return redirectUrl;
                }
            } catch (Exception e) {
                
            }
        }

        
        return contextPath + "/admin/dashboard";
    }
}
