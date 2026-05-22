package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import group36.dao.ReviewDAO;
import group36.dao.ReviewImageDAO;
import group36.model.Order;
import group36.model.Review;
import group36.model.ReviewImage;
import group36.model.User;
import group36.service.AdminNotificationService;
import group36.service.CloudinaryService;
import group36.service.OrderService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@WebServlet(name = "UserOrderController", urlPatterns = { "/ho-so/don-hang", "/ho-so/don-hang/chi-tiet" })
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10L * 1024 * 1024,
        maxRequestSize = 70L * 1024 * 1024)
public class UserOrderController extends HttpServlet {

    private static final int MAX_IMAGES = 5;
    private static final int MAX_VIDEOS = 1;
    private static final long MAX_FILE_SIZE = 10L * 1024 * 1024;
    private static final Set<String> ALLOWED_IMAGE_MIMES = Set.of(
            "image/jpeg", "image/png", "image/webp", "image/gif");
    private static final Set<String> ALLOWED_VIDEO_MIMES = Set.of(
            "video/mp4", "video/quicktime", "video/webm");

    private OrderService orderService;
    private AdminNotificationService notificationService;
    private ReviewDAO reviewDAO;
    private ReviewImageDAO reviewImageDAO;
    private CloudinaryService cloudinaryService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        notificationService = new AdminNotificationService();
        reviewDAO = new ReviewDAO();
        reviewImageDAO = new ReviewImageDAO();
        cloudinaryService = new CloudinaryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("auth");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap?redirect=" +
                    java.net.URLEncoder.encode(request.getRequestURI(), "UTF-8"));
            return;
        }

        String servletPath = request.getServletPath();

        try {
            if ("/ho-so/don-hang/chi-tiet".equals(servletPath)) {

                handleOrderDetail(request, response, currentUser);
            } else {

                handleOrderList(request, response, currentUser);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra");
        }
    }

    private void handleOrderList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");

        List<Order> orders = orderService.getOrdersByUserId(user.getId());

        if ("review".equals(statusFilter)) {
            orders = orders.stream()
                    .filter(o -> "completed".equals(o.getStatus()))
                    .toList();

            Map<Integer, Map<Integer, Review>> orderReviewMaps = new HashMap<>();
            for (Order order : orders) {
                List<Review> reviews = reviewDAO.findByOrderIdAndUserId(order.getId(), user.getId());
                for (Review r : reviews) {
                    r.setImages(reviewImageDAO.findByReviewId(r.getId()));
                }
                Map<Integer, Review> productReviewMap = new HashMap<>();
                for (Review r : reviews) {
                    productReviewMap.put(r.getProductId(), r);
                }
                orderReviewMaps.put(order.getId(), productReviewMap);
            }
            request.setAttribute("orderReviewMaps", orderReviewMaps);
        } else if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
            orders = orders.stream()
                    .filter(o -> statusFilter.equals(o.getStatus()))
                    .toList();
        }

        List<Order> allOrders = orderService.getOrdersByUserId(user.getId());
        int countAll = allOrders.size();
        int countPending = (int) allOrders.stream().filter(o -> "pending".equals(o.getStatus())).count();
        int countProcessing = (int) allOrders.stream().filter(o -> "processing".equals(o.getStatus())).count();
        int countShipping = (int) allOrders.stream().filter(o -> "shipping".equals(o.getStatus())).count();
        int countCompleted = (int) allOrders.stream().filter(o -> "completed".equals(o.getStatus())).count();
        int countCancelled = (int) allOrders.stream().filter(o -> "cancelled".equals(o.getStatus())).count();

        request.setAttribute("orders", orders);
        request.setAttribute("currentStatus", statusFilter != null ? statusFilter : "all");
        request.setAttribute("countAll", countAll);
        request.setAttribute("countPending", countPending);
        request.setAttribute("countProcessing", countProcessing);
        request.setAttribute("countShipping", countShipping);
        request.setAttribute("countCompleted", countCompleted);
        request.setAttribute("countCancelled", countCancelled);
        request.setAttribute("pageTitle", "Đơn hàng của bạn");
        request.setAttribute("activeTab", "orders");

        request.getRequestDispatcher("/DonHangList.jsp").forward(request, response);
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("id");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {

                request.setAttribute("error", "Đơn hàng không tồn tại");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            Order order = orderOpt.get();

            if (order.getUserId() == null || order.getUserId() != user.getId()) {
                request.setAttribute("error", "Bạn không có quyền xem đơn hàng này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            List<Review> existingReviews = reviewDAO.findByOrderIdAndUserId(orderId, user.getId());
            Map<Integer, Review> reviewMap = new HashMap<>();
            for (Review r : existingReviews) {
                r.setImages(reviewImageDAO.findByReviewId(r.getId()));
                reviewMap.put(r.getProductId(), r);
            }

            request.setAttribute("order", order);
            request.setAttribute("reviewMap", reviewMap);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + orderId);
            request.setAttribute("activeTab", "orders");

            request.getRequestDispatcher("/DonHangChiTiet.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("auth");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String action = request.getParameter("action");

        if ("cancel".equals(action)) {
            handleCancelOrder(request, response, currentUser);
        } else if ("confirm-received".equals(action)) {
            handleConfirmReceived(request, response, currentUser);
        } else if ("review".equals(action)) {
            handleSubmitReview(request, response, currentUser);
        } else if ("editReview".equals(action)) {
            handleEditReview(request, response, currentUser);
        } else {
            doGet(request, response);
        }
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Đơn hàng không tồn tại");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            Order order = orderOpt.get();

            if (order.getUserId() == null || order.getUserId() != user.getId()) {
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền hủy đơn hàng này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                reason = "Người dùng hủy đơn hàng";
            }

            boolean updated = orderService.cancelOrderByUser(orderId, user.getId(), reason);

            if (!updated) {
                request.getSession().setAttribute("errorMessage", "Không thể hủy đơn hàng (trạng thái không cho phép)");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            try {
                notificationService.createOrderCancelledNotification(order);
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.getSession().setAttribute("successMessage", "Đã hủy đơn hàng thành công");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi hủy đơn hàng");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }

    private void handleSubmitReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        String productIdStr = request.getParameter("productId");
        String variantIdStr = request.getParameter("variantId");
        String ratingStr = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");

        if (orderIdStr == null || productIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                request.getSession().setAttribute("errorMessage", "Số sao không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            if (reviewText == null || reviewText.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Nội dung đánh giá không được để trống");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            Optional<Order> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty() || orderOpt.get().getUserId() == null
                    || orderOpt.get().getUserId() != user.getId()) {
                request.getSession().setAttribute("errorMessage", "Không có quyền đánh giá đơn hàng này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            Order order = orderOpt.get();
            if (!"completed".equals(order.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Chỉ được đánh giá khi đơn hàng đã hoàn thành");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            if (reviewDAO.existsByUserAndOrderAndProduct(user.getId(), orderId, productId)) {
                request.getSession().setAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này rồi");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            Review review = new Review();
            review.setUserId(user.getId());
            review.setProductId(productId);
            review.setOrderId(orderId);
            review.setRating(rating);
            review.setReviewText(reviewText.trim());

            if (variantIdStr != null && !variantIdStr.isEmpty()) {
                review.setVariantId(Integer.parseInt(variantIdStr));
            }


            List<Part> mediaParts = collectMediaParts(request);
            String validationError = validateMedia(mediaParts);
            if (validationError != null) {
                request.getSession().setAttribute("errorMessage", validationError);
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            int reviewId = reviewDAO.insert(review);


            List<CloudinaryService.UploadResult> uploaded = new ArrayList<>();
            try {
                for (Part part : mediaParts) {
                    CloudinaryService.MediaType type = CloudinaryService.detectType(part.getContentType());
                    if (type == null) continue;

                    CloudinaryService.UploadResult result = cloudinaryService.upload(
                            part.getInputStream(), reviewId, type);
                    uploaded.add(result);

                    ReviewImage img = new ReviewImage();
                    img.setReviewId(reviewId);
                    img.setImageUrl(result.getUrl());
                    img.setCloudinaryPublicId(result.getPublicId());
                    img.setMediaType(type.value());
                    reviewImageDAO.insert(img);
                }
            } catch (Exception uploadEx) {

                for (CloudinaryService.UploadResult r : uploaded) {
                    try {
                        cloudinaryService.delete(r.getPublicId(), r.getType());
                    } catch (Exception deleteEx) {
                        System.err.println("[Cloudinary] Failed to delete orphan: " + r.getPublicId()
                                + " — " + deleteEx.getMessage());
                    }
                }
                reviewDAO.delete(reviewId);
                throw uploadEx;
            }

            String returnTo = request.getParameter("returnTo");
            request.getSession().setAttribute("successMessage", "Đánh giá sản phẩm thành công!");
            if ("review".equals(returnTo)) {
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang?status=review");
            } else {
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi gửi đánh giá");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }

    private void handleEditReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String reviewIdStr = request.getParameter("reviewId");
        String orderIdStr = request.getParameter("orderId");
        String ratingStr = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");

        if (reviewIdStr == null || orderIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            int orderId = Integer.parseInt(orderIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                request.getSession().setAttribute("errorMessage", "Số sao không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            if (reviewText == null || reviewText.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Nội dung đánh giá không được để trống");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            Optional<Review> reviewOpt = reviewDAO.findById(reviewId);
            if (reviewOpt.isEmpty() || reviewOpt.get().getUserId() != user.getId()) {
                request.getSession().setAttribute("errorMessage", "Không có quyền sửa đánh giá này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            Review existing = reviewOpt.get();
            if (existing.getEditCount() >= 1) {
                request.getSession().setAttribute("errorMessage", "Bạn đã chỉnh sửa đánh giá này rồi");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            List<Part> mediaParts = collectMediaParts(request);
            String validationError = validateMedia(mediaParts);
            if (validationError != null) {
                request.getSession().setAttribute("errorMessage", validationError);
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }


            List<ReviewImage> oldImages = reviewImageDAO.findByReviewId(reviewId);


            List<CloudinaryService.UploadResult> uploaded = new ArrayList<>();
            try {
                for (Part part : mediaParts) {
                    CloudinaryService.MediaType type = CloudinaryService.detectType(part.getContentType());
                    if (type == null) continue;
                    CloudinaryService.UploadResult result = cloudinaryService.upload(
                            part.getInputStream(), reviewId, type);
                    uploaded.add(result);
                }
            } catch (Exception uploadEx) {
                for (CloudinaryService.UploadResult r : uploaded) {
                    try { cloudinaryService.delete(r.getPublicId(), r.getType()); }
                    catch (Exception ignored) {}
                }
                request.getSession().setAttribute("errorMessage", "Lỗi upload media: " + uploadEx.getMessage());
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }


            int updated = reviewDAO.updateIfNotEdited(reviewId, rating, reviewText.trim());
            if (updated == 0) {

                for (CloudinaryService.UploadResult r : uploaded) {
                    try { cloudinaryService.delete(r.getPublicId(), r.getType()); }
                    catch (Exception ignored) {}
                }
                request.getSession().setAttribute("errorMessage", "Đánh giá đã được chỉnh sửa, không thể sửa lại");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }


            reviewImageDAO.deleteByReviewId(reviewId);
            for (CloudinaryService.UploadResult r : uploaded) {
                ReviewImage img = new ReviewImage();
                img.setReviewId(reviewId);
                img.setImageUrl(r.getUrl());
                img.setCloudinaryPublicId(r.getPublicId());
                img.setMediaType(r.getType().value());
                reviewImageDAO.insert(img);
            }


            for (ReviewImage old : oldImages) {
                if (old.getCloudinaryPublicId() != null) {
                    try {
                        CloudinaryService.MediaType oldType = old.isVideo()
                                ? CloudinaryService.MediaType.VIDEO
                                : CloudinaryService.MediaType.IMAGE;
                        cloudinaryService.delete(old.getCloudinaryPublicId(), oldType);
                    } catch (Exception e) {
                        System.err.println("[Cloudinary] Failed to delete orphan: "
                                + old.getCloudinaryPublicId() + " — " + e.getMessage());
                    }
                }
            }

            request.getSession().setAttribute("successMessage", "Cập nhật đánh giá thành công!");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật đánh giá");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }

    private List<Part> collectMediaParts(HttpServletRequest request) throws ServletException, IOException {
        List<Part> parts = new ArrayList<>();
        Collection<Part> all;
        try {
            all = request.getParts();
        } catch (IllegalStateException e) {

            return parts;
        }
        for (Part p : all) {
            if ("mediaFiles".equals(p.getName()) && p.getSize() > 0) {
                parts.add(p);
            }
        }
        return parts;
    }

    private String validateMedia(List<Part> parts) {
        int imageCount = 0, videoCount = 0;
        for (Part p : parts) {
            if (p.getSize() > MAX_FILE_SIZE) {
                return "File '" + p.getSubmittedFileName() + "' vượt quá 10MB";
            }
            String mime = p.getContentType();
            if (ALLOWED_IMAGE_MIMES.contains(mime)) imageCount++;
            else if (ALLOWED_VIDEO_MIMES.contains(mime)) videoCount++;
            else return "Định dạng file không hỗ trợ: " + mime;
        }
        if (imageCount > MAX_IMAGES) return "Tối đa " + MAX_IMAGES + " ảnh";
        if (videoCount > MAX_VIDEOS) return "Tối đa " + MAX_VIDEOS + " video";
        return null;
    }

    private void handleConfirmReceived(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Đơn hàng không tồn tại");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            Order order = orderOpt.get();

            if (order.getUserId() == null || order.getUserId() != user.getId()) {
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền thao tác đơn hàng này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            boolean updated = orderService.confirmReceivedByUser(orderId, user.getId());

            if (!updated) {
                request.getSession().setAttribute("errorMessage",
                        "Không thể xác nhận nhận hàng (trạng thái không cho phép)");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            request.getSession().setAttribute("successMessage", "Xác nhận nhận hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xác nhận nhận hàng");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }
}
