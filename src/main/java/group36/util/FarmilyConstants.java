package group36.util;

import java.io.InputStream;
import java.util.Properties;

public class FarmilyConstants {
    public static String FACEBOOK_CLIENT_ID;
    public static String FACEBOOK_CLIENT_SECRET;
    public static final String FACEBOOK_LINK_GET_TOKEN = "https://graph.facebook.com/v19.0/oauth/access_token";
    public static final String FACEBOOK_LINK_GET_USER_INFO = "https://graph.facebook.com/me?fields=id,name,email,picture&access_token=";

    public static String FACEBOOK_REDIRECT_URI;

    public static String GOOGLE_CLIENT_ID;
    public static String GOOGLE_CLIENT_SECRET;
    public static String GOOGLE_REDIRECT_URI;
    public static final String GOOGLE_GRANT_TYPE = "authorization_code";
    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    static {
        Properties pro = new Properties();
        try (InputStream input = FarmilyConstants.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                pro.load(input);
                GOOGLE_CLIENT_ID = pro.getProperty("google.client.id");
                GOOGLE_CLIENT_SECRET = pro.getProperty("google.client.secret");
                FACEBOOK_CLIENT_ID = pro.getProperty("facebook.client.id");
                FACEBOOK_CLIENT_SECRET = pro.getProperty("facebook.client.secret");

                String baseUrl = pro.getProperty("app.base.url", "http://localhost:8080");
                FACEBOOK_REDIRECT_URI = baseUrl + "/dang-nhap";
                GOOGLE_REDIRECT_URI = baseUrl + "/dang-nhap";
            } else {
                System.out.println("Lỗi: Không tìm thấy file config.properties");
                // Fallback cho môi trường dev local
                FACEBOOK_REDIRECT_URI = "http://localhost:8080/dang-nhap";
                GOOGLE_REDIRECT_URI = "http://localhost:8080/dang-nhap";
            }
        } catch (Exception e) {
            e.printStackTrace();
            FACEBOOK_REDIRECT_URI = "http://localhost:8080/dang-nhap";
            GOOGLE_REDIRECT_URI = "http://localhost:8080/dang-nhap";
        }
    }
}
