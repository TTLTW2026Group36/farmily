package group36.service;

import group36.dao.UserDAO;
import group36.model.User;
import group36.util.PasswordUtil;

import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;





public class UserService {
    private final UserDAO userDAO;

    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    public UserService() {
        this.userDAO = new UserDAO();
    }

    

    




    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    






    public List<User> getUsersPaginated(int page, int size) {
        return userDAO.findAllPaginated(page, size);
    }

    




    public List<User> getAllCustomers() {
        return userDAO.findByRole("customer");
    }

    






    public List<User> getCustomersPaginated(int page, int size) {
        return userDAO.findByRolePaginated("customer", page, size);
    }

    






    public User getUserById(int id) {
        return userDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + id));
    }

    





    public Optional<User> getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    





    public List<User> searchUsers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllUsers();
        }
        return userDAO.searchByNameOrEmail(keyword.trim());
    }

    




    public int getTotalUsers() {
        return userDAO.count();
    }

    




    public int getTotalCustomers() {
        return userDAO.countByRole("customer");
    }

    

    










    public User createUser(String name, String email, String password, String phone, String role) {
        
        validateEmail(email);
        validatePassword(password);

        
        if (userDAO.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email already exists: " + email);
        }

        
        User user = new User();
        user.setName(name != null ? name.trim() : null);
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole(role != null ? role.trim() : "customer");

        
        int userId = userDAO.insert(user);
        user.setId(userId);
        return user;
    }

    

    










    public User updateUser(int id, String name, String email, String phone, String role) {
        
        User existingUser = getUserById(id);

        
        validateEmail(email);

        
        String newEmail = email.trim().toLowerCase();
        if (!existingUser.getEmail().equalsIgnoreCase(newEmail)) {
            if (userDAO.findByEmail(newEmail).isPresent()) {
                throw new IllegalArgumentException("Email already exists: " + newEmail);
            }
        }

        
        existingUser.setName(name != null ? name.trim() : null);
        existingUser.setEmail(newEmail);
        existingUser.setPhone(phone != null ? phone.trim() : null);
        if (role != null && !role.trim().isEmpty()) {
            existingUser.setRole(role.trim());
        }

        
        int rowsAffected = userDAO.update(existingUser);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update user");
        }

        return getUserById(id);
    }

    






    public void updatePassword(int id, String newPassword) {
        
        getUserById(id);

        
        validatePassword(newPassword);

        
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        int rowsAffected = userDAO.updatePassword(id, hashedPassword);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update password");
        }
    }

    

    





    public void deleteUser(int id) {
        
        getUserById(id);

        int rowsAffected = userDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete user");
        }
    }

    

    


    private void validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    


    private void validatePassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        if (password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
    }
}
