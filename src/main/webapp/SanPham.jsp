<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <c:choose>
                        <c:when test="${not empty selectedCategory}">${selectedCategory.name} - </c:when>
                        <c:when test="${not empty keyword}">Tìm kiếm: ${keyword} - </c:when>
                    </c:choose>
                    Sản Phẩm - Nông Sản Farmily
                </title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SanPham.css">
                <script>
                    window.contextPath = '${pageContext.request.contextPath}';
                </script>
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

                            <c:choose>
                                <c:when test="${not empty selectedCategory}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/san-pham">Sản phẩm</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        ${selectedCategory.name}
                                    </li>
                                </c:when>
                                <c:when test="${not empty keyword}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/san-pham">Sản phẩm</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Tìm kiếm: "${keyword}"
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Sản phẩm
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ol>
                    </div>
                </nav>

                <div class="products-container">

                    <aside class="products-sidebar">

                        <div class="filter-section">
                            <h3 class="filter-section-title">DANH MỤC SẢN PHẨM</h3>
                            <div class="filter-divider"></div>
                            <ul class="filter-list category-list">

                                <li class="filter-item">
                                    <a href="${pageContext.request.contextPath}/san-pham"
                                        class="filter-link ${empty selectedCategoryId ? 'active' : ''}">
                                        <i class="fas fa-th-large"></i> Tất cả sản phẩm
                                    </a>
                                </li>

                                <c:forEach var="category" items="${categories}">
                                    <li class="filter-item">
                                        <a href="${pageContext.request.contextPath}/san-pham?categoryId=${category.id}"
                                            class="filter-link ${selectedCategoryId == category.id ? 'active' : ''}">
                                            ${category.name}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </aside>


                    <main class="products-main-content">
                        <div class="page-header-toolbar">
                            <div class="header-section">
                                <div class="title-wrap">
                                    <div class="title-content">
                                        <h1 class="products-page-title">
                                            <c:choose>
                                                <c:when test="${not empty selectedCategory}">${selectedCategory.name}
                                                </c:when>
                                                <c:when test="${not empty keyword}">Kết quả tìm kiếm: "${keyword}"
                                                </c:when>
                                                <c:otherwise>Sản phẩm</c:otherwise>
                                            </c:choose>
                                        </h1>
                                        <span class="product-count">(${totalProducts} sản phẩm)</span>
                                    </div>
                                </div>
                            </div>

                            <div class="toolbar-section">
                                <div class="sort-buttons">
                                    <span class="sort-label">
                                        <i class="fas fa-sort-amount-down"></i>
                                        Sắp xếp:
                                    </span>
                                    <button
                                        class="sort-btn ${currentSort == 'default' || empty currentSort ? 'active' : ''}"
                                        data-sort="default">
                                        <i class="fas fa-th"></i>
                                        Mặc định
                                    </button>
                                    <button class="sort-btn ${currentSort == 'name-asc' ? 'active' : ''}"
                                        data-sort="name-asc">
                                        <i class="fas fa-sort-alpha-down"></i>
                                        A → Z
                                    </button>
                                    <button class="sort-btn ${currentSort == 'name-desc' ? 'active' : ''}"
                                        data-sort="name-desc">
                                        <i class="fas fa-sort-alpha-up"></i>
                                        Z → A
                                    </button>
                                    <button class="sort-btn ${currentSort == 'price-asc' ? 'active' : ''}"
                                        data-sort="price-asc">
                                        <i class="fas fa-arrow-up"></i>
                                        Giá tăng
                                    </button>
                                    <button class="sort-btn ${currentSort == 'price-desc' ? 'active' : ''}"
                                        data-sort="price-desc">
                                        <i class="fas fa-arrow-down"></i>
                                        Giá giảm
                                    </button>
                                    <button class="sort-btn ${currentSort == 'popular' ? 'active' : ''}"
                                        data-sort="popular">
                                        <i class="fas fa-fire"></i>
                                        Bán chạy
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="products-grid">
                            <c:choose>
                                <c:when test="${empty products}">
                                    <div class="no-products">
                                        <i class="fas fa-box-open"></i>
                                        <p>Không tìm thấy sản phẩm nào.</p>
                                        <a href="${pageContext.request.contextPath}/san-pham" class="btn-back">
                                            Xem tất cả sản phẩm
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="product" items="${products}">
                                        <div class="product-card">

                                            <c:if test="${product.soldCount > 50}">
                                                <div class="product-badges">
                                                    <span class="badge badge-hot">HOT</span>
                                                </div>
                                            </c:if>


                                            <button
                                                class="wishlist-btn ${wishlistProductIds.contains(product.id) ? 'active' : ''}"
                                                aria-label="Yêu thích" data-product-id="${product.id}">
                                                <i
                                                    class="${wishlistProductIds.contains(product.id) ? 'fas' : 'far'} fa-heart"></i>
                                            </button>

                                            <div class="product-image">
                                                <a
                                                    href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">
                                                    <c:choose>
                                                        <c:when test="${not empty product.primaryImageUrl}">
                                                            <img src="${product.primaryImageUrl}"
                                                                alt="${product.name}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/images/no-image.jpg"
                                                                alt="${product.name}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </div>

                                            <div class="product-info">
                                                <h3 class="product-title">
                                                    <a
                                                        href="${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}">
                                                        ${product.name}
                                                    </a>
                                                </h3>

                                                <p class="product-price">
                                                    <span class="price-current">
                                                        <fmt:formatNumber value="${product.minPrice}" type="number"
                                                            groupingUsed="true" />đ
                                                    </span>
                                                    <c:if test="${not empty product.minPriceVariant}">
                                                        <span
                                                            class="price-unit">/${product.minPriceVariant.optionsValue}</span>
                                                    </c:if>
                                                </p>
                                                <button class="add-to-cart-btn"
                                                    onclick="addToCart(${product.id}, ${not empty product.minPriceVariant ? product.minPriceVariant.id : 0})">
                                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>


                        <c:if test="${totalPages > 1}">
                            <div class="pagination">

                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${currentPage - 1}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty currentSort && currentSort != 'default' ? '&sort='.concat(currentSort) : ''}"
                                        class="page-btn prev-btn">‹</a>
                                </c:if>


                                <c:if test="${currentPage > 3}">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=1${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty currentSort && currentSort != 'default' ? '&sort='.concat(currentSort) : ''}"
                                        class="page-btn">1</a>
                                    <c:if test="${currentPage > 4}">
                                        <span class="page-dots">...</span>
                                    </c:if>
                                </c:if>


                                <c:forEach begin="${currentPage > 2 ? currentPage - 2 : 1}"
                                    end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" var="i">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${i}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty currentSort && currentSort != 'default' ? '&sort='.concat(currentSort) : ''}"
                                        class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                                </c:forEach>


                                <c:if test="${currentPage < totalPages - 2}">
                                    <c:if test="${currentPage < totalPages - 3}">
                                        <span class="page-dots">...</span>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${totalPages}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty currentSort && currentSort != 'default' ? '&sort='.concat(currentSort) : ''}"
                                        class="page-btn">${totalPages}</a>
                                </c:if>


                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/san-pham?page=${currentPage + 1}${not empty selectedCategoryId ? '&categoryId='.concat(selectedCategoryId) : ''}${not empty currentSort && currentSort != 'default' ? '&sort='.concat(currentSort) : ''}"
                                        class="page-btn next-btn">›</a>
                                </c:if>
                            </div>
                        </c:if>
                    </main>
                </div>


                <jsp:include page="common/footer.jsp" />


                <input type="hidden" id="currentCategoryId" value="${selectedCategoryId}" />
                <input type="hidden" id="currentSort" value="${currentSort}" />
                <input type="hidden" id="currentPage" value="${currentPage}" />

                <script src="${pageContext.request.contextPath}/js/SanPham.js?v=3"></script>

            </body>

            </html>