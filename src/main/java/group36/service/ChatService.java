package group36.service;

import group36.dao.ChatConversationDAO;
import group36.dao.ChatMessageDAO;
import group36.dao.UserDAO;
import group36.dao.RefundRequestDAO;
import group36.model.ChatConversation;
import group36.model.ChatMessage;
import group36.model.RefundRequest;

import java.util.List;
import java.util.Optional;

public class ChatService {

    private final ChatConversationDAO conversationDAO = new ChatConversationDAO();
    private final ChatMessageDAO messageDAO = new ChatMessageDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RefundRequestDAO refundRequestDAO = new RefundRequestDAO();

    private static final int MAX_CONTENT_LENGTH = 2000;

    public ChatConversation createConversation(int userId, Integer refundRequestId, String subject) {
        ChatConversation conv = new ChatConversation();
        conv.setUserId(userId);
        conv.setRefundRequestId(refundRequestId);
        conv.setSubject(subject != null ? subject.trim() : null);
        conv.setStatus(ChatConversation.STATUS_OPEN);
        int id = conversationDAO.create(conv);
        conv.setId(id);
        return conv;
    }

    public ChatConversation getOrCreateRefundConversation(int userId, int refundRequestId) {
        Optional<ChatConversation> existing = conversationDAO.findByRefundRequestId(refundRequestId);
        if (existing.isPresent()) {
            ChatConversation conv = existing.get();
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
            return conv;
        }
        String dbSubject = "Hỗ trợ hoàn tiền đơn hàng";
        Optional<RefundRequest> refOpt = refundRequestDAO.findById(refundRequestId);
        if (refOpt.isPresent()) {
            dbSubject = "Hỗ trợ hoàn tiền đơn hàng #" + refOpt.get().getOrderId();
        }
        ChatConversation conv = createConversation(userId, refundRequestId, dbSubject);
        refOpt.ifPresent(conv::setRefundRequest);
        return conv;
    }

    public ChatConversation getOrCreateRefundConversation(int refundRequestId) {
        Optional<ChatConversation> existing = conversationDAO.findByRefundRequestId(refundRequestId);
        if (existing.isPresent()) {
            ChatConversation conv = existing.get();
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
            return conv;
        }
        Optional<RefundRequest> refOpt = refundRequestDAO.findById(refundRequestId);
        if (refOpt.isPresent()) {
            RefundRequest ref = refOpt.get();
            return getOrCreateRefundConversation(ref.getUserId(), refundRequestId);
        }
        return null;
    }

    public List<ChatConversation> getUserConversations(int userId) {
        List<ChatConversation> list = conversationDAO.findByUserId(userId);
        for (ChatConversation conv : list) {
            messageDAO.getLastMessage(conv.getId()).ifPresent(conv::setLastMessage);
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
            int unread = countUnreadInConversationForUser(conv.getId());
            conv.setUnreadCount(unread);
        }
        return list;
    }

    public List<ChatConversation> getAllConversations(String statusFilter, int page, int pageSize) {
        List<ChatConversation> list = conversationDAO.findAll(statusFilter, page, pageSize);
        for (ChatConversation conv : list) {
            messageDAO.getLastMessage(conv.getId()).ifPresent(conv::setLastMessage);
            userDAO.findById(conv.getUserId()).ifPresent(conv::setUser);
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
            int unread = countUnreadInConversationForAdmin(conv.getId());
            conv.setUnreadCount(unread);
        }
        return list;
    }

    public int countAllConversations(String statusFilter) {
        return conversationDAO.countAll(statusFilter);
    }

    public ChatMessage sendMessage(int conversationId, int senderId, String senderType, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống");
        }
        String trimmed = content.trim();
        if (trimmed.length() > MAX_CONTENT_LENGTH) {
            throw new IllegalArgumentException("Nội dung không được vượt quá " + MAX_CONTENT_LENGTH + " ký tự");
        }

        ChatMessage msg = new ChatMessage();
        msg.setConversationId(conversationId);
        msg.setSenderId(senderId);
        msg.setSenderType(senderType);
        msg.setContent(escapeHtml(trimmed));

        int id = messageDAO.create(msg);
        msg.setId(id);

        conversationDAO.updateTimestamp(conversationId);
        return msg;
    }

    public List<ChatMessage> getMessages(int conversationId, int limit, int offset) {
        return messageDAO.findByConversationId(conversationId, limit, offset);
    }

    public int countMessages(int conversationId) {
        return messageDAO.countByConversationId(conversationId);
    }

    public void markMessagesAsRead(int conversationId, String readerType) {
        String senderType = ChatMessage.SENDER_CUSTOMER.equals(readerType)
                ? ChatMessage.SENDER_ADMIN
                : ChatMessage.SENDER_CUSTOMER;
        messageDAO.markAsRead(conversationId, senderType);
    }

    public void closeConversation(int conversationId) {
        conversationDAO.updateStatus(conversationId, ChatConversation.STATUS_CLOSED);
    }

    public void reopenConversation(int conversationId) {
        conversationDAO.updateStatus(conversationId, ChatConversation.STATUS_OPEN);
    }

    public int getUnreadCountForUser(int userId) {
        return messageDAO.countUnreadForUser(userId);
    }

    public int getUnreadCountForAdmin() {
        return messageDAO.countUnreadForAdmin();
    }

    public Optional<ChatConversation> getConversationById(int id) {
        Optional<ChatConversation> convOpt = conversationDAO.findById(id);
        if (convOpt.isPresent()) {
            ChatConversation conv = convOpt.get();
            userDAO.findById(conv.getUserId()).ifPresent(conv::setUser);
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
        }
        return convOpt;
    }

    public Optional<ChatConversation> getConversationByRefundId(int refundRequestId) {
        Optional<ChatConversation> convOpt = conversationDAO.findByRefundRequestId(refundRequestId);
        if (convOpt.isPresent()) {
            ChatConversation conv = convOpt.get();
            userDAO.findById(conv.getUserId()).ifPresent(conv::setUser);
            if (conv.getRefundRequestId() != null) {
                refundRequestDAO.findById(conv.getRefundRequestId()).ifPresent(conv::setRefundRequest);
            }
        }
        return convOpt;
    }

    public boolean conversationBelongsToUser(int conversationId, int userId) {
        Optional<ChatConversation> conv = conversationDAO.findById(conversationId);
        return conv.isPresent() && conv.get().getUserId() == userId;
    }

    private int countUnreadInConversationForUser(int conversationId) {
        List<ChatMessage> messages = messageDAO.findByConversationId(conversationId, 100, 0);
        return (int) messages.stream().filter(m -> m.isFromAdmin() && !m.isRead()).count();
    }

    private int countUnreadInConversationForAdmin(int conversationId) {
        List<ChatMessage> messages = messageDAO.findByConversationId(conversationId, 100, 0);
        return (int) messages.stream().filter(m -> m.isFromCustomer() && !m.isRead()).count();
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
}
