package group36.service.payment;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PaymentConfig {

    private static PaymentConfig instance;

    private final String merchantId;
    private final String secretKey;
    private final String baseUrl;
    private final String callbackBaseUrl;
    private final boolean sandbox;
    private final int expiryMinutes;

    private PaymentConfig() {
        Properties props = new Properties();
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("payment.properties")) {
            if (is != null) {
                props.load(is);
            } else {
                System.err.println("[PaymentConfig] payment.properties not found, using defaults");
            }
        } catch (IOException e) {
            System.err.println("[PaymentConfig] Error loading payment.properties: " + e.getMessage());
        }

        this.merchantId = props.getProperty("sepay.merchant_id", "DEMO_MERCHANT");
        this.secretKey = props.getProperty("sepay.secret_key", "DEMO_SECRET");
        this.sandbox = Boolean.parseBoolean(props.getProperty("sepay.sandbox", "true"));
        this.callbackBaseUrl = props.getProperty("payment.callback_base_url", "http://localhost:8080");
        this.expiryMinutes = Integer.parseInt(props.getProperty("payment.expiry_minutes", "15"));

        if (sandbox) {
            this.baseUrl = props.getProperty("sepay.sandbox_url", "https://pgapi-sandbox.sepay.vn");
        } else {
            this.baseUrl = props.getProperty("sepay.base_url", "https://pg.sepay.vn");
        }

        System.out.println("[PaymentConfig] Loaded: sandbox=" + sandbox + ", baseUrl=" + baseUrl);
    }

    public static synchronized PaymentConfig getInstance() {
        if (instance == null) {
            instance = new PaymentConfig();
        }
        return instance;
    }

    public String getMerchantId() {
        return merchantId;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public String getCallbackBaseUrl() {
        return callbackBaseUrl;
    }

    public boolean isSandbox() {
        return sandbox;
    }

    public int getExpiryMinutes() {
        return expiryMinutes;
    }
}
