package group36.service;

import group36.dao.*;
import group36.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class OrderService {

    private final OrderDAO orderDAO;
    private final OrderDetailDAO orderDetailDAO;
    private final AddressDAO addressDAO;
    private final PaymentMethodDAO paymentMethodDAO;
    private final CartDAO cartDAO;
    private final CartItemDAO cartItemDAO;
    private final ProductVariantDAO productVariantDAO;
    private final ProductDAO productDAO;
    private final ProductImageDAO productImageDAO;
    private final AdminNotificationService adminNotificationService;
    private final UserDAO userDAO;
    private final FlashSaleDAO flashSaleDAO;

    public static final double FREE_SHIPPING_THRESHOLD = 100000;
    public static final double STANDARD_SHIPPING_FEE = 30000;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderDetailDAO = new OrderDetailDAO();
        this.addressDAO = new AddressDAO();
        this.paymentMethodDAO = new PaymentMethodDAO();
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productVariantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.productImageDAO = new ProductImageDAO();
        this.adminNotificationService = new AdminNotificationService();
        this.userDAO = new UserDAO();
        this.flashSaleDAO = new FlashSaleDAO();
    }

    public double calculateShippingFee(double subtotal) {
        return subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : STANDARD_SHIPPING_FEE;
    }

    public Order createOrder(int userId, int addressId, int paymentMethodId, String note)
            throws IllegalArgumentException {

        Optional<Address> addressOpt = addressDAO.findById(addressId);
        if (addressOpt.isEmpty()) {
            throw new IllegalArgumentException("Địa chỉ không tồn tại");
        }

        Optional<PaymentMethod> paymentOpt = paymentMethodDAO.findById(paymentMethodId);
        if (paymentOpt.isEmpty() || !paymentOpt.get().isActive()) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ");
        }

        Optional<Cart> cartOpt = cartDAO.findByUserId(userId);
        if (cartOpt.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }

        Cart cart = cartOpt.get();
        List<CartItem> cartItems = cartItemDAO.findByCartId(cart.getId());
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng trống");
        }

        double subtotal = 0;
        for (CartItem item : cartItems) {
            loadCartItemDetails(item);
            subtotal += item.getSubtotal();
        }

        double shippingFee = calculateShippingFee(subtotal);
        double totalPrice = subtotal + shippingFee;

        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setPaymentMethodId(paymentMethodId);
        order.setNote(note);
        order.setShippingFee(shippingFee);
        order.setTotalPrice(totalPrice);
        order.setStatus(Order.STATUS_PENDING);

        int orderId = orderDAO.insert(order);
        order.setId(orderId);

        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : cartItems) {
            OrderDetail detail = OrderDetail.fromCartItem(item, orderId);
            orderDetails.add(detail);
        }
        orderDetailDAO.insertBatch(orderDetails);
        order.setOrderDetails(orderDetails);

        for (CartItem item : cartItems) {
            if (item.getVariantId() != null) {
                productVariantDAO.decreaseStock(item.getVariantId(), item.getQuantity());
            }
            productDAO.incrementSoldCount(item.getProductId(), item.getQuantity());

            if (item.hasFlashSalePrice()) {
                flashSaleDAO.findActiveByProductId(item.getProductId()).ifPresent(fs -> {
                    flashSaleDAO.incrementSoldCount(fs.getId(), item.getQuantity());
                });
            }
        }

        cartItemDAO.deleteByCartId(cart.getId());

        order.setAddress(addressOpt.get());
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {

            e.printStackTrace();
        }

        return order;
    }

    public Order createOrderFromItems(int userId, int addressId, int paymentMethodId, String note, List<CartItem> cartItems)
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
            loadCartItemDetails(item);
            subtotal += item.getSubtotal();
        }

        double shippingFee = calculateShippingFee(subtotal);
        double totalPrice = subtotal + shippingFee;

        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setPaymentMethodId(paymentMethodId);
        order.setNote(note);
        order.setShippingFee(shippingFee);
        order.setTotalPrice(totalPrice);
        order.setStatus(Order.STATUS_PENDING);

        int orderId = orderDAO.insert(order);
        order.setId(orderId);

        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : cartItems) {
            OrderDetail detail = OrderDetail.fromCartItem(item, orderId);
            orderDetails.add(detail);
        }
        orderDetailDAO.insertBatch(orderDetails);
        order.setOrderDetails(orderDetails);

        for (CartItem item : cartItems) {
            if (item.getVariantId() != null) {
                productVariantDAO.decreaseStock(item.getVariantId(), item.getQuantity());
            }
            productDAO.incrementSoldCount(item.getProductId(), item.getQuantity());

            if (item.hasFlashSalePrice()) {
                flashSaleDAO.findActiveByProductId(item.getProductId()).ifPresent(fs -> {
                    flashSaleDAO.incrementSoldCount(fs.getId(), item.getQuantity());
                });
            }
        }

        order.setAddress(addressOpt.get());
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }

    public Order createGuestOrder(GuestInfo guestInfo, Address shippingAddress,
            int paymentMethodId, String note, List<CartItem> cartItems)
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
            loadCartItemDetails(item);
            subtotal += item.getSubtotal();
        }

        double shippingFee = calculateShippingFee(subtotal);
        double totalPrice = subtotal + shippingFee;

        shippingAddress.setUserId(0);
        int addressId = addressDAO.insert(shippingAddress);
        shippingAddress.setId(addressId);

        Order order = new Order();
        order.setUserId(null);
        order.setAddressId(addressId);
        order.setPaymentMethodId(paymentMethodId);
        order.setNote(note);
        order.setShippingFee(shippingFee);
        order.setTotalPrice(totalPrice);
        order.setStatus(Order.STATUS_PENDING);
        order.setGuestEmail(guestInfo.getEmail());
        order.setGuestName(guestInfo.getFullName());
        order.setGuestPhone(guestInfo.getPhone());

        int orderId = orderDAO.insertGuestOrder(order);
        order.setId(orderId);

        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : cartItems) {
            OrderDetail detail = OrderDetail.fromCartItem(item, orderId);
            orderDetails.add(detail);
        }
        orderDetailDAO.insertBatch(orderDetails);
        order.setOrderDetails(orderDetails);

        for (CartItem item : cartItems) {
            if (item.getVariantId() != null) {
                productVariantDAO.decreaseStock(item.getVariantId(), item.getQuantity());
            }
            productDAO.incrementSoldCount(item.getProductId(), item.getQuantity());

            if (item.hasFlashSalePrice()) {
                flashSaleDAO.findActiveByProductId(item.getProductId()).ifPresent(fs -> {
                    flashSaleDAO.incrementSoldCount(fs.getId(), item.getQuantity());
                });
            }
        }

        order.setAddress(shippingAddress);
        order.setPaymentMethod(paymentOpt.get());

        try {
            adminNotificationService.createOrderNotification(order);
        } catch (Exception e) {
            e.printStackTrace();
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

    public List<Order> getAllOrders() {
        return orderDAO.findAll();
    }

    public List<Order> getOrdersPaginated(int page, int size) {
        return orderDAO.findAllPaginated(page, size);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        int result = orderDAO.updateStatus(orderId, status);
        return result > 0;
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

        if (!order.isGuestOrder() && order.getUserId() != null) {
            userDAO.findById(order.getUserId()).ifPresent(order::setUser);
        }
    }

    private void loadOrderDetailProducts(OrderDetail detail) {
        System.out.println("DEBUG: Loading product for productId=" + detail.getProductId());
        Optional<Product> productOpt = productDAO.findById(detail.getProductId());
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            System.out.println("DEBUG: Product found - ID=" + product.getId() + ", Name=" + product.getName());
            List<ProductImage> images = productImageDAO.findByProductId(product.getId());
            product.setImages(images);
            detail.setProduct(product);
        } else {
            System.out.println("DEBUG: Product NOT FOUND for productId=" + detail.getProductId());
        }
        if (detail.getVariantId() != null) {
            productVariantDAO.findById(detail.getVariantId()).ifPresent(detail::setVariant);
        }
    }

    private void loadCartItemDetails(CartItem item) {
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

        applyFlashSalePrice(item);
    }

    private void applyFlashSalePrice(CartItem item) {
        if (item == null)
            return;

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(item.getProductId());

        if (flashSaleOpt.isPresent()) {
            FlashSale flashSale = flashSaleOpt.get();
            if (flashSale.getRemainingStock() > 0) {
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
        order.setOrderDetails(details);

        if (!order.isGuestOrder() && order.getUserId() != null) {
            userDAO.findById(order.getUserId()).ifPresent(order::setUser);
        }

        addressDAO.findById(order.getAddressId()).ifPresent(order::setAddress);
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
}
