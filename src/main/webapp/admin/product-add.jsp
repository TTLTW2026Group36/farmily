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
                                </div>

                                <div class="form-group">
                                    <label for="category">Danh mục <span class="required">*</span></label>
                                    <select id="category" name="category" class="form-control" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" ${selectedCategory==cat.id ? 'selected' : '' }>
                                                ${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-section">
                                <h3 class="form-section-title">Biến thể sản phẩm <span class="required">*</span></h3>
                                <p class="form-text" style="margin-top: -8px; margin-bottom: 12px;">Thêm ít nhất 1 biến
                                    thể. Mỗi biến thể có tên phân loại, giá bán và số lượng tồn kho riêng.</p>

                                <div class="table-wrapper">
                                    <table class="admin-table" id="variantsTable">
                                        <thead>
                                            <tr>
                                                <th>Phân loại <span class="required">*</span></th>
                                                <th>Giá bán (VNĐ) <span class="required">*</span></th>
                                                <th>Tồn kho <span class="required">*</span></th>
                                                <th style="width: 60px;"></th>
                                            </tr>
                                        </thead>
                                        <tbody id="variantsBody">
                                            <tr>
                                                <td>
                                                    <input type="text" name="variantName" class="form-control"
                                                        placeholder="VD: 500g, 1kg, Hộp nhỏ, Loại A..." required>
                                                </td>
                                                <td>
                                                    <input type="number" name="variantPrice" class="form-control"
                                                        placeholder="25000" min="1" required>
                                                </td>
                                                <td>
                                                    <input type="number" name="variantStock" class="form-control"
                                                        placeholder="100" min="0" required>
                                                </td>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <button type="button" class="btn btn-sm btn-outline" id="addVariantBtn"
                                    style="margin-top: 10px;">
                                    <i class="fas fa-plus"></i> Thêm biến thể
                                </button>
                            </div>

                                <div class="form-section">
                                    <h3 class="form-section-title">Hình ảnh sản phẩm</h3>

                                    <div id="imageUrlsContainer">
                                        <div class="image-url-row" style="display: flex; gap: 10px; margin-bottom: 10px;">
                                            <div class="form-group" style="flex: 1; margin-bottom: 0;">
                                                <input type="url" name="imageUrl" class="form-control image-url-input"
                                                    placeholder="https://example.com/image.jpg">
                                            </div>
                                            <button type="button" class="btn btn-sm btn-outline remove-image-btn"
                                                style="visibility: hidden;" title="Xóa">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <button type="button" class="btn btn-sm btn-outline" id="addImageUrlBtn"
                                        style="margin-top: 5px;">
                                        <i class="fas fa-plus"></i> Thêm hình ảnh
                                    </button>

                                    <p class="form-text" style="margin-top: 12px;">Nhập URL hình ảnh (jpg, png, webp). Hình đầu tiên sẽ là ảnh chính.</p>

                                    <div id="imagePreviewContainer"
                                        style="display: flex; gap: 15px; flex-wrap: wrap; margin-top: 15px;"></div>
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
                document.addEventListener('DOMContentLoaded', function () {
                    const variantsBody = document.getElementById('variantsBody');
                    document.getElementById('addVariantBtn').addEventListener('click', function () {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td><input type="text" name="variantName" class="form-control" placeholder="VD: 500g, 1kg, Hộp nhỏ..." required></td>' +
                            '<td><input type="number" name="variantPrice" class="form-control" placeholder="25000" min="1" required></td>' +
                            '<td><input type="number" name="variantStock" class="form-control" placeholder="100" min="0" required></td>' +
                            '<td><button type="button" class="btn btn-sm btn-danger remove-variant-btn" title="Xóa"><i class="fas fa-times"></i></button></td>';
                        variantsBody.appendChild(tr);
                    });

                    variantsBody.addEventListener('click', function (e) {
                        const btn = e.target.closest('.remove-variant-btn');
                        if (btn && variantsBody.rows.length > 1) {
                            btn.closest('tr').remove();
                        }
                    });

                    const container = document.getElementById('imageUrlsContainer');
                    const previewContainer = document.getElementById('imagePreviewContainer');

                    document.getElementById('addImageUrlBtn').addEventListener('click', function () {
                        const row = document.createElement('div');
                        row.className = 'image-url-row';
                        row.innerHTML =
                            '<div class="form-group" style="flex: 1; margin-bottom: 0;">' +
                            '<input type="url" name="imageUrl" class="form-control image-url-input" placeholder="https://example.com/image.jpg">' +
                            '</div>' +
                            '<button type="button" class="btn btn-sm btn-danger remove-image-btn" title="Xóa"><i class="fas fa-times"></i></button>';
                        container.appendChild(row);
                        updatePreviews();
                    });

                    container.addEventListener('click', function (e) {
                        const removeBtn = e.target.closest('.remove-image-btn');
                        if (removeBtn && container.children.length > 1) {
                            removeBtn.closest('.image-url-row').remove();
                            updatePreviews();
                        }
                    });

                    container.addEventListener('input', function (e) {
                        if (e.target.classList.contains('image-url-input')) {
                            updatePreviews();
                        }
                    });

                    function updatePreviews() {
                        const inputs = container.querySelectorAll('.image-url-input');
                        previewContainer.innerHTML = '';
                        inputs.forEach(function (input, index) {
                            const url = input.value.trim();
                            if (url) {
                                const div = document.createElement('div');
                                div.style.position = 'relative';
                                const img = document.createElement('img');
                                img.src = url;
                                img.alt = 'Preview ' + (index + 1);
                                img.style.cssText = 'width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;';
                                img.onerror = function () { this.style.display = 'none'; };
                                if (index === 0) {
                                    const badge = document.createElement('span');
                                    badge.textContent = 'Chính';
                                    badge.style.cssText = 'position: absolute; top: 4px; left: 4px; background: #16a34a; color: white; font-size: 10px; padding: 2px 6px; border-radius: 4px;';
                                    div.appendChild(badge);
                                }
                                div.appendChild(img);
                                previewContainer.appendChild(div);
                            }
                        });
                    }
                });
            </script>
        </body>

        </html>