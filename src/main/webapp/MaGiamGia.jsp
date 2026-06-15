<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mã Giảm Giá - Farmily</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=5">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MaGiamGia.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
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
                    Mã Giảm Giá
                </li>
            </ol>
        </div>
    </nav>

    <main class="coupon-page">
        <div class="coupon-page-header">
            <h1><i class="fas fa-ticket-alt"></i> Mã Giảm Giá</h1>
            <p>Sao chép mã và sử dụng khi thanh toán để nhận ưu đãi</p>
        </div>

        <c:choose>
            <c:when test="${empty coupons}">
                <div class="coupon-empty">
                    <i class="fas fa-ticket-alt"></i>
                    <p>Hiện chưa có mã giảm giá nào</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="coupon-grid">
                    <c:forEach var="coupon" items="${coupons}">
                        <div class="coupon-card ${coupon.discountType}">
                            <div class="coupon-left ${coupon.discountType}">
                                <i class="${coupon.discountType == 'freeship' ? 'fas fa-truck' : 'fas fa-tag'}"></i>
                                <div class="discount-val">${coupon.formattedDiscountValue}</div>
                            </div>
                            <div class="coupon-right">
                                <div class="coupon-code-row">
                                    <span class="coupon-code">${coupon.code}</span>
                                    <button class="btn-copy" onclick="copyCouponCode('${coupon.code}', this)">
                                        <i class="fas fa-copy"></i> Sao chép
                                    </button>
                                </div>
                                <div class="voucher-desc">
                                    <c:choose>
                                        <c:when test="${coupon.discountType == 'percent'}">
                                            Giảm ${coupon.discountValue}%
                                            <c:if test="${coupon.maxDiscount != null && coupon.maxDiscount > 0}">
                                                tối đa <fmt:formatNumber value="${coupon.maxDiscount}" pattern="#,##0"/>đ
                                            </c:if>
                                        </c:when>
                                        <c:when test="${coupon.discountType == 'freeship'}">
                                            Miễn phí vận chuyển
                                        </c:when>
                                        <c:otherwise>
                                            Giảm <fmt:formatNumber value="${coupon.discountValue}" pattern="#,##0"/>đ
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${coupon.expiringSoon}">
                                        <span class="voucher-tag-expiring">Sắp hết hạn</span>
                                    </c:if>
                                </div>
                                <div class="voucher-condition">${coupon.formattedMinOrderValue}</div>
                                <p class="coupon-expiry">
                                    HSD: <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy"/>
                                </p>
                                <div class="coupon-action">
                                    <c:choose>
                                        <c:when test="${userCouponStatuses[coupon.id] == 'used'}">
                                            <button class="btn-coupon-status used" disabled>
                                                <i class="fas fa-check-double"></i> Đã dùng
                                            </button>
                                        </c:when>
                                        <c:when test="${userCouponStatuses[coupon.id] == 'saved'}">
                                            <button class="btn-coupon-status saved" disabled>
                                                <i class="fas fa-bookmark"></i> Đã lưu
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-coupon-status save" onclick="toggleSaveCoupon(${coupon.id}, this)">
                                                <i class="far fa-bookmark"></i> Lưu mã
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <div id="copy-toast"></div>
    </main>

    <jsp:include page="common/footer.jsp" />

    <script>
        var contextPath = '${pageContext.request.contextPath}';
        var isLoggedIn = ${not empty sessionScope.auth};

        function copyCouponCode(code, btn) {
            navigator.clipboard.writeText(code).then(function() {
                onCopySuccess(code, btn);
            }).catch(function() {
                var textarea = document.createElement('textarea');
                textarea.value = code;
                textarea.style.position = 'fixed';
                textarea.style.opacity = '0';
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
                onCopySuccess(code, btn);
            });
        }

        function onCopySuccess(code, btn) {
            btn.classList.add('copied');
            btn.innerHTML = '<i class="fas fa-check"></i> Đã chép';
            showToast('Đã sao chép mã: ' + code);
            setTimeout(function() {
                btn.classList.remove('copied');
                btn.innerHTML = '<i class="fas fa-copy"></i> Sao chép';
            }, 2000);
        }

        function showToast(message) {
            var toast = document.getElementById('copy-toast');
            toast.textContent = message;
            toast.classList.add('show');
            setTimeout(function() { toast.classList.remove('show'); }, 2000);
        }

        function toggleSaveCoupon(couponId, btn) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/dang-nhap';
                return;
            }
            
            btn.disabled = true;
            var url = contextPath + '/api/coupon/save';
            
            fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'couponId=' + couponId
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (!data.success) {
                    btn.disabled = false;
                    showToast(data.message || 'Có lỗi xảy ra');
                } else {
                    btn.className = 'btn-coupon-status saved';
                    btn.innerHTML = '<i class="fas fa-bookmark"></i> Đã lưu';
                    showToast('Đã lưu mã thành công');
                }
            })
            .catch(function() {
                btn.disabled = false;
            });
        }
    </script>

</body>

</html>
