<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Khách hàng - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
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
                                    <h1 class="content-title">Quản lý Khách hàng</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Khách hàng</span>
                                    </div>
                                </div>
                            </div>

                            
                            <form method="get" action="${pageContext.request.contextPath}/admin/users"
                                class="filters-bar">
                                <div class="filter-group">
                                    <label>Tìm kiếm</label>
                                    <input type="text" name="search" class="form-control"
                                        placeholder="Tên hoặc email..." value="${searchKeyword}">
                                </div>
                                <div class="filter-group" style="display: flex; align-items: end;">
                                    <button type="submit" class="btn btn-secondary">
                                        <i class="fas fa-search"></i>
                                        Tìm kiếm
                                    </button>
                                </div>
                            </form>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách khách hàng (${totalUsers})</h3>
                                    <button class="btn btn-sm btn-outline" onclick="showNotification()">
                                        <i class="fas fa-download"></i> Xuất Excel
                                    </button>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <table class="admin-table" id="customersTable">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Họ tên</th>
                                                <th>Email</th>
                                                <th>Số điện thoại</th>
                                                <th>Vai trò</th>
                                                <th>Ngày đăng ký</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty users}">
                                                    <tr>
                                                        <td colspan="7" style="text-align: center; padding: 40px;">
                                                            <i class="fas fa-users"
                                                                style="font-size: 48px; color: #ccc; margin-bottom: 10px;"></i>
                                                            <p style="color: #666;">Chưa có khách hàng nào</p>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="user" items="${users}">
                                                        <tr>
                                                            <td><strong>#${user.id}</strong></td>
                                                            <td>
                                                                <div style="font-weight: 600;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty user.name}">
                                                                            ${user.name}</c:when>
                                                                        <c:otherwise><span style="color: #999;">Chưa cập
                                                                                nhật</span></c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </td>
                                                            <td>${user.email}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty user.phone}">${user.phone}
                                                                    </c:when>
                                                                    <c:otherwise><span style="color: #999;">-</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${user.role == 'admin'}">
                                                                        <span class="badge"
                                                                            style="background: #dc3545; color: white;">Admin</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge"
                                                                            style="background: #28a745; color: white;">Khách
                                                                            hàng</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${user.created_at}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td>
                                                                <div class="action-buttons">
                                                                    <a href="${pageContext.request.contextPath}/admin/users/view?id=${user.id}"
                                                                        class="btn btn-sm btn-outline" title="Xem">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}"
                                                                        class="btn btn-sm btn-outline" title="Sửa">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                
                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer">
                                        <div class="pagination">
                                            
                                            <c:choose>
                                                <c:when test="${currentPage == 1}">
                                                    <span class="disabled"><i class="fas fa-chevron-left"></i></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a
                                                        href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}">
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
                                                        <a
                                                            href="${pageContext.request.contextPath}/admin/users?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}">${i}</a>
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
                                                    <a
                                                        href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}">
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
                    function showNotification() {
                        alert("Đang xuất file excel");
                    }
                </script>
            </body>

            </html>