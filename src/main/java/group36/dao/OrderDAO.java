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

                        try {
                                order.setPaymentStatus(rs.getString("payment_status"));
                        } catch (SQLException e) {
                        }

                        try {
                                order.setAdminNote(rs.getString("admin_note"));
                        } catch (SQLException e) {
                        }

                        try {
                                int couponId = rs.getInt("coupon_id");
                                order.setCouponId(rs.wasNull() ? null : couponId);
                                order.setDiscountAmount(rs.getDouble("discount_amount"));
                        } catch (SQLException e) {
                        }

                        try {
                                int freeshipCouponId = rs.getInt("freeship_coupon_id");
                                order.setFreeshipCouponId(rs.wasNull() ? null : freeshipCouponId);
                                order.setFreeshipDiscountAmount(rs.getDouble("freeship_discount_amount"));
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
                return get().withHandle(h -> insertWithHandle(h, order));
        }

        public int insertWithHandle(org.jdbi.v3.core.Handle h, Order order) {
                String sql = "INSERT INTO orders (user_id, address_id, payment_method_id, status, note, admin_note, shipping_fee, total_price, coupon_id, discount_amount, freeship_coupon_id, freeship_discount_amount) "
                                + "VALUES (:userId, :addressId, :paymentMethodId, :status, :note, :adminNote, :shippingFee, :totalPrice, :couponId, :discountAmount, :freeshipCouponId, :freeshipDiscountAmount)";
                return h.createUpdate(sql)
                                .bind("userId", order.getUserId())
                                .bind("addressId", order.getAddressId())
                                .bind("paymentMethodId", order.getPaymentMethodId())
                                .bind("status", order.getStatus())
                                .bind("note", order.getNote())
                                .bind("adminNote", order.getAdminNote())
                                .bind("shippingFee", order.getShippingFee())
                                .bind("totalPrice", order.getTotalPrice())
                                .bind("couponId", order.getCouponId())
                                .bind("discountAmount", order.getDiscountAmount())
                                .bind("freeshipCouponId", order.getFreeshipCouponId())
                                .bind("freeshipDiscountAmount", order.getFreeshipDiscountAmount())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one();
        }

        public int insertGuestOrder(Order order) {
                return get().withHandle(h -> insertGuestOrderWithHandle(h, order));
        }

        public int insertGuestOrderWithHandle(org.jdbi.v3.core.Handle h, Order order) {
                String sql = "INSERT INTO orders (user_id, address_id, payment_method_id, status, note, admin_note, " +
                                "shipping_fee, total_price, guest_email, guest_name, guest_phone, coupon_id, discount_amount, freeship_coupon_id, freeship_discount_amount) " +
                                "VALUES (NULL, :addressId, :paymentMethodId, :status, :note, :adminNote, :shippingFee, :totalPrice, " +
                                ":guestEmail, :guestName, :guestPhone, :couponId, :discountAmount, :freeshipCouponId, :freeshipDiscountAmount)";
                return h.createUpdate(sql)
                                .bind("addressId", order.getAddressId())
                                .bind("paymentMethodId", order.getPaymentMethodId())
                                .bind("status", order.getStatus())
                                .bind("note", order.getNote())
                                .bind("adminNote", order.getAdminNote())
                                .bind("shippingFee", order.getShippingFee())
                                .bind("totalPrice", order.getTotalPrice())
                                .bind("guestEmail", order.getGuestEmail())
                                .bind("guestName", order.getGuestName())
                                .bind("guestPhone", order.getGuestPhone())
                                .bind("couponId", order.getCouponId())
                                .bind("discountAmount", order.getDiscountAmount())
                                .bind("freeshipCouponId", order.getFreeshipCouponId())
                                .bind("freeshipDiscountAmount", order.getFreeshipDiscountAmount())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one();
        }

        public int updateStatus(int orderId, String status) {
                String sql = "UPDATE orders SET status = :status WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", orderId)
                                .bind("status", status)
                                .execute());
        }

        public int updateAdminNote(int orderId, String adminNote) {
                String sql = "UPDATE orders SET admin_note = :adminNote WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", orderId)
                                .bind("adminNote", adminNote)
                                .execute());
        }

        public int updatePaymentStatus(int orderId, String paymentStatus) {
                String sql = "UPDATE orders SET payment_status = :ps WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", orderId)
                                .bind("ps", paymentStatus)
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

        public double getTotalProfit() {
                String sql = "SELECT COALESCE(SUM(total_price - shipping_fee - (SELECT COALESCE(SUM(import_price * quantity), 0) FROM order_details WHERE order_id = orders.id)), 0) FROM orders WHERE status = 'completed'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Double.class)
                                .one());
        }

        public double getProfitThisMonth() {
                String sql = "SELECT COALESCE(SUM(total_price - shipping_fee - (SELECT COALESCE(SUM(import_price * quantity), 0) FROM order_details WHERE order_id = orders.id)), 0) FROM orders " +
                                "WHERE status = 'completed' " +
                                "AND MONTH(order_date) = MONTH(CURRENT_DATE()) " +
                                "AND YEAR(order_date) = YEAR(CURRENT_DATE())";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Double.class)
                                .one());
        }

        public double getProfitPreviousMonth() {
                String sql = "SELECT COALESCE(SUM(total_price - shipping_fee - (SELECT COALESCE(SUM(import_price * quantity), 0) FROM order_details WHERE order_id = orders.id)), 0) FROM orders " +
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
                        String cleanKeyword = keyword.trim().toUpperCase()
                                        .replace("#", "")
                                        .replace("DH-0", "")
                                        .replace("DH-", "")
                                        .replace("ORD", "");

                        sql.append("AND (CAST(o.id AS CHAR) LIKE :kw ");
                        if (cleanKeyword.matches("\\d+")) {
                                sql.append("OR o.id = :idVal ");
                        }
                        sql.append("OR a.receiver LIKE :kw " +
                                        "OR a.phone LIKE :kw) ");
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
                        if (keyword != null && !keyword.isEmpty()) {
                                q.bind("kw", "%" + keyword + "%");
                                String cleanKeyword = keyword.trim().toUpperCase()
                                                .replace("#", "")
                                                .replace("DH-0", "")
                                                .replace("DH-", "")
                                                .replace("ORD", "");
                                if (cleanKeyword.matches("\\d+")) {
                                        q.bind("idVal", Integer.parseInt(cleanKeyword));
                                }
                        }
                        if (fromDate != null && !fromDate.isEmpty())
                                q.bind("fromDate", fromDate);
                        if (toDate != null && !toDate.isEmpty())
                                q.bind("toDate", toDate);
                        q.bind("size", size).bind("offset", offset);
                        return q.map(new OrderMapper()).list();
                });
        }

        public int countByUserIdAndStatus(int userId, String status) {
                String sql;
                if ("processing".equals(status)) {
                        sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND status IN ('confirmed', 'processing')";
                } else if ("cancelled".equals(status)) {
                        sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND status IN ('cancelled', 'cancelled_by_admin', 'payment_expired')";
                } else {
                        sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND status = :status";
                }
                return get().withHandle(handle -> {
                        org.jdbi.v3.core.statement.Query q = handle.createQuery(sql)
                                        .bind("userId", userId);
                        if (!"processing".equals(status) && !"cancelled".equals(status)) {
                                q.bind("status", status);
                        }
                        return q.mapTo(Integer.class).one();
                });
        }

        public List<Order> findByUserIdPaginated(int userId, int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("userId", userId)
                                .bind("size", size)
                                .bind("offset", offset)
                                .map(new OrderMapper())
                                .list());
        }

        public List<Order> findByUserIdAndStatusPaginated(int userId, String status, int page, int size) {
                int offset = (page - 1) * size;
                String sql;
                if ("processing".equals(status)) {
                        sql = "SELECT * FROM orders WHERE user_id = :userId AND status IN ('confirmed', 'processing') ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                } else if ("cancelled".equals(status)) {
                        sql = "SELECT * FROM orders WHERE user_id = :userId AND status IN ('cancelled', 'cancelled_by_admin', 'payment_expired') ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                } else {
                        sql = "SELECT * FROM orders WHERE user_id = :userId AND status = :status ORDER BY order_date DESC LIMIT :size OFFSET :offset";
                }
                return get().withHandle(handle -> {
                        org.jdbi.v3.core.statement.Query q = handle.createQuery(sql)
                                        .bind("userId", userId)
                                        .bind("size", size)
                                        .bind("offset", offset);
                        if (!"processing".equals(status) && !"cancelled".equals(status)) {
                                q.bind("status", status);
                        }
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
                        String cleanKeyword = keyword.trim().toUpperCase()
                                        .replace("#", "")
                                        .replace("DH-0", "")
                                        .replace("DH-", "")
                                        .replace("ORD", "");

                        sql.append("AND (CAST(o.id AS CHAR) LIKE :kw ");
                        if (cleanKeyword.matches("\\d+")) {
                                sql.append("OR o.id = :idVal ");
                        }
                        sql.append("OR a.receiver LIKE :kw " +
                                        "OR a.phone LIKE :kw) ");
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
                        if (keyword != null && !keyword.isEmpty()) {
                                q.bind("kw", "%" + keyword + "%");
                                String cleanKeyword = keyword.trim().toUpperCase()
                                                .replace("#", "")
                                                .replace("DH-0", "")
                                                .replace("DH-", "")
                                                .replace("ORD", "");
                                if (cleanKeyword.matches("\\d+")) {
                                        q.bind("idVal", Integer.parseInt(cleanKeyword));
                                }
                        }
                        if (fromDate != null && !fromDate.isEmpty())
                                q.bind("fromDate", fromDate);
                        if (toDate != null && !toDate.isEmpty())
                                q.bind("toDate", toDate);
                        return q.mapTo(Integer.class).one();
                });
        }

        public static class RevenueRecord {
                private String label;
                private double revenue;

                public RevenueRecord() {}

                public RevenueRecord(String label, double revenue) {
                        this.label = label;
                        this.revenue = revenue;
                }

                public String getLabel() { return label; }
                public void setLabel(String label) { this.label = label; }
                public double getRevenue() { return revenue; }
                public void setRevenue(double revenue) { this.revenue = revenue; }
        }

        public List<RevenueRecord> getWeeklyRevenue() {
                String sql = "SELECT DATE_FORMAT(order_date, '%Y-%m-%d') as order_date, COALESCE(SUM(total_price), 0) as revenue " +
                                "FROM orders " +
                                "WHERE status = 'completed' " +
                                "AND order_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                                "GROUP BY DATE_FORMAT(order_date, '%Y-%m-%d') " +
                                "ORDER BY DATE_FORMAT(order_date, '%Y-%m-%d') ASC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map((rs, ctx) -> new RevenueRecord(
                                                rs.getString("order_date"),
                                                rs.getDouble("revenue")
                                ))
                                .list());
        }

        public List<RevenueRecord> getMonthlyRevenue() {
                String sql = "SELECT DATE_FORMAT(order_date, '%Y-%m') as order_month, COALESCE(SUM(total_price), 0) as revenue " +
                                "FROM orders " +
                                "WHERE status = 'completed' " +
                                "AND order_date >= DATE_SUB(DATE_FORMAT(NOW(), '%Y-%m-01'), INTERVAL 5 MONTH) " +
                                "GROUP BY DATE_FORMAT(order_date, '%Y-%m') " +
                                "ORDER BY DATE_FORMAT(order_date, '%Y-%m') ASC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map((rs, ctx) -> new RevenueRecord(
                                                rs.getString("order_month"),
                                                rs.getDouble("revenue")
                                ))
                                .list());
        }
}
