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
                                                    <th>Ngày tạo</th>
                                                    <th style="width: 150px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty categories}">
                                                        <tr>
                                                            <td colspan="5" class="empty-state">
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
                                                            <tr>
                                                                <td>${status.index + 1}</td>
                                                                <td><strong>${category.name}</strong></td>
                                                                <td>
                                                                    <span
                                                                        class="badge ${productCountMap[category.id] > 0 ? 'success' : 'secondary'}">
                                                                        ${productCountMap[category.id]} sản phẩm
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
                                                                            class="btn btn-sm btn-outline edit-btn"
                                                                            title="Chỉnh sửa"
                                                                            data-id="${category.id}"
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
                            <button type="button" class="modal-close"
                                onclick="closeModal('editModal')">&times;</button>
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
                </script>

            </body>

            </html>