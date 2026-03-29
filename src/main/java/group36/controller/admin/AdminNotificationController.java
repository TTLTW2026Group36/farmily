package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.AdminNotification;
import group36.service.AdminNotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;





@WebServlet(name = "AdminNotificationController", urlPatterns = { "/admin/api/notifications",
        "/admin/api/notifications/*" })
public class AdminNotificationController extends HttpServlet {

    private AdminNotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new AdminNotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                
                getNotifications(request, out);
            } else if (pathInfo.equals("/count")) {
                
                getUnreadCount(out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.equals("/read")) {
                
                markAsRead(request, out);
            } else if (pathInfo != null && pathInfo.equals("/read-all")) {
                
                markAllAsRead(out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    


    private void getNotifications(HttpServletRequest request, PrintWriter out) {
        int limit = 5;
        String limitParam = request.getParameter("limit");
        if (limitParam != null) {
            try {
                limit = Integer.parseInt(limitParam);
                if (limit < 1)
                    limit = 5;
                if (limit > 50)
                    limit = 50;
            } catch (NumberFormatException e) {
                
            }
        }

        List<AdminNotification> notifications = notificationService.getLatestNotifications(limit);
        int unreadCount = notificationService.getUnreadCount();

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"unreadCount\": ").append(unreadCount).append(",");
        json.append("\"notifications\": [");

        for (int i = 0; i < notifications.size(); i++) {
            AdminNotification n = notifications.get(i);
            if (i > 0)
                json.append(",");
            json.append("{");
            json.append("\"id\": ").append(n.getId()).append(",");
            json.append("\"type\": \"").append(escapeJson(n.getType())).append("\",");
            json.append("\"title\": \"").append(escapeJson(n.getTitle())).append("\",");
            json.append("\"message\": \"").append(escapeJson(n.getMessage())).append("\",");
            json.append("\"icon\": \"").append(n.getIcon()).append("\",");
            json.append("\"iconClass\": \"").append(n.getIconClass()).append("\",");
            json.append("\"referenceId\": ").append(n.getReferenceId() != null ? n.getReferenceId() : "null")
                    .append(",");
            json.append("\"referenceType\": ")
                    .append(n.getReferenceType() != null ? "\"" + escapeJson(n.getReferenceType()) + "\"" : "null")
                    .append(",");
            json.append("\"isRead\": ").append(n.isRead()).append(",");
            json.append("\"timeAgo\": \"").append(escapeJson(n.getTimeAgo())).append("\"");
            json.append("}");
        }

        json.append("]}");
        out.print(json.toString());
    }

    


    private void getUnreadCount(PrintWriter out) {
        int count = notificationService.getUnreadCount();
        out.print("{\"unreadCount\": " + count + "}");
    }

    


    private void markAsRead(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            out.print("{\"success\": false, \"error\": \"Missing id parameter\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean success = notificationService.markAsRead(id);
            int newCount = notificationService.getUnreadCount();
            out.print("{\"success\": " + success + ", \"unreadCount\": " + newCount + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid id\"}");
        }
    }

    


    private void markAllAsRead(PrintWriter out) {
        int updated = notificationService.markAllAsRead();
        out.print("{\"success\": true, \"updated\": " + updated + ", \"unreadCount\": 0}");
    }

    


    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
