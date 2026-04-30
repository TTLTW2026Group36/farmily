package group36.controller.auth;

import group36.dao.RefreshTokenDao;
import group36.service.*;
import group36.util.FarmilyConstants;
import group36.util.RecaptchaUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;


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
        String gRecaptchaResponse = request.getParameter("g-recaptcha-response");

        AuthService as = new AuthService();
        User existingUser = as.findUserByEmail(username);

        // ktra Lockout
        if (existingUser != null && existingUser.getLockoutUntil() != null && 
            existingUser.getLockoutUntil().after(new Timestamp(System.currentTimeMillis()))) {
            request.setAttribute("error", "Tài khoản bị tạm khóa. Vui lòng thử lại sau!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/DangNhap.jsp").forward(request, response);
            return;
        }

        // ktra co can Captcha (sau 3 lan)
        if (existingUser != null && existingUser.getLoginAttempts() >= 3) {
            if (!RecaptchaUtil.verify(gRecaptchaResponse)) {
                request.setAttribute("error", "Vui lòng xác minh mã Captcha!");
                request.setAttribute("showCaptcha", true);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/DangNhap.jsp").forward(request, response);
                return;
            }
        }

        User u = as.checkLogin(username, pass);

        if (u != null) {
            as.resetLoginAttempts(u.getId());

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = request.getSession(true);
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
            //Tang so lan
            if (existingUser != null) {
                as.incrementLoginAttempts(existingUser.getId());
                if (existingUser.getLoginAttempts() + 1 >= 5) {
                    as.lockAccount(existingUser.getId());
                    request.setAttribute("error", "Đăng nhập sai quá nhiều lần. Tài khoản bị khóa 30 phút!");
                } else {
                    request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
                }
                
                // show captcha nếu lần đăng nhập hiện tại thất bại và >=3
                if (existingUser.getLoginAttempts() + 1 >= 3) {
                    request.setAttribute("showCaptcha", true);
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            }

            request.setAttribute("username", username);
            request.getRequestDispatcher("/DangNhap.jsp").forward(request, response);
        }

    }
}