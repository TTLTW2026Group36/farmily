package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.UserNotification;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserNotificationDAO extends BaseDao {

    private static class UserNotificationMapper implements RowMapper<UserNotification> {
        @Override
        public UserNotification map(ResultSet rs, StatementContext ctx) throws SQLException {
            UserNotification n = new UserNotification();
            n.setId(rs.getInt("id"));
            n.setUserId(rs.getInt("user_id"));
            n.setType(rs.getString("type"));
            n.setTitle(rs.getString("title"));
            n.setMessage(rs.getString("message"));
            n.setLink(rs.getString("link"));

            int refId = rs.getInt("reference_id");
            n.setReferenceId(rs.wasNull() ? null : refId);
            n.setReferenceType(rs.getString("reference_type"));
            n.setRead(rs.getBoolean("is_read"));
            n.setCreatedAt(rs.getTimestamp("created_at"));
            return n;
        }
    }

    public List<UserNotification> findByUserId(int userId, int limit) {
        String sql = "SELECT * FROM user_notifications WHERE user_id = :userId "
                   + "ORDER BY created_at DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("limit", limit)
                .map(new UserNotificationMapper())
                .list());
    }

    public List<UserNotification> findByUserIdPaginated(int userId, int limit, int offset) {
        String sql = "SELECT * FROM user_notifications WHERE user_id = :userId "
                   + "ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("limit", limit)
                .bind("offset", offset)
                .map(new UserNotificationMapper())
                .list());
    }

    public int countUnreadByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM user_notifications WHERE user_id = :userId AND is_read = FALSE";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one());
    }

    public int insert(UserNotification notification) {
        String sql = "INSERT INTO user_notifications "
                   + "(user_id, type, title, message, link, reference_id, reference_type, is_read) "
                   + "VALUES (:userId, :type, :title, :message, :link, :referenceId, :referenceType, :isRead)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId",        notification.getUserId())
                .bind("type",          notification.getType())
                .bind("title",         notification.getTitle())
                .bind("message",       notification.getMessage())
                .bind("link",          notification.getLink())
                .bind("referenceId",   notification.getReferenceId())
                .bind("referenceType", notification.getReferenceType())
                .bind("isRead",        notification.isRead())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public void insertBatch(List<UserNotification> notifications) {
        if (notifications == null || notifications.isEmpty()) return;
        String sql = "INSERT INTO user_notifications "
                   + "(user_id, type, title, message, link, reference_id, reference_type, is_read) "
                   + "VALUES (:userId, :type, :title, :message, :link, :referenceId, :referenceType, FALSE)";
        get().useHandle(handle -> {
            var batch = handle.prepareBatch(sql);
            for (UserNotification n : notifications) {
                batch.bind("userId",        n.getUserId())
                     .bind("type",          n.getType())
                     .bind("title",         n.getTitle())
                     .bind("message",       n.getMessage())
                     .bind("link",          n.getLink())
                     .bind("referenceId",   n.getReferenceId())
                     .bind("referenceType", n.getReferenceType())
                     .add();
            }
            batch.execute();
        });
    }

    public int markAsRead(int id, int userId) {
        String sql = "UPDATE user_notifications SET is_read = TRUE WHERE id = :id AND user_id = :userId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id",     id)
                .bind("userId", userId)
                .execute());
    }

    public int markAllAsRead(int userId) {
        String sql = "UPDATE user_notifications SET is_read = TRUE "
                   + "WHERE user_id = :userId AND is_read = FALSE";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .execute());
    }

    public int deleteOlderThan(int days) {
        String sql = "DELETE FROM user_notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL :days DAY)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("days", days)
                .execute());
    }
}
