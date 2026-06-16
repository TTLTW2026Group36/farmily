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

                    .btn-toggle {
                        border: 1px solid #94a3b8;
                        color: #64748b;
                        background: transparent;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .btn-toggle:hover {
                        background: #f1f5f9;
                        border-color: #64748b;
                    }

                    .btn-toggle.btn-published {
                        border-color: #22c55e;
                        color: #22c55e;
                    }

                    .btn-toggle.btn-published:hover {
                        background: #f0fdf4;
                    }

                    .btn-toggle.btn-hidden {
                        border-color: #94a3b8;
                        color: #94a3b8;
                    }

                    .btn-toggle.btn-hidden:hover {
                        background: #f8fafc;
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
                                    <a href="${pageContext.request.contextPath}/admin/posts/categories"
                                        class="btn btn-outline" style="margin-right: 8px;">
                                        <i class="fas fa-list"></i> Quản lý danh mục
                                    </a>
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
                                                                        style="width: 60px; height: 40px; min-width: 60px; min-height: 40px; object-fit: cover; border-radius: 4px; flex-shrink: 0;">
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
                                                                    <button
                                                                        class="btn btn-sm btn-toggle ${post.status == 'published' ? 'btn-published' : 'btn-hidden'}"
                                                                        data-id="${post.id}"
                                                                        data-status="${post.status}"
                                                                        title="${post.status == 'published' ? 'Ẩn bài viết' : 'Hiện bài viết'}">
                                                                        <i
                                                                            class="fas ${post.status == 'published' ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                                                    </button>
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
                    function showConfirm(title, message, onConfirm) {
                        const overlay = document.createElement('div');
                        overlay.className = 'confirm-overlay';
                        overlay.innerHTML = `
                            <div class="confirm-box">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h3>\${title}</h3>
                                <p>\${message}</p>
                                <div class="confirm-buttons">
                                    <button class="confirm-btn confirm-btn-cancel">Hủy</button>
                                    <button class="confirm-btn confirm-btn-ok">Xác nhận</button>
                                </div>
                            </div>
                        `;
                        document.body.appendChild(overlay);

                        overlay.querySelector('.confirm-btn-cancel').addEventListener('click', () => overlay.remove());
                        overlay.querySelector('.confirm-btn-ok').addEventListener('click', () => {
                            overlay.remove();
                            onConfirm();
                        });
                    }

                    document.querySelectorAll('.btn-delete').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            const postId = this.dataset.id;

                            showConfirm('Xác nhận xóa', 'Bạn có chắc chắn muốn xóa vĩnh viễn bài viết này không?', () => {
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
                                            const row = document.querySelector(`tr[data-id="${postId}"]`);
                                            if (row) {
                                                row.style.animation = 'fadeOut 0.3s ease';
                                                setTimeout(() => row.remove(), 300);
                                            }
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
                    });

                    document.querySelectorAll('.btn-toggle').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            const postId = this.dataset.id;
                            const currentStatus = this.dataset.status;
                            const action = currentStatus === 'published' ? 'ẩn' : 'hiện';

                            showConfirm('Thay đổi trạng thái', 'Bạn có chắc chắn muốn ' + action + ' bài viết này không?', () => {
                                fetch('${pageContext.request.contextPath}/admin/posts/toggle', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'id=' + postId
                                })
                                    .then(res => res.json())
                                    .then(data => {
                                        if (data.success) {
                                            this.dataset.status = data.status;
                                            this.title = data.isPublished ? 'Ẩn bài viết' : 'Hiện bài viết';
                                            this.className = 'btn btn-sm btn-toggle ' +
                                                (data.isPublished ? 'btn-published' : 'btn-hidden');
                                            this.querySelector('i').className = 'fas ' +
                                                (data.isPublished ? 'fa-eye' : 'fa-eye-slash');

                                            const row = document.querySelector('tr[data-id="' + postId + '"]');
                                            if (row) {
                                                const badge = row.querySelector('.badge');
                                                if (badge) {
                                                    badge.className = 'badge ' + data.badgeClass;
                                                    badge.textContent = data.statusText;
                                                }
                                            }

                                            showAlert('success', 'Đã ' + action + ' bài viết thành công');
                                        } else {
                                            showAlert('error', data.message || 'Đã xảy ra lỗi');
                                        }
                                    })
                                    .catch(err => {
                                        console.error(err);
                                        showAlert('error', 'Đã xảy ra lỗi khi thay đổi trạng thái');
                                    });
                            });
                        });
                    });
                    function showAlert(type, message) {
                        let container = document.querySelector('.toast-container');
                        if (!container) {
                            container = document.createElement('div');
                            container.className = 'toast-container';
                            document.body.appendChild(container);
                        }

                        const toast = document.createElement('div');
                        toast.className = 'custom-toast toast-' + type;

                        let icon = 'info-circle';
                        if (type === 'success') icon = 'check-circle';
                        else if (type === 'error') icon = 'exclamation-circle';
                        else if (type === 'warning') icon = 'exclamation-triangle';

                        toast.innerHTML = '<i class="fas fa-' + icon + '"></i> <span>' + message + '</span>';
                        container.appendChild(toast);

                        setTimeout(() => {
                            toast.remove();
                            if (container.childElementCount === 0) {
                                container.remove();
                            }
                        }, 3000);
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

                    /* Toast Notification Center */
                    .toast-container {
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        z-index: 9999;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 12px;
                        pointer-events: none;
                    }

                    .custom-toast {
                        pointer-events: auto;
                        background: rgba(255, 255, 255, 0.98);
                        border-left: 5px solid #3b82f6;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                        padding: 16px 28px;
                        border-radius: 8px;
                        font-size: 15px;
                        font-weight: 500;
                        color: #1e293b;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        min-width: 320px;
                        max-width: 480px;
                        animation: toastFadeIn 0.35s cubic-bezier(0.34, 1.56, 0.64, 1), toastFadeOut 0.35s ease forwards 2.65s;
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(226, 232, 240, 0.8);
                    }

                    .custom-toast.toast-success {
                        border-left-color: #22c55e;
                    }

                    .custom-toast.toast-error {
                        border-left-color: #ef4444;
                    }

                    .custom-toast.toast-warning {
                        border-left-color: #f59e0b;
                    }

                    .custom-toast i {
                        font-size: 18px;
                    }

                    .custom-toast.toast-success i {
                        color: #22c55e;
                    }

                    .custom-toast.toast-error i {
                        color: #ef4444;
                    }

                    .custom-toast.toast-warning i {
                        color: #f59e0b;
                    }

                    @keyframes toastFadeIn {
                        from {
                            opacity: 0;
                            transform: scale(0.9);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1);
                        }
                    }

                    @keyframes toastFadeOut {
                        from {
                            opacity: 1;
                            transform: scale(1);
                        }

                        to {
                            opacity: 0;
                            transform: scale(0.9);
                        }
                    }

                    .confirm-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(15, 23, 42, 0.45);
                        backdrop-filter: blur(4px);
                        z-index: 10000;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        animation: fadeInBg 0.2s ease;
                    }

                    .confirm-box {
                        background: #ffffff;
                        border-radius: 12px;
                        padding: 24px;
                        width: 90%;
                        max-width: 400px;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.05);
                        text-align: center;
                        animation: scaleInConfirm 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
                        border: 1px solid rgba(226, 232, 240, 0.8);
                    }

                    .confirm-box i {
                        font-size: 42px;
                        color: #eab308;
                        margin-bottom: 16px;
                    }

                    .confirm-box h3 {
                        margin: 0 0 8px 0;
                        font-size: 18px;
                        color: #0f172a;
                        font-weight: 600;
                    }

                    .confirm-box p {
                        margin: 0 0 24px 0;
                        font-size: 14px;
                        color: #64748b;
                        line-height: 1.5;
                    }

                    .confirm-buttons {
                        display: flex;
                        gap: 12px;
                        justify-content: center;
                    }

                    .confirm-btn {
                        padding: 10px 22px;
                        border-radius: 6px;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s;
                        border: 1px solid transparent;
                    }

                    .confirm-btn-cancel {
                        background: #f8fafc;
                        color: #475569;
                        border-color: #cbd5e1;
                    }

                    .confirm-btn-cancel:hover {
                        background: #f1f5f9;
                        border-color: #94a3b8;
                    }

                    .confirm-btn-ok {
                        background: #0f172a;
                        color: #ffffff;
                    }

                    .confirm-btn-ok:hover {
                        background: #1e293b;
                    }

                    @keyframes fadeInBg {
                        from {
                            opacity: 0;
                        }

                        to {
                            opacity: 1;
                        }
                    }

                    @keyframes scaleInConfirm {
                        from {
                            transform: scale(0.9);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }
                </style>
            </body>

            </html>