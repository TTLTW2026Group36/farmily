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
import java.io.PrintWriter;
import java.util.List;





@WebServlet(name = "PlaceOrderController", urlPatterns = { "/place-order" })
public class PlaceOrderController extends HttpServlet {

    private OrderService orderService;
    private AddressService addressService;
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        addressService = new AddressService();
        cartService = new CartService();
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

                
                order = orderService.createOrder(user.getId(), addressId, paymentMethodId, note);

                
                session.setAttribute("cartCount", 0);

            } else {
                
                @SuppressWarnings("unchecked")
                Cart guestCart = (Cart) session.getAttribute("guestCart");

                if (guestCart == null || guestCart.isEmpty()) {
                    sendError(out, "Giỏ hàng trống");
                    return;
                }

                
                GuestInfo guestInfo = new GuestInfo(email, fullname, phone);

                
                Address shippingAddress = new Address();
                shippingAddress.setReceiver(fullname);
                shippingAddress.setAddressDetail(buildAddressDetail(street, ward));
                shippingAddress.setDistrict(district);
                shippingAddress.setCity(city);

                
                List<CartItem> cartItems = guestCart.getItems();

                
                order = orderService.createGuestOrder(guestInfo, shippingAddress,
                        paymentMethodId, note, cartItems);

                
                session.removeAttribute("guestCart");
            }

            
            session.setAttribute("lastOrderId", order.getId());

            
            sendSuccess(out, order.getId());

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
        out.print("{\"success\":true,\"orderId\":" + orderId + ",\"redirectUrl\":\"/order-confirmation?id=" + orderId
                + "\"}");
    }

    private void sendError(PrintWriter out, String message) {
        out.print("{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
