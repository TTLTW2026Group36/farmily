package group36.service.payment;

import group36.model.Order;
import group36.model.Payment;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;

public class SepayProvider implements PaymentProvider {

    private static final String PROVIDER_NAME = "sepay";
    private static final String HMAC_ALGORITHM = "HmacSHA256";

    private final PaymentConfig config;

    public SepayProvider() {
        this.config = PaymentConfig.getInstance();
    }

    @Override
    public String getProviderName() {
        return PROVIDER_NAME;
    }

    @Override
    public PaymentCreateResult createPayment(Order order, String callbackBaseUrl) {
        String invoiceNumber = generateInvoiceNumber(order.getId());
        String paymentCode = "PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        BigDecimal amount = BigDecimal.valueOf(order.getTotalPrice());
        String amountStr = amount.setScale(0, BigDecimal.ROUND_HALF_UP).toPlainString();

        Payment payment = new Payment();
        payment.setOrderId(order.getId());
        payment.setPaymentCode(paymentCode);
        payment.setInvoiceNumber(invoiceNumber);
        payment.setProvider(PROVIDER_NAME);
        payment.setAmount(amount);
        payment.setStatus(Payment.STATUS_PENDING);

        long expiryMs = System.currentTimeMillis() + (config.getExpiryMinutes() * 60 * 1000L);
        payment.setExpiredAt(new Timestamp(expiryMs));

        String checkoutUrl;
        if (config.isSandbox()) {
            checkoutUrl = "https://pay-sandbox.sepay.vn/v1/checkout/init";
        } else {
            checkoutUrl = "https://pay.sepay.vn/v1/checkout/init";
        }

        String successUrl = callbackBaseUrl + "/order-confirmation?id=" + order.getId() + "&payment=success";
        String errorUrl = callbackBaseUrl + "/order-confirmation?id=" + order.getId() + "&payment=error";
        String cancelUrl = callbackBaseUrl + "/order-confirmation?id=" + order.getId() + "&payment=cancel";
        String description = "Thanh toan don hang Farmily #" + order.getId();

        String dataToSign = "merchant=" + config.getMerchantId() +
                ",currency=VND" +
                ",order_amount=" + amountStr +
                ",operation=PURCHASE" +
                ",order_description=" + description +
                ",order_invoice_number=" + invoiceNumber +
                ",success_url=" + successUrl +
                ",error_url=" + errorUrl +
                ",cancel_url=" + cancelUrl;

        String signature = hmacSha256Base64(config.getSecretKey(), dataToSign);

        String formHtml = buildCheckoutFormHtml(
                checkoutUrl, config.getMerchantId(), invoiceNumber,
                amountStr, "VND", "PURCHASE", description,
                successUrl, errorUrl, cancelUrl, signature);

        return new PaymentCreateResult(payment, formHtml);
    }

    @Override
    public PaymentIpnResult handleIpn(Map<String, Object> payload, String secretKeyHeader) {
        if (secretKeyHeader == null || !secretKeyHeader.equals(config.getSecretKey())) {
            System.err.println("[SepayProvider] IPN rejected: invalid secret key");
            return PaymentIpnResult.rejected("Invalid secret key");
        }
        String notificationType = getStringValue(payload, "notification_type");
        if (!"ORDER_PAID".equals(notificationType)) {
            System.out.println("[SepayProvider] IPN notification_type=" + notificationType + ", ignoring");
            return PaymentIpnResult.rejected("Unsupported notification type: " + notificationType);
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> orderData = (Map<String, Object>) payload.get("order");
        if (orderData == null) {
            return PaymentIpnResult.rejected("Missing order data in IPN");
        }

        String invoiceNumber = getStringValue(orderData, "order_invoice_number");
        String sepayOrderId = getStringValue(orderData, "order_id");
        String orderAmountStr = getStringValue(orderData, "order_amount");

        @SuppressWarnings("unchecked")
        Map<String, Object> txnData = (Map<String, Object>) payload.get("transaction");
        String transactionId = txnData != null ? getStringValue(txnData, "transaction_id") : null;
        String txnAmountStr = txnData != null ? getStringValue(txnData, "transaction_amount") : orderAmountStr;

        if (invoiceNumber == null || invoiceNumber.isEmpty()) {
            return PaymentIpnResult.rejected("Missing invoice number in IPN");
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(txnAmountStr != null ? txnAmountStr : orderAmountStr);
        } catch (NumberFormatException e) {
            return PaymentIpnResult.rejected("Invalid amount in IPN: " + txnAmountStr);
        }

        return PaymentIpnResult.builder()
                .verified(true)
                .invoiceNumber(invoiceNumber)
                .transactionId(transactionId)
                .sepayOrderId(sepayOrderId)
                .amount(amount)
                .status(Payment.STATUS_PAID)
                .build();
    }

    private String generateInvoiceNumber(int orderId) {
        return "FM-" + orderId + "-" + System.currentTimeMillis();
    }

    private String buildSignatureData(String merchantId, String invoiceNumber, String amount,
            String currency, String operation, String description,
            String successUrl, String errorUrl, String cancelUrl) {
        return "cancel_url=" + cancelUrl +
                "&currency=VND" +
                "&error_url=" + errorUrl +
                "&is_sandbox=1" +
                "&merchant=" + merchantId +
                "&operation=" + operation +
                "&order_amount=" + amount +
                "&order_description=" + description +
                "&order_invoice_number=" + invoiceNumber +
                "&success_url=" + successUrl;
    }

    private String hmacSha256Base64(String secretKey, String data) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            SecretKeySpec keySpec = new SecretKeySpec(
                    secretKey.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM);
            mac.init(keySpec);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new RuntimeException("Failed to generate HMAC-SHA256-Base64 signature", e);
        }
    }

    private String buildCheckoutFormHtml(String actionUrl, String merchantId,
            String invoiceNumber, String amount,
            String currency, String operation,
            String description,
            String success_url, String error_url,
            String cancel_url, String signature) {

        return "<form id='sepay-checkout-form' method='POST' action='" + actionUrl + "'>"
                + "<input type='hidden' name='merchant' value='" + escapeHtml(merchantId) + "'/>"
                + "<input type='hidden' name='currency' value='" + escapeHtml(currency) + "'/>"
                + "<input type='hidden' name='order_amount' value='" + escapeHtml(amount) + "'/>"
                + "<input type='hidden' name='operation' value='" + escapeHtml(operation) + "'/>"
                + "<input type='hidden' name='order_description' value='" + escapeHtml(description) + "'/>"
                + "<input type='hidden' name='order_invoice_number' value='" + escapeHtml(invoiceNumber) + "'/>"
                + "<input type='hidden' name='success_url' value='" + escapeHtml(success_url) + "'/>"
                + "<input type='hidden' name='error_url' value='" + escapeHtml(error_url) + "'/>"
                + "<input type='hidden' name='cancel_url' value='" + escapeHtml(cancel_url) + "'/>"
                + "<input type='hidden' name='signature' value='" + escapeHtml(signature) + "'/>"
                + "</form>";
    }

    private String escapeHtml(String text) {
        if (text == null)
            return "";
        return text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String getStringValue(Map<String, Object> map, String key) {
        Object val = map.get(key);
        return val != null ? val.toString() : null;
    }
}
