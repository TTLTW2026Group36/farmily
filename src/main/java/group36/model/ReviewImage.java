package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;






public class ReviewImage implements Serializable {
    private int id;
    private int reviewId;
    private String imageUrl;
    private String mediaType;
    private String cloudinaryPublicId;
    private Timestamp createdAt;


    public ReviewImage() {
    }

    public ReviewImage(int reviewId, String imageUrl) {
        this.reviewId = reviewId;
        this.imageUrl = imageUrl;
    }

    public ReviewImage(int id, int reviewId, String imageUrl, Timestamp createdAt) {
        this.id = id;
        this.reviewId = reviewId;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public boolean isVideo() {
        return "video".equals(mediaType);
    }

    public String getCloudinaryPublicId() {
        return cloudinaryPublicId;
    }

    public void setCloudinaryPublicId(String cloudinaryPublicId) {
        this.cloudinaryPublicId = cloudinaryPublicId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ReviewImage{" +
                "id=" + id +
                ", reviewId=" + reviewId +
                ", imageUrl='" + imageUrl + '\'' +
                ", mediaType='" + mediaType + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
