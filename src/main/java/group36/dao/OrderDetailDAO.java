package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.OrderDetail;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;





public class OrderDetailDAO extends BaseDao {

    


    private static class OrderDetailMapper implements RowMapper<OrderDetail> {
        @Override
        public OrderDetail map(ResultSet rs, StatementContext ctx) throws SQLException {
            OrderDetail detail = new OrderDetail();
            detail.setId(rs.getInt("id"));
            detail.setOrderId(rs.getInt("order_id"));
            detail.setProductId(rs.getInt("product_id"));

            int variantId = rs.getInt("variant_id");
            detail.setVariantId(rs.wasNull() ? null : variantId);

            detail.setQuantity(rs.getInt("quantity"));
            detail.setUnitPrice(rs.getDouble("unit_price"));
            detail.setSubtotal(rs.getDouble("subtotal"));
            return detail;
        }
    }

    


    public List<OrderDetail> findByOrderId(int orderId) {
        String sql = "SELECT * FROM order_details WHERE order_id = :orderId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map(new OrderDetailMapper())
                .list());
    }

    


    public int insert(OrderDetail detail) {
        String sql = "INSERT INTO order_details (order_id, product_id, variant_id, quantity, unit_price, subtotal) " +
                "VALUES (:orderId, :productId, :variantId, :quantity, :unitPrice, :subtotal)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", detail.getOrderId())
                .bind("productId", detail.getProductId())
                .bind("variantId", detail.getVariantId())
                .bind("quantity", detail.getQuantity())
                .bind("unitPrice", detail.getUnitPrice())
                .bind("subtotal", detail.getSubtotal())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    


    public void insertBatch(List<OrderDetail> details) {
        if (details == null || details.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO order_details (order_id, product_id, variant_id, quantity, unit_price, subtotal) " +
                "VALUES (:orderId, :productId, :variantId, :quantity, :unitPrice, :subtotal)";

        get().useHandle(handle -> {
            var batch = handle.prepareBatch(sql);
            for (OrderDetail detail : details) {
                batch.bind("orderId", detail.getOrderId())
                        .bind("productId", detail.getProductId())
                        .bind("variantId", detail.getVariantId())
                        .bind("quantity", detail.getQuantity())
                        .bind("unitPrice", detail.getUnitPrice())
                        .bind("subtotal", detail.getSubtotal())
                        .add();
            }
            batch.execute();
        });
    }

    


    public int deleteByOrderId(int orderId) {
        String sql = "DELETE FROM order_details WHERE order_id = :orderId";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", orderId)
                .execute());
    }

    


    public int countByOrderId(int orderId) {
        String sql = "SELECT COUNT(*) FROM order_details WHERE order_id = :orderId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapTo(Integer.class)
                .one());
    }

    


    public int sumQuantityByOrderId(int orderId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM order_details WHERE order_id = :orderId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapTo(Integer.class)
                .one());
    }
}
