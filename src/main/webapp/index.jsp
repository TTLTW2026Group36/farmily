<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Farmily - Rau Củ Quả Tươi Sạch Giao Tận Nhà 24h</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
                <script>
                    window.contextPath = '${pageContext.request.contextPath}';
                </script>
            </head>

            <body>
                <c:if test="${not empty sessionScope.registerSuccess}">
                    <div id="successPopup"
                        style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);display:flex;justify-content:center;align-items:center;z-index:9999;">
                        <div
                            style="background:white;padding:40px 60px;border-radius:16px;text-align:center;box-shadow:0 10px 40px rgba(0,0,0,0.3);max-width:400px;">
                            <i class="fas fa-check-circle" style="font-size:60px;color:#4CAF50;margin-bottom:20px;"></i>
                            <h2 style="color:#2e7d32;margin-bottom:10px;">Đăng ký thành công!</h2>
                            <p style="color:#666;margin-bottom:20px;">${sessionScope.registerSuccess}</p>
                            <p style="color:#888;font-size:14px;">Chào mừng <strong>${sessionScope.auth.name}</strong>
                                đến với Farmily!</p>
                            <button onclick="this.parentElement.parentElement.style.display='none'"
                                style="background:linear-gradient(135deg,#4CAF50,#45a049);color:white;border:none;padding:12px 40px;border-radius:25px;font-size:16px;cursor:pointer;margin-top:20px;">Bắt
                                đầu mua sắm</button>
                        </div>
                    </div>
                    <c:remove var="registerSuccess" scope="session" />
                </c:if>


                <jsp:include page="common/header.jsp" />


                <section class="main-slider">
                    <div class="slider-container">
                        <div class="slider-wrapper">
                            <div class="slide active">
                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg" alt="Rau củ quả tươi sạch">
                                <div class="slide-content">
                                    <h2>Rau Củ Quả Tươi Sạch</h2>
                                    <p>Giao hàng nhanh chóng trong 24h</p>
                                    <a href="${pageContext.request.contextPath}/san-pham" class="btn-slider">Mua
                                        ngay</a>
                                </div>
                            </div>
                            <div class="slide">
                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg" alt="Ưu đãi hấp dẫn">
                                <div class="slide-content">
                                    <h2>Ưu Đãi Đặc Biệt</h2>
                                    <p>Giảm giá lên đến 30% cho đơn hàng đầu tiên</p>
                                    <a href="${pageContext.request.contextPath}/san-pham" class="btn-slider">Khám phá
                                        ngay</a>
                                </div>
                            </div>
                            <div class="slide">
                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg" alt="An toàn vệ sinh">
                                <div class="slide-content">
                                    <h2>100% An Toàn Vệ Sinh</h2>
                                    <p>Cam kết chất lượng, nguồn gốc rõ ràng</p>
                                    <a href="${pageContext.request.contextPath}/GioiThieu.jsp" class="btn-slider">Tìm
                                        hiểu
                                        thêm</a>
                                </div>
                            </div>
                        </div>
                        <button class="slider-btn prev"><i class="fas fa-chevron-left"></i></button>
                        <button class="slider-btn next"><i class="fas fa-chevron-right"></i></button>
                        <div class="slider-dots"></div>
                    </div>
                </section>


                <section class="quick-categories">
                    <div class="container">
                        <div class="section-header">
                            <h2 class="section-title"><i class="fa-solid fa-bars"></i> DANH MỤC SẢN PHẨM</h2>
                            <a href="${pageContext.request.contextPath}/san-pham" class="view-all">Khám phá tất cả <i
                                    class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="categories-scroll">
                            <c:forEach items="${categories}" var="cat">
                                <a href="${pageContext.request.contextPath}/san-pham?categoryId=${cat.id}"
                                    class="quick-cat-item">
                                    <span>${cat.name}</span>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </section>


                <jsp:include page="common/flash-sale-section.jsp" />


                <section class="products-section">
                    <div class="container">
                        <div class="section-header">
                            <h2 class="section-title"><i class="fas fa-fire"></i> SẢN PHẨM BÁN CHẠY</h2>
                            <a href="${pageContext.request.contextPath}/san-pham?sort=popular" class="view-all">Xem tất
                                cả <i class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="products-grid" id="hot-products">
                            <c:forEach items="${bestSellers}" var="product">
                                <div class="product-card" data-category-id="${product.categoryId}">
                                    <div class="product-badges">
                                        <span class="badge badge-hot">HOT</span>
                                    </div>
                                    <button class="wishlist-btn" aria-label="Yêu thích"><i
                                            class="far fa-heart"></i></button>
                                    <div class="product-image">
                                        <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty product.images and not empty product.images[0]}">
                                                    <img src="${product.images[0].imageUrl}" alt="${product.name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                        alt="${product.name}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-title">
                                            <a
                                                href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">${product.name}</a>
                                        </h3>
                                        <p class="product-price">
                                            <span class="price-current">
                                                <fmt:formatNumber value="${product.minPrice}" type="number"
                                                    groupingUsed="true" />đ
                                            </span>
                                            <c:if test="${not empty product.minPriceVariant}">
                                                <span class="price-unit">/${product.minPriceVariant.optionsValue}</span>
                                            </c:if>
                                        </p>
                                        <button class="add-to-cart-btn"
                                            onclick="addToCart(${product.id}, ${not empty product.minPriceVariant ? product.minPriceVariant.id : 0})">
                                            <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="load-more-wrapper">
                            <a href="${pageContext.request.contextPath}/san-pham?sort=popular" class="btn-load-more">Xem
                                thêm sản phẩm <i class="fas fa-chevron-down"></i></a>
                        </div>
                    </div>
                </section>


                <section class="banner-grid-section">
                    <div class="container">
                        <div class="banner-grid">
                            <a href="${pageContext.request.contextPath}/san-pham?categoryId=1"
                                class="banner-item large">
                                <img src="https://lh3.googleusercontent.com/gg/AMW1TPqgmTfYmazEGc61H0OyP1bjmmcPkwaT4cH6vWOl5JlcQtf5qj4SYpaBJeASdkt8Y6v0xMXKmM2gWBzR-zWW4gf9Ec7ApH8YkoE6OREFdAEz_TOVTw3oivkH0wvpQ-OGKoSjwAE4KLp7hircm7XV9QadFspMjg2qfYUCeQZ2Eq55mmj-XoTA=s1024-rj-mp2"
                                    alt="Rau hữu cơ">
                                <div class="banner-content">
                                    <h3>RAU HỮU CƠ</h3>
                                    <p>An toàn - Tươi ngon</p>
                                    <span class="banner-btn">Mua ngay</span>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham?categoryId=2" class="banner-item">
                                <img src="https://lh3.googleusercontent.com/gg/AMW1TPoRm95lDbx1OVIfC_K1C1TVs9wjQQ5zVgzDc-U5RGej7sAEgNNaOz0Z6IFnT-wiJVCRcVLdUD4a7f4GHyudueKs7jBCgV7UJip06k356__2yPT3Qmzaz0q7x1GsIRbs0JsMyR2pHCRwP96gcrr7hSECqY-6QdmDBm-zEOiZY-yPKr4GeaZD=s1024-rj-mp2"
                                    alt="Trái cây nhập khẩu">
                                <div class="banner-content">
                                    <h3>TRÁI CÂY NHẬP KHẨU</h3>
                                    <p>Giảm 20%</p>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham?categoryId=3" class="banner-item">
                                <img src="https://lh3.googleusercontent.com/gg/AMW1TPpDoDdWrOsDOAjLRNQpRtBZHngc6v2Z0_gkqpn9zu7j6OCh0uAdxBPkCRRAe3suGUoboDLO-HL1NAv9GdSLVagSu36dPvHY_OgrHsJNjGYFKvk8l72dX0pueUHdkYKEOqFGfTAnk1I_54sSWIO2CDPLnyWJvz5OpuQQ6kAb0ju6coCG1GmG=s1024-rj-mp2"
                                    alt="Củ quả">
                                <div class="banner-content">
                                    <h3>CỦ QUẢ</h3>
                                    <p>Cam kết chất lượng</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </section>


                <section class="products-section">
                    <div class="container">
                        <div class="section-header">
                            <h2 class="section-title"><i class="fas fa-sparkles"></i> SẢN PHẨM MỚI</h2>
                            <a href="${pageContext.request.contextPath}/san-pham?sort=newest" class="view-all">Xem tất
                                cả <i class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="products-grid" id="new-products">
                            <c:forEach items="${newProducts}" var="product">
                                <div class="product-card" data-category-id="${product.categoryId}">
                                    <div class="product-badges">
                                        <span class="badge badge-new">MỚI</span>
                                    </div>
                                    <button class="wishlist-btn" aria-label="Yêu thích"><i
                                            class="far fa-heart"></i></button>
                                    <div class="product-image">
                                        <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty product.images and not empty product.images[0]}">
                                                    <img src="${product.images[0].imageUrl}" alt="${product.name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                        alt="${product.name}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <div class="product-info">
                                        <h3 class="product-title">
                                            <a
                                                href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">${product.name}</a>
                                        </h3>
                                        <p class="product-price">
                                            <span class="price-current">
                                                <fmt:formatNumber value="${product.minPrice}" type="number"
                                                    groupingUsed="true" />đ
                                            </span>
                                            <c:if test="${not empty product.minPriceVariant}">
                                                <span class="price-unit">/${product.minPriceVariant.optionsValue}</span>
                                            </c:if>
                                        </p>
                                        <button class="add-to-cart-btn"
                                            onclick="addToCart(${product.id}, ${not empty product.minPriceVariant ? product.minPriceVariant.id : 0})">
                                            <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="load-more-wrapper">
                            <a href="${pageContext.request.contextPath}/san-pham?sort=newest" class="btn-load-more">Xem
                                thêm sản phẩm <i class="fas fa-chevron-down"></i></a>
                        </div>
                    </div>
                </section>


                <section class="blog-section">
                    <div class="container">
                        <div class="section-header">
                            <h2 class="section-title"><i class="fas fa-newspaper"></i> TIN TỨC & KIẾN THỨC</h2>
                            <a href="${pageContext.request.contextPath}/tin-tuc" class="view-all">Xem tất cả <i
                                    class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="blog-grid">
                            <c:choose>
                                <c:when test="${not empty recentNews}">
                                    <c:forEach items="${recentNews}" var="news">
                                        <article class="blog-card-new"
                                            onclick="window.location.href='${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${news.id}'"
                                            style="cursor: pointer;">
                                            <div class="blog-thumb">
                                                <c:choose>
                                                    <c:when test="${not empty news.imageUrl}">
                                                        <img src="${news.imageUrl}" alt="${news.title}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                            alt="${news.title}">
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty news.category}">
                                                    <span class="blog-cat">${news.category.name}</span>
                                                </c:if>
                                            </div>
                                            <div class="blog-info">
                                                <div class="blog-meta">
                                                    <span><i class="far fa-calendar"></i>
                                                        <fmt:formatDate value="${news.createdAt}"
                                                            pattern="dd/MM/yyyy" />
                                                    </span>
                                                    <span><i class="far fa-eye"></i> ${news.viewCount} lượt xem</span>
                                                </div>
                                                <h3><a
                                                        href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${news.id}">${news.title}</a>
                                                </h3>
                                                <p>${news.excerpt}</p>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <article class="blog-card-new" style="cursor: pointer;">
                                        <div class="blog-thumb">
                                            <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                alt="Bảo quản rau củ">
                                            <span class="blog-cat">Mẹo Vặt</span>
                                        </div>
                                        <div class="blog-info">
                                            <div class="blog-meta">
                                                <span><i class="far fa-calendar"></i> 22/10/2025</span>
                                                <span><i class="far fa-eye"></i> 1.2K lượt xem</span>
                                            </div>
                                            <h3>10 cách bảo quản rau củ tươi lâu trong tủ lạnh</h3>
                                            <p>Khám phá những mẹo hay giúp rau củ giữ được độ tươi ngon và dinh dưỡng...
                                            </p>
                                        </div>
                                    </article>
                                    <article class="blog-card-new" style="cursor: pointer;">
                                        <div class="blog-thumb">
                                            <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                alt="Lợi ích rau hữu cơ">
                                            <span class="blog-cat">Sức Khỏe</span>
                                        </div>
                                        <div class="blog-info">
                                            <div class="blog-meta">
                                                <span><i class="far fa-calendar"></i> 14/10/2025</span>
                                                <span><i class="far fa-eye"></i> 856 lượt xem</span>
                                            </div>
                                            <h3>Lợi ích tuyệt vời của rau hữu cơ cho sức khỏe</h3>
                                            <p>Tại sao nên chọn rau hữu cơ cho bữa ăn gia đình của bạn...</p>
                                        </div>
                                    </article>
                                    <article class="blog-card-new" style="cursor: pointer;">
                                        <div class="blog-thumb">
                                            <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                alt="Công thức nấu ăn">
                                            <span class="blog-cat">Công Thức</span>
                                        </div>
                                        <div class="blog-info">
                                            <div class="blog-meta">
                                                <span><i class="far fa-calendar"></i> 13/10/2025</span>
                                                <span><i class="far fa-eye"></i> 2.1K lượt xem</span>
                                            </div>
                                            <h3>5 món ăn ngon từ rau củ cho bữa tối</h3>
                                            <p>Cùng khám phá những công thức nấu ăn đơn giản, bổ dưỡng từ rau củ...</p>
                                        </div>
                                    </article>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </section>


                <jsp:include page="common/footer.jsp" />

                <script src="${pageContext.request.contextPath}/js/index.js?v=1.1"></script>

            </body>

            </html>