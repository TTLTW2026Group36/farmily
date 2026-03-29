<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa Danh mục - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories-add.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <div class="admin-layout">

                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">

                        <jsp:include page="header.jsp" />

                        <div class="admin-content">

                            <c:if test="${not empty error}">
                                <div
                                    style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Chỉnh sửa danh mục: ${category.name}</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/index"><i
                                                class="fas fa-home"></i>
                                            Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a>
                                        <span>/</span>
                                        <span>Chỉnh sửa</span>
                                    </div>
                                </div>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/admin/categories/edit"
                                class="edit-form">
                                <input type="hidden" name="id" value="${category.id}" />
                                <div class="form-grid">

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin danh mục</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="categoryId">ID danh mục</label>
                                                <input type="text" id="categoryId" value="${category.id}" disabled>
                                            </div>

                                            <div class="form-group">
                                                <label for="categoryName">Tên danh mục <span
                                                        class="required">*</span></label>
                                                <input type="text" name="name" id="categoryName"
                                                    value="${category.name}" required>
                                            </div>

                                            <div class="form-group">
                                                <label for="categoryImageUrl">URL hình ảnh</label>
                                                <textarea id="categoryImageUrl" name="imageUrl" rows="1"
                                                    placeholder="URL hình ảnh danh mục...">${category.imageUrl}</textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Thống kê</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="info-display">
                                                    <div class="info-item">
                                                        <span class="info-label">Số sản phẩm:</span>
                                                        <span class="info-value"><strong>${productCount}</strong> sản
                                                            phẩm</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Ngày tạo:</span>
                                                        <span class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty category.createdAt}">
                                                                    <fmt:formatDate value="${category.createdAt}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </c:when>
                                                                <c:otherwise>—</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/admin/categories"
                                        class="btn btn-outline">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </form>

                        </div>
                    </main>
                </div>

            </body>

            </html>