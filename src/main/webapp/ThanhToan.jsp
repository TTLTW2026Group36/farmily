<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

      <!DOCTYPE html>
      <html lang="vi">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán - Nông Sản Farmily</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ThanhToan.css?v=3">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=3">
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
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/gio-hang">Giỏ hàng</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
            </ol>
          </div>
        </nav>

        <main class="ThanhToan_container">
          <c:if test="${isLoggedIn}">
            <section class="address-book-section" id="addressBookSection">
              <div class="address-book-header">
                <h2><i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng</h2>
                <c:if test="${not empty addresses}">
                  <button type="button" class="btn-add-address-sm" id="btnOpenAddressModal">
                    <i class="fas fa-plus"></i> Thêm địa chỉ mới
                  </button>
                </c:if>
              </div>

              <c:choose>
                <c:when test="${not empty addresses}">
                  <div class="address-selector" id="addressSelector">
                    <div class="address-selected-box" id="addressSelectTrigger">
                      <div class="selected-content" id="selectedAddressDisplay">
                        <i class="fas fa-spinner fa-spin"></i> Đang tải...
                      </div>
                      <i class="fas fa-chevron-down arrow-icon"></i>
                    </div>

                    <div class="address-options-wrapper" id="addressOptionsWrapper">
                      <div class="address-options-list">
                        <c:forEach var="addr" items="${addresses}">
                          <div class="address-option-item ${addr['default'] ? 'selected' : ''}"
                            data-address-id="${addr.id}" data-receiver="${addr.receiver}" data-phone="${addr.phone}"
                            data-detail="${addr.addressDetail}" data-district="${addr.district}"
                            data-city="${addr.city}" data-full="${addr.fullAddress}">
                            <div class="option-check">
                              <i class="fas fa-check"></i>
                            </div>
                            <div class="option-info">
                              <div class="option-top">
                                <span class="option-name">${addr.receiver}</span>
                                <span class="option-divider">|</span>
                                <span class="option-phone">${addr.phone}</span>
                              </div>
                              <p class="option-address-text">${addr.fullAddress}</p>
                            </div>
                            <c:if test="${addr['default']}">
                              <span class="option-default-tag">Mặc định</span>
                            </c:if>
                          </div>
                        </c:forEach>
                      </div>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="address-placeholder-box" id="btnOpenAddressModalEmpty">
                    <i class="fas fa-plus-circle"></i>
                    <span>Sổ địa chỉ trống. Nhấp để thêm địa chỉ giao hàng mới.</span>
                  </div>
                </c:otherwise>
              </c:choose>
            </section>
          </c:if>
          <div class="checkout">
            <section class="checkout-info">
              <div class="checkout-products">
                <h2 class="section-heading">
                  <i class="fas fa-shopping-bag"></i>
                  Sản phẩm đặt mua (<span id="cartTitleCount">${cart.items.size()}</span> sản phẩm)
                </h2>

                <div class="checkout-table-wrap">
                  <table class="checkout-table" aria-label="Danh sách sản phẩm">
                    <thead>
                      <tr>
                        <th class="ct-col-product">Sản Phẩm</th>
                        <th class="ct-col-variant">Phân Loại</th>
                        <th class="ct-col-price">Đơn Giá</th>
                        <th class="ct-col-qty">Số Lượng</th>
                        <th class="ct-col-total">Thành Tiền</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="item" items="${cart.items}">
                        <tr class="checkout-row">
                          <td class="ct-col-product">
                            <div class="ct-prod-cell">
                              <img class="ct-prod-img"
                                src="${not empty item.imageUrl ? item.imageUrl : pageContext.request.contextPath.concat('/images/placeholder.jpg')}"
                                alt="${item.productName}">
                              <span class="ct-prod-name">
                                <c:out value="${item.productName}" />
                              </span>
                            </div>
                          </td>
                          <td class="ct-col-variant" data-label="Phân loại">
                            <c:choose>
                              <c:when test="${not empty item.variantText}">
                                <span class="ct-variant-chip">${item.variantText}</span>
                              </c:when>
                              <c:otherwise>
                                <span class="ct-no-variant">—</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td class="ct-col-price" data-label="Đơn giá">
                            <c:choose>
                              <c:when test="${item.hasFlashSalePrice()}">
                                <span class="ct-price-sale">
                                  <fmt:formatNumber value="${item.unitPrice}" pattern="#,###" />đ
                                </span>
                                <span class="ct-price-orig">
                                  <fmt:formatNumber value="${item.originalUnitPrice}" pattern="#,###" />đ
                                </span>
                              </c:when>
                              <c:otherwise>
                                <span class="ct-price-main">
                                  <c:out value="${item.formattedUnitPrice}" />
                                </span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td class="ct-col-qty" data-label="Số lượng">${item.quantity}</td>
                          <td class="ct-col-total" data-label="Thành tiền">
                            <span class="ct-subtotal">${item.formattedSubtotal}</span>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>

              <form class="checkout-form" id="checkoutForm" novalidate>
                <input type="hidden" id="selectedAddressId" name="addressId" value="">
                <input type="hidden" name="isBuyNow" value="${isBuyNow}">

                <c:if test="${!isLoggedIn}">
                  <h2 class="section-heading"><i class="fas fa-user"></i> Thông tin người nhận</h2>
                </c:if>

                <c:if test="${isLoggedIn && empty addresses}">
                  <h2 class="section-heading"><i class="fas fa-user"></i> Thông tin giao hàng</h2>
                </c:if>

                <div id="manualAddressFields" style="${isLoggedIn && not empty addresses ? 'display:none' : ''}">
                  <div class="form-row">
                    <label for="email">Email <span class="required">*</span></label>
                    <input id="email" name="email" type="email" placeholder="email@domain.com" required
                      value="${userEmail}" />
                  </div>

                  <div class="form-split">
                    <div class="form-row">
                      <label for="fullname">Họ và tên <span class="required">*</span></label>
                      <input id="fullname" name="fullname" type="text" placeholder="Nguyễn Văn A" required
                        value="${userName}" />
                    </div>
                    <div class="form-row">
                      <label for="phone">Số điện thoại <span class="required">*</span></label>
                      <input id="phone" name="phone" type="tel" placeholder="09xx xxx xxx" required
                        value="${userPhone}" />
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
                      <input id="province-fallback" name="province-fallback" type="text"
                        placeholder="VD: TP Hồ Chí Minh" style="display:none;" />
                    </div>
                    <div class="form-row">
                      <label for="district">Quận/Huyện <span class="required">*</span></label>
                      <select id="district" name="district" required disabled>
                        <option value="">-- Chọn Quận/Huyện --</option>
                      </select>
                      <input id="district-fallback" name="district-fallback" type="text"
                        placeholder="VD: Thành phố Thủ Đức" style="display:none;" />
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
              <h2 class="sum-title">Tóm tắt đơn hàng</h2>

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

              <div class="checkout-actions">
                <a href="${pageContext.request.contextPath}/gio-hang" class="back-link">← Quay về giỏ hàng</a>
                <button id="placeOrder" class="submit-btn" type="button">
                  <i class="fas fa-lock"></i> ĐẶT HÀNG
                </button>
              </div>
            </aside>
          </div>
        </main>

        <div class="modal-overlay" id="addressModalOverlay">
          <div class="modal-dialog" role="dialog" aria-labelledby="modalTitle" aria-modal="true">
            <div class="modal-header">
              <h3 id="modalTitle"><i class="fas fa-plus-circle"></i> Thêm địa chỉ mới</h3>
              <button type="button" class="modal-close" id="btnCloseModal" aria-label="Đóng">
                <i class="fas fa-times"></i>
              </button>
            </div>
            <form id="addressModalForm" novalidate>
              <div class="modal-body">
                <div id="modalError" class="modal-alert error"></div>
                <div class="form-row">
                  <label for="modalReceiver">Họ tên người nhận <span class="required">*</span></label>
                  <input id="modalReceiver" type="text" placeholder="Nguyễn Văn A" required />
                </div>
                <div class="form-row">
                  <label for="modalPhone">Số điện thoại <span class="required">*</span></label>
                  <input id="modalPhone" type="tel" placeholder="09xx xxx xxx" required />
                </div>
                <div class="form-split">
                  <div class="form-row">
                    <label for="modalProvince">Tỉnh/Thành <span class="required">*</span></label>
                    <select id="modalProvince" required>
                      <option value="">-- Chọn Tỉnh/Thành --</option>
                    </select>
                  </div>
                  <div class="form-row">
                    <label for="modalDistrict">Quận/Huyện <span class="required">*</span></label>
                    <select id="modalDistrict" required disabled>
                      <option value="">-- Chọn Quận/Huyện --</option>
                    </select>
                  </div>
                </div>
                <div class="form-row">
                  <label for="modalWard">Phường/Xã</label>
                  <select id="modalWard" disabled>
                    <option value="">-- Chọn Phường/Xã --</option>
                  </select>
                </div>
                <div class="form-row">
                  <label for="modalDetail">Địa chỉ chi tiết <span class="required">*</span></label>
                  <input id="modalDetail" type="text" placeholder="Số nhà, tên đường, tòa nhà..." required />
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn-modal-cancel" id="btnCancelModal">Hủy</button>
                <button type="submit" class="btn-modal-save" id="btnSaveAddress">
                  <i class="fas fa-save"></i> Lưu địa chỉ
                </button>
              </div>
            </form>
          </div>
        </div>
    <div id="sepay-form-container" style="display:none;"></div>

        <jsp:include page="common/footer.jsp" />

        <script>
          window.contextPath = '${pageContext.request.contextPath}';
          window.isLoggedIn = <c:out value="${isLoggedIn != null ? isLoggedIn : false}" />;
          window.subtotal = <c:out value="${subtotal != null ? subtotal : 0}" />;
          window.freeShippingThreshold = <c:out value="${freeShippingThreshold != null ? freeShippingThreshold : 100000}" />;
          window.standardShippingFee = 30000;
          window.userEmail = '${userEmail}';
          window.userName = '${userName}';
          window.userPhone = '${userPhone}';
        </script>
        <script src="${pageContext.request.contextPath}/js/ThanhToan.js?v=2"></script>
      </body>

      </html>