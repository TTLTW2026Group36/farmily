<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="isAdminOrManager" value="${sessionScope.adminUser.role == 'ADMIN' || sessionScope.adminUser.role == 'MANAGER'}" />
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết Hoàn tiền #${refund.id} - Admin Farmily</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoanTien.css?v=<%= System.currentTimeMillis() %>">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <style>
                        .detail-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 20px;
                        }

                        @media (max-width: 900px) {
                            .detail-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        .detail-card {
                            background: #fff;
                            border: 1px solid #e0e0e0;
                            border-radius: 12px;
                            padding: 20px;
                            margin-bottom: 20px;
                        }

                        .detail-card h3 {
                            font-size: 15px;
                            color: #2d6a2d;
                            margin-bottom: 16px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            border-bottom: 1px solid #e8f5e9;
                            padding-bottom: 10px;
                        }

                        .detail-row {
                            display: flex;
                            gap: 12px;
                            margin-bottom: 10px;
                            font-size: 14px;
                            align-items: flex-start;
                        }

                        .detail-lbl {
                            font-weight: 600;
                            color: #555;
                            min-width: 140px;
                            flex-shrink: 0;
                        }

                        .detail-val {
                            color: #222;
                        }

                        .media-grid {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 10px;
                            margin-top: 12px;
                        }

                        .media-thumb {
                            width: 100px;
                            height: 100px;
                            border-radius: 8px;
                            object-fit: cover;
                            border: 1px solid #ddd;
                            cursor: zoom-in;
                            transition: transform 0.15s, box-shadow 0.15s;
                        }

                        .media-thumb:hover {
                            transform: scale(1.04);
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        }

                        video.media-thumb {
                            cursor: pointer;
                        }

                        .action-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            padding: 11px 20px;
                            border: none;
                            border-radius: 8px;
                            font-size: 14px;
                            font-weight: 600;
                            cursor: pointer;
                            font-family: inherit;
                            transition: opacity 0.15s;
                        }

                        .action-btn:hover {
                            opacity: 0.87;
                        }

                        .btn-approve {
                            background: #2d6a2d;
                            color: #fff;
                        }

                        .btn-reject {
                            background: #dc3545;
                            color: #fff;
                        }

                        .btn-confirm {
                            background: #0d6efd;
                            color: #fff;
                        }

                        .action-area {
                            display: flex;
                            gap: 12px;
                            flex-wrap: wrap;
                            margin-top: 20px;
                        }

                        .modal-overlay {
                            display: none;
                            position: fixed;
                            inset: 0;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 99999 !important;
                            align-items: center;
                            justify-content: center;
                        }

                        .modal-overlay.active {
                            display: flex !important;
                            opacity: 1 !important;
                            pointer-events: auto !important;
                        }

                        .modal-box {
                            background: #fff;
                            border-radius: 12px;
                            padding: 28px;
                            width: 100%;
                            max-width: 480px;
                        }

                        .modal-title {
                            font-size: 18px;
                            font-weight: 700;
                            margin-bottom: 16px;
                        }

                        .modal-label {
                            font-size: 14px;
                            font-weight: 600;
                            color: #444;
                            margin-bottom: 6px;
                            display: block;
                        }

                        .modal-input,
                        .modal-textarea {
                            width: 100%;
                            padding: 10px 14px;
                            border: 1px solid #ddd;
                            border-radius: 8px;
                            font-size: 14px;
                            font-family: inherit;
                            box-sizing: border-box;
                        }

                        .modal-textarea {
                            resize: vertical;
                            min-height: 80px;
                        }

                        .modal-actions {
                            display: flex;
                            gap: 10px;
                            justify-content: flex-end;
                            margin-top: 20px;
                        }

                        .toast-msg {
                            position: fixed;
                            bottom: 24px;
                            right: 24px;
                            z-index: 9999;
                            padding: 14px 20px;
                            border-radius: 10px;
                            font-size: 14px;
                            font-weight: 500;
                            color: #fff;
                            opacity: 0;
                            transition: opacity 0.3s;
                            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                        }

                        .toast-msg.show {
                            opacity: 1;
                        }

                        .toast-success {
                            background: #16a34a;
                        }

                        .toast-error {
                            background: #dc2626;
                        }
                    </style>
                </head>

                <body data-page="refund-requests">
                    <div class="admin-layout">
                        <jsp:include page="sidebar.jsp" />
                        <main class="admin-main">
                            <jsp:include page="header.jsp" />
                            <div class="admin-content">

                                <div class="orders-page-header">
                                    <div style="display:flex;align-items:center;gap:16px;">
                                        <a href="${pageContext.request.contextPath}/admin/refund-requests"
                                            class="btn-bento-secondary"
                                            style="display:inline-flex;align-items:center;gap:6px;">
                                            <i class="fas fa-arrow-left"></i> Quay lại
                                        </a>
                                        <div>
                                            <h1 class="orders-page-title">Yêu cầu hoàn tiền #${refund.id}</h1>
                                            <div class="content-breadcrumb">
                                                <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                        class="fas fa-home"></i> Dashboard</a>
                                                <span>/</span>
                                                <a href="${pageContext.request.contextPath}/admin/refund-requests">Hoàn
                                                    tiền</a>
                                                <span>/</span>
                                                <span>#${refund.id}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <span class="admin-refund-badge ${refund.status}"
                                            style="font-size:14px;padding:6px 16px;">
                                            ${refund.statusText}
                                        </span>
                                    </div>
                                </div>

                                <div class="detail-grid">

                                    <%-- Left column: Request info --%>
                                        <div>
                                            <div class="detail-card">
                                                <h3><i class="fas fa-file-alt"></i> Thông tin yêu cầu</h3>
                                                <div class="detail-row">
                                                    <span class="detail-lbl">ID yêu cầu:</span>
                                                    <span class="detail-val">#${refund.id}</span>
                                                </div>
                                                <div class="detail-row">
                                                    <span class="detail-lbl">Đơn hàng:</span>
                                                    <span class="detail-val">
                                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${refund.orderId}"
                                                            target="_blank" style="color:#2d6a2d;font-weight:600;">
                                                            #${refund.orderId} <i class="fas fa-external-link-alt"
                                                                style="font-size:11px;"></i>
                                                        </a>
                                                    </span>
                                                </div>
                                                <div class="detail-row">
                                                    <span class="detail-lbl">Ngày gửi:</span>
                                                    <span class="detail-val">${refund.formattedDate}</span>
                                                </div>
                                                <div class="detail-row">
                                                    <span class="detail-lbl">Lý do:</span>
                                                    <span class="detail-val">${fn:escapeXml(refund.reason)}</span>
                                                </div>
                                                <c:if test="${not empty refund.description}">
                                                    <div class="detail-row">
                                                        <span class="detail-lbl">Mô tả:</span>
                                                        <span
                                                            class="detail-val">${fn:escapeXml(refund.description)}</span>
                                                    </div>
                                                </c:if>
                                                <div class="detail-row">
                                                    <span class="detail-lbl">Số tiền hoàn:</span>
                                                    <span class="detail-val"
                                                        style="font-weight:700;color:#2d6a2d;font-size:16px;">
                                                        ${refund.formattedRefundAmount}
                                                    </span>
                                                </div>
                                                <c:if test="${not empty refund.transactionCode}">
                                                    <div class="detail-row">
                                                        <span class="detail-lbl">Mã giao dịch:</span>
                                                        <span class="detail-val"
                                                            style="font-weight:700;color:#0d6efd;font-size:15px;letter-spacing:0.5px;">
                                                            ${fn:escapeXml(refund.transactionCode)}
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <%-- Bank info --%>
                                                <div class="detail-card">
                                                    <h3><i class="fas fa-university"></i> Tài khoản nhận hoàn tiền</h3>
                                                    <div class="detail-row">
                                                        <span class="detail-lbl">Ngân hàng:</span>
                                                        <span class="detail-val">${fn:escapeXml(refund.bankName)}</span>
                                                    </div>
                                                    <div class="detail-row">
                                                        <span class="detail-lbl">Số tài khoản:</span>
                                                        <span class="detail-val" style="font-weight: 600;">
                                                            ${fn:escapeXml(refund.bankAccount)}
                                                        </span>
                                                    </div>
                                                    <div class="detail-row">
                                                        <span class="detail-lbl">Chủ tài khoản:</span>
                                                        <span class="detail-val"
                                                            style="font-weight:700;">${fn:escapeXml(refund.bankHolder)}</span>
                                                    </div>
                                                </div>

                                                <%-- Admin note if exists --%>
                                                    <c:if test="${not empty refund.adminNote}">
                                                        <div class="detail-card">
                                                            <h3><i class="fas fa-comment-alt"></i> Ghi chú admin</h3>
                                                            <p style="font-size:14px;color:#333;">
                                                                ${fn:escapeXml(refund.adminNote)}</p>
                                                        </div>
                                                    </c:if>
                                        </div>

                                        <%-- Right column: Customer + Media + Order --%>
                                            <div>
                                                <%-- Customer info --%>
                                                    <div class="detail-card">
                                                        <h3><i class="fas fa-user"></i> Khách hàng</h3>
                                                        <c:if test="${not empty refund.user}">
                                                            <div class="detail-row">
                                                                <span class="detail-lbl">Tên:</span>
                                                                <span
                                                                    class="detail-val">${fn:escapeXml(refund.user.name)}</span>
                                                            </div>
                                                            <div class="detail-row">
                                                                <span class="detail-lbl">Email:</span>
                                                                <span
                                                                    class="detail-val">${fn:escapeXml(refund.user.email)}</span>
                                                            </div>
                                                            <c:if test="${not empty refund.user.phone}">
                                                                <div class="detail-row">
                                                                    <span class="detail-lbl">Điện thoại:</span>
                                                                    <span
                                                                        class="detail-val">${fn:escapeXml(refund.user.phone)}</span>
                                                                </div>
                                                            </c:if>
                                                        </c:if>
                                                        <c:if test="${empty refund.user}">
                                                            <p style="color:#888;">Không tìm thấy thông tin khách hàng
                                                            </p>
                                                        </c:if>
                                                    </div>

                                                    <%-- Media --%>
                                                        <div class="detail-card">
                                                            <h3><i class="fas fa-images"></i> Hình ảnh / Video minh
                                                                chứng</h3>
                                                            <c:if test="${empty refund.images}">
                                                                <p style="color:#888;font-size:14px;">Không có minh
                                                                    chứng đính kèm</p>
                                                            </c:if>
                                                            <c:if test="${not empty refund.images}">
                                                                <div class="media-grid">
                                                                    <c:forEach var="img" items="${refund.images}">
                                                                        <c:choose>
                                                                            <c:when test="${img.mediaType == 'video'}">
                                                                                <div
                                                                                    style="position:relative; display:inline-block; cursor:zoom-in;">
                                                                                    <video src="${img.imageUrl}"
                                                                                        class="media-thumb" muted
                                                                                        preload="metadata"
                                                                                        onclick="openLightbox('${img.imageUrl}', 'video')"></video>
                                                                                    <div onclick="openLightbox('${img.imageUrl}', 'video')"
                                                                                        style="position:absolute; inset:0; background:rgba(0,0,0,0.15); display:flex; align-items:center; justify-content:center; border-radius:8px;">
                                                                                        <i class="fas fa-play"
                                                                                            style="color:#fff; font-size:20px; text-shadow:0 2px 4px rgba(0,0,0,0.5);"></i>
                                                                                    </div>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="${img.imageUrl}"
                                                                                    alt="Minh chứng" class="media-thumb"
                                                                                    onclick="openLightbox('${img.imageUrl}', 'image')">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:if>
                                                        </div>

                                            </div>
                                </div>

                                <%-- Action buttons --%>
                                    <c:if test="${refund.status == 'pending' && isAdminOrManager}">
                                        <div class="action-area">
                                            <button class="action-btn btn-approve" onclick="openApproveModal()">
                                                <i class="fas fa-check"></i> Duyệt yêu cầu
                                            </button>
                                            <button class="action-btn btn-reject" onclick="openRejectModal()">
                                                <i class="fas fa-times"></i> Từ chối
                                            </button>
                                        </div>
                                    </c:if>
                                    <c:if test="${refund.status == 'approved' && isAdminOrManager}">
                                        <div class="action-area">
                                            <button class="action-btn btn-confirm" onclick="openConfirmRefundModal()">
                                                <i class="fas fa-money-bill-wave"></i> Xác nhận đã chuyển tiền
                                            </button>
                                        </div>
                                    </c:if>

                                <div class="detail-card" style="margin-top:20px;" id="refundChatSection">
                                    <h3><i class="fas fa-comments"></i> Trao đổi với khách hàng</h3>
                                    <div id="refundChatMessages" style="max-height:300px;overflow-y:auto;padding:8px 0;margin-bottom:12px;display:flex;flex-direction:column;gap:8px;">
                                        <div style="text-align:center;color:#9ca3af;padding:20px;">
                                            <i class="fas fa-spinner fa-spin"></i> Đang tải...
                                        </div>
                                    </div>
                                    <div id="refundChatClosed" style="display:none;background:#fef3c7;color:#92400e;padding:10px 14px;border-radius:8px;font-size:14px;margin-bottom:8px;">
                                        <i class="fas fa-lock"></i> Cuộc hội thoại đã đóng.
                                    </div>
                                    <div id="refundChatInput">
                                        <textarea id="refundChatContent" rows="2" maxlength="2000"
                                            style="width:100%;border:1px solid #d1d5db;border-radius:8px;padding:8px 12px;font-size:14px;font-family:inherit;resize:none;box-sizing:border-box;"
                                            placeholder="Nhập tin nhắn..."></textarea>
                                        <div style="display:flex;justify-content:flex-end;margin-top:6px;">
                                            <button onclick="sendRefundChatMsg()"
                                                style="background:#2d6a2d;color:#fff;border:none;border-radius:8px;padding:8px 18px;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;">
                                                <i class="fas fa-paper-plane"></i> Gửi
                                            </button>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </main>
                    </div>

                    <%-- Approve Modal --%>
                        <div class="modal-overlay" id="approveModal">
                            <div class="modal-box">
                                <div class="modal-title"><i class="fas fa-check-circle"></i> Duyệt yêu cầu hoàn tiền
                                </div>
                                <div style="margin-bottom:14px;">
                                    <label class="modal-label">Số tiền hoàn (VND)</label>
                                    <input type="number" id="approveAmount" class="modal-input"
                                        value="${refund.refundAmount}" min="0" step="1000">
                                </div>
                                <div style="margin-bottom:6px;">
                                    <label class="modal-label">Ghi chú (tuỳ chọn)</label>
                                    <textarea id="approveNote" class="modal-textarea"
                                        placeholder="Nhập ghi chú..."></textarea>
                                </div>
                                <div class="modal-actions">
                                    <button onclick="closeModal('approveModal')"
                                        style="padding:10px 18px;border:1px solid #ddd;border-radius:8px;background:#f5f5f5;cursor:pointer;">
                                        Hủy
                                    </button>
                                    <button class="action-btn btn-approve" onclick="submitApprove()">
                                        <i class="fas fa-check"></i> Xác nhận duyệt
                                    </button>
                                </div>
                            </div>
                        </div>

                        <%-- Reject Modal --%>
                            <div class="modal-overlay" id="rejectModal">
                                <div class="modal-box">
                                    <div class="modal-title"><i class="fas fa-times-circle"></i> Từ chối yêu cầu hoàn
                                        tiền</div>
                                    <div style="margin-bottom:6px;">
                                        <label class="modal-label">Lý do từ chối <span
                                                style="color:#dc3545;">*</span></label>
                                        <textarea id="rejectNote" class="modal-textarea"
                                            placeholder="Nhập lý do từ chối..."></textarea>
                                    </div>
                                    <div class="modal-actions">
                                        <button onclick="closeModal('rejectModal')"
                                            style="padding:10px 18px;border:1px solid #ddd;border-radius:8px;background:#f5f5f5;cursor:pointer;">
                                            Hủy
                                        </button>
                                        <button class="action-btn btn-reject" onclick="submitReject()">
                                            <i class="fas fa-times"></i> Từ chối
                                        </button>
                                    </div>
                                </div>
                            </div>

                        <%-- Confirm Refunded Modal --%>
                        <div class="modal-overlay" id="confirmRefundModal">
                            <div class="modal-box">
                                <div class="modal-title" style="color:#0d6efd;"><i class="fas fa-money-bill-wave"></i> Xác nhận chuyển khoản hoàn tiền</div>
                                <div style="margin-bottom:14px; background:#f8f9fa; padding:12px; border-radius:8px; border:1px solid #e9ecef; font-size:14px; line-height:1.6;">
                                    <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                                        <span style="color:#6c757d;">Ngân hàng:</span>
                                        <span style="font-weight:600; color:#212529;">${fn:escapeXml(refund.bankName)}</span>
                                    </div>
                                    <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                                        <span style="color:#6c757d;">Số tài khoản:</span>
                                        <span style="font-weight:600; color:#212529;">${fn:escapeXml(refund.bankAccount)}</span>
                                    </div>
                                    <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                                        <span style="color:#6c757d;">Chủ tài khoản:</span>
                                        <span style="font-weight:600; color:#212529;">${fn:escapeXml(refund.bankHolder)}</span>
                                    </div>
                                    <div style="display:flex; justify-content:space-between; border-top:1px solid #dee2e6; padding-top:6px; margin-top:6px;">
                                        <span style="color:#6c757d; font-weight:600;">Số tiền cần chuyển:</span>
                                        <span style="font-weight:700; color:#2d6a2d; font-size:15px;">${refund.formattedRefundAmount}</span>
                                    </div>
                                </div>
                                <div style="margin-bottom:14px;">
                                    <label class="modal-label">Mã giao dịch <span style="color:#dc3545;">*</span></label>
                                    <input type="text" id="confirmTxCode" class="modal-input"
                                        placeholder="Nhập mã giao dịch chuyển tiền (VD: FT2310...)" required>
                                </div>
                                <div class="modal-actions">
                                    <button onclick="closeModal('confirmRefundModal')"
                                        style="padding:10px 18px;border:1px solid #ddd;border-radius:8px;background:#f5f5f5;cursor:pointer;">
                                        Hủy
                                    </button>
                                    <button class="action-btn btn-confirm" onclick="submitConfirmRefunded()">
                                        <i class="fas fa-check"></i> Xác nhận hoàn tất
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="toast-msg" id="actionToast"></div>

                            <script>
                                var REFUND_ID = ${ refund.id };
                                var ctxPath = '${pageContext.request.contextPath}';

                                function openApproveModal() { document.getElementById('approveModal').classList.add('active'); }
                                function openRejectModal() { document.getElementById('rejectModal').classList.add('active'); }
                                function openConfirmRefundModal() { document.getElementById('confirmRefundModal').classList.add('active'); }
                                function closeModal(id) { document.getElementById(id).classList.remove('active'); }

                                function submitApprove() {
                                    var note = document.getElementById('approveNote').value;
                                    var amount = document.getElementById('approveAmount').value;
                                    postAction(ctxPath + '/admin/refund-requests/approve',
                                        { refundId: REFUND_ID, adminNote: note, refundAmount: amount },
                                        function (msg) {
                                            closeModal('approveModal');
                                            showToast(msg, true);
                                            setTimeout(function () { location.reload(); }, 1500);
                                        });
                                }

                                function submitReject() {
                                    var note = document.getElementById('rejectNote').value.trim();
                                    if (!note) { alert('Vui lòng nhập lý do từ chối'); return; }
                                    postAction(ctxPath + '/admin/refund-requests/reject',
                                        { refundId: REFUND_ID, adminNote: note },
                                        function (msg) {
                                            closeModal('rejectModal');
                                            showToast(msg, true);
                                            setTimeout(function () { location.reload(); }, 1500);
                                        });
                                }

                                function submitConfirmRefunded() {
                                    var txCode = document.getElementById('confirmTxCode').value.trim();
                                    if (!txCode) {
                                        alert('Vui lòng nhập mã giao dịch');
                                        return;
                                    }
                                    postAction(ctxPath + '/admin/refund-requests/confirm',
                                        { refundId: REFUND_ID, transactionCode: txCode },
                                        function (msg) {
                                            closeModal('confirmRefundModal');
                                            showToast(msg, true);
                                            setTimeout(function () { location.reload(); }, 1500);
                                        });
                                }

                                function postAction(url, data, onSuccess) {
                                    var params = new URLSearchParams();
                                    for (var k in data) params.append(k, data[k]);
                                    fetch(url, {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: params
                                    })
                                        .then(function (r) { return r.json(); })
                                        .then(function (json) {
                                            if (json.success) onSuccess(json.message);
                                            else showToast(json.message, false);
                                        })
                                        .catch(function () { showToast('Lỗi kết nối', false); });
                                }

                                function showToast(msg, success) {
                                    var t = document.getElementById('actionToast');
                                    t.textContent = msg;
                                    t.className = 'toast-msg show ' + (success ? 'toast-success' : 'toast-error');
                                    setTimeout(function () { t.classList.remove('show'); }, 3000);
                                }

                                function openLightbox(src, type) {
                                    var modal = document.getElementById('mediaPreviewModal');
                                    var img = document.getElementById('mediaPreviewImg');
                                    var video = document.getElementById('mediaPreviewVideo');

                                    img.style.display = 'none';
                                    img.src = '';
                                    video.style.display = 'none';
                                    video.src = '';
                                    video.pause();

                                    if (type === 'image') {
                                        img.src = src;
                                        img.style.display = 'block';
                                    } else if (type === 'video') {
                                        video.src = src;
                                        video.style.display = 'block';
                                        video.load();
                                        video.play().catch(function (e) { console.log('Autoplay blocked', e); });
                                    }

                                    modal.classList.add('active');
                                }

                                function closeMediaModal(e) {
                                    if (e.target.id === 'mediaPreviewModal') {
                                        closeMediaModalDirect();
                                    }
                                }

                                function closeMediaModalDirect() {
                                    var modal = document.getElementById('mediaPreviewModal');
                                    var video = document.getElementById('mediaPreviewVideo');
                                    video.pause();
                                    modal.classList.remove('active');
                                }
                            </script>

                            <div class="media-modal-overlay" id="mediaPreviewModal" onclick="closeMediaModal(event)">
                                <div class="media-modal-box">
                                    <div class="media-modal-title">
                                        <span><i class="fas fa-image"></i> Chi tiết minh chứng</span>
                                        <button class="media-modal-close-btn"
                                            onclick="closeMediaModalDirect()">&times;</button>
                                    </div>
                                    <div class="media-modal-body">
                                        <img src="" id="mediaPreviewImg" class="media-modal-content" alt="Xem ảnh lớn">
                                        <video src="" id="mediaPreviewVideo" class="media-modal-content" controls
                                            autoplay></video>
                                    </div>
                                    <div class="media-modal-footer">
                                        <button class="media-modal-btn-close">Đóng</button>
                                    </div>
                                </div>
                            </div>

                </body>

                 <script>
                 (function() {
                     var cp = ctxPath;
                     var refundId = REFUND_ID;
                     var convId = null;
                     var convClosed = false;

                     function initRefundChat() {
                         fetchAdminChatForRefund();
                     }

                     function fetchAdminChatForRefund() {
                         fetch(cp + '/admin/chat/messages?refundId=' + refundId + '&t=' + Date.now())
                             .then(function(r) { return r.json(); })
                             .then(function(data) {
                                 if (data && data.messages) {
                                     convId = data.conversationId || null;
                                     renderRefundMessages(data.messages);
                                     updateRefundChatStatus(data.status);
                                 }
                             })
                             .catch(function() {});
                     }

                     function renderRefundMessages(messages) {
                         var container = document.getElementById('refundChatMessages');
                         if (!messages || messages.length === 0) {
                             container.innerHTML = '<div style="text-align:center;color:#9ca3af;padding:16px;font-size:13px;">Chưa có tin nhắn nào</div>';
                             return;
                         }
                         var html = '';
                         messages.forEach(function(msg) {
                             var isAdmin = msg.senderType === 'admin';
                             html += '<div style="display:flex;justify-content:' + (isAdmin ? 'flex-end' : 'flex-start') + ';">';
                             html += '<div style="max-width:70%;background:' + (isAdmin ? '#2d6a2d' : '#f3f4f6') + ';color:' + (isAdmin ? '#fff' : '#1f2937') + ';border-radius:12px;padding:9px 13px;font-size:13px;">';
                             html += '<div style="word-break:break-word;">' + escHtml(msg.content) + '</div>';
                             html += '<div style="font-size:11px;opacity:0.65;margin-top:4px;text-align:' + (isAdmin ? 'right' : 'left') + ';">' + escHtml(msg.formattedTime) + (isAdmin ? ' · Admin' : ' · Khách') + '</div>';
                             html += '</div></div>';
                         });
                         container.innerHTML = html;
                         container.scrollTop = container.scrollHeight;
                     }

                     function updateRefundChatStatus(status) {
                         var inputDiv  = document.getElementById('refundChatInput');
                         var closedDiv = document.getElementById('refundChatClosed');
                         convClosed = (status === 'closed');
                         if (convClosed) {
                             if (inputDiv)  inputDiv.style.display  = 'none';
                             if (closedDiv) closedDiv.style.display = '';
                         } else {
                             if (inputDiv)  inputDiv.style.display  = '';
                             if (closedDiv) closedDiv.style.display = 'none';
                         }
                     }

                     window.sendRefundChatMsg = function() {
                         var content = document.getElementById('refundChatContent').value.trim();
                         if (!content || convClosed) return;
                         if (!convId) { showToast('Chưa có cuộc hội thoại', false); return; }
                         var fd = new FormData();
                         fd.append('conversationId', convId);
                         fd.append('content', content);
                         fetch(cp + '/admin/chat/reply', { method: 'POST', body: fd })
                             .then(function(r) { return r.json(); })
                             .then(function(data) {
                                 if (data.success) {
                                     document.getElementById('refundChatContent').value = '';
                                     fetchAdminChatForRefund();
                                     showToast('Đã gửi', true);
                                 } else { showToast(data.message, false); }
                             })
                             .catch(function() { showToast('Lỗi kết nối', false); });
                     };

                     function escHtml(text) {
                         if (!text) return '';
                         var d = document.createElement('div');
                         d.textContent = text;
                         return d.innerHTML;
                     }

                     initRefundChat();
                     setInterval(fetchAdminChatForRefund, 5000);
                 })();
                 </script>

                 </html>