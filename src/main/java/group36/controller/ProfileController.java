package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.User;

import java.io.IOException;





@WebServlet(name = "ProfileController", urlPatterns = { "/ho-so" })
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "info";
        }

        
        request.setAttribute("activeTab", tab);

        
        request.getRequestDispatcher("/HoSo.jsp").forward(request, response);
    }
}
