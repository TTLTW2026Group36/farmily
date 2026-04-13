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

            <body data-page="customers">
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />
                    <main class="admin-main">
                        <jsp:include page="header.jsp" />
                        <div class="admin-content">

                            <c:if test="${not empty success}">
                                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
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


                            <div class="toolbar-bar">
                                <form method="get" action="${pageContext.request.contextPath}/admin/users"
                                    class="toolbar-search-form">
                                    <div class="search-group">
                                        <i class="fas fa-search search-icon"></i>
                                        <input type="text" name="search" class="search-input"
                                            placeholder="Tìm theo tên hoặc email..." value="${searchKeyword}">
                                    </div>
                                    <select name="role" class="role-select" onchange="this.form.submit()">
                                        <option value="all" ${selectedRole=='all' ? 'selected' : '' }>Tất cả</option>
                                        <option value="user" ${selectedRole=='user' ? 'selected' : '' }>Người dùng
                                        </option>
                                        <option value="admin" ${selectedRole=='admin' ? 'selected' : '' }>Admin</option>
                                    </select>
                                    <button type="submit" class="btn btn-secondary">
                                        <i class="fas fa-search"></i> Tìm
                                    </button>
                                </form>
                                <div class="toolbar-actions">
                                    <button class="btn btn-outline" id="selectAllBtn" onclick="toggleSelectAll()">
                                        <i class="fas fa-check-square"></i> Chọn tất cả
                                    </button>
                                    <button class="btn btn-export" id="exportBtn" onclick="exportSelected()" disabled>
                                        <i class="fas fa-file-csv"></i> Xuất CSV
                                    </button>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách khách hàng &nbsp;<span
                                            class="count-badge">${totalUsers}</span></h3>
                                    <span class="selected-count-msg" id="selectedMsg" style="display:none;">
                                        Đã chọn <strong id="selectedCount">0</strong> khách hàng
                                    </span>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <table class="admin-table" id="customersTable">
                                        <thead>
                                            <tr>
                                                <th class="col-check">
                                                    <input type="checkbox" id="masterCheck"
                                                        onchange="onMasterCheckChange()" class="row-check">
                                                </th>
                                                <th>ID</th>
                                                <th>Họ tên</th>
                                                <th>Email</th>
                                                <th>Số điện thoại</th>
                                                <th>Địa chỉ</th>
                                                <th>Vai trò</th>
                                                <th>Ngày đăng ký</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty users}">
                                                    <tr>
                                                        <td colspan="9" class="empty-state">
                                                            <i class="fas fa-users"></i>
                                                            <p>Chưa có khách hàng nào</p>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="user" items="${users}">
                                                        <tr class="data-row" data-id="${user.id}"
                                                            data-name="${user.name}" data-email="${user.email}"
                                                            data-phone="${user.phone}" data-role="${user.role}"
                                                            data-date="<fmt:formatDate value='${user.created_at}' pattern='dd/MM/yyyy'/>">
                                                            <td class="col-check">
                                                                <input type="checkbox" class="row-check"
                                                                    onchange="onRowCheckChange()">
                                                            </td>
                                                            <td><strong>#${user.id}</strong></td>
                                                            <td class="col-name">
                                                                <c:choose>
                                                                    <c:when test="${not empty user.name}">${user.name}
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">Chưa cập
                                                                            nhật</span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="col-email">${user.email}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty user.phone}">${user.phone}
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">—</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:set var="addrCount"
                                                                    value="${addressCountMap[user.id]}" />
                                                                <span
                                                                    class="addr-badge ${addrCount > 0 ? 'addr-has' : 'addr-none'}">
                                                                    <i class="fas fa-map-marker-alt"></i> ${addrCount}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${user.role == 'admin'}">
                                                                        <span class="role-badge role-admin">Admin</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="role-badge role-user">Người
                                                                            dùng</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${user.created_at}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td>
                                                                <div class="action-buttons">
                                                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}"
                                                                        class="btn btn-sm btn-outline"
                                                                        title="Chỉnh sửa">
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
                                                        href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}&role=${selectedRole}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}"><span class="active">${i}</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                        <a
                                                            href="${pageContext.request.contextPath}/admin/users?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}&role=${selectedRole}">${i}</a>
                                                    </c:when>
                                                    <c:when test="${i == 4 && currentPage > 5}"><span>...</span>
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
                                                        href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}&role=${selectedRole}">
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
                    function onMasterCheckChange() {
                        const master = document.getElementById('masterCheck');
                        document.querySelectorAll('.data-row .row-check').forEach(cb => cb.checked = master.checked);
                        updateExportState();
                    }

                    function onRowCheckChange() {
                        const all = document.querySelectorAll('.data-row .row-check');
                        const checked = document.querySelectorAll('.data-row .row-check:checked');
                        document.getElementById('masterCheck').checked = (all.length === checked.length && all.length > 0);
                        updateExportState();
                    }

                    function toggleSelectAll() {
                        const master = document.getElementById('masterCheck');
                        master.checked = !master.checked;
                        onMasterCheckChange();
                    }

                    function updateExportState() {
                        const count = document.querySelectorAll('.data-row .row-check:checked').length;
                        const btn = document.getElementById('exportBtn');
                        const msg = document.getElementById('selectedMsg');
                        const countEl = document.getElementById('selectedCount');
                        btn.disabled = count === 0;
                        if (count > 0) {
                            msg.style.display = 'inline-flex';
                            countEl.textContent = count;
                        } else {
                            msg.style.display = 'none';
                        }
                    }

                    function exportSelected() {
                        const rows = document.querySelectorAll('.data-row .row-check:checked');
                        if (rows.length === 0) return;

                        const headers = ['ID', 'Họ tên', 'Email', 'Số điện thoại', 'Vai trò', 'Ngày đăng ký'];
                        const lines = [headers.join(',')];

                        rows.forEach(cb => {
                            const row = cb.closest('tr');
                            const id = row.dataset.id || '';
                            const name = escCsv(row.dataset.name || '');
                            const email = escCsv(row.dataset.email || '');
                            const phone = escCsv(row.dataset.phone || '');
                            const role = row.dataset.role === 'admin' ? 'Admin' : 'Khách hàng';
                            const date = row.dataset.date || '';
                            lines.push([id, name, email, phone, role, date].join(','));
                        });

                        const csv = '\uFEFF' + lines.join('\n');
                        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
                        const url = URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = 'khach-hang-' + new Date().toISOString().slice(0, 10) + '.csv';
                        a.click();
                        URL.revokeObjectURL(url);
                    }

                    function escCsv(val) {
                        if (!val) return '';
                        if (val.includes(',') || val.includes('"') || val.includes('\n')) {
                            return '"' + val.replace(/"/g, '""') + '"';
                        }
                        return val;
                    }
                </script>
            </body>

            </html>