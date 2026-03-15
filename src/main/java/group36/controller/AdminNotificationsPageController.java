package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.AdminNotification;
import group36.service.AdminNotificationService;

import java.io.IOException;
import java.util.List;




@WebServlet(name = "AdminNotificationsPageController", urlPatterns = { "/admin/notifications" })
public class AdminNotificationsPageController extends HttpServlet {

    private AdminNotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new AdminNotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        List<AdminNotification> notifications = notificationService.getLatestNotifications(50);
        int unreadCount = notificationService.getUnreadCount();

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/admin/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("markAllRead".equals(action)) {
            notificationService.markAllAsRead();
        }

        response.sendRedirect(request.getContextPath() + "/admin/notifications");
    }
}
