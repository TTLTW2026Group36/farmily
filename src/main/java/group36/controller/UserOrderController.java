package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.dao.ReviewDAO;
import group36.model.Order;
import group36.model.Review;
import group36.model.User;
import group36.service.AdminNotificationService;
import group36.service.OrderService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "UserOrderController", urlPatterns = { "/ho-so/don-hang", "/ho-so/don-hang/chi-tiet" })
public class UserOrderController extends HttpServlet {

    private OrderService orderService;
    private AdminNotificationService notificationService;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        notificationService = new AdminNotificationService();
        reviewDAO = new ReviewDAO();
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

            if (!"pending".equals(order.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Chỉ có thể hủy đơn hàng đang chờ xác nhận");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            orderService.updateOrderStatus(orderId, "cancelled");

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

            reviewDAO.insert(review);

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

            if (!"shipping".equals(order.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Chỉ xác nhận nhận hàng khi đơn đang giao");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            orderService.updateOrderStatus(orderId, "completed");

            request.getSession().setAttribute("successMessage",
                    "Xác nhận nhận hàng thành công! Bạn có thể đánh giá sản phẩm.");
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
