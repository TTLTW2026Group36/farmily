package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Coupon;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class CouponDAO extends BaseDao {

    public static class CouponMapper implements RowMapper<Coupon> {
        @Override
        public Coupon map(ResultSet rs, StatementContext ctx) throws SQLException {
            Coupon c = new Coupon();
            c.setId(rs.getInt("id"));
            c.setCode(rs.getString("code"));
            c.setDiscountType(rs.getString("discount_type"));
            c.setDiscountValue(rs.getDouble("discount_value"));
            double maxDisc = rs.getDouble("max_discount");
            c.setMaxDiscount(rs.wasNull() ? null : maxDisc);
            c.setMinOrderValue(rs.getDouble("min_order_value"));
            c.setQuantity(rs.getInt("quantity"));
            c.setUsedCount(rs.getInt("used_count"));
            c.setMaxUsagePerUser(rs.getInt("max_usage_per_user"));
            c.setStartDate(rs.getTimestamp("start_date"));
            c.setEndDate(rs.getTimestamp("end_date"));
            c.setActive(rs.getBoolean("is_active"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            c.setUpdatedAt(rs.getTimestamp("updated_at"));
            return c;
        }
    }

    public List<Coupon> findAll() {
        String sql = "SELECT * FROM coupons ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new CouponMapper())
                .list());
    }

    public Optional<Coupon> findById(int id) {
        String sql = "SELECT * FROM coupons WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new CouponMapper())
                .findOne());
    }

    public Optional<Coupon> findByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = :code";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("code", code)
                .map(new CouponMapper())
                .findOne());
    }

    public int insert(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, max_discount, " +
                "min_order_value, quantity, used_count, max_usage_per_user, start_date, end_date, is_active) " +
                "VALUES (:code, :discountType, :discountValue, :maxDiscount, :minOrderValue, " +
                ":quantity, :usedCount, :maxUsagePerUser, :startDate, :endDate, :isActive)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("code", coupon.getCode())
                .bind("discountType", coupon.getDiscountType())
                .bind("discountValue", coupon.getDiscountValue())
                .bind("maxDiscount", coupon.getMaxDiscount())
                .bind("minOrderValue", coupon.getMinOrderValue())
                .bind("quantity", coupon.getQuantity())
                .bind("usedCount", coupon.getUsedCount())
                .bind("maxUsagePerUser", coupon.getMaxUsagePerUser())
                .bind("startDate", coupon.getStartDate())
                .bind("endDate", coupon.getEndDate())
                .bind("isActive", coupon.isActive())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public int update(Coupon coupon) {
        String sql = "UPDATE coupons SET code = :code, discount_type = :discountType, " +
                "discount_value = :discountValue, max_discount = :maxDiscount, min_order_value = :minOrderValue, " +
                "quantity = :quantity, used_count = :usedCount, max_usage_per_user = :maxUsagePerUser, " +
                "start_date = :startDate, end_date = :endDate, is_active = :isActive " +
                "WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", coupon.getId())
                .bind("code", coupon.getCode())
                .bind("discountType", coupon.getDiscountType())
                .bind("discountValue", coupon.getDiscountValue())
                .bind("maxDiscount", coupon.getMaxDiscount())
                .bind("minOrderValue", coupon.getMinOrderValue())
                .bind("quantity", coupon.getQuantity())
                .bind("usedCount", coupon.getUsedCount())
                .bind("maxUsagePerUser", coupon.getMaxUsagePerUser())
                .bind("startDate", coupon.getStartDate())
                .bind("endDate", coupon.getEndDate())
                .bind("isActive", coupon.isActive())
                .execute());
    }

    public int delete(int id) {
        String sql = "DELETE FROM coupons WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public int updateActiveStatus(int id, boolean isActive) {
        String sql = "UPDATE coupons SET is_active = :isActive WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("isActive", isActive)
                .execute());
    }

    public List<Coupon> findByFilters(String keyword, String status) {
        StringBuilder sql = new StringBuilder("SELECT * FROM coupons WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND code LIKE :keyword");
        }
        if (status != null && !status.isEmpty()) {
            switch (status) {
                case "active":
                    sql.append(" AND is_active = 1 AND NOW() BETWEEN start_date AND end_date AND used_count < quantity");
                    break;
                case "upcoming":
                    sql.append(" AND is_active = 1 AND start_date > NOW()");
                    break;
                case "expired":
                    sql.append(" AND end_date < NOW()");
                    break;
                case "disabled":
                    sql.append(" AND is_active = 0");
                    break;
            }
        }
        sql.append(" ORDER BY created_at DESC");
        return get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            return query.map(new CouponMapper()).list();
        });
    }

    public int countUsageByUserAndCoupon(int userId, int couponId) {
        String sql = "SELECT COUNT(*) FROM coupon_usage WHERE user_id = :userId AND coupon_id = :couponId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("couponId", couponId)
                .mapTo(Integer.class)
                .one());
    }

    public int incrementUsedCount(int couponId) {
        String sql = "UPDATE coupons SET used_count = used_count + 1 " +
                     "WHERE id = :id AND used_count < quantity";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", couponId)
                .execute());
    }

    public int countUsageByCouponId(int couponId) {
        String sql = "SELECT COUNT(*) FROM coupon_usage WHERE coupon_id = :couponId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("couponId", couponId)
                .mapTo(Integer.class)
                .one());
    }

    public void insertUsage(int couponId, Integer userId, int orderId, double discountAmount) {
        String sql = "INSERT INTO coupon_usage (coupon_id, user_id, order_id, discount_amount) " +
                     "VALUES (:couponId, :userId, :orderId, :discountAmount)";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("couponId", couponId)
                .bind("userId", userId)
                .bind("orderId", orderId)
                .bind("discountAmount", discountAmount)
                .execute());
    }

    public List<Coupon> findActiveCoupons() {
        String sql = "SELECT * FROM coupons WHERE is_active = 1 " +
                     "AND NOW() BETWEEN start_date AND end_date " +
                     "AND used_count < quantity " +
                     "ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new CouponMapper())
                .list());
    }

    public List<Coupon> findActiveCouponsByType(String discountType) {
        String sql = "SELECT * FROM coupons WHERE is_active = 1 " +
                     "AND discount_type = :type " +
                     "AND NOW() BETWEEN start_date AND end_date " +
                     "AND used_count < quantity ORDER BY discount_value DESC";
        return get().withHandle(h -> h.createQuery(sql)
                .bind("type", discountType).map(new CouponMapper()).list());
    }
}

