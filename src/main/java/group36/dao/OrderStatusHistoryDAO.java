package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.OrderStatusHistory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class OrderStatusHistoryDAO extends BaseDao {

    private static class OrderStatusHistoryMapper implements RowMapper<OrderStatusHistory> {
        @Override
        public OrderStatusHistory map(ResultSet rs, StatementContext ctx) throws SQLException {
            OrderStatusHistory history = new OrderStatusHistory();
            history.setId(rs.getInt("id"));
            history.setOrderId(rs.getInt("order_id"));
            history.setOldStatus(rs.getString("old_status"));
            history.setNewStatus(rs.getString("new_status"));
            history.setChangedBy(rs.getString("changed_by"));
            
            int changedById = rs.getInt("changed_by_id");
            history.setChangedById(rs.wasNull() ? null : changedById);
            
            history.setNote(rs.getString("note"));
            history.setCreatedAt(rs.getTimestamp("created_at"));
            return history;
        }
    }

    public int insert(OrderStatusHistory history) {
        String sql = "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, changed_by_id, note) " +
                     "VALUES (:orderId, :oldStatus, :newStatus, :changedBy, :changedById, :note)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", history.getOrderId())
                .bind("oldStatus", history.getOldStatus())
                .bind("newStatus", history.getNewStatus())
                .bind("changedBy", history.getChangedBy())
                .bind("changedById", history.getChangedById())
                .bind("note", history.getNote())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public List<OrderStatusHistory> findByOrderId(int orderId) {
        String sql = "SELECT * FROM order_status_history WHERE order_id = :orderId ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map(new OrderStatusHistoryMapper())
                .list());
    }

    public Optional<OrderStatusHistory> findLatestByOrderId(int orderId) {
        String sql = "SELECT * FROM order_status_history WHERE order_id = :orderId ORDER BY created_at DESC LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map(new OrderStatusHistoryMapper())
                .findOne());
    }
}
