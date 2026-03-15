package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.FlashSale;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class FlashSaleDAO extends BaseDao {

        


        private static class FlashSaleMapper implements RowMapper<FlashSale> {
                @Override
                public FlashSale map(ResultSet rs, StatementContext ctx) throws SQLException {
                        FlashSale flashSale = new FlashSale();
                        flashSale.setId(rs.getInt("id"));
                        flashSale.setProductId(rs.getInt("product_id"));
                        flashSale.setDiscountPercent(rs.getDouble("discount_percent"));
                        flashSale.setSoldCount(rs.getInt("sold_count"));
                        flashSale.setStockLimit(rs.getInt("stock_limit"));
                        flashSale.setStartTime(rs.getTimestamp("start_time"));
                        flashSale.setEndTime(rs.getTimestamp("end_time"));
                        return flashSale;
                }
        }

        




        public List<FlashSale> findActiveFlashSales() {
                String sql = "SELECT * FROM flash_sales " +
                                "WHERE NOW() BETWEEN start_time AND end_time " +
                                "AND sold_count < stock_limit " +
                                "ORDER BY end_time ASC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new FlashSaleMapper())
                                .list());
        }

        





        public List<FlashSale> findActiveFlashSales(int limit) {
                String sql = "SELECT * FROM flash_sales " +
                                "WHERE NOW() BETWEEN start_time AND end_time " +
                                "AND sold_count < stock_limit " +
                                "ORDER BY end_time ASC " +
                                "LIMIT :limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("limit", limit)
                                .map(new FlashSaleMapper())
                                .list());
        }

        





        public Optional<FlashSale> findById(int id) {
                String sql = "SELECT * FROM flash_sales WHERE id = :id";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("id", id)
                                .map(new FlashSaleMapper())
                                .findOne());
        }

        





        public Optional<FlashSale> findActiveByProductId(int productId) {
                String sql = "SELECT * FROM flash_sales " +
                                "WHERE product_id = :productId " +
                                "AND NOW() BETWEEN start_time AND end_time " +
                                "AND sold_count < stock_limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .bind("productId", productId)
                                .map(new FlashSaleMapper())
                                .findOne());
        }

        




        public List<FlashSale> findAll() {
                String sql = "SELECT * FROM flash_sales ORDER BY start_time DESC";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .map(new FlashSaleMapper())
                                .list());
        }

        





        public int insert(FlashSale flashSale) {
                String sql = "INSERT INTO flash_sales (product_id, discount_percent, " +
                                "sold_count, stock_limit, start_time, end_time) " +
                                "VALUES (:productId, :discountPercent, :soldCount, " +
                                ":stockLimit, :startTime, :endTime)";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("productId", flashSale.getProductId())
                                .bind("discountPercent", flashSale.getDiscountPercent())
                                .bind("soldCount", flashSale.getSoldCount())
                                .bind("stockLimit", flashSale.getStockLimit())
                                .bind("startTime", flashSale.getStartTime())
                                .bind("endTime", flashSale.getEndTime())
                                .executeAndReturnGeneratedKeys("id")
                                .mapTo(Integer.class)
                                .one());
        }

        





        public int update(FlashSale flashSale) {
                String sql = "UPDATE flash_sales SET product_id = :productId, " +
                                "discount_percent = :discountPercent, sold_count = :soldCount, " +
                                "stock_limit = :stockLimit, start_time = :startTime, end_time = :endTime " +
                                "WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", flashSale.getId())
                                .bind("productId", flashSale.getProductId())
                                .bind("discountPercent", flashSale.getDiscountPercent())
                                .bind("soldCount", flashSale.getSoldCount())
                                .bind("stockLimit", flashSale.getStockLimit())
                                .bind("startTime", flashSale.getStartTime())
                                .bind("endTime", flashSale.getEndTime())
                                .execute());
        }

        






        public int incrementSoldCount(int id, int increment) {
                String sql = "UPDATE flash_sales SET sold_count = sold_count + :increment " +
                                "WHERE id = :id AND sold_count + :increment <= stock_limit";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", id)
                                .bind("increment", increment)
                                .execute());
        }

        





        public int delete(int id) {
                String sql = "DELETE FROM flash_sales WHERE id = :id";
                return get().withHandle(handle -> handle.createUpdate(sql)
                                .bind("id", id)
                                .execute());
        }

        




        public java.sql.Timestamp getNearestEndTime() {
                String sql = "SELECT MIN(end_time) FROM flash_sales " +
                                "WHERE NOW() BETWEEN start_time AND end_time " +
                                "AND sold_count < stock_limit";
                return get().withHandle(handle -> handle.createQuery(sql)
                                .mapTo(java.sql.Timestamp.class)
                                .findOne()
                                .orElse(null));
        }
}
