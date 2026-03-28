package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.dao.WishlistDAO;
import group36.model.FlashSale;
import group36.model.Category;
import group36.model.Product;
import group36.model.News;
import group36.model.User;
import group36.model.Wishlist;
import group36.service.FlashSaleService;
import group36.service.CategoryService;
import group36.service.ProductService;
import group36.service.NewsService;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "HomeController", urlPatterns = { "", "/home", "/trang-chu" })
public class HomeController extends HttpServlet {

    private FlashSaleService flashSaleService;
    private CategoryService categoryService;
    private ProductService productService;
    private NewsService newsService;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        flashSaleService = new FlashSaleService();
        categoryService = new CategoryService();
        productService = new ProductService();
        newsService = new NewsService();
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        if (servletPath == null || servletPath.isEmpty() || servletPath.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        List<FlashSale> flashSales = flashSaleService.getActiveFlashSales(10);
        request.setAttribute("flashSales", flashSales);

        Timestamp flashSaleEndTime = flashSaleService.getNearestFlashSaleEndTime();
        if (flashSaleEndTime != null) {
            request.setAttribute("flashSaleEndTime", flashSaleEndTime.getTime());
        }

        List<Product> bestSellers = productService.getBestSellingProducts(8);
        request.setAttribute("bestSellers", bestSellers);

        List<Product> newProducts = productService.getNewestProducts(8);
        request.setAttribute("newProducts", newProducts);

        List<News> recentNews = newsService.getRecentNews(3);
        request.setAttribute("recentNews", recentNews);

        HttpSession session = request.getSession(false);
        Set<Integer> wishlistProductIds = new HashSet<>();
        if (session != null) {
            User user = (User) session.getAttribute("auth");
            if (user != null) {
                List<Wishlist> wishlistItems = wishlistDAO.findByUserId(user.getId());
                for (Wishlist item : wishlistItems) {
                    wishlistProductIds.add(item.getProductId());
                }
            }
        }
        request.setAttribute("wishlistProductIds", wishlistProductIds);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
