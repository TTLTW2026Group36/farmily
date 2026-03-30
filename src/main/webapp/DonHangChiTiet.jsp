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
                                <div class="order-progress-tracker">
                                    <div class="progress-steps">

                                        <div
                                            class="progress-step ${order.status == 'pending' || order.status == 'processing' || order.status == 'shipping' || order.status == 'completed' ? 'active completed' : ''}">
                                            <div class="step-icon">
                                                <i class="fas fa-clipboard-check"></i>
                                            </div>
                                            <div class="step-info">
                                                <span class="step-title">Đơn hàng đã đặt</span>
                                                <span class="step-date">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM HH:mm" />
                                                </span>
                                            </div>
                                        </div>


                                        <div
                                            class="progress-connector ${order.status == 'processing' || order.status == 'shipping' || order.status == 'completed' ? 'active' : ''}">
                                        </div>


                                        <div
                                            class="progress-step ${order.status == 'processing' || order.status == 'shipping' || order.status == 'completed' ? 'active' : ''} ${order.status == 'shipping' || order.status == 'completed' ? 'completed' : ''}">
                                            <div class="step-icon">
                                                <i class="fas fa-boxes-stacking"></i>
                                            </div>
                                            <div class="step-info">
                                                <span class="step-title">Đang xử lý</span>
                                                <span class="step-date">Chuẩn bị hàng</span>
                                            </div>
                                        </div>


                                        <div
                                            class="progress-connector ${order.status == 'shipping' || order.status == 'completed' ? 'active' : ''}">
                                        </div>


                                        <div
                                            class="progress-step ${order.status == 'shipping' || order.status == 'completed' ? 'active' : ''} ${order.status == 'completed' ? 'completed' : ''}">
                                            <div class="step-icon">
                                                <i class="fas fa-truck-fast"></i>
                                            </div>
                                            <div class="step-info">
                                                <span class="step-title">Đang giao hàng</span>
                                                <span class="step-date">Đang vận chuyển</span>
                                            </div>
                                        </div>


                                        <div class="progress-connector ${order.status == 'completed' ? 'active' : ''}">
                                        </div>


                                        <div
                                            class="progress-step ${order.status == 'completed' ? 'active completed' : ''}">
                                            <div class="step-icon">
                                                <i class="fas fa-circle-check"></i>
                                            </div>
                                            <div class="step-info">
                                                <span class="step-title">Hoàn thành</span>
                                                <span class="step-date">Đã nhận hàng</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>


                            <c:if test="${order.status == 'cancelled'}">
                                <div class="order-cancelled-banner">
                                    <i class="fas fa-circle-xmark"></i>
                                    <div class="cancelled-info">
                                        <span class="cancelled-title">Đơn hàng đã bị hủy</span>
                                        <span class="cancelled-desc">Đơn hàng này không còn hiệu lực</span>
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
                                                    <c:when test="${order.status == 'pending'}">Chờ xác nhận
                                                    </c:when>
                                                    <c:when test="${order.status == 'processing'}">Đang xử lý
                                                    </c:when>
                                                    <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                                                    <c:when test="${order.status == 'completed'}">Hoàn thành
                                                    </c:when>
                                                    <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
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
                        </div>
                    </div>


                    <jsp:include page="common/footer.jsp" />

                    <script>
                        window.contextPath = '${pageContext.request.contextPath}';
                    </script>
                </body>

                </html>