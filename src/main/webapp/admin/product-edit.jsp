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

                                    <div class="form-group">
                                        <label for="category">Danh mục <span class="required">*</span></label>
                                        <select id="category" name="category" class="form-control" required>
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}" ${product.categoryId==cat.id ? 'selected' : ''
                                                    }>${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <h3 class="form-section-title">Biến thể sản phẩm (Giá & Kho)</h3>

                                    <div class="table-wrapper">
                                        <table class="admin-table" id="variantsTable">
                                            <thead>
                                                <tr>
                                                    <th>Phân loại</th>
                                                    <th>Giá bán (VNĐ)</th>
                                                    <th>Tồn kho</th>
                                                    <th style="width: 60px;"></th>
                                                </tr>
                                            </thead>
                                            <tbody id="variantsBody">
                                                <c:forEach var="variant" items="${product.variants}" varStatus="status">
                                                    <tr data-existing="true">
                                                        <td>
                                                            <input type="hidden" name="variantId" value="${variant.id}">
                                                            <input type="text" name="variantOptions"
                                                                value="${variant.optionsValue}" class="form-control"
                                                                required>
                                                        </td>
                                                        <td>
                                                            <input type="number" name="variantPrice"
                                                                value="${variant.price}" class="form-control" min="1"
                                                                required>
                                                        </td>
                                                        <td>
                                                            <input type="number" name="variantStock"
                                                                value="${variant.stock}" class="form-control" min="0"
                                                                required>
                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <button type="button" class="btn btn-sm btn-outline" id="addVariantBtn"
                                        style="margin-top: 10px;">
                                        <i class="fas fa-plus"></i> Thêm biến thể mới
                                    </button>
                                </div>

                                <div class="form-section">
                                    <h3 class="form-section-title">Hình ảnh sản phẩm</h3>

                                    <c:if test="${not empty product.images}">
                                        <p class="form-text" style="margin-bottom: 12px;">Ảnh hiện tại:</p>
                                        <div id="existingImagesContainer"
                                            style="display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 20px;">
                                            <c:forEach var="image" items="${product.images}" varStatus="status">
                                                <div class="existing-image-wrapper" style="position: relative;"
                                                    id="image-wrapper-${image.id}">
                                                    <img src="${image.imageUrl}" alt="Ảnh ${status.index + 1}"
                                                        style="width: 120px; height: 120px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;">
                                                    <c:if test="${status.first}">
                                                        <span
                                                            style="position: absolute; top: 6px; left: 6px; background: #16a34a; color: white; font-size: 10px; padding: 2px 6px; border-radius: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">Chính</span>
                                                    </c:if>
                                                    <button type="button"
                                                        class="btn btn-sm btn-danger remove-existing-image-btn"
                                                        onclick="removeExistingImage('${image.id}')"
                                                        style="position: absolute; top: -8px; right: -8px; width: 24px; height: 24px; padding: 0; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 2px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.2);"
                                                        title="Xóa ảnh này">
                                                        <i class="fas fa-times" style="font-size: 10px;"></i>
                                                    </button>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div id="deletedImagesInputs"></div>
                                    </c:if>

                                    <p class="form-text" style="margin-bottom: 8px;">Thêm hình ảnh mới:</p>
                                    <div id="newImageUrlsContainer">
                                        <div class="image-url-row"
                                            style="display: flex; gap: 10px; margin-bottom: 10px;">
                                            <div class="form-group" style="flex: 1; margin-bottom: 0;">
                                                <input type="url" name="newImageUrls"
                                                    class="form-control new-image-url-input"
                                                    placeholder="https://example.com/image.jpg">
                                            </div>
                                            <button type="button" class="btn btn-sm btn-outline remove-new-image-btn"
                                                style="visibility: hidden;" title="Xóa">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <button type="button" class="btn btn-sm btn-outline" id="addNewImageUrlBtn"
                                        style="margin-top: 5px;">
                                        <i class="fas fa-plus"></i> Thêm hình ảnh
                                    </button>

                                    <div id="newImagePreviewContainer"
                                        style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 15px;"></div>
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
                                    style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0; margin-top: 20px;">
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

                <script>
                    function removeExistingImage(imageId) {
                        if (confirm('Bạn có chắc chắn muốn xóa ảnh này?')) {
                            const wrapper = document.getElementById('image-wrapper-' + imageId);
                            if (wrapper) {
                                wrapper.style.display = 'none';
                                const input = document.createElement('input');
                                input.type = 'hidden';
                                input.name = 'deleteImageId';
                                input.value = imageId;
                                document.getElementById('deletedImagesInputs').appendChild(input);
                            }
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        // === Add new variant rows ===
                        var variantsBody = document.getElementById('variantsBody');
                        if (document.getElementById('addVariantBtn')) {
                            document.getElementById('addVariantBtn').addEventListener('click', function () {
                                var tr = document.createElement('tr');
                                tr.setAttribute('data-new', 'true');
                                tr.innerHTML =
                                    '<td><input type="text" name="newVariantName" class="form-control" placeholder="Tên biến thể mới..." required></td>' +
                                    '<td><input type="number" name="newVariantPrice" class="form-control" placeholder="Giá" min="1" required></td>' +
                                    '<td><input type="number" name="newVariantStock" class="form-control" placeholder="Số lượng" min="0" required></td>' +
                                    '<td><button type="button" class="btn btn-sm btn-danger remove-variant-btn" title="Xóa"><i class="fas fa-times"></i></button></td>';
                                variantsBody.appendChild(tr);
                            });
                        }

                        variantsBody.addEventListener('click', function (e) {
                            var btn = e.target.closest('.remove-variant-btn');
                            if (btn) {
                                var row = btn.closest('tr');
                                if (row.hasAttribute('data-new')) {
                                    row.remove();
                                }
                            }
                        });


                        const newImagesContainer = document.getElementById('newImageUrlsContainer');
                        const newImagesPreviewContainer = document.getElementById('newImagePreviewContainer');
                        const addNewImageUrlBtn = document.getElementById('addNewImageUrlBtn');

                        if (addNewImageUrlBtn) {
                            addNewImageUrlBtn.addEventListener('click', function () {
                                const row = document.createElement('div');
                                row.className = 'image-url-row';
                                row.style.display = 'flex';
                                row.style.gap = '10px';
                                row.style.marginBottom = '10px';
                                row.innerHTML =
                                    '<div class="form-group" style="flex: 1; margin-bottom: 0;">' +
                                    '<input type="url" name="newImageUrls" class="form-control new-image-url-input" placeholder="https://example.com/image.jpg">' +
                                    '</div>' +
                                    '<button type="button" class="btn btn-sm btn-danger remove-new-image-btn" title="Xóa"><i class="fas fa-times"></i></button>';
                                newImagesContainer.appendChild(row);
                            });
                        }

                        if (newImagesContainer) {
                            newImagesContainer.addEventListener('click', function (e) {
                                const removeBtn = e.target.closest('.remove-new-image-btn');
                                if (removeBtn) {
                                    removeBtn.closest('.image-url-row').remove();
                                    updateNewImagePreviews();
                                }
                            });

                            newImagesContainer.addEventListener('input', function (e) {
                                if (e.target.classList.contains('new-image-url-input')) {
                                    updateNewImagePreviews();
                                }
                            });
                        }

                        function updateNewImagePreviews() {
                            newImagesPreviewContainer.innerHTML = '';
                            const inputs = newImagesContainer.querySelectorAll('.new-image-url-input');
                            inputs.forEach(function (input) {
                                var url = input.value.trim();
                                if (url) {
                                    const img = document.createElement('img');
                                    img.src = url;
                                    img.style.width = '100px';
                                    img.style.height = '100px';
                                    img.style.objectFit = 'cover';
                                    img.style.borderRadius = '8px';
                                    img.style.border = '1px solid #ddd';
                                    img.onerror = function () { this.style.display = 'none'; };
                                    newImagesPreviewContainer.appendChild(img);
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>