<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán - Nông Sản Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-result.css?v=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="payment-result-page">

    <jsp:include page="common/header.jsp" />

    <main class="pr-container">
        <div class="pr-card">

            <%-- Success callback: show "verifying..." until IPN confirms --%>
            <c:if test="${callbackType == 'success'}">
                <div class="pr-icon pr-icon-verifying" id="statusIcon">
                    <i class="fas fa-spinner fa-spin"></i>
                </div>
                <h1 class="pr-title" id="statusTitle">Đang xác nhận thanh toán...</h1>
                <p class="pr-subtitle" id="statusSubtitle">
                    Hệ thống đang xác nhận giao dịch của bạn. Vui lòng đợi trong giây lát.
                </p>
            </c:if>

            <%-- Error callback --%>
            <c:if test="${callbackType == 'error'}">
                <div class="pr-icon pr-icon-error">
                    <i class="fas fa-times"></i>
                </div>
                <h1 class="pr-title">Thanh toán thất bại</h1>
                <p class="pr-subtitle">
                    Giao dịch không thành công. Bạn có thể thử lại hoặc chọn phương thức khác.
                </p>
            </c:if>

            <%-- Cancel callback --%>
            <c:if test="${callbackType == 'cancel'}">
                <div class="pr-icon pr-icon-cancel">
                    <i class="fas fa-ban"></i>
                </div>
                <h1 class="pr-title">Thanh toán đã hủy</h1>
                <p class="pr-subtitle">
                    Bạn đã hủy giao dịch. Đơn hàng vẫn được giữ — bạn có thể thanh toán lại.
                </p>
            </c:if>

            <%-- Order info section --%>
            <c:if test="${not empty order}">
                <div class="pr-order-info">
                    <div class="pr-order-header">
                        <span class="pr-order-number">Đơn hàng #${order.id}</span>
                        <span class="pr-payment-badge" id="paymentBadge">
                            <c:choose>
                                <c:when test="${not empty payment}">
                                    ${payment.statusText}
                                </c:when>
                                <c:otherwise>
                                    Đang xác nhận
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="pr-order-details">
                        <div class="pr-detail-item">
                            <span class="pr-detail-label">Phương thức</span>
                            <span class="pr-detail-value">
                                <c:choose>
                                    <c:when test="${not empty order.paymentMethod}">
                                        ${order.paymentMethod.methodName}
                                    </c:when>
                                    <c:otherwise>Chuyển khoản ngân hàng</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="pr-detail-item">
                            <span class="pr-detail-label">Tổng tiền</span>
                            <span class="pr-detail-value pr-amount">${order.formattedTotalPrice}</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <%-- Action buttons --%>
            <div class="pr-actions" id="actionButtons">
                <c:choose>
                    <c:when test="${callbackType == 'success'}">
                        <%-- Polling will update these dynamically --%>
                        <div class="pr-polling-status" id="pollingStatus">
                            <i class="fas fa-circle-notch fa-spin"></i>
                            Đang kiểm tra trạng thái thanh toán...
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${not empty order}">
                            <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}"
                               class="pr-btn pr-btn-primary">
                                <i class="fas fa-eye"></i> Xem đơn hàng
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/"
                           class="pr-btn pr-btn-secondary">
                            <i class="fas fa-home"></i> Về trang chủ
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />

    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.callbackType = '${callbackType}';
        window.orderId = ${not empty order ? order.id : 0};
        window.invoiceNumber = '${invoiceNumber}';
    </script>
    <script>
    (function() {
        'use strict';

        // Only poll for success callbacks — IPN confirmation may arrive after redirect
        if (window.callbackType !== 'success' || !window.orderId) return;

        const POLL_INTERVAL = 3000; // 3 seconds
        const MAX_POLLS = 60;       // max 3 minutes of polling
        let pollCount = 0;

        function pollPaymentStatus() {
            pollCount++;

            if (pollCount > MAX_POLLS) {
                showTimeout();
                return;
            }

            fetch(window.contextPath + '/api/payment/status?orderId=' + window.orderId)
                .then(r => r.json())
                .then(data => {
                    if (data.paid) {
                        showPaid();
                    } else if (data.expired) {
                        showExpired();
                    } else if (data.status === 'failed') {
                        showFailed();
                    } else {
                        // Still pending — poll again
                        setTimeout(pollPaymentStatus, POLL_INTERVAL);
                    }
                })
                .catch(err => {
                    console.error('Poll error:', err);
                    setTimeout(pollPaymentStatus, POLL_INTERVAL);
                });
        }

        function showPaid() {
            const icon = document.getElementById('statusIcon');
            const title = document.getElementById('statusTitle');
            const subtitle = document.getElementById('statusSubtitle');
            const badge = document.getElementById('paymentBadge');
            const actions = document.getElementById('actionButtons');

            if (icon) {
                icon.className = 'pr-icon pr-icon-success';
                icon.innerHTML = '<i class="fas fa-check"></i>';
            }
            if (title) title.textContent = 'Thanh toán thành công!';
            if (subtitle) subtitle.textContent = 'Cảm ơn bạn đã mua hàng tại Nông Sản Farmily.';
            if (badge) {
                badge.textContent = 'Đã thanh toán';
                badge.className = 'pr-payment-badge pr-badge-paid';
            }
            if (actions) {
                actions.innerHTML =
                    '<a href="' + window.contextPath + '/order-confirmation?id=' + window.orderId + '" class="pr-btn pr-btn-primary">' +
                    '<i class="fas fa-receipt"></i> Xem chi tiết đơn hàng</a>' +
                    '<a href="' + window.contextPath + '/san-pham" class="pr-btn pr-btn-secondary">' +
                    '<i class="fas fa-shopping-bag"></i> Tiếp tục mua sắm</a>';
            }
        }

        function showExpired() {
            updateStatus('pr-icon-error', 'fa-clock', 'Thanh toán đã hết hạn',
                'Phiên thanh toán đã quá hạn. Bạn có thể tạo lại thanh toán mới.',
                '<a href="' + window.contextPath + '/don-hang/' + window.orderId + '" class="pr-btn pr-btn-primary">' +
                '<i class="fas fa-redo"></i> Thanh toán lại</a>' +
                '<a href="' + window.contextPath + '/" class="pr-btn pr-btn-secondary">' +
                '<i class="fas fa-home"></i> Về trang chủ</a>');
        }

        function showFailed() {
            updateStatus('pr-icon-error', 'fa-times', 'Thanh toán thất bại',
                'Giao dịch không thành công. Bạn có thể thử lại.',
                '<a href="' + window.contextPath + '/don-hang/' + window.orderId + '" class="pr-btn pr-btn-primary">' +
                '<i class="fas fa-redo"></i> Thử lại</a>' +
                '<a href="' + window.contextPath + '/" class="pr-btn pr-btn-secondary">' +
                '<i class="fas fa-home"></i> Về trang chủ</a>');
        }

        function showTimeout() {
            updateStatus('pr-icon-cancel', 'fa-hourglass-end', 'Chưa nhận được xác nhận',
                'Nếu bạn đã thanh toán, hệ thống sẽ tự động cập nhật khi nhận được thông báo từ ngân hàng.',
                '<a href="' + window.contextPath + '/don-hang/' + window.orderId + '" class="pr-btn pr-btn-primary">' +
                '<i class="fas fa-eye"></i> Xem đơn hàng</a>' +
                '<a href="' + window.contextPath + '/" class="pr-btn pr-btn-secondary">' +
                '<i class="fas fa-home"></i> Về trang chủ</a>');
        }

        function updateStatus(iconClass, iconName, titleText, subtitleText, actionsHtml) {
            const icon = document.getElementById('statusIcon');
            const title = document.getElementById('statusTitle');
            const subtitle = document.getElementById('statusSubtitle');
            const actions = document.getElementById('actionButtons');
            const badge = document.getElementById('paymentBadge');

            if (icon) { icon.className = 'pr-icon ' + iconClass; icon.innerHTML = '<i class="fas ' + iconName + '"></i>'; }
            if (title) title.textContent = titleText;
            if (subtitle) subtitle.textContent = subtitleText;
            if (actions) actions.innerHTML = actionsHtml;
            if (badge) badge.textContent = titleText;
        }

        // Start polling after a short delay (give IPN time to arrive)
        setTimeout(pollPaymentStatus, 1500);
    })();
    </script>
</body>
</html>
