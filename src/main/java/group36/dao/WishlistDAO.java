package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Wishlist;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class WishlistDAO extends BaseDao {
    private static class WishlistMapper implements RowMapper<Wishlist> {
        @Override
        public Wishlist map(ResultSet rs, StatementContext ctx) throws SQLException {
            Wishlist wishlist = new Wishlist();
            wishlist.setId(rs.getInt("id"));
            wishlist.setUserId(rs.getInt("user_id"));
            wishlist.setProductId(rs.getInt("product_id"));
            wishlist.setCreatedAt(rs.getTimestamp("created_at"));
            return wishlist;
        }
    }

    public List<Wishlist> findByUserId(int userId) {
        String sql = "SELECT * FROM wishlists WHERE user_id = :userId ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new WishlistMapper())
                .list());
    }

    public Optional<Wishlist> findByUserIdAndProductId(int userId, int productId) {
        String sql = "SELECT * FROM wishlists WHERE user_id = :userId AND product_id = :productId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .map(new WishlistMapper())
                .findOne());
    }

    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = :userId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one());
    }

    public boolean exists(int userId, int productId) {
        String sql = "SELECT COUNT(*) > 0 FROM wishlists WHERE user_id = :userId AND product_id = :productId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .mapTo(Boolean.class)
                .one());
    }

    public int insert(Wishlist wishlist) {
        String sql = "INSERT INTO wishlists (user_id, product_id) VALUES (:userId, :productId)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", wishlist.getUserId())
                .bind("productId", wishlist.getProductId())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public int delete(int id) {
        String sql = "DELETE FROM wishlists WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public int deleteByUserIdAndProductId(int userId, int productId) {
        String sql = "DELETE FROM wishlists WHERE user_id = :userId AND product_id = :productId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .execute());
    }

    public int deleteAllByUserId(int userId) {
        String sql = "DELETE FROM wishlists WHERE user_id = :userId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .execute());
    }
}
