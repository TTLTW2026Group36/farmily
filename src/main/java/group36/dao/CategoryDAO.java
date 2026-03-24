package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Category;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class CategoryDAO extends BaseDao {

    



    private static class CategoryMapper implements RowMapper<Category> {
        @Override
        public Category map(ResultSet rs, StatementContext ctx) throws SQLException {
            Category category = new Category();
            category.setId(rs.getInt("id"));
            category.setName(rs.getString("name"));
            category.setImageUrl(rs.getString("image_url"));
            category.setCreatedAt(rs.getTimestamp("created_at"));
            return category;
        }
    }

    




    public List<Category> findAll() {
        String sql = "SELECT * FROM category ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new CategoryMapper())
                .list());
    }

    





    public Optional<Category> findById(int id) {
        String sql = "SELECT * FROM category WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new CategoryMapper())
                .findOne());
    }

    





    public Optional<Category> findByName(String name) {
        String sql = "SELECT * FROM category WHERE name = :name";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("name", name)
                .map(new CategoryMapper())
                .findOne());
    }

    





    public int insert(Category category) {
        String sql = "INSERT INTO category (name, image_url) VALUES (:name, :imageUrl)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("name", category.getName())
                .bind("imageUrl", category.getImageUrl())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(Category category) {
        String sql = "UPDATE category SET name = :name, image_url = :imageUrl WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", category.getId())
                .bind("name", category.getName())
                .bind("imageUrl", category.getImageUrl())
                .execute());
    }

    






    public int delete(int id) {
        String sql = "DELETE FROM category WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    





    public boolean hasProducts(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = :categoryId";
        Integer count = get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .mapTo(Integer.class)
                .one());
        return count != null && count > 0;
    }

    




    public int count() {
        String sql = "SELECT COUNT(*) FROM category";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }
}
