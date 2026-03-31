<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Giới Thiệu</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GioiThieu.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
                            Giới thiệu
                        </li>
                    </ol>
                </div>
            </nav>
            <main class="about-page-wrapper">

                <section class="about-hero">
                    <div class="about-hero-content">
                        <h1>Chào mừng đến với Farmily</h1>
                        <p style="font-size:22px;">Farm Farmily - Yêu thương từ mầm xanh, ấm áp bữa cơm nhà.</p>
                        <a href="#about-intro" class="about-btn">Khám phá ngay</a>
                    </div>
                </section>


                <section id="about-intro" class="about-intro about-container">
                    <h2>Về Farmily</h2>
                    <p>Farmily được thành lập với sứ mệnh kết nối người tiêu dùng với những nông sản sạch, an
                        toàn
                        từ các nông
                        trại đạt chuẩn VietGAP và GlobalG.A.P. Chúng tôi tin rằng, một bữa ăn ngon bắt đầu từ
                        nguyên
                        liệu sạch.
                    </p>
                    <p>Chúng tôi không chỉ bán rau củ, chúng tôi trao gửi sự an tâm và sức khỏe cho mỗi gia đình
                        Việt.</p>
                </section>


                <section class="about-values">
                    <div class="about-container">
                        <div class="values-grid">
                            <div class="value-card">
                                <div class="value-icon"><i class="fa-solid fa-leaf"></i></div>
                                <h3>Tươi Ngon</h3>
                                <p>Thu hoạch và giao hàng trong vòng 24h để đảm bảo độ tươi mới nhất.</p>
                            </div>
                            <div class="value-card">
                                <div class="value-icon"><i class="fa-solid fa-shield-halved"></i></div>
                                <h3>An Toàn</h3>
                                <p>Quy trình kiểm định nghiêm ngặt, không dư lượng thuốc bảo vệ thực vật.</p>
                            </div>
                            <div class="value-card">
                                <div class="value-icon"><i class="fa-solid fa-hand-holding-heart"></i></div>
                                <h3>Tận Tâm</h3>
                                <p>Dịch vụ chăm sóc khách hàng chu đáo, hỗ trợ đổi trả 1:1.</p>
                            </div>
                            <div class="value-card">
                                <div class="value-icon"><i class="fa-solid fa-truck-fast"></i></div>
                                <h3>Tiện Lợi</h3>
                                <p>Giao hàng tận nơi, nhanh chóng và đúng hẹn.</p>
                            </div>
                        </div>
                    </div>
                </section>


                <section class="about-journey about-container">
                    <div class="about-intro">
                        <h2>Hành Trình Phát Triển</h2>
                    </div>
                    <div class="journey-timeline">
                        <div class="journey-item">
                            <div class="journey-year">2018</div>
                            <div class="journey-content">
                                <h3>Khởi Nguồn</h3>
                                <p>Bắt đầu từ một nông trại nhỏ tại Đà Lạt với niềm đam mê nông nghiệp sạch.</p>
                            </div>
                        </div>
                        <div class="journey-item">
                            <div class="journey-year">2020</div>
                            <div class="journey-content">
                                <h3>Mở Rộng</h3>
                                <p>Hợp tác với hơn 50 hộ nông dân, mở rộng vùng trồng lên 20ha.</p>
                            </div>
                        </div>
                        <div class="journey-item">
                            <div class="journey-year">2022</div>
                            <div class="journey-content">
                                <h3>Công Nghệ</h3>
                                <p>Áp dụng công nghệ truy xuất nguồn gốc QR Code cho 100% sản phẩm.</p>
                            </div>
                        </div>
                        <div class="journey-item">
                            <div class="journey-year">Nay</div>
                            <div class="journey-content">
                                <h3>Vươn Xa</h3>
                                <p>Phục vụ hàng ngàn bữa ăn ngon cho các gia đình tại TP.HCM và các vùng lân
                                    cận.
                                </p>
                            </div>
                        </div>
                    </div>
                </section>




                <section class="about-process about-container">
                    <h2>Quy Trình Từ Nông Trại Đến Bàn Ăn</h2>
                    <div class="process-steps">
                        <div class="process-step">
                            <div class="process-icon"><i class="fa-solid fa-seedling"></i></div>
                            <h3>Gieo Trồng</h3>
                            <p>Chọn giống tốt, canh tác theo chuẩn VietGAP.</p>
                        </div>
                        <div class="process-step">
                            <div class="process-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                            <h3>Kiểm Tra</h3>
                            <p>Kiểm định chất lượng trước khi thu hoạch.</p>
                        </div>
                        <div class="process-step">
                            <div class="process-icon"><i class="fa-solid fa-box-open"></i></div>
                            <h3>Đóng Gói</h3>
                            <p>Sơ chế và đóng gói trong môi trường lạnh.</p>
                        </div>
                        <div class="process-step">
                            <div class="process-icon"><i class="fa-solid fa-motorcycle"></i></div>
                            <h3>Giao Hàng</h3>
                            <p>Vận chuyển nhanh chóng đến tay khách hàng.</p>
                        </div>
                    </div>
                </section>


                <section class="about-testimonials">
                    <div class="about-container">
                        <h2>Khách Hàng Nói Gì Về Farmily?</h2>
                        <div class="testimonial-grid">
                            <div class="testimonial-card">
                                <p class="testimonial-text">"Rau củ rất tươi, đóng gói cẩn thận. Tôi rất yên tâm
                                    khi
                                    mua hàng
                                    tại Farmily cho bữa ăn của con nhỏ."</p>
                                <p class="testimonial-author">- Chị Mai, Quận 7</p>
                            </div>
                            <div class="testimonial-card">
                                <p class="testimonial-text">"Dịch vụ giao hàng nhanh, nhân viên thân thiện. Sản
                                    phẩm
                                    đúng như mô
                                    tả, sẽ ủng hộ dài dài."</p>
                                <p class="testimonial-author">- Anh Long, Quận 9</p>
                            </div>
                            <div class="testimonial-card">
                                <p class="testimonial-text">"Thích nhất là sự minh bạch về nguồn gốc. Quét mã QR
                                    là
                                    biết ngay
                                    rau trồng ở đâu, ngày nào."</p>
                                <p class="testimonial-author">- Cô Lan, Thủ Đức</p>
                            </div>
                        </div>
                    </div>
                </section>


                <section class="about-cta">
                    <div class="about-container">
                        <h2>Bạn Đã Sẵn Sàng Cho Bữa Ăn Tươi Ngon?</h2>
                        <p>Đặt hàng ngay hôm nay để nhận ưu đãi đặc biệt cho khách hàng mới!</p>
                        <a href="${pageContext.request.contextPath}/sanpham" class="about-btn">Mua Sắm
                            Ngay</a>
                    </div>
                </section>
            </main>



            <jsp:include page="common/footer.jsp" />
            <script src="${pageContext.request.contextPath}/js/GioiThieu.js"></script>

        </body>

        </html>