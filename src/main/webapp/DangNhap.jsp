<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng nhập tài khoản | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DangNhap.css">
            <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        </head>

        <body>

            <!-- Shopee-style Minimal Header -->
            <header class="login-header">
                <div class="header-container">
                    <div class="header-left">
                        <a href="${pageContext.request.contextPath}/" class="logo-link">
                            <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="Farmily Logo" class="brand-logo">
                        </a>
                        <span class="header-title">Đăng nhập</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/lien-he" class="help-link">Bạn cần trợ giúp?</a>
                </div>
            </header>

            <main class="login-main">
                <div class="login-container">
                    <!-- Banner thương hiệu bên trái (giống Shopee, ẩn trên mobile) -->
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

                    <!-- Card đăng nhập lớn bên phải -->
                    <div class="login-card">
                        <div class="card-header">
                            <h1>Đăng nhập</h1>
                        </div>

                        <!-- Thông báo thành công -->
                        <c:if test="${not empty sessionScope.passwordResetSuccess}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i>
                                <span>${sessionScope.passwordResetSuccess}</span>
                            </div>
                            <c:remove var="passwordResetSuccess" scope="session" />
                        </c:if>

                        <!-- Thông báo lỗi -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${error}</span>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post" class="modern-form">
                            <div class="input-group">
                                <div class="input-wrapper">
                                    <input type="text" id="username" name="username" placeholder="Email / Tên đăng nhập" value="${username}" required>
                                </div>
                            </div>

                            <div class="input-group">
                                <div class="input-wrapper">
                                    <input type="password" name="password" id="password" placeholder="Mật khẩu" required>
                                    <i class="fas fa-eye-slash toggle-eye" id="togglePassword"></i>
                                </div>
                            </div>

                            <div class="form-options">
                                <label class="remember-me">
                                    <input type="checkbox" id="rememberMe" name="rememberMe" value="true">
                                    <span class="checkmark"></span>
                                    Ghi nhớ đăng nhập
                                </label>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
                            </div>

                            <c:if test="${showCaptcha}">
                                <div class="captcha-container">
                                    <div class="g-recaptcha" data-sitekey="<%= group36.util.FarmilyConstants.RECAPTCHA_SITE_KEY %>"></div>
                                </div>
                            </c:if>

                            <button class="submit-btn" type="submit">ĐĂNG NHẬP</button>
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
                            Bạn mới biết đến Farmily? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </p>
                    </div>
                </div>
            </main>


            <jsp:include page="common/footer.jsp" />
            <script src="${pageContext.request.contextPath}/js/DangNhap.js"></script>
        </body>

        </html>