package group36.service;

import group36.dao.AdminNotificationDAO;
import group36.model.AdminNotification;
import group36.model.Order;
import group36.model.Product;

import java.util.List;




public class AdminNotificationService {

    private final AdminNotificationDAO notificationDAO;

    public AdminNotificationService() {
        this.notificationDAO = new AdminNotificationDAO();
    }

    


    public List<AdminNotification> getLatestNotifications(int limit) {
        return notificationDAO.findLatest(limit);
    }

    


    public List<AdminNotification> getUnreadNotifications(int limit) {
        return notificationDAO.findUnread(limit);
    }

    


    public int getUnreadCount() {
        return notificationDAO.countUnread();
    }

    


    public AdminNotification createOrderNotification(Order order) {
        AdminNotification notification = AdminNotification.forNewOrder(
                order.getId(),
                order.getCustomerName(),
                order.getTotalPrice());
        int id = notificationDAO.insert(notification);
        notification.setId(id);
        return notification;
    }

    


    public AdminNotification createOrderCancelledNotification(Order order) {
        AdminNotification notification = AdminNotification.forOrderCancelled(
                order.getId(),
                order.getCustomerName());
        int id = notificationDAO.insert(notification);
        notification.setId(id);
        return notification;
    }

    


    public AdminNotification createLowStockNotification(Product product, int currentStock) {
        AdminNotification notification = AdminNotification.forLowStock(
                product.getId(),
                product.getName(),
                currentStock);
        int id = notificationDAO.insert(notification);
        notification.setId(id);
        return notification;
    }

    


    public AdminNotification createNotification(String type, String title, String message,
            Integer referenceId, String referenceType) {
        AdminNotification notification = new AdminNotification(type, title, message);
        notification.setReferenceId(referenceId);
        notification.setReferenceType(referenceType);
        int id = notificationDAO.insert(notification);
        notification.setId(id);
        return notification;
    }

    


    public boolean markAsRead(int notificationId) {
        return notificationDAO.markAsRead(notificationId) > 0;
    }

    


    public int markAllAsRead() {
        return notificationDAO.markAllAsRead();
    }

    


    public int cleanupOldNotifications() {
        return notificationDAO.deleteOlderThan(30);
    }
}
