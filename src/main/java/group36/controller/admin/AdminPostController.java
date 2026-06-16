package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.News;
import group36.model.NewsCategory;
import group36.model.User;
import group36.service.NewsCategoryService;
import group36.service.NewsService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;





@WebServlet(name = "AdminPostController", urlPatterns = { "/admin/posts", "/admin/posts/*" })
public class AdminPostController extends HttpServlet {
    private final NewsService newsService;
    private final NewsCategoryService categoryService;

    private static final int PAGE_SIZE = 10;

    public AdminPostController() {
        this.newsService = new NewsService();
        this.categoryService = new NewsCategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listPosts(request, response);
            } else if (pathInfo.equals("/add")) {
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else if (pathInfo.equals("/categories")) {
                listCategories(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            if (pathInfo != null && pathInfo.startsWith("/categories")) {
                response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
            } else {
                listPosts(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.equals("/add")) {
                createPost(request, response);
            } else if (pathInfo != null && pathInfo.equals("/edit")) {
                updatePost(request, response);
            } else if (pathInfo != null && pathInfo.equals("/delete")) {
                deletePost(request, response);
            } else if (pathInfo != null && pathInfo.equals("/toggle")) {
                togglePost(request, response);
            } else if (pathInfo != null && pathInfo.equals("/categories/add")) {
                createCategory(request, response);
            } else if (pathInfo != null && pathInfo.equals("/categories/edit")) {
                updateCategory(request, response);
            } else if (pathInfo != null && pathInfo.equals("/categories/delete")) {
                deleteCategory(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            if (pathInfo != null && pathInfo.startsWith("/categories")) {
                response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/posts");
            }
        }
    }

    


    private void listPosts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        
        String statusFilter = request.getParameter("status");

        
        List<News> allPosts = newsService.getAllNewsAdmin();

        
        List<News> filteredPosts = allPosts;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            filteredPosts = new ArrayList<>();
            for (News post : allPosts) {
                if (statusFilter.equals(post.getStatus())) {
                    filteredPosts.add(post);
                }
            }
        }

        
        int totalPosts = filteredPosts.size();
        int totalPages = (int) Math.ceil((double) totalPosts / PAGE_SIZE);

        
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalPosts);
        List<News> pagedPosts = (fromIndex < totalPosts)
                ? filteredPosts.subList(fromIndex, toIndex)
                : new ArrayList<>();

        
        int publishedCount = 0, draftCount = 0, pendingCount = 0;
        for (News post : allPosts) {
            String status = post.getStatus();
            if ("published".equals(status))
                publishedCount++;
            else if ("draft".equals(status))
                draftCount++;
            else if ("pending".equals(status))
                pendingCount++;
        }

        
        request.setAttribute("posts", pagedPosts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "");
        request.setAttribute("publishedCount", publishedCount);
        request.setAttribute("draftCount", draftCount);
        request.setAttribute("pendingCount", pendingCount);

        
        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
    }

    


    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<NewsCategory> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/posts-add.jsp").forward(request, response);
    }

    


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/posts");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            News post = newsService.getNewsById(postId);
            List<NewsCategory> categories = categoryService.getAllCategories();

            request.setAttribute("post", post);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/posts-edit.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Không tìm thấy bài viết");
            response.sendRedirect(request.getContextPath() + "/admin/posts");
        }
    }

    


    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String title = request.getParameter("title");
        String excerpt = request.getParameter("excerpt");
        String content = request.getParameter("content");
        String categoryIdParam = request.getParameter("categoryId");
        String status = request.getParameter("status");
        String imageUrl = request.getParameter("imageUrl");

        
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề không được để trống");
            showAddForm(request, response);
            return;
        }

        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("adminUser");
        int authorId = (admin != null) ? admin.getId() : 1;

        
        News news = new News();
        news.setTitle(title.trim());
        news.setExcerpt(excerpt != null ? excerpt.trim() : "");
        news.setContent(content != null ? content.trim() : "");
        news.setStatus(status != null ? status : "draft");
        news.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        news.setAuthorId(authorId);

        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                news.setCategoryId(Integer.parseInt(categoryIdParam));
            } catch (NumberFormatException e) {
                news.setCategoryId(0);
            }
        }

        
        newsService.createNews(news, null);

        session.setAttribute("success", "Đã thêm bài viết thành công");
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }

    


    private void updatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/posts");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);

            
            String title = request.getParameter("title");
            String excerpt = request.getParameter("excerpt");
            String content = request.getParameter("content");
            String categoryIdParam = request.getParameter("categoryId");
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");

            
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề không được để trống");
                showEditForm(request, response);
                return;
            }

            
            News news = newsService.getNewsById(postId);
            news.setTitle(title.trim());
            news.setExcerpt(excerpt != null ? excerpt.trim() : "");
            news.setContent(content != null ? content.trim() : "");
            news.setStatus(status != null ? status : news.getStatus());
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                news.setImageUrl(imageUrl.trim());
            }

            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                news.setCategoryId(Integer.parseInt(categoryIdParam));
            }

            
            newsService.updateNews(news);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Đã cập nhật bài viết thành công");
            response.sendRedirect(request.getContextPath() + "/admin/posts");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID bài viết không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/posts");
        }
    }

    


    private void deletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Thiếu ID bài viết\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            newsService.deleteNews(postId);
            out.print("{\"success\": true, \"message\": \"Đã xóa bài viết thành công\"}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID bài viết không hợp lệ\"}");
        } catch (IllegalArgumentException e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private void togglePost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Thiếu ID bài viết\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(idParam);
            String newStatus = newsService.togglePostStatus(postId);

            String statusText;
            String badgeClass;
            if ("published".equals(newStatus)) {
                statusText = "Đã đăng";
                badgeClass = "success";
            } else {
                statusText = "Nháp";
                badgeClass = "warning";
            }
            boolean isPublished = "published".equals(newStatus);

            out.print("{\"success\": true, \"status\": \"" + newStatus
                    + "\", \"statusText\": \"" + statusText
                    + "\", \"badgeClass\": \"" + badgeClass
                    + "\", \"isPublished\": " + isPublished + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID bài viết không hợp lệ\"}");
        } catch (IllegalArgumentException e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Đã xảy ra lỗi khi thay đổi trạng thái\"}");
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

        List<NewsCategory> categories = categoryService.getAllCategories();
        Map<Integer, Integer> newsCountMap = new HashMap<>();
        for (NewsCategory cat : categories) {
            newsCountMap.put(cat.getId(), categoryService.getNewsCount(cat.getId()));
        }

        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", categories.size());
        request.setAttribute("newsCountMap", newsCountMap);
        request.getRequestDispatcher("/admin/posts-categories.jsp").forward(request, response);
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        HttpSession session = request.getSession();

        try {
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên danh mục không được để trống");
            }
            NewsCategory category = new NewsCategory();
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            
            categoryService.createCategory(category);
            session.setAttribute("success", "Đã thêm danh mục '" + category.getName() + "' thành công!");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        HttpSession session = request.getSession();

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên danh mục không được để trống");
            }
            NewsCategory category = categoryService.getCategoryById(id);
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");

            categoryService.updateCategory(category);
            session.setAttribute("success", "Đã cập nhật danh mục '" + category.getName() + "' thành công!");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID danh mục không hợp lệ");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            NewsCategory category = categoryService.getCategoryById(id);
            String categoryName = category.getName();

            categoryService.deleteCategory(id);
            session.setAttribute("success", "Đã xóa danh mục '" + categoryName + "' thành công!");
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID danh mục không hợp lệ");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi khi xóa danh mục: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/posts/categories");
    }
}
