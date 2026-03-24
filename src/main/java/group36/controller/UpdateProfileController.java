package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.User;
import group36.service.UserService;

import java.io.IOException;
import java.io.PrintWriter;





@WebServlet(name = "UpdateProfileController", urlPatterns = { "/api/user/update-profile" })
public class UpdateProfileController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");

            
            if (isEmpty(name)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Họ tên không được để trống\"}");
                return;
            }

            
            User updatedUser = userService.updateUser(
                    user.getId(),
                    name.trim(),
                    user.getEmail(), 
                    phone != null ? phone.trim() : null,
                    user.getRole() 
            );

            
            session.setAttribute("auth", updatedUser);

            
            out.print("{\"success\":true,\"message\":\"Cập nhật thông tin thành công\"," +
                    "\"user\":{" +
                    "\"name\":\"" + escapeJson(updatedUser.getName()) + "\"," +
                    "\"email\":\"" + escapeJson(updatedUser.getEmail()) + "\"," +
                    "\"phone\":\"" + escapeJson(updatedUser.getPhone() != null ? updatedUser.getPhone() : "") + "\"" +
                    "}}");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        doPut(request, response);
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
