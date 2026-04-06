package group36.service.payment;

import group36.model.Order;

import java.util.Map;

public interface PaymentProvider {

    String getProviderName();

    PaymentCreateResult createPayment(Order order, String callbackBaseUrl);

    PaymentIpnResult handleIpn(Map<String, Object> payload, String secretKeyHeader);
}
