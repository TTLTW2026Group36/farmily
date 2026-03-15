package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;






public class NewsImage implements Serializable {
    private int id;
    private int newsId;
    private String imageUrl;
    private String caption;
    private int position;
    private Timestamp createdAt;

    
    public NewsImage() {
    }

    public NewsImage(int newsId, String imageUrl) {
        this.newsId = newsId;
        this.imageUrl = imageUrl;
    }

    public NewsImage(int newsId, String imageUrl, String caption, int position) {
        this.newsId = newsId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.position = position;
    }

    public NewsImage(int id, int newsId, String imageUrl, String caption, int position, Timestamp createdAt) {
        this.id = id;
        this.newsId = newsId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.position = position;
        this.createdAt = createdAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNewsId() {
        return newsId;
    }

    public void setNewsId(int newsId) {
        this.newsId = newsId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "NewsImage{" +
                "id=" + id +
                ", newsId=" + newsId +
                ", imageUrl='" + imageUrl + '\'' +
                ", caption='" + caption + '\'' +
                ", position=" + position +
                ", createdAt=" + createdAt +
                '}';
    }
}
