package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Product;
import group36.model.Review;
import group36.model.User;
import group36.model.FlashSale;
import group36.service.FlashSaleService;
import group36.service.ProductService;
import group36.service.ReviewService;
import group36.service.WishlistService;
import group36.service.ReviewService.ReviewSummary;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailController", urlPatterns = { "/product-detail", "/chi-tiet-san-pham" })
public class ProductDetailController extends HttpServlet {

    private ProductService productService;
    private ReviewService reviewService;
    private WishlistService wishlistService;
    private FlashSaleService flashSaleService;

    private static final int REVIEWS_PER_PAGE = 5;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        reviewService = new ReviewService();
        wishlistService = new WishlistService();
        flashSaleService = new FlashSaleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = parseIntParam(request, "id", 0);

        if (productId <= 0) {
            response.sendRedirect(request.getContextPath() + "/san-pham");
            return;
        }

        try {
            Product product = productService.getProductById(productId);

            int reviewPage = parseIntParam(request, "reviewPage", 1);
            List<Review> reviews = reviewService.getReviewsByProductPaginated(
                    productId, reviewPage, REVIEWS_PER_PAGE);

            ReviewSummary reviewSummary = reviewService.getReviewSummary(productId);

            int totalReviews = reviewSummary.getTotalReviews();
            int totalReviewPages = (int) Math.ceil((double) totalReviews / REVIEWS_PER_PAGE);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewSummary", reviewSummary);
            request.setAttribute("currentReviewPage", reviewPage);
            request.setAttribute("totalReviewPages", totalReviewPages);
            request.setAttribute("reviewsPerPage", REVIEWS_PER_PAGE);

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("auth");
            boolean inWishlist = false;
            if (user != null) {
                inWishlist = wishlistService.isInWishlist(user.getId(), productId);
            }
            request.setAttribute("inWishlist", inWishlist);

            
            flashSaleService.getActiveFlashSaleForProduct(productId).ifPresent(flashSale -> {
                request.setAttribute("flashSale", flashSale);
                
                java.sql.Timestamp nearestEndTime = flashSaleService.getNearestFlashSaleEndTime();
                if (nearestEndTime != null) {
                    request.setAttribute("flashSaleEndTime", nearestEndTime.getTime());
                } else {
                    request.setAttribute("flashSaleEndTime", flashSale.getEndTime().getTime());
                }
            });

            request.setAttribute("pageTitle", product.getName() + " - Chi tiết sản phẩm");
            request.getRequestDispatcher("/ChiTietSanPham.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra");
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
