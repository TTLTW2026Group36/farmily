package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;





public class Product implements Serializable {
    private int id;
    private int categoryId;
    private String name;
    private double avgRating;
    private int reviewCount;
    private int soldCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    
    private Category category;
    private List<ProductVariant> variants;
    private List<ProductImage> images;

    
    public Product() {
    }

    public Product(int categoryId, String name) {
        this.categoryId = categoryId;
        this.name = name;
    }

    public Product(int id, int categoryId, String name,
            double avgRating, int reviewCount, int soldCount,
            Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.avgRating = avgRating;
        this.reviewCount = reviewCount;
        this.soldCount = soldCount;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }



    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public int getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(int soldCount) {
        this.soldCount = soldCount;
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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariant> variants) {
        this.variants = variants;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    
    




    public double getMinPrice() {
        if (variants == null || variants.isEmpty()) {
            return 0;
        }
        return variants.stream()
                .mapToDouble(ProductVariant::getPrice)
                .min()
                .orElse(0);
    }

    





    public double getSalePrice(double discountPercent) {
        return getMinPrice() * (1 - discountPercent / 100);
    }

    




    public int getTotalStock() {
        if (variants == null || variants.isEmpty()) {
            return 0;
        }
        return variants.stream()
                .mapToInt(ProductVariant::getStock)
                .sum();
    }

    




    public String getPrimaryImageUrl() {
        if (images == null || images.isEmpty()) {
            return null;
        }
        return images.get(0).getImageUrl();
    }

    




    public ProductVariant getMinPriceVariant() {
        if (variants == null || variants.isEmpty()) {
            return null;
        }
        return variants.stream()
                .min((v1, v2) -> Double.compare(v1.getPrice(), v2.getPrice()))
                .orElse(null);
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", avgRating=" + avgRating +
                ", reviewCount=" + reviewCount +
                ", soldCount=" + soldCount +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
