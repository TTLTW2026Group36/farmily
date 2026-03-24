package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.AdminNotification;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;




public class AdminNotificationDAO extends BaseDao {

    


    private static class AdminNotificationMapper implements RowMapper<AdminNotification> {
        @Override
        public AdminNotification map(ResultSet rs, StatementContext ctx) throws SQLException {
            AdminNotification notification = new AdminNotification();
            notification.setId(rs.getInt("id"));
            notification.setType(rs.getString("type"));
            notification.setTitle(rs.getString("title"));
            notification.setMessage(rs.getString("message"));

            int refId = rs.getInt("reference_id");
            notification.setReferenceId(rs.wasNull() ? null : refId);

            notification.setReferenceType(rs.getString("reference_type"));
            notification.setRead(rs.getBoolean("is_read"));
            notification.setCreatedAt(rs.getTimestamp("created_at"));
            return notification;
        }
    }

    


    public Optional<AdminNotification> findById(int id) {
        String sql = "SELECT * FROM admin_notifications WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new AdminNotificationMapper())
                .findOne());
    }

    


    public List<AdminNotification> findLatest(int limit) {
        String sql = "SELECT * FROM admin_notifications ORDER BY created_at DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .map(new AdminNotificationMapper())
                .list());
    }

    


    public List<AdminNotification> findAllUnread() {
        String sql = "SELECT * FROM admin_notifications WHERE is_read = FALSE ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new AdminNotificationMapper())
                .list());
    }

    


    public List<AdminNotification> findUnread(int limit) {
        String sql = "SELECT * FROM admin_notifications WHERE is_read = FALSE ORDER BY created_at DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .map(new AdminNotificationMapper())
                .list());
    }

    


    public int countUnread() {
        String sql = "SELECT COUNT(*) FROM admin_notifications WHERE is_read = FALSE";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    


    public int insert(AdminNotification notification) {
        String sql = "INSERT INTO admin_notifications (type, title, message, reference_id, reference_type, is_read) " +
                "VALUES (:type, :title, :message, :referenceId, :referenceType, :isRead)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("type", notification.getType())
                .bind("title", notification.getTitle())
                .bind("message", notification.getMessage())
                .bind("referenceId", notification.getReferenceId())
                .bind("referenceType", notification.getReferenceType())
                .bind("isRead", notification.isRead())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    


    public int markAsRead(int id) {
        String sql = "UPDATE admin_notifications SET is_read = TRUE WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    


    public int markAllAsRead() {
        String sql = "UPDATE admin_notifications SET is_read = TRUE WHERE is_read = FALSE";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .execute());
    }

    


    public int deleteOlderThan(int days) {
        String sql = "DELETE FROM admin_notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL :days DAY)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("days", days)
                .execute());
    }
}
