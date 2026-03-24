<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/settings.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
    <div class="admin-layout">
        
        <jsp:include page="sidebar.jsp" />
        
        <main class="admin-main">
            
            <form class="admin-form">
                
                <div class="form-section">
                    <h3 class="form-section-title">Thông tin cửa hàng</h3>

                    <div class="form-group">
                        <label for="shopName">Tên cửa hàng</label>
                        <input type="text" id="shopName" class="form-control" value="Farmily - Rau Củ Sạch">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" class="form-control" value="0332991664">
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" class="form-control" value="Farmily@gmail.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="address">Địa chỉ</label>
                        <input type="text" id="address" class="form-control"
                            value="Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh">
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea id="description" class="form-control"
                            rows="4">Farmily cung cấp rau củ quả sạch, hữu cơ từ các nông trại VietGAP. Giao hàng nhanh trong ngày tại TP.HCM.</textarea>
                    </div>
                </div>

                
                <div class="form-section">
                    <h3 class="form-section-title">Cài đặt vận chuyển</h3>

                    <div class="form-row-3">
                        <div class="form-group">
                            <label for="freeShip">Miễn phí ship (VNĐ)</label>
                            <input type="number" id="freeShip" class="form-control" value="200000">
                            <div class="form-text">Đơn từ giá trị này được free ship</div>
                        </div>

                        <div class="form-group">
                            <label for="shipFee">Phí ship mặc định (VNĐ)</label>
                            <input type="number" id="shipFee" class="form-control" value="18000">
                        </div>

                        <div class="form-group">
                            <label for="shipTime">Thời gian giao (giờ)</label>
                            <input type="text" id="shipTime" class="form-control" value="2-6">
                        </div>
                    </div>
                </div>

                
                <div class="form-section">
                    <h3 class="form-section-title">Phương thức thanh toán</h3>

                    <div class="form-group">
                        <div class="checkbox-wrapper">
                            <input type="checkbox" id="codEnabled" checked>
                            <label for="codEnabled">Thanh toán COD (khi nhận hàng)</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="checkbox-wrapper">
                            <input type="checkbox" id="bankEnabled" checked>
                            <label for="bankEnabled">Chuyển khoản ngân hàng</label>
                        </div>
                    </div>

                    <div class="form-group" style="margin-left: 30px;">
                        <label for="bankInfo">Thông tin ngân hàng</label>
                        <textarea id="bankInfo" class="form-control" rows="3">Ngân hàng: Vietcombank
Số tài khoản: 1234567890
Chủ tài khoản: Farmily</textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3 class="form-section-title">Mã giảm giá mặc định</h3>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="newCustomerCoupon">Mã cho khách mới</label>
                            <input type="text" id="newCustomerCoupon" class="form-control" value="WELCOME10">
                        </div>

                        <div class="form-group">
                            <label for="newCustomerDiscount">Giảm giá (%)</label>
                            <input type="number" id="newCustomerDiscount" class="form-control" value="10">
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3 class="form-section-title">Thông báo Email</h3>

                    <div class="form-group">
                        <div class="checkbox-wrapper">
                            <input type="checkbox" id="emailNewOrder" checked>
                            <label for="emailNewOrder">Gửi email khi có đơn hàng mới</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="checkbox-wrapper">
                            <input type="checkbox" id="emailLowStock" checked>
                            <label for="emailLowStock">Cảnh báo khi sản phẩm sắp hết hàng</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="adminEmail">Email nhận thông báo</label>
                        <input type="email" id="adminEmail" class="form-control" value="admin@farmily.com">
                    </div>
                </div>

                <div class="form-section">
                    <h3 class="form-section-title">Mạng xã hội</h3>

                    <div class="form-group">
                        <label for="facebook">Facebook</label>
                        <input type="url" id="facebook" class="form-control" placeholder="https://facebook.com/farmily">
                    </div>

                    <div class="form-group">
                        <label for="instagram">Instagram</label>
                        <input type="url" id="instagram" class="form-control"
                            placeholder="https://instagram.com/farmily">
                    </div>

                    <div class="form-group">
                        <label for="tiktok">TikTok</label>
                        <input type="url" id="tiktok" class="form-control" placeholder="https://tiktok.com/@farmily">
                    </div>
                </div>

                <div
                    style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                    <button type="reset" class="btn btn-secondary">Đặt lại</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu cài đặt
                    </button>
                </div>
            </form>
    </div>
    </main>
    </div>
    <script>
        document.querySelector('form').addEventListener('submit', function (e) {
            e.preventDefault();
            alert('Đã lưu cài đặt thành công!');
        });
    </script>
</body>

</html>