package group36.filter;

import group36.dao.AuthDao;
import group36.dao.RefreshTokenDao;
import group36.model.RefreshToken;
import group36.model.User;
import group36.service.CartService;
import group36.service.WishlistService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.FilterReader;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

@WebFilter("/*")
public class RememberMeFilter implements Filter {
    private RefreshTokenDao refreshTokenDao;
    private AuthDao authDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        refreshTokenDao = new RefreshTokenDao();
        authDao = new AuthDao();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("auth") != null);

        boolean isAdminLoggedIn = (session != null && session.getAttribute("adminUser") != null);
        if (!isLoggedIn && !isAdminLoggedIn) {
            String rememberMeToken = null;
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("remember_me".equals(cookie.getName())) {
                        rememberMeToken = cookie.getValue();
                        break;
                    }
                }
            }
            if (rememberMeToken != null) {
                RefreshToken rt = refreshTokenDao.findByToken(rememberMeToken);

                if (rt != null) {
                    if (rt.isRevoked()) {
                        refreshTokenDao.revokeAllByUserId(rt.getUser_id());

                        Cookie deleteCookie = new Cookie("remember_me", "");
                        deleteCookie.setMaxAge(0);
                        deleteCookie.setPath("/");
                        res.addCookie(deleteCookie);

                    } else if (rt.getExpires_at().after(new Timestamp(System.currentTimeMillis()))) {
                        String newToken = UUID.randomUUID().toString();
                        long newExpiry = System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000);
                        Timestamp newExpiresAt = new Timestamp(newExpiry);

                        refreshTokenDao.rotateToken(rememberMeToken, newToken, rt.getUser_id(), newExpiresAt);

                        User u = null;
                        try {
                            u = authDao.getUserById(rt.getUser_id());
                        } catch(Exception e) {}

                        if (u != null) {
                            HttpSession newSession = req.getSession(true);
                            newSession.setAttribute("auth", u);

                            if (u.getRole() != null && (u.getRole().equalsIgnoreCase("admin") || u.getRole().equalsIgnoreCase("manager"))) {
                                newSession.setAttribute("adminUser", u);
                            }

                            newSession.setMaxInactiveInterval(15 * 60);

                            try {
                                CartService cartService = new CartService();
                                newSession.setAttribute("cartCount", cartService.getCartItemCount(u.getId()));
                            } catch (Exception e) {}

                            try {
                                WishlistService wishlistService = new WishlistService();
                                newSession.setAttribute("wishlistCount", wishlistService.getWishlistCount(u.getId()));
                            } catch (Exception e) {}

                            Cookie newCookie = new Cookie("remember_me", newToken);
                            newCookie.setMaxAge(30 * 24 * 60 * 60);
                            newCookie.setPath("/");
                            newCookie.setHttpOnly(true);
                            newCookie.setSecure(true);
                            newCookie.setAttribute("SameSite", "Strict");
                            res.addCookie(newCookie);
                        }
                    }
                } else {
                    Cookie deleteCookie = new Cookie("remember_me", "");
                    deleteCookie.setMaxAge(0);
                    deleteCookie.setPath("/");
                    res.addCookie(deleteCookie);
                }
            }
        }
        chain.doFilter(request, response);
    }
    @Override
    public void destroy() {
    }
}
