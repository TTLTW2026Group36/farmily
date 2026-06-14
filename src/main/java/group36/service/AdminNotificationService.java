package group36.service;

import group36.dao.AdminNotificationDAO;
import group36.model.AdminNotification;
import group36.model.Order;
import group36.model.Product;

import group36.dao.ProductVariantDAO;
import group36.dao.ProductDAO;
import group36.model.ProductVariant;
import java.util.Optional;
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

    public AdminNotification createChatNotification(int conversationId, String customerName) {
        AdminNotification notification = new AdminNotification();
        notification.setType(AdminNotification.TYPE_NEW_CHAT_MESSAGE);
        notification.setTitle("Tin nhắn mới từ " + customerName);
        notification.setMessage("Khách hàng " + customerName + " đã gửi tin nhắn mới");
        notification.setReferenceId(conversationId);
        notification.setReferenceType("chat");
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

    public void checkAndTriggerExpiryNotifications() {
        ProductVariantDAO variantDAO = new ProductVariantDAO();
        ProductDAO productDAO = new ProductDAO();

        List<ProductVariant> expiring = variantDAO.findExpiringVariants();
        for (ProductVariant v : expiring) {
            Optional<Product> pOpt = productDAO.findById(v.getProductId());
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                String title = "Biến thể sắp hết hạn: " + p.getName() + " (" + v.getOptionsValue() + ")";
                String message = "Biến thể \"" + v.getOptionsValue() + "\" của sản phẩm \"" + p.getName() + "\" (Tồn kho: " + v.getStock() + ") sẽ hết hạn vào ngày " + new java.text.SimpleDateFormat("dd/MM/yyyy").format(v.getExpiryDate()) + ".";
                
                if (!notificationDAO.existsByTypeReferenceAndTitle(AdminNotification.TYPE_EXPIRING_PRODUCT, p.getId(), "product", title)) {
                    createNotification(AdminNotification.TYPE_EXPIRING_PRODUCT, title, message, p.getId(), "product");
                }
            }
        }

        List<ProductVariant> expired = variantDAO.findExpiredVariants();
        for (ProductVariant v : expired) {
            Optional<Product> pOpt = productDAO.findById(v.getProductId());
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                String title = "Biến thể đã hết hạn: " + p.getName() + " (" + v.getOptionsValue() + ")";
                String message = "Biến thể \"" + v.getOptionsValue() + "\" của sản phẩm \"" + p.getName() + "\" (Tồn kho: " + v.getStock() + ") đã hết hạn sử dụng vào ngày " + new java.text.SimpleDateFormat("dd/MM/yyyy").format(v.getExpiryDate()) + ".";
                
                if (!notificationDAO.existsByTypeReferenceAndTitle(AdminNotification.TYPE_EXPIRED_PRODUCT, p.getId(), "product", title)) {
                    createNotification(AdminNotification.TYPE_EXPIRED_PRODUCT, title, message, p.getId(), "product");
                }
            }
        }
    }
}
