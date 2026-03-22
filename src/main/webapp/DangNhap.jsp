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
                            Đăng nhập
                        </li>
                    </ol>
                </div>
            </nav>

            <main>
                <div class="login-container">
                    <h1>ĐĂNG NHẬP TÀI KHOẢN</h1>

                    <c:if test="${not empty sessionScope.passwordResetSuccess}">
                        <div
                            style="background: #e8f5e9; color: #2e7d32; padding: 15px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                            <i class="fas fa-check-circle"></i>
                            ${sessionScope.passwordResetSuccess}
                        </div>
                        <c:remove var="passwordResetSuccess" scope="session" />
                    </c:if>

                    <p>Bạn chưa có tài khoản ?
                        <a href="${pageContext.request.contextPath}/register">Đăng ký tại đây.</a>
                    </p>

                    <form action="${pageContext.request.contextPath}/login" method="post">

                        <label>Email <span>*</span> </label>
                        <input type="text" name="username" placeholder="Email" style="margin-top: 8px;" required>

                        <label>Mật khẩu <span>*</span></label>
                        <input type="password" name="password" placeholder="Mật khẩu" style="margin-top: 8px;" required>

                        <div class="quenmk">
                            <small>Quên mật khẩu? Nhấn vào
                                <a href="${pageContext.request.contextPath}/forgot-password">đây</a></small>
                        </div>

                        <c:if test="${not empty error}">
                            <p style="color: red; text-align: center;">${error}</p>
                        </c:if>

                        <button class="submit" type="submit">Đăng nhập</button>
                    </form>

                    <p class="hoac">Hoặc đăng nhập bằng</p>
                    <div class="social-login">
                        <a href="https://www.facebook.com/v19.0/dialog/oauth?client_id=962984642734580
&redirect_uri=http://localhost:8080/Farmily/LoginController" class="fb">
                            <i class="fa-brands fa-facebook"></i> Facebook
                        </a>
                        <button class="gg"><i class="fa-brands fa-google"></i> Google</button>
                    </div>
                </div>
            </main>


            <jsp:include page="common/footer.jsp" />
        </body>

        </html>