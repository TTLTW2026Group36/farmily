<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa Khách hàng #${user.id} - Admin Farmily</title>
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
                                    <h1 class="content-title">Chỉnh sửa Khách hàng #${user.id}</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/users">Khách hàng</a>
                                        <span>/</span>
                                        <span>Chỉnh sửa #${user.id}</span>
                                    </div>
                                </div>
                            </div>

                            <form class="edit-form" method="post"
                                action="${pageContext.request.contextPath}/admin/users/edit">
                                <input type="hidden" name="id" value="${user.id}">

                                <div class="form-grid">
                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin cơ bản</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="customerId">Mã khách hàng</label>
                                                <input type="text" id="customerId" value="#${user.id}" disabled>
                                            </div>

                                            <div class="form-group">
                                                <label for="name">Họ và tên</label>
                                                <input type="text" id="name" name="name" value="${user.name}"
                                                    placeholder="Nhập họ và tên">
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label for="email">Email <span class="required">*</span></label>
                                                    <input type="email" id="email" name="email" value="${user.email}"
                                                        required>
                                                </div>

                                                <div class="form-group">
                                                    <label for="phone">Số điện thoại</label>
                                                    <input type="tel" id="phone" name="phone" value="${user.phone}"
                                                        placeholder="Nhập số điện thoại">
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label for="role">Vai trò</label>
                                                <select id="role" name="role">
                                                    <option value="customer" ${user.role=='customer' ? 'selected' : ''
                                                        }>Khách hàng</option>
                                                    <option value="admin" ${user.role=='admin' ? 'selected' : '' }>Admin
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin tài khoản</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-display">
                                                <div class="info-item">
                                                    <span class="info-label">Ngày đăng ký:</span>
                                                    <span class="info-value">
                                                        <fmt:formatDate value="${user.created_at}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Cập nhật lần cuối:</span>
                                                    <span class="info-value">
                                                        <fmt:formatDate value="${user.updated_at}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                                </div>
                                            </div>

                                            <hr style="margin: 20px 0; border: none; border-top: 1px solid #eee;">

                                            
                                            <div class="card" style="background: #f8f9fa; border: 1px solid #dee2e6;">
                                                <div class="card-header" style="background: transparent;">
                                                    <h4 style="font-size: 1rem; margin: 0;">Đặt lại mật khẩu</h4>
                                                </div>
                                                <div class="card-body">
                                                    <div class="form-group">
                                                        <label for="newPassword">Mật khẩu mới</label>
                                                        <input type="password" id="newPassword" name="newPassword"
                                                            placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)"
                                                            form="resetPasswordForm">
                                                    </div>
                                                    <button type="submit" class="btn btn-warning"
                                                        form="resetPasswordForm"
                                                        onclick="return confirm('Bạn có chắc chắn muốn đặt lại mật khẩu cho khách hàng này?');">
                                                        <i class="fas fa-key"></i> Đặt lại mật khẩu
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                    <button type="button" class="btn btn-danger"
                                        onclick="if(confirm('Bạn có chắc chắn muốn xóa khách hàng này?')) document.getElementById('deleteForm').submit();">
                                        <i class="fas fa-trash"></i> Xóa khách hàng
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </form>

                            
                            <form id="deleteForm" method="post"
                                action="${pageContext.request.contextPath}/admin/users/delete" style="display: none;">
                                <input type="hidden" name="id" value="${user.id}">
                            </form>

                            <form id="resetPasswordForm" method="post"
                                action="${pageContext.request.contextPath}/admin/users/reset-password">
                                <input type="hidden" name="id" value="${user.id}">
                            </form>

                        </div>
                    </main>
                </div>

            </body>

            </html>