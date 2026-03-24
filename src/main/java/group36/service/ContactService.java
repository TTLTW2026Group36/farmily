package group36.service;

import group36.dao.ContactDAO;
import group36.model.Contact;

import java.util.List;
import java.util.Optional;





public class ContactService {
    private final ContactDAO contactDAO;

    public ContactService() {
        this.contactDAO = new ContactDAO();
    }

    







    public int saveContact(Contact contact) {
        
        if (contact.getFullname() == null || contact.getFullname().trim().isEmpty()) {
            throw new IllegalArgumentException("Họ và tên không được để trống");
        }
        if (contact.getEmail() == null || contact.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email không được để trống");
        }
        if (!isValidEmail(contact.getEmail())) {
            throw new IllegalArgumentException("Email không đúng định dạng");
        }
        if (contact.getPhone() == null || contact.getPhone().trim().isEmpty()) {
            throw new IllegalArgumentException("Số điện thoại không được để trống");
        }
        if (contact.getSubject() == null || contact.getSubject().trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống");
        }
        if (contact.getMessage() == null || contact.getMessage().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống");
        }

        
        contact.setFullname(contact.getFullname().trim());
        contact.setEmail(contact.getEmail().trim().toLowerCase());
        contact.setPhone(contact.getPhone().trim());
        contact.setSubject(contact.getSubject().trim());
        contact.setMessage(contact.getMessage().trim());
        if (contact.getOrganization() != null) {
            contact.setOrganization(contact.getOrganization().trim());
        }

        return contactDAO.insert(contact);
    }

    




    public List<Contact> getAllContacts() {
        return contactDAO.findAll();
    }

    






    public List<Contact> getContactsPaginated(int page, int size) {
        return contactDAO.findAllPaginated(page, size);
    }

    





    public Optional<Contact> getContactById(int id) {
        return contactDAO.findById(id);
    }

    




    public int countContacts() {
        return contactDAO.count();
    }

    





    public boolean deleteContact(int id) {
        return contactDAO.delete(id) > 0;
    }

    


    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email != null && email.matches(emailRegex);
    }
}
