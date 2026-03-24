<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Danh mục - Admin Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories.css">
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
                                <h1 class="content-title">Quản lý Danh mục</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                            class="fas fa-home"></i> Dashboard</a>
                                    <span>/</span>
                                    <span>Danh mục</span>
                                </div>
                            </div>
                            <div class="page-actions">
                                <button class="btn btn-primary">
                                    <a href="${pageContext.request.contextPath}/admin/categories-add.jsp"
                                        style="color: inherit; text-decoration: none;">
                                        <i class="fas fa-plus"></i> Thêm danh mục
                                    </a>
                                </button>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Danh sách danh mục (${totalCategories})</h3>
                            </div>
                            <div class="card-body" style="padding: 0;">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên danh mục</th>
                                            <th>Số sản phẩm</th>
                                            <th>Trạng thái</th>
                                            <th style="width: 150px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="category" items="${categories}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><strong>${category.name}</strong></td>
                                                <td>0</td>
                                                <td><span class="badge success">Hiển thị</span></td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/categories/edit?id=${category.id}"
                                                            class="btn btn-sm btn-outline" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/admin/categories/delete"
                                                            style="display: inline;"
                                                            onsubmit="return confirm('Xóa \'${category.name}\'?');">
                                                            <input type="hidden" name="id" value="${category.id}" />
                                                            <button type="submit" class="btn btn-sm btn-danger"
                                                                title="Xóa">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
            </div>



        </body>

        </html>