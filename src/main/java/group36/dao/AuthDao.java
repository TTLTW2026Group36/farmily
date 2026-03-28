package group36.dao;

import group36.model.User;

public class AuthDao extends BaseDao {
    public User getUserByUsername(String username) {
        return get()
                .withHandle(h -> h.createQuery("select * from users where email = :username").bind("username", username)
                        .mapToBean(User.class).stream().findFirst().orElse(null));

    }

    public void updatePassword(int userId, String hashedPassword) {
        get().useHandle(h -> h.createUpdate("UPDATE users SET password = :password WHERE id = :id")
                .bind("password", hashedPassword)
                .bind("id", userId)
                .execute());
    }

    public boolean insertUser(User user) {
        try {
            get().useHandle(h -> h.createUpdate(
                    "INSERT INTO users (name, email, password, phone, role) VALUES (:name, :email, :password, :phone, :role)")
                    .bind("name", user.getName())
                    .bind("email", user.getEmail())
                    .bind("password", user.getPassword())
                    .bind("phone", user.getPhone())
                    .bind("role", user.getRole())
                    .execute());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByFacebookId(String facebookId) {
        return get()
                .withHandle(h -> h.createQuery("select * from users where facebook_id = :facebookId").bind("facebookId", facebookId)
                        .mapToBean(User.class).stream().findFirst().orElse(null));
    }

    public boolean insertUserWithFacebook(User user) {
        try {
            get().useHandle(h -> h.createUpdate(
                    "INSERT INTO users (name, email, password, facebook_id, role) VALUES (:name, :email, :password, :facebookId, :role)")
                    .bind("name", user.getName())
                    .bind("email", user.getEmail())
                    .bind("password", "")
                    .bind("facebookId", user.getFacebookId())
                    .bind("role", user.getRole())
                    .execute());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi CSDL khi tạo user FB: " + e.getMessage());
        }
    }
}
