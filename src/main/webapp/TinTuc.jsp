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
                        <c:when test="${not empty selectedCategory}">
                            ${selectedCategory.name} - Tin Tức - Farmily
                        </c:when>
                        <c:when test="${not empty keyword}">
                            Tìm kiếm: ${keyword} - Tin Tức - Farmily
                        </c:when>
                        <c:otherwise>
                            Tin Tức - Farmily
                        </c:otherwise>
                    </c:choose>
                </title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TinTuc.css">
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
                            <c:choose>
                                <c:when test="${not empty selectedCategory}">
                                    <li class="breadcrumb-item">
                                        <a href="${pageContext.request.contextPath}/tin-tuc">Tin Tức</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        ${selectedCategory.name}
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Tin Tức
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ol>
                    </div>
                </nav>

                
                <div class="news-container">
                    <div class="container">
                        
                        <div class="page-header">
                            <h1 class="page-title">
                                <c:choose>
                                    <c:when test="${not empty selectedCategory}">
                                        ${selectedCategory.name}
                                    </c:when>
                                    <c:when test="${not empty keyword}">
                                        Kết quả tìm kiếm: "${keyword}"
                                    </c:when>
                                    <c:otherwise>
                                        Tin Tức Nông Sản
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="page-description">
                                <c:choose>
                                    <c:when test="${not empty keyword}">
                                        Tìm thấy ${totalNews} bài viết
                                    </c:when>
                                    <c:otherwise>
                                        Cập nhật những tin tức mới nhất về nông sản, sức khỏe và cuộc sống
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="news-layout">
                            
                            <main class="news-main">
                                
                                <c:if test="${not empty featuredNews}">
                                    <article class="featured-post">
                                        <a href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${featuredNews.id}"
                                            class="post-image">
                                            <img src="${not empty featuredNews.imageUrl ? featuredNews.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                                alt="${featuredNews.title}">
                                            <c:if test="${not empty featuredNews.category}">
                                                <span class="post-category">${featuredNews.category.name}</span>
                                            </c:if>
                                        </a>
                                        <div class="post-content">
                                            <h2 class="post-title">
                                                <a
                                                    href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${featuredNews.id}">
                                                    ${featuredNews.title}
                                                </a>
                                            </h2>
                                            <div class="post-meta">
                                                <span class="post-author">
                                                    <i class="fas fa-user"></i> ${featuredNews.authorName}
                                                </span>
                                                <span class="post-date">
                                                    <i class="far fa-calendar"></i>
                                                    <fmt:formatDate value="${featuredNews.createdAt}"
                                                        pattern="dd/MM/yyyy" />
                                                </span>
                                                <span class="post-views">
                                                    <i class="far fa-eye"></i>
                                                    <fmt:formatNumber value="${featuredNews.viewCount}" type="number" />
                                                    lượt xem
                                                </span>
                                            </div>
                                            <p class="post-excerpt">${featuredNews.excerpt}</p>
                                            <a href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${featuredNews.id}"
                                                class="btn-read-more">
                                                Đọc thêm <i class="fas fa-arrow-right"></i>
                                            </a>
                                        </div>
                                    </article>
                                </c:if>

                                
                                <div class="news-grid">
                                    <c:forEach var="news" items="${newsList}">
                                        
                                        <c:if test="${empty featuredNews || news.id != featuredNews.id}">
                                            <article class="news-card">
                                                <a href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${news.id}"
                                                    class="card-image">
                                                    <img src="${not empty news.imageUrl ? news.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                                        alt="${news.title}">
                                                    <c:if test="${not empty news.category}">
                                                        <span class="card-category">${news.category.name}</span>
                                                    </c:if>
                                                </a>
                                                <div class="card-content">
                                                    <h3 class="card-title">
                                                        <a
                                                            href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${news.id}">
                                                            ${news.title}
                                                        </a>
                                                    </h3>
                                                    <div class="card-meta">
                                                        <span>
                                                            <i class="far fa-calendar"></i>
                                                            <fmt:formatDate value="${news.createdAt}"
                                                                pattern="dd/MM/yyyy" />
                                                        </span>
                                                        <span>
                                                            <i class="far fa-eye"></i>
                                                            <fmt:formatNumber value="${news.viewCount}" type="number" />
                                                        </span>
                                                    </div>
                                                    <p class="card-excerpt">${news.excerpt}</p>
                                                    <a href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${news.id}"
                                                        class="card-link">
                                                        Xem chi tiết →
                                                    </a>
                                                </div>
                                            </article>
                                        </c:if>
                                    </c:forEach>

                                    
                                    <c:if test="${empty newsList}">
                                        <div class="empty-state"
                                            style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
                                            <i class="fas fa-newspaper"
                                                style="font-size: 3rem; color: #ccc; margin-bottom: 1rem;"></i>
                                            <h3>Không tìm thấy bài viết</h3>
                                            <p>
                                                <c:choose>
                                                    <c:when test="${not empty keyword}">
                                                        Không có bài viết nào phù hợp với từ khóa "${keyword}"
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có bài viết nào trong danh mục này
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </c:if>
                                </div>

                                
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination">
                                        
                                        <c:choose>
                                            <c:when test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/tin-tuc?page=${currentPage - 1}<c:if test='${selectedCategoryId > 0}'>&categoryId=${selectedCategoryId}</c:if>"
                                                    class="page-btn">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="page-btn" disabled><i
                                                        class="fas fa-chevron-left"></i></button>
                                            </c:otherwise>
                                        </c:choose>

                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <button class="page-btn active">${i}</button>
                                                </c:when>
                                                <c:when
                                                    test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                    <a href="${pageContext.request.contextPath}/tin-tuc?page=${i}<c:if test='${selectedCategoryId > 0}'>&categoryId=${selectedCategoryId}</c:if>"
                                                        class="page-btn">${i}</a>
                                                </c:when>
                                                <c:when test="${i == 4 && currentPage > 4}">
                                                    <span class="page-dots">...</span>
                                                </c:when>
                                                <c:when test="${i == totalPages - 2 && currentPage < totalPages - 3}">
                                                    <span class="page-dots">...</span>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>

                                        
                                        <c:choose>
                                            <c:when test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/tin-tuc?page=${currentPage + 1}<c:if test='${selectedCategoryId > 0}'>&categoryId=${selectedCategoryId}</c:if>"
                                                    class="page-btn">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="page-btn" disabled><i
                                                        class="fas fa-chevron-right"></i></button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </main>

                            
                            <aside class="news-sidebar">
                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Tìm kiếm</h3>
                                    <form class="search-widget" action="${pageContext.request.contextPath}/tin-tuc"
                                        method="get">
                                        <input type="text" name="keyword" placeholder="Tìm kiếm bài viết..."
                                            value="${keyword}">
                                        <button type="submit"><i class="fas fa-search"></i></button>
                                    </form>
                                </div>

                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Danh mục</h3>
                                    <ul class="category-list">
                                        <c:forEach var="cat" items="${categories}">
                                            <li>
                                                <a href="${pageContext.request.contextPath}/tin-tuc?categoryId=${cat.id}"
                                                    class="${selectedCategoryId == cat.id ? 'active' : ''}">
                                                    <i class="fas fa-folder"></i> ${cat.name}
                                                    <span>(${cat.newsCount})</span>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>

                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Bài viết phổ biến</h3>
                                    <div class="popular-posts">
                                        <c:forEach var="popular" items="${popularNews}">
                                            <article class="popular-post-item">
                                                <a href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${popular.id}"
                                                    class="popular-post-image">
                                                    <img src="${not empty popular.imageUrl ? popular.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                                        alt="${popular.title}">
                                                </a>
                                                <div class="popular-post-content">
                                                    <h4>
                                                        <a
                                                            href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${popular.id}">
                                                            ${popular.title}
                                                        </a>
                                                    </h4>
                                                    <span class="popular-post-date">
                                                        <i class="far fa-calendar"></i>
                                                        <fmt:formatDate value="${popular.createdAt}"
                                                            pattern="dd/MM/yyyy" />
                                                    </span>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </div>
                                </div>

                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Thẻ</h3>
                                    <div class="tags-cloud">
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=rau củ"
                                            class="tag">Rau củ</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=trái cây"
                                            class="tag">Trái cây</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=sức khỏe"
                                            class="tag">Sức khỏe</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=dinh dưỡng"
                                            class="tag">Dinh dưỡng</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=hữu cơ"
                                            class="tag">Hữu cơ</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=mẹo vặt"
                                            class="tag">Mẹo vặt</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=công thức"
                                            class="tag">Công thức</a>
                                        <a href="${pageContext.request.contextPath}/tin-tuc?keyword=an toàn"
                                            class="tag">An toàn</a>
                                    </div>
                                </div>

                            </aside>
                        </div>
                    </div>
                </div>

                
                <jsp:include page="common/footer.jsp" />

                <script src="${pageContext.request.contextPath}/js/TinTuc.js"></script>
            </body>

            </html>