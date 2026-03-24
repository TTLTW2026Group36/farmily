package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.ProductVariant;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class ProductVariantDAO extends BaseDao {

    


    private static class ProductVariantMapper implements RowMapper<ProductVariant> {
        @Override
        public ProductVariant map(ResultSet rs, StatementContext ctx) throws SQLException {
            ProductVariant variant = new ProductVariant();
            variant.setId(rs.getInt("id"));
            variant.setProductId(rs.getInt("product_id"));
            variant.setOptionsValue(rs.getString("options_value"));
            variant.setStock(rs.getInt("stock"));
            variant.setPrice(rs.getDouble("price"));
            variant.setCreatedAt(rs.getTimestamp("created_at"));
            return variant;
        }
    }

    





    public List<ProductVariant> findByProductId(int productId) {
        String sql = "SELECT * FROM product_variants WHERE product_id = :productId ORDER BY price ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map(new ProductVariantMapper())
                .list());
    }

    





    public Optional<ProductVariant> findById(int id) {
        String sql = "SELECT * FROM product_variants WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new ProductVariantMapper())
                .findOne());
    }

    





    public int insert(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, options_value, stock, price) " +
                "VALUES (:productId, :optionsValue, :stock, :price)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", variant.getProductId())
                .bind("optionsValue", variant.getOptionsValue())
                .bind("stock", variant.getStock())
                .bind("price", variant.getPrice())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(ProductVariant variant) {
        String sql = "UPDATE product_variants SET options_value = :optionsValue, " +
                "stock = :stock, price = :price WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", variant.getId())
                .bind("optionsValue", variant.getOptionsValue())
                .bind("stock", variant.getStock())
                .bind("price", variant.getPrice())
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM product_variants WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByProductId(int productId) {
        String sql = "DELETE FROM product_variants WHERE product_id = :productId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
    }

    






    public int updateStock(int id, int newStock) {
        String sql = "UPDATE product_variants SET stock = :stock WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("stock", newStock)
                .execute());
    }

    






    public int decreaseStock(int id, int quantity) {
        String sql = "UPDATE product_variants SET stock = stock - :quantity WHERE id = :id AND stock >= :quantity";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("quantity", quantity)
                .execute());
    }

    





    public int getTotalStock(int productId) {
        String sql = "SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = :productId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .one());
    }

    





    public double getMinPrice(int productId) {
        String sql = "SELECT COALESCE(MIN(price), 0) FROM product_variants WHERE product_id = :productId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .mapTo(Double.class)
                .one());
    }
}
