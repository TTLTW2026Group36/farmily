package group36.service;

import group36.dao.CouponDAO;
import group36.model.Coupon;
import java.sql.Timestamp;
import java.util.List;

public class CouponService {
    private final CouponDAO couponDAO;

    public CouponService() {
        this.couponDAO = new CouponDAO();
    }

    public List<Coupon> getAllCoupons() {
        return couponDAO.findAll();
    }

    public Coupon getCouponById(int id) {
        return couponDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại: " + id));
    }

    public Coupon createCoupon(Coupon coupon) {
        validateCoupon(coupon);
        couponDAO.findByCode(coupon.getCode()).ifPresent(existing -> {
            throw new IllegalArgumentException("Mã giảm giá đã tồn tại: " + coupon.getCode());
        });
        int id = couponDAO.insert(coupon);
        coupon.setId(id);
        return coupon;
    }

    public Coupon updateCoupon(Coupon coupon) {
        validateCoupon(coupon);
        couponDAO.findById(coupon.getId())
                .orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại: " + coupon.getId()));
        couponDAO.findByCode(coupon.getCode()).ifPresent(existing -> {
            if (existing.getId() != coupon.getId()) {
                throw new IllegalArgumentException("Mã giảm giá đã tồn tại: " + coupon.getCode());
            }
        });
        couponDAO.update(coupon);
        return coupon;
    }

    public void deleteCoupon(int id) {
        int affected = couponDAO.delete(id);
        if (affected == 0) {
            throw new IllegalArgumentException("Mã giảm giá không tồn tại: " + id);
        }
    }

    private void validateCoupon(Coupon coupon) {
        if (coupon.getCode() == null || coupon.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Mã giảm giá không được để trống");
        }
        if (!coupon.getCode().matches("^[A-Z0-9_-]+$")) {
            throw new IllegalArgumentException("Mã chỉ chứa chữ IN HOA, số, _ và -");
        }
        if (coupon.getDiscountType() == null) {
            throw new IllegalArgumentException("Loại giảm giá là bắt buộc");
        }
        if ("percent".equals(coupon.getDiscountType())) {
            if (coupon.getDiscountValue() <= 0 || coupon.getDiscountValue() > 100) {
                throw new IllegalArgumentException("Phần trăm giảm phải từ 1 đến 100");
            }
        } else if ("fixed".equals(coupon.getDiscountType())) {
            if (coupon.getDiscountValue() <= 0) {
                throw new IllegalArgumentException("Số tiền giảm phải lớn hơn 0");
            }
        }
        if (coupon.getQuantity() <= 0) {
            throw new IllegalArgumentException("Số lượng mã phải lớn hơn 0");
        }
        if (coupon.getMaxUsagePerUser() <= 0) {
            throw new IllegalArgumentException("Giới hạn sử dụng trên mỗi người dùng phải lớn hơn 0");
        }
        if (coupon.getStartDate() == null || coupon.getEndDate() == null) {
            throw new IllegalArgumentException("Thời gian bắt đầu và kết thúc là bắt buộc");
        }
        if (coupon.getEndDate().before(coupon.getStartDate())) {
            throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu");
        }
    }

    public void toggleCouponStatus(int id) {
        Coupon coupon = getCouponById(id);
        couponDAO.updateActiveStatus(id, !coupon.isActive());
    }

    public List<Coupon> searchCoupons(String keyword, String status) {
        return couponDAO.findByFilters(keyword, status);
    }

    public Coupon validateCouponForOrder(String code, Integer userId, double subtotal) {
        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập mã giảm giá");
        }

        Coupon coupon = couponDAO.findByCode(code.toUpperCase().trim())
            .orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại"));

        if (!coupon.isActive()) {
            throw new IllegalArgumentException("Mã giảm giá đã bị vô hiệu hóa");
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (now.before(coupon.getStartDate())) {
            throw new IllegalArgumentException("Mã giảm giá chưa đến thời gian áp dụng");
        }
        if (now.after(coupon.getEndDate())) {
            throw new IllegalArgumentException("Mã giảm giá đã hết hạn");
        }

        if (coupon.getUsedCount() >= coupon.getQuantity()) {
            throw new IllegalArgumentException("Mã giảm giá đã hết lượt sử dụng");
        }

        if (subtotal < coupon.getMinOrderValue()) {
            throw new IllegalArgumentException(
                String.format("Đơn hàng tối thiểu %,.0fđ để sử dụng mã này", coupon.getMinOrderValue()));
        }

        if (userId != null) {
            int userUsage = couponDAO.countUsageByUserAndCoupon(userId, coupon.getId());
            if (userUsage >= coupon.getMaxUsagePerUser()) {
                throw new IllegalArgumentException("Bạn đã sử dụng mã này đạt giới hạn cho phép");
            }
        }

        return coupon;
    }

    public double calculateDiscount(Coupon coupon, double subtotal, double shippingFee) {
        switch (coupon.getDiscountType()) {
            case "percent":
                double discount = subtotal * coupon.getDiscountValue() / 100;
                if (coupon.getMaxDiscount() != null && discount > coupon.getMaxDiscount()) {
                    discount = coupon.getMaxDiscount();
                }
                return discount;
            case "fixed":
                return Math.min(coupon.getDiscountValue(), subtotal);
            case "freeship":
                return shippingFee;
            default:
                return 0;
        }
    }
}

