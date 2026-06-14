<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat - Chăm sóc khách hàng - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/chat.css?v=2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body data-page="chat">
<div class="admin-layout">
    <jsp:include page="sidebar.jsp"/>
    <main class="admin-main">
        <jsp:include page="header.jsp"/>
        <div class="admin-content">
            <div class="orders-page-header">
                <div>
                    <h1 class="orders-page-title"><i class="fas fa-comments"></i> Chat - CSKH</h1>
                    <div class="content-breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                        <span>/</span><span>Chat</span>
                    </div>
                </div>
                <div class="chat-stats">
                    <span class="chat-stat-badge open-badge"><i class="fas fa-circle"></i> Đang mở: ${openCount}</span>
                    <span class="chat-stat-badge closed-badge"><i class="fas fa-circle"></i> Đã đóng: ${closedCount}</span>
                    <c:if test="${unreadTotal > 0}">
                        <span class="chat-stat-badge unread-badge"><i class="fas fa-envelope"></i> Chưa đọc: ${unreadTotal}</span>
                    </c:if>
                </div>
            </div>

            <div class="chat-layout">
                <div class="chat-list-panel">
                    <div class="chat-list-header">
                        <div class="chat-filter-tabs">
                            <a href="?status=" class="chat-tab ${empty selectedStatus ? 'active' : ''}">Tất cả</a>
                            <a href="?status=open" class="chat-tab ${'open' == selectedStatus ? 'active' : ''}">Đang mở</a>
                            <a href="?status=closed" class="chat-tab ${'closed' == selectedStatus ? 'active' : ''}">Đã đóng</a>
                        </div>
                    </div>
                    <div class="chat-conversation-list">
                        <c:choose>
                            <c:when test="${empty conversations}">
                                <div class="chat-empty-state">
                                    <i class="fas fa-comments"></i>
                                    <p>Chưa có cuộc hội thoại nào</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="conv" items="${conversations}">
                                    <div class="conv-item ${conv.open ? 'open' : 'closed'} ${conv.unreadCount > 0 ? 'has-unread' : ''}"
                                         data-conv-id="${conv.id}" onclick="loadConversation(${conv.id})">
                                        <div class="conv-avatar"><i class="fas fa-user"></i></div>
                                        <div class="conv-info">
                                            <div class="conv-subject">${fn:escapeXml(conv.displaySubject)}</div>
                                            <div class="conv-customer" style="font-size: 11px; color: #2d6a2d; font-weight: 500; margin-bottom: 2px;">
                                                <i class="fas fa-user-circle"></i> ${fn:escapeXml(not empty conv.user.name ? conv.user.name : conv.user.email)}
                                            </div>
                                            <div class="conv-last-msg">
                                                <c:choose>
                                                    <c:when test="${not empty conv.lastMessage}">
                                                        ${fn:substring(fn:escapeXml(conv.lastMessage.content), 0, 55)}
                                                    </c:when>
                                                    <c:otherwise><em>Chưa có tin nhắn</em></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="conv-meta">
                                                <span class="conv-time">${conv.timeAgo}</span>
                                                <span class="conv-status-dot ${conv.status}"></span>
                                            </div>
                                        </div>
                                        <c:if test="${conv.unreadCount > 0}">
                                            <span class="conv-unread-badge">${conv.unreadCount}</span>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${totalPages > 1}">
                        <div class="chat-pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="?status=${selectedStatus}&page=${currentPage - 1}" class="page-btn"><i class="fas fa-chevron-left"></i></a>
                            </c:if>
                            <span>${currentPage} / ${totalPages}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?status=${selectedStatus}&page=${currentPage + 1}" class="page-btn"><i class="fas fa-chevron-right"></i></a>
                            </c:if>
                        </div>
                    </c:if>
                </div>

                <div class="chat-detail-panel">
                    <div class="chat-detail-empty" id="chatDetailEmpty">
                        <i class="fas fa-comments"></i>
                        <p>Chọn một cuộc hội thoại để xem tin nhắn</p>
                    </div>
                    <div class="chat-detail-content" id="chatDetailContent" style="display:none;">
                        <div class="chat-detail-header">
                            <div class="chat-detail-title" id="chatDetailTitle"></div>
                            <div class="chat-detail-actions">
                                <button id="btnCloseConv" class="chat-action-btn close-btn" onclick="closeConversation()">
                                    <i class="fas fa-times-circle"></i> Đóng
                                </button>
                                <button id="btnReopenConv" class="chat-action-btn reopen-btn" onclick="reopenConversation()" style="display:none;">
                                    <i class="fas fa-redo"></i> Mở lại
                                </button>
                            </div>
                        </div>
                        <div id="chatOrderBanner" class="chat-order-banner" style="display:none;"></div>
                        <div class="chat-messages-area" id="chatMessagesArea"></div>
                        <div class="chat-input-area" id="chatInputArea">
                            <textarea id="adminReplyInput" class="chat-textarea" placeholder="Nhập tin nhắn... (Ctrl+Enter để gửi)" rows="3" maxlength="2000"></textarea>
                            <div class="chat-input-footer">
                                <span class="char-count" id="adminCharCount">0 / 2000</span>
                                <button class="chat-send-btn" onclick="sendAdminReply()">
                                    <i class="fas fa-paper-plane"></i> Gửi
                                </button>
                            </div>
                        </div>
                        <div class="chat-closed-notice" id="chatClosedNotice" style="display:none;">
                            <i class="fas fa-lock"></i> Cuộc hội thoại đã được đóng. Nhấn "Mở lại" để tiếp tục.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<div class="toast-msg" id="chatToast"></div>
<script>
(function() {
    var cp = '${pageContext.request.contextPath}';
    var activeConvId = null;
    var pollingInterval = null;

    window.loadConversation = function(convId) {
        activeConvId = convId;
        document.querySelectorAll('.conv-item').forEach(function(el) {
            el.classList.toggle('selected', parseInt(el.dataset.convId) === convId);
        });
        document.getElementById('chatDetailEmpty').style.display = 'none';
        document.getElementById('chatDetailContent').style.display = 'flex';
        fetchMessages(convId, true);
        if (pollingInterval) clearInterval(pollingInterval);
        pollingInterval = setInterval(function() { if (activeConvId) fetchMessages(activeConvId, false); }, 5000);
    };

    function fetchMessages(convId, scrollBottom) {
        fetch(cp + '/admin/chat/messages?conversationId=' + convId)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                renderMessages(data.messages);
                var refundInfo = null;
                if (data.orderId) {
                    refundInfo = {
                        refundRequestId: data.refundRequestId,
                        orderId: data.orderId,
                        refundAmount: data.refundAmount,
                        refundReason: data.refundReason,
                        refundStatus: data.refundStatus,
                        refundStatusText: data.refundStatusText
                    };
                }
                updateConvStatus(data.status, data.subject, data.customerName, data.customerEmail, data.customerPhone, refundInfo);
                if (scrollBottom) setTimeout(function() {
                    var area = document.getElementById('chatMessagesArea');
                    if (area) area.scrollTop = area.scrollHeight;
                }, 50);
            })
            .catch(function(e) { console.error('fetchMessages error:', e); });
    }

    function renderMessages(messages) {
        var area = document.getElementById('chatMessagesArea');
        if (!messages || messages.length === 0) {
            area.innerHTML = '<div class="chat-no-messages"><i class="fas fa-comment-slash"></i><p>Chưa có tin nhắn nào</p></div>';
            return;
        }
        var html = '';
        messages.forEach(function(msg) {
            var isAdmin = msg.senderType === 'admin';
            html += '<div class="chat-bubble-wrap ' + (isAdmin ? 'admin-side' : 'customer-side') + '">';
            html += '<div class="chat-bubble ' + (isAdmin ? 'bubble-admin' : 'bubble-customer') + '">';
            html += '<div class="bubble-content">' + escapeHtml(msg.content) + '</div>';
            html += '<div class="bubble-time">' + escapeHtml(msg.formattedTime) + (isAdmin ? ' · Admin' : ' · Khách') + '</div>';
            html += '</div></div>';
        });
        area.innerHTML = html;
    }

    function updateConvStatus(status, subject, name, email, phone, refundInfo) {
        var titleEl = document.getElementById('chatDetailTitle');
        if (titleEl && subject) {
            var html = escapeHtml(subject);
            if (name || email) {
                html += ' <span style="font-size: 0.85rem; font-weight: normal; color: #4b5563; margin-left: 10px; background: #f3f4f6; padding: 4px 10px; border-radius: 6px; border: 1px solid #e5e7eb; display: inline-flex; align-items: center; gap: 8px;">';
                html += '<i class="fas fa-user" style="color: #2d6a2d;"></i> ' + escapeHtml(name || email);
                if (phone) html += ' | <i class="fas fa-phone" style="color: #2d6a2d;"></i> ' + escapeHtml(phone);
                html += '</span>';
            }
            titleEl.innerHTML = html;
        }
        var bannerEl = document.getElementById('chatOrderBanner');
        if (bannerEl) {
            if (refundInfo && refundInfo.orderId) {
                var badgeClass = 'status-' + refundInfo.refundStatus;
                var statusText = refundInfo.refundStatusText || refundInfo.refundStatus;
                var bHtml = '';
                bHtml += '<div class="banner-card">';
                bHtml += '  <div class="banner-expanded-content" id="adminBannerExpanded">';
                bHtml += '    <div class="banner-left">';
                bHtml += '      <div class="banner-title">Đơn hàng #' + refundInfo.orderId + '</div>';
                bHtml += '      <div class="banner-desc">Lý do hoàn tiền: <strong>' + escapeHtml(refundInfo.refundReason) + '</strong> | Số tiền: <strong class="refund-amount-text">' + escapeHtml(refundInfo.refundAmount) + '</strong></div>';
                bHtml += '    </div>';
                bHtml += '    <div class="banner-right">';
                bHtml += '      <span class="refund-status-badge ' + badgeClass + '">' + escapeHtml(statusText) + '</span>';
                bHtml += '      <a href="' + cp + '/admin/orders/detail?id=' + refundInfo.orderId + '" class="banner-action-btn view-order-btn" target="_blank">Xem Đơn hàng</a>';
                bHtml += '      <a href="' + cp + '/admin/refund-requests/detail?id=' + refundInfo.refundRequestId + '" class="banner-action-btn view-refund-btn" target="_blank">Xem Y/C Hoàn tiền</a>';
                bHtml += '      <button class="banner-toggle-btn" onclick="toggleAdminBanner(true)" title="Ẩn chi tiết"><i class="fas fa-chevron-up"></i></button>';
                bHtml += '    </div>';
                bHtml += '  </div>';
                bHtml += '  <div class="banner-collapsed-content" id="adminBannerCollapsed" style="display:none; justify-content: space-between; align-items: center; width: 100%;">';
                bHtml += '    <span style="font-size: 13px; font-weight: 600; color: #4b5563;">Đơn hàng #' + refundInfo.orderId + ' (' + escapeHtml(statusText) + ')</span>';
                bHtml += '    <button onclick="toggleAdminBanner(false)" title="Hiện chi tiết" style="padding: 4px 10px; font-size: 11px; background: #e2e8f0; color: #475569; border-radius: 6px; border: none; cursor: pointer; font-weight: 600;">Hiện chi tiết</button>';
                bHtml += '  </div>';
                bHtml += '</div>';
                bannerEl.innerHTML = bHtml;
                bannerEl.style.display = 'block';
            } else {
                bannerEl.style.display = 'none';
                bannerEl.innerHTML = '';
            }
        }
        var closeBtn  = document.getElementById('btnCloseConv');
        var reopenBtn = document.getElementById('btnReopenConv');
        var inputArea  = document.getElementById('chatInputArea');
        var closedNote = document.getElementById('chatClosedNotice');
        if (status === 'closed') {
            closeBtn.style.display  = 'none';
            reopenBtn.style.display = '';
            inputArea.style.display  = 'none';
            closedNote.style.display = '';
        } else {
            closeBtn.style.display  = '';
            reopenBtn.style.display = 'none';
            inputArea.style.display  = '';
            closedNote.style.display = 'none';
        }
    }

    window.toggleAdminBanner = function(collapse) {
        var exp = document.getElementById('adminBannerExpanded');
        var col = document.getElementById('adminBannerCollapsed');
        if (exp && col) {
            if (collapse) {
                exp.style.display = 'none';
                col.style.display = 'flex';
            } else {
                exp.style.display = 'flex';
                col.style.display = 'none';
            }
        }
    };

    window.sendAdminReply = function() {
        var input = document.getElementById('adminReplyInput');
        var content = input.value.trim();
        if (!content || !activeConvId) return;
        var fd = new FormData();
        fd.append('conversationId', activeConvId);
        fd.append('content', content);
        fetch(cp + '/admin/chat/reply', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.success) {
                    input.value = '';
                    document.getElementById('adminCharCount').textContent = '0 / 2000';
                    fetchMessages(activeConvId, true);
                    showToast('Đã gửi', true);
                } else { showToast(data.message, false); }
            })
            .catch(function() { showToast('Lỗi kết nối', false); });
    };

    window.closeConversation = function() {
        if (!activeConvId || !confirm('Đóng cuộc hội thoại này?')) return;
        var fd = new FormData();
        fd.append('conversationId', activeConvId);
        fetch(cp + '/admin/chat/close', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                showToast(data.message, data.success);
                if (data.success) fetchMessages(activeConvId, false);
            });
    };

    window.reopenConversation = function() {
        if (!activeConvId) return;
        var fd = new FormData();
        fd.append('conversationId', activeConvId);
        fetch(cp + '/admin/chat/reopen', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                showToast(data.message, data.success);
                if (data.success) fetchMessages(activeConvId, false);
            });
    };

    var replyInput = document.getElementById('adminReplyInput');
    if (replyInput) {
        replyInput.addEventListener('input', function() {
            document.getElementById('adminCharCount').textContent = this.value.length + ' / 2000';
        });
        replyInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && e.ctrlKey) { e.preventDefault(); window.sendAdminReply(); }
        });
    }

    function showToast(msg, success) {
        var t = document.getElementById('chatToast');
        t.textContent = msg;
        t.className = 'toast-msg show ' + (success ? 'toast-success' : 'toast-error');
        setTimeout(function() { t.classList.remove('show'); }, 3000);
    }

    function escapeHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
})();
</script>
</body>
</html>
