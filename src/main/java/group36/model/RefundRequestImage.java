package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class RefundRequestImage implements Serializable {

    private int id;
    private int refundRequestId;
    private String imageUrl;
    private String cloudinaryPublicId;
    private String mediaType;
    private Timestamp createdAt;

    public RefundRequestImage() {}

    public RefundRequestImage(int refundRequestId, String imageUrl) {
        this.refundRequestId = refundRequestId;
        this.imageUrl = imageUrl;
        this.mediaType = "image";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRefundRequestId() { return refundRequestId; }
    public void setRefundRequestId(int refundRequestId) { this.refundRequestId = refundRequestId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCloudinaryPublicId() { return cloudinaryPublicId; }
    public void setCloudinaryPublicId(String cloudinaryPublicId) { this.cloudinaryPublicId = cloudinaryPublicId; }

    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isVideo() {
        return "video".equals(mediaType);
    }

    @Override
    public String toString() {
        return "RefundRequestImage{" +
                "id=" + id +
                ", refundRequestId=" + refundRequestId +
                ", imageUrl='" + imageUrl + '\'' +
                ", mediaType='" + mediaType + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
