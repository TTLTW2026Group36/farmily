package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class UserDAO extends BaseDao {

    private static class UserMapper implements RowMapper<User> {
        @Override
        public User map(ResultSet rs, StatementContext ctx) throws SQLException {
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            user.setPhone(rs.getString("phone"));
            user.setRole(rs.getString("role"));
            user.setCreated_at(rs.getTimestamp("created_at"));
            user.setUpdated_at(rs.getTimestamp("updated_at"));
            return user;
        }
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new UserMapper())
                .list());
    }

    public List<User> findAllPaginated(int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM users ORDER BY id DESC LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("size", size)
                .bind("offset", offset)
                .map(new UserMapper())
                .list());
    }

    public Optional<User> findById(int id) {
        String sql = "SELECT * FROM users WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new UserMapper())
                .findOne());
    }

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .map(new UserMapper())
                .findOne());
    }

    public List<User> findByRole(String role) {
        String sql = "SELECT * FROM users WHERE role = :role ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("role", role)
                .map(new UserMapper())
                .list());
    }

    public List<User> findByRolePaginated(String role, int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM users WHERE role = :role ORDER BY id DESC LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("role", role)
                .bind("size", size)
                .bind("offset", offset)
                .map(new UserMapper())
                .list());
    }

    public List<User> searchByNameOrEmail(String keyword) {
        String sql = "SELECT * FROM users WHERE name LIKE :keyword OR email LIKE :keyword ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("keyword", "%" + keyword + "%")
                .map(new UserMapper())
                .list());
    }

    public int insert(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, role) " +
                "VALUES (:name, :email, :password, :phone, :role)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("name", user.getName())
                .bind("email", user.getEmail())
                .bind("password", user.getPassword())
                .bind("phone", user.getPhone())
                .bind("role", user.getRole() != null ? user.getRole() : "user")
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public int update(User user) {
        String sql = "UPDATE users SET name = :name, email = :email, phone = :phone, role = :role WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", user.getId())
                .bind("name", user.getName())
                .bind("email", user.getEmail())
                .bind("phone", user.getPhone())
                .bind("role", user.getRole())
                .execute());
    }

    public int updatePassword(int id, String hashedPassword) {
        String sql = "UPDATE users SET password = :password WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("password", hashedPassword)
                .execute());
    }

    public int delete(int id) {
        String sql = "DELETE FROM users WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM users";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = :role";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("role", role)
                .mapTo(Integer.class)
                .one());
    }
}
