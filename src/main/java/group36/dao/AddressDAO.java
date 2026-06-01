package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Address;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AddressDAO extends BaseDao {

    private static class AddressMapper implements RowMapper<Address> {
        @Override
        public Address map(ResultSet rs, StatementContext ctx) throws SQLException {
            Address address = new Address();
            address.setId(rs.getInt("id"));
            address.setUserId(rs.getInt("user_id"));
            address.setReceiver(rs.getString("receiver"));
            address.setPhone(rs.getString("phone"));
            address.setAddressDetail(rs.getString("address_detail"));
            address.setDistrict(rs.getString("district"));
            address.setCity(rs.getString("city"));
            address.setGhnDistrictId(rs.getObject("ghn_district_id") != null ? rs.getInt("ghn_district_id") : null);
            address.setGhnWardCode(rs.getString("ghn_ward_code"));
            address.setDefault(rs.getBoolean("is_default"));
            address.setDeleted(rs.getBoolean("is_deleted"));
            address.setCreatedAt(rs.getTimestamp("created_at"));
            address.setUpdatedAt(rs.getTimestamp("updated_at"));
            return address;
        }
    }

    public Optional<Address> findById(int id) {
        String sql = "SELECT * FROM address WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new AddressMapper())
                .findOne());
    }

    public List<Address> findByUserId(int userId) {
        String sql = "SELECT * FROM address WHERE user_id = :userId AND is_deleted = FALSE ORDER BY is_default DESC, created_at DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new AddressMapper())
                .list());
    }

    public Optional<Address> findDefaultByUserId(int userId) {
        String sql = "SELECT * FROM address WHERE user_id = :userId AND is_default = TRUE AND is_deleted = FALSE LIMIT 1";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map(new AddressMapper())
                .findOne());
    }

    public int insert(Address address) {
        return get().withHandle(h -> insertWithHandle(h, address));
    }

    public int insertWithHandle(org.jdbi.v3.core.Handle h, Address address) {
        String sql = "INSERT INTO address (user_id, receiver, phone, address_detail, district, city, is_default, ghn_district_id, ghn_ward_code) " +
                "VALUES (:userId, :receiver, :phone, :addressDetail, :district, :city, :isDefault, :ghnDistrictId, :ghnWardCode)";
        return h.createUpdate(sql)
                .bind("userId", address.getUserId())
                .bind("receiver", address.getReceiver())
                .bind("phone", address.getPhone())
                .bind("addressDetail", address.getAddressDetail())
                .bind("district", address.getDistrict())
                .bind("city", address.getCity())
                .bind("isDefault", address.isDefault())
                .bind("ghnDistrictId", address.getGhnDistrictId())
                .bind("ghnWardCode", address.getGhnWardCode())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();
    }

    public int update(Address address) {
        String sql = "UPDATE address SET receiver = :receiver, phone = :phone, address_detail = :addressDetail, " +
                "district = :district, city = :city, is_default = :isDefault, " +
                "ghn_district_id = :ghnDistrictId, ghn_ward_code = :ghnWardCode, " +
                "updated_at = NOW() WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", address.getId())
                .bind("receiver", address.getReceiver())
                .bind("phone", address.getPhone())
                .bind("addressDetail", address.getAddressDetail())
                .bind("district", address.getDistrict())
                .bind("city", address.getCity())
                .bind("isDefault", address.isDefault())
                .bind("ghnDistrictId", address.getGhnDistrictId())
                .bind("ghnWardCode", address.getGhnWardCode())
                .execute());
    }

    public int delete(int id) {
        String sql = "UPDATE address SET is_deleted = TRUE, is_default = FALSE, updated_at = NOW() WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public void setDefault(int userId, int addressId) {
        get().inTransaction(handle -> {
            handle.createUpdate("UPDATE address SET is_default = FALSE WHERE user_id = :userId AND is_deleted = FALSE")
                    .bind("userId", userId)
                    .execute();
            if (addressId > 0) {
                handle.createUpdate("UPDATE address SET is_default = TRUE WHERE id = :id AND user_id = :userId AND is_deleted = FALSE")
                        .bind("id", addressId)
                        .bind("userId", userId)
                        .execute();
            }
            return null;
        });
    }

    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM address WHERE user_id = :userId AND is_deleted = FALSE";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .one());
    }
}
