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
                        review.setStatus(rs.getString("status"));
                        review.setReportCount(rs.getInt("report_count"));
                        return review;
                }
        }

        public List<Review> findByProductId(int productId) {
                String sql = "SELECT * FROM review WHERE product_id = :productId AND status = 'approved' ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new ReviewMapper())
                                .list());
        }

        public List<Review> findByProductIdPaginated(int productId, int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM review WHERE product_id = :productId AND status = 'approved' " +
                                "ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .bind("limit", size)
                                .bind("offset", offset)
                                .map(new ReviewMapper())
                                .list());
        }

        public List<Review> findByProductIdAndRating(int productId, int rating) {
                String sql = "SELECT * FROM review WHERE product_id = :productId AND rating = :rating AND status = 'approved' " +
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
                                "WHERE r.product_id = :productId AND r.status = 'approved' " +
                                "AND (r.image_url IS NOT NULL OR ri.id IS NOT NULL) " +
                                "ORDER BY r.created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new ReviewMapper())
                                .list());
        }

        public List<Review> findVerifiedByProductId(int productId) {
                String sql = "SELECT * FROM review WHERE product_id = :productId AND order_id IS NOT NULL AND status = 'approved' " +
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
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId AND status = 'approved'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countByProductIdAndRating(int productId, int rating) {
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId AND rating = :rating AND status = 'approved'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .bind("rating", rating)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countWithImagesByProductId(int productId) {
                String sql = "SELECT COUNT(DISTINCT r.id) FROM review r " +
                                "LEFT JOIN review_images ri ON r.id = ri.review_id " +
                                "WHERE r.product_id = :productId AND r.status = 'approved' " +
                                "AND (r.image_url IS NOT NULL OR ri.id IS NOT NULL)";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        public int countVerifiedByProductId(int productId) {
                String sql = "SELECT COUNT(*) FROM review WHERE product_id = :productId AND order_id IS NOT NULL AND status = 'approved'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
        }

        public double getAverageRating(int productId) {
                String sql = "SELECT COALESCE(AVG(rating), 0) FROM review WHERE product_id = :productId AND status = 'approved'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .mapTo(Double.class)
                                .one());
        }

        public int insert(Review review) {
                String sql = "INSERT INTO review (user_id, product_id, order_id, variant_id, rating, review_text, image_url, status) "
                                +
                                "VALUES (:userId, :productId, :orderId, :variantId, :rating, :reviewText, :imageUrl, 'pending')";
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

        public boolean existsByUserAndOrderAndProduct(int userId, int orderId, int productId) {
                String sql = "SELECT COUNT(*) FROM review WHERE user_id = :userId AND order_id = :orderId AND product_id = :productId";
                int count = get().withHandle(handle -> handle.createQuery(sql)
                                .bind("userId", userId)
                                .bind("orderId", orderId)
                                .bind("productId", productId)
                                .mapTo(Integer.class)
                                .one());
                return count > 0;
        }

        public List<Review> findByOrderIdAndUserId(int orderId, int userId) {
                String sql = "SELECT * FROM review WHERE order_id = :orderId AND user_id = :userId ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("orderId", orderId)
                                .bind("userId", userId)
                                .map(new ReviewMapper())
                                .list());
        }

        public List<Review> findAllForAdmin(String statusFilter, Integer productId, Integer rating,
                                        String search, int page, int size) {
                int offset = (page - 1) * size;
                StringBuilder sql = new StringBuilder("SELECT r.* FROM review r WHERE 1=1 ");
                
                if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                        sql.append("AND r.status = :status ");
                }
                if (productId != null && productId > 0) {
                        sql.append("AND r.product_id = :productId ");
                }
                if (rating != null && rating > 0) {
                        sql.append("AND r.rating = :rating ");
                }
                if (search != null && !search.isEmpty()) {
                        sql.append("AND r.review_text LIKE :search ");
                }
                
                sql.append("ORDER BY r.created_at DESC LIMIT :limit OFFSET :offset");
                
                return get().withHandle(handle -> {
                        var query = handle.createQuery(sql.toString());
                        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                                query.bind("status", statusFilter);
                        }
                        if (productId != null && productId > 0) {
                                query.bind("productId", productId);
                        }
                        if (rating != null && rating > 0) {
                                query.bind("rating", rating);
                        }
                        if (search != null && !search.isEmpty()) {
                                query.bind("search", "%" + search + "%");
                        }
                        query.bind("limit", size);
                        query.bind("offset", offset);
                        return query.map(new ReviewMapper()).list();
                });
        }

        public int countAllForAdmin(String statusFilter, Integer productId, Integer rating, String search) {
                StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM review r WHERE 1=1 ");
                
                if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                        sql.append("AND r.status = :status ");
                }
                if (productId != null && productId > 0) {
                        sql.append("AND r.product_id = :productId ");
                }
                if (rating != null && rating > 0) {
                        sql.append("AND r.rating = :rating ");
                }
                if (search != null && !search.isEmpty()) {
                        sql.append("AND r.review_text LIKE :search ");
                }
                
                return get().withHandle(handle -> {
                        var query = handle.createQuery(sql.toString());
                        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                                query.bind("status", statusFilter);
                        }
                        if (productId != null && productId > 0) {
                                query.bind("productId", productId);
                        }
                        if (rating != null && rating > 0) {
                                query.bind("rating", rating);
                        }
                        if (search != null && !search.isEmpty()) {
                                query.bind("search", "%" + search + "%");
                        }
                        return query.mapTo(Integer.class).one();
                });
        }

        public int countByStatus(String status) {
                String sql = "SELECT COUNT(*) FROM review WHERE status = :status";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("status", status)
                                .mapTo(Integer.class)
                                .one());
        }

        public int updateStatus(int reviewId, String status) {
                String sql = "UPDATE review SET status = :status WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", reviewId)
                                .bind("status", status)
                                .execute());
        }

        public int incrementReportCount(int reviewId) {
                String sql = "UPDATE review SET report_count = report_count + 1 WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", reviewId)
                                .execute());
        }

        public List<Review> findReported(int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM review WHERE report_count > 0 ORDER BY report_count DESC, created_at DESC LIMIT :limit OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("limit", size)
                                .bind("offset", offset)
                                .map(new ReviewMapper())
                                .list());
        }
}
