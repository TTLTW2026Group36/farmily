<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Flash Sale - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/products.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    .badge.active {
                        background: #d1fae5;
                        color: #065f46;
                    }

                    .badge.expired {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    .badge.upcoming {
                        background: #dbeafe;
                        color: #1e40af;
                    }
                </style>
            </head>

            <body>
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">
                            
                            <c:if test="${not empty success}">
                                <div class="alert alert-success"
                                    style="background: #d4edda; color: #155724; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"
                                    style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Quản lý Flash Sale</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Flash Sale</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/flash-sales/add"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm Flash Sale
                                    </a>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách Flash Sale</h3>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <div class="table-wrapper">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Giảm giá</th>
                                                    <th>Đã bán / Giới hạn</th>
                                                    <th>Thời gian</th>
                                                    <th>Trạng thái</th>
                                                    <th style="width: 150px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty flashSales}">
                                                        <tr>
                                                            <td colspan="6" style="text-align: center; padding: 40px;">
                                                                <i class="fas fa-bolt"
                                                                    style="font-size: 48px; color: #ccc; margin-bottom: 10px;"></i>
                                                                <p style="color: #666;">Chưa có chương trình Flash Sale
                                                                    nào</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="fs" items="${flashSales}">
                                                            <tr>
                                                                <td>
                                                                    <div class="product-cell">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty fs.product.primaryImageUrl}">
                                                                                <img src="${fs.product.primaryImageUrl}"
                                                                                    class="product-img">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                                                    class="product-img">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div>
                                                                            <div class="product-name">${fs.product.name}
                                                                            </div>
                                                                            <div class="product-sku">ID SP:
                                                                                ${fs.productId}</div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td><strong
                                                                        style="color: #dc2626;">-${fs.discountPercent}%</strong>
                                                                </td>
                                                                <td>
                                                                    <div
                                                                        style="width: 100px; background: #eee; height: 8px; border-radius: 4px; overflow: hidden; margin-bottom: 4px;">
                                                                        <div
                                                                            style="width: ${fs.soldPercentage}%; background: #fbbf24; height: 100%;">
                                                                        </div>
                                                                    </div>
                                                                    <span
                                                                        style="font-size: 12px; color: #666;">${fs.soldCount}
                                                                        / ${fs.stockLimit}</span>
                                                                </td>
                                                                <td>
                                                                    <div style="font-size: 13px;">
                                                                        <i class="far fa-clock"></i>
                                                                        <fmt:formatDate value="${fs.startTime}"
                                                                            pattern="dd/MM HH:mm" /><br>
                                                                        <i class="fas fa-arrow-right"
                                                                            style="font-size: 10px; margin: 0 5px;"></i><br>
                                                                        <i class="far fa-clock"></i>
                                                                        <fmt:formatDate value="${fs.endTime}"
                                                                            pattern="dd/MM HH:mm" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <jsp:useBean id="now" class="java.util.Date" />
                                                                    <c:choose>
                                                                        <c:when test="${fs.endTime.before(now)}">
                                                                            <span class="badge expired">Đã kết
                                                                                thúc</span>
                                                                        </c:when>
                                                                        <c:when test="${fs.startTime.after(now)}">
                                                                            <span class="badge upcoming">Sắp diễn
                                                                                ra</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge active">Đang diễn
                                                                                ra</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <div class="action-buttons">
                                                                        <a href="${pageContext.request.contextPath}/admin/flash-sales/edit?id=${fs.id}"
                                                                            class="btn btn-sm btn-outline" title="Sửa">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/flash-sales/delete"
                                                                            method="post" style="display: inline;"
                                                                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa Flash Sale này không?');">
                                                                            <input type="hidden" name="id"
                                                                                value="${fs.id}">
                                                                            <button type="submit"
                                                                                class="btn btn-sm btn-danger"
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
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>