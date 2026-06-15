package group36.controller.admin;

import group36.model.RefundRequest;
import group36.model.User;
import group36.model.UserRole;
import group36.service.RefundRequestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AdminRefundController", urlPatterns = {"/admin/refund-requests", "/admin/refund-requests/*"})
public class AdminRefundController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private RefundRequestService refundService;

    @Override
    public void init() throws ServletException {
        refundService = new RefundRequestService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listRefundRequests(request, response);
            } else if (pathInfo.equals("/detail")) {
                showRefundDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("[AdminRefundController] Error: " + e.getMessage());
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listRefundRequests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        response.setContentType("application/json;charset=UTF-8");

        try {
            if ("/approve".equals(pathInfo) || "/reject".equals(pathInfo) || "/confirm".equals(pathInfo)) {
                if (!isAdminOrManager(request)) {
                    writeJson(response, false, "Bạn không có quyền thực hiện hành động này.");
                    return;
                }
            }

            if ("/approve".equals(pathInfo)) {
                handleApprove(request, response);
            } else if ("/reject".equals(pathInfo)) {
                handleReject(request, response);
            } else if ("/confirm".equals(pathInfo)) {
                handleConfirm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("[AdminRefundController] POST error: " + e.getMessage());
            writeJson(response, false, "Có lỗi xảy ra: " + e.getMessage());
        }
    }

    private void listRefundRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = parseIntOrDefault(request.getParameter("page"), 1);
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.isEmpty()) statusFilter = null;

        List<RefundRequest> requests = refundService.getRefundRequests(statusFilter, page, PAGE_SIZE);
        int total = refundService.countRefundRequests(statusFilter);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        int pendingCount  = refundService.countRefundRequests(RefundRequest.STATUS_PENDING);
        int approvedCount = refundService.countRefundRequests(RefundRequest.STATUS_APPROVED);
        int rejectedCount = refundService.countRefundRequests(RefundRequest.STATUS_REJECTED);
        int refundedCount = refundService.countRefundRequests(RefundRequest.STATUS_REFUNDED);

        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.setAttribute("requests",      requests);
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("total",         total);
        request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "");
        request.setAttribute("pageSize",      PAGE_SIZE);
        request.setAttribute("pendingCount",  pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("refundedCount", refundedCount);

        request.getRequestDispatcher("/admin/refund-requests.jsp").forward(request, response);
    }

    private void showRefundDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/refund-requests");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            var refundOpt = refundService.getRefundRequestById(id);

            if (refundOpt.isEmpty()) {
                request.getSession().setAttribute("error", "Không tìm thấy yêu cầu hoàn tiền #" + id);
                response.sendRedirect(request.getContextPath() + "/admin/refund-requests");
                return;
            }

            request.setAttribute("refund", refundOpt.get());
            request.getRequestDispatcher("/admin/refund-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/refund-requests");
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int refundId = parseIntOrDefault(request.getParameter("refundId"), 0);
        String adminNote = request.getParameter("adminNote");
        String amountStr = request.getParameter("refundAmount");
        double refundAmount = 0;

        if (refundId == 0) {
            writeJson(response, false, "Thiếu ID yêu cầu hoàn tiền");
            return;
        }
        if (amountStr != null && !amountStr.isEmpty()) {
            try { refundAmount = Double.parseDouble(amountStr.replace(",", "")); }
            catch (NumberFormatException e) { }
        }

        int adminId = getAdminId(request);
        boolean ok = refundService.approveRefundRequest(refundId, refundAmount, adminNote, adminId);

        if (ok) {
            writeJson(response, true, "Đã duyệt yêu cầu hoàn tiền #" + refundId);
        } else {
            writeJson(response, false, "Không thể duyệt (trạng thái không hợp lệ hoặc không tồn tại)");
        }
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int refundId = parseIntOrDefault(request.getParameter("refundId"), 0);
        String adminNote = request.getParameter("adminNote");

        if (refundId == 0) {
            writeJson(response, false, "Thiếu ID yêu cầu hoàn tiền");
            return;
        }

        int adminId = getAdminId(request);
        boolean ok = refundService.rejectRefundRequest(refundId, adminNote, adminId);

        if (ok) {
            writeJson(response, true, "Đã từ chối yêu cầu hoàn tiền #" + refundId);
        } else {
            writeJson(response, false, "Không thể từ chối (trạng thái không hợp lệ hoặc không tồn tại)");
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int refundId = parseIntOrDefault(request.getParameter("refundId"), 0);
        String transactionCode = request.getParameter("transactionCode");

        if (refundId == 0) {
            writeJson(response, false, "Thiếu ID yêu cầu hoàn tiền");
            return;
        }
        if (transactionCode == null || transactionCode.trim().isEmpty()) {
            writeJson(response, false, "Vui lòng nhập mã giao dịch");
            return;
        }

        int adminId = getAdminId(request);
        boolean ok = refundService.confirmRefunded(refundId, transactionCode.trim(), adminId);

        if (ok) {
            writeJson(response, true, "Đã xác nhận hoàn tiền thành công");
        } else {
            writeJson(response, false, "Không thể xác nhận (yêu cầu phải ở trạng thái 'Đã duyệt')");
        }
    }

    private void writeJson(HttpServletResponse response, boolean success, String message) throws IOException {
        PrintWriter out = response.getWriter();
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"");
        out.print("{\"success\": " + success + ", \"message\": \"" + escaped + "\"}");
    }

    private int getAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("adminUser");
        if (admin == null) admin = (User) session.getAttribute("auth");
        return admin != null ? admin.getId() : 0;
    }

    private boolean isAdminOrManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User admin = (User) session.getAttribute("adminUser");
        if (admin == null) admin = (User) session.getAttribute("auth");
        if (admin == null) return false;
        UserRole role = UserRole.fromString(admin.getRole());
        return role == UserRole.ADMIN || role == UserRole.MANAGER;
    }

    private int parseIntOrDefault(String value, int def) {
        if (value == null || value.isEmpty()) return def;
        try { return Integer.parseInt(value); }
        catch (NumberFormatException e) { return def; }
    }
}
