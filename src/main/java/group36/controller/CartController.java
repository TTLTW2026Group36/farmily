package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Cart;
import group36.model.CartItem;
import group36.model.Product;
import group36.model.User;
import group36.service.CartService;
import group36.service.OrderService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;





@WebServlet(name = "CartController", urlPatterns = { "/gio-hang", "/cart" })
public class CartController extends HttpServlet {

    private CartService cartService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            
            session.setAttribute("redirectUrl", request.getRequestURI());
            response.sendRedirect(request.getContextPath() + "/DangNhap.jsp");
            return;
        }

        try {
            
            Cart cart = cartService.getCartByUserId(user.getId());

            
            session.setAttribute("cartCount", cart.getTotalItems());

            
            List<Integer> excludedProductIds = new ArrayList<>();
            for (CartItem item : cart.getItems()) {
                excludedProductIds.add(item.getProductId());
            }

            List<Product> recommendations = orderService.getBestSellerRecommendations(excludedProductIds, 6);

            request.setAttribute("cart", cart);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("recommendationSource", "best_seller");
            request.setAttribute("pageTitle", "Giỏ hàng");

            request.getRequestDispatcher("/GioHang.jsp").forward(request, response);

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
