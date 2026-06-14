package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.ChatMessage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class ChatMessageDAO extends BaseDao {

    private static class MessageMapper implements RowMapper<ChatMessage> {
        @Override
        public ChatMessage map(ResultSet rs, StatementContext ctx) throws SQLException {
            ChatMessage m = new ChatMessage();
            m.setId(rs.getInt("id"));
            m.setConversationId(rs.getInt("conversation_id"));
            m.setSenderId(rs.getInt("sender_id"));
            m.setSenderType(rs.getString("sender_type"));
            m.setContent(rs.getString("content"));
            m.setRead(rs.getBoolean("is_read"));
            m.setCreatedAt(rs.getTimestamp("created_at"));
            return m;
        }
    }

    public int create(ChatMessage msg) {
        String sql = "INSERT INTO chat_messages (conversation_id, sender_id, sender_type, content) " +
                     "VALUES (:conversationId, :senderId, :senderType, :content)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("conversationId", msg.getConversationId())
                .bind("senderId",       msg.getSenderId())
                .bind("senderType",     msg.getSenderType())
                .bind("content",        msg.getContent())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public List<ChatMessage> findByConversationId(int conversationId, int limit, int offset) {
        String sql = "SELECT * FROM chat_messages WHERE conversation_id = :conversationId " +
                     "ORDER BY created_at ASC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("conversationId", conversationId)
                .bind("limit",          limit)
                .bind("offset",         offset)
                .map(new MessageMapper())
                .list());
    }

    public int countByConversationId(int conversationId) {
        String sql = "SELECT COUNT(*) FROM chat_messages WHERE conversation_id = :conversationId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("conversationId", conversationId)
                .mapTo(Integer.class).one());
    }

    public void markAsRead(int conversationId, String senderType) {
        String sql = "UPDATE chat_messages SET is_read = 1 " +
                     "WHERE conversation_id = :conversationId AND sender_type = :senderType AND is_read = 0";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("conversationId", conversationId)
                .bind("senderType",     senderType)
                .execute());
    }

    public int countUnreadForUser(int userId) {
        String sql = "SELECT COUNT(*) FROM chat_messages cm " +
                     "JOIN chat_conversations cc ON cc.id = cm.conversation_id " +
                     "WHERE cc.user_id = :userId AND cm.sender_type = 'admin' AND cm.is_read = 0";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class).one());
    }

    public int countUnreadForAdmin() {
        String sql = "SELECT COUNT(*) FROM chat_messages WHERE sender_type = 'customer' AND is_read = 0";
        return get().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public Optional<ChatMessage> getLastMessage(int conversationId) {
        String sql = "SELECT * FROM chat_messages WHERE conversation_id = :conversationId " +
                     "ORDER BY created_at DESC LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("conversationId", conversationId)
                .map(new MessageMapper())
                .findOne());
    }
}
