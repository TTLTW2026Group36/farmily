<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết Khách hàng #${user.id} - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers-edit.css">
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
                                    <h1 class="content-title">Chi tiết Khách hàng #${user.id}</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/users">Khách hàng</a>
                                        <span>/</span>
                                        <span>Chi tiết #${user.id}</span>
                                    </div>
                                </div>
                                <div>
                                    <br>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}"
                                        class="btn btn-primary">
                                        <i class="fas fa-edit"></i> Chỉnh sửa
                                    </a>
                                </div>
                            </div>

                            <div class="order-detail-grid">
                                
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Thông tin khách hàng</h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="info-row">
                                            <span class="info-label">Mã khách hàng:</span>
                                            <span class="info-value"><strong>#${user.id}</strong></span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Họ và tên:</span>
                                            <span class="info-value">
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${not empty user.name}">${user.name}</c:when>
                                                        <c:otherwise><span style="color: #999;">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Email:</span>
                                            <span class="info-value">${user.email}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Số điện thoại:</span>
                                            <span class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty user.phone}">${user.phone}</c:when>
                                                    <c:otherwise><span style="color: #999;">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Vai trò:</span>
                                            <span class="info-value">
                                                <c:choose>
                                                    <c:when test="${user.role == 'admin'}">
                                                        <span class="badge"
                                                            style="background: #dc3545; color: white;">Admin</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge"
                                                            style="background: #28a745; color: white;">Khách hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Ngày đăng ký:</span>
                                            <span class="info-value">
                                                <fmt:formatDate value="${user.created_at}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Cập nhật lần cuối:</span>
                                            <span class="info-value">
                                                <fmt:formatDate value="${user.updated_at}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Thống kê mua hàng</h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="stats-grid" style="grid-template-columns: 1fr 1fr; gap: 15px;">
                                            <div class="stat-item"
                                                style="background: #e0f2fe; padding: 15px; border-radius: 8px;">
                                                <div style="color: #0284c7; font-size: 0.9rem; margin-bottom: 5px;">Tổng
                                                    đơn hàng</div>
                                                <div style="font-size: 1.8rem; font-weight: 700; color: #0c4a6e;">-
                                                </div>
                                            </div>
                                            <div class="stat-item"
                                                style="background: #dcfce7; padding: 15px; border-radius: 8px;">
                                                <div style="color: #16a34a; font-size: 0.9rem; margin-bottom: 5px;">Tổng
                                                    chi tiêu</div>
                                                <div style="font-size: 1.8rem; font-weight: 700; color: #14532d;">-
                                                </div>
                                            </div>
                                        </div>
                                        <p style="color: #666; margin-top: 15px; font-size: 0.9rem;">
                                            <i class="fas fa-info-circle"></i>
                                            Thống kê sẽ hiển thị khi module đơn hàng được tích hợp.
                                        </p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </main>
                </div>
            </body>

            </html>