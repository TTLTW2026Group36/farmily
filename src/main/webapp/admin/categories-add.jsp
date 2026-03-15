<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Danh mục mới - Admin Farmily</title>
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
                                <h1 class="content-title">Thêm Danh mục mới</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/index"><i class="fas fa-home"></i>
                                        Dashboard</a>
                                    <span>/</span>
                                    <a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a>
                                    <span>/</span>
                                    <span>Thêm mới</span>
                                </div>
                            </div>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/categories/add"
                            class="edit-form">
                            <div class="form-grid">
                                
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Thông tin danh mục</h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="form-group">
                                            <label for="categoryName">Tên danh mục <span
                                                    class="required">*</span></label>
                                            <input type="text" name="name" id="categoryName" placeholder="VD: Rau lá"
                                                required>
                                        </div>



                                        <div class="form-group">
                                            <label for="categoryDescription">Mô tả</label>
                                            <textarea id="categoryDescription" rows="4"
                                                placeholder="Nhập mô tả ngắn về danh mục..."></textarea>
                                        </div>



                                    </div>
                                </div>

                                
                                <div class="card">
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

                                        <hr style="margin: 20px 0; border: none; border-top: 1px solid #e2e8f0;">

                                        <div class="info-display" style="margin-top: 20px;">
                                            <h4 style="font-size: 14px; margin-bottom: 12px; color: #0369a1;">Hướng
                                                dẫn</h4>
                                            <ul
                                                style="font-size: 13px; color: #475569; line-height: 1.8; padding-left: 20px;">
                                                <li>Tên danh mục nên ngắn gọn, dễ hiểu</li>
                                                <li>Slug sẽ được dùng trong URL</li>
                                                <li>Mô tả giúp SEO tốt hơn</li>
                                                <li>Có thể tạo danh mục con bằng cách chọn danh mục cha</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Lưu danh mục
                                </button>
                            </div>
                        </form>

                    </div>
                </main>
            </div>

        </body>

        </html>