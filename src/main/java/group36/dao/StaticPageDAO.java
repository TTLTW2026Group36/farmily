package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.StaticPage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class StaticPageDAO extends BaseDao {

    



    private static class StaticPageMapper implements RowMapper<StaticPage> {
        @Override
        public StaticPage map(ResultSet rs, StatementContext ctx) throws SQLException {
            StaticPage page = new StaticPage();
            page.setId(rs.getInt("id"));
            page.setSlug(rs.getString("slug"));
            page.setTitle(rs.getString("title"));
            page.setContent(rs.getString("content"));
            page.setType(rs.getString("type"));
            page.setStatus(rs.getString("status"));
            page.setCreatedAt(rs.getTimestamp("created_at"));
            page.setUpdatedAt(rs.getTimestamp("updated_at"));
            return page;
        }
    }

    




    public List<StaticPage> findAll() {
        String sql = "SELECT * FROM static_page ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new StaticPageMapper())
                .list());
    }

    




    public List<StaticPage> findAllActive() {
        String sql = "SELECT * FROM static_page WHERE status = 'active' ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new StaticPageMapper())
                .list());
    }

    





    public Optional<StaticPage> findById(int id) {
        String sql = "SELECT * FROM static_page WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new StaticPageMapper())
                .findOne());
    }

    






    public Optional<StaticPage> findBySlug(String slug) {
        String sql = "SELECT * FROM static_page WHERE slug = :slug";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("slug", slug)
                .map(new StaticPageMapper())
                .findOne());
    }

    





    public Optional<StaticPage> findActiveBySlug(String slug) {
        String sql = "SELECT * FROM static_page WHERE slug = :slug AND status = 'active'";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("slug", slug)
                .map(new StaticPageMapper())
                .findOne());
    }

    





    public List<StaticPage> findByType(String type) {
        String sql = "SELECT * FROM static_page WHERE type = :type ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("type", type)
                .map(new StaticPageMapper())
                .list());
    }

    





    public int insert(StaticPage page) {
        String sql = "INSERT INTO static_page (slug, title, content, type, status) " +
                "VALUES (:slug, :title, :content, :type, :status)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("slug", page.getSlug())
                .bind("title", page.getTitle())
                .bind("content", page.getContent())
                .bind("type", page.getType())
                .bind("status", page.getStatus() != null ? page.getStatus() : "active")
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(StaticPage page) {
        String sql = "UPDATE static_page SET title = :title, content = :content, " +
                "type = :type, status = :status WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", page.getId())
                .bind("title", page.getTitle())
                .bind("content", page.getContent())
                .bind("type", page.getType())
                .bind("status", page.getStatus())
                .execute());
    }

    






    public int updateContent(int id, String content) {
        String sql = "UPDATE static_page SET content = :content WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("content", content)
                .execute());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM static_page WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    




    public int count() {
        String sql = "SELECT COUNT(*) FROM static_page";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    





    public boolean slugExists(String slug) {
        String sql = "SELECT COUNT(*) FROM static_page WHERE slug = :slug";
        Integer count = get().withHandle(handle -> handle.createQuery(sql)
                .bind("slug", slug)
                .mapTo(Integer.class)
                .one());
        return count != null && count > 0;
    }

    






    public boolean slugExistsForOther(String slug, int excludeId) {
        String sql = "SELECT COUNT(*) FROM static_page WHERE slug = :slug AND id != :id";
        Integer count = get().withHandle(handle -> handle.createQuery(sql)
                .bind("slug", slug)
                .bind("id", excludeId)
                .mapTo(Integer.class)
                .one());
        return count != null && count > 0;
    }
}
