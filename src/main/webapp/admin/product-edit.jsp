<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Sửa Sản phẩm - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/product-add.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <div class="admin-layout">
                    
                    <jsp:include page="sidebar.jsp" />
                    

                    
                    <main class="admin-main">
                        
                        <jsp:include page="header.jsp" />
                        

                        
                        <div class="admin-content">
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"
                                    style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Sửa Sản phẩm</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i>
                                            Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
                                        <span>/</span>
                                        <span>Sửa: ${product.name}</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline">
                                        <i class="fas fa-arrow-left"></i>
                                        Quay lại
                                    </a>
                                </div>
                            </div>

                            <form class="admin-form" action="${pageContext.request.contextPath}/admin/products/edit"
                                method="post">
                                <input type="hidden" name="id" value="${product.id}">

                                
                                <div class="form-section">
                                    <h3 class="form-section-title">Thông tin cơ bản</h3>

                                    <div class="form-group">
                                        <label for="productName">Tên sản phẩm <span class="required">*</span></label>
                                        <input type="text" id="productName" name="productName" class="form-control"
                                            placeholder="VD: Bắp cải hữu cơ" required value="${product.name}">
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="category">Danh mục <span class="required">*</span></label>
                                            <select id="category" name="category" class="form-control" required>
                                                <option value="">-- Chọn danh mục --</option>
                                                <c:forEach var="cat" items="${categories}">
                                                    <option value="${cat.id}" ${product.categoryId==cat.id ? 'selected'
                                                        : '' }>${cat.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="tags">Tags</label>
                                            <input type="text" id="tags" name="tags" class="form-control"
                                                placeholder="VD: organic, fresh, local" value="${product.tags}">
                                            <div class="form-text">Phân cách bằng dấu phẩy</div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="description">Mô tả sản phẩm</label>
                                        <textarea id="description" name="description" class="form-control" rows="4"
                                            placeholder="Mô tả chi tiết về sản phẩm, nguồn gốc, công dụng...">${product.description}</textarea>
                                    </div>
                                </div>

                                
                                <div class="form-section">
                                    <h3 class="form-section-title">Biến thể sản phẩm (Giá & Kho)</h3>

                                    <c:choose>
                                        <c:when test="${not empty product.variants}">
                                            <div class="table-wrapper" style="margin-bottom: 15px;">
                                                <table class="admin-table" style="margin: 0;">
                                                    <thead>
                                                        <tr>
                                                            <th>Đơn vị</th>
                                                            <th>Giá (VNĐ)</th>
                                                            <th>Tồn kho</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="variant" items="${product.variants}"
                                                            varStatus="status">
                                                            <tr>
                                                                <td>
                                                                    <input type="hidden" name="variantId"
                                                                        value="${variant.id}">
                                                                    <input type="text" name="variantOptions"
                                                                        value="${variant.optionsValue}"
                                                                        class="form-control" style="width: 100px;">
                                                                </td>
                                                                <td>
                                                                    <input type="number" name="variantPrice"
                                                                        value="${variant.price}" class="form-control"
                                                                        style="width: 120px;" min="0">
                                                                </td>
                                                                <td>
                                                                    <input type="number" name="variantStock"
                                                                        value="${variant.stock}" class="form-control"
                                                                        style="width: 100px;" min="0">
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="color: #666; font-style: italic;">Sản phẩm chưa có biến thể nào.
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                
                                <div class="form-section">
                                    <h3 class="form-section-title">Hình ảnh sản phẩm</h3>

                                    <c:if test="${not empty product.images}">
                                        <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 15px;">
                                            <c:forEach var="image" items="${product.images}">
                                                <div style="position: relative;">
                                                    <img src="${image.imageUrl}" alt=""
                                                        style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;">
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="form-group">
                                        <label for="newImageUrl">Thêm hình ảnh mới (URL)</label>
                                        <input type="url" id="newImageUrl" name="newImageUrl" class="form-control"
                                            placeholder="https://example.com/image.jpg">
                                        <div class="form-text">Nhập URL hình ảnh sản phẩm (jpg, png, webp)</div>
                                    </div>
                                </div>

                                
                                <div class="form-section">
                                    <h3 class="form-section-title">Thông tin thêm</h3>
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Đánh giá trung bình</label>
                                            <p style="margin: 8px 0; font-size: 16px;">
                                                <i class="fas fa-star" style="color: #ffc107;"></i>
                                                <fmt:formatNumber value="${product.avgRating}" maxFractionDigits="1" />
                                                / 5.0
                                                <span style="color: #666; font-size: 14px;">(${product.reviewCount} đánh
                                                    giá)</span>
                                            </p>
                                        </div>
                                        <div class="form-group">
                                            <label>Đã bán</label>
                                            <p style="margin: 8px 0; font-size: 16px;">${product.soldCount} sản phẩm</p>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Ngày tạo</label>
                                            <p style="margin: 8px 0; color: #666;">
                                                <fmt:formatDate value="${product.createdAt}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                        </div>
                                        <div class="form-group">
                                            <label>Cập nhật lần cuối</label>
                                            <p style="margin: 8px 0; color: #666;">
                                                <fmt:formatDate value="${product.updatedAt}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                
                                <div
                                    style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                                    <a href="${pageContext.request.contextPath}/admin/products"
                                        class="btn btn-secondary">
                                        Hủy bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        Cập nhật sản phẩm
                                    </button>
                                </div>
                            </form>
                        </div>
                    </main>
                </div>
            </body>

            </html>