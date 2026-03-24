package group36.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;






@WebFilter(filterName = "HomeRedirectFilter", urlPatterns = { "/" })
public class HomeRedirectFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        
        String path = requestURI.substring(contextPath.length());

        if (path.isEmpty() || path.equals("/")) {
            
            request.getRequestDispatcher("/home").forward(request, response);
        } else {
            
            chain.doFilter(request, response);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void destroy() {
        
    }
}
