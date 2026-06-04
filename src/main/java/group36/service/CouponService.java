package group36.service;

import group36.dao.CouponDAO;
import group36.dao.CouponUsageDAO;
import group36.dao.SavedCouponDAO;
import group36.model.Coupon;
import group36.model.CouponUsage;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CouponService {
    private final CouponDAO couponDAO;
    private final CouponUsageDAO couponUsageDAO;
    private final SavedCouponDAO savedCouponDAO;

    public CouponService() {
        this.couponDAO = new CouponDAO();
        this.couponUsageDAO = new CouponUsageDAO();
        this.savedCouponDAO = new SavedCouponDAO();
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
        Coupon existing = couponDAO.findById(coupon.getId())
                .orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại: " + coupon.getId()));
        couponDAO.findByCode(coupon.getCode()).ifPresent(other -> {
            if (other.getId() != coupon.getId()) {
                throw new IllegalArgumentException("Mã giảm giá đã tồn tại: " + coupon.getCode());
            }
        });

        if (hasUsage(coupon.getId())) {
            if (!existing.getCode().equals(coupon.getCode())) {
                throw new IllegalArgumentException("Không thể sửa mã code của coupon đã được sử dụng.");
            }
            if (!existing.getDiscountType().equals(coupon.getDiscountType())) {
                throw new IllegalArgumentException("Không thể sửa loại giảm giá của coupon đã được sử dụng.");
            }
            if (existing.getDiscountValue() != coupon.getDiscountValue()) {
                throw new IllegalArgumentException("Không thể sửa giá trị giảm của coupon đã được sử dụng.");
            }
            if (!java.util.Objects.equals(existing.getMaxDiscount(), coupon.getMaxDiscount())) {
                throw new IllegalArgumentException("Không thể sửa giảm tối đa của coupon đã được sử dụng.");
            }
            if (existing.getMaxUsagePerUser() != coupon.getMaxUsagePerUser()) {
                throw new IllegalArgumentException("Không thể sửa giới hạn sử dụng/người của coupon đã được sử dụng.");
            }
            int actualUsed = getActualUsedCount(coupon.getId());
            if (coupon.getQuantity() < actualUsed) {
                throw new IllegalArgumentException(
                    "Số lượng mã không được nhỏ hơn số lượt đã sử dụng (" + actualUsed + ").");
            }
        }

        couponDAO.update(coupon);
        return coupon;
    }

    public void deleteCoupon(int id) {
        if (hasUsage(id)) {
            throw new IllegalArgumentException(
                "Không thể xoá mã giảm giá đã được sử dụng. Hãy tắt mã thay vì xoá.");
        }
        int affected = couponDAO.delete(id);
        if (affected == 0) {
            throw new IllegalArgumentException("Mã giảm giá không tồn tại: " + id);
        }
    }

    public boolean hasUsage(int couponId) {
        return couponDAO.countUsageByCouponId(couponId) > 0;
    }

    public int getActualUsedCount(int couponId) {
        return couponDAO.countUsageByCouponId(couponId);
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

    public List<Coupon> getPublicCoupons() {
        return couponDAO.findActiveCoupons();
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

    public List<CouponUsage> getCouponUsageHistory(int couponId) {
        return couponUsageDAO.findByCouponId(couponId);
    }

    public double getTotalDiscountAmount(int couponId) {
        return couponUsageDAO.getTotalDiscountByCouponId(couponId);
    }

    public void saveCoupon(int userId, int couponId) {
        getCouponById(couponId);
        savedCouponDAO.save(userId, couponId);
    }

    public List<Coupon> getSavedCoupons(int userId) {
        return savedCouponDAO.getSavedCoupons(userId);
    }

    public Set<Integer> getSavedCouponIds(int userId) {
        return savedCouponDAO.getSavedCouponIds(userId);
    }

    public String getUserCouponStatus(int userId, Coupon coupon) {
        int usageCount = couponDAO.countUsageByUserAndCoupon(userId, coupon.getId());
        if (usageCount >= coupon.getMaxUsagePerUser()) {
            return "used";
        }
        if (savedCouponDAO.isSaved(userId, coupon.getId())) {
            return "saved";
        }
        return "none";
    }

    public Map<String, Object> getAvailableVouchersForCheckout(Integer userId, double subtotal) {
        Map<String, Object> result = new HashMap<>();
        List<Coupon> allActive = couponDAO.findActiveCoupons();
        List<Map<String, Object>> discountList = new ArrayList<>();
        List<Map<String, Object>> freeshipList = new ArrayList<>();

        Set<Integer> savedIds = userId != null ? savedCouponDAO.getSavedCouponIds(userId) : new HashSet<>();

        for (Coupon c : allActive) {
            if (userId != null) {
                int usageCount = couponDAO.countUsageByUserAndCoupon(userId, c.getId());
                if (usageCount >= c.getMaxUsagePerUser()) {
                    continue;
                }
            }
            Map<String, Object> item = couponToMap(c);
            boolean eligible = subtotal >= c.getMinOrderValue();
            item.put("eligible", eligible);
            item.put("saved", savedIds.contains(c.getId()));
            if (!eligible) {
                item.put("shortAmount", c.getMinOrderValue() - subtotal);
            }
            item.put("calculatedDiscount", calculateDiscount(c, subtotal, 0));

            if ("freeship".equals(c.getDiscountType())) {
                freeshipList.add(item);
            } else {
                discountList.add(item);
            }
        }

        Comparator<Map<String, Object>> comp = (a, b) -> {
            boolean aE = (boolean) a.get("eligible");
            boolean bE = (boolean) b.get("eligible");
            if (aE != bE) return bE ? 1 : -1;
            return Double.compare((double) b.get("calculatedDiscount"), (double) a.get("calculatedDiscount"));
        };
        discountList.sort(comp);
        freeshipList.sort(comp);

        result.put("discountCoupons", discountList);
        result.put("freeshipCoupons", freeshipList);
        return result;
    }

    private Map<String, Object> couponToMap(Coupon c) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", c.getId());
        m.put("code", c.getCode());
        m.put("discountType", c.getDiscountType());
        m.put("discountValue", c.getDiscountValue());
        m.put("maxDiscount", c.getMaxDiscount());
        m.put("minOrderValue", c.getMinOrderValue());
        m.put("endDate", c.getEndDate());
        m.put("expiringSoon", c.isExpiringSoon());
        m.put("formattedDiscountValue", c.getFormattedDiscountValue());
        m.put("formattedMinOrderValue", c.getFormattedMinOrderValue());
        return m;
    }
}

