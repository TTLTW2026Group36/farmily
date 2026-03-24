package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;

import java.io.IOException;





@WebServlet(name = "AdminLogoutController", value = "/admin/logout")
public class AdminLogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            
            User adminUser = (User) session.getAttribute("adminUser");
            if (adminUser != null) {
                System.out.println("[ADMIN LOGOUT] User: " + adminUser.getEmail() +
                        " | Role: " + adminUser.getRole() +
                        " | Time: " + new java.util.Date());
            }

            
            session.invalidate();
        }

        
        response.sendRedirect(request.getContextPath() + "/admin/login?success=logout");
    }
}
