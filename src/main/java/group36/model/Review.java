package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;





public class Review implements Serializable {
    private int id;
    private int userId;
    private int productId;
    private Integer orderId; 
    private Integer variantId; 
    private int rating; 
    private String reviewText;
    private String imageUrl; 
    private Timestamp createdAt;

    
    private User user;
    private ProductVariant variant;
    private List<ReviewImage> images;

    
    public Review() {
    }

    public Review(int userId, int productId, int rating, String reviewText) {
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.reviewText = reviewText;
    }

    public Review(int id, int userId, int productId, Integer orderId, Integer variantId,
            int rating, String reviewText, String imageUrl, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.orderId = orderId;
        this.variantId = variantId;
        this.rating = rating;
        this.reviewText = reviewText;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getVariantId() {
        return variantId;
    }

    public void setVariantId(Integer variantId) {
        this.variantId = variantId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating < 1)
            rating = 1;
        if (rating > 5)
            rating = 5;
        this.rating = rating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public List<ReviewImage> getImages() {
        return images;
    }

    public void setImages(List<ReviewImage> images) {
        this.images = images;
    }

    

    




    public String getUserDisplayName() {
        if (user != null && user.getName() != null) {
            return user.getName();
        }
        return "Ẩn danh";
    }

    




    public String getUserInitial() {
        String name = getUserDisplayName();
        return name.substring(0, 1).toUpperCase();
    }

    




    public String getVariantDisplayText() {
        if (variant != null && variant.getOptionsValue() != null) {
            return variant.getOptionsValue();
        }
        return "";
    }

    




    public boolean hasImages() {
        return (images != null && !images.isEmpty()) ||
                (imageUrl != null && !imageUrl.isEmpty());
    }

    




    public boolean isVerifiedPurchase() {
        return orderId != null;
    }

    




    public String getFormattedDate() {
        if (createdAt == null)
            return "";
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(createdAt);
    }

    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", rating=" + rating +
                ", reviewText='" + reviewText + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
