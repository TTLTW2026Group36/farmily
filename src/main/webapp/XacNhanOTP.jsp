<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP | Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .otp-container {
            max-width: 450px;
            margin: 100px auto;
            text-align: center;
            padding: 40px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .otp-icon { font-size: 50px; color: #4CAF50; margin-bottom: 20px; }
        h2 { color: #333; margin-bottom: 10px; }
        p.desc { color: #666; margin-bottom: 30px; line-height: 1.5; }
        .email-highlight { font-weight: bold; color: #333; }
        
        .otp-input-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        .otp-input {
            width: 50px;
            height: 60px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 24px;
            text-align: center;
            font-weight: bold;
            color: #4CAF50;
            transition: 0.3s;
        }
        .otp-input:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 10px rgba(76, 175, 80, 0.2);
        }
        
        .btn-verify {
            width: 100%;
            padding: 15px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-verify:hover { background: #45a049; transform: translateY(-2px); }
        .error-msg { color: #f44336; margin-top: 15px; font-size: 14px; }
        
        .resend-box { margin-top: 25px; font-size: 14px; color: #666; }
        .resend-link { color: #4CAF50; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <main>
        <div class="otp-container">
            <div class="otp-icon"><i class="fas fa-shield-halved"></i></div>
            <h2>Xác thực mã OTP</h2>
            <p class="desc">
                Chúng tôi vừa gửi mã xác nhận 6 số đến email:<br>
                <span class="email-highlight">${emailSent}</span>
            </p>

            <!-- Form xử lý xác nhận -->
            <form action="${pageContext.request.contextPath}/verify-otp" method="post" id="otpForm">
                <input type="hidden" name="email" value="${emailSent}">
                
                <div class="otp-input-group">
                    <input type="text" name="otp" maxlength="6" class="otp-input"
                           style="width: 200px;" placeholder="XXXXXX" required
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                </div>

                <c:if test="${not empty error}">
                    <p class="error-msg"><i class="fas fa-circle-exclamation"></i> ${error}</p>
                </c:if>

                <button type="submit" class="btn-verify">BẮT ĐẦU XÁC MINH</button>
            </form>

            <div class="resend-box">
                Bạn chưa nhận được mã? 
                <a href="${pageContext.request.contextPath}/forgot-password" class="resend-link">Gửi lại ngay</a>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />
</body>
</html>
