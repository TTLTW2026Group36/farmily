<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giá tốt mỗi ngày - Farmily</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SanPham.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GiaTot.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
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
                                Giá Tốt
                            </li>
                        </ol>
                    </div>
                </nav>

                <div class="main-content">
                    <div class="GT-container">
                        <div class="page-header-toolbar">
                            <div class="header-section">
                                <div class="title-wrap">
                                    <div class="title-content">
                                        <h1 class="products-page-title">
                                            <i class="fas fa-bolt" style="color: #ff6b35;"></i>
                                            Giá Tốt Hôm Nay
                                            <c:if test="${not empty flashSales}">
                                                <span style="font-size: 0.5em; color: #666;">(${flashSales.size()}
                                                    sản phẩm)</span>
                                            </c:if>
                                        </h1>
                                    </div>

                                    <c:if test="${not empty flashSaleEndTime}">
                                        <div class="countdown"
                                            style="margin-left: 20px; background: linear-gradient(135deg, #ff6b35, #f7931e); padding: 8px 16px; border-radius: 8px; display: flex; align-items: center; gap: 10px;">
                                            <span class="countdown-label" style="color: white; font-weight: 600;">Kết
                                                thúc trong:</span>
                                            <div class="countdown-timer" id="flashCountdown"
                                                data-end-time="${flashSaleEndTime}">
                                                <div class="time-box"
                                                    style=" padding: 6px 10px; border-radius: 6px; text-align: center; min-width: 45px;">
                                                    <span id="gt-hours">00</span>
                                                    <small>Giờ</small>
                                                </div>
                                                <span class="separator"
                                                    style="color: white; font-weight: bold; font-size: 1.2em;">:</span>
                                                <div class="time-box"
                                                    style=" padding: 6px 10px; border-radius: 6px; text-align: center; min-width: 45px;">
                                                    <span id="gt-minutes">00</span>
                                                    <small>Phút</small>
                                                </div>
                                                <span class="separator"
                                                    style="color: white; font-weight: bold; font-size: 1.2em;">:</span>
                                                <div class="time-box"
                                                    style=" padding: 6px 10px; border-radius: 6px; text-align: center; min-width: 45px;">
                                                    <span id="gt-seconds">00</span>
                                                    <small>Giây</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="toolbar-section">
                                <div class="sort-buttons">
                                    <span class="sort-label">
                                        <i class="fas fa-sort-amount-down"></i>
                                        Sắp xếp:
                                    </span>
                                    <button class="sort-btn active" data-sort="default">
                                        <i class="fas fa-th"></i>
                                        Mặc định
                                    </button>
                                    <button class="sort-btn" data-sort="price-asc">
                                        <i class="fas fa-arrow-up"></i>
                                        Giá tăng
                                    </button>
                                    <button class="sort-btn" data-sort="price-desc">
                                        <i class="fas fa-arrow-down"></i>
                                        Giá giảm
                                    </button>
                                    <button class="sort-btn" data-sort="discount">
                                        <i class="fas fa-percent"></i>
                                        Giảm nhiều
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="products-grid">
                            <c:choose>
                                <c:when test="${not empty flashSales}">
                                    <c:forEach var="sale" items="${flashSales}">
                                        <div class="flash-product-item">
                                            <div class="product-badges">
                                                <span class="badge badge-sale">SALE</span>
                                            </div>
                                            <div class="discount-badge">-
                                                <fmt:formatNumber value="${sale.discountPercent}"
                                                    maxFractionDigits="0" />%
                                            </div>
                                            <div class="product-img">
                                                <a
                                                    href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${sale.product.id}">
                                                    <c:choose>
                                                        <c:when test="${not empty sale.product.primaryImageUrl}">
                                                            <img src="${sale.product.primaryImageUrl}"
                                                                alt="${sale.product.name}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                                alt="${sale.product.name}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </div>
                                            <h3>${sale.product.name}</h3>
                                            <div class="product-price">
                                                <span class="new-price">
                                                    <fmt:formatNumber
                                                        value="${sale.product.minPrice * (1 - sale.discountPercent / 100)}"
                                                        pattern="#,###" />đ
                                                </span>
                                                <span class="old-price">
                                                    <fmt:formatNumber value="${sale.product.minPrice}"
                                                        pattern="#,###" />đ
                                                </span>
                                            </div>
                                            <div class="sold-progress">
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${sale.soldPercentage}%">
                                                    </div>
                                                </div>
                                                <span class="sold-text">Đã bán
                                                    ${sale.soldCount}/${sale.stockLimit}</span>
                                            </div>
                                            <button class="add-to-cart-btn"
                                                onclick="addToCart(${sale.product.id}, ${not empty sale.product.minPriceVariant ? sale.product.minPriceVariant.id : 0})">
                                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                            </button>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>

                                    <div class="empty-state">
                                        <i class="fas fa-tags"></i>
                                        <h2>Hiện tại chưa có sản phẩm giá tốt</h2>
                                        <p>Hãy quay lại sau để xem các ưu đãi hấp dẫn!</p>
                                        <a href="${pageContext.request.contextPath}/san-pham" style="display: inline-block; margin-top: 20px; padding: 12px 30px;
      background: linear-gradient(135deg, #4CAF50, #45a049);
      color: white; text-decoration: none; border-radius: 25px;">
                                            Xem tất cả sản phẩm
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${not empty flashSales && flashSales.size() > 12}">
                            <div class="load-more-section">
                                <button class="load-more-btn">
                                    Xem thêm sản phẩm
                                    <i class="fas fa-chevron-down"></i>
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>



                <jsp:include page="common/footer.jsp" />
                <script src="${pageContext.request.contextPath}/js/GiaTot.js"></script>



                <c:if test="${not empty flashSaleEndTime}">
                    <script>
                        (function () {
                            const endTime = ${ flashSaleEndTime };

                            function updateCountdown() {
                                const now = new Date().getTime();
                                const distance = endTime - now;

                                if (distance < 0) {
                                    document.getElementById('gt-hours').textContent = '00';
                                    document.getElementById('gt-minutes').textContent = '00';
                                    document.getElementById('gt-seconds').textContent = '00';
                                    return;
                                }

                                const hours = Math.floor(distance / (1000 * 60 * 60));
                                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                                document.getElementById('gt-hours').textContent = hours.toString().padStart(2, '0');
                                document.getElementById('gt-minutes').textContent = minutes.toString().padStart(2, '0');
                                document.getElementById('gt-seconds').textContent = seconds.toString().padStart(2, '0');
                            }

                            updateCountdown();
                            setInterval(updateCountdown, 1000);
                        })();
                    </script>
                </c:if>
            </body>

            </html>