package group36.service;

import group36.dao.UserDAO;
import group36.dao.UserNotificationDAO;
import group36.model.Order;
import group36.model.User;
import group36.model.UserNotification;

import java.util.ArrayList;
import java.util.List;

public class UserNotificationService {

    private final UserNotificationDAO notificationDAO;
    private final UserDAO userDAO;

    public UserNotificationService() {
        this.notificationDAO = new UserNotificationDAO();
        this.userDAO = new UserDAO();
    }

    public void createOrderStatusNotification(Order order, String oldStatus, String newStatus) {
        if (order == null || order.getUserId() == null) return;

        if (!shouldNotifyForStatus(newStatus)) return;

        UserNotification n = UserNotification.forOrderStatus(
                order.getUserId(), order.getId(), newStatus, "");
        notificationDAO.insert(n);
    }

    private boolean shouldNotifyForStatus(String status) {
        switch (status) {
            case Order.STATUS_CONFIRMED:
            case Order.STATUS_PROCESSING:
            case Order.STATUS_SHIPPING:
            case Order.STATUS_DELIVERED:
            case Order.STATUS_CANCELLED:
            case Order.STATUS_CANCELLED_BY_ADMIN:
            case Order.STATUS_DELIVERY_FAILED:
            case Order.STATUS_RETURNED:
            case Order.STATUS_REFUNDED:
                return true;
            default:
                return false;
        }
    }

    public int createFlashSaleNotificationForAll(String productName, double discountPercent) {
        List<Integer> userIds = getAllCustomerIds();
        if (userIds.isEmpty()) return 0;

        String discStr = discountPercent > 0
                ? String.format("%.0f", discountPercent) + "%" : "đặc biệt";
        String title = "⚡ Flash Sale: " + productName + " giảm " + discStr + "!";
        String message = "Nhanh tay mua ngay, số lượng có hạn!";
        String link = "/gia-tot";

        List<UserNotification> batch = buildBatch(userIds, UserNotification.TYPE_FLASH_SALE,
                title, message, link);
        notificationDAO.insertBatch(batch);
        return batch.size();
    }

    public int createCouponNotificationForAll(String couponCode, String description) {
        List<Integer> userIds = getAllCustomerIds();
        if (userIds.isEmpty()) return 0;

        String title = "🎫 Mã giảm giá mới: " + couponCode;
        String message = (description != null && !description.trim().isEmpty())
                ? description : "Áp dụng ngay để nhận ưu đãi đặc biệt!";
        String link = "/ma-giam-gia";

        List<UserNotification> batch = buildBatch(userIds, UserNotification.TYPE_COUPON,
                title, message, link);
        notificationDAO.insertBatch(batch);
        return batch.size();
    }

    public int createBroadcastNotification(String title, String message, String link) {
        List<Integer> userIds = getAllCustomerIds();
        if (userIds.isEmpty()) return 0;

        List<UserNotification> batch = buildBatch(userIds, UserNotification.TYPE_BROADCAST,
                title, message, link);
        notificationDAO.insertBatch(batch);
        return batch.size();
    }

    public List<UserNotification> getLatestForUser(int userId, int limit) {
        return notificationDAO.findByUserId(userId, limit);
    }

    public List<UserNotification> getPagedForUser(int userId, int limit, int offset) {
        return notificationDAO.findByUserIdPaginated(userId, limit, offset);
    }

    public int getUnreadCount(int userId) {
        return notificationDAO.countUnreadByUserId(userId);
    }

    public boolean markAsRead(int notificationId, int userId) {
        return notificationDAO.markAsRead(notificationId, userId) > 0;
    }

    public int markAllAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    public int cleanupOld() {
        return notificationDAO.deleteOlderThan(30);
    }

    private List<Integer> getAllCustomerIds() {
        List<User> users = userDAO.findByRole("USER");
        List<Integer> ids = new ArrayList<>();
        for (User u : users) {
            ids.add(u.getId());
        }
        return ids;
    }

    private List<UserNotification> buildBatch(List<Integer> userIds, String type,
                                               String title, String message, String link) {
        List<UserNotification> batch = new ArrayList<>();
        for (int userId : userIds) {
            batch.add(new UserNotification(userId, type, title, message, link));
        }
        return batch;
    }
}
