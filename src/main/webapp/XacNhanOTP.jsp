<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP | Farmily</title>
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
                <span class="header-title">Xác minh OTP</span>
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
                <div class="card-header" style="text-align: center;">
                    <div style="font-size: 50px; color: var(--primary-color, #219653); margin-bottom: 15px;">
                        <i class="fas fa-shield-halved"></i>
                    </div>
                    <h1>Xác thực mã OTP</h1>
                    <p style="color: #666; font-size: 14px; margin-top: 8px; line-height: 1.5;">
                        Chúng tôi vừa gửi mã xác nhận 6 số đến email:<br>
                        <strong style="color: #222;">${emailSent}</strong>
                    </p>
                </div>


                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px; text-align: left;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/verify-otp" method="post" id="otpForm" class="modern-form" style="text-align: center;">
                    <input type="hidden" name="email" value="${emailSent}">
                    
                    <div class="otp-input-group">
                        <input type="text" name="otp" maxlength="6" class="otp-input"
                               placeholder="XXXXXX" required
                               oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                    </div>

                    <button type="submit" class="submit-btn">BẮT ĐẦU XÁC MINH</button>
                </form>

                <div class="resend-box">
                    Bạn chưa nhận được mã? 
                    <a href="${pageContext.request.contextPath}/forgot-password" class="resend-link">Gửi lại ngay</a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />
</body>
</html>
