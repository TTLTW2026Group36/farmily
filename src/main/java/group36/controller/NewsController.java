package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.model.News;
import group36.model.NewsCategory;
import group36.service.NewsCategoryService;
import group36.service.NewsService;

import java.io.IOException;
import java.util.List;





@WebServlet(name = "NewsController", urlPatterns = { "/tin-tuc", "/news" })
public class NewsController extends HttpServlet {

    private NewsService newsService;
    private NewsCategoryService categoryService;

    private static final int DEFAULT_PAGE_SIZE = 6;

    @Override
    public void init() throws ServletException {
        newsService = new NewsService();
        categoryService = new NewsCategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        int categoryId = parseIntParam(request, "categoryId", 0);
        int page = parseIntParam(request, "page", 1);
        int size = parseIntParam(request, "size", DEFAULT_PAGE_SIZE);
        String keyword = request.getParameter("keyword");

        
        if (page < 1)
            page = 1;
        if (size < 1 || size > 24)
            size = DEFAULT_PAGE_SIZE;

        
        List<NewsCategory> categories = categoryService.getAllCategoriesWithCount();
        request.setAttribute("categories", categories);

        
        List<News> newsList;
        int totalNews;

        if (keyword != null && !keyword.trim().isEmpty()) {
            
            newsList = newsService.searchNews(keyword.trim());
            totalNews = newsList.size();
            request.setAttribute("keyword", keyword.trim());
        } else if (categoryId > 0) {
            
            newsList = newsService.getNewsByCategoryPaginated(categoryId, page, size);
            totalNews = newsService.getTotalNewsByCategory(categoryId);
            request.setAttribute("selectedCategoryId", categoryId);

            
            try {
                NewsCategory selectedCategory = categoryService.getCategoryById(categoryId);
                request.setAttribute("selectedCategory", selectedCategory);
            } catch (Exception ignored) {
                
            }
        } else {
            
            newsList = newsService.getNewsPaginated(page, size);
            totalNews = newsService.getTotalNews();
        }

        
        if (page == 1 && categoryId == 0 && (keyword == null || keyword.isEmpty())) {
            News featuredNews = newsService.getFeaturedNews();
            request.setAttribute("featuredNews", featuredNews);
        }

        
        List<News> popularNews = newsService.getPopularNews(4);
        request.setAttribute("popularNews", popularNews);

        
        int totalPages = (int) Math.ceil((double) totalNews / size);
        if (totalPages < 1)
            totalPages = 1;

        
        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalNews", totalNews);
        request.setAttribute("totalPages", totalPages);

        
        request.getRequestDispatcher("/TinTuc.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    


    private int parseIntParam(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
