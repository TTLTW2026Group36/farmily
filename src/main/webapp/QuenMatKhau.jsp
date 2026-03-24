<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quên mật khẩu | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuenMatKhau.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .error-message {
                    background: #ffebee;
                    color: #c62828;
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin: 15px 0;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .info-box {
                    background: #e3f2fd;
                    color: #1565c0;
                    padding: 15px 20px;
                    border-radius: 8px;
                    margin: 20px 0;
                    font-size: 14px;
                    line-height: 1.6;
                }

                .info-box i {
                    margin-right: 8px;
                }

                .forgot-container h1 i {
                    color: #4CAF50;
                    margin-right: 10px;
                }
            </style>
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
                                Quên mật khẩu
                            </li>
                        </ol>
                    </div>
                </nav>

                <main>
                    <div class="forgot-container">
                        <h1><i class="fas fa-lock"></i> QUÊN MẬT KHẨU</h1>
                        <p>Nhập địa chỉ email đã đăng ký để nhận mã OTP đặt lại mật khẩu.</p>


                        <c:if test="${not empty error}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle"></i>
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                            <label>Email <span>*</span></label>
                            <input type="email" name="email" placeholder="Nhập địa chỉ email" value="${email}" required
                                autofocus>

                            <button class="submit" type="submit">
                                <i class="fas fa-paper-plane"></i> Gửi mã OTP
                            </button>

                            <a class="back" href="${pageContext.request.contextPath}/dang-nhap">
                                <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                            </a>
                        </form>

                        <p class="hoac">Hoặc đăng nhập bằng</p>
                        <div class="social-login">
                            <button class="fb"><i class="fa-brands fa-facebook"></i> Facebook</button>
                            <button class="gg"><i class="fa-brands fa-google"></i> Google</button>
                        </div>
                    </div>
                </main>

                
                    <jsp:include page="common/footer.jsp" />
        </body>

        </html>