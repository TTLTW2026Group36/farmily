package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Cart;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;





public class CartDAO extends BaseDao {

    


    private static class CartMapper implements RowMapper<Cart> {
        @Override
        public Cart map(ResultSet rs, StatementContext ctx) throws SQLException {
            Cart cart = new Cart();
            cart.setId(rs.getInt("id"));
            cart.setUserId(rs.getInt("user_id"));
            cart.setCreatedAt(rs.getTimestamp("created_at"));
            return cart;
        }
    }

    





    public Optional<Cart> findById(int id) {
        String sql = "SELECT * FROM cart WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new CartMapper())
                .findOne());
    }

    





    public Optional<Cart> findByUserId(int userId) {
        String sql = "SELECT * FROM cart WHERE user_id = :userId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new CartMapper())
                .findOne());
    }

    





    public int insert(Cart cart) {
        String sql = "INSERT INTO cart (user_id) VALUES (:userId)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", cart.getUserId())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    






    public int delete(int id) {
        String sql = "DELETE FROM cart WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByUserId(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = :userId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .execute());
    }
}
