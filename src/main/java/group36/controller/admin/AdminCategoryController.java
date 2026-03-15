package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Category;
import group36.service.CategoryService;

import java.io.IOException;
import java.util.List;





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
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", categories.size());
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
            request.setAttribute("category", category);
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
        String imageUrl = request.getParameter("imageUrl");

        try {
            Category category = categoryService.createCategory(name, imageUrl);

            
            HttpSession session = request.getSession();
            session.setAttribute("success", "Category '" + category.getName() + "' created successfully!");

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("name", name);
            request.setAttribute("imageUrl", imageUrl);
            request.getRequestDispatcher("/admin/categories-add.jsp").forward(request, response);
        }
    }

    


    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String imageUrl = request.getParameter("imageUrl");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Category category = categoryService.updateCategory(id, name, imageUrl);

            
            HttpSession session = request.getSession();
            session.setAttribute("success", "Category '" + category.getName() + "' updated successfully!");

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid category ID");
            showEditForm(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("name", name);
            request.setAttribute("imageUrl", imageUrl);
            showEditForm(request, response);
        }
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
            session.setAttribute("success", "Category '" + categoryName + "' deleted successfully!");

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Invalid category ID");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
}
