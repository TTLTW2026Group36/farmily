<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản | Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DangNhap.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=5">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>


    <header class="login-header">
        <div class="header-container">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/" class="logo-link">
                    <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="Farmily Logo" class="brand-logo">
                </a>
                <span class="header-title">Đăng ký</span>
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
                    <h1>Đăng ký</h1>
                </div>


                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="modern-form">
                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="text" name="name" placeholder="Họ và Tên" value="${name}" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="tel" name="phone" placeholder="Số điện thoại" value="${phone}" required pattern="[0-9]{10,11}">
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="email" name="email" placeholder="Email" value="${email}" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="password" name="password" id="password" placeholder="Mật khẩu" required>
                            <i class="fas fa-eye-slash toggle-eye" id="togglePassword"></i>
                        </div>
                        
                        <div class="password-strength-container" id="strength-container" style="display: none;">
                            <div class="progress-bar">
                                <div id="strength-bar" class="strength-bar"></div>
                            </div>
                            <div id="strength-text" class="strength-text">Độ mạnh: Yếu</div>

                            <ul class="strength-criteria">
                                <li id="rule-length">Không đủ 8 ký tự</li>
                                <li id="rule-upper">Không có chữ viết hoa</li>
                                <li id="rule-lower">Không có chữ viết thường</li>
                                <li id="rule-number">Không có chữ số</li>
                                <li id="rule-special">Không có ký tự đặc biệt</li>
                            </ul>
                        </div>
                    </div>

                    <div class="input-group">
                        <div class="input-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                            <i class="fas fa-eye-slash toggle-eye" id="toggleConfirmPassword"></i>
                        </div>
                    </div>

                    <button class="submit-btn submit" type="submit">ĐĂNG KÝ</button>
                </form>

                <div class="divider">
                    <span>HOẶC</span>
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

                <p class="register-prompt">
                    Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/dang-nhap">Đăng nhập</a>
                </p>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/DangKy.js?v=<%= System.currentTimeMillis() %>"></script>
    <jsp:include page="common/footer.jsp" />
</body>

</html>