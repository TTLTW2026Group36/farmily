package group36.service;

import group36.dao.CategoryDAO;
import group36.dao.ProductDAO;
import group36.model.Category;

import java.util.List;
import java.util.Optional;





public class CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    




    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    






    public Category getCategoryById(int id) {
        return categoryDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Category not found with ID: " + id));
    }

    







    public Category createCategory(String name) {
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty");
        }

        name = name.trim();

        
        if (categoryDAO.findByName(name).isPresent()) {
            throw new IllegalArgumentException("Category with name '" + name + "' already exists");
        }

        
        Category category = new Category(name);
        int generatedId = categoryDAO.insert(category);
        category.setId(generatedId);

        return category;
    }

    








    public Category updateCategory(int id, String name) {
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty");
        }

        name = name.trim();

        
        Category existing = getCategoryById(id);

        
        Optional<Category> duplicate = categoryDAO.findByName(name);
        if (duplicate.isPresent() && duplicate.get().getId() != id) {
            throw new IllegalArgumentException("Category with name '" + name + "' already exists");
        }

        
        existing.setName(name);

        int rowsAffected = categoryDAO.update(existing);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update category");
        }

        return existing;
    }

    






    public void deleteCategory(int id) {
        
        getCategoryById(id); 

        
        if (categoryDAO.hasProducts(id)) {
            throw new IllegalArgumentException(
                    "Cannot delete category with associated products. Please remove or reassign products first.");
        }

        
        int rowsAffected = categoryDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete category");
        }
    }

    




    public int getTotalCategories() {
        return categoryDAO.count();
    }

    





    public boolean isValidCategoryName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        
        
        return name.trim().length() <= 255;
    }

    public int getProductCount(int categoryId) {
        return new ProductDAO().countByCategoryId(categoryId);
    }
}
