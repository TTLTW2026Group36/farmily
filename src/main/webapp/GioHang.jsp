<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Nông Sản Farmily</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GioHang.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Enhanced cart item styles */
        .cart-item {
            display: flex;
            gap: 16px;
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            position: relative;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
        }

        .item-thumb {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            flex-shrink: 0;
        }

        .item-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .item-name {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 8px 0;
            color: #1f2937;
        }

        .item-name a:hover {
            color: #16a34a;
        }

        /* Variant dropdown styles */
        .variant-select-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 8px;
        }

        .variant-select {
            appearance: none;
            -webkit-appearance: none;
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 8px 36px 8px 12px;
            font-size: 13px;
            color: #374151;
            cursor: pointer;
            min-width: 150px;
            transition: all 0.2s;
        }

        .variant-select:hover {
            border-color: #16a34a;
            background: #f0fdf4;
        }

        .variant-select:focus {
            outline: none;
            border-color: #16a34a;
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
        }

        .variant-select-wrapper::after {
            content: '▼';
            font-size: 10px;
            color: #6b7280;
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
        }

        .item-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .item-unit-price {
            font-size: 15px;
            color: #16a34a;
            font-weight: 600;
            min-width: 100px;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            overflow: hidden;
        }

        .qty-btn {
            width: 36px;
            height: 36px;
            border: none;
            background: #f9fafb;
            color: #374151;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .qty-btn:hover {
            background: #16a34a;
            color: #fff;
        }

        .qty-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .qty-btn:disabled:hover {
            background: #f9fafb;
            color: #374151;
        }

        .qty-input {
            width: 50px;
            height: 36px;
            border: none;
            border-left: 1px solid #e5e7eb;
            border-right: 1px solid #e5e7eb;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
        }

        .qty-input:focus {
            outline: none;
            background: #f0fdf4;
        }

        .item-subtotal {
            font-size: 16px;
            font-weight: 700;
            color: #dc2626;
            min-width: 110px;
            text-align: right;
        }

        .remove-btn {
            position: absolute;
            top: 12px;
            right: 12px;
            background: none;
            border: none;
            color: #9ca3af;
            cursor: pointer;
            font-size: 13px;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.2s;
        }

        .remove-btn:hover {
            background: #fef2f2;
            color: #dc2626;
        }

        .variant-label {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 4px;
        }

        @media (max-width: 768px) {
            .cart-item {
                flex-direction: column;
            }

            .item-thumb {
                width: 100%;
                height: 200px;
            }

            .item-row {
                flex-direction: column;
                align-items: flex-start;
            }
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
                    <i class="fas fa-home"></i>
                    Trang chủ
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                Giỏ hàng
            </li>
        </ol>
    </div>
</nav>

<main class="GioHang_container">
    <h1 class="page-title">Giỏ hàng <c:if test="${not empty cart.items}"><span
            style="font-weight: 400; font-size: 18px; color: #6b7280;">(${cart.totalItems} sản
                                phẩm)</span></c:if>
    </h1>

    <c:choose>
        
        <c:when test="${empty cart or empty cart.items}">
            <div class="empty-cart" style="text-align: center; padding: 60px 20px;">
                <i class="fas fa-shopping-cart"
                   style="font-size: 64px; color: #d1d5db; margin-bottom: 20px;"></i>
                <h2 style="color: #6b7280; margin-bottom: 16px;">Giỏ hàng của bạn đang trống</h2>
                <p style="color: #9ca3af; margin-bottom: 24px;">Hãy thêm sản phẩm vào giỏ hàng để
                    tiến hành mua sắm</p>
                <a href="${pageContext.request.contextPath}/san-pham" class="checkout-btn"
                   style="display: inline-block; text-decoration: none; padding: 12px 32px;">
                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                </a>
            </div>
        </c:when>

        
        <c:otherwise>
            <div class="cart">
                
                <section class="cart-items" aria-label="Danh sách sản phẩm trong giỏ">
                    <c:forEach var="item" items="${cart.items}">
                        <article class="cart-item" data-item-id="${item.id}"
                                 data-price="${item.unitPrice}" data-product-id="${item.productId}">
                            <button class="remove-btn" aria-label="Xóa sản phẩm"
                                    onclick="removeCartItem(${item.id})" title="Xóa khỏi giỏ hàng">
                                <i class="fas fa-times"></i> Xóa
                            </button>

                            <a
                                    href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                                <img class="item-thumb"
                                     src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/images/placeholder.jpg')}"
                                     alt="${item.productName}" />
                            </a>

                            <div class="item-info">
                                <div>
                                    <h2 class="item-name">
                                        <a
                                                href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                                            <c:out value="${item.productName}" />
                                        </a>
                                    </h2>

                                        
                                    <c:if test="${not empty item.product.variants}">
                                        <div class="variant-label">Phân loại:</div>
                                        <div class="variant-select-wrapper">
                                            <select class="variant-select"
                                                    id="variant-${item.id}"
                                                    onchange="updateVariant(${item.id}, this.value, this)"
                                                    data-original="${item.variantId}">
                                                <c:forEach var="variant"
                                                           items="${item.product.variants}">
                                                    <option value="${variant.id}"
                                                            data-price="${variant.price}"
                                                            data-stock="${variant.stock}"
                                                        ${variant.id==item.variantId
                                                                ? 'selected' : '' }>
                                                        <c:out
                                                                value="${variant.optionsValue}" />
                                                        -
                                                        <fmt:formatNumber
                                                                value="${variant.price}"
                                                                type="number"
                                                                groupingUsed="true" />đ
                                                        <c:if test="${variant.stock <= 5}">
                                                            (Còn ${variant.stock})</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="item-row">
                                                            <span class="item-unit-price" id="price-${item.id}"
                                                                  aria-label="Đơn giá">
                                                                <c:choose>
                                                                    <c:when test="${item.hasFlashSalePrice()}">
                                                                        <span style="color:#dc2626;font-weight:700">
                                                                            <fmt:formatNumber value="${item.unitPrice}"
                                                                                              pattern="#,###" />đ
                                                                        </span>
                                                                        <span
                                                                                style="text-decoration:line-through;color:#9ca3af;font-size:0.85em;margin-left:4px">
                                                                            <fmt:formatNumber
                                                                                    value="${item.originalUnitPrice}"
                                                                                    pattern="#,###" />đ
                                                                        </span>
                                                                        <span
                                                                                style="background:#dc2626;color:#fff;font-size:10px;padding:2px 5px;border-radius:4px;margin-left:4px">SALE</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:out value="${item.formattedUnitPrice}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>

                                    <div class="quantity-control" role="group"
                                         aria-label="Chọn số lượng">
                                        <button class="qty-btn minus" aria-label="Giảm số lượng"
                                                onclick="changeQuantity(${item.id}, -1)"
                                            ${item.quantity <=1 ? 'disabled' : '' }>
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input class="qty-input" type="text" inputmode="numeric"
                                               id="qty-${item.id}" value="${item.quantity}"
                                               onchange="updateCartQuantity(${item.id}, this.value)"
                                               aria-live="polite" />
                                        <button class="qty-btn plus" aria-label="Tăng số lượng"
                                                onclick="changeQuantity(${item.id}, 1)">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>

                                    <span class="item-subtotal" id="subtotal-${item.id}"
                                          aria-label="Thành tiền">
                                                                <c:out value="${item.formattedSubtotal}" />
                                                            </span>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </section>

                
                <aside class="cart-summary" aria-label="Tóm tắt đơn hàng">
                    <h3 style="margin: 0 0 16px 0; font-size: 18px;">Tóm tắt đơn hàng</h3>

                    <div class="summary-row"
                         style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                                <span>Tạm tính (<span id="totalItems">${cart.totalItems}</span> sản
                                                    phẩm)</span>
                        <strong class="cart-total" id="cartTotal">
                            <c:out value="${cart.formattedTotalAmount}" />
                        </strong>
                    </div>

                    <div class="summary-row"
                         style="display: flex; justify-content: space-between; margin-bottom: 12px; color: #6b7280;">
                        <span>Phí vận chuyển</span>
                        <span>Tính khi thanh toán</span>
                    </div>

                    <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 16px 0;">

                    <div class="summary-row"
                         style="display: flex; justify-content: space-between; margin-bottom: 20px; font-size: 18px;">
                        <strong>Tổng cộng</strong>
                        <strong style="color: #dc2626;" id="grandTotal">
                            <c:out value="${cart.formattedTotalAmount}" />
                        </strong>
                    </div>

                    <button class="checkout-btn" type="button" style="width: 100%;"
                            onclick="window.location.href='${pageContext.request.contextPath}/checkout'">
                        <i class="fas fa-lock"></i> Tiến hành thanh toán
                    </button>

                    <a class="continue-link" href="${pageContext.request.contextPath}/san-pham"
                       aria-label="Tiếp tục mua hàng"
                       style="display: block; text-align: center; margin-top: 16px; color: #16a34a; text-decoration: none;">
                        <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </aside>
            </div>
        </c:otherwise>
    </c:choose>
</main>


<jsp:include page="common/footer.jsp" />

<script>window.contextPath = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/js/GioHang.js"></script>
</body>

</html>