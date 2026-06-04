<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Sản phẩm - Admin Farmily</title>
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
                                    <h1 class="content-title">Quản lý Sản phẩm</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i>
                                            Dashboard</a>
                                        <span>/</span>
                                        <span>Sản phẩm</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/products/add"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Thêm sản phẩm
                                    </a>
                                </div>
                            </div>

                            <form method="get" action="${pageContext.request.contextPath}/admin/products"
                                class="filters-bar" id="filterForm">
                                <div class="filter-group">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="search" class="form-control"
                                        placeholder="Tên sản phẩm..." value="${searchKeyword}"
                                        style="min-width: 180px;">
                                </div>

                                <div class="filter-group">
                                    <label>Danh mục</label>
                                    <select name="category" class="form-control" onchange="this.form.submit()">
                                        <option value="">Tất cả danh mục</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" ${selectedCategory==cat.id ? 'selected' : '' }>
                                                ${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label>Trạng thái</label>
                                    <select name="status" class="form-control" onchange="this.form.submit()">
                                        <option value="">Tất cả</option>
                                        <option value="instock" ${selectedStatus=='instock' ? 'selected' : '' }>Còn hàng</option>
                                        <option value="outofstock" ${selectedStatus=='outofstock' ? 'selected' : '' }>Hết hàng</option>
                                        <option value="expiring" ${selectedStatus=='expiring' ? 'selected' : '' }>Sắp hết hạn</option>
                                        <option value="expired" ${selectedStatus=='expired' ? 'selected' : '' }>Đã hết hạn</option>
                                    </select>
                                </div>

                                 <div class="filter-group">
                                    <label>Sắp xếp</label>
                                    <select name="sort" class="form-control" onchange="this.form.submit()">
                                        <option value="newest" ${selectedSort=='newest' ? 'selected' : '' }>Mới nhất</option>
                                        <option value="name_asc" ${selectedSort=='name_asc' ? 'selected' : '' }>Tên A-Z</option>
                                        <option value="price_asc" ${selectedSort=='price_asc' ? 'selected' : '' }>Giá thấp - cao</option>
                                        <option value="price_desc" ${selectedSort=='price_desc' ? 'selected' : '' }>Giá cao - thấp</option>
                                    </select>
                                </div>
                            </form>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách sản phẩm (${totalProducts})</h3>
                                    <div style="display: flex; gap: 10px;">
                                        <button class="btn btn-sm btn-outline" onclick="exportExcel()">
                                            <i class="fas fa-download"></i>
                                            Xuất Excel
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <div class="table-wrapper">
                                        <table class="admin-table" id="productsTable">
                                            <thead>
                                                <tr>
                                                    <th style="width: 50px;">
                                                        <input type="checkbox" id="selectAll" title="Chọn tất cả">
                                                    </th>
                                                    <th>Sản phẩm</th>
                                                    <th>Danh mục</th>
                                                    <th>Giá</th>
                                                    <th>Tồn kho</th>
                                                    <th>Đã bán</th>
                                                    <th>Trạng thái</th>
                                                    <th style="width: 150px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty products}">
                                                        <tr>
                                                            <td colspan="8" style="text-align: center; padding: 40px;">
                                                                <i class="fas fa-box-open"
                                                                    style="font-size: 48px; color: #ccc; margin-bottom: 10px;"></i>
                                                                <p style="color: #666;">Không tìm thấy sản phẩm nào</p>
                                                                <a href="${pageContext.request.contextPath}/admin/products/add"
                                                                    class="btn btn-primary" style="margin-top: 10px;">
                                                                    <i class="fas fa-plus"></i> Thêm sản phẩm đầu tiên
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="product" items="${products}">
                                                            <tr>
                                                                <td><input type="checkbox" class="product-checkbox"
                                                                        name="productIds" value="${product.id}"></td>
                                                                <td>
                                                                    <div class="product-cell" onclick="window.open('${pageContext.request.contextPath}/chi-tiet-san-pham?id=${product.id}', '_blank')" title="Xem trên trang chủ">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.primaryImageUrl}">
                                                                                <img src="${product.primaryImageUrl}"
                                                                                    alt="${product.name}"
                                                                                    class="product-img">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                                                    alt="${product.name}"
                                                                                    class="product-img">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div>
                                                                            <div class="product-name">${product.name}</div>
                                                                            <div class="product-sku">ID: ${product.id}</div>
                                                                            <c:if test="${not empty product.variants}">
                                                                                <div class="variants-expiry-list" style="margin-top: 4px; display: flex; flex-direction: column; gap: 2px;">
                                                                                    <c:forEach var="variant" items="${product.variants}">
                                                                                        <c:if test="${not empty variant.expiryDate}">
                                                                                            <div style="font-size: 11px; color: #64748b; display: flex; align-items: center; gap: 4px; flex-wrap: wrap;">
                                                                                                <span>${variant.optionsValue}:</span>
                                                                                                <c:choose>
                                                                                                    <c:when test="${variant.expiryStatus == 'đã hết hạn'}">
                                                                                                        <span class="badge danger" style="padding: 1px 4px; font-size: 10px; line-height: 1; height: auto; text-transform: none; display: inline-flex; align-items: center;">Hết hạn (<fmt:formatDate value="${variant.expiryDate}" pattern="dd/MM/yyyy" />)</span>
                                                                                                    </c:when>
                                                                                                    <c:when test="${variant.expiryStatus == 'sắp hết hạn'}">
                                                                                                        <span class="badge warning" style="padding: 1px 4px; font-size: 10px; line-height: 1; height: auto; text-transform: none; display: inline-flex; align-items: center;">Sắp hết hạn (<fmt:formatDate value="${variant.expiryDate}" pattern="dd/MM/yyyy" />)</span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span class="badge success" style="padding: 1px 4px; font-size: 10px; line-height: 1; height: auto; text-transform: none; background: #e2e8f0; color: #475569; border-color: #cbd5e1; display: inline-flex; align-items: center;">Còn hạn (<fmt:formatDate value="${variant.expiryDate}" pattern="dd/MM/yyyy" />)</span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty product.category}">
                                                                            ${product.category.name}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span style="color: #999;">Chưa phân
                                                                                loại</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <strong>
                                                                        <fmt:formatNumber value="${product.minPrice}"
                                                                            type="number" groupingUsed="true"
                                                                            maxFractionDigits="0" />đ
                                                                    </strong>
                                                                </td>
                                                                <td>${product.totalStock}</td>
                                                                <td>${product.soldCount}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${product.totalStock == 0}">
                                                                            <span class="badge danger">Hết hàng</span>
                                                                        </c:when>
                                                                        <c:when test="${product.totalStock <= 10}">
                                                                            <span class="badge warning">Sắp hết</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge success">Còn hàng</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <div class="action-buttons">
                                                                        <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}"
                                                                            class="btn btn-sm btn-outline" title="Sửa">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/admin/products/delete"
                                                                            method="post" style="display: inline;"
                                                                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?');">
                                                                            <input type="hidden" name="id"
                                                                                value="${product.id}">
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

                                <c:if test="${totalPages > 1}">
                                    <c:set var="filterParams" value="" />
                                    <c:if test="${selectedCategory > 0}">
                                        <c:set var="filterParams" value="${filterParams}&category=${selectedCategory}" />
                                    </c:if>
                                    <c:if test="${not empty selectedStatus}">
                                        <c:set var="filterParams" value="${filterParams}&status=${selectedStatus}" />
                                    </c:if>
                                    <c:if test="${not empty selectedSort && selectedSort != 'newest'}">
                                        <c:set var="filterParams" value="${filterParams}&sort=${selectedSort}" />
                                    </c:if>
                                    <c:if test="${not empty searchKeyword}">
                                        <c:set var="filterParams" value="${filterParams}&search=${searchKeyword}" />
                                    </c:if>

                                    <div class="card-footer">
                                        <div class="pagination">
                                            <c:choose>
                                                <c:when test="${currentPage == 1}">
                                                    <span class="disabled"><i class="fas fa-chevron-left"></i></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}${filterParams}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="active">${i}</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                        <a href="${pageContext.request.contextPath}/admin/products?page=${i}${filterParams}">${i}</a>
                                                    </c:when>
                                                    <c:when test="${i == 4 && currentPage > 5}">
                                                        <span>...</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i == totalPages - 2 && currentPage < totalPages - 4}">
                                                        <span>...</span>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${currentPage == totalPages}">
                                                    <span class="disabled"><i class="fas fa-chevron-right"></i></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}${filterParams}">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </main>
                </div>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var selectAll = document.getElementById('selectAll');
                        var productCheckboxes = document.querySelectorAll('.product-checkbox');
                        var totalProducts = ${totalProducts != null ? totalProducts : 0};

                        if (selectAll) {
                            selectAll.addEventListener('change', function () {
                                productCheckboxes.forEach(function (cb) {
                                    cb.checked = selectAll.checked;
                                });
                            });
                        }

                        productCheckboxes.forEach(function (checkbox) {
                            checkbox.addEventListener('change', function () {
                                if (selectAll) {
                                    selectAll.checked = document.querySelectorAll('.product-checkbox:checked').length === productCheckboxes.length;
                                }
                            });
                        });
                    });

                    function exportExcel() {
                        var selected = document.querySelectorAll('.product-checkbox:checked');
                        var url = '${pageContext.request.contextPath}/admin/products/export';
                        
                        if (selected.length > 0) {
                            var ids = Array.from(selected).map(cb => cb.value).join(',');
                            window.location.href = url + '?ids=' + ids;
                        } else {
                            var searchParams = new URLSearchParams(window.location.search);
                            window.location.href = url + '?' + searchParams.toString();
                        }
                    }
                </script>
            </body>

            </html>