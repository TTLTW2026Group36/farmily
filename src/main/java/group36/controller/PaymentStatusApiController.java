package group36.controller;

import com.google.gson.Gson;
import group36.model.Payment;
import group36.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "PaymentStatusApiController", urlPatterns = { "/api/payment/status" })
public class PaymentStatusApiController extends HttpServlet {

    private PaymentService paymentService;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing orderId parameter\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Optional<Payment> paymentOpt = paymentService.getLatestPayment(orderId);

            Map<String, Object> result = new HashMap<>();

            if (paymentOpt.isPresent()) {
                Payment payment = paymentOpt.get();
                result.put("found", true);
                result.put("status", payment.getStatus());
                result.put("statusText", payment.getStatusText());
                result.put("paymentCode", payment.getPaymentCode());
                result.put("paid", payment.isPaid());
                result.put("expired", payment.isExpired());
                result.put("amount", payment.getFormattedAmount());
            } else {
                result.put("found", false);
                result.put("status", "unpaid");
                result.put("statusText", "Chưa có thanh toán");
            }

            out.print(gson.toJson(result));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid orderId\"}");
        } catch (Exception e) {
            System.err.println("[PaymentStatus] Error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Internal error\"}");
        }
    }
}
