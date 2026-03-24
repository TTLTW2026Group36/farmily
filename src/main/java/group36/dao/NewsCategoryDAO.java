package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.NewsCategory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class NewsCategoryDAO extends BaseDao {

    


    private static class NewsCategoryMapper implements RowMapper<NewsCategory> {
        @Override
        public NewsCategory map(ResultSet rs, StatementContext ctx) throws SQLException {
            NewsCategory category = new NewsCategory();
            category.setId(rs.getInt("id"));
            category.setName(rs.getString("name"));
            category.setSlug(rs.getString("slug"));
            category.setDescription(rs.getString("description"));
            category.setCreatedAt(rs.getTimestamp("created_at"));
            return category;
        }
    }

    




    public List<NewsCategory> findAll() {
        String sql = "SELECT * FROM news_categories ORDER BY name ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new NewsCategoryMapper())
                .list());
    }

    





    public Optional<NewsCategory> findById(int id) {
        String sql = "SELECT * FROM news_categories WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new NewsCategoryMapper())
                .findOne());
    }

    





    public Optional<NewsCategory> findBySlug(String slug) {
        String sql = "SELECT * FROM news_categories WHERE slug = :slug";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("slug", slug)
                .map(new NewsCategoryMapper())
                .findOne());
    }

    




    public List<NewsCategory> findAllWithNewsCount() {
        String sql = "SELECT nc.*, COUNT(n.id) as news_count " +
                "FROM news_categories nc " +
                "LEFT JOIN news n ON nc.id = n.category_id AND n.status = 'published' " +
                "GROUP BY nc.id " +
                "ORDER BY nc.name ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> {
                    NewsCategory category = new NewsCategoryMapper().map(rs, ctx);
                    category.setNewsCount(rs.getInt("news_count"));
                    return category;
                })
                .list());
    }

    





    public int insert(NewsCategory category) {
        String sql = "INSERT INTO news_categories (name, slug, description) " +
                "VALUES (:name, :slug, :description)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("name", category.getName())
                .bind("slug", category.getSlug())
                .bind("description", category.getDescription())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(NewsCategory category) {
        String sql = "UPDATE news_categories SET name = :name, slug = :slug, " +
                "description = :description WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", category.getId())
                .bind("name", category.getName())
                .bind("slug", category.getSlug())
                .bind("description", category.getDescription())
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM news_categories WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    




    public int count() {
        String sql = "SELECT COUNT(*) FROM news_categories";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }
}
