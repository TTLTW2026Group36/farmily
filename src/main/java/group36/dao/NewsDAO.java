package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.News;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class NewsDAO extends BaseDao {

        


        private static class NewsMapper implements RowMapper<News> {
                @Override
                public News map(ResultSet rs, StatementContext ctx) throws SQLException {
                        News news = new News();
                        news.setId(rs.getInt("id"));
                        news.setCategoryId(rs.getInt("category_id"));
                        news.setAuthorId(rs.getInt("author_id"));
                        news.setTitle(rs.getString("title"));
                        news.setContent(rs.getString("content"));
                        news.setExcerpt(rs.getString("excerpt"));
                        news.setImageUrl(rs.getString("image_url"));
                        news.setViewCount(rs.getInt("view_count"));
                        news.setStatus(rs.getString("status"));
                        news.setCreatedAt(rs.getTimestamp("created_at"));
                        news.setUpdatedAt(rs.getTimestamp("updated_at"));
                        return news;
                }
        }

        




        public List<News> findAll() {
                String sql = "SELECT * FROM news WHERE status = 'published' ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new NewsMapper())
                                .list());
        }

        




        public List<News> findAllAdmin() {
                String sql = "SELECT * FROM news ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new NewsMapper())
                                .list());
        }

        






        public List<News> findAllPaginated(int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM news WHERE status = 'published' " +
                                "ORDER BY created_at DESC LIMIT :size OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("size", size)
                                .bind("offset", offset)
                                .map(new NewsMapper())
                                .list());
        }

        





        public Optional<News> findById(int id) {
                String sql = "SELECT * FROM news WHERE id = :id";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("id", id)
                                .map(new NewsMapper())
                                .findOne());
        }

        





        public Optional<News> findByIdPublished(int id) {
                String sql = "SELECT * FROM news WHERE id = :id AND status = 'published'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("id", id)
                                .map(new NewsMapper())
                                .findOne());
        }

        





        public List<News> findByCategoryId(int categoryId) {
                String sql = "SELECT * FROM news WHERE category_id = :categoryId AND status = 'published' " +
                                "ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("categoryId", categoryId)
                                .map(new NewsMapper())
                                .list());
        }

        







        public List<News> findByCategoryIdPaginated(int categoryId, int page, int size) {
                int offset = (page - 1) * size;
                String sql = "SELECT * FROM news WHERE category_id = :categoryId AND status = 'published' " +
                                "ORDER BY created_at DESC LIMIT :size OFFSET :offset";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("categoryId", categoryId)
                                .bind("size", size)
                                .bind("offset", offset)
                                .map(new NewsMapper())
                                .list());
        }

        





        public List<News> searchByTitle(String keyword) {
                String sql = "SELECT * FROM news WHERE title LIKE :keyword AND status = 'published' " +
                                "ORDER BY created_at DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("keyword", "%" + keyword + "%")
                                .map(new NewsMapper())
                                .list());
        }

        





        public List<News> findPopular(int limit) {
                String sql = "SELECT * FROM news WHERE status = 'published' " +
                                "ORDER BY view_count DESC LIMIT :limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("limit", limit)
                                .map(new NewsMapper())
                                .list());
        }

        





        public List<News> findRecent(int limit) {
                String sql = "SELECT * FROM news WHERE status = 'published' " +
                                "ORDER BY created_at DESC LIMIT :limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("limit", limit)
                                .map(new NewsMapper())
                                .list());
        }

        







        public List<News> findRelated(int newsId, int categoryId, int limit) {
                String sql = "SELECT * FROM news WHERE id != :newsId AND category_id = :categoryId " +
                                "AND status = 'published' ORDER BY created_at DESC LIMIT :limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("newsId", newsId)
                                .bind("categoryId", categoryId)
                                .bind("limit", limit)
                                .map(new NewsMapper())
                                .list());
        }

        





        public int insert(News news) {
                String sql = "INSERT INTO news (category_id, author_id, title, content, excerpt, image_url, status) " +
                                "VALUES (:categoryId, :authorId, :title, :content, :excerpt, :imageUrl, :status)";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("categoryId", news.getCategoryId())
                                .bind("authorId", news.getAuthorId())
                                .bind("title", news.getTitle())
                                .bind("content", news.getContent())
                                .bind("excerpt", news.getExcerpt())
                                .bind("imageUrl", news.getImageUrl())
                                .bind("status", news.getStatus() != null ? news.getStatus() : "published")
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int update(News news) {
                String sql = "UPDATE news SET category_id = :categoryId, title = :title, " +
                                "content = :content, excerpt = :excerpt, image_url = :imageUrl, " +
                                "status = :status WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", news.getId())
                                .bind("categoryId", news.getCategoryId())
                                .bind("title", news.getTitle())
                                .bind("content", news.getContent())
                                .bind("excerpt", news.getExcerpt())
                                .bind("imageUrl", news.getImageUrl())
                                .bind("status", news.getStatus())
                                .execute());
        }

        






        public int delete(int id) {
                String sql = "DELETE FROM news WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", id)
                                .execute());
        }

        





        public int incrementViewCount(int id) {
                String sql = "UPDATE news SET view_count = view_count + 1 WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", id)
                                .execute());
        }

        




        public int count() {
                String sql = "SELECT COUNT(*) FROM news WHERE status = 'published'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int countByCategoryId(int categoryId) {
                String sql = "SELECT COUNT(*) FROM news WHERE category_id = :categoryId AND status = 'published'";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("categoryId", categoryId)
                                .mapTo(Integer.class)
                                .one());
        }

        




        public Optional<News> findFeatured() {
                String sql = "SELECT * FROM news WHERE status = 'published' " +
                                "ORDER BY view_count DESC, created_at DESC LIMIT 1";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new NewsMapper())
                                .findOne());
        }
}
