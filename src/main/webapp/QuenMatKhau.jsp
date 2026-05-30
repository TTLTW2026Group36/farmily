<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DangNhap.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>


    <header class="login-header">
        <div class="header-container">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/" class="logo-link">
                    <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="Farmily Logo" class="brand-logo">
                </a>
                <span class="header-title">Quên mật khẩu</span>
            </div>
            <a href="${pageContext.request.contextPath}/lien-he" class="help-link">Bạn cần trợ giúp?</a>
        </div>
    </header>

    <main class="login-main">
        <div class="login-container">

            <div class="login-brand-banner">
                <div class="brand-logo-large">
                    <i class="fas fa-seedling"></i> Farmily
                </div>
                <h2>Nông Sản Sạch từ Nông Trại</h2>
                <p>Mang bữa ăn tươi ngon, an toàn & trọn vẹn dinh dưỡng trực tiếp từ vườn hữu cơ đến bàn ăn nhà bạn.</p>
                <ul class="brand-features-list">
                    <li><i class="fas fa-check-circle"></i> 100% Thực phẩm sạch chất lượng cao</li>
                    <li><i class="fas fa-check-circle"></i> Giao nhận nhanh chóng trong ngày</li>
                    <li><i class="fas fa-check-circle"></i> Hỗ trợ thanh toán tiện lợi qua ví & thẻ</li>
                </ul>
            </div>


            <div class="login-card">
                <div class="card-header">
                    <h1>Yêu cầu đặt lại mật khẩu</h1>
                    <p style="color: #666; font-size: 14px; margin-top: 8px; line-height: 1.4;">Nhập địa chỉ email đã đăng ký để nhận liên kết/mã OTP đặt lại mật khẩu.</p>
                </div>


                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span id="error-text">${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="modern-form">
                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="email" name="email" placeholder="Địa chỉ email đã đăng ký" value="${email}" required autofocus>
                        </div>
                    </div>

                    <button class="submit-btn submit" type="submit">GỬI LIÊN KẾT / MÃ OTP</button>

                    <a class="back-to-login" href="${pageContext.request.contextPath}/dang-nhap">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </form>

                <div class="divider">
                    <span>HOẶC ĐĂNG NHẬP VỚI</span>
                </div>

                <div class="social-login">
                    <a href="${googleOAuthUrl}" class="social-btn gg-btn">
                        <i class="fa-brands fa-google google-icon"></i>
                        <span>Google</span>
                    </a>
                    <a href="${facebookOAuthUrl}" class="social-btn fb-btn">
                        <i class="fa-brands fa-facebook"></i>
                        <span>Facebook</span>
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />

    <script>

        const forgotForm = document.querySelector('form');
        const btnSubmit = document.querySelector('button.submit');
        
        if (forgotForm && btnSubmit) {
            forgotForm.onsubmit = function() {
                btnSubmit.disabled = true;
                btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
                btnSubmit.style.opacity = '0.7';
            };
        }


        const errorMsg = document.getElementById('error-text');
        if (errorMsg) {
            let match = errorMsg.innerText.match(/\d+/);
            if (match) {
                let seconds = parseInt(match[0]);
                const timer = setInterval(() => {
                    seconds--;
                    if (seconds <= 0) {
                        clearInterval(timer);
                        const parent = errorMsg.closest('.alert-danger');
                        if(parent) {
                            parent.style.transition = 'opacity 0.5s';
                            parent.style.opacity = '0';
                            setTimeout(() => parent.style.display = 'none', 500);
                        }
                    } else {
                        errorMsg.innerText = errorMsg.innerText.replace(/\d+/, seconds);
                    }
                }, 1000);
            }
        }
    </script>
</body>

</html>