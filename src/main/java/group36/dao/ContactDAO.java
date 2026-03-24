package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Contact;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class ContactDAO extends BaseDao {

    



    private static class ContactMapper implements RowMapper<Contact> {
        @Override
        public Contact map(ResultSet rs, StatementContext ctx) throws SQLException {
            Contact contact = new Contact();
            contact.setId(rs.getInt("id"));

            int userId = rs.getInt("user_id");
            contact.setUserId(rs.wasNull() ? null : userId);

            contact.setFullname(rs.getString("fullname"));
            contact.setEmail(rs.getString("email"));
            contact.setPhone(rs.getString("phone"));
            contact.setSubject(rs.getString("subject"));
            contact.setOrganization(rs.getString("organization"));
            contact.setMessage(rs.getString("message"));
            contact.setCreatedAt(rs.getTimestamp("created_at"));
            return contact;
        }
    }

    





    public int insert(Contact contact) {
        String sql = "INSERT INTO contact (user_id, fullname, email, phone, subject, organization, message) " +
                "VALUES (:userId, :fullname, :email, :phone, :subject, :organization, :message)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", contact.getUserId())
                .bind("fullname", contact.getFullname())
                .bind("email", contact.getEmail())
                .bind("phone", contact.getPhone())
                .bind("subject", contact.getSubject())
                .bind("organization", contact.getOrganization())
                .bind("message", contact.getMessage())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    




    public List<Contact> findAll() {
        String sql = "SELECT * FROM contact ORDER BY created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new ContactMapper())
                .list());
    }

    






    public List<Contact> findAllPaginated(int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM contact ORDER BY created_at DESC LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("size", size)
                .bind("offset", offset)
                .map(new ContactMapper())
                .list());
    }

    





    public Optional<Contact> findById(int id) {
        String sql = "SELECT * FROM contact WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new ContactMapper())
                .findOne());
    }

    




    public int count() {
        String sql = "SELECT COUNT(*) FROM contact";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    





    public int delete(int id) {
        String sql = "DELETE FROM contact WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }
}
