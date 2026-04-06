package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Order;
import group36.service.OrderService;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "OrderConfirmController", urlPatterns = { "/order-confirmation", "/xac-nhan-don-hang" })
public class OrderConfirmController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {

            String orderIdStr = request.getParameter("id");
            Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");

            int orderId;
            if (orderIdStr != null && !orderIdStr.isEmpty()) {
                orderId = Integer.parseInt(orderIdStr);
            } else if (lastOrderId != null) {
                orderId = lastOrderId;

                session.removeAttribute("lastOrderId");
            } else {

                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {

                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Order order = orderOpt.get();

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Đặt hàng thành công");

            String paymentCallback = request.getParameter("payment");
            if (paymentCallback != null) {
                request.setAttribute("paymentCallback", paymentCallback);
            }

            request.getRequestDispatcher("/ThankYou.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
