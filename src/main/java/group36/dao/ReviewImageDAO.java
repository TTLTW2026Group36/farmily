package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.ReviewImage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;





public class ReviewImageDAO extends BaseDao {

    


    private static class ReviewImageMapper implements RowMapper<ReviewImage> {
        @Override
        public ReviewImage map(ResultSet rs, StatementContext ctx) throws SQLException {
            ReviewImage image = new ReviewImage();
            image.setId(rs.getInt("id"));
            image.setReviewId(rs.getInt("review_id"));
            image.setImageUrl(rs.getString("image_url"));
            image.setCreatedAt(rs.getTimestamp("created_at"));
            return image;
        }
    }

    





    public List<ReviewImage> findByReviewId(int reviewId) {
        String sql = "SELECT * FROM review_images WHERE review_id = :reviewId ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("reviewId", reviewId)
                .map(new ReviewImageMapper())
                .list());
    }

    





    public List<ReviewImage> findByReviewIds(List<Integer> reviewIds) {
        if (reviewIds == null || reviewIds.isEmpty()) {
            return Collections.emptyList();
        }

        String placeholders = reviewIds.stream()
                .map(id -> "?")
                .collect(Collectors.joining(", "));

        String sql = "SELECT * FROM review_images WHERE review_id IN (" + placeholders + ") ORDER BY review_id, id ASC";

        return get().withHandle(handle -> {
            var query = handle.createQuery(sql);
            for (int i = 0; i < reviewIds.size(); i++) {
                query.bind(i, reviewIds.get(i));
            }
            return query.map(new ReviewImageMapper()).list();
        });
    }

    





    public int insert(ReviewImage image) {
        String sql = "INSERT INTO review_images (review_id, image_url) VALUES (:reviewId, :imageUrl)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("reviewId", image.getReviewId())
                .bind("imageUrl", image.getImageUrl())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM review_images WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByReviewId(int reviewId) {
        String sql = "DELETE FROM review_images WHERE review_id = :reviewId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("reviewId", reviewId)
                .execute());
    }

    





    public int countByReviewId(int reviewId) {
        String sql = "SELECT COUNT(*) FROM review_images WHERE review_id = :reviewId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("reviewId", reviewId)
                .mapTo(Integer.class)
                .one());
    }
}
