package group36.service;

import group36.dao.NewsCategoryDAO;
import group36.dao.NewsDAO;
import group36.dao.NewsImageDAO;
import group36.dao.UserDAO;
import group36.model.News;
import group36.model.NewsImage;

import java.util.List;

public class NewsService {
    private final NewsDAO newsDAO;
    private final NewsImageDAO imageDAO;
    private final NewsCategoryDAO categoryDAO;
    private final UserDAO userDAO;

    public NewsService() {
        this.newsDAO = new NewsDAO();
        this.imageDAO = new NewsImageDAO();
        this.categoryDAO = new NewsCategoryDAO();
        this.userDAO = new UserDAO();
    }

    public List<News> getAllNews() {
        List<News> newsList = newsDAO.findAll();
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> getAllNewsAdmin() {
        List<News> newsList = newsDAO.findAllAdmin();
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> getNewsPaginated(int page, int size) {
        List<News> newsList = newsDAO.findAllPaginated(page, size);
        loadNewsDetails(newsList);
        return newsList;
    }

    public News getNewsById(int id) {
        News news = newsDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("News not found with ID: " + id));
        loadNewsDetails(news);
        return news;
    }

    public News getPublishedNewsById(int id) {
        News news = newsDAO.findByIdPublished(id)
                .orElseThrow(() -> new IllegalArgumentException("News not found with ID: " + id));
        loadNewsDetails(news);

        
        newsDAO.incrementViewCount(id);
        news.setViewCount(news.getViewCount() + 1);

        return news;
    }

    public List<News> getNewsByCategoryPaginated(int categoryId, int page, int size) {
        List<News> newsList = newsDAO.findByCategoryIdPaginated(categoryId, page, size);
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> searchNews(String keyword) {
        List<News> newsList = newsDAO.searchByTitle(keyword);
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> getPopularNews(int limit) {
        List<News> newsList = newsDAO.findPopular(limit);
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> getRecentNews(int limit) {
        List<News> newsList = newsDAO.findRecent(limit);
        loadNewsDetails(newsList);
        return newsList;
    }

    public List<News> getRelatedNews(int newsId, int categoryId, int limit) {
        List<News> newsList = newsDAO.findRelated(newsId, categoryId, limit);
        loadNewsDetails(newsList);
        return newsList;
    }

    public News getFeaturedNews() {
        return newsDAO.findFeatured()
                .map(news -> {
                    loadNewsDetails(news);
                    return news;
                })
                .orElse(null);
    }

    public int getTotalNews() {
        return newsDAO.count();
    }

    public int getTotalNewsByCategory(int categoryId) {
        return newsDAO.countByCategoryId(categoryId);
    }

    public News createNews(News news, List<String> imageUrls) {
        validateNews(news);

        
        if (news.getCategoryId() > 0) {
            categoryDAO.findById(news.getCategoryId())
                    .orElseThrow(() -> new IllegalArgumentException("Category not found"));
        }

        
        int newsId = newsDAO.insert(news);
        news.setId(newsId);

        
        if (imageUrls != null && !imageUrls.isEmpty()) {
            int position = 1;
            for (String imageUrl : imageUrls) {
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    NewsImage image = new NewsImage(newsId, imageUrl.trim(), null, position++);
                    imageDAO.insert(image);
                }
            }
        }

        return getNewsById(newsId);
    }

    public News updateNews(News news) {
        validateNews(news);

        getNewsById(news.getId());

        int rowsAffected = newsDAO.update(news);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update news");
        }

        return getNewsById(news.getId());
    }

    public NewsImage addImage(int newsId, String imageUrl, String caption) {
        getNewsById(newsId);

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            throw new IllegalArgumentException("Image URL cannot be empty");
        }

        int position = imageDAO.countByNewsId(newsId) + 1;

        NewsImage image = new NewsImage(newsId, imageUrl.trim(), caption, position);
        int imageId = imageDAO.insert(image);
        image.setId(imageId);
        return image;
    }

    public void deleteNews(int id) {
        getNewsById(id);

        int rowsAffected = newsDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete news");
        }
    }

    public int deleteImage(int imageId) {
        return imageDAO.delete(imageId);
    }

    private void loadNewsDetails(News news) {
        if (news == null)
            return;
        if (news.getCategoryId() > 0) {
            categoryDAO.findById(news.getCategoryId())
                    .ifPresent(news::setCategory);
        }
        if (news.getAuthorId() > 0) {
            userDAO.findById(news.getAuthorId())
                    .ifPresent(news::setAuthor);
        }
        news.setImages(imageDAO.findByNewsId(news.getId()));
    }

    private void loadNewsDetails(List<News> newsList) {
        if (newsList == null || newsList.isEmpty())
            return;
        for (News news : newsList) {
            loadNewsDetails(news);
        }
    }

    private void validateNews(News news) {
        if (news == null) {
            throw new IllegalArgumentException("News cannot be null");
        }
        if (news.getTitle() == null || news.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("News title cannot be empty");
        }
        news.setTitle(news.getTitle().trim());
    }
}
