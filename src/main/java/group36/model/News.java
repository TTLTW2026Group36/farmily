package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;





public class News implements Serializable {
    private int id;
    private int categoryId;
    private int authorId;
    private String title;
    private String content;
    private String excerpt;
    private String imageUrl; 
    private int viewCount;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    
    private NewsCategory category;
    private User author;
    private List<NewsImage> images;

    
    public News() {
    }

    public News(int categoryId, String title, String content, String excerpt, String imageUrl) {
        this.categoryId = categoryId;
        this.title = title;
        this.content = content;
        this.excerpt = excerpt;
        this.imageUrl = imageUrl;
    }

    public News(int id, int categoryId, int authorId, String title, String content, String excerpt,
            String imageUrl, int viewCount, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.categoryId = categoryId;
        this.authorId = authorId;
        this.title = title;
        this.content = content;
        this.excerpt = excerpt;
        this.imageUrl = imageUrl;
        this.viewCount = viewCount;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getExcerpt() {
        return excerpt;
    }

    public void setExcerpt(String excerpt) {
        this.excerpt = excerpt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public NewsCategory getCategory() {
        return category;
    }

    public void setCategory(NewsCategory category) {
        this.category = category;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public List<NewsImage> getImages() {
        return images;
    }

    public void setImages(List<NewsImage> images) {
        this.images = images;
    }

    
    




    public String getPrimaryImageUrl() {
        if (images != null && !images.isEmpty()) {
            return images.get(0).getImageUrl();
        }
        return imageUrl;
    }

    




    public String getAuthorName() {
        if (author != null && author.getName() != null) {
            return author.getName();
        }
        return "Admin";
    }

    




    public String getCategoryName() {
        if (category != null && category.getName() != null) {
            return category.getName();
        }
        return "";
    }

    




    public boolean isPublished() {
        return "published".equalsIgnoreCase(status);
    }

    @Override
    public String toString() {
        return "News{" +
                "id=" + id +
                ", categoryId=" + categoryId +
                ", authorId=" + authorId +
                ", title='" + title + '\'' +
                ", excerpt='" + excerpt + '\'' +
                ", viewCount=" + viewCount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
