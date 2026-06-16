<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục Bài viết - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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

        .alert-danger {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
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
</head>

<body data-page="posts">
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />

        <main class="admin-main">
            <jsp:include page="header.jsp" />

            <div class="admin-content">
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <div class="content-header">
                    <div>
                        <h1 class="content-title">Danh mục Bài viết</h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/admin/posts">Bài viết</a>
                            <span>/</span>
                            <span>Danh mục</span>
                        </div>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-primary" onclick="openAddModal()">
                            <i class="fas fa-plus"></i> Thêm danh mục
                        </button>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Danh sách danh mục (${totalCategories})</h3>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-wrapper">
                            <table class="admin-table" id="categoriesTable">
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">STT</th>
                                        <th>Tên danh mục</th>
                                        <th>Mô tả</th>
                                        <th>Số bài viết</th>
                                        <th>Ngày tạo</th>
                                        <th style="width: 150px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty categories}">
                                            <tr>
                                                <td colspan="6" class="empty-state">
                                                    <i class="fas fa-folder-open"></i>
                                                    <p>Chưa có danh mục nào</p>
                                                    <button type="button" class="btn btn-primary btn-sm" onclick="openAddModal()">
                                                        <i class="fas fa-plus"></i> Thêm danh mục đầu tiên
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="category" items="${categories}" varStatus="status">
                                                <tr data-id="${category.id}">
                                                    <td>${status.index + 1}</td>
                                                    <td><strong>${category.name}</strong></td>
                                                    <td><span style="color: #64748b; font-size: 14px;">${category.description}</span></td>
                                                    <td>
                                                        <span class="badge ${newsCountMap[category.id] > 0 ? 'success' : 'secondary'}">
                                                            ${newsCountMap[category.id]} bài viết
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty category.createdAt}">
                                                                <fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #94a3b8;">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline edit-btn"
                                                                title="Chỉnh sửa" data-id="${category.id}"
                                                                data-name="${category.name}"
                                                                data-description="${category.description}">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/admin/posts/categories/delete"
                                                                style="display: inline;"
                                                                class="delete-category-form"
                                                                data-name="${category.name}"
                                                                data-count="${newsCountMap[category.id]}">
                                                                <input type="hidden" name="id" value="${category.id}" />
                                                                <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Thêm -->
    <div class="modal" id="addModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Thêm danh mục mới</h3>
                <button type="button" class="modal-close" onclick="closeModal('addModal')">&times;</button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/posts/categories/add">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="addCategoryName">Tên danh mục <span class="required">*</span></label>
                        <input type="text" name="name" id="addCategoryName" class="form-control"
                            placeholder="VD: Cẩm nang nông nghiệp,..." required autofocus>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="addCategoryDesc">Mô tả</label>
                        <textarea name="description" id="addCategoryDesc" class="form-control" rows="3"
                            placeholder="Mô tả ngắn gọn về danh mục này..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu danh mục
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Sửa -->
    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Chỉnh sửa danh mục</h3>
                <button type="button" class="modal-close" onclick="closeModal('editModal')">&times;</button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/posts/categories/edit">
                <input type="hidden" name="id" id="editCategoryId" />
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editCategoryName">Tên danh mục <span class="required">*</span></label>
                        <input type="text" name="name" id="editCategoryName" class="form-control" required>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="editCategoryDesc">Mô tả</label>
                        <textarea name="description" id="editCategoryDesc" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addCategoryName').value = '';
            document.getElementById('addCategoryDesc').value = '';
            document.getElementById('addModal').style.display = 'flex';
            setTimeout(function () {
                document.getElementById('addCategoryName').focus();
            }, 100);
        }

        function openEditModal(id, name, desc) {
            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editCategoryDesc').value = desc || '';
            document.getElementById('editModal').style.display = 'flex';
            setTimeout(function () {
                document.getElementById('editCategoryName').focus();
            }, 100);
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        document.querySelectorAll('.modal').forEach(function (modal) {
            modal.addEventListener('click', function (e) {
                if (e.target === modal) closeModal(modal.id);
            });
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                document.querySelectorAll('.modal').forEach(function (modal) {
                    modal.style.display = 'none';
                });
            }
        });

        document.querySelectorAll('.edit-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                openEditModal(
                    this.getAttribute('data-id'), 
                    this.getAttribute('data-name'),
                    this.getAttribute('data-description')
                );
            });
        });

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
            }, 4000);
        }

        // Intercept delete form submission to check article count
        document.querySelectorAll('.delete-category-form').forEach(form => {
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                const name = this.getAttribute('data-name');
                const count = parseInt(this.getAttribute('data-count') || '0', 10);

                if (count > 0) {
                    // Hiển thị thông báo không cho phép xóa
                    showAlert('error', "Không thể xóa danh mục này vì đang chứa " + count + " bài viết. Hãy chuyển bài viết sang danh mục khác trước");
                } else {
                    // Popup xác nhận trước khi thực thi
                    showConfirm('Xác nhận xóa', "Bạn có chắc chắn muốn xóa danh mục '" + name + "' này?", () => {
                        this.submit();
                    });
                }
            });
        });
    </script>
</body>
</html>
