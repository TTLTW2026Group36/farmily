package group36.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Coupon;
import group36.model.User;
import group36.service.CouponService;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "CouponApiController", urlPatterns = {"/api/coupon/apply", "/api/coupon/remove", "/api/coupon/save", "/api/coupon/saved", "/api/coupon/available"})
public class CouponApiController extends HttpServlet {
    private CouponService couponService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        couponService = new CouponService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String path = request.getServletPath();

        if ("/api/coupon/saved".equals(path)) {
            handleGetSaved(request, response);
            return;
        }

        if ("/api/coupon/available".equals(path)) {
            handleAvailable(request, response);
            return;
        }

        response.setStatus(404);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String path = request.getServletPath();

        if ("/api/coupon/remove".equals(path)) {
            handleRemove(request, response);
            return;
        } else if ("/api/coupon/save".equals(path)) {
            handleSave(request, response);
            return;
        }

        handleApply(request, response);
    }

    private void handleAvailable(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String subtotalStr = request.getParameter("subtotal");
        if (subtotalStr == null || subtotalStr.trim().isEmpty()) {
            response.getWriter().print(gson.toJson(Map.of("success", false, "message", "Thiếu subtotal")));
            return;
        }
        try {
            double subtotal = Double.parseDouble(subtotalStr);
            User user = (User) request.getSession().getAttribute("auth");
            Integer userId = user != null ? user.getId() : null;
            Map<String, Object> vouchers = couponService.getAvailableVouchersForCheckout(userId, subtotal);
            response.getWriter().print(gson.toJson(Map.of("success", true, "data", vouchers)));
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            response.getWriter().print(gson.toJson(Map.of("success", false, "message", "Có lỗi xảy ra")));
        }
    }

    private void handleApply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String subtotalStr = request.getParameter("subtotal");
        String shippingFeeStr = request.getParameter("shippingFee");
        String slot = request.getParameter("slot");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        Integer userId = user != null ? user.getId() : null;

        try {
            if (subtotalStr == null || subtotalStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu giá trị tạm tính");
            }
            double subtotal = Double.parseDouble(subtotalStr);

            double shippingFee = 0;
            if (shippingFeeStr != null && !shippingFeeStr.trim().isEmpty() && !"undefined".equals(shippingFeeStr) && !"null".equals(shippingFeeStr)) {
                shippingFee = Double.parseDouble(shippingFeeStr);
            }

            Coupon coupon = couponService.validateCouponForOrder(code, userId, subtotal);
            double discountAmount = couponService.calculateDiscount(coupon, subtotal, shippingFee);

            if ("freeship".equals(slot)) {
                session.setAttribute("appliedFreeshipCouponId", coupon.getId());
                session.setAttribute("appliedFreeshipCouponCode", coupon.getCode());
                session.setAttribute("appliedFreeshipDiscountAmount", discountAmount);
            } else {
                session.setAttribute("appliedCouponId", coupon.getId());
                session.setAttribute("appliedCouponCode", coupon.getCode());
                session.setAttribute("appliedDiscountAmount", discountAmount);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("couponId", coupon.getId());
            result.put("code", coupon.getCode());
            result.put("discountType", coupon.getDiscountType());
            result.put("discountAmount", discountAmount);
            result.put("discountText", coupon.getDiscountTypeText());
            result.put("slot", slot != null ? slot : "discount");
            response.getWriter().print(gson.toJson(result));

        } catch (IllegalArgumentException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", e.getMessage());
            response.getWriter().print(gson.toJson(result));
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra khi áp dụng mã giảm giá");
            response.getWriter().print(gson.toJson(result));
        }
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        String slot = request.getParameter("slot");

        if ("freeship".equals(slot)) {
            session.removeAttribute("appliedFreeshipCouponId");
            session.removeAttribute("appliedFreeshipCouponCode");
            session.removeAttribute("appliedFreeshipDiscountAmount");
        } else {
            session.removeAttribute("appliedCouponId");
            session.removeAttribute("appliedCouponCode");
            session.removeAttribute("appliedDiscountAmount");
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        response.getWriter().print(gson.toJson(result));
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) {
            response.setStatus(401);
            response.getWriter().print(gson.toJson(Map.of("success", false, "message", "Vui lòng đăng nhập")));
            return;
        }
        int couponId = Integer.parseInt(request.getParameter("couponId"));
        couponService.saveCoupon(user.getId(), couponId);
        response.getWriter().print(gson.toJson(Map.of("success", true)));
    }

    private void handleGetSaved(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("auth");
        if (user == null) {
            response.setStatus(401);
            response.getWriter().print(gson.toJson(Map.of("success", false, "message", "Vui lòng đăng nhập")));
            return;
        }
        List<Coupon> saved = couponService.getSavedCoupons(user.getId());
        List<Map<String, Object>> result = new ArrayList<>();
        for (Coupon c : saved) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", c.getId());
            item.put("code", c.getCode());
            item.put("discountType", c.getDiscountType());
            item.put("discountValue", c.getDiscountValue());
            item.put("maxDiscount", c.getMaxDiscount());
            item.put("minOrderValue", c.getMinOrderValue());
            item.put("endDate", c.getEndDate());
            item.put("status", c.getStatus());
            item.put("statusText", c.getStatusText());
            item.put("formattedDiscountValue", c.getFormattedDiscountValue());
            item.put("formattedMinOrderValue", c.getFormattedMinOrderValue());
            item.put("userStatus", couponService.getUserCouponStatus(user.getId(), c));
            result.add(item);
        }
        response.getWriter().print(gson.toJson(Map.of("success", true, "coupons", result)));
    }
}
