package group36.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import group36.model.ChatConversation;
import group36.model.ChatMessage;
import group36.model.User;
import group36.service.AdminNotificationService;
import group36.service.ChatService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "AdminChatController", urlPatterns = {"/admin/chat", "/admin/chat/*"})
@MultipartConfig
public class AdminChatController extends HttpServlet {

    private static final int PAGE_SIZE = 20;

    private ChatService chatService;
    private AdminNotificationService notificationService;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        chatService = new ChatService();
        notificationService = new AdminNotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String path = request.getPathInfo();
        try {
            if (path == null || "/".equals(path)) {
                showChatPage(request, response);
            } else if ("/messages".equals(path)) {
                handleGetMessages(request, response);
            } else if ("/unread-count".equals(path)) {
                handleUnreadCount(response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("[AdminChatController] GET error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String path = request.getPathInfo();
        response.setContentType("application/json; charset=UTF-8");
        try {
            if ("/reply".equals(path)) {
                handleReply(request, response);
            } else if ("/close".equals(path)) {
                handleClose(request, response);
            } else if ("/reopen".equals(path)) {
                handleReopen(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("[AdminChatController] POST error: " + e.getMessage());
            writeJson(response, false, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void showChatPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.isEmpty()) statusFilter = null;
        int page = parseIntOrDefault(request.getParameter("page"), 1);

        List<ChatConversation> conversations = chatService.getAllConversations(statusFilter, page, PAGE_SIZE);
        int total = chatService.countAllConversations(statusFilter);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        int unreadTotal = chatService.getUnreadCountForAdmin();

        request.setAttribute("conversations",  conversations);
        request.setAttribute("currentPage",    page);
        request.setAttribute("totalPages",     totalPages);
        request.setAttribute("total",          total);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "");
        request.setAttribute("unreadTotal",    unreadTotal);
        request.setAttribute("openCount",      chatService.countAllConversations(ChatConversation.STATUS_OPEN));
        request.setAttribute("closedCount",    chatService.countAllConversations(ChatConversation.STATUS_CLOSED));

        request.getRequestDispatcher("/admin/chat.jsp").forward(request, response);
    }

    private void handleGetMessages(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        int conversationId = parseIntOrDefault(request.getParameter("conversationId"), 0);

        if (conversationId <= 0) {
            int refundId = parseIntOrDefault(request.getParameter("refundId"), 0);
            if (refundId > 0) {
                Optional<ChatConversation> byRefund = chatService.getConversationByRefundId(refundId);
                if (byRefund.isPresent()) {
                    conversationId = byRefund.get().getId();
                } else {
                    JsonObject empty = new JsonObject();
                    empty.add("messages", new JsonArray());
                    empty.addProperty("total", 0);
                    empty.addProperty("status", "open");
                    empty.addProperty("subject", "Hỗ trợ hoàn tiền #" + refundId);
                    writeRaw(response, gson.toJson(empty));
                    return;
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                writeRaw(response, "{\"error\":\"conversationId required\"}");
                return;
            }
        }

        chatService.markMessagesAsRead(conversationId, ChatMessage.SENDER_ADMIN);

        int limit  = parseIntOrDefault(request.getParameter("limit"), 100);
        int offset = parseIntOrDefault(request.getParameter("offset"), 0);
        List<ChatMessage> messages = chatService.getMessages(conversationId, limit, offset);

        Optional<ChatConversation> convOpt = chatService.getConversationById(conversationId);

        JsonObject result = new JsonObject();
        JsonArray arr = new JsonArray();
        for (ChatMessage msg : messages) arr.add(buildMessageJson(msg));
        result.add("messages", arr);
        result.addProperty("total", chatService.countMessages(conversationId));
        result.addProperty("conversationId", conversationId);
        if (convOpt.isPresent()) {
            ChatConversation conv = convOpt.get();
            result.addProperty("status",     conv.getStatus());
            result.addProperty("statusText", conv.getStatusText());
            result.addProperty("subject",    conv.getDisplaySubject());
            if (conv.getUser() != null) {
                result.addProperty("customerName",  conv.getUser().getName());
                result.addProperty("customerEmail", conv.getUser().getEmail());
                result.addProperty("customerPhone", conv.getUser().getPhone());
            }
            if (conv.getRefundRequest() != null) {
                result.addProperty("refundRequestId", conv.getRefundRequest().getId());
                result.addProperty("orderId",         conv.getRefundRequest().getOrderId());
                result.addProperty("refundAmount",    conv.getRefundRequest().getFormattedRefundAmount());
                result.addProperty("refundReason",    conv.getRefundRequest().getReason());
                result.addProperty("refundStatus",    conv.getRefundRequest().getStatus());
                result.addProperty("refundStatusText",conv.getRefundRequest().getStatusText());
            }
        }
        writeRaw(response, gson.toJson(result));
    }

    private void handleUnreadCount(HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        int count = chatService.getUnreadCountForAdmin();
        writeRaw(response, "{\"count\":" + count + "}");
    }

    private void handleReply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int conversationId = parseIntOrDefault(request.getParameter("conversationId"), 0);
        String content = request.getParameter("content");

        if (conversationId <= 0) { writeJson(response, false, "Thiếu conversationId"); return; }

        Optional<ChatConversation> convOpt = chatService.getConversationById(conversationId);
        if (convOpt.isEmpty()) { writeJson(response, false, "Không tìm thấy cuộc hội thoại"); return; }
        if (convOpt.get().isClosed()) { writeJson(response, false, "Cuộc hội thoại đã đóng"); return; }

        int adminId = getAdminId(request);
        try {
            ChatMessage msg = chatService.sendMessage(conversationId, adminId, ChatMessage.SENDER_ADMIN, content);
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", "Đã gửi tin nhắn");
            result.add("chatMessage", buildMessageJson(msg));
            writeRaw(response, gson.toJson(result));
        } catch (IllegalArgumentException e) {
            writeJson(response, false, e.getMessage());
        }
    }

    private void handleClose(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int conversationId = parseIntOrDefault(request.getParameter("conversationId"), 0);
        if (conversationId <= 0) { writeJson(response, false, "Thiếu conversationId"); return; }
        chatService.closeConversation(conversationId);
        writeJson(response, true, "Đã đóng cuộc hội thoại");
    }

    private void handleReopen(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int conversationId = parseIntOrDefault(request.getParameter("conversationId"), 0);
        if (conversationId <= 0) { writeJson(response, false, "Thiếu conversationId"); return; }
        chatService.reopenConversation(conversationId);
        writeJson(response, true, "Đã mở lại cuộc hội thoại");
    }

    private JsonObject buildMessageJson(ChatMessage msg) {
        JsonObject obj = new JsonObject();
        obj.addProperty("id",            msg.getId());
        obj.addProperty("conversationId", msg.getConversationId());
        obj.addProperty("senderId",      msg.getSenderId());
        obj.addProperty("senderType",    msg.getSenderType());
        obj.addProperty("content",       msg.getContent());
        obj.addProperty("isRead",        msg.isRead());
        obj.addProperty("timeAgo",       msg.getTimeAgo());
        obj.addProperty("formattedTime", msg.getFormattedTime());
        return obj;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        return session.getAttribute("adminUser") != null;
    }

    private int getAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return 0;
        User admin = (User) session.getAttribute("adminUser");
        return admin != null ? admin.getId() : 0;
    }

    private void writeJson(HttpServletResponse response, boolean success, String message) throws IOException {
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"");
        writeRaw(response, "{\"success\":" + success + ",\"message\":\"" + escaped + "\"}");
    }

    private void writeRaw(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(json);
    }

    private int parseIntOrDefault(String val, int def) {
        if (val == null || val.isEmpty()) return def;
        try { return Integer.parseInt(val); } catch (NumberFormatException e) { return def; }
    }
}
