package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.dao.AddressDAO;
import group36.model.User;
import group36.model.UserRole;
import group36.service.UserService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminUserController", urlPatterns = { "/admin/users", "/admin/users/*" })
public class AdminUserController extends HttpServlet {
    private final UserService userService;
    private final AddressDAO addressDAO;

    public AdminUserController() {
        this.userService = new UserService();
        this.addressDAO = new AddressDAO();
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
            System.err.println("Error: " + e.getMessage());
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
            } else if (pathInfo.equals("/toggle-status")) {
                toggleUserStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
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
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int size = 10;
        String sizeParam = request.getParameter("size");
        if (sizeParam != null && !sizeParam.isEmpty()) {
            try {
                size = Integer.parseInt(sizeParam);
                if (size != -1) {
                    if (size < 1) size = 10;
                    if (size > 100) size = 100;
                }
            } catch (NumberFormatException e) {
                size = 10;
            }
        }

        String keyword = request.getParameter("search");
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            role = "all";
        }
        String statusFilter = request.getParameter("status");
        String verifiedFilter = request.getParameter("verified");

        List<User> users = userService.findUsers(keyword, role, statusFilter, verifiedFilter, page, size);
        int totalUsers = userService.countUsers(keyword, role, statusFilter, verifiedFilter);
        int totalPages = size > 0 ? (int) Math.ceil((double) totalUsers / size) : 1;

        Map<Integer, Integer> addressCountMap = new HashMap<>();
        for (User u : users) {
            addressCountMap.put(u.getId(), addressDAO.countByUserId(u.getId()));
        }

        request.setAttribute("users", users);
        request.setAttribute("addressCountMap", addressCountMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedRole", role);
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("selectedVerified", verifiedFilter);
        request.setAttribute("pageSize", size);

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
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            UserRole parsedRole = UserRole.fromString(role);

            HttpSession session = request.getSession();
            User currentAdmin = (User) session.getAttribute("adminUser");
            if (currentAdmin != null
                    && currentAdmin.getId() == id
                    && UserRole.fromString(currentAdmin.getRole()) == UserRole.ADMIN
                    && parsedRole != UserRole.ADMIN) {
                session.setAttribute("error", "Không thể thay đổi vai trò của chính mình khi đang là ADMIN!");
                response.sendRedirect(request.getContextPath() + "/admin/users/edit?id=" + idParam);
                return;
            }

            userService.updateUserBasic(id, name, phone, parsedRole.name());

            session.setAttribute("success",
                    "Cập nhật thông tin & vai trò (" + parsedRole.name() + ") thành công! "
                    + "Người dùng cần đăng nhập lại để áp dụng vai trò mới.");

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

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        String reason = request.getParameter("reason");

        try {
            int id = Integer.parseInt(idParam);
            HttpSession session = request.getSession();
            User currentAdmin = (User) session.getAttribute("adminUser");
            if (currentAdmin != null && currentAdmin.getId() == id) {
                response.getWriter().write("{\"success\":false,\"message\":\"Kh\u00f4ng th\u1ec3 kh\u00f3a t\u00e0i kho\u1ea3n c\u1ee7a ch\u00ednh m\u00ecnh!\"}");
                return;
            }

            if ("lock".equals(action)) {
                userService.lockUser(id, reason);
                response.getWriter().write("{\"success\":true,\"message\":\"\u0110\u00e3 kh\u00f3a t\u00e0i kho\u1ea3n\",\"newStatus\":\"locked\"}");
            } else if ("unlock".equals(action)) {
                userService.unlockUser(id);
                response.getWriter().write("{\"success\":true,\"message\":\"\u0110\u00e3 m\u1edf kh\u00f3a t\u00e0i kho\u1ea3n\",\"newStatus\":\"active\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"H\u00e0nh \u0111\u1ed9ng kh\u00f4ng h\u1ee3p l\u1ec7\"}");
            }
        } catch (Exception e) {
            String msg = e.getMessage() != null ? e.getMessage().replace("\"", "'") : "L\u1ed7i h\u1ec7 th\u1ed1ng";
            response.getWriter().write("{\"success\":false,\"message\":\"" + msg + "\"}");
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
