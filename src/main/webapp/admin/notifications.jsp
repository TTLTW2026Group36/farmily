<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thông báo - Admin Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/notifications.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body data-page="notifications">
            <div class="admin-layout">
                <jsp:include page="sidebar.jsp" />

                <main class="admin-main">
                    <jsp:include page="header.jsp" />

                    <div class="admin-content">
                        <div class="notifications-container">
                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Thông báo</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="fas fa-home"></i> Dashboard
                                        </a>
                                        <span>/</span>
                                        <span>Thông báo</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <c:if test="${unreadCount > 0}">
                                        <form action="${pageContext.request.contextPath}/admin/notifications"
                                            method="post" style="margin: 0;">
                                            <input type="hidden" name="action" value="markAllRead">
                                            <button type="submit" class="btn btn-outline">
                                                <i class="fas fa-check-double"></i>
                                                Đánh dấu tất cả đã đọc (${unreadCount})
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>


                            <div class="broadcast-section" style="margin-bottom: 24px;">
                                <h3 style="font-size:15px; font-weight:700; color:#333; margin:0 0 16px; display:flex; align-items:center; gap:8px;">
                                    <i class="fas fa-bullhorn" style="color:#2f8f3f;"></i> Gửi thông báo cho tất cả khách hàng
                                </h3>
                                <form id="broadcast-form">
                                    <div style="margin-bottom:12px;">
                                        <label style="display:block; font-weight:600; font-size:13px; margin-bottom:5px;">
                                            Tiêu đề <span style="color:#e53e3e;">*</span>
                                        </label>
                                        <input type="text" id="broadcast-title" placeholder="VD: Khuyến mãi cuối tuần giảm 30%!" maxlength="255" required
                                               style="width:100%; padding:9px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px;">
                                    </div>
                                    <div style="margin-bottom:12px;">
                                        <label style="display:block; font-weight:600; font-size:13px; margin-bottom:5px;">
                                            Nội dung <span style="color:#e53e3e;">*</span>
                                        </label>
                                        <textarea id="broadcast-message" rows="2" placeholder="VD: Giảm 30% tất cả rau củ hữu cơ từ 8h-20h hôm nay!" required
                                                  style="width:100%; padding:9px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; resize:vertical;"></textarea>
                                    </div>
                                    <div style="margin-bottom:14px;">
                                        <label style="display:block; font-weight:600; font-size:13px; margin-bottom:5px;">
                                            Link điều hướng (tùy chọn)
                                        </label>
                                        <input type="text" id="broadcast-link" placeholder="VD: /san-pham hoặc /ma-giam-gia"
                                               style="width:100%; padding:9px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px;">
                                    </div>
                                    <button type="submit" id="btn-broadcast"
                                            style="display:inline-flex; align-items:center; gap:8px; padding:10px 20px; background:#2f8f3f; color:#fff; border:none; border-radius:6px; font-size:14px; cursor:pointer;">
                                        <i class="fas fa-paper-plane"></i> Gửi cho tất cả khách hàng
                                    </button>
                                </form>
                                <div id="broadcast-result" style="display:none; margin-top:10px; padding:10px 14px; border-radius:6px; font-size:13px;"></div>
                            </div>

                            <div class="notification-card">
                                <c:choose>
                                    <c:when test="${empty notifications}">
                                        <div style="text-align: center; padding: 60px 20px; color: #64748b;">
                                            <i class="fas fa-bell-slash"
                                                style="font-size: 48px; margin-bottom: 16px; color: #cbd5e1; display: block;"></i>
                                            <h3 style="margin-bottom: 8px;">Không có thông báo</h3>
                                            <p>Bạn sẽ nhận được thông báo khi có đơn hàng mới hoặc cập nhật quan trọng.
                                            </p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="n" items="${notifications}">
                                            <a href="${n.getLink(pageContext.request.contextPath)}"
                                                class="notification-full-item ${n.read ? '' : 'unread'}"
                                                data-id="${n.id}">
                                                <div class="notification-full-icon ${n.iconClass}">
                                                    <i class="fas ${n.icon}"></i>
                                                </div>
                                                <div class="notification-full-content">
                                                    <div class="notification-full-title">${n.title}</div>
                                                    <div class="notification-full-text">${n.message}</div>
                                                    <div class="notification-full-meta">
                                                        <div class="notification-full-time">
                                                            <i class="fas fa-clock"></i>
                                                            <span>${n.timeAgo}</span>
                                                        </div>
                                                        <span>•</span>
                                                        <span>
                                                            <i class="fas fa-tag"></i>
                                                             <c:choose>
                                                                <c:when test="${n.type == 'new_order'}">Đơn hàng</c:when>
                                                                <c:when test="${n.type == 'order_cancelled'}">Hủy đơn</c:when>
                                                                <c:when test="${n.type == 'low_stock'}">Tồn kho</c:when>
                                                                <c:when test="${n.type == 'new_contact'}">Liên hệ</c:when>
                                                                <c:when test="${n.type == 'new_review'}">Đánh giá</c:when>
                                                                <c:when test="${n.type == 'review_reported'}">Báo cáo</c:when>
                                                                <c:when test="${n.type == 'flash_sale_low_stock'}">Flash Sale</c:when>
                                                                <c:otherwise>Hệ thống</c:otherwise>
                                                             </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                                <c:if test="${!n.read}">
                                                    <div class="notification-actions">
                                                        <button class="mark-read-btn"
                                                            onclick="markAsRead(event, ${n.id})">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </div>
                                                </c:if>
                                            </a>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

            <script>
                var contextPath = '${pageContext.request.contextPath}';

                function markAsRead(event, id) {
                    event.preventDefault();
                    event.stopPropagation();

                    fetch(contextPath + '/admin/api/notifications/read', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'id=' + id
                    })
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.success) {
                                var item = event.target.closest('.notification-full-item');
                                if (item) {
                                    item.classList.remove('unread');
                                    var btn = item.querySelector('.notification-actions');
                                    if (btn) btn.remove();
                                }
                            }
                        });
                }

                document.getElementById('broadcast-form').addEventListener('submit', function(e) {
                    e.preventDefault();
                    var btn = document.getElementById('btn-broadcast');
                    var result = document.getElementById('broadcast-result');
                    var title = document.getElementById('broadcast-title').value.trim();
                    var message = document.getElementById('broadcast-message').value.trim();
                    var link = document.getElementById('broadcast-link').value.trim();

                    if (!title || !message) return;

                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

                    fetch(contextPath + '/admin/api/notifications/broadcast', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'title=' + encodeURIComponent(title)
                            + '&message=' + encodeURIComponent(message)
                            + '&link=' + encodeURIComponent(link)
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.success) {
                            result.style.background = '#e8f5e9';
                            result.style.color = '#2e7d32';
                            result.style.border = '1px solid #a5d6a7';
                            result.textContent = '✓ Đã gửi thông báo cho ' + data.userCount + ' khách hàng';
                            document.getElementById('broadcast-form').reset();
                        } else {
                            result.style.background = '#fce4ec';
                            result.style.color = '#c62828';
                            result.style.border = '1px solid #ef9a9a';
                            result.textContent = '✗ Lỗi: ' + (data.error || 'Không xác định');
                        }
                        result.style.display = 'block';
                        setTimeout(function() { result.style.display = 'none'; }, 5000);
                    })
                    .catch(function() {
                        result.style.background = '#fce4ec';
                        result.style.color = '#c62828';
                        result.style.border = '1px solid #ef9a9a';
                        result.textContent = '✗ Có lỗi xảy ra, vui lòng thử lại';
                        result.style.display = 'block';
                    })
                    .finally(function() {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi cho tất cả khách hàng';
                    });
                });
            </script>
        </body>

        </html>