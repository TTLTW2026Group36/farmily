package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Review;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class ReviewDAO extends BaseDao {

        


        private static class ReviewMapper implements RowMapper<Review> {
                @Override
                public Review map(ResultSet rs, StatementContext ctx) throws SQLException {
                        Review review = new Review();
                        review.setId(rs.getInt("id"));
                        review.setUserId(rs.getInt("user_id"));
                        review.setProductId(rs.getInt("product_id"));

                        int orderId = rs.getInt("order_id");
                        review.setOrderId(rs.wasNull() ? null : orderId);

                        int variantId = rs.getInt("variant_id");
                        review.setVariantId(rs.wasNull() ? null : variantId);

                        review.setRating(rs.getInt("rating"));
                        review.setReviewText(rs.getString("review_text"));
                        review.setImageUrl(rs.getString("image_url"));
                        review.setCreatedAt(rs.getTimestamp("created_at"));
                        return review;
                }
        }

        





        public List<Review> findByProductId(int productId) {
                String sql = "SELECT * FROM review WHERE product_id = :productId ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new ReviewMapper())
                                .list());
        }

        







        public List<Review> findByProductIdPaginated(int productId, int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM review WHERE product_id = :productId " +
                                "ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .bind("limit", size)
                                .bind("offset", offset)
                                .map(new ReviewMapper())
                                .list());
        }

        






        public List<Review> findByProductIdAndRating(int productId, int rating) {
                String sql = "SELECT * FROM review WHERE product_id = :productId AND rating = :rating " +
                                "ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .bind("rating", rating)
                                .map(new ReviewMapper())
                                .list());
        }

        





        public List<Review> findByProductIdWithImages(int productId) {
                String sql = "SELECT DISTINCT r.* FROM review r " +
                                "LEFT JOIN review_images ri ON r.id = ri.review_id " +
                                "WHERE r.product_id = :productId " +
                                "AND (r.image_url IS NOT NULL OR ri.id IS NOT NULL) " +
                                "ORDER BY r.created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new ReviewMapper())
                                .list());
        }

        





        public List<Review> findVerifiedByProductId(int productId) {
                String sql = "SELECT * FROM review WHERE product_id = :productId AND order_id IS NOT NULL " +
                                "ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new ReviewMapper())
                                .list());
        }

        





        public Optional<Review> findById(int id) {
                String sql = "SELECT * FROM review WHERE id = :id";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("id", id)
                                .map(new ReviewMapper())
                                .findOne());
        }

        





        public int countByProductId(int productId) {
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        






        public int countByProductIdAndRating(int productId, int rating) {
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId AND rating = :rating";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .bind("rating", rating)
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int countWithImagesByProductId(int productId) {
                String sql = "SELECT COUNT(DISTINCT r.id) FROM review r " +
                                "LEFT JOIN review_images ri ON r.id = ri.review_id " +
                                "WHERE r.product_id = :productId " +
                                "AND (r.image_url IS NOT NULL OR ri.id IS NOT NULL)";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int countVerifiedByProductId(int productId) {
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId AND order_id IS NOT NULL";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        





        public double getAverageRating(int productId) {
                String sql = "SELECT COALESCE(AVG(rating), 0) FROM review WHERE product_id = :productId";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Double.class)
                                .one());
        }

        





        public int insert(Review review) {
                String sql = "INSERT INTO review (user_id, product_id, order_id, variant_id, rating, review_text, image_url) "
                                +
                                "VALUES (:userId, :productId, :orderId, :variantId, :rating, :reviewText, :imageUrl)";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("userId", review.getUserId())
                                .bind("productId", review.getProductId())
                                .bind("orderId", review.getOrderId())
                                .bind("variantId", review.getVariantId())
                                .bind("rating", review.getRating())
                                .bind("reviewText", review.getReviewText())
                                .bind("imageUrl", review.getImageUrl())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int delete(int id) {
                String sql = "DELETE FROM review WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", id)
                                .execute());
        }

        






        public boolean existsByUserAndProduct(int userId, int productId) {
                String sql = "SELECT COUNT(*) FROM review WHERE user_id = :userId AND product_id = :productId";
                int count = get().withHandle(handle -> handle.createQuery(sql)
                                .bind("userId", userId)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
                return count > 0;
        }
}
