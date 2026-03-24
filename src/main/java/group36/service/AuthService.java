package group36.service;

import group36.dao.AuthDao;
import group36.model.User;
import group36.util.PasswordUtil;

public class AuthService {
    AuthDao authDao = new AuthDao();

    public User checkLogin(String username, String pass) {
        User u = authDao.getUserByUsername(username);
        if (u == null || u.getPassword() == null) {
            return null;
        }

        boolean passwordMatch = false;
        String storedPassword = u.getPassword();

        
        if (PasswordUtil.isMD5Hash(storedPassword)) {
            
            passwordMatch = PasswordUtil.checkPassword(pass, storedPassword);
        } else {
            
            passwordMatch = storedPassword.equals(pass);

            
            if (passwordMatch) {
                String hashedPassword = PasswordUtil.hashPassword(pass);
                authDao.updatePassword(u.getId(), hashedPassword);
                System.out.println("Password migrated to MD5 for user: " + username);
            }
        }

        if (passwordMatch) {
            u.setPassword(null);
            return u;
        }
        return null;
    }

    


    public boolean isEmailExists(String email) {
        User u = authDao.getUserByUsername(email);
        return u != null;
    }

    


    public boolean register(User user) {
        
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

        return authDao.insertUser(user);
    }

}
