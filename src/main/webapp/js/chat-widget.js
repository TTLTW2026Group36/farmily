var chatWidget = (function () {
    var cp = '';
    var activeConvId = null;
    var isOpen = false;
    var pollingTimer = null;
    var badgeTimer = null;

    function init(contextPath) {
        cp = contextPath;
        fetchBadgeCount();
        badgeTimer = setInterval(fetchBadgeCount, 30000);

        var input = document.getElementById('widgetMsgInput');
        if (input) {
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
            });
        }
    }

    function toggle() {
        isOpen = !isOpen;
        var panel = document.getElementById('chatPanel');
        var fabIcon = document.querySelector('.chat-fab-icon');
        var fabClose = document.querySelector('.chat-fab-close');
        if (isOpen) {
            panel.style.display = 'flex';
            panel.style.flexDirection = 'column';
            if (fabIcon)  fabIcon.style.display  = 'none';
            if (fabClose) fabClose.style.display = '';
            showListView();
            startPolling();
        } else {
            panel.style.display = 'none';
            if (fabIcon)  fabIcon.style.display  = '';
            if (fabClose) fabClose.style.display = 'none';
            stopPolling();
        }
    }

    function showListView() {
        setView('chatViewList');
        activeConvId = null;
        loadConversations();
    }

    function showNewView() {
        setView('chatViewNew');
        document.getElementById('newConvSubject').value = '';
        document.getElementById('newConvMsg').value = '';
    }

    function showMessagesView(convId, title, status) {
        activeConvId = convId;
        setView('chatViewMessages');
        var titleEl = document.getElementById('widgetConvTitle');
        if (titleEl) titleEl.textContent = title || 'Hội thoại';
        loadMessages(convId, true);
        updateInputVisibility(status);
    }

    function setView(viewId) {
        ['chatViewList', 'chatViewMessages', 'chatViewNew'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.style.display = id === viewId ? 'flex' : 'none';
            if (el && id === viewId) el.style.flexDirection = 'column';
        });
    }

    function loadConversations() {
        var listEl = document.getElementById('widgetConvList');
        listEl.innerHTML = '<div class="widget-loading"><i class="fas fa-spinner fa-spin"></i></div>';
        fetch(cp + '/api/chat/conversations', { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                renderConversations(data.conversations);
                updateBadge(data.unreadTotal || 0);
            })
            .catch(function () {
                listEl.innerHTML = '<div class="widget-empty"><p>Lỗi tải dữ liệu</p></div>';
            });
    }

    function renderConversations(conversations) {
        var listEl = document.getElementById('widgetConvList');
        if (!conversations || conversations.length === 0) {
            listEl.innerHTML =
                '<div class="widget-empty">' +
                '<i class="fas fa-comments"></i>' +
                '<p>Chưa có cuộc hội thoại nào</p>' +
                '<button class="widget-start-btn" onclick="chatWidget.showNewView()">Bắt đầu ngay</button>' +
                '</div>';
            return;
        }
        var html = '';
        conversations.forEach(function (conv) {
            html += '<div class="widget-conv-item" onclick="chatWidget.openConversation(' +
                conv.id + ',\'' + escHtml(conv.subject) + '\',\'' + conv.status + '\')">';
            html += '<div class="widget-conv-avatar"><i class="fas fa-comments"></i></div>';
            html += '<div class="widget-conv-info">';
            html += '<div class="widget-conv-subject">' + escHtml(conv.subject) + '</div>';
            if (conv.lastMessage) {
                html += '<div class="widget-conv-last">' + escHtml(conv.lastMessage.substring(0, 50)) + '</div>';
            }
            html += '<div class="widget-conv-time">' + escHtml(conv.timeAgo) + '</div>';
            html += '</div>';
            if (conv.unreadCount > 0) {
                html += '<span class="widget-conv-unread">' + conv.unreadCount + '</span>';
            }
            html += '</div>';
        });
        listEl.innerHTML = html;
    }

    function openConversation(convId, title, status) {
        showMessagesView(convId, title, status);
    }

    function loadMessages(convId, scrollBottom) {
        var area = document.getElementById('widgetMessages');
        if (scrollBottom) {
            area.innerHTML = '<div class="widget-loading"><i class="fas fa-spinner fa-spin"></i></div>';
        }
        fetch(cp + '/api/chat/messages?conversationId=' + convId + '&limit=100', { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                renderMessages(data.messages);
                if (data.subject) {
                    var titleEl = document.getElementById('widgetConvTitle');
                    if (titleEl) titleEl.textContent = data.subject;
                }
                var bannerEl = document.getElementById('widgetOrderBanner');
                if (bannerEl) {
                    if (data.orderId) {
                        var badgeClass = 'status-' + data.refundStatus;
                        var statusText = data.refundStatusText || data.refundStatus;
                        var bHtml = '';
                        bHtml += '<div id="widgetBannerExpanded" style="display: flex; flex-direction: column; gap: 6px; width: 100%;">';
                        bHtml += '  <div class="widget-banner-header">';
                        bHtml += '    <div class="widget-banner-title">Đơn hàng #' + data.orderId + '</div>';
                        bHtml += '    <div style="display: flex; align-items: center; gap: 6px;">';
                        bHtml += '      <span class="widget-banner-badge ' + badgeClass + '">' + escHtml(statusText) + '</span>';
                        bHtml += '      <button onclick="chatWidget.toggleWidgetBanner(true)" style="background: none; border: none; color: #b45309; cursor: pointer; padding: 2px; font-size: 12px; display: inline-flex; align-items: center;" title="Ẩn chi tiết"><i class="fas fa-chevron-up"></i></button>';
                        bHtml += '    </div>';
                        bHtml += '  </div>';
                        bHtml += '  <div class="widget-banner-desc">';
                        bHtml += '    Lý do: <strong>' + escHtml(data.refundReason) + '</strong><br>';
                        bHtml += '    Số tiền: <span class="refund-amount">' + escHtml(data.refundAmount) + '</span>';
                        bHtml += '  </div>';
                        bHtml += '  <div class="widget-banner-actions">';
                        bHtml += '    <a href="' + cp + '/ho-so/don-hang/chi-tiet?id=' + data.orderId + '" class="widget-banner-btn" target="_blank">Chi tiết đơn hàng</a>';
                        bHtml += '  </div>';
                        bHtml += '</div>';
                        bHtml += '<div id="widgetBannerCollapsed" style="display: none; justify-content: space-between; align-items: center; width: 100%;">';
                        bHtml += '  <span style="font-size: 11px; font-weight: 600; color: #b45309;">Đơn hàng #' + data.orderId + ' (' + escHtml(statusText) + ')</span>';
                        bHtml += '  <button onclick="chatWidget.toggleWidgetBanner(false)" style="background: #fde68a; border: none; color: #b45309; padding: 4px 10px; border-radius: 6px; font-size: 10px; font-weight: 600; cursor: pointer;">Hiện chi tiết</button>';
                        bHtml += '</div>';
                        bannerEl.innerHTML = bHtml;
                        bannerEl.style.display = 'flex';
                    } else {
                        bannerEl.style.display = 'none';
                        bannerEl.innerHTML = '';
                    }
                }
                if (scrollBottom) {
                    setTimeout(function () {
                        area.scrollTop = area.scrollHeight;
                    }, 30);
                }
            })
            .catch(function () {
                area.innerHTML = '<div class="widget-empty"><p>Lỗi tải tin nhắn</p></div>';
            });
    }

    function renderMessages(messages) {
        var area = document.getElementById('widgetMessages');
        if (!messages || messages.length === 0) {
            area.innerHTML =
                '<div class="widget-empty">' +
                '<i class="fas fa-comment-slash"></i>' +
                '<p>Chưa có tin nhắn nào</p>' +
                '</div>';
            return;
        }
        var atBottom = area.scrollHeight - area.scrollTop - area.clientHeight < 60;
        var html = '';
        messages.forEach(function (msg) {
            var isMe = msg.senderType === 'customer';
            html += '<div class="widget-msg-wrap ' + (isMe ? 'me' : 'admin') + '">';
            html += '<div class="widget-bubble ' + (isMe ? 'bubble-me' : 'bubble-admin') + '">';
            html += '<div style="word-break:break-word;">' + escHtml(msg.content) + '</div>';
            html += '<div class="widget-bubble-time">' + escHtml(msg.formattedTime) + '</div>';
            html += '</div></div>';
        });
        area.innerHTML = html;
        if (atBottom) area.scrollTop = area.scrollHeight;
    }

    function updateInputVisibility(status) {
        var inputArea   = document.getElementById('widgetInputArea');
        var closedNotice = document.getElementById('widgetClosedNotice');
        if (status === 'closed') {
            if (inputArea)    inputArea.style.display    = 'none';
            if (closedNotice) closedNotice.style.display = '';
        } else {
            if (inputArea)    inputArea.style.display    = '';
            if (closedNotice) closedNotice.style.display = 'none';
        }
    }

    function sendMessage() {
        if (!activeConvId) return;
        var input = document.getElementById('widgetMsgInput');
        var content = input.value.trim();
        if (!content) return;
        var fd = new FormData();
        fd.append('conversationId', activeConvId);
        fd.append('content', content);
        fetch(cp + '/api/chat/send', { method: 'POST', body: fd, credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.success) {
                    input.value = '';
                    loadMessages(activeConvId, false);
                    var area = document.getElementById('widgetMessages');
                    setTimeout(function () { if (area) area.scrollTop = area.scrollHeight; }, 80);
                }
            })
            .catch(function () {});
    }

    function createConversation() {
        var subject = document.getElementById('newConvSubject').value.trim();
        var msg     = document.getElementById('newConvMsg').value.trim();
        if (!subject) { document.getElementById('newConvSubject').focus(); return; }
        if (!msg)     { document.getElementById('newConvMsg').focus(); return; }

        var fd = new FormData();
        fd.append('subject', subject);
        fetch(cp + '/api/chat/conversations', { method: 'POST', body: fd, credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.conversationId) {
                    var fd2 = new FormData();
                    fd2.append('conversationId', data.conversationId);
                    fd2.append('content', msg);
                    return fetch(cp + '/api/chat/send', { method: 'POST', body: fd2, credentials: 'same-origin' })
                        .then(function () {
                            showMessagesView(data.conversationId, subject, 'open');
                        });
                }
            })
            .catch(function () {});
    }

    function fetchBadgeCount() {
        fetch(cp + '/api/chat/unread-count', { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) { updateBadge(data.count || 0); })
            .catch(function () {});
    }

    function updateBadge(count) {
        var badge = document.getElementById('chatFabBadge');
        if (!badge) return;
        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.style.display = 'flex';
        } else {
            badge.style.display = 'none';
        }
    }

    function startPolling() {
        stopPolling();
        pollingTimer = setInterval(function () {
            if (!isOpen) return;
            if (activeConvId) {
                loadMessages(activeConvId, false);
            } else {
                loadConversations();
            }
        }, 5000);
    }

    function stopPolling() {
        if (pollingTimer) { clearInterval(pollingTimer); pollingTimer = null; }
    }

    function escHtml(text) {
        if (!text) return '';
        var div = document.createElement('div');
        div.textContent = String(text);
        return div.innerHTML;
    }

    function toggleWidgetBanner(collapse) {
        var exp = document.getElementById('widgetBannerExpanded');
        var col = document.getElementById('widgetBannerCollapsed');
        if (exp && col) {
            if (collapse) {
                exp.style.display = 'none';
                col.style.display = 'flex';
            } else {
                exp.style.display = 'block';
                col.style.display = 'none';
            }
        }
    }

    return {
        init: init,
        toggle: toggle,
        showListView: showListView,
        showNewView: showNewView,
        openConversation: openConversation,
        sendMessage: sendMessage,
        createConversation: createConversation,
        toggleWidgetBanner: toggleWidgetBanner
    };
})();
