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
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoanTien.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review-shared.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=9">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css?v=2">
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
                                    <a href="${pageContext.request.contextPath}/ho-so">Hồ sơ cá nhân</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    Đơn hàng của bạn
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
                                <li>
                                    <a href="${pageContext.request.contextPath}/ho-so?tab=coupons">
                                        <i class="fas fa-ticket-alt"></i> Ví voucher
                                    </a>
                                </li>
                            </ul>
                        </div>


                        <div class="profile-info">
                            <h2>ĐƠN HÀNG CỦA BẠN</h2>


                            <div class="order-filter">
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=all"
                                    class="filter-btn ${currentStatus == 'all' ? 'active' : ''}">
                                    Tất cả (${countAll})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=pending"
                                    class="filter-btn ${currentStatus == 'pending' ? 'active' : ''}">
                                    Chờ xác nhận (${countPending})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=processing"
                                    class="filter-btn ${currentStatus == 'processing' ? 'active' : ''}">
                                    Đang xử lý (${countProcessing})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=shipping"
                                    class="filter-btn ${currentStatus == 'shipping' ? 'active' : ''}">
                                    Đang giao (${countShipping})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=completed"
                                    class="filter-btn ${currentStatus == 'completed' ? 'active' : ''}">
                                    Hoàn thành (${countCompleted})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=cancelled"
                                    class="filter-btn ${currentStatus == 'cancelled' ? 'active' : ''}">
                                    Đã hủy (${countCancelled})
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=review"
                                    class="filter-btn ${currentStatus == 'review' ? 'active' : ''}">
                                    <i class="fas fa-star"></i> Đánh giá
                                </a>
                                <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=refund"
                                    class="filter-btn ${currentStatus == 'refund' ? 'active' : ''}">
                                    <i class="fas fa-undo-alt"></i> Hoàn tiền (${countRefund})
                                </a>
                            </div>


                            <c:choose>
                                <c:when test="${currentStatus == 'review'}">
                                    <c:choose>
                                        <c:when test="${empty orders}">
                                            <div class="empty-orders">
                                                <i class="fas fa-star"></i>
                                                <p>Chưa có đơn hàng nào hoàn thành để đánh giá</p>
                                                <a href="${pageContext.request.contextPath}/san-pham"
                                                    class="btn-primary">
                                                    Tiếp tục mua sắm
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="review-list">
                                                <c:forEach var="order" items="${orders}">
                                                    <div class="review-order-card">
                                                        <div class="review-order-header">
                                                            <div class="review-order-id">
                                                                <i class="fas fa-receipt"></i>
                                                                Đơn hàng #${order.id}
                                                            </div>
                                                            <div class="review-order-date">
                                                                <fmt:formatDate value="${order.orderDate}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </div>
                                                        </div>
                                                        <div class="review-products-list">
                                                            <c:forEach var="detail" items="${order.orderDetails}">
                                                                <div class="review-product-card">
                                                                    <div class="review-product-info">
                                                                        <a href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${detail.productId}"
                                                                            class="review-product-img">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                                                    <img src="${detail.imageUrl}"
                                                                                        alt="${detail.productName}"
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
                                                                            <c:if
                                                                                test="${not empty detail.variantText}">
                                                                                <span
                                                                                    class="review-product-variant">Phân
                                                                                    loại: ${detail.variantText}</span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>

                                                                    <c:set var="thisReviewMap"
                                                                        value="${orderReviewMaps[order.id]}" />
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${not empty thisReviewMap && not empty thisReviewMap[detail.productId]}">
                                                                            <c:set var="existingReview"
                                                                                value="${thisReviewMap[detail.productId]}" />
                                                                            <div class="review-completed">
                                                                                <div class="review-completed-header">
                                                                                    <span class="review-badge reviewed">
                                                                                        <i
                                                                                            class="fas fa-check-circle"></i>
                                                                                        Đã đánh giá
                                                                                    </span>
                                                                                    <span class="review-date">
                                                                                        <fmt:formatDate
                                                                                            value="${existingReview.createdAt}"
                                                                                            pattern="dd/MM/yyyy HH:mm" />
                                                                                    </span>
                                                                                </div>
                                                                                <div class="review-stars-display">
                                                                                    <c:forEach var="i" begin="1"
                                                                                        end="5">
                                                                                        <i
                                                                                            class="fa-star ${i <= existingReview.rating ? 'fas active' : 'far'}"></i>
                                                                                    </c:forEach>
                                                                                </div>
                                                                                <p class="review-text-display">
                                                                                    ${fn:escapeXml(existingReview.reviewText)}
                                                                                </p>
                                                                                <c:if test="${not empty existingReview.images}">
                                                                                    <div class="review-media-grid">
                                                                                        <c:forEach var="img" items="${existingReview.images}">
                                                                                            <c:choose>
                                                                                                <c:when test="${img.mediaType eq 'video'}">
                                                                                                    <video src="${img.imageUrl}" preload="metadata" class="review-media-thumb"></video>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <img src="${img.imageUrl}" alt="Ảnh đánh giá" class="review-media-thumb">
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </c:forEach>
                                                                                    </div>
                                                                                </c:if>
                                                                                <c:choose>
                                                                                    <c:when test="${existingReview.editable}">
                                                                                        <button type="button"
                                                                                            class="btn-edit-review"
                                                                                            onclick="toggleEditReviewForm(${existingReview.id})">
                                                                                            <i class="fas fa-edit"></i> Sửa đánh giá (1 lần)
                                                                                        </button>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="review-edit-locked">
                                                                                            <i class="fas fa-lock"></i> Đã chỉnh sửa
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>

                                                                                <c:if test="${existingReview.editable}">
                                                                                    <form id="editReviewForm-${existingReview.id}"
                                                                                        class="review-form review-edit-form"
                                                                                        method="post"
                                                                                        enctype="multipart/form-data"
                                                                                        action="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet"
                                                                                        onsubmit="return validateReviewForm(this)"
                                                                                        style="display:none;">
                                                                                        <input type="hidden" name="action" value="editReview">
                                                                                        <input type="hidden" name="reviewId" value="${existingReview.id}">
                                                                                        <input type="hidden" name="orderId" value="${order.id}">
                                                                                        <input type="hidden" name="rating" value="${existingReview.rating}" class="rating-input">

                                                                                        <div class="star-rating-input">
                                                                                            <span class="star-label">Đánh giá:</span>
                                                                                            <div class="stars-interactive">
                                                                                                <c:forEach var="i" begin="1" end="5">
                                                                                                    <i class="fa-star ${i <= existingReview.rating ? 'fas' : 'far'}" data-value="${i}"></i>
                                                                                                </c:forEach>
                                                                                            </div>
                                                                                            <span class="star-text"></span>
                                                                                        </div>

                                                                                        <textarea name="reviewText" class="review-textarea"
                                                                                            rows="3" maxlength="500">${fn:escapeXml(existingReview.reviewText)}</textarea>

                                                                                        <div class="review-media-section">
                                                                                            <label class="media-upload-label">
                                                                                                <i class="fas fa-camera"></i> Thay ảnh/video
                                                                                                <input type="file" name="mediaFiles" multiple
                                                                                                    accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm"
                                                                                                    class="media-file-input" hidden>
                                                                                            </label>
                                                                                            <div class="media-preview"></div>
                                                                                            <small class="media-hint">Chọn ảnh/video mới sẽ thay toàn bộ media cũ. Tối đa 5 ảnh + 1 video, ≤ 10MB.</small>
                                                                                        </div>

                                                                                        <div class="review-form-actions">
                                                                                            <span class="char-count">0/500</span>
                                                                                            <button type="button" class="btn-cancel-edit"
                                                                                                onclick="toggleEditReviewForm(${existingReview.id})">
                                                                                                Hủy
                                                                                            </button>
                                                                                            <button type="submit" class="btn-submit-review">
                                                                                                <i class="fas fa-save"></i> Lưu thay đổi
                                                                                            </button>
                                                                                        </div>
                                                                                    </form>
                                                                                </c:if>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <div class="review-form-wrapper">
                                                                                <div class="review-form-header">
                                                                                    <span
                                                                                        class="review-badge not-reviewed">
                                                                                        <i
                                                                                            class="far fa-comment-dots"></i>
                                                                                        Chưa đánh giá
                                                                                    </span>
                                                                                </div>
                                                                                <form class="review-form" method="post"
                                                                                    action="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet"
                                                                                    enctype="multipart/form-data"
                                                                                    onsubmit="return validateReviewForm(this)">
                                                                                    <input type="hidden" name="action"
                                                                                        value="review">
                                                                                    <input type="hidden" name="returnTo"
                                                                                        value="review">
                                                                                    <input type="hidden" name="orderId"
                                                                                        value="${order.id}">
                                                                                    <input type="hidden"
                                                                                        name="productId"
                                                                                        value="${detail.productId}">
                                                                                    <c:if
                                                                                        test="${detail.variantId != null}">
                                                                                        <input type="hidden"
                                                                                            name="variantId"
                                                                                            value="${detail.variantId}">
                                                                                    </c:if>
                                                                                    <input type="hidden" name="rating"
                                                                                        value="0" class="rating-input">

                                                                                    <div class="star-rating-input">
                                                                                        <span class="star-label">Đánh
                                                                                            giá:</span>
                                                                                        <div class="stars-interactive">
                                                                                            <i class="far fa-star"
                                                                                                data-value="1"></i>
                                                                                            <i class="far fa-star"
                                                                                                data-value="2"></i>
                                                                                            <i class="far fa-star"
                                                                                                data-value="3"></i>
                                                                                            <i class="far fa-star"
                                                                                                data-value="4"></i>
                                                                                            <i class="far fa-star"
                                                                                                data-value="5"></i>
                                                                                        </div>
                                                                                        <span class="star-text"></span>
                                                                                    </div>

                                                                                    <textarea name="reviewText"
                                                                                        class="review-textarea"
                                                                                        placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."
                                                                                        rows="3"
                                                                                        maxlength="500"></textarea>

                                                                                    <div class="review-media-section">
                                                                                        <label class="media-upload-label">
                                                                                            <i class="fas fa-camera"></i> Thêm ảnh/video
                                                                                            <input type="file" name="mediaFiles" multiple
                                                                                                accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm"
                                                                                                class="media-file-input" hidden>
                                                                                        </label>
                                                                                        <div class="media-preview"></div>
                                                                                        <small class="media-hint">Tối đa 5 ảnh + 1 video, mỗi file ≤ 10MB</small>
                                                                                    </div>

                                                                                    <div class="review-form-actions">
                                                                                        <span
                                                                                            class="char-count">0/500</span>
                                                                                        <button type="submit"
                                                                                            class="btn-submit-review">
                                                                                            <i
                                                                                                class="fas fa-paper-plane"></i>
                                                                                            Gửi đánh giá
                                                                                        </button>
                                                                                    </div>
                                                                                </form>
                                                                            </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${currentStatus == 'refund'}">
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <div class="empty-orders">
                                            <i class="fas fa-undo-alt"></i>
                                            <p>Bạn chưa có yêu cầu hoàn tiền nào</p>
                                            <a href="${pageContext.request.contextPath}/san-pham" class="btn-primary">
                                                Tiếp tục mua sắm
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="orders-list">
                                            <c:forEach var="order" items="${orders}">
                                                <div class="order-card">
                                                    <div class="order-header">
                                                        <div class="order-id">
                                                            <strong>Mã đơn hàng:</strong> #${order.id}
                                                        </div>
                                                        <div class="order-date">
                                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </div>
                                                        <div class="order-status">
                                                            <c:set var="rr" value="${refundRequestMap[order.id]}"/>
                                                            <c:if test="${not empty rr}">
                                                                <span class="refund-badge refund-${rr.status}">
                                                                    Hoàn tiền: ${rr.statusText}
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="order-body">
                                                        <div class="order-products">
                                                            <c:forEach var="detail" items="${order.orderDetails}" varStatus="status">
                                                                <c:if test="${status.index < 3}">
                                                                    <div class="product-item">
                                                                        <div class="product-image">
                                                                            <c:choose>
                                                                                <c:when test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                                                    <img src="${detail.imageUrl}" alt="${detail.productName}" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}${detail.imageUrl}" alt="${detail.productName}" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <div class="product-info">
                                                                            <p class="product-name">${detail.productName}</p>
                                                                            <c:if test="${not empty detail.variantText}">
                                                                                <p class="product-variant">Phân loại: ${detail.variantText}</p>
                                                                            </c:if>
                                                                            <p class="product-price-qty">
                                                                                <span class="unit-price">
                                                                                    <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###" />đ
                                                                                </span>
                                                                                <span class="quantity">x${detail.quantity}</span>
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>

                                                            <c:if test="${order.orderDetails.size() > 3}">
                                                                <div class="hidden-products" id="hidden-products-${order.id}">
                                                                    <c:forEach var="detail" items="${order.orderDetails}" varStatus="status">
                                                                        <c:if test="${status.index >= 3}">
                                                                            <div class="product-item">
                                                                                <div class="product-image">
                                                                                    <c:choose>
                                                                                        <c:when test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                                                            <img src="${detail.imageUrl}" alt="${detail.productName}" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <img src="${pageContext.request.contextPath}${detail.imageUrl}" alt="${detail.productName}" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </div>
                                                                                <div class="product-info">
                                                                                    <p class="product-name">${detail.productName}</p>
                                                                                    <c:if test="${not empty detail.variantText}">
                                                                                        <p class="product-variant">Phân loại: ${detail.variantText}</p>
                                                                                    </c:if>
                                                                                    <p class="product-price-qty">
                                                                                        <span class="unit-price">
                                                                                            <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###" />đ
                                                                                        </span>
                                                                                        <span class="quantity">x${detail.quantity}</span>
                                                                                    </p>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </div>

                                                                <button type="button" class="btn-toggle-products" data-order-id="${order.id}" onclick="toggleProductList(${order.id})">
                                                                    <i class="fas fa-chevron-down"></i>
                                                                    <span class="toggle-text">Xem đầy đủ (${order.orderDetails.size()} sản phẩm)</span>
                                                                </button>
                                                            </c:if>
                                                        </div>

                                                        <div class="order-total">
                                                            <p class="total-label">Thành tiền:</p>
                                                            <p class="total-price">
                                                                <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />đ
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="order-footer" style="display:flex;gap:10px;justify-content:flex-end;align-items:center;">
                                                        <c:if test="${not empty rr}">
                                                            <span style="font-size:13px;color:#666;">Số tiền hoàn: <strong style="color:#2d6a2d;">${rr.formattedRefundAmount}</strong></span>
                                                        </c:if>
                                                        <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}"
                                                           class="btn-view-detail">Chi tiết đơn hàng</a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${empty orders}">
                                    <div class="empty-orders">
                                        <i class="fas fa-box-open"></i>
                                        <p>Bạn chưa có đơn hàng nào</p>
                                        <a href="${pageContext.request.contextPath}/san-pham" class="btn-primary">
                                            Tiếp tục mua sắm
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="orders-list">
                                        <c:forEach var="order" items="${orders}">
                                            <div class="order-card">
                                                <div class="order-header">
                                                    <div class="order-id">
                                                        <strong>Mã đơn hàng:</strong> #${order.id}
                                                    </div>
                                                    <div class="order-date">
                                                        <fmt:formatDate value="${order.orderDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                    <div class="order-status">
                                                        <span class="status-badge status-${order.status}">
                                                            ${order.statusText}
                                                        </span>
                                                        <c:if test="${not empty order.ghnOrderCode}">
                                                            <span style="font-size:0.82em;color:#ff6600;margin-left:8px;">
                                                                <i class="fas fa-truck"></i>
                                                                GHN: <strong style="font-family:monospace;">${order.ghnOrderCode}</strong>
                                                                &nbsp;<a href="https://donhang.ghn.vn/?order_code=${order.ghnOrderCode}" target="_blank" rel="noopener" style="color:#ff6600;text-decoration:underline;">Tra cứu</a>
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <div class="order-body">
                                                    <div class="order-products">
                                                        <c:forEach var="detail" items="${order.orderDetails}"
                                                            varStatus="status">
                                                            <c:if test="${status.index < 3}">
                                                                <div class="product-item">
                                                                    <div class="product-image">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                                                <img src="${detail.imageUrl}"
                                                                                    alt="${detail.productName}"
                                                                                    onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="${pageContext.request.contextPath}${detail.imageUrl}"
                                                                                    alt="${detail.productName}"
                                                                                    onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="product-info">
                                                                        <p class="product-name">
                                                                            ${detail.productName}</p>
                                                                        <c:if test="${not empty detail.variantText}">
                                                                            <p class="product-variant">Phân loại:
                                                                                ${detail.variantText}</p>
                                                                        </c:if>
                                                                        <p class="product-price-qty">
                                                                            <span class="unit-price">
                                                                                <fmt:formatNumber
                                                                                    value="${detail.unitPrice}"
                                                                                    pattern="#,###" />đ
                                                                            </span>
                                                                            <span
                                                                                class="quantity">x${detail.quantity}</span>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>

                                                        <c:if test="${order.orderDetails.size() > 3}">

                                                            <div class="hidden-products"
                                                                id="hidden-products-${order.id}">
                                                                <c:forEach var="detail" items="${order.orderDetails}"
                                                                    varStatus="status">
                                                                    <c:if test="${status.index >= 3}">
                                                                        <div class="product-item">
                                                                            <div class="product-image">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${detail.imageUrl != null && (fn:startsWith(detail.imageUrl, 'http') || fn:startsWith(detail.imageUrl, 'https'))}">
                                                                                        <img src="${detail.imageUrl}"
                                                                                            alt="${detail.productName}"
                                                                                            onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <img src="${pageContext.request.contextPath}${detail.imageUrl}"
                                                                                            alt="${detail.productName}"
                                                                                            onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                            <div class="product-info">
                                                                                <p class="product-name">
                                                                                    ${detail.productName}</p>
                                                                                <c:if
                                                                                    test="${not empty detail.variantText}">
                                                                                    <p class="product-variant">Phân
                                                                                        loại: ${detail.variantText}
                                                                                    </p>
                                                                                </c:if>
                                                                                <p class="product-price-qty">
                                                                                    <span class="unit-price">
                                                                                        <fmt:formatNumber
                                                                                            value="${detail.unitPrice}"
                                                                                            pattern="#,###" />đ
                                                                                    </span>
                                                                                    <span
                                                                                        class="quantity">x${detail.quantity}</span>
                                                                                </p>
                                                                            </div>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>


                                                            <button type="button" class="btn-toggle-products"
                                                                data-order-id="${order.id}"
                                                                onclick="toggleProductList(${order.id})">
                                                                <i class="fas fa-chevron-down"></i>
                                                                <span class="toggle-text">Xem đầy đủ
                                                                    (${order.orderDetails.size()} sản phẩm)</span>
                                                            </button>
                                                        </c:if>
                                                    </div>

                                                    <div class="order-total">
                                                        <p class="total-label">Thành tiền:</p>
                                                        <p class="total-price">
                                                            <fmt:formatNumber value="${order.totalPrice}"
                                                                pattern="#,###" />đ
                                                        </p>
                                                    </div>
                                                </div>

                                                <div class="order-footer" style="display: flex; gap: 10px; justify-content: flex-end; align-items: center;">
                                                    <c:if test="${order.status == 'pending' && order.onlinePayment && order.paymentStatus != 'paid'}">
                                                        <a href="${pageContext.request.contextPath}/payment/repay?orderId=${order.id}"
                                                            class="btn-view-detail" style="background-color: #22c55e; border-color: #22c55e; color: #fff; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                                                            <i class="fas fa-credit-card"></i> Thanh toán ngay
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${refundEligibleSet.contains(order.id)}">
                                                        <a href="${pageContext.request.contextPath}/ho-so/hoan-tien?orderId=${order.id}"
                                                            class="btn-view-detail" style="background-color: #f97316; border-color: #f97316; color: #fff; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                                                            <i class="fas fa-undo-alt"></i> Hoàn tiền
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}"
                                                        class="btn-view-detail">
                                                        Chi tiết đơn hàng
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${totalPages > 1}">
                                <div class="pagination-bar">
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=${currentStatus}&page=${currentPage - 1}"
                                            class="pagination-btn pagination-prev">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </c:if>

                                    <div class="pagination-pages">
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=${currentStatus}&page=${i}"
                                                class="pagination-page ${i == currentPage ? 'active' : ''}">${i}</a>
                                        </c:forEach>
                                    </div>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/ho-so/don-hang?status=${currentStatus}&page=${currentPage + 1}"
                                            class="pagination-btn pagination-next">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </c:if>
                        </div>
                    </div>


                    <jsp:include page="common/chat-widget.jsp" />
                <jsp:include page="common/footer.jsp" />

                    <script>
                        window.contextPath = '${pageContext.request.contextPath}';
                    </script>
                    <script src="${pageContext.request.contextPath}/js/DonHang.js"></script>
                    <script src="${pageContext.request.contextPath}/js/review-media-upload.js?v=<%= System.currentTimeMillis() %>"></script>
                    <script src="${pageContext.request.contextPath}/js/review-lightbox.js"></script>
                    <script>
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
                            var btn = form.querySelector('button[type="submit"]');
                            btn.disabled = true;
                            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
                            return true;
                        }

                        function toggleEditReviewForm(reviewId) {
                            const form = document.getElementById('editReviewForm-' + reviewId);
                            if (!form) return;
                            const isVisible = form.style.display !== 'none';
                            form.style.display = isVisible ? 'none' : 'block';
                        }
                    </script>

                    <!-- Shared review lightbox -->
                    <div id="reviewSharedLightbox" onclick="reviewLightbox.close()">
                        <button class="rsl-close" onclick="reviewLightbox.close()">&times;</button>
                        <button class="rsl-nav prev" id="rslPrev" onclick="event.stopPropagation();reviewLightbox.navigate(-1)">&#8249;</button>
                        <img id="rslImg" src="" alt="" style="display:none;" onclick="event.stopPropagation()">
                        <video id="rslVideo" controls style="display:none;" onclick="event.stopPropagation()"></video>
                        <button class="rsl-nav next" id="rslNext" onclick="event.stopPropagation();reviewLightbox.navigate(1)">&#8250;</button>
                    </div>
                </body>

                </html>
