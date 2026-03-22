package group36.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import group36.dao.AuthDao;
import group36.model.User;
import group36.util.FarmilyConstants;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import java.io.IOException;

public class FacebookAuthService {

    public static class FacebookAccount {
        private String id;
        private String name;
        private String email;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }

    public static String getToken(String code) throws IOException {
        String response = Request.Post(FarmilyConstants.FACEBOOK_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                        .add("client_id", FarmilyConstants.FACEBOOK_CLIENT_ID)
                        .add("client_secret", FarmilyConstants.FACEBOOK_CLIENT_SECRET)
                        .add("redirect_uri", FarmilyConstants.FACEBOOK_REDIRECT_URI)
                        .add("code", code)
                        .build()
                )
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static FacebookAccount getUserInfo(final String accessToken) throws IOException {
        String link = FarmilyConstants.FACEBOOK_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        FacebookAccount fbAccount = new Gson().fromJson(response, FacebookAccount.class);
        return fbAccount;
    }

    public static User loginOrRegister(FacebookAccount fbAccount) {
        AuthDao authDao = new AuthDao();
        User user = authDao.getUserByFacebookId(fbAccount.getId());
        
        if (user == null) {
            if (fbAccount.getEmail() != null) {
                user = authDao.getUserByUsername(fbAccount.getEmail());
            }
            if (user == null) {
                user = new User();
                user.setName(fbAccount.getName());
                user.setEmail(fbAccount.getEmail() != null ? fbAccount.getEmail() : fbAccount.getId() + "@facebook.com");
                user.setFacebookId(fbAccount.getId());
                user.setRole("USER");
                
                authDao.insertUserWithFacebook(user);
                user = authDao.getUserByFacebookId(fbAccount.getId());
            }
        }
        return user;
    }
}
