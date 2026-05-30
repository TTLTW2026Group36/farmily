<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu | Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DangNhap.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>


    <header class="login-header">
        <div class="header-container">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/" class="logo-link">
                    <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="Farmily Logo" class="brand-logo">
                </a>
                <span class="header-title">Đặt lại mật khẩu</span>
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
                    <h1>Đặt lại mật khẩu</h1>
                    <p style="color: #666; font-size: 14px; margin-top: 8px; line-height: 1.4;">Tạo mật khẩu mới cho tài khoản của bạn.</p>
                </div>


                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm" class="modern-form">
                    <input type="hidden" name="token" value="${token}">
                    
                    <div class="input-group">
                        <label style="font-weight: 600; font-size: 14px; margin-bottom: 8px; display: block; color: #555;">Mật khẩu mới <span style="color: red;">*</span></label>
                        <div class="password-wrapper">
                            <input type="password" name="newPassword" id="newPassword" placeholder="Nhập mật khẩu mới" required minlength="8">
                            <button type="button" class="toggle-password" onclick="togglePassword('newPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strengthBar"></div>
                        </div>

                        <ul class="requirements-list" id="requirements">
                            <li id="req-length" class="invalid">
                                <i class="fas fa-circle"></i> Ít nhất 8 ký tự
                            </li>
                            <li id="req-upper" class="invalid">
                                <i class="fas fa-circle"></i> Phải có chữ viết hoa
                            </li>
                            <li id="req-lower" class="invalid">
                                <i class="fas fa-circle"></i> Phải có chữ viết thường
                            </li>
                            <li id="req-number" class="invalid">
                                <i class="fas fa-circle"></i> Phải có chữ số
                            </li>
                            <li id="req-special" class="invalid">
                                <i class="fas fa-circle"></i> Phải có ký tự đặc biệt
                            </li>
                        </ul>
                    </div>

                    <div class="input-group">
                        <label style="font-weight: 600; font-size: 14px; margin-bottom: 8px; display: block; color: #555;">Xác nhận mật khẩu <span style="color: red;">*</span></label>
                        <div class="password-wrapper">
                            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-match" id="matchStatus"></div>
                    </div>

                    <button class="submit-btn submit" type="submit" id="submitBtn">ĐẶT LẠI MẬT KHẨU</button>

                    <a class="back-to-login" href="${pageContext.request.contextPath}/dang-nhap">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />

    <script>

        function togglePassword(inputId, btn) {
            const input = document.getElementById(inputId);
            const icon = btn.querySelector('i');

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }


        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const matchStatus = document.getElementById('matchStatus');

        newPassword.addEventListener('input', function () {
            const value = this.value;
            let strength = 0;

            const hasLength = value.length >= 8;
            const hasUpper = /[A-Z]/.test(value);
            const hasLower = /[a-z]/.test(value);
            const hasNumber = /[0-9]/.test(value);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(value);

            updateRequirement('req-length', hasLength);
            updateRequirement('req-upper', hasUpper);
            updateRequirement('req-lower', hasLower);
            updateRequirement('req-number', hasNumber);
            updateRequirement('req-special', hasSpecial);

            if (hasLength) strength++;
            if (hasUpper) strength++;
            if (hasLower) strength++;
            if (hasNumber) strength++;
            if (hasSpecial) strength++;

            strengthBar.className = 'password-strength-bar';
            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength <= 4) {
                strengthBar.classList.add('strength-medium');
            } else if (strength === 5) {
                strengthBar.classList.add('strength-strong');
            }

            checkMatch();
        });

        confirmPassword.addEventListener('input', checkMatch);

        function updateRequirement(id, isValid) {
            const el = document.getElementById(id);
            const icon = el.querySelector('i');

            if (isValid) {
                el.classList.remove('invalid');
                el.classList.add('valid');
                icon.classList.remove('fa-circle');
                icon.classList.add('fa-check-circle');
            } else {
                el.classList.remove('valid');
                el.classList.add('invalid');
                icon.classList.remove('fa-check-circle');
                icon.classList.add('fa-circle');
            }
        }

        function checkMatch() {
            const pass = newPassword.value;
            const confirm = confirmPassword.value;

            if (confirm.length === 0) {
                matchStatus.textContent = '';
                matchStatus.className = 'password-match';
                return;
            }

            if (pass === confirm) {
                matchStatus.textContent = '✓ Mật khẩu khớp';
                matchStatus.className = 'password-match match';
            } else {
                matchStatus.textContent = '✗ Mật khẩu không khớp';
                matchStatus.className = 'password-match no-match';
            }
        }


        document.getElementById('resetForm').addEventListener('submit', function (e) {
            const pass = newPassword.value;
            const confirm = confirmPassword.value;

            if (pass.length < 8) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 8 ký tự');
                return;
            }

            if (pass !== confirm) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp');
                return;
            }
        });
    </script>
</body>

</html>