<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    if (statusCode == null) {
        statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    }
    
    String errorTitle = "Đã Có Lỗi Xảy Ra";
    String errorDesc = "Hệ thống đang gặp sự cố nhỏ. Vui lòng thử lại sau.";
    String errorIcon = "fa-exclamation-triangle";
    
    if (statusCode != null) {
        if (statusCode == 404) {
            errorTitle = "404 - Không Tìm Thấy Trang";
            errorDesc = "Đường dẫn bạn truy cập không tồn tại hoặc đã bị di chuyển.";
            errorIcon = "fa-compass";
        } else if (statusCode == 500) {
            errorTitle = "500 - Lỗi Hệ Thống";
            errorDesc = "Hệ thống xảy ra lỗi xử lý. Chúng tôi đang kiểm tra và khắc phục.";
            errorIcon = "fa-server";
        } else {
            errorTitle = statusCode + " - Lỗi Truy Cập";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= errorTitle %> - Farmily</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=5">
    <style>
        .error-page-container {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 60vh;
            background: linear-gradient(135deg, #f4f6f8 0%, #eef1f5 100%);
            padding: 40px 20px;
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
        }
        .error-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            padding: 50px 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }
        .error-card:hover {
            transform: translateY(-5s);
        }
        .error-icon-wrapper {
            width: 90px;
            height: 90px;
            background: rgba(46, 125, 50, 0.1);
            color: #2e7d32;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin: 0 auto 24px;
        }
        .error-title {
            font-size: 26px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        .error-description {
            font-size: 16px;
            color: #666666;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: #2e7d32;
            color: #ffffff;
            padding: 12px 28px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.2s ease, transform 0.2s ease;
        }
        .btn-home:hover {
            background-color: #1b5e20;
            color: #ffffff;
            transform: translateY(-2px);
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="error-page-container">
        <div class="error-card">
            <div class="error-icon-wrapper">
                <i class="fas <%= errorIcon %>"></i>
            </div>
            <h1 class="error-title"><%= errorTitle %></h1>
            <p class="error-description"><%= errorDesc %></p>
            <a href="${pageContext.request.contextPath}/" class="btn-home">
                <i class="fas fa-home"></i> Quay lại Trang chủ
            </a>
        </div>
    </div>

    <jsp:include page="common/footer.jsp" />
</body>
</html>
