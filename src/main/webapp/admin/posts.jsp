<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Bài viết - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/posts.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    .status-filter {
                        display: flex;
                        gap: 12px;
                        margin-bottom: 16px;
                        flex-wrap: wrap;
                    }

                    .status-filter a {
                        padding: 8px 16px;
                        border-radius: 8px;
                        text-decoration: none;
                        color: #64748b;
                        background: #f1f5f9;
                        font-size: 14px;
                        transition: all 0.2s;
                    }

                    .status-filter a:hover {
                        background: #e2e8f0;
                    }

                    .status-filter a.active {
                        background: #22c55e;
                        color: white;
                    }

                    .alert {
                        padding: 12px 16px;
                        border-radius: 8px;
                        margin-bottom: 16px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .alert-success {
                        background: #dcfce7;
                        color: #166534;
                        border: 1px solid #bbf7d0;
                    }

                    .alert-error {
                        background: #fef2f2;
                        color: #dc2626;
                        border: 1px solid #fecaca;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 60px 20px;
                        color: #64748b;
                    }

                    .empty-state i {
                        font-size: 48px;
                        margin-bottom: 16px;
                        color: #cbd5e1;
                    }
                </style>
            </head>

            <body data-page="posts">
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">
                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Quản lý Bài viết</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Bài viết</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/posts/add"
                                        class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm bài viết
                                    </a>
                                </div>
                            </div>


                            <c:if test="${not empty success}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> ${success}
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-circle"></i> ${error}
                                </div>
                            </c:if>


                            <div class="status-filter">
                                <a href="${pageContext.request.contextPath}/admin/posts"
                                    class="${empty selectedStatus ? 'active' : ''}">
                                    Tất cả (${publishedCount + draftCount + pendingCount})
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/posts?status=published"
                                    class="${selectedStatus == 'published' ? 'active' : ''}">
                                    Đã đăng (${publishedCount})
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/posts?status=draft"
                                    class="${selectedStatus == 'draft' ? 'active' : ''}">
                                    Nháp (${draftCount})
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/posts?status=pending"
                                    class="${selectedStatus == 'pending' ? 'active' : ''}">
                                    Chờ duyệt (${pendingCount})
                                </a>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách bài viết (${totalPosts})</h3>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <c:choose>
                                        <c:when test="${empty posts}">
                                            <div class="empty-state">
                                                <i class="fas fa-file-alt"></i>
                                                <p>Chưa có bài viết nào</p>
                                                <a href="${pageContext.request.contextPath}/admin/posts/add"
                                                    class="btn btn-primary" style="margin-top: 16px;">
                                                    <i class="fas fa-plus"></i> Thêm bài viết đầu tiên
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <table class="admin-table" id="postsTable">
                                                <thead>
                                                    <tr>
                                                        <th>Tiêu đề</th>
                                                        <th>Danh mục</th>
                                                        <th>Tác giả</th>
                                                        <th>Lượt xem</th>
                                                        <th>Trạng thái</th>
                                                        <th>Ngày đăng</th>
                                                        <th style="width: 150px;">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="post" items="${posts}">
                                                        <tr data-id="${post.id}">
                                                            <td>
                                                                <div
                                                                    style="display: flex; gap: 12px; align-items: center;">
                                                                    <img src="${not empty post.imageUrl ? post.imageUrl : 'https://via.placeholder.com/60x40?text=No+Image'}"
                                                                        alt="${post.title}"
                                                                        style="width: 60px; height: 40px; object-fit: cover; border-radius: 4px;">
                                                                    <div>
                                                                        <div
                                                                            style="font-weight: 600; margin-bottom: 3px;">
                                                                            ${post.title}</div>
                                                                        <div style="font-size: 12px; color: #64748b;">
                                                                            ID: ${post.id}</div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>${post.categoryName}</td>
                                                            <td>${post.authorName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${post.viewCount}" />
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${post.status == 'published'}">
                                                                        <span class="badge success">Đã đăng</span>
                                                                    </c:when>
                                                                    <c:when test="${post.status == 'draft'}">
                                                                        <span class="badge warning">Nháp</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge info">Chờ duyệt</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${post.createdAt}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td>
                                                                <div class="action-buttons">
                                                                    <a href="${pageContext.request.contextPath}/admin/posts/edit?id=${post.id}"
                                                                        class="btn btn-sm btn-outline" title="Sửa">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>
                                                                    <button class="btn btn-sm btn-danger btn-delete"
                                                                        data-id="${post.id}" title="Xóa">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </div>


                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer">
                                        <div class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <a
                                                    href="${pageContext.request.contextPath}/admin/posts?page=${currentPage - 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="active">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a
                                                            href="${pageContext.request.contextPath}/admin/posts?page=${i}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <a
                                                    href="${pageContext.request.contextPath}/admin/posts?page=${currentPage + 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </main>
                </div>

                <script>
                    // Delete post with AJAX
                    document.querySelectorAll('.btn-delete').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            const postId = this.dataset.id;

                            if (!confirm('Bạn có chắc chắn muốn xóa bài viết này?')) {
                                return;
                            }

                            fetch('${pageContext.request.contextPath}/admin/posts/delete', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: 'id=' + postId
                            })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        // Remove row from table
                                        const row = document.querySelector(`tr[data-id="${postId}"]`);
                                        if (row) {
                                            row.style.animation = 'fadeOut 0.3s ease';
                                            setTimeout(() => row.remove(), 300);
                                        }
                                        // Show success message
                                        showAlert('success', data.message);
                                    } else {
                                        showAlert('error', data.message);
                                    }
                                })
                                .catch(err => {
                                    console.error(err);
                                    showAlert('error', 'Đã xảy ra lỗi khi xóa bài viết');
                                });
                        });
                    });

                    function showAlert(type, message) {
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-' + type;
                        alertDiv.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : 'exclamation') + '-circle"></i> ' + message;

                        const content = document.querySelector('.admin-content');
                        const header = content.querySelector('.content-header');
                        header.insertAdjacentElement('afterend', alertDiv);

                        setTimeout(() => alertDiv.remove(), 3000);
                    }
                </script>

                <style>
                    @keyframes fadeOut {
                        from {
                            opacity: 1;
                            transform: translateX(0);
                        }

                        to {
                            opacity: 0;
                            transform: translateX(-20px);
                        }
                    }
                </style>
            </body>

            </html>