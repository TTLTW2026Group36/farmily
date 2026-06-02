package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.dao.ReviewDAO;
import group36.model.User;
import group36.model.AdminNotification;
import group36.service.AdminNotificationService;
import java.io.IOException;

@WebServlet(name = "ReviewReportController", urlPatterns = { "/api/review/report" })
public class ReviewReportController extends HttpServlet {
    
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() { reviewDAO = new ReviewDAO(); }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        // Chỉ user đã login mới report được
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"Vui lòng đăng nhập\"}");
            return;
        }
        
        String reviewIdStr = request.getParameter("reviewId");
        if (reviewIdStr == null) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"Thiếu reviewId\"}");
            return;
        }
        
        int reviewId = Integer.parseInt(reviewIdStr);
        reviewDAO.incrementReportCount(reviewId);

        try {
            AdminNotificationService notificationService = new AdminNotificationService();
            notificationService.createNotification(
                AdminNotification.TYPE_REVIEW_REPORTED,
                "Đánh giá bị báo cáo vi phạm",
                "Khách hàng \"" + user.getName() + "\" đã báo cáo vi phạm đánh giá #" + reviewId + ".",
                reviewId,
                "review"
            );
        } catch (Exception notiEx) {
            System.err.println("[ReviewReportController] Failed to create report notification: " + notiEx.getMessage());
        }
        
        response.getWriter().write("{\"success\":true,\"message\":\"Đã báo cáo đánh giá\"}");
    }
}
