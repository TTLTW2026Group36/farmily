<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <header class="admin-header">
            <div class="header-left">
                <button class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>

            </div>

            <div class="header-right">
                <div class="notification-wrapper">
                    <button class="header-btn" id="notificationBtn">
                        <i class="fas fa-bell"></i>
                        <span class="badge" id="notificationBadge" style="display: none;">0</span>
                    </button>
                    <div class="notification-dropdown" id="notificationDropdown">
                        <div class="notification-header">
                            <h4>Thông báo</h4>
                            <span class="notification-count" id="notificationCountText">0 mới</span>
                        </div>
                        <div class="notification-list" id="notificationList">
                            <div class="notification-loading"
                                style="text-align: center; padding: 20px; color: #64748b;">
                                <i class="fas fa-spinner fa-spin"></i> Đang tải...
                            </div>
                        </div>
                        <div class="notification-footer">
                            <a href="#" id="markAllReadBtn" style="margin-right: 10px;">Đánh dấu đã đọc</a>
                            <a href="${pageContext.request.contextPath}/admin/notifications">Xem tất cả</a>
                        </div>
                    </div>
                </div>

                <div class="user-menu">
                    <c:set var="adminUser" value="${sessionScope.adminUser}" />
                    <c:set var="firstLetter"
                        value="${not empty adminUser.name ? adminUser.name.substring(0,1).toUpperCase() : 'A'}" />

                    <div class="user-avatar">${firstLetter}</div>
                    <div class="user-info">
                        <div class="name">${not empty adminUser.name ? adminUser.name : 'Admin User'}</div>
                        <div class="role">
                            <c:choose>
                                <c:when test="${adminUser.role == 'admin'}">Quản trị viên</c:when>
                                <c:when test="${adminUser.role == 'manager'}">Người quản lý</c:when>
                                <c:otherwise>Quản trị viên</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="user-dropdown">
                        <!-- <a href="${pageContext.request.contextPath}/admin/settings" data-page="settings">
                            <i class="fas fa-cog"></i>
                            <span>Cài đặt</span>
                        </a> -->
                        <a href="${pageContext.request.contextPath}/admin/logout">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Đăng xuất</span>
                        </a>
                    </div>
                </div>
            </div>
        </header>

        <script>
            (function () {
                var contextPath = '${pageContext.request.contextPath}';
                var notificationBtn = document.getElementById('notificationBtn');
                var notificationDropdown = document.getElementById('notificationDropdown');
                var notificationBadge = document.getElementById('notificationBadge');
                var notificationCountText = document.getElementById('notificationCountText');
                var notificationList = document.getElementById('notificationList');
                var markAllReadBtn = document.getElementById('markAllReadBtn');

                notificationBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    notificationDropdown.classList.toggle('show');
                    if (notificationDropdown.classList.contains('show')) {
                        loadNotifications();
                    }
                });

                document.addEventListener('click', function (e) {
                    if (!notificationDropdown.contains(e.target) && e.target !== notificationBtn) {
                        notificationDropdown.classList.remove('show');
                    }
                });

                markAllReadBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    fetch(contextPath + '/admin/api/notifications/read-all', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                updateBadge(0);
                                var items = notificationList.querySelectorAll('.notification-item.unread');
                                items.forEach(function (item) {
                                    item.classList.remove('unread');
                                });
                            }
                        })
                        .catch(function (error) {
                            console.error('Error marking all as read:', error);
                        });
                });

                function loadNotifications() {
                    fetch(contextPath + '/admin/api/notifications?limit=5')
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            updateBadge(data.unreadCount);
                            renderNotifications(data.notifications);
                        })
                        .catch(function (error) {
                            console.error('Error loading notifications:', error);
                            notificationList.innerHTML = '<div style="text-align: center; padding: 20px; color: #dc2626;">Lỗi tải thông báo</div>';
                        });
                }

                function renderNotifications(notifications) {
                    if (!notifications || notifications.length === 0) {
                        notificationList.innerHTML = '<div style="text-align: center; padding: 30px; color: #64748b;"><i class="fas fa-bell-slash" style="font-size: 32px; margin-bottom: 10px; display: block;"></i>Không có thông báo</div>';
                        return;
                    }

                    var html = '';
                    notifications.forEach(function (n) {
                        var link = getNotificationLink(n);
                        html += '<a href="' + link + '" class="notification-item ' + (n.isRead ? '' : 'unread') + '" data-id="' + n.id + '">';
                        html += '<div class="notification-icon ' + n.iconClass + '">';
                        html += '<i class="fas ' + n.icon + '"></i>';
                        html += '</div>';
                        html += '<div class="notification-content">';
                        html += '<div class="notification-title">' + escapeHtml(n.title) + '</div>';
                        html += '<div class="notification-text">' + escapeHtml(n.message) + '</div>';
                        html += '<div class="notification-time">' + escapeHtml(n.timeAgo) + '</div>';
                        html += '</div>';
                        html += '</a>';
                    });
                    notificationList.innerHTML = html;

                    notificationList.querySelectorAll('.notification-item').forEach(function (item) {
                        item.addEventListener('click', function () {
                            var id = this.getAttribute('data-id');
                            markAsRead(id);
                        });
                    });
                }

                function getNotificationLink(notification) {
                    if (!notification.referenceType || !notification.referenceId) {
                        return contextPath + '/admin/notifications';
                    }
                    switch (notification.referenceType) {
                        case 'order':
                            return contextPath + '/admin/orders/detail?id=' + notification.referenceId;
                        case 'product':
                            return contextPath + '/admin/products/edit?id=' + notification.referenceId;
                        default:
                            return contextPath + '/admin/notifications';
                    }
                }

                function updateBadge(count) {
                    if (count > 0) {
                        notificationBadge.textContent = count > 99 ? '99+' : count;
                        notificationBadge.style.display = 'flex';
                        notificationCountText.textContent = count + ' mới';
                    } else {
                        notificationBadge.style.display = 'none';
                        notificationCountText.textContent = 'Không có thông báo mới';
                    }
                }

                function markAsRead(id) {
                    fetch(contextPath + '/admin/api/notifications/read', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'id=' + id
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                updateBadge(data.unreadCount);
                            }
                        })
                        .catch(function (error) {
                            console.error('Error marking as read:', error);
                        });
                }

                function escapeHtml(text) {
                    if (!text) return '';
                    var div = document.createElement('div');
                    div.textContent = text;
                    return div.innerHTML;
                }

                function fetchUnreadCount() {
                    fetch(contextPath + '/admin/api/notifications/count')
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            updateBadge(data.unreadCount);
                        })
                        .catch(function (error) {
                            console.error('Error fetching notification count:', error);
                        });
                }

                fetchUnreadCount();

                setInterval(fetchUnreadCount, 30000);
                (function () {
                    var searchInput = document.getElementById('searchTable');
                    if (!searchInput) return;

                    var page = document.body.getAttribute('data-page') || '';

                    var config = {
                        orders: {
                            placeholder: 'Tìm mã đơn, tên hoặc SĐT khách hàng...',
                            tableId: 'ordersTable',
                            columns: [0, 1]
                        },
                        products: {
                            placeholder: 'Tìm tên sản phẩm hoặc danh mục...',
                            tableId: 'productsTable',
                            columns: [1, 2]
                        },
                        customers: {
                            placeholder: 'Tìm tên, email hoặc số điện thoại...',
                            tableId: 'customersTable',
                            columns: [1, 2, 3]
                        },
                        notifications: {
                            placeholder: 'Tìm nội dung thông báo...',
                            tableId: null,
                            listSelector: '.notification-full-item',
                            textSelectors: ['.notification-full-title', '.notification-full-text']
                        },
                        categories: {
                            placeholder: 'Tìm tên danh mục...',
                            tableId: 'categoriesTable',
                            columns: [1]
                        },
                        posts: {
                            placeholder: 'Tìm tiêu đề, danh mục hoặc tác giả...',
                            tableId: 'postsTable',
                            columns: [0, 1, 2]
                        },
                        'static-pages': {
                            placeholder: 'Tìm tiêu đề hoặc slug trang tĩnh...',
                            tableId: 'staticPagesTable',
                            columns: [1, 2]
                        },
                        'flash-sales': {
                            placeholder: 'Tìm tên sản phẩm Flash Sale...',
                            tableId: 'flashSalesTable',
                            columns: [0]
                        }
                    };

                    var cfg = config[page];
                    if (!cfg) {
                        searchInput.placeholder = 'Tìm kiếm...';
                        searchInput.disabled = true;
                        searchInput.title = 'Trang này không có bảng dữ liệu để lọc';
                        searchInput.style.opacity = '0.45';
                        searchInput.style.cursor = 'not-allowed';
                        return;
                    }

                    searchInput.placeholder = cfg.placeholder;

                    function normalizeText(str) {
                        return (str || '').toLowerCase().trim();
                    }

                    function filterTable(query) {
                        var table = document.getElementById(cfg.tableId);
                        if (!table) return;
                        var rows = table.querySelectorAll('tbody tr');
                        var q = normalizeText(query);
                        var visibleCount = 0;
                        rows.forEach(function (row) {
                            var cells = row.querySelectorAll('td');
                            if (cells.length === 0) { row.style.display = ''; return; }
                            var match = !q;
                            if (!match) {
                                cfg.columns.forEach(function (ci) {
                                    if (cells[ci] && normalizeText(cells[ci].textContent).indexOf(q) !== -1) {
                                        match = true;
                                    }
                                });
                            }
                            row.style.display = match ? '' : 'none';
                            if (match) visibleCount++;
                        });

                        var emptyRow = table.querySelector('tr.search-empty-state');
                        if (!q || visibleCount > 0) {
                            if (emptyRow) emptyRow.remove();
                        } else if (!emptyRow) {
                            var colCount = table.querySelector('thead tr') ? table.querySelectorAll('thead tr th').length : 5;
                            var tr = document.createElement('tr');
                            tr.className = 'search-empty-state';
                            tr.innerHTML = '<td colspan="' + colCount + '" style="text-align:center;padding:30px;color:#64748b;">' +
                                '<i class="fas fa-search" style="font-size:32px;margin-bottom:10px;display:block;opacity:0.3;"></i>' +
                                'Không tìm thấy kết quả phù hợp với "<strong>' + escapeHtml(query) + '</strong>"' +
                                '</td>';
                            table.querySelector('tbody').appendChild(tr);
                        }
                    }

                    function filterNotifications(query) {
                        var items = document.querySelectorAll(cfg.listSelector);
                        var q = normalizeText(query);
                        items.forEach(function (item) {
                            var text = '';
                            cfg.textSelectors.forEach(function (sel) {
                                var el = item.querySelector(sel);
                                if (el) text += ' ' + el.textContent;
                            });
                            item.style.display = (!q || normalizeText(text).indexOf(q) !== -1) ? '' : 'none';
                        });
                    }

                    searchInput.addEventListener('input', function () {
                        var q = this.value;
                        if (cfg.tableId) {
                            filterTable(q);
                        } else {
                            filterNotifications(q);
                        }
                    });

                    searchInput.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            this.value = '';
                            this.dispatchEvent(new Event('input'));
                        }
                    });
                })();
            })();
        </script>