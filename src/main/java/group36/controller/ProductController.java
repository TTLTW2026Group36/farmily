package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.dao.WishlistDAO;
import group36.model.Category;
import group36.model.Product;
import group36.model.User;
import group36.model.Wishlist;
import group36.service.CategoryService;
import group36.service.ProductService;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ProductController", urlPatterns = { "/san-pham", "/products" })
public class ProductController extends HttpServlet {

    private ProductService productService;
    private CategoryService categoryService;
    private WishlistDAO wishlistDAO;

    private static final int DEFAULT_PAGE_SIZE = 12;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryService = new CategoryService();
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int categoryId = parseIntParam(request, "categoryId", 0);
        int page = parseIntParam(request, "page", 1);
        int size = parseIntParam(request, "size", DEFAULT_PAGE_SIZE);
        String sort = request.getParameter("sort");
        String keyword = request.getParameter("keyword");

        if (page < 1)
            page = 1;
        if (size < 1 || size > 48)
            size = DEFAULT_PAGE_SIZE;

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        List<Product> products;
        int totalProducts;

        if (keyword != null && !keyword.trim().isEmpty()) {

            products = productService.searchProducts(keyword.trim());
            totalProducts = products.size();
            request.setAttribute("keyword", keyword.trim());
        } else if (categoryId > 0) {

            products = productService.getProductsByCategoryPaginatedSorted(categoryId, page, size, sort);
            totalProducts = productService.getTotalProductsByCategory(categoryId);
            request.setAttribute("selectedCategoryId", categoryId);

            try {
                Category selectedCategory = categoryService.getCategoryById(categoryId);
                request.setAttribute("selectedCategory", selectedCategory);
            } catch (Exception ignored) {

            }
        } else {

            products = productService.getProductsPaginatedSorted(page, size, sort);
            totalProducts = productService.getTotalProducts();
        }

        int totalPages = (int) Math.ceil((double) totalProducts / size);
        if (totalPages < 1)
            totalPages = 1;

        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentSort", sort != null ? sort : "default");

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

        request.getRequestDispatcher("/SanPham.jsp").forward(request, response);
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
