package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.User;
import group36.service.UserService;

import java.io.IOException;
import java.util.List;





@WebServlet(name = "AdminUserController", urlPatterns = { "/admin/customers", "/admin/customers/*" })
public class AdminUserController extends HttpServlet {
    private final UserService userService;

    private static final int PAGE_SIZE = 10;

    public AdminUserController() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                
                listUsers(request, response);
            } else if (pathInfo.equals("/view")) {
                
                showUserDetail(request, response);
            } else if (pathInfo.equals("/edit")) {
                
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listUsers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/edit")) {
                updateUser(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteUser(request, response);
            } else if (pathInfo.equals("/reset-password")) {
                resetPassword(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    


    private void listUsers(HttpServletRequest request, HttpServletResponse response)
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

        
        String keyword = request.getParameter("search");

        
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            role = "customer"; 
        }

        
        List<User> users;
        int totalUsers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            
            users = userService.searchUsers(keyword);
            
            if (!"all".equals(role)) {
                String finalRole = role;
                users = users.stream()
                        .filter(u -> finalRole.equals(u.getRole()))
                        .toList();
            }
            totalUsers = users.size();
            
            int start = (page - 1) * PAGE_SIZE;
            int end = Math.min(start + PAGE_SIZE, users.size());
            if (start < users.size()) {
                users = users.subList(start, end);
            } else {
                users = List.of();
            }
        } else {
            
            if ("all".equals(role)) {
                users = userService.getUsersPaginated(page, PAGE_SIZE);
                totalUsers = userService.getTotalUsers();
            } else {
                users = userService.getCustomersPaginated(page, PAGE_SIZE);
                totalUsers = userService.getTotalCustomers();
            }
        }

        
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);

        
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedRole", role);
        request.setAttribute("pageSize", PAGE_SIZE);

        
        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
    }

    


    private void showUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            User user = userService.getUserById(id);

            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/customers-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ");
            listUsers(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listUsers(request, response);
        }
    }

    


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            User user = userService.getUserById(id);

            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/customers-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ");
            listUsers(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listUsers(request, response);
        }
    }

    


    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            
            userService.updateUser(id, name, email, phone, role);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Cập nhật thông tin khách hàng thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + idParam);
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + idParam);
        }
    }

    


    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            User user = userService.getUserById(id);
            String userName = user.getName();

            userService.deleteUser(id);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Xóa khách hàng '" + userName + "' thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID người dùng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    


    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            userService.updatePassword(id, newPassword);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Đặt lại mật khẩu thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + id);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + idParam);
        }
    }
}
