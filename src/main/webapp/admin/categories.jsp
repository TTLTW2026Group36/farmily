<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
                <style>
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

                    .btn-toggle.btn-active {
                        border-color: #22c55e;
                        color: #22c55e;
                    }

                    .btn-toggle.btn-active:hover {
                        background: #f0fdf4;
                    }

                    .btn-toggle.btn-inactive {
                        border-color: #94a3b8;
                        color: #94a3b8;
                    }

                    .btn-toggle.btn-inactive:hover {
                        background: #f8fafc;
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

            <body>
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
                                    <h1 class="content-title">Quản lý Danh mục</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
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
                                                    <th>Số sản phẩm</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày tạo</th>
                                                    <th style="width: 180px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty categories}">
                                                        <tr>
                                                            <td colspan="6" class="empty-state">
                                                                <i class="fas fa-folder-open"></i>
                                                                <p>Chưa có danh mục nào</p>
                                                                <button type="button" class="btn btn-primary btn-sm"
                                                                    onclick="openAddModal()">
                                                                    <i class="fas fa-plus"></i> Thêm danh mục đầu tiên
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="category" items="${categories}"
                                                            varStatus="status">
                                                            <tr data-id="${category.id}">
                                                                <td>${status.index + 1}</td>
                                                                <td><strong>${category.name}</strong></td>
                                                                <td>
                                                                    <span
                                                                        class="badge ${productCountMap[category.id] > 0 ? 'success' : 'secondary'}">
                                                                        ${productCountMap[category.id]} sản phẩm
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge ${category.status == 'active' ? 'success' : 'warning'}">
                                                                        ${category.status == 'active' ? 'Hoạt động' : 'Tạm ẩn'}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty category.createdAt}">
                                                                            <fmt:formatDate
                                                                                value="${category.createdAt}"
                                                                                pattern="dd/MM/yyyy HH:mm" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span style="color: #94a3b8;">—</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <div class="action-buttons">
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-toggle ${category.status == 'active' ? 'btn-active' : 'btn-inactive'}"
                                                                            data-id="${category.id}"
                                                                            data-status="${category.status}"
                                                                            title="${category.status == 'active' ? 'Ẩn danh mục' : 'Hiện danh mục'}">
                                                                            <i class="fas ${category.status == 'active' ? 'fa-eye' : 'fa-eye-slash'}"></i>
                                                                        </button>
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-outline edit-btn"
                                                                            title="Chỉnh sửa" data-id="${category.id}"
                                                                            data-name="${category.name}">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        <form method="post"
                                                                            action="${pageContext.request.contextPath}/admin/categories/delete"
                                                                            style="display: inline;"
                                                                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục \'${category.name}\'?');">
                                                                            <input type="hidden" name="id"
                                                                                value="${category.id}" />
                                                                            <button type="submit"
                                                                                class="btn btn-sm btn-danger"
                                                                                title="Xóa">
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
                <div class="modal" id="addModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title">Thêm danh mục mới</h3>
                            <button type="button" class="modal-close" onclick="closeModal('addModal')">&times;</button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin/categories/add">
                            <div class="modal-body">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label for="addCategoryName">Tên danh mục <span class="required">*</span></label>
                                    <input type="text" name="name" id="addCategoryName" class="form-control"
                                        placeholder="VD: Rau lá,..." required autofocus>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeModal('addModal')">Hủy</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Lưu danh mục
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="modal" id="editModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 class="modal-title">Chỉnh sửa danh mục</h3>
                            <button type="button" class="modal-close" onclick="closeModal('editModal')">&times;</button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin/categories/edit">
                            <input type="hidden" name="id" id="editCategoryId" />
                            <div class="modal-body">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label for="editCategoryName">Tên danh mục <span class="required">*</span></label>
                                    <input type="text" name="name" id="editCategoryName" class="form-control" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeModal('editModal')">Hủy</button>
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
                        document.getElementById('addModal').style.display = 'flex';
                        setTimeout(function () {
                            document.getElementById('addCategoryName').focus();
                        }, 100);
                    }

                    function openEditModal(id, name) {
                        document.getElementById('editCategoryId').value = id;
                        document.getElementById('editCategoryName').value = name;
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

                    (function () {
                        var searchInput = document.getElementById('searchTable');
                        if (!searchInput) return;
                        searchInput.addEventListener('input', function () {
                            var filter = this.value.toLowerCase();
                            var rows = document.querySelectorAll('#categoriesTable tbody tr');
                            rows.forEach(function (row) {
                                if (row.querySelector('.empty-state')) return;
                                var text = row.textContent.toLowerCase();
                                row.style.display = text.indexOf(filter) > -1 ? '' : 'none';
                            });
                        });
                    })();

                    document.querySelectorAll('.edit-btn').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            openEditModal(this.getAttribute('data-id'), this.getAttribute('data-name'));
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
                        }, 3000);
                    }

                    document.querySelectorAll('.btn-toggle').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.preventDefault();
                            const categoryId = this.dataset.id;
                            const currentStatus = this.dataset.status;
                            const action = currentStatus === 'active' ? 'ẩn' : 'hiện';

                            showConfirm('Thay đổi trạng thái', 'Bạn có chắc chắn muốn ' + action + ' danh mục này không?', () => {
                                fetch('${pageContext.request.contextPath}/admin/categories/toggle', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'id=' + categoryId
                                })
                                    .then(res => res.json())
                                    .then(data => {
                                        if (data.success) {
                                            this.dataset.status = data.status;
                                            this.title = data.isActive ? 'Ẩn danh mục' : 'Hiện danh mục';
                                            this.className = 'btn btn-sm btn-toggle ' +
                                                (data.isActive ? 'btn-active' : 'btn-inactive');
                                            this.querySelector('i').className = 'fas ' +
                                                (data.isActive ? 'fa-eye' : 'fa-eye-slash');

                                            const row = document.querySelector('tr[data-id="' + categoryId + '"]');
                                            if (row) {
                                                const badge = row.querySelector('td:nth-child(4) .badge');
                                                if (badge) {
                                                    badge.className = 'badge ' + data.badgeClass;
                                                    badge.textContent = data.statusText;
                                                }
                                            }

                                            showAlert('success', 'Đã ' + action + ' danh mục thành công');
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
                </script>

            </body>

            </html>