package group36.controller.auth;

import group36.dao.RefreshTokenDao;
import group36.service.*;
import group36.util.FarmilyConstants;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet(name = "LoginController", value = { "/login", "/dang-nhap" })
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code != null && !code.trim().isEmpty()) {
            try {
                User user = null;
                if (request.getParameter("scope") != null) {
                    String accessToken = GoogleAuthService.getToken(code);
                    GoogleAuthService.GoogleAccount ggAcc = GoogleAuthService.getUserInfo(accessToken);
                    user = GoogleAuthService.loginOrRegister(ggAcc);
                } else {
                    String accessToken = FacebookAuthService.getToken(code);
                    FacebookAuthService.FacebookAccount fbAccount = FacebookAuthService.getUserInfo(accessToken);
                    user = FacebookAuthService.loginOrRegister(fbAccount);
                }
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
                request.setAttribute("error", "Error connecting to provider: " + e.getMessage());
            }
        }

        String fbUrl = "https://www.facebook.com/v19.0/dialog/oauth"
                + "?client_id=" + FarmilyConstants.FACEBOOK_CLIENT_ID
                + "&redirect_uri=" + URLEncoder.encode(FarmilyConstants.FACEBOOK_REDIRECT_URI, "UTF-8");

        String ggUrl = "https://accounts.google.com/o/oauth2/auth"
                + "?scope=email%20profile%20openid"
                + "&redirect_uri=" + URLEncoder.encode(FarmilyConstants.GOOGLE_REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&client_id=" + FarmilyConstants.GOOGLE_CLIENT_ID
                + "&approval_prompt=force";

        request.setAttribute("facebookOAuthUrl", fbUrl);
        request.setAttribute("googleOAuthUrl", ggUrl);
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

            String rememberMe = request.getParameter("rememberMe");
            if("true".equals(rememberMe)) {
                String token = java.util.UUID.randomUUID().toString();
                long expiryTime = System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000);//30 ngay
                java.sql.Timestamp expireAt = new java.sql.Timestamp(expiryTime);

                RefreshTokenDao tokenDao = new RefreshTokenDao();
                tokenDao.insertToken(u.getId(), token, expireAt);

                Cookie cookie = new Cookie("remember_me", token);
                cookie.setMaxAge(30 * 24 * 60 * 60);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setSecure(true);
                cookie.setAttribute("SameSite", "Strict");
                response.addCookie(cookie);
            }
            session.setMaxInactiveInterval(15 * 60);

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