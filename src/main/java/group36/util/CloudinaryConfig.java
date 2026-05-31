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
                .getResourceAsStream("config.properties")) {
            if (in == null) {
                throw new IllegalStateException(
                        "config.properties not found in classpath. "
                                + "Please ensure config.properties exists and contains Cloudinary credentials.");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load config.properties", e);
        }

        String cloudName = props.getProperty("cloudinary.cloud_name");
        String apiKey = props.getProperty("cloudinary.api_key");
        String apiSecret = props.getProperty("cloudinary.api_secret");

        if (isBlank(cloudName) || isBlank(apiKey) || isBlank(apiSecret)) {
            throw new IllegalStateException(
                    "Cloudinary credentials missing. Required keys: cloudinary.cloud_name, cloudinary.api_key, cloudinary.api_secret");
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
