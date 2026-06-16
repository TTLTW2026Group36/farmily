package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.User;
import group36.model.UserRole;

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

            user.setRole(UserRole.fromString(rs.getString("role")).name());
            user.setStatus(rs.getString("status"));
            user.setCreated_at(rs.getTimestamp("created_at"));
            user.setUpdated_at(rs.getTimestamp("updated_at"));
            user.setLoginAttempts(rs.getInt("login_attempts"));
            user.setLockoutUntil(rs.getTimestamp("lockout_until"));
            user.setEmailVerified(rs.getBoolean("is_email_verified"));
            user.setLockedReason(rs.getString("locked_reason"));
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
        String sql = "SELECT * FROM users WHERE name LIKE :keyword OR email LIKE :keyword OR phone LIKE :keyword ORDER BY id DESC";
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
                .bind("role", UserRole.fromString(user.getRole()).name())
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

    public int updateStatus(int userId, String status, String lockedReason) {
        String sql = "UPDATE users SET status = :status, locked_reason = :reason WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", userId)
                .bind("status", status)
                .bind("reason", lockedReason)
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

    public void incrementLoginAttempts(int userId) {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1 WHERE id = :id";
        get().useHandle(handle -> handle.createUpdate(sql).bind("id", userId).execute());
    }

    public void resetLoginAttempts(int userId) {
        String sql = "UPDATE users SET login_attempts = 0, lockout_until = NULL WHERE id = :id";
        get().useHandle(handle -> handle.createUpdate(sql).bind("id", userId).execute());
    }

    public void lockAccount(int userId, int minutes) {
        String sql = "UPDATE users SET lockout_until = :until WHERE id = :id";
        java.sql.Timestamp until = new java.sql.Timestamp(System.currentTimeMillis() + (long) minutes * 60 * 1000);
        get().useHandle(handle -> handle.createUpdate(sql).bind("id", userId).bind("until", until).execute());
    }

    public List<User> findUsers(String keyword, String role, String status, String verified, int page, int size) {
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");

        if (role != null && !role.isEmpty() && !"all".equals(role)) {
            sql.append(" AND role = :role");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE :keyword OR email LIKE :keyword OR phone LIKE :keyword)");
        }
        if ("locked".equals(status)) {
            sql.append(" AND status = 'locked'");
        } else if ("active".equals(status)) {
            sql.append(" AND status = 'active'");
        }
        if ("verified".equals(verified)) {
            sql.append(" AND is_email_verified = TRUE");
        } else if ("unverified".equals(verified)) {
            sql.append(" AND is_email_verified = FALSE");
        }
        sql.append(" ORDER BY id DESC");

        boolean isPaginated = size > 0;
        if (isPaginated) {
            sql.append(" LIMIT :size OFFSET :offset");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());
            if (isPaginated) {
                int offset = (page - 1) * size;
                q.bind("size", size).bind("offset", offset);
            }
            if (role != null && !role.isEmpty() && !"all".equals(role)) {
                q.bind("role", role);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                q.bind("keyword", "%" + keyword.trim() + "%");
            }
            return q.map(new UserMapper()).list();
        });
    }

    public int countUsers(String keyword, String role, String status, String verified) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");

        if (role != null && !role.isEmpty() && !"all".equals(role)) {
            sql.append(" AND role = :role");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE :keyword OR email LIKE :keyword OR phone LIKE :keyword)");
        }
        if ("locked".equals(status)) {
            sql.append(" AND status = 'locked'");
        } else if ("active".equals(status)) {
            sql.append(" AND status = 'active'");
        }
        if ("verified".equals(verified)) {
            sql.append(" AND is_email_verified = TRUE");
        } else if ("unverified".equals(verified)) {
            sql.append(" AND is_email_verified = FALSE");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());
            if (role != null && !role.isEmpty() && !"all".equals(role)) {
                q.bind("role", role);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                q.bind("keyword", "%" + keyword.trim() + "%");
            }
            return q.mapTo(Integer.class).one();
        });
    }
}

