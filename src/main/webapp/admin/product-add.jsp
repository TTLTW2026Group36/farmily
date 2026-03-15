<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Sản phẩm - Admin Farmily</title>
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
                                <h1 class="content-title">Thêm Sản phẩm mới</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                            class="fas fa-home"></i>
                                        Dashboard</a>
                                    <span>/</span>
                                    <a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a>
                                    <span>/</span>
                                    <span>Thêm mới</span>
                                </div>
                            </div>
                            <div class="page-actions">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline">
                                    <i class="fas fa-arrow-left"></i>
                                    Quay lại
                                </a>
                            </div>
                        </div>

                        <form class="admin-form" action="${pageContext.request.contextPath}/admin/products/add"
                            method="post">
                            
                            <div class="form-section">
                                <h3 class="form-section-title">Thông tin cơ bản</h3>

                                <div class="form-group">
                                    <label for="productName">Tên sản phẩm <span class="required">*</span></label>
                                    <input type="text" id="productName" name="productName" class="form-control"
                                        placeholder="VD: Bắp cải hữu cơ" required value="${productName}">
                                    <div class="form-error">Vui lòng nhập tên sản phẩm</div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="category">Danh mục <span class="required">*</span></label>
                                        <select id="category" name="category" class="form-control" required>
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}" ${selectedCategory==cat.id ? 'selected' : ''
                                                    }>${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="tags">Tags</label>
                                        <input type="text" id="tags" name="tags" class="form-control"
                                            placeholder="VD: organic, fresh, local" value="${tags}">
                                        <div class="form-text">Phân cách bằng dấu phẩy</div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="description">Mô tả sản phẩm</label>
                                    <textarea id="description" name="description" class="form-control" rows="4"
                                        placeholder="Mô tả chi tiết về sản phẩm, nguồn gốc, công dụng...">${description}</textarea>
                                </div>
                            </div>

                            
                            <div class="form-section">
                                <h3 class="form-section-title">Giá & Kho hàng</h3>

                                <div class="form-row-3">
                                    <div class="form-group">
                                        <label for="price">Giá bán (VNĐ) <span class="required">*</span></label>
                                        <input type="number" id="price" name="price" class="form-control"
                                            placeholder="25000" min="0" required value="${price}">
                                    </div>

                                    <div class="form-group">
                                        <label for="stock">Số lượng tồn kho <span class="required">*</span></label>
                                        <input type="number" id="stock" name="stock" class="form-control"
                                            placeholder="100" min="0" required value="${stock}">
                                    </div>

                                    <div class="form-group">
                                        <label for="unit">Đơn vị tính</label>
                                        <select id="unit" name="unit" class="form-control">
                                            <option value="kg" ${unit=='kg' ? 'selected' : '' }>kg</option>
                                            <option value="500g" ${unit=='500g' ? 'selected' : '' }>500g</option>
                                            <option value="gram" ${unit=='gram' ? 'selected' : '' }>gram</option>
                                            <option value="bó" ${unit=='bó' ? 'selected' : '' }>bó</option>
                                            <option value="trái" ${unit=='trái' ? 'selected' : '' }>trái</option>
                                            <option value="túi" ${unit=='túi' ? 'selected' : '' }>túi</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            
                            <div class="form-section">
                                <h3 class="form-section-title">Hình ảnh sản phẩm</h3>

                                <div class="form-group">
                                    <label for="imageUrl">URL hình ảnh</label>
                                    <input type="url" id="imageUrl" name="imageUrl" class="form-control"
                                        placeholder="https://example.com/image.jpg" value="${imageUrl}">
                                    <div class="form-text">Nhập URL hình ảnh sản phẩm (jpg, png, webp)</div>
                                </div>

                                <div id="imagePreview" style="margin-top: 10px;">
                                    <c:if test="${not empty imageUrl}">
                                        <img src="${imageUrl}" alt="Preview"
                                            style="max-width: 200px; max-height: 200px; border-radius: 8px;">
                                    </c:if>
                                </div>
                            </div>

                            
                            <div
                                style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Lưu sản phẩm
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
            <script>
                // Preview image when URL is entered
                document.getElementById('imageUrl').addEventListener('input', function (e) {
                    const url = e.target.value;
                    const preview = document.getElementById('imagePreview');
                    if (url) {
                        preview.innerHTML = '<img src="' + url + '" alt="Preview" style="max-width: 200px; max-height: 200px; border-radius: 8px;" onerror="this.style.display=\'none\'">';
                    } else {
                        preview.innerHTML = '';
                    }
                });
            </script>
        </body>

        </html>