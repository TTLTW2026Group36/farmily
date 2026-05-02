<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo | Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .notice-container {
            max-width: 600px;
            margin: 100px auto;
            text-align: center;
            padding: 40px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .notice-icon {
            font-size: 60px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        h1 { color: #333; margin-bottom: 20px; }
        p { color: #666; line-height: 1.6; margin-bottom: 30px; }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: #4CAF50;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            transition: 0.3s;
        }
        .btn:hover { background: #45a049; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    <main>
        <div class="notice-container">
            <div class="notice-icon">
                <i class="fas fa-envelope-circle-check"></i>
            </div>
            <h1>Thông báo</h1>
            <p>${message}</p>
            <a href="${pageContext.request.contextPath}/" class="btn">Quay lại trang chủ</a>
        </div>
    </main>
    <jsp:include page="common/footer.jsp" />
</body>
</html>
