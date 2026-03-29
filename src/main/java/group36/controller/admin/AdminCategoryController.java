package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Category;
import group36.service.CategoryService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;





@WebServlet(name = "AdminCategoryController", urlPatterns = { "/admin/categories", "/admin/categories/*" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
        maxFileSize = 1024 * 1024 * 10, 
        maxRequestSize = 1024 * 1024 * 50 
)
public class AdminCategoryController extends HttpServlet {
    private final CategoryService categoryService;

    public AdminCategoryController() {
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                
                listCategories(request, response);
            } else if (pathInfo.equals("/add")) {
                
                request.getRequestDispatcher("/admin/categories-add.jsp").forward(request, response);
            } else if (pathInfo.equals("/edit")) {
                
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/add")) {
                createCategory(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateCategory(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteCategory(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            listCategories(request, response);
        }
    }

    


    private void listCategories(HttpServletRequest request, HttpServletResponse response)
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

        List<Category> categories = categoryService.getAllCategories();
        Map<Integer, Integer> productCountMap = new HashMap<>();
        for (Category cat : categories) {
            productCountMap.put(cat.getId(), categoryService.getProductCount(cat.getId()));
        }
        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", categories.size());
        request.setAttribute("productCountMap", productCountMap);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Category category = categoryService.getCategoryById(id);
            int productCount = categoryService.getProductCount(id);
            request.setAttribute("category", category);
            request.setAttribute("productCount", productCount);
            request.getRequestDispatcher("/admin/categories-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid category ID");
            listCategories(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listCategories(request, response);
        }
    }

    


    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        HttpSession session = request.getSession();

        try {
            Category category = categoryService.createCategory(name);
            session.setAttribute("success", "Đã thêm danh mục '" + category.getName() + "' thành công!");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    


    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        HttpSession session = request.getSession();

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Category category = categoryService.updateCategory(id, name);
            session.setAttribute("success", "Đã cập nhật danh mục '" + category.getName() + "' thành công!");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID danh mục không hợp lệ");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    


    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Category category = categoryService.getCategoryById(id);
            String categoryName = category.getName();

            categoryService.deleteCategory(id);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Đã xóa danh mục '" + categoryName + "' thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID danh mục không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
}
