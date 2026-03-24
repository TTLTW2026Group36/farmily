<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <footer class="footer">
            <div class="footer-top">
                <div class="container">
                    <div class="grid">

                        <section class="footer-col">
                            <h4 class="title">Về chúng tôi</h4>

                            <a href="${pageContext.request.contextPath}/" class="logo-footer">
                                <img src="https://i.postimg.cc/zBz59B8m/logo-backpng.png" alt="logo Farmily"
                                    class="logo-footer">
                            </a>

                            <p>Farmily, giới thiệu đến bạn sản phẩm đa dạng, tươi sạch.</p>

                            <div class="contact-item">
                                <i class="fa fa-map-marker-alt" aria-hidden="true"></i>
                                <div class="content">
                                    <div class="label">Địa chỉ:</div>
                                    <span>Trường Đại Học Nông Lâm Thành Phố Hồ Chí Minh<br>
                                        Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</span>
                                </div>
                            </div>

                            <div class="contact-item">
                                <i class="fa fa-mobile-alt" aria-hidden="true"></i>
                                <div class="content">
                                    <div class="label">Số điện thoại:</div>
                                    <a class="link" href="tel:0378827924" title="0378827924">0378827924</a>
                                </div>
                            </div>

                            <div class="contact-item">
                                <i class="fa fa-envelope" aria-hidden="true"></i>
                                <div class="content">
                                    <div class="label">Email:</div>
                                    <a class="link" href="mailto:Farmily@gmail.com"
                                        title="Farmily@gmail.com">Farmily@gmail.com</a>
                                </div>
                            </div>
                        </section>


                        <nav class="footer-col">
                            <h4 class="title">Chính sách</h4>
                            <ul class="list">
                                <li><a class="link" href="${pageContext.request.contextPath}/huong-dan-mua-hang"
                                        title="Hướng dẫn mua hàng">Hướng dẫn mua
                                        hàng</a></li>
                                <li><a class="link" href="${pageContext.request.contextPath}/huong-dan-mua-hang"
                                        title="Hướng dẫn thanh toán">Hướng dẫn thanh
                                        toán</a>
                                </li>
                                <li><a class="link" href="${pageContext.request.contextPath}/huong-dan-mua-hang"
                                        title="Hướng dẫn giao nhận">Hướng dẫn giao
                                        nhận</a>
                                </li>
                                <li><a class="link" href="${pageContext.request.contextPath}/dieu-khoan-dich-vu"
                                        title="Điều khoản dịch vụ">Điều khoản dịch
                                        vụ</a>
                                </li>
                                <li><a class="link" href="${pageContext.request.contextPath}/chinh-sach-hoan-tra"
                                        title="Chính sách nhận và hoàn trả hàng hóa">Chính sách nhận và hoàn trả hàng
                                        hóa</a></li>
                            </ul>
                        </nav>


                        <nav class="footer-col">
                            <h4 class="title">Hỗ trợ khách hàng</h4>
                            <ul class="list">
                                <li><a class="link" href="#" title="Tìm kiếm">Tìm kiếm</a></li>


                                <c:choose>

                                    <c:when test="${not empty sessionScope.auth}">
                                        <li><a class="link" href="${pageContext.request.contextPath}/ho-so"
                                                title="Hồ sơ">Hồ sơ của tôi</a></li>
                                        <li><a class="link" href="${pageContext.request.contextPath}/ho-so/don-hang"
                                                title="Đơn hàng">Đơn hàng</a></li>
                                        <li><a class="link" href="${pageContext.request.contextPath}/logout"
                                                title="Đăng xuất">Đăng xuất</a></li>
                                    </c:when>


                                    <c:otherwise>
                                        <li><a class="link" href="${pageContext.request.contextPath}/dang-nhap"
                                                title="Đăng nhập">Đăng nhập</a></li>
                                        <li><a class="link" href="${pageContext.request.contextPath}/register"
                                                title="Đăng ký">Đăng ký</a></li>
                                    </c:otherwise>
                                </c:choose>


                                <li><a class="link" href="${pageContext.request.contextPath}/gio-hang"
                                        title="Giỏ hàng">Giỏ hàng</a></li>
                            </ul>
                        </nav>


                        <section class="footer-col">
                            <div class="social-footer">
                                <h4 class="title">Theo dõi chúng tôi</h4>
                                <ul class="social">
                                    <li><a class="facebook link" href="https://www.facebook.com/nongsanfarmily.site/"
                                            title="Facebook"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a class="twitter link" href="#" title="Tiktok"><i
                                                class="fab fa-tiktok"></i></a>
                                    </li>
                                    <li><a class="instgram link" href="#" title="Instagram"><i
                                                class="fab fa-instagram"></i></a>
                                    </li>
                                </ul>
                            </div>

                            <div class="newsletter">
                                <h4 class="title">Đăng ký nhận tin</h4>
                                <form id="mc-form" class="newsletter-form" data-toggle="validator">
                                    <input class="input" type="email" name="EMAIL" placeholder="Nhập địa chỉ email"
                                        aria-label="Địa chỉ Email" required autocomplete="off">
                                    <button class="btn" type="submit" name="subscribe"
                                        aria-label="Đăng ký nhận tin">Đăng
                                        ký</button>
                                </form>
                                <div class="newsletter-success" id="newsletter-success" style="display: none;">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Đã đăng ký nhận tin thành công!</span>
                                </div>
                            </div>

                            <style>
                                .newsletter-success {
                                    display: flex;
                                    align-items: center;
                                    gap: 10px;
                                    background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
                                    color: #2e7d32;
                                    padding: 12px 16px;
                                    border-radius: 8px;
                                    margin-top: 12px;
                                    font-weight: 500;
                                    animation: fadeInUp 0.4s ease;
                                    border: 1px solid #a5d6a7;
                                }

                                .newsletter-success i {
                                    font-size: 18px;
                                    color: #43a047;
                                }

                                @keyframes fadeInUp {
                                    from {
                                        opacity: 0;
                                        transform: translateY(10px);
                                    }

                                    to {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }
                                }
                            </style>

                            <script>
                                document.addEventListener('DOMContentLoaded', function () {
                                    const newsletterForm = document.getElementById('mc-form');
                                    const newsletterSuccess = document.getElementById('newsletter-success');

                                    if (newsletterForm) {
                                        newsletterForm.addEventListener('submit', function (e) {
                                            e.preventDefault();

                                            const emailInput = this.querySelector('input[name="EMAIL"]');
                                            const email = emailInput.value.trim();

                                            if (email && validateEmail(email)) {
                                                newsletterForm.style.display = 'none';
                                                newsletterSuccess.style.display = 'flex';

                                                localStorage.setItem('newsletter_subscribed', 'true');
                                                localStorage.setItem('newsletter_email', email);
                                            }
                                        });
                                    }

                                    if (localStorage.getItem('newsletter_subscribed') === 'true') {
                                        if (newsletterForm) newsletterForm.style.display = 'none';
                                        if (newsletterSuccess) newsletterSuccess.style.display = 'flex';
                                    }

                                    function validateEmail(email) {
                                        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                        return re.test(email);
                                    }
                                });
                            </script>
                        </section>
                    </div>
                </div>
            </div>
        </footer>