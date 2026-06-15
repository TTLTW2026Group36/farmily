package group36.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import group36.model.UserNotification;
import group36.service.UserNotificationService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "UserNotificationApiController",
            urlPatterns = { "/api/user-notifications", "/api/user-notifications/*" })
public class UserNotificationApiController extends HttpServlet {

    private UserNotificationService notificationService;

    @Override
    public void init() throws ServletException {
        notificationService = new UserNotificationService();
    }

    private User getLoggedInUser(HttpServletRequest request) {
        Object auth = request.getSession(false) != null
                ? request.getSession(false).getAttribute("auth") : null;
        return (auth instanceof User) ? (User) auth : null;
    }

    private boolean requireAuth(HttpServletResponse response, PrintWriter out) throws IOException {
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        User user = getLoggedInUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if ("/count".equals(pathInfo)) {
                getUnreadCount(user.getId(), out);
            } else if (pathInfo == null || "/".equals(pathInfo) || "/latest".equals(pathInfo)) {
                getLatest(request, user.getId(), out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Not found\"}");
            }
        } catch (Exception e) {
            System.err.println("[UserNotificationApiController] GET error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        User user = getLoggedInUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Unauthorized\"}");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if ("/read".equals(pathInfo)) {
                markAsRead(request, user.getId(), out);
            } else if ("/read-all".equals(pathInfo)) {
                markAllAsRead(user.getId(), out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Not found\"}");
            }
        } catch (Exception e) {
            System.err.println("[UserNotificationApiController] POST error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void getUnreadCount(int userId, PrintWriter out) {
        int count = notificationService.getUnreadCount(userId);
        out.print("{\"unreadCount\": " + count + "}");
    }

    private void getLatest(HttpServletRequest request, int userId, PrintWriter out) {
        int limit = 7;
        int offset = 0;
        try {
            String lp = request.getParameter("limit");
            if (lp != null) limit = Math.min(Math.max(Integer.parseInt(lp), 1), 50);
            String op = request.getParameter("offset");
            if (op != null) offset = Math.max(Integer.parseInt(op), 0);
        } catch (NumberFormatException ignored) {}

        List<UserNotification> list = (offset > 0)
                ? notificationService.getPagedForUser(userId, limit, offset)
                : notificationService.getLatestForUser(userId, limit);

        int unread = notificationService.getUnreadCount(userId);
        String contextPath = request.getContextPath();

        StringBuilder json = new StringBuilder();
        json.append("{\"unreadCount\":").append(unread).append(",\"notifications\":[");
        for (int i = 0; i < list.size(); i++) {
            UserNotification n = list.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\":").append(n.getId()).append(",");
            json.append("\"type\":\"").append(escapeJson(n.getType())).append("\",");
            json.append("\"title\":\"").append(escapeJson(n.getTitle())).append("\",");
            json.append("\"message\":\"").append(escapeJson(n.getMessage())).append("\",");
            String link = n.getLink();
            if (link != null && link.startsWith("/")) link = contextPath + link;
            json.append("\"link\":").append(link != null ? "\"" + escapeJson(link) + "\"" : "null").append(",");
            json.append("\"icon\":\"").append(n.getIcon()).append("\",");
            json.append("\"iconClass\":\"").append(n.getIconClass()).append("\",");
            json.append("\"isRead\":").append(n.isRead()).append(",");
            json.append("\"timeAgo\":\"").append(escapeJson(n.getTimeAgo())).append("\"");
            json.append("}");
        }
        json.append("]}");
        out.print(json.toString());
    }

    private void markAsRead(HttpServletRequest request, int userId, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            out.print("{\"success\": false, \"error\": \"Missing id parameter\"}");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            boolean success = notificationService.markAsRead(id, userId);
            int newCount = notificationService.getUnreadCount(userId);
            out.print("{\"success\": " + success + ", \"unreadCount\": " + newCount + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid id\"}");
        }
    }

    private void markAllAsRead(int userId, PrintWriter out) {
        int updated = notificationService.markAllAsRead(userId);
        out.print("{\"success\": true, \"count\": " + updated + ", \"unreadCount\": 0}");
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
