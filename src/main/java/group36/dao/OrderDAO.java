package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Order;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class OrderDAO extends BaseDao {

        private static class OrderMapper implements RowMapper<Order> {
                @Override
                public Order map(ResultSet rs, StatementContext ctx) throws SQLException {
                        Order order = new Order();
                        order.setId(rs.getInt("id"));

                        int userId = rs.getInt("user_id");
                        order.setUserId(rs.wasNull() ? null : userId);

                        order.setAddressId(rs.getInt("address_id"));
                        order.setPaymentMethodId(rs.getInt("payment_method_id"));
                        order.setStatus(rs.getString("status"));
                        order.setNote(rs.getString("note"));
                        order.setShippingFee(rs.getDouble("shipping_fee"));
                        order.setTotalPrice(rs.getDouble("total_price"));
                        order.setOrderDate(rs.getTimestamp("order_date"));

                        try {
                                order.setGuestEmail(rs.getString("guest_email"));
                                order.setGuestName(rs.getString("guest_name"));
                                order.setGuestPhone(rs.getString("guest_phone"));
                        } catch (SQLException e) {

                        }

                        return order;
                }
        }

        public Optional<Order> findById(int id) {
                String sql = "SELECT * FROM orders WHERE id = :id";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("id", id)
                                .map(new OrderMapper())
                                .findOne());
        }

        public List<Order> findByUserId(int userId) {
                String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY order_date DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("userId", userId)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findAll() {
                String sql = "SELECT * FROM orders ORDER BY order_date DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findAllPaginated(int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM orders ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("size", size)
                                .bind("offset", offset)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findByStatus(String status) {
                String sql = "SELECT * FROM orders WHERE status = :status ORDER BY order_date DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("status", status)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findByStatusPaginated(String status, int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM orders WHERE status = :status ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("status", status)
                                .bind("size", size)
                                .bind("offset", offset)
                                .map(new OrderMapper())
                                .list());
        }

        public int insert(Order order) {
                String sql = "INSERT INTO orders (user_id, address_id, payment_method_id, status, note, shipping_fee, total_price) "
                                +
                                "VALUES (:userId, :addressId, :paymentMethodId, :status, :note, :shippingFee, :totalPrice)";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("userId", order.getUserId())
                                .bind("addressId", order.getAddressId())
                                .bind("paymentMethodId", order.getPaymentMethodId())
                                .bind("status", order.getStatus())
                                .bind("note", order.getNote())
                                .bind("shippingFee", order.getShippingFee())
                                .bind("totalPrice", order.getTotalPrice())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        public int insertGuestOrder(Order order) {
                String sql = "INSERT INTO orders (user_id, address_id, payment_method_id, status, note, " +
                                "shipping_fee, total_price, guest_email, guest_name, guest_phone) " +
                                "VALUES (NULL, :addressId, :paymentMethodId, :status, :note, :shippingFee, :totalPrice, "
                                +
                                ":guestEmail, :guestName, :guestPhone)";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("addressId", order.getAddressId())
                                .bind("paymentMethodId", order.getPaymentMethodId())
                                .bind("status", order.getStatus())
                                .bind("note", order.getNote())
                                .bind("shippingFee", order.getShippingFee())
                                .bind("totalPrice", order.getTotalPrice())
                                .bind("guestEmail", order.getGuestEmail())
                                .bind("guestName", order.getGuestName())
                                .bind("guestPhone", order.getGuestPhone())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        public int updateStatus(int orderId, String status) {
                String sql = "UPDATE orders SET status = :status WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", orderId)
                                .bind("status", status)
                                .execute());
        }

        public int count() {
                String sql = "SELECT COUNT(*) FROM orders";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countByStatus(String status) {
                String sql = "SELECT COUNT(*) FROM orders WHERE status = :status";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("status", status)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countByUserId(int userId) {
                String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("userId", userId)
                                .mapTo(Integer.class)
                                .one());
        }

        public double getTotalRevenue() {
                String sql = "SELECT COALESCE(SUM(total_price), 0) FROM orders WHERE status = 'completed'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Double.class)
                                .one());
        }

        public double getRevenueThisMonth() {
                String sql = "SELECT COALESCE(SUM(total_price), 0) FROM orders " +
                                "WHERE status = 'completed' " +
                                "AND MONTH(order_date) = MONTH(CURRENT_DATE()) " +
                                "AND YEAR(order_date) = YEAR(CURRENT_DATE())";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Double.class)
                                .one());
        }

        public double getRevenuePreviousMonth() {
                String sql = "SELECT COALESCE(SUM(total_price), 0) FROM orders " +
                                "WHERE status = 'completed' " +
                                "AND MONTH(order_date) = MONTH(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) " +
                                "AND YEAR(order_date) = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Double.class)
                                .one());
        }

        public int countOrdersThisMonth() {
                String sql = "SELECT COUNT(*) FROM orders " +
                                "WHERE MONTH(order_date) = MONTH(CURRENT_DATE()) " +
                                "AND YEAR(order_date) = YEAR(CURRENT_DATE())";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countOrdersPreviousMonth() {
                String sql = "SELECT COUNT(*) FROM orders " +
                                "WHERE MONTH(order_date) = MONTH(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) " +
                                "AND YEAR(order_date) = YEAR(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Integer.class)
                                .one());
        }

        public List<Order> findRecent(int limit) {
                String sql = "SELECT * FROM orders ORDER BY order_date DESC LIMIT :limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("limit", limit)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findFiltered(String status, String keyword, String fromDate, String toDate, int page,
                        int size) {
                int offset = (page - 1) * size;
                StringBuilder sql = new StringBuilder(
                                "SELECT o.* FROM orders o " +
                                                "LEFT JOIN address a ON o.address_id = a.id " +
                                                "WHERE 1=1 ");
                if (status != null && !status.isEmpty()) {
                        if ("processing".equals(status)) {
                                sql.append("AND o.status IN ('confirmed','processing') ");
                        } else {
                                sql.append("AND o.status = :status ");
                        }
                }
                if (keyword != null && !keyword.isEmpty()) {
                        sql.append("AND (CAST(o.id AS CHAR) LIKE :kw " +
                                        "OR a.receiver LIKE :kw " +
                                        "OR a.phone LIKE :kw " +
                                        "OR o.guest_name LIKE :kw " +
                                        "OR o.guest_phone LIKE :kw) ");
                }
                if (fromDate != null && !fromDate.isEmpty()) {
                        sql.append("AND DATE(o.order_date) >= :fromDate ");
                }
                if (toDate != null && !toDate.isEmpty()) {
                        sql.append("AND DATE(o.order_date) <= :toDate ");
                }
                sql.append("ORDER BY o.order_date DESC LIMIT :size OFFSET :offset");

                String finalSql = sql.toString();
                return get().withHandle(handle -> {
                        org.jdbi.v3.core.statement.Query q = handle.createQuery(finalSql);
                        if (status != null && !status.isEmpty() && !"processing".equals(status))
                                q.bind("status", status);
                        if (keyword != null && !keyword.isEmpty())
                                q.bind("kw", "%" + keyword + "%");
                        if (fromDate != null && !fromDate.isEmpty())
                                q.bind("fromDate", fromDate);
                        if (toDate != null && !toDate.isEmpty())
                                q.bind("toDate", toDate);
                        q.bind("size", size).bind("offset", offset);
                        return q.map(new OrderMapper()).list();
                });
        }

        public int countFiltered(String status, String keyword, String fromDate, String toDate) {
                StringBuilder sql = new StringBuilder(
                                "SELECT COUNT(*) FROM orders o " +
                                                "LEFT JOIN address a ON o.address_id = a.id " +
                                                "WHERE 1=1 ");
                if (status != null && !status.isEmpty()) {
                        if ("processing".equals(status)) {
                                sql.append("AND o.status IN ('confirmed','processing') ");
                        } else {
                                sql.append("AND o.status = :status ");
                        }
                }
                if (keyword != null && !keyword.isEmpty()) {
                        sql.append("AND (CAST(o.id AS CHAR) LIKE :kw " +
                                        "OR a.receiver LIKE :kw " +
                                        "OR a.phone LIKE :kw " +
                                        "OR o.guest_name LIKE :kw " +
                                        "OR o.guest_phone LIKE :kw) ");
                }
                if (fromDate != null && !fromDate.isEmpty()) {
                        sql.append("AND DATE(o.order_date) >= :fromDate ");
                }
                if (toDate != null && !toDate.isEmpty()) {
                        sql.append("AND DATE(o.order_date) <= :toDate ");
                }
                String finalSql = sql.toString();
                return get().withHandle(handle -> {
                        org.jdbi.v3.core.statement.Query q = handle.createQuery(finalSql);
                        if (status != null && !status.isEmpty() && !"processing".equals(status))
                                q.bind("status", status);
                        if (keyword != null && !keyword.isEmpty())
                                q.bind("kw", "%" + keyword + "%");
                        if (fromDate != null && !fromDate.isEmpty())
                                q.bind("fromDate", fromDate);
                        if (toDate != null && !toDate.isEmpty())
                                q.bind("toDate", toDate);
                        return q.mapTo(Integer.class).one();
                });
        }
}
