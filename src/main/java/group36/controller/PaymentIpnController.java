package group36.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import group36.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.util.Map;

@WebServlet(name = "PaymentIpnController", urlPatterns = { "/api/payment/ipn" })
public class PaymentIpnController extends HttpServlet {

    private PaymentService paymentService;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            StringBuilder rawBody = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    rawBody.append(line);
                }
            }
            String rawPayload = rawBody.toString();
            System.out.println("[IPN] Received payload: " + rawPayload);

            Type mapType = new TypeToken<Map<String, Object>>() {
            }.getType();
            Map<String, Object> payload = gson.fromJson(rawPayload, mapType);

            String secretKeyHeader = request.getHeader("X-Secret-Key");

            boolean success = paymentService.processIpn(rawPayload, payload, secretKeyHeader);

            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"success\":" + success + "}");

        } catch (Exception e) {
            System.err.println("[IPN] Error processing webhook: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"success\":false,\"error\":\"Internal error\"}");
        }
    }
}
