package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.CartItem;
import group36.model.User;
import group36.service.CartService;

import java.io.IOException;
import java.io.PrintWriter;





@WebServlet(name = "AddToCartController", urlPatterns = { "/api/cart", "/api/cart/*" })
public class AddToCartController extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            out.print("{\"success\":true,\"count\":0}");
            return;
        }

        try {
            int count = cartService.getCartItemCount(user.getId());
            session.setAttribute("cartCount", count);
            out.print("{\"success\":true,\"count\":" + count + "}");
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(
                    "{\"success\":false,\"message\":\"Vui lòng đăng nhập để thêm vào giỏ hàng\",\"requireLogin\":true}");
            return;
        }

        try {
            
            int productId = parseIntParam(request, "productId", 0);
            Integer variantId = parseNullableIntParam(request, "variantId");
            int quantity = parseIntParam(request, "quantity", 1);

            if (productId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"ID sản phẩm không hợp lệ\"}");
                return;
            }

            
            CartItem item = cartService.addToCart(user.getId(), productId, variantId, quantity);

            
            int cartCount = cartService.getCartItemCount(user.getId());
            session.setAttribute("cartCount", cartCount);

            
            out.print("{\"success\":true,\"message\":\"Đã thêm vào giỏ hàng\"," +
                    "\"item\":{" +
                    "\"id\":" + item.getId() + "," +
                    "\"productName\":\"" + escapeJson(item.getProductName()) + "\"," +
                    "\"variantText\":\"" + escapeJson(item.getVariantText()) + "\"," +
                    "\"quantity\":" + item.getQuantity() + "," +
                    "\"unitPrice\":" + item.getUnitPrice() + "," +
                    "\"subtotal\":" + item.getSubtotal() +
                    "}," +
                    "\"cartCount\":" + cartCount + "}");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    



    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            int itemId = parseIntParam(request, "itemId", 0);
            Integer variantId = parseNullableIntParam(request, "variantId");
            Integer quantity = parseNullableIntParam(request, "quantity");

            if (itemId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"ID item không hợp lệ\"}");
                return;
            }

            CartItem item = null;

            
            if (variantId != null) {
                item = cartService.updateVariant(user.getId(), itemId, variantId);
            }

            
            if (quantity != null && quantity > 0) {
                item = cartService.updateQuantity(user.getId(), itemId, quantity);
            }

            if (item == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Không có thay đổi nào được thực hiện\"}");
                return;
            }

            
            int cartCount = cartService.getCartItemCount(user.getId());
            session.setAttribute("cartCount", cartCount);

            out.print("{\"success\":true,\"message\":\"Đã cập nhật giỏ hàng\"," +
                    "\"item\":{" +
                    "\"id\":" + item.getId() + "," +
                    "\"productId\":" + item.getProductId() + "," +
                    "\"variantId\":" + (item.getVariantId() != null ? item.getVariantId() : "null") + "," +
                    "\"variantText\":\"" + escapeJson(item.getVariantText()) + "\"," +
                    "\"quantity\":" + item.getQuantity() + "," +
                    "\"unitPrice\":" + item.getUnitPrice() + "," +
                    "\"subtotal\":" + item.getSubtotal() +
                    "}," +
                    "\"cartCount\":" + cartCount + "}");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    


    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            int itemId = parseIntParam(request, "itemId", 0);

            if (itemId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"ID item không hợp lệ\"}");
                return;
            }

            cartService.removeItem(user.getId(), itemId);

            
            int cartCount = cartService.getCartItemCount(user.getId());
            session.setAttribute("cartCount", cartCount);

            out.print(
                    "{\"success\":true,\"message\":\"Đã xóa sản phẩm khỏi giỏ hàng\",\"cartCount\":" + cartCount + "}");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    

    private int parseIntParam(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private Integer parseNullableIntParam(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
