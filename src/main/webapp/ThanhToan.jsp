<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - Nông Sản Farmily</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ThanhToan.css">
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
                  <i class="fas fa-home"></i> Trang chủ
                </a>
              </li>
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/gio-hang">Giỏ hàng</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
            </ol>
          </div>
        </nav>

        <main class="ThanhToan_container">
          <div class="checkout">
            
            <section class="checkout-info">
              <form class="checkout-form" id="checkoutForm" novalidate>

                
                <c:if test="${isLoggedIn and not empty addresses}">
                  <div class="form-row">
                    <label for="addressBook">Sổ địa chỉ</label>
                    <select id="addressBook" name="addressId">
                      <option value="new">Địa chỉ mới...</option>
                      <c:forEach var="addr" items="${addresses}">
                        <option value="${addr.id}" data-receiver="${addr.receiver}" data-detail="${addr.addressDetail}"
                          data-district="${addr.district}" data-city="${addr.city}" <c:if test="${addr['default']}">
                          selected
                </c:if>>
                ${addr.displayText}
                </option>
                </c:forEach>
                </select>
          </div>
          </c:if>

          <div class="form-row">
            <label for="email">Email <span class="required">*</span></label>
            <input id="email" name="email" type="email" placeholder="email@domain.com" required value="${userEmail}" />
          </div>

          <div class="form-split">
            <div class="form-row">
              <label for="fullname">Họ và tên <span class="required">*</span></label>
              <input id="fullname" name="fullname" type="text" placeholder="Nguyễn Văn A" required
                value="${userName}" />
            </div>
            <div class="form-row">
              <label for="phone">Số điện thoại <span class="required">*</span></label>
              <input id="phone" name="phone" type="tel" placeholder="09xx xxx xxx" required value="${userPhone}" />
            </div>
          </div>

          <div class="form-row">
            <label for="street">Địa chỉ <span class="required">*</span></label>
            <input id="street" name="street" type="text" placeholder="Số nhà, tên đường..." required />
          </div>

          <div class="form-split">
            
            <div class="form-row">
              <label for="province">Tỉnh/Thành <span class="required">*</span></label>
              <select id="province" name="province" required>
                <option value="">-- Chọn Tỉnh/Thành --</option>
              </select>
              <input id="province-fallback" name="province-fallback" type="text" placeholder="VD: TP Hồ Chí Minh"
                style="display:none;" />
            </div>

            
            <div class="form-row">
              <label for="district">Quận/Huyện <span class="required">*</span></label>
              <select id="district" name="district" required disabled>
                <option value="">-- Chọn Quận/Huyện --</option>
              </select>
              <input id="district-fallback" name="district-fallback" type="text" placeholder="VD: Thành phố Thủ Đức"
                style="display:none;" />
            </div>

            
            <div class="form-row">
              <label for="ward">Phường/Xã</label>
              <select id="ward" name="ward" disabled>
                <option value="">-- Chọn Phường/Xã --</option>
              </select>
              <input id="ward-fallback" name="ward-fallback" type="text" placeholder="VD: Linh Trung"
                style="display:none;" />
            </div>
          </div>

          <div class="form-row">
            <label for="note">Ghi chú (tuỳ chọn)</label>
            <textarea id="note" name="note" rows="3" placeholder="Ví dụ: Giao giờ hành chính..."></textarea>
          </div>

          
          <div class="panel">
            <h2>Phương thức thanh toán</h2>
            <c:forEach var="pm" items="${paymentMethods}" varStatus="status">
              <label class="radio">
                <input type="radio" name="payment" value="${pm.id}" <c:if test="${status.first}">checked</c:if> />
                <i class="fas ${pm.iconClass}"></i>
                ${pm.methodName}
              </label>
            </c:forEach>

            
            <c:if test="${empty paymentMethods}">
              <label class="radio">
                <input type="radio" name="payment" value="1" checked />
                <i class="fas fa-money-bill-wave"></i>
                Thanh toán khi giao hàng (COD)
              </label>
            </c:if>
          </div>
          </form>
          </section>

          
          <aside class="checkout-summary" aria-label="Tóm tắt đơn hàng">
            <h2 class="sum-title">Đơn hàng (<span id="itemCount">${cart.totalItems}</span> sản phẩm)</h2>

            <div id="orderItems" class="order-items">
              <c:forEach var="item" items="${cart.items}">
                <div class="order-item">
                  <img
                    src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/images/placeholder.jpg')}"
                    alt="${item.productName}">
                  <p class="order-name">
                    ${item.productName}
                    <c:if test="${not empty item.variantText}">
                      <small class="variant-text">(${item.variantText})</small>
                    </c:if>
                  </p>
                  <span class="order-qty" title="Số lượng">x${item.quantity}</span>
                  <span class="order-price">${item.formattedSubtotal}</span>
                </div>
              </c:forEach>
            </div>

            
            <c:if test="${subtotal < freeShippingThreshold}">
              <div class="free-ship-notice">
                <i class="fas fa-truck"></i>
                Mua thêm <strong>
                  <fmt:formatNumber value="${freeShippingThreshold - subtotal}" type="number" groupingUsed="true" />đ
                </strong>
                để được <strong>MIỄN PHÍ VẬN CHUYỂN</strong>
              </div>
            </c:if>

            <div class="totals">
              <p>
                Tạm tính
                <span id="subtotalText">
                  <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true" />đ
                </span>
              </p>
              <p>
                Phí vận chuyển
                <span id="shippingFeeText">
                  <c:choose>
                    <c:when test="${shippingFee == 0}">
                      <span class="free-shipping">Miễn phí</span>
                    </c:when>
                    <c:otherwise>
                      <fmt:formatNumber value="${shippingFee}" type="number" groupingUsed="true" />đ
                    </c:otherwise>
                  </c:choose>
                </span>
              </p>
              <p class="grand">
                Tổng cộng
                <strong id="grandTotalText">
                  <fmt:formatNumber value="${total}" type="number" groupingUsed="true" />đ
                </strong>
              </p>
            </div>

            <div class="actions">
              <a href="${pageContext.request.contextPath}/gio-hang" class="back-link">
                ← Quay về giỏ hàng
              </a>
              <button id="placeOrder" class="submit-btn" type="button">
                <i class="fas fa-lock"></i> ĐẶT HÀNG
              </button>
            </div>
          </aside>
          </div>
        </main>

        
        <jsp:include page="common/footer.jsp" />

        
        <script>
          window.contextPath = '${pageContext.request.contextPath}';
          window.isLoggedIn = <c:out value="${isLoggedIn != null ? isLoggedIn : false}" />;
          window.subtotal = <c:out value="${subtotal != null ? subtotal : 0}" />;
          window.freeShippingThreshold = <c:out value="${freeShippingThreshold != null ? freeShippingThreshold : 100000}" />;
          window.standardShippingFee = 30000;
        </script>
        <script src="${pageContext.request.contextPath}/js/ThanhToan.js"></script>
      </body>

      </html>