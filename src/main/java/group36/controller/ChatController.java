package group36.controller;

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

@WebServlet(name = "ChatController", urlPatterns = {"/api/chat", "/api/chat/*"})
@MultipartConfig
public class ChatController extends HttpServlet {

    private final ChatService chatService = new ChatService();
    private final AdminNotificationService notificationService = new AdminNotificationService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getAuthUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeRaw(response, "{\"error\":\"Vui lòng đăng nhập\"}");
            return;
        }

        String path = request.getPathInfo();
        try {
            if (path == null || "/conversations".equals(path) || "/".equals(path)) {
                handleGetConversations(request, response, user);
            } else if ("/messages".equals(path)) {
                handleGetMessages(request, response, user);
            } else if ("/unread-count".equals(path)) {
                handleUnreadCount(response, user);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                writeRaw(response, "{\"error\":\"Not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeRaw(response, "{\"error\":\"Lỗi hệ thống\"}");
            System.err.println("[ChatController] GET error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = getAuthUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeRaw(response, "{\"error\":\"Vui lòng đăng nhập\"}");
            return;
        }

        String path = request.getPathInfo();
        try {
            if ("/conversations".equals(path)) {
                handleCreateConversation(request, response, user);
            } else if ("/send".equals(path)) {
                handleSendMessage(request, response, user);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                writeRaw(response, "{\"error\":\"Not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            writeRaw(response, "{\"error\":\"Lỗi hệ thống\"}");
            System.err.println("[ChatController] POST error: " + e.getMessage());
        }
    }

    private void handleGetConversations(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        List<ChatConversation> conversations = chatService.getUserConversations(user.getId());
        int unreadTotal = chatService.getUnreadCountForUser(user.getId());

        JsonObject result = new JsonObject();
        result.addProperty("unreadTotal", unreadTotal);

        JsonArray arr = new JsonArray();
        for (ChatConversation conv : conversations) {
            arr.add(buildConversationJson(conv));
        }
        result.add("conversations", arr);
        writeRaw(response, gson.toJson(result));
    }

    private void handleGetMessages(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int conversationId = parseIntParam(request, "conversationId", 0);
        if (conversationId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeRaw(response, "{\"error\":\"conversationId required\"}");
            return;
        }
        if (!chatService.conversationBelongsToUser(conversationId, user.getId())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            writeRaw(response, "{\"error\":\"Không có quyền truy cập\"}");
            return;
        }

        int limit  = parseIntParam(request, "limit", 50);
        int offset = parseIntParam(request, "offset", 0);
        if (limit > 100) limit = 100;

        chatService.markMessagesAsRead(conversationId, ChatMessage.SENDER_CUSTOMER);

        List<ChatMessage> messages = chatService.getMessages(conversationId, limit, offset);
        int total = chatService.countMessages(conversationId);

        JsonObject result = new JsonObject();
        result.addProperty("total", total);
        JsonArray arr = new JsonArray();
        for (ChatMessage msg : messages) arr.add(buildMessageJson(msg));
        result.add("messages", arr);

        Optional<ChatConversation> convOpt = chatService.getConversationById(conversationId);
        if (convOpt.isPresent()) {
            ChatConversation conv = convOpt.get();
            result.addProperty("status", conv.getStatus());
            result.addProperty("subject", conv.getDisplaySubject());
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

    private void handleUnreadCount(HttpServletResponse response, User user) throws IOException {
        int count = chatService.getUnreadCountForUser(user.getId());
        writeRaw(response, "{\"count\":" + count + "}");
    }

    private void handleCreateConversation(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String subject = request.getParameter("subject");
        String refundIdStr = request.getParameter("refundRequestId");
        Integer refundRequestId = null;
        if (refundIdStr != null && !refundIdStr.isEmpty()) {
            try { refundRequestId = Integer.parseInt(refundIdStr); } catch (NumberFormatException ignored) {}
        }

        ChatConversation conv = chatService.createConversation(user.getId(), refundRequestId, subject);
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.addProperty("conversationId", conv.getId());
        writeRaw(response, gson.toJson(result));
    }

    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int conversationId = parseIntParam(request, "conversationId", 0);
        String content = request.getParameter("content");

        if (conversationId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeRaw(response, "{\"error\":\"conversationId required\"}");
            return;
        }
        if (!chatService.conversationBelongsToUser(conversationId, user.getId())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            writeRaw(response, "{\"error\":\"Không có quyền truy cập\"}");
            return;
        }

        Optional<ChatConversation> convOpt = chatService.getConversationById(conversationId);
        if (convOpt.isEmpty() || convOpt.get().isClosed()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeRaw(response, "{\"error\":\"Cuộc hội thoại đã được đóng\"}");
            return;
        }

        try {
            ChatMessage msg = chatService.sendMessage(conversationId, user.getId(), ChatMessage.SENDER_CUSTOMER, content);
            try {
                String name = user.getName() != null ? user.getName() : user.getEmail();
                notificationService.createChatNotification(conversationId, name);
            } catch (Exception ignored) {}
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.add("message", buildMessageJson(msg));
            writeRaw(response, gson.toJson(result));
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeRaw(response, "{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private JsonObject buildConversationJson(ChatConversation conv) {
        JsonObject obj = new JsonObject();
        obj.addProperty("id",          conv.getId());
        obj.addProperty("subject",     conv.getDisplaySubject());
        obj.addProperty("status",      conv.getStatus());
        obj.addProperty("statusText",  conv.getStatusText());
        obj.addProperty("timeAgo",     conv.getTimeAgo());
        obj.addProperty("unreadCount", conv.getUnreadCount());
        if (conv.getLastMessage() != null) {
            obj.addProperty("lastMessage", conv.getLastMessage().getContent());
            obj.addProperty("lastMessageTime", conv.getLastMessage().getFormattedTime());
        }
        return obj;
    }

    private JsonObject buildMessageJson(ChatMessage msg) {
        JsonObject obj = new JsonObject();
        obj.addProperty("id",           msg.getId());
        obj.addProperty("conversationId", msg.getConversationId());
        obj.addProperty("senderId",     msg.getSenderId());
        obj.addProperty("senderType",   msg.getSenderType());
        obj.addProperty("content",      msg.getContent());
        obj.addProperty("isRead",       msg.isRead());
        obj.addProperty("timeAgo",      msg.getTimeAgo());
        obj.addProperty("formattedTime", msg.getFormattedTime());
        return obj;
    }

    private User getAuthUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("auth");
    }

    private int parseIntParam(HttpServletRequest request, String name, int def) {
        String val = request.getParameter(name);
        if (val == null || val.trim().isEmpty()) return def;
        try { return Integer.parseInt(val.trim()); } catch (NumberFormatException e) { return def; }
    }

    private void writeRaw(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(json);
    }
}
