package group36.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import group36.model.User;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;






@WebFilter(filterName = "AdminAuthFilter", urlPatterns = { "/admin/*" })
public class AdminAuthFilter implements Filter {

    private static final List<String> ALLOWED_ROLES = Arrays.asList("admin", "manager");

    
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/admin/login",
            "/admin/css/",
            "/admin/js/",
            "/admin/images/");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AdminAuthFilter] Initialized - Protecting /admin/* routes");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        
        if (isPublicResource(requestURI, contextPath)) {
            chain.doFilter(request, response);
            return;
        }

        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("adminUser") : null;

        if (adminUser == null) {
            
            handleUnauthenticated(request, response, requestURI);
            return;
        }

        
        if (!isAuthorized(adminUser)) {
            
            session.invalidate(); 
            response.sendRedirect(contextPath + "/admin/login?error=unauthorized");
            return;
        }

        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[AdminAuthFilter] Destroyed");
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

    


    private boolean isAuthorized(User user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        return ALLOWED_ROLES.contains(user.getRole().toLowerCase());
    }

    


    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response, String requestURI)
            throws IOException {

        String contextPath = request.getContextPath();

        
        String returnUrl = requestURI;
        String queryString = request.getQueryString();
        if (queryString != null && !queryString.isEmpty()) {
            returnUrl += "?" + queryString;
        }

        
        String encodedReturnUrl = URLEncoder.encode(returnUrl, StandardCharsets.UTF_8);

        
        response.sendRedirect(contextPath + "/admin/login?redirect=" + encodedReturnUrl);
    }
}
