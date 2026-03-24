package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.StaticPage;
import group36.service.StaticPageService;

import java.io.IOException;
import java.util.List;





@WebServlet(name = "AdminStaticPageController", urlPatterns = { "/admin/static-pages", "/admin/static-pages/*" })
public class AdminStaticPageController extends HttpServlet {
    private final StaticPageService staticPageService;

    public AdminStaticPageController() {
        this.staticPageService = new StaticPageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                
                listStaticPages(request, response);
            } else if (pathInfo.equals("/edit")) {
                
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/static-pages.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.equals("/edit")) {
                updateStaticPage(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listStaticPages(request, response);
        }
    }

    


    private void listStaticPages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");

        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        List<StaticPage> staticPages = staticPageService.getAllStaticPages();
        request.setAttribute("staticPages", staticPages);
        request.setAttribute("totalPages", staticPages.size());
        request.getRequestDispatcher("/admin/static-pages.jsp").forward(request, response);
    }

    


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            StaticPage staticPage = staticPageService.getStaticPageById(id);
            request.setAttribute("staticPage", staticPage);
            request.getRequestDispatcher("/admin/static-page-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID trang không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
        }
    }

    


    private void updateStaticPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            StaticPage staticPage = staticPageService.updateStaticPage(id, title, content, type, status);

            
            HttpSession session = request.getSession();
            session.setAttribute("success", "Cập nhật trang '" + staticPage.getTitle() + "' thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID trang không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/static-pages");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            
            try {
                int id = Integer.parseInt(idParam);
                StaticPage staticPage = staticPageService.getStaticPageById(id);
                staticPage.setTitle(title);
                staticPage.setContent(content);
                staticPage.setType(type);
                staticPage.setStatus(status);
                request.setAttribute("staticPage", staticPage);
            } catch (Exception ex) {
                
            }
            request.getRequestDispatcher("/admin/static-page-edit.jsp").forward(request, response);
        }
    }
}
