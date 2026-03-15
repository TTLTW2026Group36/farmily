package group36.service;

import group36.dao.StaticPageDAO;
import group36.model.StaticPage;

import java.util.List;
import java.util.Optional;





public class StaticPageService {
    private final StaticPageDAO staticPageDAO;

    public StaticPageService() {
        this.staticPageDAO = new StaticPageDAO();
    }

    




    public List<StaticPage> getAllStaticPages() {
        return staticPageDAO.findAll();
    }

    




    public List<StaticPage> getActiveStaticPages() {
        return staticPageDAO.findAllActive();
    }

    






    public StaticPage getStaticPageById(int id) {
        return staticPageDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Static page not found with ID: " + id));
    }

    







    public StaticPage getStaticPageBySlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            throw new IllegalArgumentException("Slug cannot be empty");
        }
        return staticPageDAO.findBySlug(slug.trim())
                .orElseThrow(() -> new IllegalArgumentException("Static page not found with slug: " + slug));
    }

    






    public Optional<StaticPage> getActiveStaticPageBySlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            return Optional.empty();
        }
        return staticPageDAO.findActiveBySlug(slug.trim());
    }

    





    public List<StaticPage> getStaticPagesByType(String type) {
        return staticPageDAO.findByType(type);
    }

    









    public StaticPage createStaticPage(String slug, String title, String content, String type) {
        
        validateSlug(slug);
        validateTitle(title);

        slug = slug.trim().toLowerCase();
        title = title.trim();

        
        if (staticPageDAO.slugExists(slug)) {
            throw new IllegalArgumentException("Static page with slug '" + slug + "' already exists");
        }

        
        StaticPage page = new StaticPage(slug, title, content, type);
        int generatedId = staticPageDAO.insert(page);
        page.setId(generatedId);

        return page;
    }

    










    public StaticPage updateStaticPage(int id, String title, String content, String type, String status) {
        
        validateTitle(title);

        title = title.trim();

        
        StaticPage existing = getStaticPageById(id);

        
        existing.setTitle(title);
        existing.setContent(content);
        existing.setType(type);
        existing.setStatus(status);

        int rowsAffected = staticPageDAO.update(existing);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update static page");
        }

        return existing;
    }

    







    public void updateContent(int id, String content) {
        
        getStaticPageById(id);

        int rowsAffected = staticPageDAO.updateContent(id, content);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update static page content");
        }
    }

    





    public void deleteStaticPage(int id) {
        
        getStaticPageById(id);

        int rowsAffected = staticPageDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete static page");
        }
    }

    




    public int getTotalStaticPages() {
        return staticPageDAO.count();
    }

    





    private void validateSlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            throw new IllegalArgumentException("Slug cannot be empty");
        }
        String trimmed = slug.trim();
        if (trimmed.length() > 255) {
            throw new IllegalArgumentException("Slug cannot exceed 255 characters");
        }
        
        if (!trimmed.matches("^[a-z0-9-]+$")) {
            throw new IllegalArgumentException("Slug can only contain lowercase letters, numbers, and hyphens");
        }
    }

    





    private void validateTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be empty");
        }
        if (title.trim().length() > 255) {
            throw new IllegalArgumentException("Title cannot exceed 255 characters");
        }
    }

    





    public boolean isValidSlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            return false;
        }
        return slug.trim().matches("^[a-z0-9-]+$") && slug.trim().length() <= 255;
    }
}
