package group36.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class CloudinaryConfig {

    private static volatile Cloudinary instance;

    public static Cloudinary get() {
        if (instance == null) {
            synchronized (CloudinaryConfig.class) {
                if (instance == null) {
                    instance = build();
                }
            }
        }
        return instance;
    }

    private static Cloudinary build() {
        Properties props = new Properties();
        try (InputStream in = CloudinaryConfig.class.getClassLoader()
                .getResourceAsStream("cloudinary.properties")) {
            if (in == null) {
                throw new IllegalStateException(
                        "cloudinary.properties not found in classpath. "
                                + "Copy cloudinary.properties.example and fill in credentials.");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load cloudinary.properties", e);
        }

        String cloudName = props.getProperty("cloud_name");
        String apiKey = props.getProperty("api_key");
        String apiSecret = props.getProperty("api_secret");

        if (isBlank(cloudName) || isBlank(apiKey) || isBlank(apiSecret)) {
            throw new IllegalStateException(
                    "Cloudinary credentials missing. Required keys: cloud_name, api_key, api_secret");
        }

        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true));
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
