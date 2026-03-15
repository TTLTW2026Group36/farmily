package group36.model;

import java.io.Serializable;






public class GuestInfo implements Serializable {
    private String email;
    private String fullName;
    private String phone;

    
    public GuestInfo() {
    }

    public GuestInfo(String email, String fullName, String phone) {
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
    }

    
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    

    




    public boolean isValid() {
        return email != null && !email.trim().isEmpty() &&
                fullName != null && !fullName.trim().isEmpty() &&
                phone != null && !phone.trim().isEmpty();
    }

    




    public boolean isEmailValid() {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email.matches(emailRegex);
    }

    




    public boolean isPhoneValid() {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        String phoneRegex = "^0[0-9]{9,10}$";
        return phone.replaceAll("\\s+", "").matches(phoneRegex);
    }

    @Override
    public String toString() {
        return "GuestInfo{" +
                "email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
