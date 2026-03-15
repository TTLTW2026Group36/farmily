package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.NewsImage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class NewsImageDAO extends BaseDao {

    


    private static class NewsImageMapper implements RowMapper<NewsImage> {
        @Override
        public NewsImage map(ResultSet rs, StatementContext ctx) throws SQLException {
            NewsImage image = new NewsImage();
            image.setId(rs.getInt("id"));
            image.setNewsId(rs.getInt("news_id"));
            image.setImageUrl(rs.getString("image_url"));
            image.setCaption(rs.getString("caption"));
            image.setPosition(rs.getInt("position"));
            image.setCreatedAt(rs.getTimestamp("created_at"));
            return image;
        }
    }

    





    public List<NewsImage> findByNewsId(int newsId) {
        String sql = "SELECT * FROM news_images WHERE news_id = :newsId ORDER BY position ASC, id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("newsId", newsId)
                .map(new NewsImageMapper())
                .list());
    }

    





    public Optional<NewsImage> findById(int id) {
        String sql = "SELECT * FROM news_images WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new NewsImageMapper())
                .findOne());
    }

    





    public Optional<NewsImage> findPrimaryByNewsId(int newsId) {
        String sql = "SELECT * FROM news_images WHERE news_id = :newsId ORDER BY position ASC, id ASC LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("newsId", newsId)
                .map(new NewsImageMapper())
                .findOne());
    }

    





    public int insert(NewsImage image) {
        String sql = "INSERT INTO news_images (news_id, image_url, caption, position) " +
                "VALUES (:newsId, :imageUrl, :caption, :position)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("newsId", image.getNewsId())
                .bind("imageUrl", image.getImageUrl())
                .bind("caption", image.getCaption())
                .bind("position", image.getPosition())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(NewsImage image) {
        String sql = "UPDATE news_images SET image_url = :imageUrl, caption = :caption, " +
                "position = :position WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", image.getId())
                .bind("imageUrl", image.getImageUrl())
                .bind("caption", image.getCaption())
                .bind("position", image.getPosition())
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM news_images WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public int deleteByNewsId(int newsId) {
        String sql = "DELETE FROM news_images WHERE news_id = :newsId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("newsId", newsId)
                .execute());
    }

    





    public int countByNewsId(int newsId) {
        String sql = "SELECT COUNT(*) FROM news_images WHERE news_id = :newsId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("newsId", newsId)
                .mapTo(Integer.class)
                .one());
    }
}
