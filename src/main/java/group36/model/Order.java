package group36.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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

    private Address address;
    private PaymentMethod paymentMethod;
    private User user;
    private List<OrderDetail> orderDetails;

    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_PROCESSING = "processing";
    public static final String STATUS_SHIPPING = "shipping";
    public static final String STATUS_DELIVERED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";

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
                return "badge-danger";
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
