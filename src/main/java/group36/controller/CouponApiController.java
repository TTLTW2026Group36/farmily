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

@WebServlet(name = "CouponApiController", urlPatterns = {"/api/coupon/apply", "/api/coupon/remove"})
public class CouponApiController extends HttpServlet {
    private CouponService couponService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        couponService = new CouponService();
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
        }

        handleApply(request, response);
    }

    private void handleApply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        String subtotalStr = request.getParameter("subtotal");
        String shippingFeeStr = request.getParameter("shippingFee");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        Integer userId = user != null ? user.getId() : null;

        double subtotal = Double.parseDouble(subtotalStr);
        double shippingFee = Double.parseDouble(shippingFeeStr);

        try {
            Coupon coupon = couponService.validateCouponForOrder(code, userId, subtotal);
            double discountAmount = couponService.calculateDiscount(coupon, subtotal, shippingFee);

            session.setAttribute("appliedCouponId", coupon.getId());
            session.setAttribute("appliedCouponCode", coupon.getCode());
            session.setAttribute("appliedDiscountAmount", discountAmount);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("couponId", coupon.getId());
            result.put("code", coupon.getCode());
            result.put("discountType", coupon.getDiscountType());
            result.put("discountAmount", discountAmount);
            result.put("discountText", coupon.getDiscountTypeText());
            response.getWriter().print(gson.toJson(result));

        } catch (IllegalArgumentException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", e.getMessage());
            response.getWriter().print(gson.toJson(result));
        }
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("appliedCouponId");
        session.removeAttribute("appliedCouponCode");
        session.removeAttribute("appliedDiscountAmount");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        response.getWriter().print(gson.toJson(result));
    }
}
