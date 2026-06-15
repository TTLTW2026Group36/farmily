package group36.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import group36.model.User;
import group36.model.UserRole;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    private static final Map<String, Set<UserRole>> SECURITY_MAP;

    static {
        Map<String, Set<UserRole>> map = new LinkedHashMap<>();

        Set<UserRole> orderStaff = EnumSet.of(
                UserRole.ADMIN, UserRole.MANAGER, UserRole.STAFF_ORDER);

        map.put("/admin/dashboard", orderStaff);

        map.put("/admin/users",       EnumSet.of(UserRole.ADMIN));
        map.put("/admin/api/address", EnumSet.of(UserRole.ADMIN));
        map.put("/admin/contacts",    EnumSet.of(UserRole.ADMIN, UserRole.MANAGER, UserRole.STAFF_ORDER));

        Set<UserRole> managerLevel = EnumSet.of(UserRole.ADMIN, UserRole.MANAGER);
        map.put("/admin/products",   managerLevel);
        map.put("/admin/categories", managerLevel);
        map.put("/admin/coupons",    managerLevel);
        map.put("/admin/flash-sales",managerLevel);

        map.put("/admin/orders",            orderStaff);
        map.put("/admin/reviews",           orderStaff);
        map.put("/admin/chat",              orderStaff);
        map.put("/admin/refund-requests",   orderStaff);
        
        map.put("/admin/notifications",     orderStaff);
        map.put("/admin/api/notifications", orderStaff);

        Set<UserRole> contentStaff = EnumSet.of(
                UserRole.ADMIN, UserRole.MANAGER, UserRole.STAFF_CONTENT);
        map.put("/admin/posts",         contentStaff);
        map.put("/admin/static-pages",  contentStaff);

        SECURITY_MAP = Collections.unmodifiableMap(map);
    }

    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/admin/login",
            "/admin/css/",
            "/admin/js/",
            "/admin/images/");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AdminAuthFilter] Initialized - RBAC Security Map active ("
                + SECURITY_MAP.size() + " protected path groups)");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestURI  = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (isPublicResource(requestURI, contextPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session   = request.getSession(false);
        User        adminUser = (session != null) ? (User) session.getAttribute("adminUser") : null;

        if (adminUser == null) {
            handleUnauthenticated(request, response, requestURI);
            return;
        }

        UserRole role = UserRole.fromString(adminUser.getRole());

        if (!role.canAccessAdmin()) {
            session.invalidate();
            response.sendRedirect(contextPath + "/admin/login?error=unauthorized");
            return;
        }

        Set<UserRole> allowedRoles = getAllowedRoles(requestURI, contextPath);
        if (!allowedRoles.contains(role)) {
            System.out.println("[RBAC DENIED] User: " + adminUser.getEmail()
                    + " | Role: " + role
                    + " | Path: " + requestURI);
            session.setAttribute("error",
                    "Bạn không có quyền truy cập chức năng này. (Vai trò hiện tại: " + role + ")");
            response.sendRedirect(contextPath + "/admin/dashboard");
            return;
        }

        request.setAttribute("currentRole", role);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[AdminAuthFilter] Destroyed");
    }

    private Set<UserRole> getAllowedRoles(String requestURI, String contextPath) {
        String path = requestURI.substring(contextPath.length());

        if (path.equals("/admin") || path.equals("/admin/")) {
            return UserRole.ALL_STAFF;
        }

        if (path.startsWith("/admin/logout")) {
            return UserRole.ALL_STAFF;
        }

        for (Map.Entry<String, Set<UserRole>> entry : SECURITY_MAP.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }

        return EnumSet.of(UserRole.ADMIN);
    }

    private boolean isPublicResource(String requestURI, String contextPath) {
        String path = requestURI.substring(contextPath.length());
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }

    private void handleUnauthenticated(HttpServletRequest request,
                                       HttpServletResponse response,
                                       String requestURI) throws IOException {
        String contextPath  = request.getContextPath();
        String returnUrl    = requestURI;
        String queryString  = request.getQueryString();
        if (queryString != null && !queryString.isEmpty()) {
            returnUrl += "?" + queryString;
        }
        String encodedReturnUrl = URLEncoder.encode(returnUrl, StandardCharsets.UTF_8);
        response.sendRedirect(contextPath + "/admin/login?redirect=" + encodedReturnUrl);
    }
}
