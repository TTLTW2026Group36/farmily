# Tổng quan chức năng hiện có - Farmily

Tài liệu này rà soát chức năng hiện có trong source hiện tại của dự án Farmily.

## 1. Tổng quan hệ thống

Farmily là web app bán nông sản dùng Java Servlet/JSP, Gradle, WAR deployment.

Các nhóm chức năng chính:

- Khách hàng: trang chủ, sản phẩm, tìm kiếm, tin tức, liên hệ, trang tĩnh.
- Tài khoản: đăng ký, đăng nhập, đăng xuất, quên mật khẩu, OTP, đổi mật khẩu, hồ sơ.
- Mua hàng: giỏ hàng, wishlist, checkout, đặt hàng, thanh toán, theo dõi đơn hàng.
- Admin: dashboard, quản lý sản phẩm, danh mục, flash sale, bài viết, trang tĩnh, khách hàng, đơn hàng, thông báo.
- API nội bộ: giỏ hàng, địa chỉ, danh mục, thanh toán, thông báo admin.

## 2. Công nghệ và cấu trúc chính

- Build: Gradle Groovy DSL (`build.gradle`, `settings.gradle`).
- Backend: Java Servlet/JSP.
- View: JSP trong `src/main/webapp`.
- Controller: `src/main/java/group36/controller`.
- Service: `src/main/java/group36/service`.
- DAO: `src/main/java/group36/dao`.
- Model: `src/main/java/group36/model`.
- Filter: `src/main/java/group36/filter`.

## 3. Chức năng public/khách hàng

### 3.1 Trang chủ

- Hiển thị trang chủ Farmily.
- Nạp dữ liệu nổi bật như danh mục, sản phẩm, flash sale nếu controller/service cung cấp.
- File liên quan:
  - `HomeController`
  - `index.jsp`
  - `common/header.jsp`
  - `common/footer.jsp`
  - `common/flash-sale-section.jsp`

### 3.2 Sản phẩm

- Xem danh sách sản phẩm.
- Xem chi tiết sản phẩm.
- Lọc/tìm sản phẩm theo danh mục, từ khóa hoặc tiêu chí controller hỗ trợ.
- Hiển thị biến thể, hình ảnh, đánh giá nếu có dữ liệu.
- File liên quan:
  - `ProductController`
  - `ProductDetailController`
  - `SearchController`
  - `ProductService`
  - `ProductVariantDAO`
  - `ProductImageDAO`
  - `ReviewService`
  - `ReviewDAO`
  - `ReviewImageDAO`
  - `SanPham.jsp`
  - `ChiTietSanPham.jsp`

### 3.3 Danh mục

- API lấy danh mục sản phẩm.
- Phục vụ dropdown/menu/filter phía giao diện.
- Route chính:
  - `/api/categories`
- File liên quan:
  - `CategoryController`
  - `CategoryService`
  - `CategoryDAO`
  - `Category.java`

### 3.4 Tìm kiếm

- Tìm sản phẩm theo keyword.
- Có thể dùng chung với trang sản phẩm hoặc trả kết quả qua route riêng.
- File liên quan:
  - `SearchController`
  - `ProductService`
  - `SanPham.jsp`

### 3.5 Flash sale / Giá tốt

- Hiển thị danh sách sản phẩm đang flash sale hoặc chương trình giá tốt.
- Hiển thị section flash sale ở trang chủ.
- File liên quan:
  - `GiaTotController`
  - `FlashSaleService`
  - `FlashSaleDAO`
  - `FlashSale.java`
  - `GiaTot.jsp`
  - `common/flash-sale-section.jsp`

### 3.6 Tin tức / Blog

- Xem danh sách tin tức.
- Xem chi tiết bài viết.
- Hỗ trợ danh mục tin và ảnh tin tức ở tầng dữ liệu.
- File liên quan:
  - `NewsController`
  - `NewsDetailController`
  - `NewsService`
  - `NewsCategoryService`
  - `NewsDAO`
  - `NewsCategoryDAO`
  - `NewsImageDAO`
  - `TinTuc.jsp`
  - `ChiTietTinTuc.jsp`

### 3.7 Trang tĩnh

- Hiển thị các trang nội dung tĩnh của website.
- Các trang hiện có:
  - Giới thiệu
  - Hướng dẫn mua hàng
  - Chính sách nhận và hoàn trả
  - Điều khoản dịch vụ
- File liên quan:
  - `StaticPageController`
  - `StaticPageService`
  - `StaticPageDAO`
  - `GioiThieu.jsp`
  - `HuongDanMuaHang.jsp`
  - `ChinhSachNhanVaHoanTra.jsp`
  - `DieuKhoanDichVu.jsp`

### 3.8 Liên hệ

- Hiển thị form liên hệ.
- Gửi/lưu nội dung liên hệ từ khách hàng.
- File liên quan:
  - `ContactController`
  - `ContactService`
  - `ContactDAO`
  - `Contact.java`
  - `LienHe.jsp`

## 4. Tài khoản và xác thực

### 4.1 Đăng ký

- Người dùng tạo tài khoản mới.
- Kiểm tra dữ liệu đăng ký và email đã tồn tại.
- Sau đăng ký thành công chuyển về trang chủ hoặc đăng nhập theo logic controller.
- Route chính:
  - `/register`
- File liên quan:
  - `RegisterController`
  - `AuthService`
  - `UserDAO`
  - `User.java`
  - `DangKy.jsp`

### 4.2 Đăng nhập

- Người dùng đăng nhập bằng username/email và mật khẩu.
- Hỗ trợ lưu session người dùng.
- Có service liên quan Google/Facebook auth.
- Route chính:
  - `/login`
  - `/dang-nhap`
- File liên quan:
  - `LoginController`
  - `AuthService`
  - `GoogleAuthService`
  - `FacebookAuthService`
  - `RememberMeFilter`
  - `DangNhap.jsp`

### 4.3 Đăng xuất

- Xóa session/cookie đăng nhập.
- Chuyển người dùng về trang public.
- Route chính:
  - `/logout`
- File liên quan:
  - `LogoutController`

### 4.4 Quên mật khẩu / OTP / đặt lại mật khẩu

- Người dùng nhập email để yêu cầu đặt lại mật khẩu.
- Hệ thống tạo OTP/token reset.
- Người dùng xác nhận OTP và đặt mật khẩu mới.
- Route chính:
  - `/forgot-password`
  - `/quen-mat-khau`
  - `/verify-otp`
  - `/xac-nhan-otp`
  - `/reset-password`
  - `/dat-lai-mat-khau`
- File liên quan:
  - `ForgotPasswordController`
  - `VerifyOTPController`
  - `ResetPasswordController`
  - `PasswordResetService`
  - `PasswordResetTokenDAO`
  - `PasswordResetToken.java`
  - `QuenMatKhau.jsp`
  - `XacNhanOTP.jsp`
  - `DatLaiMatKhau.jsp`

### 4.5 Hồ sơ cá nhân

- Xem thông tin tài khoản.
- Cập nhật thông tin cá nhân.
- Đổi mật khẩu.
- File liên quan:
  - `ProfileController`
  - `UpdateProfileController`
  - `ChangePasswordController`
  - `UserService`
  - `UserDAO`
  - `HoSo.jsp`

### 4.6 Phân quyền và redirect

- Chặn route admin nếu chưa đăng nhập hoặc không đủ quyền.
- Redirect `/` về trang phù hợp.
- Ghi nhớ đăng nhập bằng filter remember-me.
- File liên quan:
  - `AdminAuthFilter`
  - `HomeRedirectFilter`
  - `RememberMeFilter`

## 5. Mua hàng

### 5.1 Giỏ hàng

- Xem giỏ hàng.
- Thêm sản phẩm vào giỏ.
- Cập nhật số lượng.
- Xóa sản phẩm khỏi giỏ.
- Hỗ trợ API thao tác giỏ hàng.
- Route chính:
  - `/gio-hang`
  - `/cart`
  - `/api/cart`
  - `/api/cart/*`
- File liên quan:
  - `CartController`
  - `AddToCartController`
  - `CartService`
  - `CartDAO`
  - `CartItemDAO`
  - `Cart.java`
  - `CartItem.java`
  - `GioHang.jsp`

### 5.2 Wishlist

- Thêm/xóa sản phẩm yêu thích.
- Lấy danh sách yêu thích của người dùng.
- File liên quan:
  - `WishlistController`
  - `WishlistService`
  - `WishlistDAO`
  - `Wishlist.java`

### 5.3 Checkout và đặt hàng

- Hiển thị trang thanh toán.
- Nhận thông tin người mua/địa chỉ/phương thức thanh toán.
- Tạo đơn hàng từ giỏ hàng.
- Hỗ trợ thông tin khách vãng lai qua model `GuestInfo`.
- File liên quan:
  - `CheckoutController`
  - `PlaceOrderController`
  - `OrderConfirmController`
  - `OrderService`
  - `PaymentMethodService`
  - `GuestInfo.java`
  - `Order.java`
  - `OrderDetail.java`
  - `ThanhToan.jsp`
  - `ThankYou.jsp`

### 5.4 Thanh toán

- Xử lý callback/IPN từ cổng thanh toán.
- Kiểm tra trạng thái thanh toán qua API.
- Hiển thị kết quả thanh toán.
- File liên quan:
  - `PaymentCallbackController`
  - `PaymentIpnController`
  - `PaymentStatusApiController`
  - `PaymentService`
  - `PaymentMethodService`
  - `PaymentMethodDAO`
  - `PaymentResult.jsp`

### 5.5 Đơn hàng của người dùng

- Xem danh sách đơn hàng.
- Xem chi tiết đơn hàng.
- File liên quan:
  - `UserOrderController`
  - `OrderService`
  - `Order.java`
  - `OrderDetail.java`
  - `DonHangList.jsp`
  - `DonHangChiTiet.jsp`

### 5.6 Địa chỉ

- API lấy/tạo/cập nhật/xóa địa chỉ người dùng.
- Có bản API riêng cho admin.
- Route chính:
  - `/api/address`
  - `/api/address/*`
  - `/admin/api/address`
  - `/admin/api/address/*`
- File liên quan:
  - `AddressApiController`
  - `AdminAddressApiController`
  - `AddressService`
  - `AddressDAO`
  - `Address.java`

## 6. Admin

### 6.1 Đăng nhập/đăng xuất admin

- Admin đăng nhập vào khu vực quản trị.
- Admin đăng xuất khỏi hệ thống quản trị.
- Route chính:
  - `/admin/login`
  - `/admin/logout`
- File liên quan:
  - `AdminLoginController`
  - `AdminLogoutController`
  - `AdminAuthFilter`
  - `admin/login.jsp`

### 6.2 Dashboard

- Hiển thị dashboard tổng quan cho admin.
- Có số liệu liên quan đơn hàng, doanh thu, người dùng, sản phẩm tùy dữ liệu service/DAO.
- Route chính:
  - `/admin`
  - `/admin/`
  - `/admin/dashboard`
- File liên quan:
  - `AdminDashboardController`
  - `admin/dashboard.jsp`

### 6.3 Quản lý khách hàng/người dùng

- Xem danh sách người dùng.
- Xem chi tiết người dùng.
- Chỉnh sửa thông tin người dùng.
- Cập nhật trạng thái hoặc quyền theo logic controller.
- Route chính:
  - `/admin/users`
  - `/admin/users/*`
- File liên quan:
  - `AdminUserController`
  - `UserService`
  - `UserDAO`
  - `admin/customers.jsp`
  - `admin/customers-detail.jsp`
  - `admin/customers-edit.jsp`

### 6.4 Quản lý sản phẩm

- Xem danh sách sản phẩm.
- Thêm sản phẩm.
- Sửa sản phẩm.
- Xóa hoặc cập nhật trạng thái sản phẩm.
- Quản lý dữ liệu liên quan biến thể và ảnh sản phẩm.
- Route chính:
  - `/admin/products`
  - `/admin/products/*`
- File liên quan:
  - `AdminProductController`
  - `ProductService`
  - `ProductVariantDAO`
  - `ProductImageDAO`
  - `admin/products.jsp`
  - `admin/product-add.jsp`
  - `admin/product-edit.jsp`

### 6.5 Quản lý danh mục

- Xem danh sách danh mục.
- Thêm danh mục.
- Sửa danh mục.
- Xóa/cập nhật trạng thái danh mục.
- Route chính:
  - `/admin/categories`
  - `/admin/categories/*`
- File liên quan:
  - `AdminCategoryController`
  - `CategoryService`
  - `CategoryDAO`
  - `admin/categories.jsp`
  - `admin/categories-add.jsp`
  - `admin/categories-edit.jsp`

### 6.6 Quản lý flash sale

- Xem danh sách flash sale.
- Thêm chương trình flash sale.
- Sửa chương trình flash sale.
- Xóa/cập nhật trạng thái flash sale.
- Route chính:
  - `/admin/flash-sales`
  - `/admin/flash-sales/*`
- File liên quan:
  - `AdminFlashSaleController`
  - `FlashSaleService`
  - `FlashSaleDAO`
  - `admin/flash-sales.jsp`
  - `admin/flash-sale-add.jsp`
  - `admin/flash-sale-edit.jsp`

### 6.7 Quản lý bài viết/tin tức

- Xem danh sách bài viết.
- Thêm bài viết.
- Sửa bài viết.
- Xóa/cập nhật trạng thái bài viết.
- Quản lý danh mục tin và ảnh tin tức ở tầng dữ liệu.
- Route chính:
  - `/admin/posts`
  - `/admin/posts/*`
- File liên quan:
  - `AdminPostController`
  - `NewsService`
  - `NewsCategoryService`
  - `NewsDAO`
  - `NewsCategoryDAO`
  - `NewsImageDAO`
  - `admin/posts.jsp`
  - `admin/posts-add.jsp`
  - `admin/posts-edit.jsp`

### 6.8 Quản lý trang tĩnh

- Xem danh sách trang tĩnh.
- Chỉnh sửa nội dung trang tĩnh.
- Route chính:
  - `/admin/static-pages`
  - `/admin/static-pages/*`
- File liên quan:
  - `AdminStaticPageController`
  - `StaticPageService`
  - `StaticPageDAO`
  - `admin/static-pages.jsp`
  - `admin/static-page-edit.jsp`

### 6.9 Quản lý đơn hàng

- Xem danh sách đơn hàng.
- Xem chi tiết đơn hàng.
- Cập nhật trạng thái đơn hàng.
- Route chính:
  - `/admin/orders`
  - `/admin/orders/*`
- File liên quan:
  - `AdminOrderController`
  - `OrderService`
  - `admin/orders.jsp`
  - `admin/order-detail.jsp`

### 6.10 Thông báo admin

- API lấy danh sách thông báo.
- Tạo thông báo khi có đơn hàng hoặc sự kiện hệ thống.
- Đánh dấu đã đọc.
- Trang xem thông báo trong admin.
- Route chính:
  - `/admin/notifications`
  - `/admin/api/notifications`
- File liên quan:
  - `AdminNotificationController`
  - `AdminNotificationsPageController`
  - `AdminNotificationService`
  - `AdminNotificationDAO`
  - `AdminNotification.java`
  - `admin/notifications.jsp`

## 7. API/route chính được phát hiện

### Public/Auth

| Route | Chức năng |
|---|---|
| `/` | Redirect trang chủ |
| `/home` | Trang chủ |
| `/login`, `/dang-nhap` | Đăng nhập |
| `/register` | Đăng ký |
| `/logout` | Đăng xuất |
| `/forgot-password`, `/quen-mat-khau` | Quên mật khẩu |
| `/verify-otp`, `/xac-nhan-otp` | Xác nhận OTP |
| `/reset-password`, `/dat-lai-mat-khau` | Đặt lại mật khẩu |
| `/gio-hang`, `/cart` | Giỏ hàng |
| `/api/cart`, `/api/cart/*` | API giỏ hàng |
| `/api/categories` | API danh mục |
| `/api/address`, `/api/address/*` | API địa chỉ |

### Admin

| Route | Chức năng |
|---|---|
| `/admin`, `/admin/`, `/admin/dashboard` | Dashboard admin |
| `/admin/login` | Đăng nhập admin |
| `/admin/logout` | Đăng xuất admin |
| `/admin/users`, `/admin/users/*` | Quản lý người dùng |
| `/admin/products`, `/admin/products/*` | Quản lý sản phẩm |
| `/admin/categories`, `/admin/categories/*` | Quản lý danh mục |
| `/admin/flash-sales`, `/admin/flash-sales/*` | Quản lý flash sale |
| `/admin/posts`, `/admin/posts/*` | Quản lý bài viết |
| `/admin/static-pages`, `/admin/static-pages/*` | Quản lý trang tĩnh |
| `/admin/orders`, `/admin/orders/*` | Quản lý đơn hàng |
| `/admin/notifications` | Trang thông báo admin |
| `/admin/api/notifications` | API thông báo admin |
| `/admin/api/address`, `/admin/api/address/*` | API địa chỉ cho admin |

## 8. Model dữ liệu chính

- `User`: tài khoản người dùng/admin.
- `Product`: sản phẩm.
- `ProductVariant`: biến thể sản phẩm.
- `ProductImage`: ảnh sản phẩm.
- `Category`: danh mục sản phẩm.
- `Cart`, `CartItem`: giỏ hàng.
- `Wishlist`: sản phẩm yêu thích.
- `Order`, `OrderDetail`: đơn hàng và chi tiết đơn hàng.
- `PaymentMethod`: phương thức thanh toán.
- `GuestInfo`: thông tin khách vãng lai.
- `Address`: địa chỉ giao hàng.
- `Review`, `ReviewImage`: đánh giá và ảnh đánh giá.
- `FlashSale`: chương trình flash sale.
- `News`, `NewsCategory`, `NewsImage`: tin tức, danh mục tin, ảnh tin.
- `StaticPage`: trang tĩnh.
- `Contact`: liên hệ.
- `AdminNotification`: thông báo admin.
- `PasswordResetToken`: token/OTP đặt lại mật khẩu.

## 9. Ghi chú rà soát

- Dự án hiện build được bằng `./gradlew war`.
- `./gradlew test` chạy thành công nhưng không có test source (`NO-SOURCE`).
- Có tài liệu cũ `docs/Phân chia chức năng Farmily.md` liệt kê phân chia 30 nhóm chức năng.
- Có file `src/main/java/group36/service/commit.txt` nằm trong source tree, nên kiểm tra lại có cần giữ không.
- Có thư mục webapp tên `${pageContext.request.contextPath}` nhìn bất thường, nên kiểm tra lại có phải tạo nhầm khi copy path JSP không.

## 10. Câu hỏi chưa rõ

- Chưa xác nhận đầy đủ từng route SEO/public vì một số route nằm trong controller nhưng cần đọc chi tiết từng file để map 100% URL.
- Chưa xác nhận chức năng thanh toán đang tích hợp cổng nào nếu không đọc sâu `PaymentService` và các payment controller.
