package group36.dao;

import group36.model.Payment;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class PaymentDAO extends BaseDao {

        private static class PaymentMapper implements RowMapper<Payment> {
                @Override
                public Payment map(ResultSet rs, StatementContext ctx) throws SQLException {
                        Payment p = new Payment();
                        p.setId(rs.getInt("id"));
                        p.setOrderId(rs.getInt("order_id"));
                        p.setPaymentCode(rs.getString("payment_code"));
                        p.setInvoiceNumber(rs.getString("invoice_number"));
                        p.setProvider(rs.getString("provider"));
                        p.setAmount(rs.getBigDecimal("amount"));
                        p.setStatus(rs.getString("status"));
                        p.setPaymentUrl(rs.getString("payment_url"));
                        p.setRawWebhookPayload(rs.getString("raw_webhook_payload"));
                        p.setSepayOrderId(rs.getString("sepay_order_id"));
                        p.setTransactionId(rs.getString("transaction_id"));
                        p.setPaidAt(rs.getTimestamp("paid_at"));
                        p.setExpiredAt(rs.getTimestamp("expired_at"));
                        p.setCreatedAt(rs.getTimestamp("created_at"));
                        p.setUpdatedAt(rs.getTimestamp("updated_at"));
                        return p;
                }
        }

        public int insert(Payment payment) {
                return get().withHandle(handle -> handle.createUpdate(
                                "INSERT INTO payments (order_id, payment_code, invoice_number, provider, " +
                                                "amount, status, payment_url, expired_at) " +
                                                "VALUES (:orderId, :paymentCode, :invoiceNumber, :provider, " +
                                                ":amount, :status, :paymentUrl, :expiredAt)")
                                .bind("orderId", payment.getOrderId())
                                .bind("paymentCode", payment.getPaymentCode())
                                .bind("invoiceNumber", payment.getInvoiceNumber())
                                .bind("provider", payment.getProvider())
                                .bind("amount", payment.getAmount())
                                .bind("status", payment.getStatus())
                                .bind("paymentUrl", payment.getPaymentUrl())
                                .bind("expiredAt", payment.getExpiredAt())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        public Optional<Payment> findByInvoiceNumber(String invoiceNumber) {
                return get().withHandle(
                                handle -> handle.createQuery("SELECT * FROM payments WHERE invoice_number = :inv")
                                                .bind("inv", invoiceNumber)
                                                .map(new PaymentMapper())
                                                .findFirst());
        }

        public Optional<Payment> findLatestByOrderId(int orderId) {
                return get().withHandle(handle -> handle.createQuery(
                                "SELECT * FROM payments WHERE order_id = :orderId ORDER BY id DESC LIMIT 1")
                                .bind("orderId", orderId)
                                .map(new PaymentMapper())
                                .findFirst());
        }

        public List<Payment> findAllByOrderId(int orderId) {
                return get().withHandle(handle -> handle.createQuery(
                                "SELECT * FROM payments WHERE order_id = :orderId ORDER BY id DESC")
                                .bind("orderId", orderId)
                                .map(new PaymentMapper())
                                .list());
        }

        public void updateStatus(int paymentId, String status) {
                get().useHandle(handle -> handle.createUpdate("UPDATE payments SET status = :status WHERE id = :id")
                                .bind("status", status)
                                .bind("id", paymentId)
                                .execute());
        }

        public void updateWithWebhook(int paymentId, String status, String transactionId,
                        String sepayOrderId, String rawPayload) {
                get().useHandle(handle -> handle.createUpdate(
                                "UPDATE payments SET status = :status, transaction_id = :txnId, " +
                                                "sepay_order_id = :sepayId, raw_webhook_payload = :payload, " +
                                                "paid_at = CASE WHEN :status = 'paid' THEN NOW() ELSE paid_at END " +
                                                "WHERE id = :id")
                                .bind("status", status)
                                .bind("txnId", transactionId)
                                .bind("sepayId", sepayOrderId)
                                .bind("payload", rawPayload)
                                .bind("id", paymentId)
                                .execute());
        }

        public int expireOverduePayments() {
                return get().withHandle(handle -> handle.createUpdate(
                                "UPDATE payments SET status = 'expired' " +
                                                "WHERE status = 'pending' AND expired_at < NOW()")
                                .execute());
        }
}
