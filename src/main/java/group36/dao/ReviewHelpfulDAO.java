package group36.dao;

import java.util.List;

import org.jdbi.v3.core.Jdbi;

public class ReviewHelpfulDAO extends BaseDao {

    public Jdbi jdbi() {
        return get();
    }

    public boolean existsByReviewAndUser(int reviewId, int userId) {
        String sql = "SELECT COUNT(*) FROM review_helpful WHERE review_id = :reviewId AND user_id = :userId";
        int count = get().withHandle(handle -> handle.createQuery(sql)
                .bind("reviewId", reviewId)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one());
        return count > 0;
    }

    public int insert(int reviewId, int userId) {
        String sql = "INSERT IGNORE INTO review_helpful (review_id, user_id) VALUES (:reviewId, :userId)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("reviewId", reviewId)
                .bind("userId", userId)
                .execute());
    }

    public int delete(int reviewId, int userId) {
        String sql = "DELETE FROM review_helpful WHERE review_id = :reviewId AND user_id = :userId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("reviewId", reviewId)
                .bind("userId", userId)
                .execute());
    }

    public int countByReviewId(int reviewId) {
        String sql = "SELECT COUNT(*) FROM review_helpful WHERE review_id = :reviewId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("reviewId", reviewId)
                .mapTo(Integer.class)
                .one());
    }

    public List<Integer> findReviewIdsByUser(int userId, List<Integer> reviewIds) {
        if (reviewIds == null || reviewIds.isEmpty()) return List.of();
        String placeholders = reviewIds.stream().map(id -> "?").collect(java.util.stream.Collectors.joining(", "));
        String sql = "SELECT review_id FROM review_helpful WHERE user_id = ? AND review_id IN (" + placeholders + ")";
        return get().withHandle(handle -> {
            var query = handle.createQuery(sql).bind(0, userId);
            for (int i = 0; i < reviewIds.size(); i++) {
                query.bind(i + 1, reviewIds.get(i));
            }
            return query.mapTo(Integer.class).list();
        });
    }
}
