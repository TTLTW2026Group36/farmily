package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.ChatConversation;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class ChatConversationDAO extends BaseDao {

    private static class ConversationMapper implements RowMapper<ChatConversation> {
        @Override
        public ChatConversation map(ResultSet rs, StatementContext ctx) throws SQLException {
            ChatConversation c = new ChatConversation();
            c.setId(rs.getInt("id"));
            c.setUserId(rs.getInt("user_id"));
            int refundId = rs.getInt("refund_request_id");
            c.setRefundRequestId(rs.wasNull() ? null : refundId);
            c.setSubject(rs.getString("subject"));
            c.setStatus(rs.getString("status"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            c.setUpdatedAt(rs.getTimestamp("updated_at"));
            return c;
        }
    }

    public int create(ChatConversation conv) {
        String sql = "INSERT INTO chat_conversations (user_id, refund_request_id, subject, status) " +
                     "VALUES (:userId, :refundRequestId, :subject, :status)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId",          conv.getUserId())
                .bind("refundRequestId", conv.getRefundRequestId())
                .bind("subject",         conv.getSubject())
                .bind("status",          conv.getStatus())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public Optional<ChatConversation> findById(int id) {
        String sql = "SELECT * FROM chat_conversations WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new ConversationMapper())
                .findOne());
    }

    public List<ChatConversation> findByUserId(int userId) {
        String sql = "SELECT * FROM chat_conversations WHERE user_id = :userId ORDER BY updated_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new ConversationMapper())
                .list());
    }

    public List<ChatConversation> findAll(String statusFilter, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            String sql = "SELECT * FROM chat_conversations WHERE status = :status ORDER BY updated_at DESC LIMIT :limit OFFSET :offset";
            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("status", statusFilter)
                    .bind("limit",  pageSize)
                    .bind("offset", offset)
                    .map(new ConversationMapper())
                    .list());
        }
        String sql = "SELECT * FROM chat_conversations ORDER BY updated_at DESC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit",  pageSize)
                .bind("offset", offset)
                .map(new ConversationMapper())
                .list());
    }

    public int countAll(String statusFilter) {
        if (statusFilter != null && !statusFilter.isEmpty()) {
            String sql = "SELECT COUNT(*) FROM chat_conversations WHERE status = :status";
            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("status", statusFilter)
                    .mapTo(Integer.class).one());
        }
        String sql = "SELECT COUNT(*) FROM chat_conversations";
        return get().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public Optional<ChatConversation> findByRefundRequestId(int refundRequestId) {
        String sql = "SELECT * FROM chat_conversations WHERE refund_request_id = :refundRequestId LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("refundRequestId", refundRequestId)
                .map(new ConversationMapper())
                .findOne());
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE chat_conversations SET status = :status WHERE id = :id";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("status", status)
                .bind("id",     id)
                .execute());
    }

    public void updateTimestamp(int id) {
        String sql = "UPDATE chat_conversations SET updated_at = CURRENT_TIMESTAMP WHERE id = :id";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public int countUnreadConversations(int userId) {
        String sql = "SELECT COUNT(DISTINCT cm.conversation_id) " +
                     "FROM chat_messages cm " +
                     "JOIN chat_conversations cc ON cc.id = cm.conversation_id " +
                     "WHERE cc.user_id = :userId AND cm.sender_type = 'admin' AND cm.is_read = 0";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class).one());
    }
}
