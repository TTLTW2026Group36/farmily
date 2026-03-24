package group36.controller.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import group36.service.AuthService;
import java.io.IOException;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/DangKy.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/DangKy.jsp").forward(request, response);
            return;
        }

        AuthService authService = new AuthService();
        if (authService.isEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/DangKy.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name);
        user.setPhone(phone);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole("user"); 

        boolean success = authService.register(user);
        if (success) {
            
            User newUser = authService.checkLogin(email, password);
            HttpSession session = request.getSession();
            session.setAttribute("auth", newUser);
            session.setAttribute("registerSuccess", "Chào mừng bạn gia nhập Farmily!");
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Đăng ký không thành công. Vui lòng thử lại!");
            request.getRequestDispatcher("/DangKy.jsp").forward(request, response);
        }
    }
}
