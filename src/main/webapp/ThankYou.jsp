<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đặt hàng thành công - Nông Sản Farmily</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ThanhToan.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <style>
                    .thankyou-page .thankyou-container {
                        max-width: 800px;
                        margin: 40px auto;
                        padding: 0 20px;
                        font-family: var(--font-main);
                    }

                    .thankyou-page .thankyou-card {
                        background: #fff;
                        border-radius: 16px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                        padding: 40px;
                        text-align: center;
                    }

                    .thankyou-page .success-icon {
                        width: 80px;
                        height: 80px;
                        background: var(--primary);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto 24px;
                        animation: scaleIn 0.5s ease;
                    }

                    .thankyou-page .success-icon i {
                        font-size: 40px;
                        color: #fff;
                    }

                    .thankyou-page .thankyou-title {
                        font-family: var(--font-main);
                        font-weight: 700;
                        font-size: 28px;
                        color: #1f2937;
                        margin-bottom: 12px;
                    }

                    .thankyou-subtitle {
                        color: #6b7280;
                        font-size: 16px;
                        margin-bottom: 32px;
                    }

                    .order-info {
                        background: #f9fafb;
                        border-radius: 12px;
                        padding: 24px;
                        margin-bottom: 32px;
                        text-align: left;
                    }

                    .order-info-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 16px;
                        padding-bottom: 16px;
                        border-bottom: 1px solid #e5e7eb;
                    }

                    .order-number {
                        font-size: 18px;
                        font-weight: 600;
                        color: #22c55e;
                    }

                    .order-status {
                        background: #fef3c7;
                        color: #92400e;
                        padding: 4px 12px;
                        border-radius: 20px;
                        font-size: 13px;
                        font-weight: 500;
                    }

                    .order-details {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 16px;
                    }

                    .order-detail-item {
                        display: flex;
                        flex-direction: column;
                        gap: 4px;
                    }

                    .order-detail-label {
                        color: #6b7280;
                        font-size: 13px;
                    }

                    .order-detail-value {
                        color: #1f2937;
                        font-weight: 500;
                    }

                    .order-items-list {
                        margin-top: 20px;
                        padding-top: 16px;
                        border-top: 1px solid #e5e7eb;
                    }

                    .order-item-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 8px 0;
                        font-size: 14px;
                    }

                    .order-item-name {
                        color: #374151;
                    }

                    .order-item-price {
                        color: #1f2937;
                        font-weight: 500;
                    }

                    .order-totals {
                        margin-top: 16px;
                        padding-top: 16px;
                        border-top: 2px solid #e5e7eb;
                    }

                    .order-total-row {
                        display: flex;
                        justify-content: space-between;
                        padding: 6px 0;
                        font-size: 14px;
                    }

                    .order-total-row.grand {
                        font-size: 18px;
                        font-weight: 600;
                        color: #22c55e;
                        margin-top: 8px;
                    }

                    .action-buttons {
                        display: flex;
                        gap: 16px;
                        justify-content: center;
                    }

                    .thankyou-page .ty-btn {
                        padding: 12px 24px;
                        border-radius: 8px;
                        font-size: 15px;
                        font-weight: 500;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.2s;
                    }

                    .thankyou-page .btn-primary {
                        background: #22c55e;
                        color: #fff;
                    }

                    .thankyou-page .btn-primary:hover {
                        
                        box-shadow: 0 4px 12px rgba(34, 197, 94, 0.4);
                    }

                    .thankyou-page .btn-secondary {
                        background: #f3f4f6;
                        color: #374151;
                    }

                    .thankyou-page .btn-secondary:hover {
                        background: #e5e7eb;
                    }

                    @keyframes scaleIn {
                        from {
                            transform: scale(0);
                        }

                        to {
                            transform: scale(1);
                        }
                    }

                    @media (max-width: 600px) {
                        .order-details {
                            grid-template-columns: 1fr;
                        }

                        .action-buttons {
                            flex-direction: column;
                        }

                        .thankyou-page .ty-btn {
                            justify-content: center;
                        }
                    }
                </style>
            </head>

            <body class="thankyou-page">

                <jsp:include page="common/header.jsp" />

                <main class="thankyou-container">
                    <div class="thankyou-card">
                        <div class="success-icon">
                            <i class="fas fa-check"></i>
                        </div>

                        <h1 class="thankyou-title">Đặt hàng thành công!</h1>
                        <p class="thankyou-subtitle">
                            Cảm ơn bạn đã mua hàng tại Nông Sản Farmily.
                            Chúng tôi sẽ liên hệ với bạn sớm nhất.
                        </p>

                        <div class="order-info">
                            <div class="order-info-header">
                                <span class="order-number">Đơn hàng #${order.id}</span>
                                <span class="order-status">${order.statusText}</span>
                            </div>

                            <div class="order-details">
                                <div class="order-detail-item">
                                    <span class="order-detail-label">Người nhận</span>
                                    <span class="order-detail-value">${order.address.receiver}</span>
                                </div>
                                <div class="order-detail-item">
                                    <span class="order-detail-label">Điện thoại</span>
                                    <span class="order-detail-value">
                                        ${order.guestOrder ? order.guestPhone : order.user.phone}
                                    </span>
                                </div>
                                <div class="order-detail-item">
                                    <span class="order-detail-label">Địa chỉ</span>
                                    <span class="order-detail-value">${order.address.fullAddress}</span>
                                </div>
                                <div class="order-detail-item">
                                    <span class="order-detail-label">Thanh toán</span>
                                    <span class="order-detail-value">${order.paymentMethod.methodName}</span>
                                </div>
                            </div>


                            <div class="order-items-list">
                                <c:forEach var="item" items="${order.orderDetails}">
                                    <div class="order-item-row">
                                        <span class="order-item-name">
                                            ${item.productName}
                                            <c:if test="${not empty item.variantText}">
                                                (${item.variantText})
                                            </c:if>
                                            x${item.quantity}
                                        </span>
                                        <span class="order-item-price">${item.formattedSubtotal}</span>
                                    </div>
                                </c:forEach>
                            </div>


                            <div class="order-totals">
                                <div class="order-total-row">
                                    <span>Tạm tính</span>
                                    <span>${order.formattedSubtotal}</span>
                                </div>
                                <div class="order-total-row">
                                    <span>Phí vận chuyển</span>
                                    <span>${order.formattedShippingFee}</span>
                                </div>
                                <div class="order-total-row grand">
                                    <span>Tổng cộng</span>
                                    <span>${order.formattedTotalPrice}</span>
                                </div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/" class="ty-btn btn-primary">
                                <i class="fas fa-home"></i>
                                Về trang chủ
                            </a>
                            <a href="${pageContext.request.contextPath}/san-pham" class="ty-btn btn-secondary">
                                <i class="fas fa-shopping-bag"></i>
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </main>


                <jsp:include page="common/footer.jsp" />
            </body>

            </html>