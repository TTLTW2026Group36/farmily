package group36.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Contact;
import group36.service.ContactService;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "AdminContactController", urlPatterns = { "/admin/contacts", "/admin/contacts/*" })
public class AdminContactController extends HttpServlet {
    private final ContactService contactService;

    public AdminContactController() {
        this.contactService = new ContactService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listContacts(request, response);
            } else if (pathInfo.equals("/view-api")) {
                getContactApi(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listContacts(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.equals("/delete")) {
                deleteContact(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
        }
    }

    private void listContacts(HttpServletRequest request, HttpServletResponse response)
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
                if (size < 1) size = 10;
                if (size > 100) size = 100;
            } catch (NumberFormatException e) {
                size = 10;
            }
        }

        List<Contact> contacts = contactService.getContactsPaginated(page, size);
        int totalContacts = contactService.countContacts();
        int totalPages = (int) Math.ceil((double) totalContacts / size);

        request.setAttribute("contacts", contacts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContacts", totalContacts);
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

        request.getRequestDispatcher("/admin/contacts.jsp").forward(request, response);
    }

    private void getContactApi(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false, \"message\":\"Thiếu ID\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Optional<Contact> contactOpt = contactService.getContactById(id);
            if (contactOpt.isPresent()) {
                Contact c = contactOpt.get();
                // Format response JSON safely
                String json = String.format(
                    "{\"success\":true, \"contact\":{\"id\":%d, \"userId\":%s, \"fullname\":\"%s\", \"email\":\"%s\", \"phone\":\"%s\", \"subject\":\"%s\", \"organization\":\"%s\", \"message\":\"%s\", \"createdAt\":\"%s\"}}",
                    c.getId(),
                    c.getUserId() == null ? "null" : c.getUserId().toString(),
                    escapeJson(c.getFullname()),
                    escapeJson(c.getEmail()),
                    escapeJson(c.getPhone()),
                    escapeJson(c.getSubject()),
                    escapeJson(c.getOrganization()),
                    escapeJson(c.getMessage()),
                    c.getCreatedAt().toString()
                );
                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\":false, \"message\":\"Không tìm thấy liên hệ\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false, \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void deleteContact(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();

        if (idParam == null || idParam.trim().isEmpty()) {
            session.setAttribute("error", "Thiếu ID liên hệ");
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean deleted = contactService.deleteContact(id);
            if (deleted) {
                session.setAttribute("success", "Đã xóa liên hệ thành công!");
            } else {
                session.setAttribute("error", "Không thể xóa liên hệ hoặc liên hệ không tồn tại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID không hợp lệ");
        }

        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
