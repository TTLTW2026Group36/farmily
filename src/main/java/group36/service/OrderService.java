package group36.service;

import group36.dao.*;
import group36.model.*;
import org.jdbi.v3.core.Handle;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public class OrderService {

    private final OrderDAO orderDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final AddressDAO addressDAO;
    private final PaymentMethodDAO paymentMethodDAO;
    private final PaymentDAO paymentDAO;
    private final CartDAO cartDAO;
    private final CartItemDAO cartItemDAO;
    private final ProductVariantDAO productVariantDAO;
    private final ProductDAO productDAO;
    private final ProductImageDAO productImageDAO;
    private final AdminNotificationService adminNotificationService;
    private final UserNotificationService userNotificationService;
    private final UserDAO userDAO;
    private final FlashSaleDAO flashSaleDAO;
    private final OrderStatusHistoryDAO orderStatusHistoryDAO;
    private final CouponDAO couponDAO;
    private final CouponService couponService;
    private final GhnService ghnService;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderDetailDAO = new OrderDetailDAO();
        this.addressDAO = new AddressDAO();
        this.paymentMethodDAO = new PaymentMethodDAO();
        this.paymentDAO = new PaymentDAO();
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.productImageDAO = new ProductImageDAO();
        this.adminNotificationService = new AdminNotificationService();
        this.userNotificationService = new UserNotificationService();
        this.userDAO = new UserDAO();
        this.flashSaleDAO = new FlashSaleDAO();
        this.orderStatusHistoryDAO = new OrderStatusHistoryDAO();
        this.couponDAO = new CouponDAO();
        this.couponService = new CouponService();
        this.ghnService = new GhnService();
    }

    public Order createOrder(int userId, int addressId, int paymentMethodId, String note, double shippingFee)
            throws IllegalArgumentException {
        return createOrder(userId, addressId, paymentMethodId, note, shippingFee, null, null, null, null);
    }

    public Order createOrder(int userId, int addressId, int paymentMethodId, String note,
                             double shippingFee, String couponCode, Double appliedDiscountAmount)
            throws IllegalArgumentException {
        return createOrder(userId, addressId, paymentMethodId, note, shippingFee, couponCode, appliedDiscountAmount, null, null);
    }

    public Order createOrder(int userId, int addressId, int paymentMethodId, String note,
                             double shippingFee, String couponCode, Double appliedDiscountAmount,
                             String freeshipCouponCode, Double appliedFreeshipDiscountAmount)
            throws IllegalArgumentException {

        Optional<Address> addressOpt = addressDAO.findById(addressId);
        if (addressOpt.isEmpty()) {
            throw new IllegalArgumentException("Địa chỉ không tồn tại");
        }

        Optional<PaymentMethod> paymentOpt = paymentMethodDAO.findById(paymentMethodId);
        if (paymentOpt.isEmpty() || !paymentOpt.get().isActive()) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }

        CartService cartService = new CartService();
        Cart cart = cartService.getCartByUserId(userId);
        List<CartItem> cartItems = cart.getItems();
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }

        double subtotal = 0;
        for (CartItem item : cartItems) {
            loadCartItemDetails(item, userId);
            subtotal += item.getSubtotal();
        }

        for (CartItem item : cartItems) {
            Optional<FlashSale> fsOpt = flashSaleDAO.findActiveByProductId(item.getProductId());
            if (fsOpt.isPresent()) {
                FlashSale fs = fsOpt.get();
                if (fs.getMaxQtyPerUser() > 0) {
                    int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, fs.getProductId(), fs.getStartTime(), fs.getEndTime());
                    if (purchased >= fs.getMaxQtyPerUser()) {
                        throw new IllegalArgumentException("Bạn đã mua sản phẩm " + (item.getProduct() != null ? item.getProduct().getName() : "này") + " đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                    }
                    if (purchased + item.getQuantity() > fs.getMaxQtyPerUser()) {
                        int allowed = fs.getMaxQtyPerUser() - purchased;
                        throw new IllegalArgumentException("Bạn chỉ được mua thêm tối đa " + allowed + " sản phẩm " + (item.getProduct() != null ? item.getProduct().getName() : "này") + " trong chương trình Flash Sale (đã mua: " + purchased + ")");
                    }
                }
            }
        }

        Integer couponId = null;
        double discountAmount = 0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon coupon = couponService.validateCouponForOrder(couponCode, userId, subtotal);
                discountAmount = couponService.calculateDiscount(coupon, subtotal, shippingFee);
                couponId = coupon.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Coupon validation failed: " + e.getMessage());
            }
        }

        Integer freeshipCouponId = null;
        double freeshipDiscountAmount = 0;
        if (freeshipCouponCode != null && !freeshipCouponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon fc = couponService.validateCouponForOrder(freeshipCouponCode, userId, subtotal);
                freeshipDiscountAmount = couponService.calculateDiscount(fc, subtotal, shippingFee);
                freeshipCouponId = fc.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Freeship coupon validation failed: " + e.getMessage());
            }
        }

        double totalPrice = subtotal - discountAmount - freeshipDiscountAmount + shippingFee;
        final Integer finalCouponId = couponId;
        final double finalDiscountAmount = discountAmount;
        final Integer finalFreeshipCouponId = freeshipCouponId;
        final double finalFreeshipDiscountAmount = freeshipDiscountAmount;

        Order order = JdbiProvider.getInstance().inTransaction(handle -> {
            Order o = new Order();
            o.setUserId(userId);
            o.setAddressId(addressId);
            o.setPaymentMethodId(paymentMethodId);
            o.setNote(note);
            o.setShippingFee(shippingFee);
            o.setTotalPrice(totalPrice);
            o.setCouponId(finalCouponId);
            o.setDiscountAmount(finalDiscountAmount);
            o.setFreeshipCouponId(finalFreeshipCouponId);
            o.setFreeshipDiscountAmount(finalFreeshipDiscountAmount);
            o.setStatus(Order.STATUS_PENDING);
            return executeOrderTransaction(handle, o, cartItems, null);
        });

        if (couponId != null && discountAmount > 0) {
            couponDAO.incrementUsedCount(couponId);
            couponDAO.insertUsage(couponId, userId, order.getId(), discountAmount);
        }
        if (freeshipCouponId != null && freeshipDiscountAmount > 0) {
            couponDAO.incrementUsedCount(freeshipCouponId);
            couponDAO.insertUsage(freeshipCouponId, userId, order.getId(), freeshipDiscountAmount);
        }

        order.setAddress(addressOpt.get());
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }

        checkAndTriggerFlashSaleNotifications(cartItems);

        return order;
    }


    public Order createOrderFromItems(int userId, int addressId, int paymentMethodId, String note, List<CartItem> cartItems, double shippingFee)
            throws IllegalArgumentException {
        return createOrderFromItems(userId, addressId, paymentMethodId, note, cartItems, shippingFee, null, null, null, null);
    }

    public Order createOrderFromItems(int userId, int addressId, int paymentMethodId, String note, List<CartItem> cartItems,
                                      double shippingFee, String couponCode, Double appliedDiscountAmount)
            throws IllegalArgumentException {
        return createOrderFromItems(userId, addressId, paymentMethodId, note, cartItems, shippingFee, couponCode, appliedDiscountAmount, null, null);
    }

    public Order createOrderFromItems(int userId, int addressId, int paymentMethodId, String note, List<CartItem> cartItems,
                                      double shippingFee, String couponCode, Double appliedDiscountAmount,
                                      String freeshipCouponCode, Double appliedFreeshipDiscountAmount)
            throws IllegalArgumentException {

        Optional<Address> addressOpt = addressDAO.findById(addressId);
        if (addressOpt.isEmpty()) {
            throw new IllegalArgumentException("Địa chỉ không tồn tại");
        }

        Optional<PaymentMethod> paymentOpt = paymentMethodDAO.findById(paymentMethodId);
        if (paymentOpt.isEmpty() || !paymentOpt.get().isActive()) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("Sản phẩm trống");
        }

        double subtotal = 0;
        for (CartItem item : cartItems) {
            loadCartItemDetails(item, userId);
            subtotal += item.getSubtotal();
        }

        for (CartItem item : cartItems) {
            Optional<FlashSale> fsOpt = flashSaleDAO.findActiveByProductId(item.getProductId());
            if (fsOpt.isPresent()) {
                FlashSale fs = fsOpt.get();
                if (fs.getMaxQtyPerUser() > 0) {
                    int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, fs.getProductId(), fs.getStartTime(), fs.getEndTime());
                    if (purchased >= fs.getMaxQtyPerUser()) {
                        throw new IllegalArgumentException("Bạn đã mua sản phẩm " + (item.getProduct() != null ? item.getProduct().getName() : "này") + " đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                    }
                    if (purchased + item.getQuantity() > fs.getMaxQtyPerUser()) {
                        int allowed = fs.getMaxQtyPerUser() - purchased;
                        throw new IllegalArgumentException("Bạn chỉ được mua thêm tối đa " + allowed + " sản phẩm " + (item.getProduct() != null ? item.getProduct().getName() : "này") + " trong chương trình Flash Sale (đã mua: " + purchased + ")");
                    }
                }
            }
        }

        Integer couponId = null;
        double discountAmount = 0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon coupon = couponService.validateCouponForOrder(couponCode, userId, subtotal);
                discountAmount = couponService.calculateDiscount(coupon, subtotal, shippingFee);
                couponId = coupon.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Coupon validation failed: " + e.getMessage());
            }
        }

        Integer freeshipCouponId = null;
        double freeshipDiscountAmount = 0;
        if (freeshipCouponCode != null && !freeshipCouponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon fc = couponService.validateCouponForOrder(freeshipCouponCode, userId, subtotal);
                freeshipDiscountAmount = couponService.calculateDiscount(fc, subtotal, shippingFee);
                freeshipCouponId = fc.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Freeship coupon validation failed: " + e.getMessage());
            }
        }

        double totalPrice = subtotal - discountAmount - freeshipDiscountAmount + shippingFee;
        final Integer finalCouponId = couponId;
        final double finalDiscountAmount = discountAmount;
        final Integer finalFreeshipCouponId = freeshipCouponId;
        final double finalFreeshipDiscountAmount = freeshipDiscountAmount;

        Order order = JdbiProvider.getInstance().inTransaction(handle -> {
            Order o = new Order();
            o.setUserId(userId);
            o.setAddressId(addressId);
            o.setPaymentMethodId(paymentMethodId);
            o.setNote(note);
            o.setShippingFee(shippingFee);
            o.setTotalPrice(totalPrice);
            o.setCouponId(finalCouponId);
            o.setDiscountAmount(finalDiscountAmount);
            o.setFreeshipCouponId(finalFreeshipCouponId);
            o.setFreeshipDiscountAmount(finalFreeshipDiscountAmount);
            o.setStatus(Order.STATUS_PENDING);
            return executeOrderTransaction(handle, o, cartItems, null);
        });

        if (couponId != null && discountAmount > 0) {
            couponDAO.incrementUsedCount(couponId);
            couponDAO.insertUsage(couponId, userId, order.getId(), discountAmount);
        }
        if (freeshipCouponId != null && freeshipDiscountAmount > 0) {
            couponDAO.incrementUsedCount(freeshipCouponId);
            couponDAO.insertUsage(freeshipCouponId, userId, order.getId(), freeshipDiscountAmount);
        }

        order.setAddress(addressOpt.get());
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }

        checkAndTriggerFlashSaleNotifications(cartItems);

        return order;
    }

    public Order createGuestOrder(GuestInfo guestInfo, Address shippingAddress,
            int paymentMethodId, String note, List<CartItem> cartItems, double shippingFee)
            throws IllegalArgumentException {
        return createGuestOrder(guestInfo, shippingAddress, paymentMethodId, note, cartItems, shippingFee, null, null, null, null);
    }

    public Order createGuestOrder(GuestInfo guestInfo, Address shippingAddress,
            int paymentMethodId, String note, List<CartItem> cartItems,
            double shippingFee, String couponCode, Double appliedDiscountAmount)
            throws IllegalArgumentException {
        return createGuestOrder(guestInfo, shippingAddress, paymentMethodId, note, cartItems, shippingFee, couponCode, appliedDiscountAmount, null, null);
    }

    public Order createGuestOrder(GuestInfo guestInfo, Address shippingAddress,
            int paymentMethodId, String note, List<CartItem> cartItems,
            double shippingFee, String couponCode, Double appliedDiscountAmount,
            String freeshipCouponCode, Double appliedFreeshipDiscountAmount)
            throws IllegalArgumentException {

        if (guestInfo == null || !guestInfo.isValid()) {
            throw new IllegalArgumentException("Thông tin khách hàng không đầy đủ");
        }

        if (!guestInfo.isEmailValid()) {
            throw new IllegalArgumentException("Email không hợp lệ");
        }

        Optional<PaymentMethod> paymentOpt = paymentMethodDAO.findById(paymentMethodId);
        if (paymentOpt.isEmpty() || !paymentOpt.get().isActive()) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }

        double subtotal = 0;
        for (CartItem item : cartItems) {
            loadCartItemDetails(item, null);
            subtotal += item.getSubtotal();
        }

        Integer couponId = null;
        double discountAmount = 0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon coupon = couponService.validateCouponForOrder(couponCode, null, subtotal);
                discountAmount = couponService.calculateDiscount(coupon, subtotal, shippingFee);
                couponId = coupon.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Coupon validation failed: " + e.getMessage());
            }
        }

        Integer freeshipCouponId = null;
        double freeshipDiscountAmount = 0;
        if (freeshipCouponCode != null && !freeshipCouponCode.trim().isEmpty()) {
            try {
                group36.model.Coupon fc = couponService.validateCouponForOrder(freeshipCouponCode, null, subtotal);
                freeshipDiscountAmount = couponService.calculateDiscount(fc, subtotal, shippingFee);
                freeshipCouponId = fc.getId();
            } catch (IllegalArgumentException e) {
                System.err.println("[OrderService] Freeship coupon validation failed: " + e.getMessage());
            }
        }

        double totalPrice = subtotal - discountAmount - freeshipDiscountAmount + shippingFee;
        final Integer finalCouponId = couponId;
        final double finalDiscountAmount = discountAmount;
        final Integer finalFreeshipCouponId = freeshipCouponId;
        final double finalFreeshipDiscountAmount = freeshipDiscountAmount;

        Order order = JdbiProvider.getInstance().inTransaction(handle -> {
            shippingAddress.setUserId(0);
            int addressId = addressDAO.insertWithHandle(handle, shippingAddress);
            shippingAddress.setId(addressId);

            Order o = new Order();
            o.setUserId(null);
            o.setAddressId(addressId);
            o.setPaymentMethodId(paymentMethodId);
            o.setNote(note);
            o.setShippingFee(shippingFee);
            o.setTotalPrice(totalPrice);
            o.setCouponId(finalCouponId);
            o.setDiscountAmount(finalDiscountAmount);
            o.setFreeshipCouponId(finalFreeshipCouponId);
            o.setFreeshipDiscountAmount(finalFreeshipDiscountAmount);
            o.setStatus(Order.STATUS_PENDING);
            o.setGuestEmail(guestInfo.getEmail());
            o.setGuestName(guestInfo.getFullName());
            o.setGuestPhone(guestInfo.getPhone());

            int orderId = orderDAO.insertGuestOrderWithHandle(handle, o);
            o.setId(orderId);

            List<OrderDetail> orderDetails = new ArrayList<>();
            for (CartItem item : cartItems) {
                orderDetails.add(OrderDetail.fromCartItem(item, orderId));
            }
            orderDetailDAO.insertBatchWithHandle(handle, orderDetails);
            o.setOrderDetails(orderDetails);

            for (CartItem item : cartItems) {
                if (item.getVariantId() != null) {
                    productVariantDAO.decreaseStockWithLock(handle, item.getVariantId(), item.getQuantity());
                }
                productDAO.incrementSoldCountWithHandle(handle, item.getProductId(), item.getQuantity());
                if (item.hasFlashSalePrice()) {
                    flashSaleDAO.findActiveByProductIdWithHandle(handle, item.getProductId()).ifPresent(fs -> {
                        flashSaleDAO.incrementSoldCountWithHandle(handle, fs.getId(), item.getQuantity());
                    });
                }
            }

            return o;
        });

        if (couponId != null && discountAmount > 0) {
            couponDAO.incrementUsedCount(couponId);
            couponDAO.insertUsage(couponId, null, order.getId(), discountAmount);
        }
        if (freeshipCouponId != null && freeshipDiscountAmount > 0) {
            couponDAO.incrementUsedCount(freeshipCouponId);
            couponDAO.insertUsage(freeshipCouponId, null, order.getId(), freeshipDiscountAmount);
        }

        order.setAddress(shippingAddress);
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }

        checkAndTriggerFlashSaleNotifications(cartItems);

        return order;
    }


    private Order executeOrderTransaction(Handle handle, Order order, List<CartItem> cartItems, Integer cartIdToDelete) {
        int orderId = orderDAO.insertWithHandle(handle, order);
        order.setId(orderId);

        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : cartItems) {
            orderDetails.add(OrderDetail.fromCartItem(item, orderId));
        }
        orderDetailDAO.insertBatchWithHandle(handle, orderDetails);
        order.setOrderDetails(orderDetails);

        for (CartItem item : cartItems) {
            if (item.getVariantId() != null) {
                productVariantDAO.decreaseStockWithLock(handle, item.getVariantId(), item.getQuantity());
            }
            productDAO.incrementSoldCountWithHandle(handle, item.getProductId(), item.getQuantity());
            if (item.hasFlashSalePrice()) {
                flashSaleDAO.findActiveByProductIdWithHandle(handle, item.getProductId()).ifPresent(fs -> {
                    flashSaleDAO.incrementSoldCountWithHandle(handle, fs.getId(), item.getQuantity());
                });
            }
        }

        if (cartIdToDelete != null) {
            cartItemDAO.deleteByCartIdWithHandle(handle, cartIdToDelete);
        }

        return order;
    }

    public Optional<Order> getOrderById(int orderId) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            loadOrderDetails(order);
        }
        return orderOpt;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = orderDAO.findByUserId(userId);
        for (Order order : orders) {
            loadOrderDetails(order);
        }
        return orders;
    }

    public List<Order> getOrdersByUserIdPaginated(int userId, int page, int pageSize) {
        List<Order> orders = orderDAO.findByUserIdPaginated(userId, page, pageSize);
        for (Order order : orders) {
            loadOrderDetails(order);
        }
        return orders;
    }

    public List<Order> getOrdersByUserIdAndStatusPaginated(int userId, String status, int page, int pageSize) {
        List<Order> orders = orderDAO.findByUserIdAndStatusPaginated(userId, status, page, pageSize);
        for (Order order : orders) {
            loadOrderDetails(order);
        }
        return orders;
    }

    public int countOrdersByUserId(int userId) {
        return orderDAO.countByUserId(userId);
    }

    public int countOrdersByUserIdAndStatus(int userId, String status) {
        return orderDAO.countByUserIdAndStatus(userId, status);
    }

    public List<Product> getPreviouslyPurchasedRecommendations(int userId, List<Integer> excludedProductIds, int limit) {
        if (limit <= 0) {
            return new ArrayList<>();
        }

        Set<Integer> excluded = toExcludedSet(excludedProductIds);
        List<Integer> purchasedIds = orderDetailDAO.findTopPurchasedProductIdsByUserId(userId, limit * 3);

        List<Product> recommendations = new ArrayList<>();
        for (Integer productId : purchasedIds) {
            if (productId == null || excluded.contains(productId)) {
                continue;
            }
            Optional<Product> productOpt = productDAO.findById(productId);
            if (productOpt.isEmpty()) {
                continue;
            }

            Product product = productOpt.get();
            enrichProductForRecommendation(product);

            if (product.getTotalStock() <= 0) {
                continue;
            }

            recommendations.add(product);
            excluded.add(product.getId());

            if (recommendations.size() >= limit) {
                break;
            }
        }

        return recommendations;
    }

    public List<Product> getBestSellerRecommendations(List<Integer> excludedProductIds, int limit) {
        if (limit <= 0) {
            return new ArrayList<>();
        }

        Set<Integer> excluded = toExcludedSet(excludedProductIds);
        List<Product> bestSellers = productDAO.findBestSelling(limit * 3);

        List<Product> recommendations = new ArrayList<>();
        for (Product product : bestSellers) {
            if (product == null || excluded.contains(product.getId())) {
                continue;
            }

            enrichProductForRecommendation(product);

            if (product.getTotalStock() <= 0) {
                continue;
            }

            recommendations.add(product);
            excluded.add(product.getId());

            if (recommendations.size() >= limit) {
                break;
            }
        }

        return recommendations;
    }

    public List<Product> getCheckoutRecommendations(Integer userId, List<Integer> excludedProductIds, int limit) {
        List<Product> recommendations = new ArrayList<>();
        Set<Integer> excluded = toExcludedSet(excludedProductIds);

        if (limit <= 0) {
            return recommendations;
        }

        if (userId != null) {
            recommendations.addAll(getPreviouslyPurchasedRecommendations(userId, new ArrayList<>(excluded), limit));
            for (Product product : recommendations) {
                excluded.add(product.getId());
            }
        }

        int remaining = limit - recommendations.size();
        if (remaining > 0) {
            recommendations.addAll(getBestSellerRecommendations(new ArrayList<>(excluded), remaining));
        }

        return recommendations;
    }

    public String getCheckoutRecommendationSource(Integer userId, List<Product> recommendations) {
        if (userId == null || recommendations == null || recommendations.isEmpty()) {
            return "best_seller";
        }

        List<Integer> purchasedIds = orderDetailDAO.findTopPurchasedProductIdsByUserId(userId, 200);
        Set<Integer> purchasedSet = toExcludedSet(purchasedIds);

        for (Product product : recommendations) {
            if (product != null && purchasedSet.contains(product.getId())) {
                return "purchased";
            }
        }

        return "best_seller";
    }

    private Set<Integer> toExcludedSet(List<Integer> excludedProductIds) {
        Set<Integer> excluded = new HashSet<>();
        if (excludedProductIds == null) {
            return excluded;
        }
        for (Integer id : excludedProductIds) {
            if (id != null) {
                excluded.add(id);
            }
        }
        return excluded;
    }

    private void enrichProductForRecommendation(Product product) {
        product.setImages(productImageDAO.findByProductId(product.getId()));
        product.setVariants(productVariantDAO.findByProductId(product.getId()));
    }

    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    public List<Order> getOrdersPaginated(int page, int size) {
        return orderDAO.findAllPaginated(page, size);
    }

    @Deprecated
    public boolean updateOrderStatus(int orderId, String status) {
        return updateOrderStatus(orderId, status, "system", null, null);
    }

    public boolean updateOrderStatus(int orderId, String newStatus, String changedBy, Integer changedById, String note) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        if (orderOpt.isEmpty()) {
            return false;
        }
        Order order = orderOpt.get();
        String oldStatus = order.getStatus();

        if (!Order.isTransitionAllowed(oldStatus, newStatus)) {
            throw new IllegalStateException("Không thể chuyển trạng thái từ " + oldStatus + " sang " + newStatus);
        }

        boolean updated = orderDAO.updateStatus(orderId, newStatus) > 0;
        if (updated) {
            OrderStatusHistory history = new OrderStatusHistory();
            history.setOrderId(orderId);
            history.setOldStatus(oldStatus);
            history.setNewStatus(newStatus);
            history.setChangedBy(changedBy);
            history.setChangedById(changedById);
            history.setNote(note);
            orderStatusHistoryDAO.insert(history);

            if (order.getUserId() != null) {
                try {
                    userNotificationService.createOrderStatusNotification(order, oldStatus, newStatus);
                } catch (Exception e) {
                    System.err.println("[OrderService] Error creating user notification: " + e.getMessage());
                }
            }

            if ((Order.STATUS_CONFIRMED.equals(newStatus) || Order.STATUS_PROCESSING.equals(newStatus))
                    && order.getGhnOrderCode() == null) {
                try {
                    Optional<Address> addrOpt = addressDAO.findById(order.getAddressId());
                    if (addrOpt.isPresent()) {
                        Address addr = addrOpt.get();
                        if (addr.getGhnDistrictId() != null && addr.getGhnWardCode() != null) {
                            paymentMethodDAO.findById(order.getPaymentMethodId()).ifPresent(order::setPaymentMethod);
                            double codAmount = order.isOnlinePayment() ? 0 : order.getTotalPrice();
                            int paymentTypeId = order.isOnlinePayment() ? 1 : 2;
                            String ghnCode = ghnService.createShippingOrder(
                                orderId,
                                addr.getReceiver(),
                                addr.getPhone(),
                                addr.getAddressDetail(),
                                addr.getGhnDistrictId(),
                                addr.getGhnWardCode(),
                                codAmount,
                                order.getTotalPrice(),
                                order.getNote(),
                                paymentTypeId
                            );
                            orderDAO.saveGhnOrderCode(orderId, ghnCode);
                            System.out.println("[OrderService] GHN order created: " + ghnCode + " for order #" + orderId);
                        } else {
                            System.err.println("[OrderService] Address #" + order.getAddressId() + " missing GHN district/ward, skip GHN create");
                        }
                    }
                } catch (Exception e) {
                    System.err.println("[OrderService] Failed to create GHN order for #" + orderId + ": " + e.getMessage());
                }
            }
        }
        return updated;
    }

    public boolean cancelOrderByUser(int orderId, int userId, String reason) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        if (orderOpt.isEmpty() || !orderOpt.get().getUserId().equals(userId)) {
            return false;
        }
        return updateOrderStatus(orderId, Order.STATUS_CANCELLED, "user", userId, reason);
    }

    public boolean cancelOrderByAdmin(int orderId, int adminId, String reason) {
        return updateOrderStatus(orderId, Order.STATUS_CANCELLED_BY_ADMIN, "admin", adminId, reason);
    }

    public boolean confirmReceivedByUser(int orderId, int userId) {
        Optional<Order> orderOpt = orderDAO.findById(orderId);
        if (orderOpt.isEmpty() || !orderOpt.get().getUserId().equals(userId)) {
            return false;
        }
        return updateOrderStatus(orderId, Order.STATUS_DELIVERED, "user", userId, "Khách hàng xác nhận đã nhận hàng");
    }

    public int countOrders() {
        return orderDAO.count();
    }

    public int countOrdersByStatus(String status) {
        return orderDAO.countByStatus(status);
    }

    private void loadOrderDetails(Order order) {
        List<OrderDetail> details = orderDetailDAO.findByOrderId(order.getId());
        for (OrderDetail detail : details) {
            loadOrderDetailProducts(detail);
        }
        order.setOrderDetails(details);

        addressDAO.findById(order.getAddressId()).ifPresent(order::setAddress);
        paymentMethodDAO.findById(order.getPaymentMethodId()).ifPresent(order::setPaymentMethod);
        paymentDAO.findLatestByOrderId(order.getId()).ifPresent(order::setLatestPayment);

        List<OrderStatusHistory> history = orderStatusHistoryDAO.findByOrderId(order.getId());
        order.setStatusHistory(history);

        if (!order.isGuestOrder() && order.getUserId() != null) {
            userDAO.findById(order.getUserId()).ifPresent(order::setUser);
        }
    }

    private void loadOrderDetailProducts(OrderDetail detail) {
        Optional<Product> productOpt = productDAO.findById(detail.getProductId());
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            List<ProductImage> images = productImageDAO.findByProductId(product.getId());
            product.setImages(images);
            detail.setProduct(product);
        }
        if (detail.getVariantId() != null) {
            productVariantDAO.findById(detail.getVariantId()).ifPresent(detail::setVariant);
        }
    }

    private void loadCartItemDetails(CartItem item, Integer userId) {
        productDAO.findById(item.getProductId()).ifPresent(product -> {

            product.setImages(productImageDAO.findByProductId(product.getId()));
            List<ProductVariant> variants = productVariantDAO.findByProductId(product.getId());
            product.setVariants(variants);
            item.setProduct(product);

            if (item.getVariantId() != null) {
                for (ProductVariant v : variants) {
                    if (Integer.valueOf(v.getId()).equals(item.getVariantId())) {
                        item.setVariant(v);
                        break;
                    }
                }
            }
        });

        if (item.getVariantId() != null && item.getVariant() == null) {
            productVariantDAO.findById(item.getVariantId()).ifPresent(item::setVariant);
        }

        applyFlashSalePrice(item, userId);
    }

    private void applyFlashSalePrice(CartItem item, Integer userId) {
        if (item == null)
            return;

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(item.getProductId());

        if (flashSaleOpt.isPresent()) {
            FlashSale flashSale = flashSaleOpt.get();
            if (flashSale.getRemainingStock() > 0) {
                if (userId != null && userId > 0 && flashSale.getMaxQtyPerUser() > 0) {
                    int purchasedQty = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, flashSale.getProductId(), flashSale.getStartTime(), flashSale.getEndTime());
                    if (purchasedQty >= flashSale.getMaxQtyPerUser()) {
                        return;
                    }
                }
                double originalPrice = item.getOriginalUnitPrice();
                if (originalPrice > 0) {
                    double salePrice = flashSale.getSalePrice(originalPrice);
                    item.setFlashSalePrice(salePrice);
                }
            }
        }
    }

    public List<Order> getOrdersByStatusPaginated(String status, int page, int size) {
        return orderDAO.findByStatusPaginated(status, page, size);
    }

    public List<Order> getOrdersFiltered(String status, String keyword, String fromDate, String toDate, int page,
            int size) {
        return orderDAO.findFiltered(status, keyword, fromDate, toDate, page, size);
    }

    public int countOrdersFiltered(String status, String keyword, String fromDate, String toDate) {
        return orderDAO.countFiltered(status, keyword, fromDate, toDate);
    }

    public void loadOrderDetailsForAdmin(Order order) {
        List<OrderDetail> details = orderDetailDAO.findByOrderId(order.getId());
        for (OrderDetail detail : details) {
            loadOrderDetailProducts(detail);
        }
        order.setOrderDetails(details);

        if (!order.isGuestOrder() && order.getUserId() != null) {
            userDAO.findById(order.getUserId()).ifPresent(order::setUser);
        }

        addressDAO.findById(order.getAddressId()).ifPresent(order::setAddress);
        paymentMethodDAO.findById(order.getPaymentMethodId()).ifPresent(order::setPaymentMethod);
        paymentDAO.findLatestByOrderId(order.getId()).ifPresent(order::setLatestPayment);

        List<OrderStatusHistory> history = orderStatusHistoryDAO.findByOrderId(order.getId());
        order.setStatusHistory(history);
    }

    public double getTotalRevenue() {
        return orderDAO.getTotalRevenue();
    }

    public double getRevenueThisMonth() {
        return orderDAO.getRevenueThisMonth();
    }

    public double getRevenueChangePercent() {
        double thisMonth = orderDAO.getRevenueThisMonth();
        double lastMonth = orderDAO.getRevenuePreviousMonth();
        if (lastMonth == 0) {
            return thisMonth > 0 ? 100 : 0;
        }
        return ((thisMonth - lastMonth) / lastMonth) * 100;
    }

    public double getTotalProfit() {
        return orderDAO.getTotalProfit();
    }

    public double getProfitThisMonth() {
        return orderDAO.getProfitThisMonth();
    }

    public double getProfitChangePercent() {
        double thisMonth = orderDAO.getProfitThisMonth();
        double lastMonth = orderDAO.getProfitPreviousMonth();
        if (lastMonth == 0) {
            return thisMonth > 0 ? 100 : 0;
        }
        return ((thisMonth - lastMonth) / lastMonth) * 100;
    }

    public int getOrdersThisMonth() {
        return orderDAO.countOrdersThisMonth();
    }

    public double getOrdersChangePercent() {
        int thisMonth = orderDAO.countOrdersThisMonth();
        int lastMonth = orderDAO.countOrdersPreviousMonth();
        if (lastMonth == 0) {
            return thisMonth > 0 ? 100 : 0;
        }
        return ((double) (thisMonth - lastMonth) / lastMonth) * 100;
    }

    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = orderDAO.findRecent(limit);
        for (Order order : orders) {
            loadOrderDetailsForAdmin(order);
        }
        return orders;
    }

    private void checkAndTriggerFlashSaleNotifications(List<CartItem> cartItems) {
        try {
            for (CartItem item : cartItems) {
                if (item.hasFlashSalePrice()) {
                    flashSaleDAO.findActiveByProductId(item.getProductId()).ifPresent(fs -> {
                        int remaining = fs.getStockLimit() - fs.getSoldCount();
                        if (remaining <= 0) {
                            adminNotificationService.createNotification(
                                AdminNotification.TYPE_FLASH_SALE_LOW_STOCK,
                                "Flash Sale hết hàng!",
                                "Sản phẩm Flash Sale \"" + (item.getProduct() != null ? item.getProduct().getName() : "Sản phẩm #" + item.getProductId()) + "\" đã bán hết giới hạn tồn kho (" + fs.getStockLimit() + ").",
                                fs.getId(),
                                "flash_sale"
                            );
                        } else if (remaining <= 5) {
                            adminNotificationService.createNotification(
                                AdminNotification.TYPE_FLASH_SALE_LOW_STOCK,
                                "Flash Sale sắp hết hàng",
                                "Sản phẩm Flash Sale \"" + (item.getProduct() != null ? item.getProduct().getName() : "Sản phẩm #" + item.getProductId()) + "\" chỉ còn lại " + remaining + " sản phẩm.",
                                fs.getId(),
                                "flash_sale"
                            );
                        }
                    });
                }
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public List<OrderDAO.RevenueRecord> getWeeklyRevenueChartData() {
        List<OrderDAO.RevenueRecord> dbData = orderDAO.getWeeklyRevenue();
        List<OrderDAO.RevenueRecord> result = new ArrayList<>();
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        java.time.format.DateTimeFormatter displayDtf = java.time.format.DateTimeFormatter.ofPattern("dd/MM");
        
        for (int i = 6; i >= 0; i--) {
            java.time.LocalDate date = today.minusDays(i);
            String dbKey = date.format(dtf);
            String displayLabel = date.format(displayDtf);
            
            double revenue = dbData.stream()
                .filter(r -> dbKey.equals(r.getLabel()))
                .mapToDouble(OrderDAO.RevenueRecord::getRevenue)
                .findFirst()
                .orElse(0.0);
                
            result.add(new OrderDAO.RevenueRecord(displayLabel, revenue));
        }
        return result;
    }

    public List<OrderDAO.RevenueRecord> getMonthlyRevenueChartData() {
        List<OrderDAO.RevenueRecord> dbData = orderDAO.getMonthlyRevenue();
        List<OrderDAO.RevenueRecord> result = new ArrayList<>();
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM");
        java.time.format.DateTimeFormatter displayDtf = java.time.format.DateTimeFormatter.ofPattern("'Tháng' MM");
        
        for (int i = 5; i >= 0; i--) {
            java.time.LocalDate month = today.minusMonths(i);
            String dbKey = month.format(dtf);
            String displayLabel = month.format(displayDtf);
            
            double revenue = dbData.stream()
                .filter(r -> dbKey.equals(r.getLabel()))
                .mapToDouble(OrderDAO.RevenueRecord::getRevenue)
                .findFirst()
                .orElse(0.0);
                
            result.add(new OrderDAO.RevenueRecord(displayLabel, revenue));
        }
        return result;
    }
}
