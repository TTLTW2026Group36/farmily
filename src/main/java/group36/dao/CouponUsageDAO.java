package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.CouponUsage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CouponUsageDAO extends BaseDao {

    private static class CouponUsageMapper implements RowMapper<CouponUsage> {
        @Override
        public CouponUsage map(ResultSet rs, StatementContext ctx) throws SQLException {
            CouponUsage cu = new CouponUsage();
            cu.setId(rs.getInt("id"));
            cu.setCouponId(rs.getInt("coupon_id"));
            int userId = rs.getInt("user_id");
            cu.setUserId(rs.wasNull() ? null : userId);
            cu.setOrderId(rs.getInt("order_id"));
            cu.setDiscountAmount(rs.getDouble("discount_amount"));
            cu.setUsedAt(rs.getTimestamp("used_at"));
            
            try {
                cu.setUserName(rs.getString("user_name"));
            } catch (SQLException e) {
                // Ignore if not present in select statement
            }
            try {
                cu.setUserEmail(rs.getString("user_email"));
            } catch (SQLException e) {
                // Ignore if not present in select statement
            }
            return cu;
        }
    }

    public List<CouponUsage> findByCouponId(int couponId) {
        String sql = "SELECT cu.*, " +
                     "COALESCE(u.name, o.guest_name) as user_name, " +
                     "COALESCE(u.email, o.guest_email) as user_email " +
                     "FROM coupon_usage cu " +
                     "LEFT JOIN users u ON cu.user_id = u.id " +
                     "LEFT JOIN orders o ON cu.order_id = o.id " +
                     "WHERE cu.coupon_id = :couponId " +
                     "ORDER BY cu.used_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("couponId", couponId)
                .map(new CouponUsageMapper())
                .list());
    }
    
    public double getTotalDiscountByCouponId(int couponId) {
        String sql = "SELECT COALESCE(SUM(discount_amount), 0) FROM coupon_usage WHERE coupon_id = :couponId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("couponId", couponId)
                .mapTo(Double.class)
                .one());
    }
}
