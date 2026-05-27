package group36.service;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import group36.util.FarmilyConstants;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GhnService {

    private static final String BASE_URL = "https://dev-online-gateway.ghn.vn/shiip/public-api";
    private static final int DEFAULT_WEIGHT = 500;
    private static final int DEFAULT_LENGTH = 20;
    private static final int DEFAULT_WIDTH  = 20;
    private static final int DEFAULT_HEIGHT = 10;
    private static final int SERVICE_TYPE_ID = 2;
    private static final int CONNECT_TIMEOUT = 5000;
    private static final int READ_TIMEOUT = 10000;

    private final String apiToken;
    private final int shopId;
    private final int fromDistrictId;
    private final String fromWardCode;
    private final Gson gson;

    public GhnService() {
        this.apiToken = FarmilyConstants.GHN_API_TOKEN;
        this.shopId = FarmilyConstants.GHN_SHOP_ID;
        this.fromDistrictId = FarmilyConstants.GHN_FROM_DISTRICT_ID;
        this.fromWardCode = FarmilyConstants.GHN_FROM_WARD_CODE;
        this.gson = new Gson();
    }

    public String getProvinces() {
        return callGhnApi("/master-data/province", "GET", null, false);
    }

    public String getDistricts(int provinceId) {
        JsonObject body = new JsonObject();
        body.addProperty("province_id", provinceId);
        return callGhnApi("/master-data/district", "POST", body.toString(), false);
    }

    public String getWards(int districtId) {
        JsonObject body = new JsonObject();
        body.addProperty("district_id", districtId);
        return callGhnApi("/master-data/ward", "POST", body.toString(), false);
    }

    public double calculateFee(int toDistrictId, String toWardCode, double insuranceValue) {
        JsonObject body = new JsonObject();
        body.addProperty("service_type_id", SERVICE_TYPE_ID);
        body.addProperty("from_district_id", fromDistrictId);
        body.addProperty("from_ward_code", fromWardCode);
        body.addProperty("to_district_id", toDistrictId);
        body.addProperty("to_ward_code", toWardCode);
        body.addProperty("weight", DEFAULT_WEIGHT);
        body.addProperty("length", DEFAULT_LENGTH);
        body.addProperty("width", DEFAULT_WIDTH);
        body.addProperty("height", DEFAULT_HEIGHT);
        body.addProperty("insurance_value", (int) insuranceValue);

        String response = callGhnApi("/v2/shipping-order/fee", "POST", body.toString(), true);

        try {
            JsonObject json = gson.fromJson(response, JsonObject.class);
            int code = json.has("code") ? json.get("code").getAsInt() : -1;

            if (code != 200) {
                String message = json.has("message") ? json.get("message").getAsString() : "Unknown error";
                throw new RuntimeException("GHN API error (code=" + code + "): " + message);
            }

            JsonElement data = json.get("data");
            if (data == null || data.isJsonNull()) {
                throw new RuntimeException("GHN API trả về data null");
            }

            JsonObject dataObj = data.getAsJsonObject();
            if (!dataObj.has("total")) {
                throw new RuntimeException("GHN API response thiếu field 'total'");
            }

            return dataObj.get("total").getAsDouble();
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi parse GHN API response: " + e.getMessage(), e);
        }
    }

    private String callGhnApi(String endpoint, String method, String jsonBody, boolean includeShopId) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(BASE_URL + endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod(method);
            conn.setConnectTimeout(CONNECT_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);

            conn.setRequestProperty("Token", apiToken);
            conn.setRequestProperty("Content-Type", "application/json");
            if (includeShopId) {
                conn.setRequestProperty("ShopId", String.valueOf(shopId));
            }

            if (jsonBody != null && ("POST".equals(method) || "PUT".equals(method))) {
                conn.setDoOutput(true);
                try (OutputStream os = conn.getOutputStream()) {
                    os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
                    os.flush();
                }
            }

            int responseCode = conn.getResponseCode();
            InputStream inputStream;
            if (responseCode >= 200 && responseCode < 300) {
                inputStream = conn.getInputStream();
            } else {
                inputStream = conn.getErrorStream();
            }

            if (inputStream == null) {
                throw new RuntimeException("GHN API: no response body (HTTP " + responseCode + ")");
            }

            String responseBody = readStream(inputStream);

            if (responseCode < 200 || responseCode >= 300) {
                throw new RuntimeException("GHN API HTTP " + responseCode + ": " + responseBody);
            }

            return responseBody;
        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi kết nối GHN API: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String readStream(InputStream is) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}
