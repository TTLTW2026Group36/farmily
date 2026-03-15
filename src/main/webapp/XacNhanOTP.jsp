<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Xác nhận mã OTP | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuenMatKhau.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .otp-container {
                    display: flex;
                    gap: 10px;
                    justify-content: center;
                    margin: 25px 0;
                }

                .otp-input {
                    width: 50px;
                    height: 60px;
                    text-align: center;
                    font-size: 24px;
                    font-weight: bold;
                    border: 2px solid #ddd;
                    border-radius: 10px;
                    transition: all 0.3s ease;
                }

                .otp-input:focus {
                    border-color: #4CAF50;
                    box-shadow: 0 0 10px rgba(76, 175, 80, 0.3);
                    outline: none;
                }

                .otp-input.filled {
                    border-color: #4CAF50;
                    background: #f0fff0;
                }

                .timer {
                    text-align: center;
                    color: #666;
                    margin: 15px 0;
                    font-size: 14px;
                }

                .timer strong {
                    color: #e53935;
                    font-size: 16px;
                }

                .resend-link {
                    color: #4CAF50;
                    cursor: pointer;
                    text-decoration: underline;
                }

                .resend-link:hover {
                    color: #388E3C;
                }

                .resend-link.disabled {
                    color: #999;
                    cursor: not-allowed;
                    text-decoration: none;
                }

                .otp-demo-box {
                    background: linear-gradient(135deg, #fff3e0, #ffe0b2);
                    border: 2px dashed #ff9800;
                    border-radius: 12px;
                    padding: 20px;
                    margin: 20px 0;
                    text-align: center;
                }

                .otp-demo-box .otp-code {
                    font-size: 32px;
                    font-weight: bold;
                    color: #e65100;
                    letter-spacing: 8px;
                    margin: 10px 0;
                }

                .otp-demo-box small {
                    color: #666;
                }

                .email-display {
                    background: #f5f5f5;
                    padding: 10px 15px;
                    border-radius: 8px;
                    margin: 10px 0;
                    font-weight: 500;
                }

                .email-display i {
                    color: #4CAF50;
                    margin-right: 8px;
                }

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

                .success-message {
                    background: #e8f5e9;
                    color: #2e7d32;
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin: 15px 0;
                    display: flex;
                    align-items: center;
                    gap: 10px;
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
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/forgot-password">
                                    Quên mật khẩu
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                Xác nhận OTP
                            </li>
                        </ol>
                    </div>
                </nav>

                <main>
                    <div class="forgot-container">
                        <h1><i class="fas fa-shield-alt"></i> XÁC NHẬN MÃ OTP</h1>
                        <p>Nhập mã OTP 6 chữ số đã được gửi đến email của bạn.</p>

                        <c:if test="${not empty email}">
                            <div class="email-display">
                                <i class="fas fa-envelope"></i>
                                ${email}
                            </div>
                        </c:if>

                        
                            <c:if test="${not empty otpDemo}">
                                <div class="otp-demo-box">
                                    <small><strong>DEMO OTP</strong> - Mã OTP của bạn:</small>
                                    <div class="otp-code">${otpDemo}</div>
                                </div>
                            </c:if>

                            <c:if test="${not empty error}">
                                <div class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <c:if test="${not empty success}">
                                <div class="success-message">
                                    <i class="fas fa-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/verify-otp" method="post" id="otpForm">
                                <div class="otp-container">
                                    <input type="text" class="otp-input" name="otp1" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" autofocus>
                                    <input type="text" class="otp-input" name="otp2" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric">
                                    <input type="text" class="otp-input" name="otp3" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric">
                                    <input type="text" class="otp-input" name="otp4" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric">
                                    <input type="text" class="otp-input" name="otp5" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric">
                                    <input type="text" class="otp-input" name="otp6" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric">
                                </div>

                                <div class="timer">
                                    <span id="timerText">Mã OTP có hiệu lực trong <strong
                                            id="countdown">15:00</strong></span>
                                </div>

                                <button class="submit" type="submit">
                                    <i class="fas fa-check"></i> Xác nhận
                                </button>

                                <div style="text-align: center; margin-top: 20px;">
                                    <span>Không nhận được mã? </span>
                                    <a href="${pageContext.request.contextPath}/forgot-password" class="resend-link"
                                        id="resendLink">
                                        Gửi lại mã OTP
                                    </a>
                                </div>

                                <a class="back" href="${pageContext.request.contextPath}/DangNhap.jsp">
                                    <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                                </a>
                            </form>
                    </div>
                </main>

                
                    <jsp:include page="common/footer.jsp" />

                    <script>
                        // OTP Input Auto-focus
                        const otpInputs = document.querySelectorAll('.otp-input');

                        otpInputs.forEach((input, index) => {
                            input.addEventListener('input', (e) => {
                                const value = e.target.value;

                                // Only allow numbers
                                e.target.value = value.replace(/[^0-9]/g, '');

                                if (value && index < otpInputs.length - 1) {
                                    otpInputs[index + 1].focus();
                                }

                                // Add filled class
                                if (value) {
                                    input.classList.add('filled');
                                } else {
                                    input.classList.remove('filled');
                                }
                            });

                            input.addEventListener('keydown', (e) => {
                                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                                    otpInputs[index - 1].focus();
                                }
                            });

                            // Handle paste
                            input.addEventListener('paste', (e) => {
                                e.preventDefault();
                                const pastedData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');

                                if (pastedData.length === 6) {
                                    otpInputs.forEach((inp, i) => {
                                        inp.value = pastedData[i] || '';
                                        if (inp.value) inp.classList.add('filled');
                                    });
                                    otpInputs[5].focus();
                                }
                            });
                        });

                        // Countdown timer (15 minutes)
                        let timeLeft = 15 * 60; // 15 minutes in seconds
                        const countdownEl = document.getElementById('countdown');

                        const timer = setInterval(() => {
                            timeLeft--;

                            const minutes = Math.floor(timeLeft / 60);
                            const seconds = timeLeft % 60;

                            countdownEl.textContent =
                                String(minutes).padStart(2, '0') + ':' +
                                String(seconds).padStart(2, '0');

                            if (timeLeft <= 60) {
                                countdownEl.style.color = '#e53935';
                            }

                            if (timeLeft <= 0) {
                                clearInterval(timer);
                                countdownEl.textContent = 'Đã hết hạn';
                                countdownEl.style.color = '#999';
                            }
                        }, 1000);
                    </script>
        </body>

        </html>