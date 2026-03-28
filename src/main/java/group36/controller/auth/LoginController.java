package group36.controller.auth;

import group36.service.FacebookAuthService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import group36.service.AuthService;
import group36.service.CartService;
import group36.service.WishlistService;
import java.io.IOException;

@WebServlet(name = "LoginController", value = { "/login", "/dang-nhap" })
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        
        if (code != null && !code.trim().isEmpty()) {
            try {
                String accessToken = group36.service.FacebookAuthService.getToken(code);
                group36.service.FacebookAuthService.FacebookAccount fbAccount = group36.service.FacebookAuthService.getUserInfo(accessToken);
                
                User user = group36.service.FacebookAuthService.loginOrRegister(fbAccount);
                
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("auth", user);
                    
                    try {
                        CartService cartService = new CartService();
                        int cartCount = cartService.getCartItemCount(user.getId());
                        session.setAttribute("cartCount", cartCount);
                    } catch (Exception e) {
                        session.setAttribute("cartCount", 0);
                    }
        
                    try {
                        WishlistService wishlistService = new WishlistService();
                        int wishlistCount = wishlistService.getWishlistCount(user.getId());
                        session.setAttribute("wishlistCount", wishlistCount);
                    } catch (Exception e) {
                        session.setAttribute("wishlistCount", 0);
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                } else {
                    request.setAttribute("error", "Failed to login with Facebook.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error connecting to Facebook: " + e.getMessage());
            }
        }
        
        request.getRequestDispatcher("/DangNhap.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String pass = request.getParameter("password");
        AuthService as = new AuthService();
        User u = as.checkLogin(username, pass);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", u);

            
            try {
                CartService cartService = new CartService();
                int cartCount = cartService.getCartItemCount(u.getId());
                session.setAttribute("cartCount", cartCount);
            } catch (Exception e) {
                session.setAttribute("cartCount", 0);
            }

            
            try {
                WishlistService wishlistService = new WishlistService();
                int wishlistCount = wishlistService.getWishlistCount(u.getId());
                session.setAttribute("wishlistCount", wishlistCount);
            } catch (Exception e) {
                session.setAttribute("wishlistCount", 0);
            }

            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/DangNhap.jsp").forward(request, response);
        }

    }
}