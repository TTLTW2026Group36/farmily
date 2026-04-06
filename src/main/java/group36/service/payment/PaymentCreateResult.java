package group36.service.payment;

import group36.model.Payment;

public class PaymentCreateResult {
    private final Payment payment;
    private final String checkoutFormHtml;

    public PaymentCreateResult(Payment payment, String checkoutFormHtml) {
        this.payment = payment;
        this.checkoutFormHtml = checkoutFormHtml;
    }

    public Payment getPayment() {
        return payment;
    }

    public String getCheckoutFormHtml() {
        return checkoutFormHtml;
    }
}
