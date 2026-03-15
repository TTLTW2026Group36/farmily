package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;





public class NewsCategory implements Serializable {
    private int id;
    private String name;
    private String slug;
    private String description;
    private Timestamp createdAt;

    
    private int newsCount;

    
    public NewsCategory() {
    }

    public NewsCategory(String name, String slug) {
        this.name = name;
        this.slug = slug;
    }

    public NewsCategory(int id, String name, String slug, String description, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.createdAt = createdAt;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getNewsCount() {
        return newsCount;
    }

    public void setNewsCount(int newsCount) {
        this.newsCount = newsCount;
    }

    @Override
    public String toString() {
        return "NewsCategory{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", newsCount=" + newsCount +
                '}';
    }
}
