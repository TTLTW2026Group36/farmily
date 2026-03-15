package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.CartItem;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class CartItemDAO extends BaseDao {

    


    private static class CartItemMapper implements RowMapper<CartItem> {
        @Override
        public CartItem map(ResultSet rs, StatementContext ctx) throws SQLException {
            CartItem item = new CartItem();
            item.setId(rs.getInt("id"));
            item.setCartId(rs.getInt("cart_id"));
            item.setProductId(rs.getInt("product_id"));

            int variantId = rs.getInt("variant_id");
            item.setVariantId(rs.wasNull() ? null : variantId);

            item.setQuantity(rs.getInt("quantity"));
            return item;
        }
    }

    





    public List<CartItem> findByCartId(int cartId) {
        String sql = "SELECT * FROM cart_items WHERE cart_id = :cartId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("cartId", cartId)
                .map(new CartItemMapper())
                .list());
    }

    





    public Optional<CartItem> findById(int id) {
        String sql = "SELECT * FROM cart_items WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new CartItemMapper())
                .findOne());
    }

    








    public Optional<CartItem> findByCartAndProduct(int cartId, int productId, Integer variantId) {
        String sql;
        if (variantId != null) {
            sql = "SELECT * FROM cart_items WHERE cart_id = :cartId AND product_id = :productId AND variant_id = :variantId";
            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .bind("variantId", variantId)
                    .map(new CartItemMapper())
                    .findOne());
        } else {
            sql = "SELECT * FROM cart_items WHERE cart_id = :cartId AND product_id = :productId AND variant_id IS NULL";
            return get().withHandle(handle -> handle.createQuery(sql)
                    .bind("cartId", cartId)
                    .bind("productId", productId)
                    .map(new CartItemMapper())
                    .findOne());
        }
    }

    





    public int insert(CartItem item) {
        String sql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) " +
                "VALUES (:cartId, :productId, :variantId, :quantity)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("cartId", item.getCartId())
                .bind("productId", item.getProductId())
                .bind("variantId", item.getVariantId())
                .bind("quantity", item.getQuantity())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    






    public int updateQuantity(int id, int quantity) {
        String sql = "UPDATE cart_items SET quantity = :quantity WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("quantity", quantity)
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM cart_items WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByCartId(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = :cartId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("cartId", cartId)
                .execute());
    }

    





    public int countByCartId(int cartId) {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE cart_id = :cartId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("cartId", cartId)
                .mapTo(Integer.class)
                .one());
    }

    






    public int updateVariant(int id, int variantId) {
        String sql = "UPDATE cart_items SET variant_id = :variantId WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("variantId", variantId)
                .execute());
    }
}
