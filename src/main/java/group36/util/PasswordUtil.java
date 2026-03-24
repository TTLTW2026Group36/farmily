package group36.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;




public class PasswordUtil {

    





    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(plainPassword.getBytes());

            
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not found", e);
        }
    }

    






    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        String hashedInput = hashPassword(plainPassword);
        return hashedPassword.equalsIgnoreCase(hashedInput);
    }

    






    public static boolean isMD5Hash(String password) {
        if (password == null) {
            return false;
        }
        
        return password.length() == 32 && password.matches("[a-fA-F0-9]+");
    }
}