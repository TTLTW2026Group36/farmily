package group36.service.payment;

import java.math.BigDecimal;

public class PaymentIpnResult {
    private final boolean verified;
    private final String invoiceNumber;
    private final String transactionId;
    private final String sepayOrderId;
    private final BigDecimal amount;
    private final String status; // "paid", "failed"
    private final String errorMessage;

    private PaymentIpnResult(Builder b) {
        this.verified = b.verified;
        this.invoiceNumber = b.invoiceNumber;
        this.transactionId = b.transactionId;
        this.sepayOrderId = b.sepayOrderId;
        this.amount = b.amount;
        this.status = b.status;
        this.errorMessage = b.errorMessage;
    }

    public boolean isVerified() {
        return verified;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public String getSepayOrderId() {
        return sepayOrderId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getStatus() {
        return status;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static PaymentIpnResult rejected(String reason) {
        return new Builder().verified(false).errorMessage(reason).build();
    }

    public static class Builder {
        private boolean verified;
        private String invoiceNumber;
        private String transactionId;
        private String sepayOrderId;
        private BigDecimal amount;
        private String status;
        private String errorMessage;

        public Builder verified(boolean v) {
            this.verified = v;
            return this;
        }

        public Builder invoiceNumber(String v) {
            this.invoiceNumber = v;
            return this;
        }

        public Builder transactionId(String v) {
            this.transactionId = v;
            return this;
        }

        public Builder sepayOrderId(String v) {
            this.sepayOrderId = v;
            return this;
        }

        public Builder amount(BigDecimal v) {
            this.amount = v;
            return this;
        }

        public Builder status(String v) {
            this.status = v;
            return this;
        }

        public Builder errorMessage(String v) {
            this.errorMessage = v;
            return this;
        }

        public PaymentIpnResult build() {
            return new PaymentIpnResult(this);
        }
    }
}
