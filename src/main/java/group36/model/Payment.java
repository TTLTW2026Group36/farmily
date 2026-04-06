package group36.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment implements Serializable {

    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_PAID = "paid";
    public static final String STATUS_FAILED = "failed";
    public static final String STATUS_EXPIRED = "expired";

    private int id;
    private int orderId;
    private String paymentCode;
    private String invoiceNumber;
    private String provider;
    private BigDecimal amount;
    private String status;
    private String paymentUrl;
    private String rawWebhookPayload;
    private String sepayOrderId;
    private String transactionId;
    private Timestamp paidAt;
    private Timestamp expiredAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Payment() {
        this.status = STATUS_PENDING;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentUrl() {
        return paymentUrl;
    }

    public void setPaymentUrl(String paymentUrl) {
        this.paymentUrl = paymentUrl;
    }

    public String getRawWebhookPayload() {
        return rawWebhookPayload;
    }

    public void setRawWebhookPayload(String rawWebhookPayload) {
        this.rawWebhookPayload = rawWebhookPayload;
    }

    public String getSepayOrderId() {
        return sepayOrderId;
    }

    public void setSepayOrderId(String sepayOrderId) {
        this.sepayOrderId = sepayOrderId;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Timestamp getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Timestamp expiredAt) {
        this.expiredAt = expiredAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isPaid() {
        return STATUS_PAID.equals(status);
    }

    public boolean isPending() {
        return STATUS_PENDING.equals(status);
    }

    public boolean isExpired() {
        if (STATUS_EXPIRED.equals(status))
            return true;
        if (STATUS_PENDING.equals(status) && expiredAt != null) {
            return new Timestamp(System.currentTimeMillis()).after(expiredAt);
        }
        return false;
    }

    public String getStatusText() {
        switch (status) {
            case STATUS_PENDING:
                return isExpired() ? "Đã hết hạn" : "Đang chờ thanh toán";
            case STATUS_PAID:
                return "Đã thanh toán";
            case STATUS_FAILED:
                return "Thanh toán thất bại";
            case STATUS_EXPIRED:
                return "Đã hết hạn";
            default:
                return status;
        }
    }

    public String getStatusClass() {
        switch (status) {
            case STATUS_PENDING:
                return isExpired() ? "badge-danger" : "badge-warning";
            case STATUS_PAID:
                return "badge-success";
            case STATUS_FAILED:
                return "badge-danger";
            case STATUS_EXPIRED:
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }

    public String getFormattedAmount() {
        if (amount == null)
            return "0đ";
        return String.format("%,.0f", amount).replace(",", ".") + "đ";
    }

    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", invoiceNumber='" + invoiceNumber + '\'' +
                ", provider='" + provider + '\'' +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                '}';
    }
}
