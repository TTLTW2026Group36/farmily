<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Trang tĩnh - Admin Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body data-page="static-pages">
            <div class="admin-layout">

                <jsp:include page="sidebar.jsp" />


                <main class="admin-main">

                    <jsp:include page="header.jsp" />


                    <div class="admin-content">
                        <div class="content-header">
                            <div>
                                <h1 class="content-title">Quản lý Trang tĩnh</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/index"><i class="fas fa-home"></i>
                                        Dashboard</a>
                                    <span>/</span>
                                    <span>Trang tĩnh</span>
                                </div>
                            </div>
                        </div>


                        <c:if test="${not empty success}">
                            <div class="alert alert-success"
                                style="background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-check-circle"></i>
                                ${success}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-error"
                                style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-exclamation-circle"></i>
                                ${error}
                            </div>
                        </c:if>

                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Danh sách trang tĩnh (${totalPages})</h3>
                            </div>
                            <div class="card-body" style="padding: 0;">
                                <table class="admin-table" id="staticPagesTable">
                                    <thead>
                                        <tr>
                                            <th style="width: 60px;">ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Slug</th>
                                            <th>Loại</th>
                                            <th>Trạng thái</th>
                                            <th>Cập nhật</th>
                                            <th style="width: 100px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="page" items="${staticPages}">
                                            <tr>
                                                <td>${page.id}</td>
                                                <td><strong>${page.title}</strong></td>
                                                <td><code
                                                        style="background: #f1f5f9; padding: 2px 8px; border-radius: 4px; font-size: 13px;">${page.slug}</code>
                                                </td>
                                                <td>${page.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${page.status == 'active'}">
                                                            <span class="badge success">Hiển thị</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge"
                                                                style="background: #f1f5f9; color: #64748b;">Ẩn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${page.updatedAt != null}">
                                                        ${page.updatedAt}
                                                    </c:if>
                                                    <c:if test="${page.updatedAt == null}">
                                                        -
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="${pageContext.request.contextPath}/admin/static-pages/edit?id=${page.id}"
                                                            class="btn btn-sm btn-outline" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty staticPages}">
                                            <tr>
                                                <td colspan="7"
                                                    style="text-align: center; padding: 40px; color: #64748b;">
                                                    <i class="fas fa-file-alt"
                                                        style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                                                    <p>Chưa có trang tĩnh nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <div class="card" style="margin-top: 20px; background: #fffbeb; border: 1px solid #fcd34d;">
                            <div class="card-body" style="padding: 16px;">
                                <div style="display: flex; gap: 12px; align-items: flex-start;">
                                    <i class="fas fa-info-circle"
                                        style="color: #d97706; font-size: 20px; margin-top: 2px;"></i>
                                    <div>
                                        <strong style="color: #92400e;">Lưu ý về Trang tĩnh</strong>
                                        <p style="margin: 8px 0 0; color: #78350f; font-size: 14px;">
                                            Các trang tĩnh (Giới thiệu, Hướng dẫn mua hàng, Điều khoản dịch vụ) được
                                            quản lý tại đây.
                                            Bạn có thể chỉnh sửa nội dung HTML trực tiếp. Nội dung hỗ trợ các thẻ HTML
                                            như
                                            <code>&lt;p&gt;</code>, <code>&lt;strong&gt;</code>,
                                            <code>&lt;ul&gt;</code>, <code>&lt;h2&gt;</code>, v.v.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>