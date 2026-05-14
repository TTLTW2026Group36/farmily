<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <c:out value="${product.name}" default="Chi Tiết Sản Phẩm" /> - Nông Sản Farmily
                </title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ChiTietSanPham.css?v=<%= System.currentTimeMillis() %>">
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
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/san-pham">Sản phẩm</a>
                            </li>
                            <c:if test="${not empty product.category}">
                                <li class="breadcrumb-item">
                                    <a
                                        href="${pageContext.request.contextPath}/san-pham?categoryId=${product.category.id}">
                                        <c:out value="${product.category.name}" />
                                    </a>
                                </li>
                            </c:if>
                            <li class="breadcrumb-item active" aria-current="page">
                                <c:out value="${product.name}" />
                            </li>
                        </ol>
                    </div>
                </nav>

                <main class="sp sp-container">
                    <section class="sp-grid" aria-labelledby="sp-title">

                        <aside class="sp-gallery" aria-label="Bộ sưu tập ảnh sản phẩm">
                            <div class="sp-photo-main" id="photoMain" role="img" aria-label="Ảnh sản phẩm">
                                <c:choose>
                                    <c:when test="${not empty product.images}">
                                        <img id="mainImg" src="${product.images[0].imageUrl}"
                                            alt="${product.name} - ảnh 1">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="mainImg"
                                            src="${pageContext.request.contextPath}/images/placeholder.jpg"
                                            alt="${product.name}">
                                    </c:otherwise>
                                </c:choose>
                                <button class="nav prev" aria-label="Ảnh trước" data-dir="-1">‹</button>
                                <button class="nav next" aria-label="Ảnh kế tiếp" data-dir="1">›</button>
                            </div>

                            <div class="sp-thumbs" id="thumbs" role="list">
                                <c:choose>
                                    <c:when test="${not empty product.images}">
                                        <c:forEach var="image" items="${product.images}" varStatus="status">
                                            <button class="thumb ${status.first ? 'is-active' : ''}" role="listitem"
                                                aria-label="Ảnh ${status.index + 1}">
                                                <img src="${image.imageUrl}"
                                                    alt="${product.name} - ảnh ${status.index + 1}">
                                            </button>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="thumb is-active" role="listitem" aria-label="Ảnh 1">
                                            <img src="${pageContext.request.contextPath}/images/placeholder.jpg"
                                                alt="${product.name}">
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </aside>


                        <article class="sp-info">
                            <h1 id="sp-title" class="sp-title">
                                <c:out value="${product.name}" />
                            </h1>

                            <div class="sp-meta">
                                <span>Tình trạng:
                                    <c:choose>
                                        <c:when test="${product.totalStock > 0}">
                                            <strong class="status in-stock">Còn hàng</strong>
                                        </c:when>
                                        <c:otherwise>
                                            <strong class="status out-of-stock" style="color: #dc2626;">Hết
                                                hàng</strong>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="sp-meta">
                                <span class="rating">
                                    <strong>
                                        <fmt:formatNumber value="${product.avgRating}" pattern="#.#" />
                                    </strong>
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= product.avgRating}">
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:when test="${i - 0.5 <= product.avgRating}">
                                                <i class="fas fa-star-half-alt"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    (
                                    <c:out value="${product.reviewCount}" /> đánh giá)
                                </span>
                                <span class="dot">•</span>
                                <span>Đã bán: <strong>
                                        <c:choose>
                                            <c:when test="${product.soldCount >= 1000}">
                                                <fmt:formatNumber value="${product.soldCount / 1000}" pattern="#.#" />k
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${product.soldCount}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </strong></span>
                            </div>


                            <c:if test="${not empty flashSale}">
                                <div class="sp-flash-sale">
                                    <div class="flash-sale-info">
                                        <i class="fas fa-bolt"></i>
                                        <div class="flash-sale-title">
                                            <h3>FLASH SALE</h3>
                                            <p>Đang diễn ra - Giảm ${flashSale.discountPercent}%</p>
                                        </div>
                                    </div>
                                    <div class="flash-sale-countdown">
                                        <span class="label">Kết thúc sau</span>
                                        <div class="timer-display" id="flashTimer" data-end-time="${flashSaleEndTime}">
                                            <span id="h">00</span>:
                                            <span id="m">00</span>:
                                            <span id="s">00</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <div class="sp-price-box ${not empty flashSale ? 'is-sale' : ''}">
                                <div class="sp-price" id="price">
                                    <c:choose>
                                        <c:when test="${not empty flashSale}">
                                            <span class="current-price">
                                                <fmt:formatNumber
                                                    value="${not empty product.variants ? product.variants[0].getSalePrice(flashSale.discountPercent) : product.getSalePrice(flashSale.discountPercent)}"
                                                    pattern="#,###" />đ
                                            </span>
                                            <span class="old-price">
                                                <fmt:formatNumber
                                                    value="${not empty product.variants ? product.variants[0].price : product.minPrice}"
                                                    pattern="#,###" />đ
                                            </span>
                                            <span class="badge-sale-percent">-${flashSale.discountPercent}%</span>
                                        </c:when>
                                        <c:when test="${not empty product.variants}">
                                            <fmt:formatNumber value="${product.variants[0].price}" pattern="#,###" />đ
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${product.minPrice}" pattern="#,###" />đ
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="sp-note">Giao trong ngày ở HCM cho đơn đặt trước 12–16h.</div>
                            </div>

                            <form class="sp-purchase" id="purchaseForm">
                                <input type="hidden" id="productId" value="${product.id}">


                                <c:if test="${not empty product.variants}">
                                    <div class="field weight-field">
                                        <span class="label">Khối lượng:</span>
                                        <div class="weight-options">
                                            <c:forEach var="variant" items="${product.variants}" varStatus="status">
                                                <label class="weight-option">
                                                    <input type="radio" name="variantId" value="${variant.id}"
                                                        data-price="${variant.price}" data-stock="${variant.stock}"
                                                        ${status.first ? 'checked' : '' }>
                                                    <span class="weight-label">
                                                        <c:out value="${variant.optionsValue}" />
                                                    </span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>


                                <div class="field qty-field">
                                    <span class="label">Số lượng:</span>
                                    <div class="qty">
                                        <button type="button" class="qty-btn" data-step="-1"
                                            aria-label="Giảm">−</button>
                                        <input id="qtyInput" class="qty-input" type="number" value="1" min="1" max="99"
                                            inputmode="numeric" aria-label="Số lượng">
                                        <button type="button" class="qty-btn" data-step="1" aria-label="Tăng">+</button>
                                    </div>
                                </div>


                                <div class="actions">
                                    <c:choose>
                                        <c:when test="${product.totalStock > 0}">
                                            <div style="display: flex; flex-direction: row; gap: 12px; width: 100%;">
                                                <button type="submit" class="btn-primary" style="flex: 1; padding: 14px 8px; font-size: 15px;">
                                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                                </button>
                                                <button type="button" class="btn-buy-now" id="btnBuyNow">
                                                    Mua ngay
                                                </button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-primary" disabled>
                                                HẾT HÀNG
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <p class="msg" id="msg" role="status" aria-live="polite"></p>
                            </form>


                            <button type="button" class="btn-wishlist ${inWishlist ? 'active' : ''}" id="wishlistBtn"
                                data-product-id="${product.id}"
                                title="${inWishlist ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích'}"
                                onclick="event.stopPropagation();">
                                <i class="${inWishlist ? 'fas' : 'far'} fa-heart"></i>
                                <span>Yêu thích</span>
                            </button>
                        </article>
                    </section>


                    <section class="sp-desc card" aria-labelledby="desc-title">
                        <h2 id="desc-title" style="text-align: left; margin-left: 40px;">Mô tả</h2>
                        <ul class="desc-list">
                            <li>Sản xuất theo tiêu chuẩn an toàn, VietGAP.</li>
                            <li>Sơ chế, đóng gói, giao trong ngày. Thu hoạch buổi sáng – giao trong 12–24h.</li>
                            <li><strong>Lưu ý:</strong></li>
                            <li>Trọng lượng có thể chênh lệch ~5% do đặc tính nông sản.</li>
                            <li>Sản phẩm nhận được có thể khác với hình ảnh về màu sắc và kích thước tùy theo
                                mùa vụ hoặc thời
                                tiết nhưng vẫn đảm bảo chất lượng.</li>
                            <li>Nếu có yêu cầu đặc biệt về rửa/lựa size, vui lòng ghi chú khi đặt hàng.</li>
                            <li>Hotline/Zalo: 0378827924</li>
                        </ul>
                    </section>


                    <section class="sp-reviews card" aria-labelledby="reviews-title">
                        <h2 id="reviews-title">Đánh giá sản phẩm</h2>


                        <div class="reviews-summary">
                            <div class="rating-overview">
                                <div class="rating-score">
                                    <span class="score">
                                        <c:choose>
                                            <c:when test="${not empty reviewSummary}">
                                                <c:out value="${reviewSummary.formattedAvgRating}" />
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when
                                                    test="${not empty reviewSummary && i <= reviewSummary.averageRating}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:when
                                                    test="${not empty reviewSummary && i - 0.5 <= reviewSummary.averageRating}">
                                                    <i class="fas fa-star-half-alt"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <p class="total-reviews">
                                        <c:out value="${not empty reviewSummary ? reviewSummary.totalReviews : 0}" />
                                        đánh giá
                                    </p>
                                </div>

                                <div class="rating-breakdown">
                                    <div class="rating-bar">
                                        <span class="stars-label">5 <i class="fas fa-star"></i></span>
                                        <div class="bar">
                                            <div class="fill"
                                                style="width: ${not empty reviewSummary ? reviewSummary.getPercentage(5) : 0}%">
                                            </div>
                                        </div>
                                        <span class="count">
                                            <c:out value="${not empty reviewSummary ? reviewSummary.count5Star : 0}" />
                                        </span>
                                    </div>
                                    <div class="rating-bar">
                                        <span class="stars-label">4 <i class="fas fa-star"></i></span>
                                        <div class="bar">
                                            <div class="fill"
                                                style="width: ${not empty reviewSummary ? reviewSummary.getPercentage(4) : 0}%">
                                            </div>
                                        </div>
                                        <span class="count">
                                            <c:out value="${not empty reviewSummary ? reviewSummary.count4Star : 0}" />
                                        </span>
                                    </div>
                                    <div class="rating-bar">
                                        <span class="stars-label">3 <i class="fas fa-star"></i></span>
                                        <div class="bar">
                                            <div class="fill"
                                                style="width: ${not empty reviewSummary ? reviewSummary.getPercentage(3) : 0}%">
                                            </div>
                                        </div>
                                        <span class="count">
                                            <c:out value="${not empty reviewSummary ? reviewSummary.count3Star : 0}" />
                                        </span>
                                    </div>
                                    <div class="rating-bar">
                                        <span class="stars-label">2 <i class="fas fa-star"></i></span>
                                        <div class="bar">
                                            <div class="fill"
                                                style="width: ${not empty reviewSummary ? reviewSummary.getPercentage(2) : 0}%">
                                            </div>
                                        </div>
                                        <span class="count">
                                            <c:out value="${not empty reviewSummary ? reviewSummary.count2Star : 0}" />
                                        </span>
                                    </div>
                                    <div class="rating-bar">
                                        <span class="stars-label">1 <i class="fas fa-star"></i></span>
                                        <div class="bar">
                                            <div class="fill"
                                                style="width: ${not empty reviewSummary ? reviewSummary.getPercentage(1) : 0}%">
                                            </div>
                                        </div>
                                        <span class="count">
                                            <c:out value="${not empty reviewSummary ? reviewSummary.count1Star : 0}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="reviews-filter">
                            <button class="filter-btn active" data-filter="all">Tất cả</button>
                            <button class="filter-btn" data-filter="5">5 sao (
                                <c:out value="${not empty reviewSummary ? reviewSummary.count5Star : 0}" />)
                            </button>
                            <button class="filter-btn" data-filter="4">4 sao (
                                <c:out value="${not empty reviewSummary ? reviewSummary.count4Star : 0}" />)
                            </button>
                            <button class="filter-btn" data-filter="3">3 sao (
                                <c:out value="${not empty reviewSummary ? reviewSummary.count3Star : 0}" />)
                            </button>
                            <button class="filter-btn" data-filter="with-images">Có hình ảnh (
                                <c:out value="${not empty reviewSummary ? reviewSummary.countWithImages : 0}" />)
                            </button>
                            <button class="filter-btn" data-filter="verified">Đã mua hàng (
                                <c:out value="${not empty reviewSummary ? reviewSummary.countVerified : 0}" />)
                            </button>
                        </div>


                        <div class="reviews-list">
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach var="review" items="${reviews}">
                                        <article class="review-item" data-rating="${review.rating}"
                                            data-verified="${review.verifiedPurchase}"
                                            data-has-images="${review.hasImages()}">
                                            <div class="review-header">
                                                <div class="user-avatar">
                                                    <c:out value="${review.userInitial}" />
                                                </div>
                                                <div class="user-info">
                                                    <h4 class="user-name">
                                                        <c:out value="${review.userDisplayName}" />
                                                    </h4>
                                                    <div class="review-meta">
                                                        <div class="stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <c:choose>
                                                                    <c:when test="${i <= review.rating}">
                                                                        <i class="fas fa-star"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="far fa-star"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </div>
                                                        <span class="date">
                                                            <c:out value="${review.formattedDate}" />
                                                        </span>
                                                        <c:if test="${review.verifiedPurchase}">
                                                            <span class="verified"><i class="fas fa-check-circle"></i>
                                                                Đã mua hàng</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="review-content">
                                                <p class="review-text">
                                                    <c:out value="${review.reviewText}" />
                                                </p>
                                                <c:if test="${not empty review.variantDisplayText}">
                                                    <div class="review-variant">Phân loại:
                                                        <c:out value="${review.variantDisplayText}" />
                                                    </div>
                                                </c:if>
                                                <c:if test="${review.hasImages()}">
                                                    <div class="review-images">
                                                        <c:forEach var="img" items="${review.images}">
                                                            <img src="${img.imageUrl}" alt="Ảnh đánh giá">
                                                        </c:forEach>
                                                        <c:if test="${not empty review.imageUrl}">
                                                            <img src="${review.imageUrl}" alt="Ảnh đánh giá">
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                                <div class="review-actions">
                                                    <button class="action-btn"><i class="far fa-thumbs-up"></i> Hữu ích</button>
                                                    <button class="action-btn report-btn" 
                                                            data-review-id="${review.id}"
                                                            title="Báo cáo đánh giá không phù hợp">
                                                        <i class="far fa-flag"></i> Báo cáo
                                                    </button>
                                                </div>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-reviews" style="text-align: center; padding: 40px; color: #6b7280;">
                                        <i class="far fa-comment-dots"
                                            style="font-size: 48px; margin-bottom: 16px;"></i>
                                        <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                                        <p>Hãy là người đầu tiên đánh giá!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>


                        <c:if test="${not empty reviews && totalReviewPages > 1}">
                            <div class="reviews-loadmore">
                                <c:if test="${currentReviewPage < totalReviewPages}">
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}&reviewPage=${currentReviewPage + 1}"
                                        class="btn-loadmore">Xem thêm đánh giá</a>
                                </c:if>
                            </div>
                        </c:if>
                    </section>
                </main>

                <c:if test="${not empty relatedProducts}">
                    <section class="sp-related sp-container" aria-labelledby="related-title">
                        <h2 id="related-title" class="sp-related-heading">Sản phẩm liên quan</h2>
                        <div class="sp-related-grid">
                            <c:forEach var="rp" items="${relatedProducts}">
                                <div class="sp-related-card">
                                    <div class="sp-related-img">
                                        <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${rp.id}">
                                            <c:choose>
                                                <c:when test="${not empty rp.primaryImageUrl}">
                                                    <img src="${rp.primaryImageUrl}" alt="${rp.name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/images/no-image.jpg"
                                                        alt="${rp.name}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <div class="sp-related-info">
                                        <h3 class="sp-related-name">
                                            <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${rp.id}">
                                                <c:out value="${rp.name}" />
                                            </a>
                                        </h3>
                                        <p class="sp-related-price">
                                            <span class="price-current">
                                                <fmt:formatNumber value="${rp.minPrice}" type="number"
                                                    groupingUsed="true" />đ
                                            </span>
                                            <c:if test="${not empty rp.minPriceVariant}">
                                                <span class="price-unit">/${rp.minPriceVariant.optionsValue}</span>
                                            </c:if>
                                        </p>
                                        <button class="sp-related-cart-btn"
                                            onclick="addToCart(${rp.id}, ${not empty rp.minPriceVariant ? rp.minPriceVariant.id : 0})">
                                            <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>

                <jsp:include page="common/footer.jsp" />

                <script>
                    window.contextPath = "<c:out value='${pageContext.request.contextPath}'/>";
                    window.isLoggedIn = ${sessionScope.auth != null};

                    window.productData = {
                        id: ${empty product.id ? 0 : product.id },
                    name: "<c:out value='${product.name}'/>",
                        variants: [
                            <c:forEach var="variant" items="${product.variants}" varStatus="status">
                                {
                                    id: ${empty variant.id ? 0 : variant.id},
                                optionsValue: "<c:out value='${variant.optionsValue}' />",
                                price: ${empty variant.price ? 0 : variant.price},
                                stock: ${empty variant.stock ? 0 : variant.stock}
            }<c:if test="${!status.last}">,</c:if>
                            </c:forEach>
                        ],
                            flashSale: <c:choose>
                                <c:when test="${not empty flashSale}">
                                    {
                                        discountPercent: ${flashSale.discountPercent},
                                    endTime: ${flashSaleEndTime}
                }
                                </c:when>
                                <c:otherwise>null</c:otherwise>
                            </c:choose>
    };
                </script>

                <script src="${pageContext.request.contextPath}/js/ChiTietSanPham.js?v=<%= System.currentTimeMillis() %>"></script>
            </body>

            </html>