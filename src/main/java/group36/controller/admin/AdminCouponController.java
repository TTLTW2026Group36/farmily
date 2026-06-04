package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Coupon;
import group36.service.CouponService;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "AdminCouponController", urlPatterns = { "/admin/coupons", "/admin/coupons/*" })
public class AdminCouponController extends HttpServlet {
    private final CouponService couponService;

    public AdminCouponController() {
        this.couponService = new CouponService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listCoupons(request, response);
            } else if (pathInfo.equals("/add")) {
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else if (pathInfo.equals("/detail")) {
                showCouponDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listCoupons(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/add")) {
                createCoupon(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateCoupon(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteCoupon(request, response);
            } else if (pathInfo.equals("/toggle")) {
                toggleCoupon(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        }
    }

    private void toggleCoupon(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            couponService.toggleCouponStatus(id);
            Coupon updated = couponService.getCouponById(id);
            response.getWriter().print("{\"success\":true,\"isActive\":" + updated.isActive() 
                + ",\"statusText\":\"" + updated.getStatusText() + "\""
                + ",\"statusClass\":\"" + updated.getStatusBadgeClass() + "\"}");
        } catch (Exception e) {
            response.getWriter().print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    private void listCoupons(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Coupon> coupons;
        if ((keyword != null && !keyword.isEmpty()) || (status != null && !status.isEmpty())) {
            coupons = couponService.searchCoupons(keyword, status);
        } else {
            coupons = couponService.getAllCoupons();
        }

        request.setAttribute("coupons", coupons);
        request.setAttribute("currentKeyword", keyword);
        request.setAttribute("currentStatus", status);

        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/coupons.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/coupon-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
            return;
        }

        int id = Integer.parseInt(idParam);
        Coupon coupon = couponService.getCouponById(id);
        boolean hasUsage = couponService.hasUsage(id);
        int actualUsedCount = hasUsage ? couponService.getActualUsedCount(id) : 0;

        request.setAttribute("coupon", coupon);
        request.setAttribute("hasUsage", hasUsage);
        request.setAttribute("actualUsedCount", actualUsedCount);
        request.getRequestDispatcher("/admin/coupon-edit.jsp").forward(request, response);
    }

    private void createCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String code = request.getParameter("code").toUpperCase().trim();
            String discountType = request.getParameter("discountType");
            double discountValue = 0;
            if (request.getParameter("discountValue") != null && !request.getParameter("discountValue").isEmpty()) {
                discountValue = Double.parseDouble(request.getParameter("discountValue"));
            }
            Double maxDiscount = null;
            if (request.getParameter("maxDiscount") != null && !request.getParameter("maxDiscount").isEmpty()) {
                maxDiscount = Double.parseDouble(request.getParameter("maxDiscount"));
            }
            double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int maxUsagePerUser = Integer.parseInt(request.getParameter("maxUsagePerUser"));
            Timestamp startDate = parseTimestamp(request.getParameter("startDate"));
            Timestamp endDate = parseTimestamp(request.getParameter("endDate"));
            boolean isActive = request.getParameter("isActive") != null;

            Coupon coupon = new Coupon(code, discountType, discountValue, maxDiscount, minOrderValue, quantity, maxUsagePerUser, startDate, endDate, isActive);
            couponService.createCoupon(coupon);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Thêm mã giảm giá thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());

            Coupon coupon = new Coupon();
            coupon.setCode(request.getParameter("code"));
            coupon.setDiscountType(request.getParameter("discountType"));
            try {
                if (request.getParameter("discountValue") != null && !request.getParameter("discountValue").isEmpty()) {
                    coupon.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("maxDiscount") != null && !request.getParameter("maxDiscount").isEmpty()) {
                    coupon.setMaxDiscount(Double.parseDouble(request.getParameter("maxDiscount")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("minOrderValue") != null && !request.getParameter("minOrderValue").isEmpty()) {
                    coupon.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("quantity") != null && !request.getParameter("quantity").isEmpty()) {
                    coupon.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("maxUsagePerUser") != null && !request.getParameter("maxUsagePerUser").isEmpty()) {
                    coupon.setMaxUsagePerUser(Integer.parseInt(request.getParameter("maxUsagePerUser")));
                }
            } catch (Exception ignored) {}
            try {
                coupon.setStartDate(parseTimestamp(request.getParameter("startDate")));
            } catch (Exception ignored) {}
            try {
                coupon.setEndDate(parseTimestamp(request.getParameter("endDate")));
            } catch (Exception ignored) {}
            coupon.setActive(request.getParameter("isActive") != null);

            request.setAttribute("coupon", coupon);
            request.getRequestDispatcher("/admin/coupon-add.jsp").forward(request, response);
        }
    }

    private void updateCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            String code = request.getParameter("code").toUpperCase().trim();
            String discountType = request.getParameter("discountType");
            double discountValue = 0;
            if (request.getParameter("discountValue") != null && !request.getParameter("discountValue").isEmpty()) {
                discountValue = Double.parseDouble(request.getParameter("discountValue"));
            }
            Double maxDiscount = null;
            if (request.getParameter("maxDiscount") != null && !request.getParameter("maxDiscount").isEmpty()) {
                maxDiscount = Double.parseDouble(request.getParameter("maxDiscount"));
            }
            double minOrderValue = Double.parseDouble(request.getParameter("minOrderValue"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int maxUsagePerUser = Integer.parseInt(request.getParameter("maxUsagePerUser"));
            Timestamp startDate = parseTimestamp(request.getParameter("startDate"));
            Timestamp endDate = parseTimestamp(request.getParameter("endDate"));
            boolean isActive = request.getParameter("isActive") != null;
            int usedCount = Integer.parseInt(request.getParameter("usedCount"));

            Coupon coupon = new Coupon(code, discountType, discountValue, maxDiscount, minOrderValue, quantity, maxUsagePerUser, startDate, endDate, isActive);
            coupon.setId(id);
            coupon.setUsedCount(usedCount);
            couponService.updateCoupon(coupon);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Cập nhật mã giảm giá thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());

            Coupon coupon = new Coupon();
            coupon.setId(id);
            coupon.setCode(request.getParameter("code"));
            coupon.setDiscountType(request.getParameter("discountType"));
            try {
                if (request.getParameter("discountValue") != null && !request.getParameter("discountValue").isEmpty()) {
                    coupon.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("maxDiscount") != null && !request.getParameter("maxDiscount").isEmpty()) {
                    coupon.setMaxDiscount(Double.parseDouble(request.getParameter("maxDiscount")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("minOrderValue") != null && !request.getParameter("minOrderValue").isEmpty()) {
                    coupon.setMinOrderValue(Double.parseDouble(request.getParameter("minOrderValue")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("quantity") != null && !request.getParameter("quantity").isEmpty()) {
                    coupon.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("maxUsagePerUser") != null && !request.getParameter("maxUsagePerUser").isEmpty()) {
                    coupon.setMaxUsagePerUser(Integer.parseInt(request.getParameter("maxUsagePerUser")));
                }
            } catch (Exception ignored) {}
            try {
                if (request.getParameter("usedCount") != null && !request.getParameter("usedCount").isEmpty()) {
                    coupon.setUsedCount(Integer.parseInt(request.getParameter("usedCount")));
                }
            } catch (Exception ignored) {}
            try {
                coupon.setStartDate(parseTimestamp(request.getParameter("startDate")));
            } catch (Exception ignored) {}
            try {
                coupon.setEndDate(parseTimestamp(request.getParameter("endDate")));
            } catch (Exception ignored) {}
            coupon.setActive(request.getParameter("isActive") != null);

            request.setAttribute("coupon", coupon);
            request.getRequestDispatcher("/admin/coupon-edit.jsp").forward(request, response);
        }
    }

    private void deleteCoupon(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        try {
            couponService.deleteCoupon(id);
            session.setAttribute("success", "Xóa mã giảm giá thành công!");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/coupons");
    }

    private void showCouponDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Coupon coupon = couponService.getCouponById(id);
        List<group36.model.CouponUsage> usageHistory = couponService.getCouponUsageHistory(id);
        double totalDiscount = couponService.getTotalDiscountAmount(id);
        
        request.setAttribute("coupon", coupon);
        request.setAttribute("usageHistory", usageHistory);
        request.setAttribute("totalDiscount", totalDiscount);
        request.getRequestDispatcher("/admin/coupon-detail.jsp").forward(request, response);
    }

    private Timestamp parseTimestamp(String datetimeStr) {
        if (datetimeStr == null || datetimeStr.isEmpty()) {
            return null;
        }
        LocalDateTime ldt = LocalDateTime.parse(datetimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        return Timestamp.valueOf(ldt);
    }
}
