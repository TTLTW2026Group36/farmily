package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.RefundRequestImage;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class RefundRequestImageDAO extends BaseDao {

    private static class RefundRequestImageMapper implements RowMapper<RefundRequestImage> {
        @Override
        public RefundRequestImage map(ResultSet rs, StatementContext ctx) throws SQLException {
            RefundRequestImage img = new RefundRequestImage();
            img.setId(rs.getInt("id"));
            img.setRefundRequestId(rs.getInt("refund_request_id"));
            img.setImageUrl(rs.getString("image_url"));
            img.setCloudinaryPublicId(rs.getString("cloudinary_public_id"));
            img.setMediaType(rs.getString("media_type"));
            img.setCreatedAt(rs.getTimestamp("created_at"));
            return img;
        }
    }

    public int insert(RefundRequestImage img) {
        String sql = "INSERT INTO refund_request_images (refund_request_id, image_url, cloudinary_public_id, media_type) " +
                "VALUES (:refundRequestId, :imageUrl, :publicId, :mediaType)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("refundRequestId", img.getRefundRequestId())
                .bind("imageUrl",        img.getImageUrl())
                .bind("publicId",        img.getCloudinaryPublicId())
                .bind("mediaType",       img.getMediaType() != null ? img.getMediaType() : "image")
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    public List<RefundRequestImage> findByRefundRequestId(int refundRequestId) {
        String sql = "SELECT * FROM refund_request_images WHERE refund_request_id = :refundRequestId ORDER BY id ASC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("refundRequestId", refundRequestId)
                .map(new RefundRequestImageMapper())
                .list());
    }

    public void deleteByRefundRequestId(int refundRequestId) {
        String sql = "DELETE FROM refund_request_images WHERE refund_request_id = :refundRequestId";
        get().withHandle(handle -> handle.createUpdate(sql)
                .bind("refundRequestId", refundRequestId)
                .execute());
    }
}
