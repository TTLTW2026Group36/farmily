<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Đăng ký tài khoản | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DangKy.css?v=<%= System.currentTimeMillis() %>">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=<%= System.currentTimeMillis() %>">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body>

            
                <jsp:include page="common/header.jsp" />
                <nav class="site-breadcrumb" aria-label="Breadcrumb">
                    <div class="breadcrumb-container">
                        <ol class="breadcrumb-list">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/">
                                    <i class="fas fa-home"></i>
                                    Trang chủ
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Đăng ký tài khoản
                            </li>
                        </ol>
                    </div>
                </nav>

                <main>
                    <div class="register-container">
                        <h1>THÔNG TIN CÁ NHÂN</h1>
                        <p>Bạn chưa có tài khoản ?
                            <a href="${pageContext.request.contextPath}/dang-nhap">Đăng nhập tại đây.</a>
                        </p>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            


                                    <label>Họ và Tên <span>*</span></label>
                                    <input type="text" name="name" placeholder="Tên" required value="${name}">

                                    <label>Số điện thoại <span>*</span></label>
                                    <input type="tel" name="phone" placeholder="Số điện thoại" required
                                        pattern="[0-9]{10,11}" value="${phone}">

                                    <label>Email <span>*</span></label>
                                    <input type="email" name="email" placeholder="Email" required value="${email}">

                                    <label>Mật khẩu <span>*</span></label>
                                    <input type="password" name="password" id="password" placeholder="Mật khẩu" required>

                                    <div class="password-strength-container" id="strength-container" style="display: none;">
                                        <div class="progress-bar">
                                            <div id="strength-bar" class="strength-bar"></div>
                                        </div>
                                        <div id="strength-text" class="strength-text">Độ mạnh: Yếu</div>

                                        <ul class="strength-criteria">
                                            <li id="rule-length">Phải ít nhất 8 ký tự</li>
                                            <li id="rule-upper">Phải có chữ viết hoa</li>
                                            <li id="rule-lower">Phải có chữ viết thường</li>
                                            <li id="rule-number">Phải có chữ số</li>
                                            <li id="rule-special">Phải có ký tự đặc biệt</li>
                                        </ul>
                                    </div>

                                    <label>Nhập lại mật khẩu <span>*</span></label>
                                    <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu"
                                        required>

                                    <c:if test="${not empty error}">
                                        <div style="color: red; margin-top: 10px; text-align: center;">
                                            ${error}
                                        </div>
                                    </c:if>
                                    <button type="submit" class="submit">Đăng ký</button>
                        </form>

                        <p class="hoac">Hoặc đăng nhập bằng</p>
                        <div class="social-login">
                            <button class="fb"><i class="fa-brands fa-facebook"></i> Facebook</button>
                            <button class="gg"><i class="fa-brands fa-google"></i> Google</button>
                        </div>
                    </div>
                </main>

                <script src="${pageContext.request.contextPath}/js/DangKy.js?v=<%= System.currentTimeMillis() %>"></script>
                    <jsp:include page="common/footer.jsp" />
        </body>

        </html>