package group36.service;

import group36.dao.NewsCategoryDAO;
import group36.model.NewsCategory;

import java.util.List;





public class NewsCategoryService {
    private final NewsCategoryDAO categoryDAO;

    public NewsCategoryService() {
        this.categoryDAO = new NewsCategoryDAO();
    }

    

    




    public List<NewsCategory> getAllCategories() {
        return categoryDAO.findAll();
    }

    





    public List<NewsCategory> getAllCategoriesWithCount() {
        return categoryDAO.findAllWithNewsCount();
    }

    






    public NewsCategory getCategoryById(int id) {
        return categoryDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Category not found with ID: " + id));
    }

    






    public NewsCategory getCategoryBySlug(String slug) {
        return categoryDAO.findBySlug(slug)
                .orElseThrow(() -> new IllegalArgumentException("Category not found with slug: " + slug));
    }

    

    






    public NewsCategory createCategory(NewsCategory category) {
        validateCategory(category);

        
        if (category.getSlug() == null || category.getSlug().trim().isEmpty()) {
            category.setSlug(generateSlug(category.getName()));
        }

        int id = categoryDAO.insert(category);
        category.setId(id);
        return category;
    }

    

    






    public NewsCategory updateCategory(NewsCategory category) {
        validateCategory(category);

        
        getCategoryById(category.getId());

        int rowsAffected = categoryDAO.update(category);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update category");
        }

        return getCategoryById(category.getId());
    }

    

    





    public void deleteCategory(int id) {
        getCategoryById(id);

        int rowsAffected = categoryDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete category");
        }
    }

    

    


    private void validateCategory(NewsCategory category) {
        if (category == null) {
            throw new IllegalArgumentException("Category cannot be null");
        }
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty");
        }
        category.setName(category.getName().trim());
    }

    


    private String generateSlug(String name) {
        if (name == null)
            return "";
        return name.toLowerCase()
                .replaceAll("[àáạảãâầấậẩẫăằắặẳẵ]", "a")
                .replaceAll("[èéẹẻẽêềếệểễ]", "e")
                .replaceAll("[ìíịỉĩ]", "i")
                .replaceAll("[òóọỏõôồốộổỗơờớợởỡ]", "o")
                .replaceAll("[ùúụủũưừứựửữ]", "u")
                .replaceAll("[ỳýỵỷỹ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
    }
}
