package group36.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import group36.dao.AuthDao;
import group36.model.User;
import group36.util.FarmilyConstants;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import java.io.IOException;

public class GoogleAuthService {
    public static class GoogleAccount {
        private String id, email, name, first_name, given_name, family_name, picture;
        private boolean verified_email;

        public GoogleAccount(String id, String email, String name, String first_name, String given_name, String family_name, String picture, boolean verified_email) {
            this.id = id;
            this.email = email;
            this.name = name;
            this.first_name = first_name;
            this.given_name = given_name;
            this.family_name = family_name;
            this.picture = picture;
            this.verified_email = verified_email;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getFirst_name() {
            return first_name;
        }

        public void setFirst_name(String first_name) {
            this.first_name = first_name;
        }

        public String getGiven_name() {
            return given_name;
        }

        public void setGiven_name(String given_name) {
            this.given_name = given_name;
        }

        public String getFamily_name() {
            return family_name;
        }

        public void setFamily_name(String family_name) {
            this.family_name = family_name;
        }

        public String getPicture() {
            return picture;
        }

        public void setPicture(String picture) {
            this.picture = picture;
        }

        public boolean isVerified_email() {
            return verified_email;
        }

        public void setVerified_email(boolean verified_email) {
            this.verified_email = verified_email;
        }
    }

    public static String getToken(String code) throws IOException {
        String reponse = Request.Post(FarmilyConstants.GOOGLE_LINK_GET_TOKEN).bodyForm(Form.form()
                        .add("client_id", FarmilyConstants.GOOGLE_CLIENT_ID)
                        .add("client_secret", FarmilyConstants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", FarmilyConstants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", FarmilyConstants.GOOGLE_GRANT_TYPE).build())
                .execute().returnContent().asString();
        JsonObject jo = new Gson().fromJson(reponse, JsonObject.class);
        String accessToken = jo.get("access_token").toString().replaceAll("\"", "");
        return accessToken;

    }

    public static GoogleAccount getUserInfo(final String accessToken) throws IOException {
        String response = Request.Get(FarmilyConstants.GOOGLE_LINK_GET_USER_INFO + accessToken).execute().returnContent().asString();
        return new Gson().fromJson(response, GoogleAccount.class);
    }

    public static User loginOrRegister(GoogleAccount googleAccount) {
        AuthDao authDao = new AuthDao();
        User user = authDao.getUserByGoogleId(googleAccount.getId());

        if (user == null) {
            user = authDao.getUserByUsername(googleAccount.getEmail());
            if (user == null) {
                user = new User();
                user.setName(googleAccount.getName());
                user.setEmail(googleAccount.getEmail());
                user.setGoogleId(googleAccount.getId());
                user.setRole("user"); // Set default role
                authDao.insertUserWithGoogle(user);
                user = authDao.getUserByGoogleId(googleAccount.getId());
            }
        }
        return user;
    }
}
