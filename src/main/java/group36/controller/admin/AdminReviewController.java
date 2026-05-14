package group36.controller.admin;

import group36.dao.ProductDAO;
import group36.dao.ReviewDAO;
import group36.model.Product;
import group36.model.Review;
import group36.service.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewController extends HttpServlet {

    private ReviewDAO reviewDAO;
    private ReviewService reviewService;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        reviewService = new ReviewService();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "all";
        }

        String search = request.getParameter("search");
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");

        Integer productId = null;
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Integer rating = null;
        if (ratingStr != null && !ratingStr.isEmpty()) {
            try {
                rating = Integer.parseInt(ratingStr);
            } catch (NumberFormatException ignored) {
            }
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }
        int pageSize = 10;

        List<Review> reviews;
        int totalReviews;

        if ("reported".equals(status)) {
            reviews = reviewDAO.findReported(page, pageSize);
            totalReviews = reviewDAO.countReported();
        } else {
            reviews = reviewDAO.findAllForAdmin(status, productId, rating, search, page, pageSize);
            totalReviews = reviewDAO.countAllForAdmin(status, productId, rating, search);
        }

        reviewService.loadReviewDetailsForAdmin(reviews);

        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        request.setAttribute("reviews", reviews);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentStatus", status);

        request.setAttribute("countAll", reviewDAO.countAllForAdmin("all", null, null, null));
        request.setAttribute("countPending", reviewDAO.countByStatus(Review.STATUS_PENDING));
        request.setAttribute("countApproved", reviewDAO.countByStatus(Review.STATUS_APPROVED));
        request.setAttribute("countRejected", reviewDAO.countByStatus(Review.STATUS_REJECTED));
        request.setAttribute("countHidden", reviewDAO.countByStatus(Review.STATUS_HIDDEN));
        request.setAttribute("countReported", reviewDAO.countReported());

        List<Product> products = productDAO.findAll();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String reviewIdStr = request.getParameter("reviewId");
        HttpSession session = request.getSession();

        if (action == null || reviewIdStr == null) {
            session.setAttribute("errorMsg", "Thiếu thông tin bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
            return;
        }

        int reviewId;
        try {
            reviewId = Integer.parseInt(reviewIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "ID đánh giá không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
            return;
        }

        boolean success = false;
        String msg = "";

        switch (action) {
            case "approve":
                success = reviewService.approveReview(reviewId);
                msg = success ? "Đã duyệt đánh giá thành công!" : "Duyệt đánh giá thất bại!";
                break;
            case "reject":
                success = reviewService.rejectReview(reviewId);
                msg = success ? "Đã từ chối đánh giá!" : "Từ chối đánh giá thất bại!";
                break;
            case "hide":
                success = reviewService.hideReview(reviewId);
                msg = success ? "Đã ẩn đánh giá!" : "Ẩn đánh giá thất bại!";
                break;
            case "delete":
                int rows = reviewDAO.delete(reviewId);
                success = rows > 0;
                msg = success ? "Đã xóa đánh giá vĩnh viễn!" : "Xóa đánh giá thất bại!";
                break;
            default:
                msg = "Hành động không hợp lệ!";
        }

        if (success) {
            session.setAttribute("successMsg", msg);
        } else {
            session.setAttribute("errorMsg", msg);
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/admin/reviews")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        }
    }
}
