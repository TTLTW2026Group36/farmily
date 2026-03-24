package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;





public class StaticPage implements Serializable {
    private int id;
    private String slug; 
    private String title; 
    private String content; 
    private String type; 
    private String status; 
    private Timestamp createdAt;
    private Timestamp updatedAt;

    
    public StaticPage() {
    }

    public StaticPage(int id, String slug, String title, String content, String type,
            String status, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.slug = slug;
        this.title = title;
        this.content = content;
        this.type = type;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public StaticPage(String slug, String title, String content, String type) {
        this.slug = slug;
        this.title = title;
        this.content = content;
        this.type = type;
        this.status = "active";
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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

    


    public boolean isActive() {
        return "active".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "StaticPage{" +
                "id=" + id +
                ", slug='" + slug + '\'' +
                ", title='" + title + '\'' +
                ", type='" + type + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
