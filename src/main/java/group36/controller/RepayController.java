package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Order;
import group36.model.User;
import group36.service.OrderService;
import group36.service.PaymentService;
import group36.service.payment.PaymentCreateResult;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;

@WebServlet(name = "RepayController", urlPatterns = { "/payment/repay" })
public class RepayController extends HttpServlet {

    private OrderService orderService;
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User authUser = (User) session.getAttribute("auth");

        try {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null || orderIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            Order order = orderOpt.get();

            if (order.getUserId() != null) {
                if (authUser == null || authUser.getId() != order.getUserId().intValue()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thanh toán đơn hàng này.");
                    return;
                }
            }

            if (!Order.STATUS_PENDING.equals(order.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            if (!order.isOnlinePayment()) {
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            PaymentCreateResult paymentResult = paymentService.createPayment(order);

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<meta charset='UTF-8'>");
            out.println("<title>Đang chuyển hướng thanh toán...</title>");
            out.println("<style>");
            out.println("body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; background-color: #f9fafb; margin: 0; color: #374151; }");
            out.println(".spinner { border: 4px solid #f3f4f6; border-top: 4px solid #22c55e; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite; margin-bottom: 20px; }");
            out.println("@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='spinner'></div>");
            out.println("<h2>Đang chuyển hướng tới cổng thanh toán ngân hàng...</h2>");
            out.println("<p>Vui lòng không đóng trình duyệt hoặc nhấn nút quay lại.</p>");
            out.println(paymentResult.getCheckoutFormHtml());
            out.println("<script>document.forms[0].submit();</script>");
            out.println("</body>");
            out.println("</html>");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra khi tạo lại thanh toán.");
        }
    }
}
