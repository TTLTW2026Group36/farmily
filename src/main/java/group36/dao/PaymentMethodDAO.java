package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.PaymentMethod;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class PaymentMethodDAO extends BaseDao {

    


    private static class PaymentMethodMapper implements RowMapper<PaymentMethod> {
        @Override
        public PaymentMethod map(ResultSet rs, StatementContext ctx) throws SQLException {
            PaymentMethod method = new PaymentMethod();
            method.setId(rs.getInt("id"));
            method.setMethodName(rs.getString("method_name"));
            method.setStatus(rs.getString("status"));
            return method;
        }
    }

    


    public Optional<PaymentMethod> findById(int id) {
        String sql = "SELECT * FROM payment_method WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new PaymentMethodMapper())
                .findOne());
    }

    


    public List<PaymentMethod> findAllActive() {
        String sql = "SELECT * FROM payment_method WHERE status = 'active' ORDER BY id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new PaymentMethodMapper())
                .list());
    }

    


    public List<PaymentMethod> findAll() {
        String sql = "SELECT * FROM payment_method ORDER BY id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new PaymentMethodMapper())
                .list());
    }
}
