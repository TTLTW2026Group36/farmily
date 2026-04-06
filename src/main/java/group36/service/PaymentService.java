package group36.service;

import group36.dao.OrderDAO;
import group36.dao.PaymentDAO;
import group36.model.Order;
import group36.model.Payment;
import group36.service.payment.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class PaymentService {

    private final PaymentDAO paymentDAO;
    private final OrderDAO orderDAO;
    private final PaymentProvider provider;
    private final PaymentConfig config;

    public PaymentService() {
        this.paymentDAO = new PaymentDAO();
        this.orderDAO = new OrderDAO();
        this.config = PaymentConfig.getInstance();
        this.provider = new SepayProvider();
    }

    public PaymentCreateResult createPayment(Order order) {
        expireExistingPendingPayments(order.getId());

        PaymentCreateResult result = provider.createPayment(order, config.getCallbackBaseUrl());
        Payment payment = result.getPayment();

        int paymentId = paymentDAO.insert(payment);
        payment.setId(paymentId);

        orderDAO.updatePaymentStatus(order.getId(), Payment.STATUS_PENDING);

        System.out.println("[PaymentService] Created payment #" + paymentId
                + " for order #" + order.getId()
                + " invoice=" + payment.getInvoiceNumber());

        return result;
    }

    public boolean processIpn(String rawPayload, Map<String, Object> parsedPayload,
            String secretKeyHeader) {
        PaymentIpnResult ipnResult = provider.handleIpn(parsedPayload, secretKeyHeader);

        if (!ipnResult.isVerified()) {
            System.err.println("[PaymentService] IPN rejected: " + ipnResult.getErrorMessage());
            return false;
        }

        Optional<Payment> paymentOpt = paymentDAO.findByInvoiceNumber(ipnResult.getInvoiceNumber());
        if (paymentOpt.isEmpty()) {
            System.err.println("[PaymentService] IPN for unknown invoice: " + ipnResult.getInvoiceNumber());
            return false;
        }

        Payment payment = paymentOpt.get();

        if (payment.isPaid()) {
            System.out.println("[PaymentService] IPN idempotent skip: payment #" + payment.getId()
                    + " already paid");
            return true;
        }

        if (ipnResult.getAmount() != null) {
            BigDecimal ipnAmount = ipnResult.getAmount();
            if (payment.getAmount().compareTo(ipnAmount) != 0) {
                System.err.println("[PaymentService] AMOUNT MISMATCH for payment #" + payment.getId()
                        + ": expected=" + payment.getAmount() + " received=" + ipnAmount);
                paymentDAO.updateWithWebhook(
                        payment.getId(), Payment.STATUS_FAILED,
                        ipnResult.getTransactionId(), ipnResult.getSepayOrderId(), rawPayload);
                orderDAO.updatePaymentStatus(payment.getOrderId(), Payment.STATUS_FAILED);
                return false;
            }
        }

        String newStatus = ipnResult.getStatus();
        paymentDAO.updateWithWebhook(
                payment.getId(), newStatus,
                ipnResult.getTransactionId(), ipnResult.getSepayOrderId(), rawPayload);

        syncPaymentToOrder(payment.getOrderId(), newStatus);

        System.out.println("[PaymentService] IPN processed: payment #" + payment.getId()
                + " → " + newStatus + " for order #" + payment.getOrderId());

        return true;
    }

    public Optional<Payment> getLatestPayment(int orderId) {
        Optional<Payment> paymentOpt = paymentDAO.findLatestByOrderId(orderId);

        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            if (payment.isPending() && payment.isExpired()) {
                paymentDAO.updateStatus(payment.getId(), Payment.STATUS_EXPIRED);
                payment.setStatus(Payment.STATUS_EXPIRED);
                orderDAO.updatePaymentStatus(orderId, Payment.STATUS_EXPIRED);
                System.out.println("[PaymentService] Auto-expired payment #" + payment.getId());
            }
        }

        return paymentOpt;
    }

    public List<Payment> getPaymentHistory(int orderId) {
        return paymentDAO.findAllByOrderId(orderId);
    }

    private void syncPaymentToOrder(int orderId, String paymentStatus) {
        orderDAO.updatePaymentStatus(orderId, paymentStatus);

        if (Payment.STATUS_PAID.equals(paymentStatus)) {
            Optional<Order> orderOpt = orderDAO.findById(orderId);
            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                if (Order.STATUS_PENDING.equals(order.getStatus())) {
                    orderDAO.updateStatus(orderId, Order.STATUS_CONFIRMED);
                    System.out.println("[PaymentService] Order #" + orderId
                            + " confirmed after payment");
                } else {
                    System.out.println("[PaymentService] Order #" + orderId
                            + " status=" + order.getStatus()
                            + ", skipping order status update (only payment updated)");
                }
            }
        }
    }

    private void expireExistingPendingPayments(int orderId) {
        List<Payment> existing = paymentDAO.findAllByOrderId(orderId);
        for (Payment p : existing) {
            if (p.isPending()) {
                paymentDAO.updateStatus(p.getId(), Payment.STATUS_EXPIRED);
                System.out.println("[PaymentService] Expired old payment #" + p.getId()
                        + " before new attempt");
            }
        }
    }
}
