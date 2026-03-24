<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Flash Sale - Admin Farmily</title>
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
                                <h1 class="content-title">Thêm Flash Sale mới</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                            class="fas fa-home"></i> Dashboard</a>
                                    <span>/</span>
                                    <a href="${pageContext.request.contextPath}/admin/flash-sales">Flash Sale</a>
                                    <span>/</span>
                                    <span>Thêm mới</span>
                                </div>
                            </div>
                            <div class="page-actions">
                                <a href="${pageContext.request.contextPath}/admin/flash-sales" class="btn btn-outline">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </div>

                        <form class="admin-form" action="${pageContext.request.contextPath}/admin/flash-sales/add"
                            method="post">
                            <div class="form-section">
                                <h3 class="form-section-title">Thông tin Flash Sale</h3>

                                <div class="form-group">
                                    <label for="productId">Sản phẩm <span class="required">*</span></label>
                                    <select id="productId" name="productId" class="form-control" required>
                                        <option value="">-- Chọn sản phẩm --</option>
                                        <c:forEach var="product" items="${products}">
                                            <option value="${product.id}">${product.name} (ID: ${product.id})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="discountPercent">Phần trăm giảm giá (%) <span
                                                class="required">*</span></label>
                                        <input type="number" id="discountPercent" name="discountPercent"
                                            class="form-control" placeholder="VD: 20" min="1" max="99" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="stockLimit">Giới hạn số lượng bán <span
                                                class="required">*</span></label>
                                        <input type="number" id="stockLimit" name="stockLimit" class="form-control"
                                            placeholder="VD: 50" min="1" required>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="startTime">Thời gian bắt đầu <span class="required">*</span></label>
                                        <input type="datetime-local" id="startTime" name="startTime"
                                            class="form-control" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="endTime">Thời gian kết thúc <span class="required">*</span></label>
                                        <input type="datetime-local" id="endTime" name="endTime" class="form-control"
                                            required>
                                    </div>
                                </div>
                            </div>

                            <div
                                style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                                <a href="${pageContext.request.contextPath}/admin/flash-sales"
                                    class="btn btn-secondary">Hủy bỏ</a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Lưu Flash Sale
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </body>

        </html>