# Trang tính1

|#|Chức Năng|File liên quan (Phát  1-10, Quỳnh 11-21, Tài 22-30)|
|---|---|---|
|1|Login / Register|LoginController, RegisterController, DangNhap.jsp, DangKy.jsp, DangKy.js|
|2|Phân quyền (RBAC)|AdminAuthFilter, HomeRedirectFilter|
|3|Quên mật khẩu / OTP|ForgotPasswordController, ResetPasswordController, VerifyOTPController, PasswordResetService, PasswordResetTokenDAO, QuenMatKhau.jsp, XacNhanOTP.jsp, DatLaiMatKhau.jsp|
|4|Trang Profile|ProfileController, UpdateProfileController, HoSo.jsp, HoSo.js|
|5|Admin (User Management)|AdminUserController, customers.jsp, customers-detail.jsp, customers-edit.jsp|
|6|Admin Login/Logout|AdminLoginController, AdminLogoutController, login.jsp (admin)|
|7|Đổi mật khẩu|ChangePasswordController|
|8|Blog/Tin tức|NewsController, NewsDetailController, TinTuc.jsp, ChiTietTinTuc.jsp|
|9|Admin (Blog)|AdminPostController, posts.jsp, posts-add.jsp, posts-edit.jsp|
|10|Trang tĩnh (Static Pages)|StaticPageController, StaticPageService, StaticPageDAO, AdminStaticPageController, static-pages.jsp, static-page-edit.jsp, ChinhSachNhanVaHoanTra.jsp, DieuKhoanDichVu.jsp, HuongDanMuaHang.jsp, GioiThieu.jsp|
|11|Product (danh sách, chi tiết, lọc)|ProductController, ProductDetailController, SearchController, SanPham.jsp, ChiTietSanPham.jsp, SanPham.js, ChiTietSanPham.js|
|12|Admin (Product)|AdminProductController, products.jsp, product-add.jsp, product-edit.jsp, AdminCategoryController, categories.jsp, categories-add.jsp, categories-edit.jsp|
|13|Product Variant|ProductVariantDAO, ProductVariant.java|
|14|Product Image|ProductImageDAO, ProductImage.java|
|15|Rating/Review|ReviewDAO, ReviewService, ReviewImageDAO, Review.java, ReviewImage.java|
|16|Flash Sale / Giá Tốt|GiaTotController, FlashSaleDAO, FlashSaleService, FlashSale.java, GiaTot.jsp, GiaTot.js, flash-sale-section.jsp|
|17|Admin Flash Sale|AdminFlashSaleController, flash-sales.jsp, flash-sale-add.jsp, flash-sale-edit.jsp|
|18|Search|SearchController|
|19|News Category / News Image|NewsCategoryDAO, NewsCategoryService, NewsCategory.java, NewsImageDAO, NewsImage.java|
|20|Trang chủ (Home)|HomeController, index.jsp, index.js|
|21|Contact|ContactController, LienHe.jsp, LienHe.js|
|22|Cart (Giỏ hàng)|AddToCartController, CartController, CartService, CartDAO, CartItemDAO, GioHang.jsp, GioHang.js, cart.js|
|23|Wishlist|WishlistController, WishlistService, WishlistDAO|
|24|Checkout & Order|CheckoutController, PlaceOrderController, OrderConfirmController, ThanhToan.jsp, ThanhToan.js, ThankYou.jsp|
|25|Quản lý Đơn hàng|UserOrderController, OrderService, OrderDAO, OrderDetailDAO, DonHangList.jsp, DonHangChiTiet.jsp, DonHang.js|
|26|Admin (Order Dashboard)|AdminOrderController, AdminDashboardController, orders.jsp, order-detail.jsp, dashboard.jsp|
|27|Address API|AddressApiController, AddressService, AddressDAO, Address.java|
|28|Payment Method|PaymentMethodDAO, PaymentMethodService, PaymentMethod.java|
|29|Guest Info|GuestInfo.java|
|30|Admin Notifications|AdminNotificationController, AdminNotificationsPageController, AdminNotificationDAO, AdminNotificationService, notifications.jsp|
