<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thùng rác - Sản phẩm đã xóa - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/products.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body data-page="products">
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
                                    <h1 class="content-title"><i class="fas fa-trash-alt" style="margin-right: 8px;"></i>Thùng rác</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i>
                                            Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
                                        <span>/</span>
                                        <span>Thùng rác</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/products"
                                        class="btn btn-outline">
                                        <i class="fas fa-arrow-left"></i>
                                        Quay lại
                                    </a>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Sản phẩm đã xóa (${totalProducts})</h3>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <div class="table-wrapper">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Danh mục</th>
                                                    <th>Giá</th>
                                                    <th>Ngày xóa</th>
                                                    <th style="width: 200px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty products}">
                                                        <tr>
                                                            <td colspan="5" style="text-align: center; padding: 40px;">
                                                                <i class="fas fa-check-circle"
                                                                    style="font-size: 48px; color: #28a745; margin-bottom: 10px;"></i>
                                                                <p style="color: #666;">Thùng rác trống</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="product" items="${products}">
                                                            <tr>
                                                                <td>
                                                                    <div class="product-cell">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.primaryImageUrl}">
                                                                                <img src="${product.primaryImageUrl}"
                                                                                    alt="${product.name}"
                                                                                    class="product-img"
                                                                                    style="opacity: 0.6;">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                                                    alt="${product.name}"
                                                                                    class="product-img"
                                                                                    style="opacity: 0.6;">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div>
                                                                            <div class="product-name" style="color: #999;">${product.name}</div>
                                                                            <div class="product-sku">ID: ${product.id}</div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty product.category}">
                                                                            ${product.category.name}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span style="color: #999;">Chưa phân loại</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${product.minPrice}"
                                                                        type="number" groupingUsed="true"
                                                                        maxFractionDigits="0" />đ
                                                                </td>
                                                                <td>
                                                                    <fmt:formatDate value="${product.deletedAt}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </td>
                                                                <td>
                                                                    <div class="action-buttons">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/products/restore"
                                                                            method="post" style="display: inline;">
                                                                            <input type="hidden" name="id"
                                                                                value="${product.id}">
                                                                            <button type="submit"
                                                                                class="btn btn-sm btn-outline"
                                                                                title="Khôi phục"
                                                                                style="color: #28a745; border-color: #28a745;">
                                                                                <i class="fas fa-undo"></i> Khôi phục
                                                                            </button>
                                                                        </form>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/products/hard-delete"
                                                                            method="post" style="display: inline;"
                                                                            onsubmit="return confirm('Hành động này sẽ xóa vĩnh viễn sản phẩm khỏi hệ thống và KHÔNG THỂ hoàn tác! Bạn có chắc chắn?');">
                                                                            <input type="hidden" name="id"
                                                                                value="${product.id}">
                                                                            <button type="submit"
                                                                                class="btn btn-sm btn-danger"
                                                                                title="Xóa vĩnh viễn">
                                                                                <i class="fas fa-trash"></i> Xóa hẳn
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
