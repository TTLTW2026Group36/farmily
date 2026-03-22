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
                    * {
                        box-sizing: border-box;
                        margin: 0;
                        padding: 0;
                    }

                    body {
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
                        background: #f5f5f5;
                        color: #333;
                        font-size: 14px;
                    }

                    .gh-wrap {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 16px 16px 24px;
                    }

                    .gh-title {
                        font-size: 20px;
                        font-weight: 600;
                        color: #222;
                        margin-bottom: 16px;
                    }

                    /* ── Table ── */
                    .cart-table {
                        width: 100%;
                        background: #fff;
                        border-radius: 4px;
                        border: 1px solid #e8e8e8;
                        border-collapse: collapse;
                        overflow: hidden;
                    }

                    .cart-table thead tr {
                        background: #fafafa;
                        border-bottom: 1px solid #e8e8e8;
                    }

                    .cart-table th {
                        padding: 12px 10px;
                        font-weight: 500;
                        color: #555;
                        font-size: 13px;
                        white-space: nowrap;
                    }

                    .cart-table td {
                        padding: 16px 10px;
                        vertical-align: middle;
                        border-bottom: 1px solid #f0f0f0;
                    }

                    .cart-table tbody tr:last-child td {
                        border-bottom: none;
                    }

                    .cart-table tbody tr.row-selected td {
                        background: #fffbe6;
                    }

                    /* Column widths */
                    .col-check {
                        width: 48px;
                        text-align: center;
                    }

                    .col-product {
                        min-width: 260px;
                    }

                    .col-variant {
                        width: 150px;
                    }

                    .col-price {
                        width: 110px;
                        text-align: center;
                    }

                    .col-qty {
                        width: 120px;
                        text-align: center;
                    }

                    .col-total {
                        width: 110px;
                        text-align: center;
                    }

                    .col-action {
                        width: 80px;
                        text-align: center;
                    }

                    .cb {
                        width: 16px;
                        height: 16px;
                        cursor: pointer;
                        accent-color: #ee4d2d;
                    }

                    .prod-cell {
                        display: flex;
                        align-items: flex-start;
                        gap: 12px;
                    }

                    .prod-img {
                        width: 72px;
                        height: 72px;
                        object-fit: cover;
                        border: 1px solid #e8e8e8;
                        border-radius: 2px;
                        flex-shrink: 0;
                    }

                    .prod-name {
                        font-size: 13px;
                        color: #333;
                        line-height: 1.4;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                        text-decoration: none;
                    }

                    .prod-name:hover {
                        color: #ee4d2d;
                    }

                    .variant-sel {
                        width: 100%;
                        padding: 5px 8px;
                        border: 1px solid #d9d9d9;
                        border-radius: 2px;
                        font-size: 12px;
                        color: #333;
                        background: #fff;
                        cursor: pointer;
                    }

                    .variant-sel:focus {
                        outline: none;
                        border-color: #ee4d2d;
                    }

                    .no-variant {
                        color: #999;
                        font-size: 12px;
                    }

                    .price-main {
                        color: #ee4d2d;
                        font-weight: 500;
                        font-size: 14px;
                    }

                    .price-orig {
                        color: #999;
                        text-decoration: line-through;
                        font-size: 12px;
                        display: block;
                        margin-top: 2px;
                    }

                    .badge-sale {
                        display: inline-block;
                        background: #ee4d2d;
                        color: #fff;
                        font-size: 10px;
                        padding: 1px 4px;
                        border-radius: 2px;
                        margin-left: 4px;
                    }

                    .qty-ctrl {
                        display: inline-flex;
                        align-items: center;
                        border: 1px solid #d9d9d9;
                        border-radius: 2px;
                        overflow: hidden;
                    }

                    .qty-btn {
                        width: 30px;
                        height: 30px;
                        border: none;
                        background: #fff;
                        color: #555;
                        font-size: 14px;
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .qty-btn:hover:not(:disabled) {
                        background: #f5f5f5;
                    }

                    .qty-btn:disabled {
                        color: #ccc;
                        cursor: not-allowed;
                    }

                    .qty-input {
                        width: 44px;
                        height: 30px;
                        border: none;
                        border-left: 1px solid #d9d9d9;
                        border-right: 1px solid #d9d9d9;
                        text-align: center;
                        font-size: 13px;
                        font-weight: 500;
                    }

                    .qty-input:focus {
                        outline: none;
                    }

                    .subtotal-val {
                        color: #ee4d2d;
                        font-weight: 600;
                        font-size: 14px;
                    }

                    .del-btn {
                        background: none;
                        border: none;
                        color: #999;
                        font-size: 13px;
                        cursor: pointer;
                        padding: 4px 0;
                    }

                    .del-btn:hover {
                        color: #ee4d2d;
                    }

                    .empty-state {
                        background: #fff;
                        border: 1px solid #e8e8e8;
                        border-radius: 4px;
                        text-align: center;
                        padding: 80px 20px;
                        color: #999;
                    }

                    .empty-state i {
                        font-size: 56px;
                        margin-bottom: 16px;
                        display: block;
                        color: #d9d9d9;
                    }

                    .empty-state h2 {
                        font-size: 16px;
                        color: #666;
                        margin-bottom: 8px;
                    }

                    .empty-state a {
                        display: inline-block;
                        margin-top: 16px;
                        padding: 9px 24px;
                        background: #ee4d2d;
                        color: #fff;
                        border-radius: 2px;
                        text-decoration: none;
                        font-size: 14px;
                    }

                    .cart-bar {
                        position: sticky;
                        bottom: 0;
                        background: #fff;
                        border-top: 1px solid #e8e8e8;
                        border-bottom: 1px solid #e8e8e8;
                        z-index: 100;
                        box-shadow: 0 -2px 8px rgba(0, 0, 0, .06);
                        margin-top: 0;
                    }

                    .cart-bar-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 0 16px;
                        height: 60px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        gap: 16px;
                    }

                    .bar-left {
                        display: flex;
                        align-items: center;
                        gap: 20px;
                        flex-shrink: 0;
                    }

                    .bar-select-all {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        font-size: 14px;
                        color: #333;
                        cursor: pointer;
                        user-select: none;
                        white-space: nowrap;
                    }

                    .bar-btn {
                        background: none;
                        border: none;
                        font-size: 13px;
                        cursor: pointer;
                        white-space: nowrap;
                        padding: 0;
                    }

                    .bar-btn-del {
                        color: #555;
                    }

                    .bar-btn-del:hover {
                        color: #ee4d2d;
                    }

                    .bar-btn-wish {
                        color: #555;
                    }

                    .bar-btn-wish:hover {
                        color: #ee4d2d;
                    }

                    .bar-btn:disabled {
                        opacity: 0.4;
                        cursor: not-allowed;
                    }

                    .bar-right {
                        display: flex;
                        align-items: center;
                        gap: 24px;
                    }

                    .bar-total-info {
                        font-size: 13px;
                        color: #555;
                        white-space: nowrap;
                    }

                    .bar-total-info span {
                        color: #ee4d2d;
                        font-weight: 600;
                        font-size: 16px;
                    }

                    .bar-buy-btn {
                        padding: 0 32px;
                        height: 40px;
                        background: #ee4d2d;
                        color: #fff;
                        border: none;
                        border-radius: 2px;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        white-space: nowrap;
                    }

                    .bar-buy-btn:disabled {
                        background: #ccc;
                        cursor: not-allowed;
                    }

                    .site-breadcrumb {
                        background: #fff;
                        border-bottom: 1px solid #e8e8e8;
                    }

                    .breadcrumb-container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 8px 16px;
                    }

                    .breadcrumb-list {
                        list-style: none;
                        display: flex;
                        gap: 6px;
                        align-items: center;
                        font-size: 13px;
                    }

                    .breadcrumb-item a {
                        color: #555;
                        text-decoration: none;
                    }

                    .breadcrumb-item a:hover {
                        color: #ee4d2d;
                    }

                    .breadcrumb-item.active {
                        color: #ee4d2d;
                    }

                    .breadcrumb-item+.breadcrumb-item::before {
                        content: '/';
                        color: #ccc;
                        margin-right: 6px;
                    }

                    @media (max-width: 900px) {

                        .col-variant,
                        .col-price {
                            display: none;
                        }

                        .cart-bar-inner {
                            flex-wrap: wrap;
                            height: auto;
                            padding: 10px 16px;
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
                                <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
                        </ol>
                    </div>
                </nav>

                <div class="gh-wrap">
                    <h1 class="gh-title">Giỏ hàng<c:if test="${not empty cart.items}"> (<span
                                id="cartTitleCount">${cart.items.size()}</span> sản phẩm)</c:if>
                    </h1>

                    <c:choose>
                        <c:when test="${empty cart or empty cart.items}">
                            <div class="empty-state">
                                <i class="fas fa-shopping-cart"></i>
                                <h2>Giỏ hàng của bạn đang trống</h2>
                                <p>Hãy thêm sản phẩm vào giỏ hàng để tiến hành mua sắm</p>
                                <a href="${pageContext.request.contextPath}/san-pham">Tiếp tục mua sắm</a>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <table class="cart-table" aria-label="Giỏ hàng">
                                <thead>
                                    <tr>
                                        <th class="col-check">
                                            <input type="checkbox" class="cb" id="selectAllTop"
                                                onclick="toggleSelectAll(this)" checked>
                                        </th>
                                        <th class="col-product">Sản Phẩm</th>
                                        <th class="col-variant">Phân Loại</th>
                                        <th class="col-price">Đơn Giá</th>
                                        <th class="col-qty">Số Lượng</th>
                                        <th class="col-total">Số Tiền</th>
                                        <th class="col-action">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody id="cartTableBody">
                                    <c:forEach var="item" items="${cart.items}">
                                        <tr class="cart-row row-selected" data-item-id="${item.id}"
                                            data-price="${item.unitPrice}">
                                            <td class="col-check">
                                                <input type="checkbox" class="cb cart-item-check"
                                                    data-item-id="${item.id}" onclick="onItemCheckChange()" checked>
                                            </td>
                                            <td class="col-product">
                                                <div class="prod-cell">
                                                    <a
                                                        href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                                                        <img class="prod-img"
                                                            src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/images/placeholder.jpg')}"
                                                            alt="${item.productName}">
                                                    </a>
                                                    <a class="prod-name"
                                                        href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                                                        <c:out value="${item.productName}" />
                                                    </a>
                                                </div>
                                            </td>
                                            <td class="col-variant">
                                                <c:choose>
                                                    <c:when test="${not empty item.product.variants}">
                                                        <select class="variant-sel" id="variant-${item.id}"
                                                            onchange="updateVariant(${item.id}, this.value, this)"
                                                            data-original="${item.variantId}">
                                                            <c:forEach var="variant" items="${item.product.variants}">
                                                                <option value="${variant.id}"
                                                                    data-price="${variant.price}"
                                                                    data-stock="${variant.stock}"
                                                                    ${variant.id==item.variantId ? 'selected' : '' }>
                                                                    <c:out value="${variant.optionsValue}" />
                                                                    -
                                                                    <fmt:formatNumber value="${variant.price}"
                                                                        type="number" groupingUsed="true" />đ
                                                                    <c:if test="${variant.stock <= 5}">(Còn
                                                                        ${variant.stock})</c:if>
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="no-variant">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="col-price">
                                                <span id="price-${item.id}">
                                                    <c:choose>
                                                        <c:when test="${item.hasFlashSalePrice()}">
                                                            <span class="price-main">
                                                                <fmt:formatNumber value="${item.unitPrice}"
                                                                    pattern="#,###" />đ
                                                            </span>
                                                            <span class="price-orig">
                                                                <fmt:formatNumber value="${item.originalUnitPrice}"
                                                                    pattern="#,###" />đ
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="price-main">
                                                                <c:out value="${item.formattedUnitPrice}" />
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="col-qty">
                                                <div class="qty-ctrl" role="group" aria-label="Số lượng">
                                                    <button class="qty-btn minus" aria-label="Giảm"
                                                        onclick="changeQuantity(${item.id}, -1)" ${item.quantity <=1
                                                        ? 'disabled' : '' }>−</button>
                                                    <input class="qty-input" type="text" inputmode="numeric"
                                                        id="qty-${item.id}" value="${item.quantity}"
                                                        onchange="updateCartQuantity(${item.id}, this.value)">
                                                    <button class="qty-btn plus" aria-label="Tăng"
                                                        onclick="changeQuantity(${item.id}, 1)">+</button>
                                                </div>
                                            </td>
                                            <td class="col-total">
                                                <span class="subtotal-val" id="subtotal-${item.id}">
                                                    <c:out value="${item.formattedSubtotal}" />
                                                </span>
                                            </td>
                                            <td class="col-action">
                                                <button class="del-btn" title="Xóa"
                                                    onclick="removeCartItem(${item.id})">Xóa</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${not empty cart and not empty cart.items}">
                        <div class="cart-bar" role="toolbar" aria-label="Thanh giỏ hàng">
                            <div class="cart-bar-inner">
                                <div class="bar-left">
                                    <label class="bar-select-all" for="selectAllBar">
                                        <input type="checkbox" class="cb" id="selectAllBar"
                                            onclick="toggleSelectAll(this)" checked>
                                        Chọn Tất Cả (<span id="selectAllCount">${cart.items.size()}</span>)
                                    </label>
                                    <button class="bar-btn bar-btn-del" id="deleteSelectedBtn"
                                        onclick="deleteSelectedItems()">Xóa</button>
                                    <button class="bar-btn bar-btn-wish" id="wishSelectedBtn"
                                        onclick="saveToWishlist()">
                                        Lưu vào mục Yêu thích
                                    </button>
                                </div>
                                <div class="bar-right">
                                    <div class="bar-total-info">
                                        Tổng cộng (<span id="totalItems">${cart.items.size()}</span> sản phẩm):
                                        <span id="grandTotal">
                                            <c:out value="${cart.formattedTotalAmount}" />
                                        </span>
                                    </div>
                                    <button class="bar-buy-btn" id="checkoutBtn" onclick="proceedToCheckout()">
                                        Mua Hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <jsp:include page="common/footer.jsp" />

                <script>window.contextPath = '${pageContext.request.contextPath}';</script>
                <script src="${pageContext.request.contextPath}/js/GioHang.js"></script>
            </body>

            </html>