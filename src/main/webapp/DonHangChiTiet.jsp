<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${pageTitle} | Farmily</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoSo.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DonHang.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <style>
                        .timeline-vertical {
                            position: relative;
                            padding: 20px 0 20px 40px;
                            margin: 20px 0;
                        }
                        .timeline-vertical::before {
                            content: '';
                            position: absolute;
                            top: 0;
                            bottom: 0;
                            left: 19px;
                            width: 2px;
                            background: #e2e8f0;
                        }
                        .timeline-v-item {
                            position: relative;
                            margin-bottom: 24px;
                        }
                        .timeline-v-item:last-child {
                            margin-bottom: 0;
                        }
                        .timeline-v-dot {
                            position: absolute;
                            left: -40px;
                            top: 0;
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            background: #f8fafc;
                            border: 2px solid #e2e8f0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: #64748b;
                            z-index: 1;
                        }
                        .timeline-v-item.completed .timeline-v-dot {
                            background: #10b981;
                            border-color: #10b981;
                            color: white;
                        }
                        .timeline-v-content {
                            background: #f8fafc;
                            padding: 16px;
                            border-radius: 8px;
                            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
                            border: 1px solid #e2e8f0;
                        }
                        .timeline-v-title {
                            font-weight: 600;
                            color: #0f172a;
                            margin-bottom: 4px;
                            font-size: 15px;
                        }
                        .timeline-v-date {
                            font-size: 13px;
                            color: #64748b;
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
                                        <i class="fas fa-home"></i> Trang chủ
                                    </a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/ho-so">Hồ sơ</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/ho-so/don-hang">Đơn hàng</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    Chi tiết #${order.id}
                                </li>
                            </ol>
                        </div>
                    </nav>

                    <div class="profile-container">

                        <div class="profile-menu">
                            <h2>TRANG TÀI KHOẢN</h2>
                            <p>Xin chào, <span class="highlight-name">${sessionScope.auth.name}</span>!</p>
                            <ul>
                                <li>
                                    <a href="${pageContext.request.contextPath}/ho-so?tab=info">
                                        <i class="fas fa-user"></i> Thông tin tài khoản
                                    </a>
                                </li>
                                <li class="active">
                                    <a href="${pageContext.request.contextPath}/ho-so/don-hang">
                                        <i class="fas fa-box"></i> Đơn hàng của bạn
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/ho-so?tab=address">
                                        <i class="fas fa-map-marker-alt"></i> Sổ địa chỉ
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/ho-so?tab=password">
                                        <i class="fas fa-lock"></i> Đổi mật khẩu
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/ho-so?tab=wishlist">
                                        <i class="fas fa-heart"></i> Sản phẩm yêu thích
                                    </a>
                                </li>
                            </ul>
                        </div>


                        <div class="profile-info">
                            <div class="order-detail-header">
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang" class="btn-back">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                                <h2>CHI TIẾT ĐƠN HÀNG #${order.id}</h2>
                            </div>


                            <c:if test="${order.status != 'cancelled'}">
                                <div class="timeline-vertical">
                                    <c:choose>
                                        <c:when test="${not empty order.statusHistory}">
                                            <c:forEach var="history" items="${order.statusHistory}">
                                                <div class="timeline-v-item completed">
                                                    <div class="timeline-v-dot"><i class="fas fa-check"></i></div>
                                                    <div class="timeline-v-content">
                                                        <div class="timeline-v-title">${history.newStatusText}</div>
                                                        <div class="timeline-v-date">
                                                            <fmt:formatDate value="${history.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                        <c:if test="${not empty history.note}">
                                                            <div class="timeline-v-date" style="margin-top:4px;">Ghi chú: ${fn:escapeXml(history.note)}</div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="timeline-v-item completed">
                                                <div class="timeline-v-dot"><i class="fas fa-check"></i></div>
                                                <div class="timeline-v-content">
                                                    <div class="timeline-v-title">Đơn hàng đã đặt</div>
                                                    <div class="timeline-v-date">
                                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <c:if test="${order.status == 'cancelled' || order.status == 'cancelled_by_admin'}">
                                <div class="order-cancelled-banner">
                                    <i class="fas fa-circle-xmark"></i>
                                    <div class="cancelled-info">
                                        <span class="cancelled-title">Đơn hàng đã bị hủy</span>
                                        <span class="cancelled-desc">Đơn hàng này không còn hiệu lực</span>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${order.status == 'delivery_failed'}">
                                <div class="order-cancelled-banner" style="background:#fff1f2; color:#be123c;">
                                    <i class="fas fa-truck-slash" style="color:#be123c;"></i>
                                    <div class="cancelled-info">
                                        <span class="cancelled-title" style="color:#be123c;">Giao hàng thất bại</span>
                                        <span class="cancelled-desc" style="color:#e11d48;">Đơn hàng không thể giao đến bạn.</span>
                                    </div>
                                </div>
                            </c:if>


                            <div class="order-detail-info">
                                <div class="info-row">
                                    <div class="info-col">
                                        <p class="info-label">Ngày đặt hàng:</p>
                                        <p class="info-value">
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                    <div class="info-col">
                                        <p class="info-label">Trạng thái:</p>
                                        <p class="info-value">
                                            <span class="status-badge status-${order.status}">
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                                    <c:when test="${order.status == 'processing'}">Đang xử lý</c:when>
                                                    <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                                                    <c:when test="${order.status == 'completed'}">Hoàn thành</c:when>
                                                    <c:when test="${order.status == 'cancelled'}">Đã hủy (Khách)</c:when>
                                                    <c:when test="${order.status == 'cancelled_by_admin'}">Đã hủy (Hệ thống)</c:when>
                                                    <c:when test="${order.status == 'payment_expired'}">Hết hạn thanh toán</c:when>
                                                    <c:when test="${order.status == 'delivery_failed'}">Giao thất bại</c:when>
                                                    <c:when test="${order.status == 'returned'}">Đã hoàn hàng</c:when>
                                                    <c:when test="${order.status == 'refunded'}">Đã hoàn tiền</c:when>
                                                    <c:otherwise>${order.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </p>
                                    </div>
                                    <div class="info-col">
                                        <p class="info-label">Phương thức thanh toán:</p>
                                        <p class="info-value">${order.paymentMethod.name}</p>
                                    </div>
                                </div>
                            </div>


                            <div class="order-section">
                                <h3><i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng</h3>
                                <div class="address-box">
                                    <p><strong>${order.address.receiver}</strong></p>
                                    <c:choose>
                                        <c:when test="${not empty order.address.phone}">
                                            <p><i class="fas fa-phone"></i> ${order.address.phone}</p>
                                        </c:when>
                                        <c:when test="${not empty order.customerPhone}">
                                            <p><i class="fas fa-phone"></i> ${order.customerPhone}</p>
                                        </c:when>
                                        <c:when test="${not empty sessionScope.auth.phone}">
                                            <p><i class="fas fa-phone"></i> ${sessionScope.auth.phone}</p>
                                        </c:when>
                                    </c:choose>
                                    <p><i class="fas fa-location-dot"></i> ${order.address.fullAddress}</p>
                                </div>
                            </div>


                            <c:if test="${not empty order.note}">
                                <div class="order-section">
                                    <h3><i class="fas fa-note-sticky"></i> Ghi chú</h3>
                                    <p class="order-note">${order.note}</p>
                                </div>
                            </c:if>


                            <div class="order-section">
                                <h3><i class="fas fa-box"></i> Sản phẩm</h3>
                                <div class="product-list-detail">
                                    <c:forEach var="detail" items="${order.orderDetails}">
                                        <div class="product-detail-item">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when
                                                        test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                        <img src="${detail.imageUrl}" alt="${detail.productName}"
                                                            onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}${detail.imageUrl}"
                                                            alt="${detail.productName}"
                                                            onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <p class="product-name">${detail.productName}</p>
                                                <c:if test="${not empty detail.variantText}">
                                                    <p class="product-variant">Phân loại: ${detail.variantText}</p>
                                                </c:if>
                                            </div>
                                            <div class="product-quantity">x${detail.quantity}</div>
                                            <div class="product-price">
                                                <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###" />đ
                                            </div>
                                            <div class="product-subtotal">
                                                <fmt:formatNumber value="${detail.subtotal}" pattern="#,###" />đ
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>


                            <div class="order-summary">
                                <div class="summary-row">
                                    <span class="summary-label">Tạm tính:</span>
                                    <span class="summary-value">
                                        <fmt:formatNumber value="${order.totalPrice - order.shippingFee}"
                                            pattern="#,###" />đ
                                    </span>
                                </div>
                                <div class="summary-row">
                                    <span class="summary-label">Phí vận chuyển:</span>
                                    <span class="summary-value">
                                        <c:choose>
                                            <c:when test="${order.shippingFee == 0}">
                                                <span class="free-ship">Miễn phí</span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${order.shippingFee}" pattern="#,###" />đ
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="summary-row summary-total">
                                    <span class="summary-label">Tổng cộng:</span>
                                    <span class="summary-value total-amount">
                                        <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />đ
                                    </span>
                                </div>
                            </div>


                            <c:if test="${order.status == 'shipping'}">
                                <div class="order-actions">
                                    <form action="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet"
                                        method="post" onsubmit="return confirm('Xác nhận bạn đã nhận được hàng?');">
                                        <input type="hidden" name="action" value="confirm-received">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <button type="submit" class="btn-confirm-received">
                                            <i class="fas fa-box-open"></i> Đã nhận hàng
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <c:if test="${order.status == 'pending'}">
                                <div class="order-actions">
                                    <form action="${pageContext.request.contextPath}/ho-so/don-hang" method="post"
                                        onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?');">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <button type="submit" class="btn-cancel-order">
                                            <i class="fas fa-times"></i> Hủy đơn hàng
                                        </button>
                                    </form>
                                </div>
                            </c:if>


                            <c:if test="${order.status == 'completed' && not empty sessionScope.auth}">
                                <div class="order-section review-area">
                                    <h3><i class="fas fa-star-half-stroke"></i> Đánh giá sản phẩm</h3>
                                    <c:forEach var="detail" items="${order.orderDetails}">
                                        <div class="review-product-card" id="review-${detail.productId}">
                                            <div class="review-product-info">
                                                <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${detail.productId}"
                                                    class="review-product-img">
                                                    <c:choose>
                                                        <c:when
                                                            test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                            <img src="${detail.imageUrl}" alt="${detail.productName}"
                                                                onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}${detail.imageUrl}"
                                                                alt="${detail.productName}"
                                                                onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </a>
                                                <div class="review-product-meta">
                                                    <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${detail.productId}"
                                                        class="review-product-name">${detail.productName}</a>
                                                    <c:if test="${not empty detail.variantText}">
                                                        <span class="review-product-variant">Phân loại:
                                                            ${detail.variantText}</span>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:choose>
                                                <c:when test="${not empty reviewMap[detail.productId]}">
                                                    <c:set var="existingReview"
                                                        value="${reviewMap[detail.productId]}" />
                                                    <div class="review-completed">
                                                        <div class="review-completed-header">
                                                            <span class="review-badge reviewed">
                                                                <i class="fas fa-check-circle"></i> Đã đánh giá
                                                            </span>
                                                            <span class="review-date">
                                                                <fmt:formatDate value="${existingReview.createdAt}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </span>
                                                        </div>
                                                        <div class="review-stars-display">
                                                            <c:forEach var="i" begin="1" end="5">
                                                                <i
                                                                    class="fa-star ${i <= existingReview.rating ? 'fas active' : 'far'}"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <p class="review-text-display">
                                                            ${fn:escapeXml(existingReview.reviewText)}</p>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="review-form-wrapper">
                                                        <div class="review-form-header">
                                                            <span class="review-badge not-reviewed">
                                                                <i class="far fa-comment-dots"></i> Chưa đánh giá
                                                            </span>
                                                        </div>
                                                        <form class="review-form" method="post"
                                                            action="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet"
                                                            onsubmit="return validateReviewForm(this)">
                                                            <input type="hidden" name="action" value="review">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <input type="hidden" name="productId"
                                                                value="${detail.productId}">
                                                            <c:if test="${detail.variantId != null}">
                                                                <input type="hidden" name="variantId"
                                                                    value="${detail.variantId}">
                                                            </c:if>
                                                            <input type="hidden" name="rating" value="0"
                                                                class="rating-input">

                                                            <div class="star-rating-input">
                                                                <span class="star-label">Đánh giá:</span>
                                                                <div class="stars-interactive">
                                                                    <i class="far fa-star" data-value="1"></i>
                                                                    <i class="far fa-star" data-value="2"></i>
                                                                    <i class="far fa-star" data-value="3"></i>
                                                                    <i class="far fa-star" data-value="4"></i>
                                                                    <i class="far fa-star" data-value="5"></i>
                                                                </div>
                                                                <span class="star-text"></span>
                                                            </div>

                                                            <textarea name="reviewText" class="review-textarea"
                                                                placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."
                                                                rows="3" maxlength="500"></textarea>

                                                            <div class="review-form-actions">
                                                                <span class="char-count">0/500</span>
                                                                <button type="submit" class="btn-submit-review">
                                                                    <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>


                    <jsp:include page="common/footer.jsp" />

                    <script>
                        window.contextPath = '${pageContext.request.contextPath}';

                        var starLabels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Rất tốt'];

                        document.querySelectorAll('.stars-interactive').forEach(function (container) {
                            var stars = container.querySelectorAll('i');
                            var form = container.closest('.review-form');
                            var ratingInput = form.querySelector('.rating-input');
                            var starText = container.nextElementSibling;

                            stars.forEach(function (star) {
                                star.addEventListener('mouseenter', function () {
                                    var val = parseInt(this.getAttribute('data-value'));
                                    highlightStars(stars, val);
                                    starText.textContent = starLabels[val];
                                });

                                star.addEventListener('mouseleave', function () {
                                    var current = parseInt(ratingInput.value);
                                    highlightStars(stars, current);
                                    starText.textContent = current > 0 ? starLabels[current] : '';
                                });

                                star.addEventListener('click', function () {
                                    var val = parseInt(this.getAttribute('data-value'));
                                    ratingInput.value = val;
                                    highlightStars(stars, val);
                                    starText.textContent = starLabels[val];
                                });
                            });
                        });

                        function highlightStars(stars, count) {
                            stars.forEach(function (s, idx) {
                                if (idx < count) {
                                    s.classList.remove('far');
                                    s.classList.add('fas', 'active');
                                } else {
                                    s.classList.remove('fas', 'active');
                                    s.classList.add('far');
                                }
                            });
                        }

                        document.querySelectorAll('.review-textarea').forEach(function (textarea) {
                            var counter = textarea.closest('.review-form').querySelector('.char-count');
                            textarea.addEventListener('input', function () {
                                counter.textContent = this.value.length + '/500';
                            });
                        });

                        function validateReviewForm(form) {
                            var rating = parseInt(form.querySelector('.rating-input').value);
                            var text = form.querySelector('.review-textarea').value.trim();

                            if (rating < 1 || rating > 5) {
                                alert('Vui lòng chọn số sao đánh giá');
                                return false;
                            }
                            if (text.length === 0) {
                                alert('Vui lòng nhập nội dung đánh giá');
                                return false;
                            }
                            form.querySelector('button[type="submit"]').disabled = true;
                            form.querySelector('button[type="submit"]').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
                            return true;
                        }
                    </script>
                </body>

                </html>