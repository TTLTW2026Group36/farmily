package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Order implements Serializable {
    private int id;
    private Integer userId;
    private int addressId;
    private int paymentMethodId;
    private String status;
    private String note;
    private double shippingFee;
    private double totalPrice;
    private Timestamp orderDate;

    private String guestEmail;
    private String guestName;
    private String guestPhone;

    private String paymentStatus;

    private Address address;
    private PaymentMethod paymentMethod;
    private User user;
    private List<OrderDetail> orderDetails;
    private Payment latestPayment;
    private String adminNote;
    private List<OrderStatusHistory> statusHistory;

    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_PROCESSING = "processing";
    public static final String STATUS_SHIPPING = "shipping";
    public static final String STATUS_DELIVERED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";
    public static final String STATUS_PAYMENT_EXPIRED = "payment_expired";
    public static final String STATUS_DELIVERY_FAILED = "delivery_failed";
    public static final String STATUS_RETURNED = "returned";
    public static final String STATUS_REFUNDED = "refunded";
    public static final String STATUS_CANCELLED_BY_ADMIN = "cancelled_by_admin";

    public static final Map<String, Set<String>> ALLOWED_TRANSITIONS = new HashMap<>();

    static {
        // pending
        Set<String> pendingNext = new HashSet<>();
        pendingNext.add(STATUS_CONFIRMED);
        pendingNext.add(STATUS_CANCELLED);
        pendingNext.add(STATUS_CANCELLED_BY_ADMIN);
        pendingNext.add(STATUS_PAYMENT_EXPIRED);
        ALLOWED_TRANSITIONS.put(STATUS_PENDING, pendingNext);

        // confirmed
        Set<String> confirmedNext = new HashSet<>();
        confirmedNext.add(STATUS_PROCESSING);
        confirmedNext.add(STATUS_CANCELLED_BY_ADMIN);
        ALLOWED_TRANSITIONS.put(STATUS_CONFIRMED, confirmedNext);

        // processing
        Set<String> processingNext = new HashSet<>();
        processingNext.add(STATUS_SHIPPING);
        processingNext.add(STATUS_CANCELLED_BY_ADMIN);
        ALLOWED_TRANSITIONS.put(STATUS_PROCESSING, processingNext);

        // shipping
        Set<String> shippingNext = new HashSet<>();
        shippingNext.add(STATUS_DELIVERED);
        shippingNext.add(STATUS_DELIVERY_FAILED);
        ALLOWED_TRANSITIONS.put(STATUS_SHIPPING, shippingNext);

        // delivered
        Set<String> deliveredNext = new HashSet<>();
        deliveredNext.add(STATUS_RETURNED);
        ALLOWED_TRANSITIONS.put(STATUS_DELIVERED, deliveredNext);

        // delivery_failed
        Set<String> deliveryFailedNext = new HashSet<>();
        deliveryFailedNext.add(STATUS_RETURNED);
        deliveryFailedNext.add(STATUS_REFUNDED);
        ALLOWED_TRANSITIONS.put(STATUS_DELIVERY_FAILED, deliveryFailedNext);

        // returned
        Set<String> returnedNext = new HashSet<>();
        returnedNext.add(STATUS_REFUNDED);
        ALLOWED_TRANSITIONS.put(STATUS_RETURNED, returnedNext);

        ALLOWED_TRANSITIONS.put(STATUS_CANCELLED, new HashSet<>());
        ALLOWED_TRANSITIONS.put(STATUS_CANCELLED_BY_ADMIN, new HashSet<>());
        ALLOWED_TRANSITIONS.put(STATUS_PAYMENT_EXPIRED, new HashSet<>());
        ALLOWED_TRANSITIONS.put(STATUS_REFUNDED, new HashSet<>());
    }

    public static final double FREE_SHIPPING_THRESHOLD = 100000;
    public static final double STANDARD_SHIPPING_FEE = 30000;

    public Order() {
        this.orderDetails = new ArrayList<>();
        this.status = STATUS_PENDING;
    }

    public Order(Integer userId, int addressId, int paymentMethodId, double totalPrice) {
        this.userId = userId;
        this.addressId = addressId;
        this.paymentMethodId = paymentMethodId;
        this.totalPrice = totalPrice;
        this.status = STATUS_PENDING;
        this.orderDetails = new ArrayList<>();
    }

    public static boolean isTransitionAllowed(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null)
            return false;
        if (currentStatus.equals(newStatus))
            return true;
        Set<String> allowed = ALLOWED_TRANSITIONS.get(currentStatus);
        return allowed != null && allowed.contains(newStatus);
    }

    public static Set<String> getAllowedNextStatuses(String currentStatus) {
        Set<String> allowed = ALLOWED_TRANSITIONS.get(currentStatus);
        return allowed != null ? allowed : new HashSet<>();
    }

    public static boolean isTerminalStatus(String status) {
        Set<String> allowed = ALLOWED_TRANSITIONS.get(status);
        return allowed == null || allowed.isEmpty();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public int getAddressId() {
        return addressId;
    }

    public void setAddressId(int addressId) {
        this.addressId = addressId;
    }

    public int getPaymentMethodId() {
        return paymentMethodId;
    }

    public void setPaymentMethodId(int paymentMethodId) {
        this.paymentMethodId = paymentMethodId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public List<OrderStatusHistory> getStatusHistory() {
        return statusHistory;
    }

    public void setStatusHistory(List<OrderStatusHistory> statusHistory) {
        this.statusHistory = statusHistory != null ? statusHistory : new ArrayList<>();
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestPhone() {
        return guestPhone;
    }

    public void setGuestPhone(String guestPhone) {
        this.guestPhone = guestPhone;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails != null ? orderDetails : new ArrayList<>();
    }

    public boolean isGuestOrder() {
        return userId == null;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Payment getLatestPayment() {
        return latestPayment;
    }

    public void setLatestPayment(Payment latestPayment) {
        this.latestPayment = latestPayment;
    }

    public String getPaymentMethodText() {
        if (paymentMethod == null)
            return "COD";
        String name = paymentMethod.getMethodName();
        if (name == null)
            return "COD";
        String lower = name.toLowerCase();
        if (lower.contains("chuyển khoản") || lower.contains("ngân hàng")
                || lower.contains("bank") || lower.contains("online")) {
            return "Chuyển khoản";
        }
        return "COD";
    }

    public boolean isOnlinePayment() {
        return "Chuyển khoản".equals(getPaymentMethodText());
    }

    public String getPaymentStatusText() {
        if (!isOnlinePayment()) {
            if (STATUS_DELIVERED.equals(status)) {
                return "Đã thanh toán";
            }
            return "Thanh toán khi nhận hàng";
        }
        if (paymentStatus == null || "unpaid".equals(paymentStatus))
            return "Chưa thanh toán";
        switch (paymentStatus) {
            case "pending":
                return "Đang chờ thanh toán";
            case "paid":
                return "Đã thanh toán";
            case "failed":
                return "Thanh toán thất bại";
            case "expired":
                return "Hết hạn thanh toán";
            default:
                return paymentStatus;
        }
    }

    public String getPaymentStatusBadgeClass() {
        if (!isOnlinePayment()) {
            if (STATUS_DELIVERED.equals(status)) {
                return "bento-pay-paid";
            }
            return "bento-pay-cod";
        }
        if (paymentStatus == null || "unpaid".equals(paymentStatus))
            return "bento-pay-unpaid";
        switch (paymentStatus) {
            case "pending":
                return "bento-pay-pending";
            case "paid":
                return "bento-pay-paid";
            case "failed":
                return "bento-pay-failed";
            case "expired":
                return "bento-pay-expired";
            default:
                return "bento-pay-unpaid";
        }
    }

    public static double calculateShippingFee(double subtotal) {
        return subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : STANDARD_SHIPPING_FEE;
    }

    public double getSubtotal() {
        return totalPrice - shippingFee;
    }

    public String getFormattedTotalPrice() {
        return String.format("%,.0f", totalPrice).replace(",", ".") + "đ";
    }

    public String getFormattedShippingFee() {
        if (shippingFee == 0) {
            return "Miễn phí";
        }
        return String.format("%,.0f", shippingFee).replace(",", ".") + "đ";
    }

    public String getFormattedSubtotal() {
        return String.format("%,.0f", getSubtotal()).replace(",", ".") + "đ";
    }

    public String getStatusText() {
        switch (status) {
            case STATUS_PENDING:
                return "Chờ xác nhận";
            case STATUS_CONFIRMED:
                return "Đang xử lý";
            case STATUS_PROCESSING:
                return "Đang xử lý";
            case STATUS_SHIPPING:
                return "Đang giao";
            case STATUS_DELIVERED:
                return "Hoàn thành";
            case STATUS_CANCELLED:
                return "Đã hủy";
            case STATUS_PAYMENT_EXPIRED:
                return "Thanh toán hết hạn";
            case STATUS_DELIVERY_FAILED:
                return "Giao thất bại";
            case STATUS_RETURNED:
                return "Hoàn hàng";
            case STATUS_REFUNDED:
                return "Hoàn tiền";
            case STATUS_CANCELLED_BY_ADMIN:
                return "Hủy bởi admin";
            default:
                return status;
        }
    }

    public String getStatusClass() {
        switch (status) {
            case STATUS_PENDING:
                return "badge-warning";
            case STATUS_CONFIRMED:
            case STATUS_PROCESSING:
                return "badge-info";
            case STATUS_SHIPPING:
                return "badge-primary";
            case STATUS_DELIVERED:
                return "badge-success";
            case STATUS_CANCELLED:
            case STATUS_PAYMENT_EXPIRED:
            case STATUS_CANCELLED_BY_ADMIN:
                return "badge-danger";
            case STATUS_DELIVERY_FAILED:
                return "badge-warning";
            case STATUS_RETURNED:
                return "badge-info";
            case STATUS_REFUNDED:
                return "badge-secondary";
            default:
                return "badge-secondary";
        }
    }

    public int getTotalItems() {
        if (orderDetails == null || orderDetails.isEmpty()) {
            return 0;
        }
        return orderDetails.stream()
                .mapToInt(OrderDetail::getQuantity)
                .sum();
    }

    public String getCustomerName() {
        if (isGuestOrder()) {
            return guestName;
        }
        return user != null ? user.getName() : "";
    }

    public String getCustomerEmail() {
        if (isGuestOrder()) {
            return guestEmail;
        }
        return user != null ? user.getEmail() : "";
    }

    public String getCustomerPhone() {
        if (isGuestOrder()) {
            return guestPhone;
        }
        return user != null ? user.getPhone() : "";
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", status='" + status + '\'' +
                ", totalPrice=" + totalPrice +
                ", shippingFee=" + shippingFee +
                ", orderDate=" + orderDate +
                ", itemCount=" + (orderDetails != null ? orderDetails.size() : 0) +
                '}';
    }
}
