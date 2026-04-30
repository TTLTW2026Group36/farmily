package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.*;
import group36.service.*;

import java.io.IOException;
import java.util.List;





@WebServlet(name = "CheckoutController", urlPatterns = { "/checkout", "/thanh-toan" })
public class CheckoutController extends HttpServlet {

    private CartService cartService;
    private AddressService addressService;
    private PaymentMethodService paymentMethodService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        addressService = new AddressService();
        paymentMethodService = new PaymentMethodService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        try {
            Cart cart;
            List<Address> addresses = null;

            boolean isBuyNow = "true".equals(request.getParameter("buyNow"));
            if (isBuyNow) {
                try {
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    String vIdStr = request.getParameter("variantId");
                    Integer variantId = (vIdStr != null && !vIdStr.trim().isEmpty() && !"null".equals(vIdStr)) ? Integer.parseInt(vIdStr) : null;
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    cart = cartService.createBuyNowCart(user != null ? user.getId() : 0, productId, variantId, quantity);
                    session.setAttribute("buyNowCart", cart);
                    request.setAttribute("isBuyNow", true);

                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/san-pham");
                    return;
                }
            } else {
                session.removeAttribute("buyNowCart");
                request.setAttribute("isBuyNow", false);

                if (user != null) {
                    cart = cartService.getCartByUserId(user.getId());
                    if (cart == null || cart.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/gio-hang");
                        return;
                    }
                } else {
                    cart = (Cart) session.getAttribute("guestCart");

                    if (cart == null || cart.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/san-pham");
                        return;
                    }
                }
            }

            List<Integer> excludedProductIds = new java.util.ArrayList<>();
            for (CartItem item : cart.getItems()) {
                excludedProductIds.add(item.getProductId());
            }

            Integer recommendationUserId = user != null ? user.getId() : null;
            List<Product> recommendations = orderService.getCheckoutRecommendations(recommendationUserId, excludedProductIds, 6);
            String recommendationSource = orderService.getCheckoutRecommendationSource(recommendationUserId, recommendations);

            // Still load addresses if logged in
            if (user != null) {
                addresses = addressService.getAddressesByUserId(user.getId());
                request.setAttribute("userEmail", user.getEmail());
                request.setAttribute("userName", user.getName());
                request.setAttribute("userPhone", user.getPhone());
                request.setAttribute("isLoggedIn", true);
            } else {
                request.setAttribute("isLoggedIn", false);
            }

            List<PaymentMethod> paymentMethods = paymentMethodService.getActivePaymentMethods();

            
            double subtotal = cart.getTotalAmount();
            double shippingFee = orderService.calculateShippingFee(subtotal);
            double total = subtotal + shippingFee;

            
            request.setAttribute("cart", cart);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("recommendationSource", recommendationSource);
            request.setAttribute("addresses", addresses);
            request.setAttribute("paymentMethods", paymentMethods);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("total", total);
            request.setAttribute("freeShippingThreshold", OrderService.FREE_SHIPPING_THRESHOLD);
            request.setAttribute("pageTitle", "Thanh toán");

            
            request.getRequestDispatcher("/ThanhToan.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
