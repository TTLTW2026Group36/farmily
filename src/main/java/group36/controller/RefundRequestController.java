package group36.controller;

import group36.model.Order;
import group36.model.RefundRequest;
import group36.model.User;
import group36.service.OrderService;
import group36.service.RefundRequestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@WebServlet(name = "RefundRequestController", urlPatterns = {"/ho-so/hoan-tien"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 10L * 1024 * 1024,
        maxRequestSize    = 50L * 1024 * 1024
)
public class RefundRequestController extends HttpServlet {

    private static final int    MAX_IMAGES     = 3;
    private static final int    MAX_VIDEOS     = 1;
    private static final long   MAX_FILE_SIZE  = 10L * 1024 * 1024;
    private static final Set<String> ALLOWED_IMAGE_MIMES = Set.of(
            "image/jpeg", "image/png", "image/webp", "image/gif");
    private static final Set<String> ALLOWED_VIDEO_MIMES = Set.of(
            "video/mp4", "video/quicktime", "video/webm");

    private RefundRequestService refundService;
    private OrderService         orderService;

    @Override
    public void init() throws ServletException {
        refundService = new RefundRequestService();
        orderService  = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("auth");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap?redirect=" +
                    java.net.URLEncoder.encode(request.getRequestURI() + "?" + request.getQueryString(), "UTF-8"));
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Optional<Order> orderOpt = orderService.getOrderById(orderId);
            if (orderOpt.isEmpty()) {
                session.setAttribute("errorMessage", "Đơn hàng không tồn tại");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }
            Order order = orderOpt.get();
            if (order.getUserId() == null || order.getUserId() != currentUser.getId()) {
                session.setAttribute("errorMessage", "Bạn không có quyền truy cập đơn hàng này");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
                return;
            }

            Optional<RefundRequest> existingOpt = refundService.getRefundRequestByOrderId(orderId);
            if (existingOpt.isPresent()) {
                session.setAttribute("infoMessage", "Đơn hàng này đã có yêu cầu hoàn tiền");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            if (!refundService.isEligibleForRefund(orderId)) {
                session.setAttribute("errorMessage", "Đơn hàng này không đủ điều kiện yêu cầu hoàn tiền (đã quá 72 giờ hoặc chưa hoàn thành)");
                response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
                return;
            }

            request.setAttribute("order",         order);
            request.setAttribute("refundReasons",  RefundRequest.REASONS);
            request.setAttribute("pageTitle",      "Yêu cầu hoàn tiền — Đơn #" + orderId);
            request.setAttribute("activeTab",      "orders");

            request.getRequestDispatcher("/YeuCauHoanTien.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("auth");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang");
            return;
        }

        String reason      = request.getParameter("reason");
        String description = request.getParameter("description");
        String bankName    = request.getParameter("bankName");
        String bankAccount = request.getParameter("bankAccount");
        String bankHolder  = request.getParameter("bankHolder");

        String validationError = validateFields(reason, description, bankName, bankAccount, bankHolder);
        if (validationError != null) {
            session.setAttribute("errorMessage", validationError);
            response.sendRedirect(request.getContextPath() + "/ho-so/hoan-tien?orderId=" + orderId);
            return;
        }

        List<Part> mediaParts = collectMediaParts(request);
        String mediaError = validateMedia(mediaParts);
        if (mediaError != null) {
            session.setAttribute("errorMessage", mediaError);
            response.sendRedirect(request.getContextPath() + "/ho-so/hoan-tien?orderId=" + orderId);
            return;
        }

        try {
            refundService.createRefundRequest(
                    orderId, currentUser.getId(),
                    reason.trim(),
                    description != null ? description.trim() : "",
                    bankName.trim(), bankAccount.trim(), bankHolder.trim(),
                    mediaParts
            );

            session.setAttribute("successMessage", "Yêu cầu hoàn tiền đã được gửi thành công! Chúng tôi sẽ xem xét và phản hồi sớm nhất có thể.");
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);

        } catch (IllegalArgumentException | IllegalStateException e) {
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ho-so/don-hang/chi-tiet?id=" + orderId);
        } catch (Exception e) {
            System.err.println("[RefundRequestController] Error: " + e.getMessage());
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi yêu cầu hoàn tiền. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/ho-so/hoan-tien?orderId=" + orderId);
        }
    }

    private String validateFields(String reason, String description, String bankName, String bankAccount, String bankHolder) {
        if (reason == null || reason.trim().isEmpty())
            return "Vui lòng chọn lý do hoàn tiền";
        if (!RefundRequest.REASONS.contains(reason.trim()))
            return "Lý do không hợp lệ";
        if ("Lý do khác".equals(reason.trim()) && (description == null || description.trim().isEmpty()))
            return "Vui lòng nhập mô tả chi tiết cho lý do khác";
        if (bankName == null || bankName.trim().isEmpty())
            return "Vui lòng nhập tên ngân hàng";
        if (bankAccount == null || bankAccount.trim().isEmpty())
            return "Vui lòng nhập số tài khoản";
        if (!bankAccount.trim().matches("\\d+"))
            return "Số tài khoản chỉ được chứa chữ số";
        if (bankHolder == null || bankHolder.trim().isEmpty())
            return "Vui lòng nhập tên chủ tài khoản";
        return null;
    }

    private List<Part> collectMediaParts(HttpServletRequest request) throws ServletException, IOException {
        List<Part> parts = new ArrayList<>();
        try {
            Collection<Part> all = request.getParts();
            for (Part p : all) {
                if ("mediaFiles".equals(p.getName()) && p.getSize() > 0) {
                    parts.add(p);
                }
            }
        } catch (IllegalStateException e) {
        }
        return parts;
    }

    private String validateMedia(List<Part> parts) {
        int imageCount = 0, videoCount = 0;
        for (Part p : parts) {
            if (p.getSize() > MAX_FILE_SIZE)
                return "File '" + p.getSubmittedFileName() + "' vượt quá 10MB";
            String mime = p.getContentType();
            if (ALLOWED_IMAGE_MIMES.contains(mime))      imageCount++;
            else if (ALLOWED_VIDEO_MIMES.contains(mime)) videoCount++;
            else return "Định dạng file không hỗ trợ: " + mime;
        }
        if (imageCount > MAX_IMAGES) return "Tối đa " + MAX_IMAGES + " ảnh";
        if (videoCount > MAX_VIDEOS) return "Tối đa " + MAX_VIDEOS + " video";
        return null;
    }
}
