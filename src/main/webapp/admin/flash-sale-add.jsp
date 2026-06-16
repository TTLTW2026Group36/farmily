<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Flash Sale - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/product-add.css?v=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #10b981;
            --primary-dark: #047857;
            --primary-light: #ecfdf5;
            --warning: #f59e0b;
            --danger: #ef4444;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --border-radius: 12px;
            --border-radius-sm: 8px;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .simple-card {
            background: #ffffff;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-200);
            padding: 24px;
            margin-bottom: 24px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-800);
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .product-search-row {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }

        .search-input-wrapper {
            flex: 1;
            min-width: 250px;
            position: relative;
        }

        .search-input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
        }

        .search-input-wrapper input {
            padding-left: 40px !important;
        }

        .toggle-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            user-select: none;
            font-weight: 500;
            color: var(--gray-700);
        }

        .toggle-wrapper input {
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
            cursor: pointer;
        }

        .product-list-container {
            max-height: 380px;
            overflow-y: auto;
            border: 1px solid var(--gray-200);
            border-radius: var(--border-radius-sm);
            background: #ffffff;
        }

        .product-item-row {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            border-bottom: 1px solid var(--gray-100);
            cursor: pointer;
            transition: background 0.15s ease;
        }

        .product-item-row:last-child {
            border-bottom: none;
        }

        .product-item-row:hover {
            background: var(--gray-50);
        }

        .product-item-row.selected {
            background: var(--primary-light);
        }

        .product-item-checkbox-col {
            margin-right: 16px;
            display: flex;
            align-items: center;
        }

        .product-item-checkbox-col input {
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
            cursor: pointer;
        }

        .product-item-info-col {
            flex: 1;
        }

        .product-item-title {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .product-item-variants {
            font-size: 12px;
            color: var(--gray-500);
            margin-top: 4px;
        }

        .badge-warning-custom {
            background: #fffbeb;
            color: #d97706;
            border: 1px solid #fde68a;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-danger-custom {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fee2e2;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .selection-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 13px;
        }

        .btn-link {
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
            font-weight: 600;
            padding: 0;
            font-size: 13px;
            text-decoration: underline;
        }

        .btn-link:hover {
            color: var(--primary-dark);
        }

        .form-actions-simple {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }
    </style>
</head>

<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />

        <main class="admin-main">
            <jsp:include page="header.jsp" />

            <div class="admin-content" style="max-width: 900px; margin: 0 auto; padding: 20px;">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"
                        style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <div class="content-header" style="margin-bottom: 20px;">
                    <div>
                        <h1 class="content-title">Thêm Flash Sale mới</h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/admin/flash-sales">Flash Sale</a>
                            <span>/</span>
                            <span>Thêm mới</span>
                        </div>
                    </div>
                </div>

                <form class="admin-form" action="${pageContext.request.contextPath}/admin/flash-sales/add" method="post">
                    <div id="hiddenProductIdsContainer"></div>

                    <div class="simple-card">
                        <h3 class="card-title">
                            <i class="fas fa-cog" style="color: var(--primary);"></i>
                            Thông tin chương trình Flash Sale
                        </h3>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="discountPercent">Mức giảm giá (%) <span class="required">*</span></label>
                                <input type="number" id="discountPercent" name="discountPercent"
                                    class="form-control" placeholder="Ví dụ: 15" min="1" max="99" required>
                            </div>

                            <div class="form-group">
                                <label for="stockLimit">Số lượng mở bán tối đa <span class="required">*</span></label>
                                <input type="number" id="stockLimit" name="stockLimit" class="form-control"
                                    placeholder="Ví dụ: 30" min="1" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="startTime">Thời gian bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" id="startTime" name="startTime" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label for="endTime">Thời gian kết thúc <span class="required">*</span></label>
                                <input type="datetime-local" id="endTime" name="endTime" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="maxQtyPerUser">Giới hạn mua tối đa của 1 user</label>
                                <input type="number" id="maxQtyPerUser" name="maxQtyPerUser" class="form-control"
                                    placeholder="Ví dụ: 1 (Nhập 0 hoặc để trống để không giới hạn)" min="0" value="0">
                                <span style="font-size: 12px; color: var(--gray-500); margin-top: 4px; display: block;">
                                    Số lượng tối đa sản phẩm giảm giá này mà mỗi khách hàng được phép mua. Lần thứ 2 hoặc số lượng vượt quá sẽ tính theo giá gốc.
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="simple-card">
                        <h3 class="card-title">
                            <i class="fas fa-boxes" style="color: var(--primary);"></i>
                            Chọn sản phẩm áp dụng
                        </h3>

                        <div class="product-search-row">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchProduct" class="form-control" placeholder="Tìm kiếm sản phẩm nhanh...">
                            </div>

                            <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                                <label class="toggle-wrapper">
                                    <input type="checkbox" id="filterExpiringOnly">
                                    <span>Chỉ hiển thị sản phẩm sắp hết hạn</span>
                                </label>

                                <label class="toggle-wrapper">
                                    <input type="checkbox" id="filterActiveFlashSaleOnly" checked>
                                    <span>Ẩn sản phẩm đang chạy Flash Sale</span>
                                </label>
                            </div>
                        </div>

                        <div class="selection-bar">
                            <div>
                                Đã chọn: <span id="selectedCounter" style="color: var(--primary); font-weight: 700;">0</span> sản phẩm
                            </div>
                            <div style="display: flex; gap: 12px;">
                                <button type="button" class="btn-link" id="selectAllBtn">Chọn tất cả</button>
                                <span style="color: var(--gray-300);">|</span>
                                <button type="button" class="btn-link" id="deselectAllBtn" style="color: var(--gray-500);">Bỏ chọn hết</button>
                            </div>
                        </div>

                        <div class="product-list-container" id="productListContainer">
                        </div>
                    </div>

                    <div class="form-actions-simple">
                        <a href="${pageContext.request.contextPath}/admin/flash-sales" class="btn btn-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu Flash Sale
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        const activeFlashSaleProductIds = new Set([
            <c:if test="${not empty activeFlashSaleProductIds}">
                <c:forEach var="pid" items="${activeFlashSaleProductIds}">
                    ${pid},
                </c:forEach>
            </c:if>
        ]);

        const productData = [];
        <c:forEach var="product" items="${products}">
            productData.push({
                id: ${product.id},
                name: `<c:out value="${product.name}"/>`,
                hasActiveFlashSale: activeFlashSaleProductIds.has(${product.id}),
                variants: [
                    <c:forEach var="v" items="${product.variants}">
                        {
                            id: ${v.id},
                            optionsValue: `<c:out value="${v.optionsValue}"/>`,
                            price: ${v.price},
                            stock: ${v.stock},
                            expiryDate: "${v.expiryDate != null ? v.expiryDate : ''}",
                            expiryStatus: "${v.expiryStatus}"
                        },
                    </c:forEach>
                ]
            });
        </c:forEach>

        let selectedProductIds = new Set();
        let searchQuery = "";
        let filterExpiring = false;
        let filterActiveFlashSale = true;

        const searchInput = document.getElementById("searchProduct");
        const expiringToggle = document.getElementById("filterExpiringOnly");
        const activeFlashSaleToggle = document.getElementById("filterActiveFlashSaleOnly");
        const productListContainer = document.getElementById("productListContainer");
        const selectedCounter = document.getElementById("selectedCounter");
        const hiddenContainer = document.getElementById("hiddenProductIdsContainer");
        const selectAllBtn = document.getElementById("selectAllBtn");
        const deselectAllBtn = document.getElementById("deselectAllBtn");
        const form = document.querySelector(".admin-form");

        function isProductExpiring(product) {
            return product.variants && product.variants.some(v => v.expiryStatus === 'sắp hết hạn');
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
        }

        function formatDate(dateStr) {
            if (!dateStr) return "";
            try {
                const d = new Date(dateStr);
                if (isNaN(d.getTime())) return dateStr;
                return d.toLocaleDateString('vi-VN');
            } catch (e) {
                return dateStr;
            }
        }

        function getFilteredProducts() {
            return productData.filter(product => {
                if (searchQuery && !product.name.toLowerCase().includes(searchQuery.toLowerCase())) {
                    return false;
                }
                if (filterExpiring && !isProductExpiring(product)) {
                    return false;
                }
                if (filterActiveFlashSale && product.hasActiveFlashSale) {
                    return false;
                }
                return true;
            });
        }

        function renderProducts() {
            const filtered = getFilteredProducts();
            productListContainer.innerHTML = "";

            if (filtered.length === 0) {
                productListContainer.innerHTML = 
                    '<div style="text-align: center; padding: 40px; color: var(--gray-500);">' +
                        '<i class="fas fa-info-circle" style="font-size: 30px; margin-bottom: 10px; display: block; color: var(--gray-300);"></i>' +
                        'Không tìm thấy sản phẩm nào' +
                    '</div>';
                return;
            }

            filtered.forEach(product => {
                const isSelected = selectedProductIds.has(product.id);
                const row = document.createElement("div");
                row.className = "product-item-row" + (isSelected ? " selected" : "");
                row.dataset.id = product.id;

                let variantsStr = "";
                if (product.variants && product.variants.length > 0) {
                    variantsStr = "Phân loại: " + product.variants.map(v => {
                        return v.optionsValue + " (" + formatCurrency(v.price) + " - Kho: " + v.stock + ")";
                    }).join(", ");
                } else {
                    variantsStr = "Chưa cấu hình phân loại";
                }

                let expiryBadgeHtml = "";
                const expiringVariant = product.variants.find(v => v.expiryStatus === 'sắp hết hạn');
                const expiredVariant = product.variants.find(v => v.expiryStatus === 'đã hết hạn');

                if (expiringVariant) {
                    expiryBadgeHtml = '<span class="badge-warning-custom"><i class="fas fa-exclamation-triangle"></i> Sắp hết hạn (' + formatDate(expiringVariant.expiryDate) + ')</span>';
                } else if (expiredVariant) {
                    expiryBadgeHtml = '<span class="badge-danger-custom"><i class="fas fa-times-circle"></i> Đã hết hạn (' + formatDate(expiredVariant.expiryDate) + ')</span>';
                }

                if (product.hasActiveFlashSale) {
                    expiryBadgeHtml += '<span class="badge-danger-custom" style="background: #fff7ed; color: #ea580c; border: 1px solid #ffedd5; margin-left: 6px;"><i class="fas fa-fire"></i> Đang chạy Flash Sale</span>';
                }

                row.innerHTML = 
                    '<div class="product-item-checkbox-col">' +
                        '<input type="checkbox" class="product-item-checkbox" data-id="' + product.id + '" ' + (isSelected ? 'checked' : '') + '>' +
                    '</div>' +
                    '<div class="product-item-info-col">' +
                        '<div class="product-item-title">' +
                            '<span>' + product.name + '</span>' +
                            expiryBadgeHtml +
                        '</div>' +
                        '<div class="product-item-variants">' + variantsStr + '</div>' +
                    '</div>';

                row.addEventListener("click", (e) => {
                    if (e.target.type !== "checkbox" && !e.target.classList.contains("product-item-checkbox")) {
                        toggleProductSelection(product.id);
                    }
                });

                row.querySelector(".product-item-checkbox").addEventListener("change", () => {
                    toggleProductSelection(product.id);
                });

                productListContainer.appendChild(row);
            });
        }

        function toggleProductSelection(id) {
            if (selectedProductIds.has(id)) {
                selectedProductIds.delete(id);
            } else {
                selectedProductIds.add(id);
            }
            updateSelectionUI();
        }

        function updateSelectionUI() {
            hiddenContainer.innerHTML = "";
            selectedProductIds.forEach(id => {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = "productIds";
                input.value = id;
                hiddenContainer.appendChild(input);
            });

            selectedCounter.innerText = selectedProductIds.size;

            const checkboxes = productListContainer.querySelectorAll(".product-item-checkbox");
            checkboxes.forEach(cb => {
                const id = parseInt(cb.dataset.id);
                const row = cb.closest(".product-item-row");
                if (selectedProductIds.has(id)) {
                    cb.checked = true;
                    if (row) row.classList.add("selected");
                } else {
                    cb.checked = false;
                    if (row) row.classList.remove("selected");
                }
            });
        }

        searchInput.addEventListener("input", (e) => {
            searchQuery = e.target.value;
            renderProducts();
        });

        expiringToggle.addEventListener("change", (e) => {
            filterExpiring = e.target.checked;
            renderProducts();
        });

        activeFlashSaleToggle.addEventListener("change", (e) => {
            filterActiveFlashSale = e.target.checked;
            renderProducts();
        });

        selectAllBtn.addEventListener("click", () => {
            const filtered = getFilteredProducts();
            filtered.forEach(p => selectedProductIds.add(p.id));
            updateSelectionUI();
        });

        deselectAllBtn.addEventListener("click", () => {
            const filtered = getFilteredProducts();
            filtered.forEach(p => selectedProductIds.delete(p.id));
            updateSelectionUI();
        });

        form.addEventListener("submit", (e) => {
            if (selectedProductIds.size === 0) {
                e.preventDefault();
                alert("Vui lòng chọn ít nhất một sản phẩm để tạo Flash Sale!");
                return false;
            }
        });

        renderProducts();
    </script>
</body>

</html>