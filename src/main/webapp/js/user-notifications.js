(function () {
    'use strict';

    var contextPath = window.contextPath || '';
    if (!window.isLoggedIn) return;

    var bellTrigger   = document.getElementById('bell-trigger');
    var dropdown      = document.getElementById('notification-dropdown');
    var badge         = document.getElementById('notificationCount');
    var notifList     = document.getElementById('notification-list');
    var btnReadAll    = document.getElementById('btn-read-all');

    if (!bellTrigger || !dropdown) return;

    bellTrigger.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (dropdown.classList.contains('show')) {
            dropdown.classList.remove('show');
        } else {
            dropdown.classList.add('show');
            fetchLatest();
        }
    });

    document.addEventListener('click', function (e) {
        var bell = document.getElementById('notification-bell');
        if (bell && !bell.contains(e.target)) {
            dropdown.classList.remove('show');
        }
    });

    function pollUnreadCount() {
        fetch(contextPath + '/api/user-notifications/count', { credentials: 'same-origin' })
            .then(function (r) { return r.ok ? r.json() : null; })
            .then(function (data) {
                if (data) updateBadge(data.unreadCount || 0);
            })
            .catch(function () {});
    }

    function updateBadge(count) {
        if (!badge) return;
        badge.textContent = count > 99 ? '99+' : count;
        if (count > 0) {
            badge.classList.remove('badge-hidden');
        } else {
            badge.classList.add('badge-hidden');
        }
    }

    function fetchLatest() {
        notifList.innerHTML = '<div class="notification-empty"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải...</div>';

        fetch(contextPath + '/api/user-notifications/latest?limit=7', { credentials: 'same-origin' })
            .then(function (r) { return r.ok ? r.json() : null; })
            .then(function (data) {
                if (!data) {
                    notifList.innerHTML = '<div class="notification-empty">Có lỗi xảy ra</div>';
                    return;
                }
                updateBadge(data.unreadCount || 0);
                renderNotifications(data.notifications || []);
            })
            .catch(function () {
                notifList.innerHTML = '<div class="notification-empty">Không thể tải thông báo</div>';
            });
    }

    function renderNotifications(notifications) {
        if (!notifications.length) {
            notifList.innerHTML = '<div class="notification-empty"><i class="fa-regular fa-bell-slash"></i><br>Không có thông báo mới</div>';
            return;
        }

        var html = '';
        notifications.forEach(function (n) {
            var href   = n.link || '#';
            var unread = n.isRead ? '' : ' unread';
            html += '<a class="notification-item' + unread + '" '
                  + 'href="' + escapeAttr(href) + '" '
                  + 'data-id="' + n.id + '" '
                  + (n.isRead ? '' : 'data-unread="1"') + '>'
                  + '<div class="notification-item-icon ' + escapeAttr(n.iconClass) + '">'
                  + '<i class="fa-solid ' + escapeAttr(n.icon) + '"></i></div>'
                  + '<div class="notification-item-content">'
                  + '<div class="notification-item-title">' + escapeHtml(n.title) + '</div>'
                  + '<div class="notification-item-message">' + escapeHtml(n.message || '') + '</div>'
                  + '<div class="notification-item-time">' + escapeHtml(n.timeAgo) + '</div>'
                  + '</div></a>';
        });
        notifList.innerHTML = html;

        notifList.querySelectorAll('.notification-item[data-unread]').forEach(function (item) {
            item.addEventListener('click', function () {
                var id = this.getAttribute('data-id');
                if (id) markAsRead(parseInt(id, 10));
            });
        });
    }

    function markAsRead(id) {
        fetch(contextPath + '/api/user-notifications/read', {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'id=' + id
        }).then(function (r) { return r.ok ? r.json() : null; })
          .then(function (data) { if (data) updateBadge(data.unreadCount || 0); })
          .catch(function () {});
    }

    if (btnReadAll) {
        btnReadAll.addEventListener('click', function (e) {
            e.preventDefault();
            fetch(contextPath + '/api/user-notifications/read-all', {
                method: 'POST',
                credentials: 'same-origin'
            }).then(function (r) { return r.ok ? r.json() : null; })
              .then(function (data) {
                  updateBadge(0);
                  fetchLatest();
              })
              .catch(function () {});
        });
    }

    function escapeHtml(text) {
        if (!text) return '';
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }

    function escapeAttr(text) {
        if (!text) return '';
        return text.replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    pollUnreadCount();
    setInterval(pollUnreadCount, 45000);
})();
