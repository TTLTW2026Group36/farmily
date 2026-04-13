package group36.controller;

import group36.model.Order;
import group36.model.Payment;
import group36.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "PaymentCallbackController", urlPatterns = {
        "/payment/success", "/payment/error", "/payment/cancel"
})
public class PaymentCallbackController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String invoiceNumber = request.getParameter("invoice");

        String callbackType;
        if (path.endsWith("/success")) {
            callbackType = "success";
        } else if (path.endsWith("/error")) {
            callbackType = "error";
        } else {
            callbackType = "cancel";
        }

        Order order = null;
        Payment payment = null;

        if (invoiceNumber != null && !invoiceNumber.isEmpty()) {
            payment = findPaymentByInvoice(invoiceNumber);
            if (payment != null) {
                Optional<Order> orderOpt = orderService.getOrderById(payment.getOrderId());
                if (orderOpt.isPresent()) {
                    order = orderOpt.get();
                }
            }
        }

        request.setAttribute("callbackType", callbackType);
        request.setAttribute("order", order);
        request.setAttribute("payment", payment);
        request.setAttribute("invoiceNumber", invoiceNumber);
        request.getRequestDispatcher("/PaymentResult.jsp").forward(request, response);
    }

    private Payment findPaymentByInvoice(String invoiceNumber) {
        try {
            group36.dao.PaymentDAO paymentDAO = new group36.dao.PaymentDAO();
            return paymentDAO.findByInvoiceNumber(invoiceNumber).orElse(null);
        } catch (Exception e) {
            System.err.println("[PaymentCallback] Error finding payment: " + e.getMessage());
            return null;
        }
    }
}
