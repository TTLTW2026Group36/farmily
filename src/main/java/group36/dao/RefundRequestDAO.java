package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.RefundRequest;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class RefundRequestDAO extends BaseDao {

    private static class RefundRequestMapper implements RowMapper<RefundRequest> {
        @Override
        public RefundRequest map(ResultSet rs, StatementContext ctx) throws SQLException {
            RefundRequest r = new RefundRequest();
            r.setId(rs.getInt("id"));
            r.setOrderId(rs.getInt("order_id"));
            r.setUserId(rs.getInt("user_id"));
            r.setReason(rs.getString("reason"));
            r.setDescription(rs.getString("description"));
            r.setBankName(rs.getString("bank_name"));
            r.setBankAccount(rs.getString("bank_account"));
            r.setBankHolder(rs.getString("bank_holder"));
            r.setRefundAmount(rs.getDouble("refund_amount"));
            r.setStatus(rs.getString("status"));
            r.setAdminNote(rs.getString("admin_note"));
            r.setTransactionCode(rs.getString("transaction_code"));
            r.setCreatedAt(rs.getTimestamp("created_at"));
            r.setUpdatedAt(rs.getTimestamp("updated_at"));
            return r;
        }
    }

    public int insert(RefundRequest r) {
        String sql = "INSERT INTO refund_requests " +
                "(order_id, user_id, reason, description, bank_name, bank_account, bank_holder, refund_amount, status) " +
                "VALUES (:orderId, :userId, :reason, :description, :bankName, :bankAccount, :bankHolder, :refundAmount, 'pending')";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId",       r.getOrderId())
                .bind("userId",        r.getUserId())
                .bind("reason",        r.getReason())
                .bind("description",   r.getDescription())
                .bind("bankName",      r.getBankName())
                .bind("bankAccount",   r.getBankAccount())
                .bind("bankHolder",    r.getBankHolder())
                .bind("refundAmount",  r.getRefundAmount())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public Optional<RefundRequest> findById(int id) {
        String sql = "SELECT * FROM refund_requests WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new RefundRequestMapper())
                .findOne());
    }

    public Optional<RefundRequest> findByOrderId(int orderId) {
        String sql = "SELECT * FROM refund_requests WHERE order_id = :orderId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map(new RefundRequestMapper())
                .findOne());
    }

    public List<RefundRequest> findByUserId(int userId) {
        String sql = "SELECT * FROM refund_requests WHERE user_id = :userId ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new RefundRequestMapper())
                .list());
    }

    public List<RefundRequest> findByUserIdPaginated(int userId, int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM refund_requests WHERE user_id = :userId " +
                "ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("limit",  size)
                .bind("offset", offset)
                .map(new RefundRequestMapper())
                .list());
    }

    public List<RefundRequest> findAll() {
        String sql = "SELECT * FROM refund_requests ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new RefundRequestMapper())
                .list());
    }

    public List<RefundRequest> findByStatus(String status) {
        String sql = "SELECT * FROM refund_requests WHERE status = :status ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("status", status)
                .map(new RefundRequestMapper())
                .list());
    }

    public List<RefundRequest> findAllPaginated(int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM refund_requests ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit",  size)
                .bind("offset", offset)
                .map(new RefundRequestMapper())
                .list());
    }

    public List<RefundRequest> findByStatusPaginated(String status, int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM refund_requests WHERE status = :status " +
                "ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("status", status)
                .bind("limit",  size)
                .bind("offset", offset)
                .map(new RefundRequestMapper())
                .list());
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM refund_requests";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class).one());
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM refund_requests WHERE status = :status";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("status", status)
                .mapTo(Integer.class).one());
    }

    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM refund_requests WHERE user_id = :userId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class).one());
    }

    public int updateStatus(int id, String status, String adminNote) {
        String sql = "UPDATE refund_requests SET status = :status, admin_note = :adminNote WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id",        id)
                .bind("status",    status)
                .bind("adminNote", adminNote)
                .execute());
    }

    public int updateConfirmRefunded(int id, String status, String transactionCode) {
        String sql = "UPDATE refund_requests SET status = :status, transaction_code = :transactionCode WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id",              id)
                .bind("status",          status)
                .bind("transactionCode", transactionCode)
                .execute());
    }

    public int updateRefundAmount(int id, double amount) {
        String sql = "UPDATE refund_requests SET refund_amount = :amount WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id",     id)
                .bind("amount", amount)
                .execute());
    }

    public boolean existsByOrderId(int orderId) {
        String sql = "SELECT COUNT(*) FROM refund_requests WHERE order_id = :orderId";
        int count = get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapTo(Integer.class).one());
        return count > 0;
    }
}
