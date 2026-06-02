# Nhật ký Kỹ thuật: Thiết kế và Lập kế hoạch phòng chống IDOR trong OrderConfirmController

**Ngày:** 2026-06-03
**Tác giả:** Antigravity AI
**Chủ đề:** Khắc phục lỗi IDOR và lộ thông tin cá nhân (PII) trên trang xác nhận đơn hàng (`/order-confirmation`)

## 1. Bối cảnh & Vấn đề
* Trang `/order-confirmation?id=X` cho phép xem thông tin xác nhận đơn hàng (gồm tên, số điện thoại, địa chỉ, chi tiết đơn hàng) bằng cách thay đổi giá trị `id` trên URL trực tiếp.
* Không có bước kiểm tra quyền sở hữu đơn hàng (IDOR), dẫn đến nguy cơ rò rỉ dữ liệu cá nhân (PII).

## 2. Giải pháp Thiết kế
* Sử dụng một Set lưu trong session dưới khóa `"authorizedOrderIds"` (`Set<Integer>`) để theo dõi các đơn hàng được phép xem bởi phiên người dùng hiện tại (cả thành viên đăng nhập và khách vãng lai).
* **Nơi cấp quyền:** Trong `PlaceOrderController.java`, sau khi tạo đơn hàng thành công, ID đơn hàng được đưa vào Set này.
* **Nơi xác thực:** Trong `OrderConfirmController.java`:
  * Đối với Member: Hợp lệ nếu ID đơn hàng thuộc Set trong session HOẶC `order.getUserId()` bằng ID người dùng hiện tại.
  * Đối với Guest: Hợp lệ nếu ID đơn hàng thuộc Set trong session.
  * Nếu không hợp lệ: Trả về lỗi `403 Forbidden`.

## 3. Lập kế hoạch Triển khai
* Kế hoạch hành động chi tiết đã được tạo tại `plans/fix-idor-order-confirm/` bao gồm 3 pha: Research, Implement, và Test.
