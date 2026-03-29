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
                                                                <c:when test="${n.type == 'new_order'}">Đơn hàng
                                                                </c:when>
                                                                <c:when test="${n.type == 'order_cancelled'}">Hủy đơn
                                                                </c:when>
                                                                <c:when test="${n.type == 'low_stock'}">Tồn kho</c:when>
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
            </script>
        </body>

        </html>