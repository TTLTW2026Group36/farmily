<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Đăng nhập Admin - Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/login.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <script src="https://www.google.com/recaptcha/api.js" async defer></script>
            <style>
                .alert-error {
                    background: #fee2e2;
                    border-left: 4px solid #dc2626;
                    color: #991b1b;
                }

                .alert-warning {
                    background: #fef3c7;
                    border-left: 4px solid #f59e0b;
                    color: #92400e;
                }

                .alert-success {
                    background: #d1fae5;
                    border-left: 4px solid #10b981;
                    color: #065f46;
                }
            </style>
        </head>

        <body>
            <div class="login-page">
                <div class="login-container">
                    <div class="login-header">
                        <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="Farmily Logo">
                        <h1>Quản trị Farmily</h1>
                        <p>Đăng nhập để tiếp tục</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty warning}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            ${warning}
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <c:choose>
                                <c:when test="${success == 'logout'}">Đã đăng xuất thành công</c:when>
                                <c:otherwise>${success}</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <form class="login-form" action="${pageContext.request.contextPath}/admin/login" method="post">
                        <div class="form-group">
                            <label for="username">Tên đăng nhập</label>
                            <input type="text" id="username" name="username" class="form-control" placeholder="admin"
                                required autocomplete="username" value="${param.username}">
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" class="form-control"
                                placeholder="••••••••" required autocomplete="current-password">
                        </div>

                        <div class="checkbox-wrapper">
                            <input type="checkbox" id="remember" name="remember" value="true">
                            <label for="remember">Ghi nhớ đăng nhập</label>
                        </div>

                        <c:if test="${showCaptcha}">
                            <div class="g-recaptcha" data-sitekey="<%= group36.util.FarmilyConstants.RECAPTCHA_SITE_KEY %>" style="margin-bottom: 20px;"></div>
                        </c:if>

                        <input type="hidden" name="redirect" value="${param.redirect}">

                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt"></i>Đăng nhập
                        </button>
                    </form>

                    <div class="login-footer">
                        <p>Quên mật khẩu? Liên hệ quản trị hệ thống</p>
                    </div>
                </div>
            </div>
        </body>

        </html>