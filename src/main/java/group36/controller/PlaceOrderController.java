package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.*;
import group36.service.*;
import group36.service.payment.PaymentCreateResult;
import com.google.gson.Gson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "PlaceOrderController", urlPatterns = { "/place-order" })
public class PlaceOrderController extends HttpServlet {

    private OrderService orderService;
    private AddressService addressService;
    private CartService cartService;
    private PaymentService paymentService;
    private PaymentMethodService paymentMethodService;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        addressService = new AddressService();
        cartService = new CartService();
        paymentService = new PaymentService();
        paymentMethodService = new PaymentMethodService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        PrintWriter out = response.getWriter();

        try {

            String email = request.getParameter("email");
            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String street = request.getParameter("street");
            String ward = request.getParameter("ward");
            String district = request.getParameter("district");
            String city = request.getParameter("province");
            String note = request.getParameter("note");
            String paymentMethodStr = request.getParameter("payment");
            String addressIdStr = request.getParameter("addressId");

            if (isEmpty(email) || isEmpty(fullname) || isEmpty(phone) || isEmpty(street)) {
                sendError(out, "Vui lòng điền đầy đủ thông tin bắt buộc");
                return;
            }

            int paymentMethodId = 1;
            if (paymentMethodStr != null && !paymentMethodStr.isEmpty()) {
                try {
                    paymentMethodId = Integer.parseInt(paymentMethodStr);
                } catch (NumberFormatException e) {

                    switch (paymentMethodStr) {
                        case "COD":
                            paymentMethodId = 1;
                            break;
                        case "e_wallet":
                            paymentMethodId = 3;
                            break;
                        case "bank_transfer":
                            paymentMethodId = 2;
                            break;
                    }
                }
            }

            boolean isBuyNow = "true".equals(request.getParameter("isBuyNow"));

            Order order;

            if (user != null) {
                int addressId;

                if (addressIdStr != null && !addressIdStr.isEmpty() && !addressIdStr.equals("new")) {
                    addressId = Integer.parseInt(addressIdStr);
                } else {
                    Address newAddress = new Address();
                    newAddress.setUserId(user.getId());
                    newAddress.setReceiver(fullname);
                    newAddress.setAddressDetail(buildAddressDetail(street, ward));
                    newAddress.setDistrict(district);
                    newAddress.setCity(city);

                    Address created = addressService.createAddress(newAddress);
                    addressId = created.getId();
                }

                if (isBuyNow) {
                    Cart buyNowCart = (Cart) session.getAttribute("buyNowCart");
                    if (buyNowCart == null || buyNowCart.isEmpty()) {
                        sendError(out, "Phiên giao dịch Mua Ngay đã hết hạn.");
                        return;
                    }
                    order = orderService.createOrderFromItems(user.getId(), addressId, paymentMethodId, note,
                            buyNowCart.getItems());
                    session.removeAttribute("buyNowCart");
                } else {
                    order = orderService.createOrder(user.getId(), addressId, paymentMethodId, note);
                    session.setAttribute("cartCount", 0);
                }

            } else {
                Cart targetCart = isBuyNow ? (Cart) session.getAttribute("buyNowCart")
                        : (Cart) session.getAttribute("guestCart");

                if (targetCart == null || targetCart.isEmpty()) {
                    sendError(out, isBuyNow ? "Phiên giao dịch Mua Ngay đã hết hạn." : "Giỏ hàng trống");
                    return;
                }

                GuestInfo guestInfo = new GuestInfo(email, fullname, phone);

                Address shippingAddress = new Address();
                shippingAddress.setReceiver(fullname);
                shippingAddress.setAddressDetail(buildAddressDetail(street, ward));
                shippingAddress.setDistrict(district);
                shippingAddress.setCity(city);

                List<CartItem> cartItems = targetCart.getItems();

                order = orderService.createGuestOrder(guestInfo, shippingAddress,
                        paymentMethodId, note, cartItems);

                if (isBuyNow) {
                    session.removeAttribute("buyNowCart");
                } else {
                    session.removeAttribute("guestCart");
                }
            }

            session.setAttribute("lastOrderId", order.getId());

            boolean isOnlinePayment = isOnlinePaymentMethod(paymentMethodId);

            if (isOnlinePayment) {
                try {
                    PaymentCreateResult paymentResult = paymentService.createPayment(order);

                    Map<String, Object> result = new HashMap<>();
                    result.put("success", true);
                    result.put("orderId", order.getId());
                    result.put("paymentRedirect", true);
                    result.put("checkoutFormHtml", paymentResult.getCheckoutFormHtml());

                    out.print(gson.toJson(result));
                } catch (Exception e) {
                    System.err.println("[PlaceOrder] Payment creation failed: " + e.getMessage());
                    e.printStackTrace();
                    sendSuccess(out, order.getId());
                }
            } else {
                sendSuccess(out, order.getId());
            }

        } catch (IllegalArgumentException e) {
            sendError(out, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(out, "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại.");
        }
    }

    private String buildAddressDetail(String street, String ward) {
        StringBuilder sb = new StringBuilder();
        if (street != null && !street.isEmpty()) {
            sb.append(street);
        }
        if (ward != null && !ward.isEmpty()) {
            if (sb.length() > 0)
                sb.append(", ");
            sb.append(ward);
        }
        return sb.toString();
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private void sendSuccess(PrintWriter out, int orderId) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("orderId", orderId);
        result.put("redirectUrl", "/order-confirmation?id=" + orderId);
        out.print(gson.toJson(result));
    }

    private void sendError(PrintWriter out, String message) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        out.print(gson.toJson(result));
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("'", "\\'");
    }

    private boolean isOnlinePaymentMethod(int paymentMethodId) {
        try {
            Optional<PaymentMethod> pm = paymentMethodService.getPaymentMethodById(paymentMethodId);
            if (pm.isPresent()) {
                String name = pm.get().getMethodName();
                if (name != null) {
                    String lower = name.toLowerCase();
                    return lower.contains("chuyển khoản") || lower.contains("ngân hàng")
                            || lower.contains("bank") || lower.contains("online");
                }
            }
        } catch (Exception e) {
            System.err.println("[PlaceOrder] Error checking payment method: " + e.getMessage());
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}