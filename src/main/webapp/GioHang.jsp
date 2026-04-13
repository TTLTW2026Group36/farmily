<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ Hàng - Nông Sản Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GioHang.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
                                            <div class="cb-wrap">
                                                <input type="checkbox" class="cb" id="selectAllTop"
                                                    onclick="toggleSelectAll(this)" checked>
                                            </div>
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
                                            data-product-id="${item.productId}" data-price="${item.unitPrice}"
                                            data-stock="${item.stock}">
                                            <td class="col-check">
                                                <div class="cb-wrap">
                                                    <input type="checkbox" class="cb cart-item-check"
                                                        data-item-id="${item.id}" onclick="onItemCheckChange()" checked>
                                                </div>
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
                                                        <div class="variant-chips" id="variant-chips-${item.id}"
                                                            data-item-id="${item.id}" data-original="${item.variantId}">
                                                            <c:forEach var="variant" items="${item.product.variants}">
                                                                <span
                                                                    class="variant-chip ${variant.id == item.variantId ? 'active' : ''}"
                                                                    data-variant-id="${variant.id}"
                                                                    data-price="${variant.price}"
                                                                    data-stock="${variant.stock}"
                                                                    onclick="onChipClick(${item.id}, ${variant.id}, this)">
                                                                    <c:out value="${variant.optionsValue}" />
                                                                </span>
                                                            </c:forEach>
                                                        </div>
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
                                                <c:if test="${item.stock > 0 && item.stock <= 5}">
                                                    <span class="low-stock-warn" id="stock-warn-${item.id}">Còn lại ${item.stock} sản phẩm</span>
                                                </c:if>
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