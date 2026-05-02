package group36.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import java.io.IOException;

public class RecaptchaUtil {
    private static final String GOOGLE_RECAPTCHA_ENDPOINT = "https://www.google.com/recaptcha/api/siteverify";

    public static boolean verify(String gRecaptchaResponse) {
        if (gRecaptchaResponse == null || gRecaptchaResponse.isEmpty()) {
            return false;
        }

        try {
            String response = Request.Post(GOOGLE_RECAPTCHA_ENDPOINT)
                    .bodyForm(Form.form()
                            .add("secret", FarmilyConstants.RECAPTCHA_SECRET_KEY)
                            .add("response", gRecaptchaResponse)
                            .build()).execute().returnContent().asString();

            JsonObject jsonObject = new Gson().fromJson(response, JsonObject.class);
            return jsonObject.get("success").getAsBoolean();
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
