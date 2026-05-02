<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Đánh giá - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    .review-image-thumbnail {
                        width: 40px;
                        height: 40px;
                        object-fit: cover;
                        border-radius: 4px;
                        margin-right: 4px;
                        cursor: pointer;
                    }

                    .stars {
                        color: #f59e0b;
                    }

                    .bento-td-content {
                        max-width: 250px;
                        white-space: normal;
                        line-height: 1.4;
                    }

                    .action-form {
                        display: inline-block;
                        margin: 0;
                        padding: 0;
                    }

                    .bento-badge-danger {
                        background: #fee2e2;
                        color: #ef4444;
                    }

                    .bento-badge-secondary {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    .bento-icon-hidden {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    .bento-icon-reported {
                        background: #fee2e2;
                        color: #ef4444;
                    }

                    .desc-hidden {
                        color: #64748b;
                    }

                    .desc-reported {
                        color: #ef4444;
                    }
                </style>
            </head>

            <body data-page="reviews">
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">
                            <div class="orders-page-header">
                                <div>
                                    <h1 class="orders-page-title">Quản lý Đánh giá</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Đánh giá</span>
                                    </div>
                                </div>
                            </div>

                            <div class="bento-stat-grid">
                                <a href="${pageContext.request.contextPath}/admin/reviews"
                                    class="bento-card ${currentStatus == 'all' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Tất cả</span>
                                        <span class="bento-icon-wrapper bento-icon-all"><i
                                                class="fas fa-list"></i></span>
                                    </div>
                                    <div class="bento-card-value">${countAll}</div>
                                    <div class="bento-card-desc desc-all">Toàn bộ đánh giá</div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reviews?status=pending"
                                    class="bento-card ${currentStatus == 'pending' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Chờ duyệt</span>
                                        <div class="bento-icon-wrapper bento-icon-pending"><i class="fas fa-clock"></i>
                                        </div>
                                    </div>
                                    <div class="bento-card-value">${countPending}</div>
                                    <div class="bento-card-desc desc-pending">Cần xem xét</div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reviews?status=approved"
                                    class="bento-card ${currentStatus == 'approved' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Đã duyệt</span>
                                        <div class="bento-icon-wrapper bento-icon-completed"><i
                                                class="fas fa-check-circle"></i></div>
                                    </div>
                                    <div class="bento-card-value">${countApproved}</div>
                                    <div class="bento-card-desc desc-completed">Hiển thị công khai</div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reviews?status=rejected"
                                    class="bento-card ${currentStatus == 'rejected' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Từ chối</span>
                                        <div class="bento-icon-wrapper bento-icon-cancelled"><i class="fas fa-ban"></i>
                                        </div>
                                    </div>
                                    <div class="bento-card-value">${countRejected}</div>
                                    <div class="bento-card-desc desc-cancelled">Không hợp lệ</div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reviews?status=hidden"
                                    class="bento-card ${currentStatus == 'hidden' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Đã ẩn</span>
                                        <div class="bento-icon-wrapper bento-icon-hidden"><i
                                                class="fas fa-eye-slash"></i></div>
                                    </div>
                                    <div class="bento-card-value">${countHidden}</div>
                                    <div class="bento-card-desc desc-hidden">Ẩn khỏi web</div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/reviews?status=reported"
                                    class="bento-card ${currentStatus == 'reported' ? 'active' : ''}">
                                    <div class="bento-card-header">
                                        <span class="bento-card-title">Bị Report</span>
                                        <div class="bento-icon-wrapper bento-icon-reported"><i class="fas fa-flag"></i>
                                        </div>
                                    </div>
                                    <div class="bento-card-value">${countReported}</div>
                                    <div class="bento-card-desc desc-reported">Người dùng báo cáo</div>
                                </a>
                            </div>

                            <section class="bento-filter-section">
                                <form action="${pageContext.request.contextPath}/admin/reviews" method="get"
                                    class="bento-filter-grid">
                                    <input type="hidden" name="status" value="${currentStatus}">
                                    <div class="bento-filter-group">
                                        <label>Sản phẩm</label>
                                        <select name="productId" class="bento-input">
                                            <option value="">Tất cả sản phẩm</option>
                                            <c:forEach var="p" items="${products}">
                                                <option value="${p.id}" ${param.productId==p.id ? 'selected' : '' }>
                                                    ${p.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="bento-filter-group">
                                        <label>Rating</label>
                                        <select name="rating" class="bento-input">
                                            <option value="">Tất cả Rating</option>
                                            <c:forEach begin="1" end="5" var="r">
                                                <option value="${r}" ${param.rating==r ? 'selected' : '' }>${r} Sao
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="bento-filter-group">
                                        <label>Nội dung</label>
                                        <div class="search-input-wrapper">
                                            <i class="fas fa-search"></i>
                                            <input type="text" name="search" class="bento-input"
                                                placeholder="Tìm nội dung..." value="${param.search}">
                                        </div>
                                    </div>
                                    <div class="bento-filter-actions">
                                        <button type="submit" class="btn-bento-primary">Lọc</button>
                                        <a href="${pageContext.request.contextPath}/admin/reviews"
                                            class="btn-bento-secondary" style="height: 41px;">Đặt lại</a>
                                    </div>
                                </form>
                            </section>

                            <div class="bento-table-card">
                                <div class="table-responsive">
                                    <table class="bento-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Sản phẩm</th>
                                                <th>Người đánh giá</th>
                                                <th>Rating</th>
                                                <th style="min-width: 250px;">Nội dung</th>
                                                <th>Ảnh</th>
                                                <th>Report</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty reviews}">
                                                    <tr>
                                                        <td colspan="10">
                                                            <div class="bento-empty-state">
                                                                <i class="fas fa-inbox bento-empty-icon"></i>
                                                                <div class="bento-empty-title">Không có đánh giá nào
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="r" items="${reviews}">
                                                        <tr>
                                                            <td>#${r.id}</td>
                                                            <td>
                                                                <c:if test="${not empty r.product}">
                                                                    <strong>${r.product.name}</strong>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                ${r.userDisplayName}<br>
                                                                <small class="text-muted">
                                                                    <c:if test="${r.verifiedPurchase}">Đã mua hàng
                                                                    </c:if>
                                                                </small>
                                                            </td>
                                                            <td class="stars">
                                                                <c:forEach begin="1" end="${r.rating}">
                                                                    <i class="fas fa-star"></i>
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                <div class="bento-td-content">
                                                                    ${r.reviewText}
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty r.imageUrl}">
                                                                    <img src="${r.imageUrl}"
                                                                        class="review-image-thumbnail">
                                                                </c:if>
                                                                <c:forEach var="img" items="${r.images}">
                                                                    <img src="${img.imageUrl}"
                                                                        class="review-image-thumbnail">
                                                                </c:forEach>
                                                            </td>
                                                            <td>
                                                                <c:if test="${r.reportCount > 0}">
                                                                    <span class="bento-badge-danger"
                                                                        style="padding:2px 6px;border-radius:4px;font-size:12px;">
                                                                        <i class="fas fa-flag"></i> ${r.reportCount}
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${r.reportCount == 0}">
                                                                    -
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.status == 'pending'}"><span
                                                                            class="bento-status-badge bento-badge-pending">Chờ
                                                                            duyệt</span></c:when>
                                                                    <c:when test="${r.status == 'approved'}"><span
                                                                            class="bento-status-badge bento-badge-completed">Đã
                                                                            duyệt</span></c:when>
                                                                    <c:when test="${r.status == 'rejected'}"><span
                                                                            class="bento-status-badge bento-badge-cancelled">Từ
                                                                            chối</span></c:when>
                                                                    <c:when test="${r.status == 'hidden'}"><span
                                                                            class="bento-status-badge bento-badge-secondary">Đã
                                                                            ẩn</span></c:when>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="bento-td-date">${r.formattedDate}</div>
                                                            </td>
                                                            <td>
                                                                <div class="bento-actions">
                                                                    <c:if test="${r.status == 'pending'}">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/reviews"
                                                                            method="post" class="action-form">
                                                                            <input type="hidden" name="action"
                                                                                value="approve">
                                                                            <input type="hidden" name="reviewId"
                                                                                value="${r.id}">
                                                                            <button type="submit"
                                                                                class="btn-bento-icon bento-icon-primary"
                                                                                title="Duyệt">
                                                                                <i class="fas fa-check"></i>
                                                                            </button>
                                                                        </form>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/reviews"
                                                                            method="post" class="action-form">
                                                                            <input type="hidden" name="action"
                                                                                value="reject">
                                                                            <input type="hidden" name="reviewId"
                                                                                value="${r.id}">
                                                                            <button type="submit"
                                                                                class="btn-bento-icon bento-icon-danger"
                                                                                title="Từ chối">
                                                                                <i class="fas fa-times"></i>
                                                                            </button>
                                                                        </form>
                                                                    </c:if>

                                                                    <c:if test="${r.status == 'approved'}">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/reviews"
                                                                            method="post" class="action-form">
                                                                            <input type="hidden" name="action"
                                                                                value="hide">
                                                                            <input type="hidden" name="reviewId"
                                                                                value="${r.id}">
                                                                            <button type="submit"
                                                                                class="btn-bento-icon bento-icon-cancelled"
                                                                                title="Ẩn">
                                                                                <i class="fas fa-eye-slash"></i>
                                                                            </button>
                                                                        </form>
                                                                    </c:if>

                                                                    <c:if test="${r.status == 'hidden'}">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/reviews"
                                                                            method="post" class="action-form">
                                                                            <input type="hidden" name="action"
                                                                                value="approve">
                                                                            <input type="hidden" name="reviewId"
                                                                                value="${r.id}">
                                                                            <button type="submit"
                                                                                class="btn-bento-icon bento-icon-primary"
                                                                                title="Hiện">
                                                                                <i class="fas fa-eye"></i>
                                                                            </button>
                                                                        </form>
                                                                    </c:if>

                                                                    <form
                                                                        action="${pageContext.request.contextPath}/admin/reviews"
                                                                        method="post" class="action-form"
                                                                        onsubmit="return confirm('Xóa vĩnh viễn đánh giá này?');">
                                                                        <input type="hidden" name="action"
                                                                            value="delete">
                                                                        <input type="hidden" name="reviewId"
                                                                            value="${r.id}">
                                                                        <button type="submit"
                                                                            class="btn-bento-icon bento-icon-danger"
                                                                            title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${totalPages > 1}">
                                    <div class="bento-table-footer">
                                        <div class="bento-pagination">
                                            <c:if test="${currentPage > 1}">
                                                <a class="bento-page-btn"
                                                    href="?page=${currentPage - 1}&status=${currentStatus}&productId=${param.productId}&rating=${param.rating}&search=${param.search}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:if>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <a class="bento-page-btn ${i == currentPage ? 'active' : ''}"
                                                    href="?page=${i}&status=${currentStatus}&productId=${param.productId}&rating=${param.rating}&search=${param.search}">${i}</a>
                                            </c:forEach>
                                            <c:if test="${currentPage < totalPages}">
                                                <a class="bento-page-btn"
                                                    href="?page=${currentPage + 1}&status=${currentStatus}&productId=${param.productId}&rating=${param.rating}&search=${param.search}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </main>
                </div>

                <c:if test="${not empty sessionScope.successMsg || not empty sessionScope.errorMsg}">
                    <div class="toast-container" id="toastContainer">
                        <c:if test="${not empty sessionScope.successMsg}">
                            <div class="toast toast-success show">
                                <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
                            </div>
                            <c:remove var="successMsg" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.errorMsg}">
                            <div class="toast toast-error show">
                                <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}
                            </div>
                            <c:remove var="errorMsg" scope="session" />
                        </c:if>
                    </div>
                    <script>
                        setTimeout(function () {
                            var toasts = document.querySelectorAll('.toast');
                            toasts.forEach(function (toast) {
                                toast.classList.remove('show');
                                setTimeout(function () { toast.remove(); }, 300);
                            });
                        }, 3000);
                    </script>
                </c:if>
            </body>

            </html>