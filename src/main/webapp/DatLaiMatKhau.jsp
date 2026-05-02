<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt lại mật khẩu | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuenMatKhau.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .password-wrapper {
                    position: relative;
                    margin-bottom: 15px;
                }

                .password-wrapper input {
                    padding-right: 45px;
                }

                .toggle-password {
                    position: absolute;
                    right: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    background: none;
                    border: none;
                    cursor: pointer;
                    color: #666;
                    font-size: 18px;
                    padding: 5px;
                }

                .toggle-password:hover {
                    color: #4CAF50;
                }

                .password-strength {
                    height: 4px;
                    background: #eee;
                    border-radius: 2px;
                    margin-top: 8px;
                    overflow: hidden;
                }

                .password-strength-bar {
                    height: 100%;
                    width: 0;
                    transition: all 0.3s ease;
                    border-radius: 2px;
                }

                .strength-weak {
                    background: #f44336;
                    width: 33%;
                }

                .strength-medium {
                    background: #ff9800;
                    width: 66%;
                }

                .strength-strong {
                    background: #4CAF50;
                    width: 100%;
                }

                .password-hint {
                    font-size: 12px;
                    color: #666;
                    margin-top: 8px;
                }

                .password-hint.error {
                    color: #f44336;
                }

                .password-hint.success {
                    color: #4CAF50;
                }

                .password-match {
                    font-size: 12px;
                    margin-top: 5px;
                }

                .password-match.match {
                    color: #4CAF50;
                }

                .password-match.no-match {
                    color: #f44336;
                }

                .success-icon {
                    font-size: 60px;
                    color: #4CAF50;
                    margin-bottom: 20px;
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

                .requirements-list {
                    list-style: none;
                    padding: 0;
                    margin: 15px 0;
                    font-size: 13px;
                }

                .requirements-list li {
                    padding: 5px 0;
                    color: #666;
                }

                .requirements-list li i {
                    margin-right: 8px;
                    width: 16px;
                }

                .requirements-list li.valid {
                    color: #4CAF50;
                }

                .requirements-list li.invalid {
                    color: #999;
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
                                Đặt lại mật khẩu
                            </li>
                        </ol>
                    </div>
                </nav>

                <main>
                    <div class="forgot-container">
                        <h1><i class="fas fa-key"></i> ĐẶT LẠI MẬT KHẨU</h1>
                        <p>Tạo mật khẩu mới cho tài khoản của bạn.</p>

                        <c:if test="${not empty error}">
                            <div class="error-message">
                                <i class="fas fa-exclamation-circle"></i>
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/reset-password" method="post" id="resetForm">
                            <input type="hidden" name="token" value="${token}">
                            <label>Mật khẩu mới <span>*</span></label>
                            <div class="password-wrapper">
                                <input type="password" name="newPassword" id="newPassword"
                                    placeholder="Nhập mật khẩu mới" required minlength="6">
                                <button type="button" class="toggle-password"
                                    onclick="togglePassword('newPassword', this)">
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
                                <li id="req-letter" class="invalid">
                                    <i class="fas fa-circle"></i> Chứa chữ cái
                                </li>
                                <li id="req-number" class="invalid">
                                    <i class="fas fa-circle"></i> Chứa số
                                </li>
                            </ul>

                            <label>Xác nhận mật khẩu <span>*</span></label>
                            <div class="password-wrapper">
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                    placeholder="Nhập lại mật khẩu mới" required>
                                <button type="button" class="toggle-password"
                                    onclick="togglePassword('confirmPassword', this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="password-match" id="matchStatus"></div>

                            <button class="submit" type="submit" id="submitBtn">
                                <i class="fas fa-save"></i> Đặt lại mật khẩu
                            </button>

                            <a class="back" href="${pageContext.request.contextPath}/DangNhap.jsp">
                                <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                            </a>
                        </form>
                    </div>
                </main>

                
                    <jsp:include page="common/footer.jsp" />

                    <script>
                        // Toggle password visibility
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

                        // Password strength checker
                        const newPassword = document.getElementById('newPassword');
                        const confirmPassword = document.getElementById('confirmPassword');
                        const strengthBar = document.getElementById('strengthBar');
                        const matchStatus = document.getElementById('matchStatus');

                        newPassword.addEventListener('input', function () {
                            const value = this.value;
                            let strength = 0;

                            // Check requirements
                            const hasLength = value.length >= 6;
                            const hasLetter = /[a-zA-Z]/.test(value);
                            const hasNumber = /[0-9]/.test(value);

                            // Update requirements UI
                            updateRequirement('req-length', hasLength);
                            updateRequirement('req-letter', hasLetter);
                            updateRequirement('req-number', hasNumber);

                            // Calculate strength
                            if (hasLength) strength++;
                            if (hasLetter && hasNumber) strength++;
                            if (value.length >= 8 && /[!@#$%^&*]/.test(value)) strength++;

                            // Update strength bar
                            strengthBar.className = 'password-strength-bar';
                            if (strength === 1) {
                                strengthBar.classList.add('strength-weak');
                            } else if (strength === 2) {
                                strengthBar.classList.add('strength-medium');
                            } else if (strength >= 3) {
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

                        // Form validation
                        document.getElementById('resetForm').addEventListener('submit', function (e) {
                            const pass = newPassword.value;
                            const confirm = confirmPassword.value;

                            if (pass.length < 6) {
                                e.preventDefault();
                                alert('Mật khẩu phải có ít nhất 6 ký tự');
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