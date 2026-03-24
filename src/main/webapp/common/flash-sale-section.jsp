<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            
            <c:if test="${not empty flashSales}">
                <section class="flash-sale-section">
                    <div class="container">
                        <div class="section-header-flash">
                            <div class="flash-title">
                                <i class="fas fa-bolt"></i>
                                <h2>FLASH SALE</h2>
                                <div class="countdown">
                                    <span class="countdown-label">Kết thúc trong:</span>
                                    <div class="countdown-timer" data-end-time="${flashSaleEndTime}">
                                        <div class="time-box">
                                            <span id="hours">00</span>
                                            <small>Giờ</small>
                                        </div>
                                        <span class="separator">:</span>
                                        <div class="time-box">
                                            <span id="minutes">00</span>
                                            <small>Phút</small>
                                        </div>
                                        <span class="separator">:</span>
                                        <div class="time-box">
                                            <span id="seconds">00</span>
                                            <small>Giây</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/gia-tot" class="view-all-flash">Xem tất cả <i
                                    class="fas fa-arrow-right"></i></a>
                        </div>
                        <div class="flash-products-wrapper">
                            <button class="flash-scroll-btn flash-prev" aria-label="Xem sản phẩm trước">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <div class="flash-products-scroll">
                                <c:forEach var="sale" items="${flashSales}">
                                    <div class="flash-product-item">
                                        <div class="product-badges">
                                            <span class="badge badge-sale">SALE</span>
                                        </div>
                                        <div class="discount-badge">-
                                            <fmt:formatNumber value="${sale.discountPercent}" maxFractionDigits="0" />%
                                        </div>
                                        <div class="product-img">
                                            <a
                                                href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${sale.product.id}">
                                                <c:choose>
                                                    <c:when test="${not empty sale.product.primaryImageUrl}">
                                                        <img src="${sale.product.primaryImageUrl}"
                                                            alt="${sale.product.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                            alt="${sale.product.name}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </div>
                                        <h3><a
                                                href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${sale.product.id}">${sale.product.name}</a>
                                        </h3>
                                        <div class="product-price">
                                            <span class="new-price">
                                                <fmt:formatNumber value="${sale.salePrice}" pattern="#,###" />đ
                                            </span>
                                            <span class="old-price">
                                                <fmt:formatNumber value="${sale.originalPrice}" pattern="#,###" />đ
                                            </span>
                                        </div>
                                        <div class="sold-progress">
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width: ${sale.soldPercentage}%"></div>
                                            </div>
                                            <span class="sold-text">Đã bán ${sale.soldCount}/${sale.stockLimit}</span>
                                        </div>
                                        <button class="btn-add-flash"
                                            onclick="addToCart(${sale.product.id}, ${not empty sale.product.variants ? sale.product.variants[0].id : 0})">
                                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                                        </button>
                                    </div>
                                </c:forEach>
                            </div>
                            <button class="flash-scroll-btn flash-next" aria-label="Xem sản phẩm tiếp theo">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </section>
            </c:if>