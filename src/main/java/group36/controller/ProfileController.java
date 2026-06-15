package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.User;

import group36.dao.EmailVerificationTokenDAO;
import group36.model.EmailVerificationToken;
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

        EmailVerificationTokenDAO tokenDao = new EmailVerificationTokenDAO();
        EmailVerificationToken existingToken = tokenDao.findByUserId(user.getId());
        long remainingSeconds = 0;
        if (existingToken != null) {
            long remainingMs = existingToken.getExpireAt().getTime() - System.currentTimeMillis();
            long totalDurationMs = 24L * 60 * 60 * 1000;
            long ageMs = totalDurationMs - remainingMs;
            if (ageMs < 60L * 1000) {
                remainingSeconds = 60 - (ageMs / 1000);
            }
        }
        request.setAttribute("emailVerificationCooldown", remainingSeconds);

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "info";
        }

        request.setAttribute("activeTab", tab);

        request.getRequestDispatcher("/HoSo.jsp").forward(request, response);
    }
}
