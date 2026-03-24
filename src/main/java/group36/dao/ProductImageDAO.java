package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.ProductImage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class ProductImageDAO extends BaseDao {

    


    private static class ProductImageMapper implements RowMapper<ProductImage> {
        @Override
        public ProductImage map(ResultSet rs, StatementContext ctx) throws SQLException {
            ProductImage image = new ProductImage();
            image.setId(rs.getInt("id"));
            image.setProductId(rs.getInt("product_id"));
            image.setImageUrl(rs.getString("image_url"));
            image.setCreatedAt(rs.getTimestamp("created_at"));
            return image;
        }
    }

    





    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map(new ProductImageMapper())
                .list());
    }

    





    public Optional<ProductImage> findById(int id) {
        String sql = "SELECT * FROM product_images WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new ProductImageMapper())
                .findOne());
    }

    





    public Optional<ProductImage> findPrimaryByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId ORDER BY id ASC LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map(new ProductImageMapper())
                .findOne());
    }

    





    public int insert(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_url) VALUES (:productId, :imageUrl)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", image.getProductId())
                .bind("imageUrl", image.getImageUrl())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    






    public int updateUrl(int id, String imageUrl) {
        String sql = "UPDATE product_images SET image_url = :imageUrl WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("imageUrl", imageUrl)
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM product_images WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = :productId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
    }

    





    public int countByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM product_images WHERE product_id = :productId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .one());
    }
}
