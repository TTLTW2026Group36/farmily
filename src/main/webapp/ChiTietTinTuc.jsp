<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${news.title} - Farmily</title>
                <meta name="description" content="${news.excerpt}">
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
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/tin-tuc">Tin Tức</a>
                            </li>
                            <c:if test="${not empty news.category}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/tin-tuc?categoryId=${news.categoryId}">
                                        ${news.category.name}
                                    </a>
                                </li>
                            </c:if>
                            <li class="breadcrumb-item active" aria-current="page">
                                ${news.title}
                            </li>
                        </ol>
                    </div>
                </nav>

                
                <div class="post-detail-container">
                    <div class="container">
                        <div class="post-detail-layout">
                            
                            <main class="post-detail-main">
                                <article class="post-detail">
                                    
                                    <header class="post-header">
                                        <c:if test="${not empty news.category}">
                                            <div class="post-category-badge">
                                                <i class="fas fa-folder"></i> ${news.category.name}
                                            </div>
                                        </c:if>
                                        <h1 class="post-title">${news.title}</h1>
                                        <div class="post-meta">
                                            <div class="meta-item">
                                                <i class="fas fa-user"></i>
                                                <span>Đăng bởi: <strong>${news.authorName}</strong></span>
                                            </div>
                                            <div class="meta-item">
                                                <i class="far fa-calendar"></i>
                                                <span>
                                                    <fmt:formatDate value="${news.createdAt}" pattern="dd/MM/yyyy" />
                                                </span>
                                            </div>
                                            <div class="meta-item">
                                                <i class="far fa-eye"></i>
                                                <span>
                                                    <fmt:formatNumber value="${news.viewCount}" type="number" /> lượt
                                                    xem
                                                </span>
                                            </div>
                                        </div>
                                    </header>

                                    
                                    <div class="post-featured-image">
                                        <img src="${not empty news.imageUrl ? news.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                            alt="${news.title}">
                                    </div>

                                    
                                    <div class="post-content">
                                        ${news.content}
                                    </div>

                                    
                                    <div class="post-tags">
                                        <h3>Thẻ:</h3>
                                        <div class="tags-list">
                                            <c:if test="${not empty news.category}">
                                                <a href="${pageContext.request.contextPath}/tin-tuc?categoryId=${news.categoryId}"
                                                    class="tag">
                                                    ${news.category.name}
                                                </a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/tin-tuc?keyword=rau củ"
                                                class="tag">Rau củ</a>
                                            <a href="${pageContext.request.contextPath}/tin-tuc?keyword=sức khỏe"
                                                class="tag">Sức khỏe</a>
                                            <a href="${pageContext.request.contextPath}/tin-tuc?keyword=dinh dưỡng"
                                                class="tag">Dinh dưỡng</a>
                                        </div>
                                    </div>

                                    
                                    <div class="post-share">
                                        <h3>Chia sẻ bài viết:</h3>
                                        <div class="share-buttons">
                                            <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}?id=${news.id}"
                                                target="_blank" class="share-btn facebook">
                                                <i class="fab fa-facebook-f"></i> Facebook
                                            </a>
                                            <a href="https://twitter.com/intent/tweet?url=${pageContext.request.requestURL}?id=${news.id}&text=${news.title}"
                                                target="_blank" class="share-btn twitter">
                                                <i class="fab fa-twitter"></i> Twitter
                                            </a>
                                            <a href="https://pinterest.com/pin/create/button/?url=${pageContext.request.requestURL}?id=${news.id}&description=${news.title}"
                                                target="_blank" class="share-btn pinterest">
                                                <i class="fab fa-pinterest-p"></i> Pinterest
                                            </a>
                                        </div>
                                    </div>

                                    
                                    <div class="author-box">
                                        <div class="author-avatar">
                                            <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                alt="${news.authorName}">
                                        </div>
                                        <div class="author-info">
                                            <h3 class="author-name">${news.authorName}</h3>
                                            <p class="author-bio">
                                                Chuyên gia dinh dưỡng với nhiều năm kinh nghiệm trong lĩnh vực tư vấn
                                                sức khỏe và thực phẩm sạch.
                                                Đam mê chia sẻ kiến thức về lối sống lành mạnh.
                                            </p>
                                            <div class="author-social">
                                                <a href="#"><i class="fab fa-facebook"></i></a>
                                                <a href="#"><i class="fab fa-twitter"></i></a>
                                                <a href="#"><i class="fab fa-instagram"></i></a>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <c:if test="${not empty relatedNews}">
                                        <div class="related-posts">
                                            <h3 class="section-title">Bài viết liên quan</h3>
                                            <div class="related-posts-grid">
                                                <c:forEach var="related" items="${relatedNews}">
                                                    <article class="related-post-item">
                                                        <div class="related-post-image">
                                                            <a
                                                                href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${related.id}">
                                                                <img src="${not empty related.imageUrl ? related.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                                                    alt="${related.title}">
                                                            </a>
                                                        </div>
                                                        <div class="related-post-content">
                                                            <h4>
                                                                <a
                                                                    href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${related.id}">
                                                                    ${related.title}
                                                                </a>
                                                            </h4>
                                                            <div class="related-post-meta">
                                                                <span>
                                                                    <i class="far fa-calendar"></i>
                                                                    <fmt:formatDate value="${related.createdAt}"
                                                                        pattern="dd/MM/yyyy" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </article>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </article>
                            </main>

                            
                            <aside class="post-sidebar">
                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Tìm kiếm</h3>
                                    <form class="search-widget" action="${pageContext.request.contextPath}/tin-tuc"
                                        method="get">
                                        <input type="text" name="keyword" placeholder="Tìm kiếm bài viết...">
                                        <button type="submit"><i class="fas fa-search"></i></button>
                                    </form>
                                </div>

                                
                                <div class="sidebar-widget">
                                    <h3 class="widget-title">Danh mục</h3>
                                    <ul class="category-list">
                                        <c:forEach var="cat" items="${categories}">
                                            <li>
                                                <a href="${pageContext.request.contextPath}/tin-tuc?categoryId=${cat.id}"
                                                    class="${news.categoryId == cat.id ? 'active' : ''}">
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
                                                <div class="popular-post-image">
                                                    <a
                                                        href="${pageContext.request.contextPath}/chi-tiet-tin-tuc?id=${popular.id}">
                                                        <img src="${not empty popular.imageUrl ? popular.imageUrl : 'https://i.postimg.cc/xdZztWKq/demosanpham.jpg'}"
                                                            alt="${popular.title}">
                                                    </a>
                                                </div>
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
                                    <h3 class="widget-title">Thẻ phổ biến</h3>
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


            </body>

            </html>