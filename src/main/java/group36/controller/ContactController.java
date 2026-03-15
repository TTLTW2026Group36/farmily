package group36.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Contact;
import group36.model.User;
import group36.service.ContactService;

import java.io.IOException;
import java.io.PrintWriter;








@WebServlet(name = "ContactController", urlPatterns = { "/lien-he" })
public class ContactController extends HttpServlet {
    private final ContactService contactService;

    public ContactController() {
        this.contactService = new ContactService();
    }

    


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/LienHe.jsp").forward(request, response);
    }

    



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            
            String fullname = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String organization = request.getParameter("org");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");

            
            Contact contact = new Contact();
            contact.setFullname(fullname);
            contact.setEmail(email);
            contact.setPhone(phone);
            contact.setOrganization(organization);
            contact.setSubject(subject);
            contact.setMessage(message);

            
            HttpSession session = request.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("auth");
                if (user != null) {
                    contact.setUserId(user.getId());
                }
            }

            
            int contactId = contactService.saveContact(contact);

            
            out.print(
                    "{\"success\": true, \"message\": \"Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.\", \"id\": "
                            + contactId + "}");

        } catch (IllegalArgumentException e) {
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"" + escapeJson(e.getMessage()) + "\"}");

        } catch (Exception e) {
            
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Đã có lỗi xảy ra. Vui lòng thử lại sau.\"}");
        }

        out.flush();
    }

    


    private String escapeJson(String str) {
        if (str == null)
            return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
