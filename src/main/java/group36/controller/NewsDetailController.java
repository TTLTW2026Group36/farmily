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





@WebServlet(name = "NewsDetailController", urlPatterns = { "/chi-tiet-tin-tuc", "/news/detail" })
public class NewsDetailController extends HttpServlet {

    private NewsService newsService;
    private NewsCategoryService categoryService;

    @Override
    public void init() throws ServletException {
        newsService = new NewsService();
        categoryService = new NewsCategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        int newsId = parseIntParam(request, "id", 0);

        if (newsId <= 0) {
            
            response.sendRedirect(request.getContextPath() + "/tintuc");
            return;
        }

        try {
            
            News news = newsService.getPublishedNewsById(newsId);
            request.setAttribute("news", news);

            
            List<News> relatedNews = newsService.getRelatedNews(
                    newsId,
                    news.getCategoryId(),
                    3);
            request.setAttribute("relatedNews", relatedNews);

            
            List<News> popularNews = newsService.getPopularNews(4);
            request.setAttribute("popularNews", popularNews);

            
            List<NewsCategory> categories = categoryService.getAllCategoriesWithCount();
            request.setAttribute("categories", categories);

            
            request.getRequestDispatcher("/ChiTietTinTuc.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            
            response.sendRedirect(request.getContextPath() + "/tintuc");
        }
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
