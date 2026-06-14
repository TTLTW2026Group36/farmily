package group36.service;

import group36.dao.OrderStatusHistoryDAO;
import group36.dao.RefundRequestDAO;
import group36.dao.RefundRequestImageDAO;
import group36.dao.UserDAO;
import group36.model.AdminNotification;
import group36.model.Order;
import group36.model.OrderStatusHistory;
import group36.model.RefundRequest;
import group36.model.RefundRequestImage;
import group36.model.User;

import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RefundRequestService {

    private static final int REFUND_WINDOW_HOURS = 72;

    private final RefundRequestDAO refundDAO;
    private final RefundRequestImageDAO imageDAO;
    private final OrderService orderService;
    private final OrderStatusHistoryDAO historyDAO;
    private final CloudinaryService cloudinaryService;
    private final AdminNotificationService notificationService;
    private final UserDAO userDAO;

    public RefundRequestService() {
        this.refundDAO           = new RefundRequestDAO();
        this.imageDAO            = new RefundRequestImageDAO();
        this.orderService        = new OrderService();
        this.historyDAO          = new OrderStatusHistoryDAO();
        this.cloudinaryService   = new CloudinaryService();
        this.notificationService = new AdminNotificationService();
        this.userDAO             = new UserDAO();
    }

    public boolean isEligibleForRefund(int orderId) {
        Optional<Order> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isEmpty()) return false;

        Order order = orderOpt.get();
        if (!Order.STATUS_DELIVERED.equals(order.getStatus())) return false;

        if (refundDAO.existsByOrderId(orderId)) return false;

        Timestamp completedAt = getCompletedTimestamp(orderId);
        if (completedAt == null) return false;

        long diffMs   = System.currentTimeMillis() - completedAt.getTime();
        long diffHours = diffMs / (1000L * 60 * 60);
        return diffHours <= REFUND_WINDOW_HOURS;
    }

    public Timestamp getCompletedTimestamp(int orderId) {
        Optional<OrderStatusHistory> histOpt =
                historyDAO.findByOrderIdAndNewStatus(orderId, Order.STATUS_DELIVERED);
        return histOpt.map(OrderStatusHistory::getCreatedAt).orElse(null);
    }

    public RefundRequest createRefundRequest(
            int orderId, int userId,
            String reason, String description,
            String bankName, String bankAccount, String bankHolder,
            List<Part> mediaParts) throws IOException {

        Optional<Order> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isEmpty()) {
            throw new IllegalArgumentException("Đơn hàng không tồn tại");
        }
        Order order = orderOpt.get();
        if (order.getUserId() == null || order.getUserId() != userId) {
            throw new IllegalArgumentException("Bạn không có quyền yêu cầu hoàn tiền đơn hàng này");
        }

        if (!Order.STATUS_DELIVERED.equals(order.getStatus())) {
            throw new IllegalStateException("Chỉ đơn hàng đã hoàn thành mới có thể yêu cầu hoàn tiền");
        }

        if (!isEligibleForRefund(orderId)) {
            if (refundDAO.existsByOrderId(orderId)) {
                throw new IllegalStateException("Đơn hàng này đã có yêu cầu hoàn tiền");
            }
            throw new IllegalStateException("Đã quá 72 giờ kể từ khi đơn hàng hoàn thành, không thể yêu cầu hoàn tiền");
        }

        if (refundDAO.existsByOrderId(orderId)) {
            throw new IllegalStateException("Đơn hàng này đã có yêu cầu hoàn tiền");
        }

        RefundRequest refund = new RefundRequest();
        refund.setOrderId(orderId);
        refund.setUserId(userId);
        refund.setReason(reason);
        refund.setDescription(description);
        refund.setBankName(bankName);
        refund.setBankAccount(bankAccount);
        refund.setBankHolder(bankHolder);
        refund.setRefundAmount(order.getTotalPrice());

        int refundId = refundDAO.insert(refund);
        refund.setId(refundId);

        List<CloudinaryService.UploadResult> uploaded = new ArrayList<>();
        try {
            if (mediaParts != null) {
                for (Part part : mediaParts) {
                    if (part.getSize() == 0) continue;
                    CloudinaryService.MediaType type = CloudinaryService.detectType(part.getContentType());
                    if (type == null) continue;
                    CloudinaryService.UploadResult result =
                            cloudinaryService.upload(part.getInputStream(), refundId, type);
                    uploaded.add(result);

                    RefundRequestImage img = new RefundRequestImage();
                    img.setRefundRequestId(refundId);
                    img.setImageUrl(result.getUrl());
                    img.setCloudinaryPublicId(result.getPublicId());
                    img.setMediaType(type.value());
                    imageDAO.insert(img);
                }
            }
        } catch (Exception uploadEx) {
            for (CloudinaryService.UploadResult r : uploaded) {
                try { cloudinaryService.delete(r.getPublicId(), r.getType()); }
                catch (Exception ignored) {}
            }
            imageDAO.deleteByRefundRequestId(refundId);
            throw new IOException("Lỗi upload minh chứng: " + uploadEx.getMessage(), uploadEx);
        }

        try {
            String userName = "Khách hàng";
            Optional<User> userOpt = userDAO.findById(userId);
            if (userOpt.isPresent() && userOpt.get().getName() != null) {
                userName = userOpt.get().getName();
            }
            notificationService.createNotification(
                    AdminNotification.TYPE_REFUND_REQUEST,
                    "Yêu cầu hoàn tiền mới #" + refundId,
                    userName + " gửi yêu cầu hoàn tiền cho đơn hàng #" + orderId +
                            " (" + order.getFormattedTotalPrice() + ") — Lý do: " + reason,
                    refundId,
                    "refund"
            );
        } catch (Exception notiEx) {
            System.err.println("[RefundRequestService] Failed to create notification: " + notiEx.getMessage());
        }

        return refund;
    }

    public boolean approveRefundRequest(int refundId, double refundAmount, String adminNote, int adminId) {
        Optional<RefundRequest> opt = refundDAO.findById(refundId);
        if (opt.isEmpty()) return false;

        RefundRequest refund = opt.get();
        if (!RefundRequest.STATUS_PENDING.equals(refund.getStatus())) return false;

        if (refundAmount > 0 && refundAmount != refund.getRefundAmount()) {
            refundDAO.updateRefundAmount(refundId, refundAmount);
        }

        int updated = refundDAO.updateStatus(refundId, RefundRequest.STATUS_APPROVED, adminNote);
        return updated > 0;
    }

    public boolean rejectRefundRequest(int refundId, String adminNote, int adminId) {
        Optional<RefundRequest> opt = refundDAO.findById(refundId);
        if (opt.isEmpty()) return false;

        RefundRequest refund = opt.get();
        if (!RefundRequest.STATUS_PENDING.equals(refund.getStatus())) return false;

        int updated = refundDAO.updateStatus(refundId, RefundRequest.STATUS_REJECTED, adminNote);
        return updated > 0;
    }

    public boolean confirmRefunded(int refundId, String transactionCode, int adminId) {
        Optional<RefundRequest> opt = refundDAO.findById(refundId);
        if (opt.isEmpty()) return false;

        RefundRequest refund = opt.get();
        if (!RefundRequest.STATUS_APPROVED.equals(refund.getStatus())) return false;

        int updated = refundDAO.updateConfirmRefunded(refundId, RefundRequest.STATUS_REFUNDED, transactionCode);
        if (updated == 0) return false;

        try {
            orderService.updateOrderStatus(
                    refund.getOrderId(),
                    Order.STATUS_REFUNDED,
                    "admin",
                    adminId,
                    "Hoàn tiền đã được xác nhận (RefundRequest #" + refundId + ")"
            );
        } catch (Exception e) {
            System.err.println("[RefundRequestService] Failed to update order status to refunded: " + e.getMessage());
        }

        return true;
    }

    public Optional<RefundRequest> getRefundRequestById(int id) {
        Optional<RefundRequest> opt = refundDAO.findById(id);
        opt.ifPresent(this::loadDetails);
        return opt;
    }

    public Optional<RefundRequest> getRefundRequestByOrderId(int orderId) {
        Optional<RefundRequest> opt = refundDAO.findByOrderId(orderId);
        opt.ifPresent(r -> r.setImages(imageDAO.findByRefundRequestId(r.getId())));
        return opt;
    }

    public List<RefundRequest> getRefundRequests(String statusFilter, int page, int pageSize) {
        List<RefundRequest> list;
        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
            list = refundDAO.findByStatusPaginated(statusFilter, page, pageSize);
        } else {
            list = refundDAO.findAllPaginated(page, pageSize);
        }
        list.forEach(this::loadAdminListDetails);
        return list;
    }

    public int countRefundRequests(String statusFilter) {
        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
            return refundDAO.countByStatus(statusFilter);
        }
        return refundDAO.countAll();
    }

    private void loadDetails(RefundRequest r) {
        r.setImages(imageDAO.findByRefundRequestId(r.getId()));
        orderService.getOrderById(r.getOrderId()).ifPresent(r::setOrder);
        userDAO.findById(r.getUserId()).ifPresent(r::setUser);
    }

    private void loadAdminListDetails(RefundRequest r) {
        orderService.getOrderById(r.getOrderId()).ifPresent(r::setOrder);
        userDAO.findById(r.getUserId()).ifPresent(r::setUser);
    }

    public List<RefundRequest> getRefundRequestsByUserId(int userId, int page, int pageSize) {
        List<RefundRequest> list = refundDAO.findByUserIdPaginated(userId, page, pageSize);
        list.forEach(r -> r.setImages(imageDAO.findByRefundRequestId(r.getId())));
        return list;
    }

    public int countByUserId(int userId) {
        return refundDAO.countByUserId(userId);
    }
}
