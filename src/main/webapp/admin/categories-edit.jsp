<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


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
                        <div class="content-header">
                            <div>
                                <h1 class="content-title">Chỉnh sửa danh mục: ${category.name}</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/index"><i class="fas fa-home"></i>
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
                                            <input type="text" name="name" id="categoryName" value="${category.name}"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label for="categoryDescription">Mô tả</label>
                                            <textarea id="categoryDescription" name="imageUrl" rows="1"
                                                placeholder="URL hình ảnh danh mục...">${category.imageUrl}</textarea>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <div class="card" style="margin-bottom: 24px;">
                                        <div class="card-header">
                                            <h3 class="card-title">Cài đặt hiển thị</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="categoryStatus">Trạng thái</label>
                                                <select id="categoryStatus">
                                                    <option selected>Hiển thị</option>
                                                    <option>Ẩn</option>
                                                </select>
                                            </div>

                                            <div class="form-group" style="margin-bottom: 0;">
                                                <label
                                                    style="display: flex; align-items: center; gap: 8px; cursor: pointer; margin-bottom: 0;">
                                                    <input type="checkbox" id="showOnHome" checked
                                                        style="width: auto; margin: 0;">
                                                    <span>Hiển thị trên trang chủ</span>
                                                </label>
                                            </div>

                                            <hr style="margin: 20px 0; border: none; border-top: 1px solid #e2e8f0;">

                                            <div class="form-group" style="margin-bottom: 0;">
                                                <label
                                                    style="display: flex; align-items: center; gap: 8px; cursor: pointer; margin-bottom: 0;">
                                                    <input type="checkbox" id="showInMenu" checked
                                                        style="width: auto; margin: 0;">
                                                    <span>Hiển thị trong menu</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thống kê</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-display">
                                                <div class="info-item">
                                                    <span class="info-label">Số sản phẩm:</span>
                                                    <span class="info-value"><strong>45</strong> sản phẩm</span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Ngày tạo:</span>
                                                    <span class="info-value">15/12/2024 10:30</span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Cập nhật cuối:</span>
                                                    <span class="info-value">20/01/2025 14:20</span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Lượt xem:</span>
                                                    <span class="info-value"
                                                        style="color: #16a34a;"><strong>1.234</strong> lượt</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                        
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/categories/delete"
                                style="display: inline;" onsubmit="return confirm('Xóa \'${category.name}\'?');">
                                <input type="hidden" name="id" value="${category.id}" />

                                <button type="submit" class="btn btn-danger" title="Xóa">
                                    <i class="fas fa-trash"></i> Xóa danh mục
                                </button>
                            </form>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                        </div>


                    </div>
                </main>
            </div>

        </body>

        </html>