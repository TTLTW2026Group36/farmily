package group36.controller;

import group36.model.Coupon;
import group36.service.CouponService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CouponListController", urlPatterns = {"/ma-giam-gia"})
public class CouponListController extends HttpServlet {
    private CouponService couponService;

    @Override
    public void init() {
        couponService = new CouponService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Coupon> coupons = couponService.getPublicCoupons();
        request.setAttribute("coupons", coupons);
        request.setAttribute("pageTitle", "Mã Giảm Giá");
        request.getRequestDispatcher("/MaGiamGia.jsp").forward(request, response);
    }
}
