package group36.dao;

import group36.model.Coupon;
import group36.dao.CouponDAO.CouponMapper;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SavedCouponDAO extends BaseDao {

    public void save(int userId, int couponId) {
        String sql = "INSERT IGNORE INTO saved_coupons (user_id, coupon_id) VALUES (:userId, :couponId)";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .bind("couponId", couponId)
                .execute());
    }

    public Set<Integer> getSavedCouponIds(int userId) {
        String sql = "SELECT coupon_id FROM saved_coupons WHERE user_id = :userId";
        List<Integer> ids = get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .list());
        return new HashSet<>(ids);
    }

    public List<Coupon> getSavedCoupons(int userId) {
        String sql = "SELECT c.* FROM coupons c " +
                     "INNER JOIN saved_coupons sc ON c.id = sc.coupon_id " +
                     "WHERE sc.user_id = :userId " +
                     "ORDER BY sc.saved_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new CouponMapper())
                .list());
    }

    public boolean isSaved(int userId, int couponId) {
        String sql = "SELECT COUNT(*) FROM saved_coupons WHERE user_id = :userId AND coupon_id = :couponId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("couponId", couponId)
                .mapTo(Integer.class)
                .one()) > 0;
    }
}
