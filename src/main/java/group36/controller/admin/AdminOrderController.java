package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Order;
import group36.service.OrderService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = { "/admin/orders", "/admin/orders/*" })
public class AdminOrderController extends HttpServlet {
    private final OrderService orderService;

    private static final int PAGE_SIZE = 10;

    public AdminOrderController() {
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {

                listOrders(request, response);
            } else if (pathInfo.equals("/detail")) {

                showOrderDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listOrders(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.equals("/update-status")) {
                updateOrderStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.isEmpty())
            statusFilter = null;

        String keyword = request.getParameter("q");
        if (keyword != null)
            keyword = keyword.trim();
        if (keyword != null && keyword.isEmpty())
            keyword = null;

        String fromDate = request.getParameter("fromDate");
        if (fromDate != null && fromDate.isEmpty())
            fromDate = null;

        String toDate = request.getParameter("toDate");
        if (toDate != null && toDate.isEmpty())
            toDate = null;

        List<Order> orders = orderService.getOrdersFiltered(statusFilter, keyword, fromDate, toDate, page, PAGE_SIZE);
        int totalOrders = orderService.countOrdersFiltered(statusFilter, keyword, fromDate, toDate);

        for (Order order : orders) {
            orderService.loadOrderDetailsForAdmin(order);
        }

        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        int pendingCount = orderService.countOrdersByStatus("pending");
        int processingCount = orderService.countOrdersByStatus("processing")
                + orderService.countOrdersByStatus("confirmed");
        int shippingCount = orderService.countOrdersByStatus("shipping");
        int completedCount = orderService.countOrdersByStatus("completed");
        int cancelledCount = orderService.countOrdersByStatus("cancelled");

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "");
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");
        request.setAttribute("pageSize", PAGE_SIZE);

        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("processingCount", processingCount);
        request.setAttribute("shippingCount", shippingCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);

        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            java.util.Optional<Order> orderOpt = orderService.getOrderById(orderId);

            if (orderOpt.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Không tìm thấy đơn hàng #" + orderId);
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            request.setAttribute("order", orderOpt.get());
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String orderIdParam = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        if (orderIdParam == null || newStatus == null) {
            out.print("{\"success\": false, \"message\": \"Thiếu thông tin\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);

            if (!isValidStatus(newStatus)) {
                out.print("{\"success\": false, \"message\": \"Trạng thái không hợp lệ\"}");
                return;
            }

            boolean updated = orderService.updateOrderStatus(orderId, newStatus);

            if (updated) {
                out.print("{\"success\": true, \"message\": \"Cập nhật trạng thái thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể cập nhật trạng thái\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID đơn hàng không hợp lệ\"}");
        }
    }

    private boolean isValidStatus(String status) {
        return status.equals("pending") ||
                status.equals("confirmed") ||
                status.equals("processing") ||
                status.equals("shipping") ||
                status.equals("completed") ||
                status.equals("cancelled");
    }
}
