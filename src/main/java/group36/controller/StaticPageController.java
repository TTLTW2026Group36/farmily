package group36.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.StaticPage;
import group36.service.StaticPageService;

import java.io.IOException;
import java.util.Optional;













@WebServlet(name = "StaticPageController", urlPatterns = {
        "/huong-dan-mua-hang",
        "/dieu-khoan-dich-vu",
        "/chinh-sach-hoan-tra"
})
public class StaticPageController extends HttpServlet {
    private final StaticPageService staticPageService;

    public StaticPageController() {
        this.staticPageService = new StaticPageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        
        String slug = servletPath.substring(1);

        
        String jspPath = getJspPath(slug);

        if (jspPath == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            
            Optional<StaticPage> pageOpt = staticPageService.getActiveStaticPageBySlug(slug);

            if (pageOpt.isPresent()) {
                StaticPage staticPage = pageOpt.get();
                request.setAttribute("staticPage", staticPage);
                request.setAttribute("pageTitle", staticPage.getTitle());
                request.setAttribute("pageContent", staticPage.getContent());
                request.setAttribute("contentFromDb", true);
            } else {
                
                request.setAttribute("contentFromDb", false);
            }

            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            
            request.setAttribute("contentFromDb", false);
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    


    private String getJspPath(String slug) {
        switch (slug) {
            case "huong-dan-mua-hang":
                return "/HuongDanMuaHang.jsp";
            case "dieu-khoan-dich-vu":
                return "/DieuKhoanDichVu.jsp";
            case "chinh-sach-hoan-tra":
                return "/ChinhSachNhanVaHoanTra.jsp";
            default:
                return null;
        }
    }
}
