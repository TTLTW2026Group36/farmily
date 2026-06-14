<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${not empty sessionScope.auth}">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat-widget.css?v=4">

<div id="farmily-chat-widget">
    <button class="chat-fab" id="chatFab" onclick="chatWidget.toggle()" title="Chat hỗ trợ" aria-label="Mở chat hỗ trợ">
        <i class="fas fa-comments chat-fab-icon"></i>
        <i class="fas fa-times chat-fab-close" style="display:none;"></i>
        <span class="chat-fab-badge" id="chatFabBadge" style="display:none;">0</span>
    </button>

    <div class="chat-panel" id="chatPanel" style="display:none;" role="dialog" aria-label="Chat hỗ trợ">
        <div class="chat-header">
            <div class="chat-header-info">
                <div class="chat-header-avatar"><i class="fas fa-headset"></i></div>
                <div>
                    <div class="chat-header-title">Farmily CSKH</div>
                    <div class="chat-header-sub">Chúng tôi sẵn sàng hỗ trợ bạn</div>
                </div>
            </div>
            <button class="chat-header-close" onclick="chatWidget.toggle()" aria-label="Đóng chat"><i class="fas fa-times"></i></button>
        </div>

        <div class="chat-view" id="chatViewList">
            <div class="chat-view-toolbar">
                <span class="chat-view-title">Cuộc hội thoại</span>
                <button class="chat-new-btn" onclick="chatWidget.showNewView()" id="btnNewConv">
                    <i class="fas fa-plus"></i> Mới
                </button>
            </div>
            <div class="chat-list-body" id="widgetConvList">
                <div class="widget-loading"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
        </div>

        <div class="chat-view" id="chatViewMessages" style="display:none;">
            <div class="chat-view-toolbar">
                <button class="chat-back-btn" onclick="chatWidget.showListView()"><i class="fas fa-arrow-left"></i></button>
                <span class="chat-view-title" id="widgetConvTitle">Hội thoại</span>
            </div>
            <div id="widgetOrderBanner" class="widget-order-banner" style="display:none;"></div>
            <div class="chat-messages-body" id="widgetMessages">
                <div class="widget-loading"><i class="fas fa-spinner fa-spin"></i></div>
            </div>
            <div class="widget-closed-notice" id="widgetClosedNotice" style="display:none;">
                <i class="fas fa-lock"></i> Cuộc hội thoại đã đóng.
            </div>
            <div class="widget-input-area" id="widgetInputArea">
                <textarea id="widgetMsgInput" class="widget-textarea" placeholder="Nhập tin nhắn..." rows="2" maxlength="2000"></textarea>
                <button class="widget-send-btn" onclick="chatWidget.sendMessage()" aria-label="Gửi tin nhắn">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>

        <div class="chat-view" id="chatViewNew" style="display:none;">
            <div class="chat-view-toolbar">
                <button class="chat-back-btn" onclick="chatWidget.showListView()"><i class="fas fa-arrow-left"></i></button>
                <span class="chat-view-title">Cuộc hội thoại mới</span>
            </div>
            <div class="chat-new-form">
                <label class="widget-label">Chủ đề</label>
                <input type="text" id="newConvSubject" class="widget-input" placeholder="Ví dụ: Hỏi về đơn hàng..." maxlength="255">
                <label class="widget-label" style="margin-top:10px;">Tin nhắn đầu tiên</label>
                <textarea id="newConvMsg" class="widget-textarea" placeholder="Nhập câu hỏi của bạn..." rows="4" maxlength="2000"></textarea>
                <button class="widget-create-btn" onclick="chatWidget.createConversation()">
                    <i class="fas fa-paper-plane"></i> Bắt đầu
                </button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/chat-widget.js?v=4"></script>
<script>
    chatWidget.init('${pageContext.request.contextPath}');
</script>
</c:if>
