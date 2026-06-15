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
    <title>Quản lý Hoàn tiền - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoanTien.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.5); z-index: 1000;
            align-items: center; justify-content: center;
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #fff; border-radius: 12px; padding: 28px;
            width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.2);
        }
        .modal-title { font-size: 18px; font-weight: 700; margin-bottom: 16px; color: #1a2e1a; }
        .modal-label { font-size: 14px; font-weight: 600; color: #444; margin-bottom: 6px; display: block; }
        .modal-input, .modal-textarea {
            width: 100%; padding: 10px 14px; border: 1px solid #ddd;
            border-radius: 8px; font-size: 14px; font-family: inherit;
            box-sizing: border-box;
        }
        .modal-textarea { resize: vertical; min-height: 80px; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
        .btn-modal-primary {
            padding: 10px 20px; background: #2d6a2d; color: #fff;
            border: none; border-radius: 8px; cursor: pointer; font-size: 14px;
            font-family: inherit; font-weight: 600;
        }
        .btn-modal-danger {
            padding: 10px 20px; background: #dc3545; color: #fff;
            border: none; border-radius: 8px; cursor: pointer; font-size: 14px;
            font-family: inherit; font-weight: 600;
        }
        .btn-modal-secondary {
            padding: 10px 20px; background: #f0f0f0; color: #333;
            border: 1px solid #ddd; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-family: inherit;
        }
        .toast-msg {
            position: fixed; bottom: 24px; right: 24px; z-index: 9999;
            padding: 14px 20px; border-radius: 10px; font-size: 14px;
            font-weight: 500; color: #fff; max-width: 360px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            opacity: 0; transition: opacity 0.3s;
        }
        .toast-msg.show { opacity: 1; }
        .toast-success { background: #16a34a; }
        .toast-error   { background: #dc2626; }
    </style>
</head>
<body data-page="refund-requests">
<div class="admin-layout">
    <jsp:include page="sidebar.jsp"/>
    <main class="admin-main">
        <jsp:include page="header.jsp"/>
        <div class="admin-content">

            <div class="orders-page-header">
                <div>
                    <h1 class="orders-page-title">Quản lý Hoàn tiền</h1>
                    <div class="content-breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                        <span>/</span>
                        <span>Hoàn tiền</span>
                    </div>
                </div>
            </div>

            <%-- Flash messages --%>
            <c:if test="${not empty success}">
                <div class="toast-msg toast-success show" id="flashToast">${fn:escapeXml(success)}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="toast-msg toast-error show" id="flashToast">${fn:escapeXml(error)}</div>
            </c:if>

            <%-- Stat cards --%>
            <div class="bento-stat-grid">
                <a href="${pageContext.request.contextPath}/admin/refund-requests"
                   class="bento-card ${empty selectedStatus ? 'active' : ''}">
                    <div class="bento-card-header">
                        <span class="bento-card-title">Tất cả</span>
                        <span class="bento-icon-wrapper bento-icon-all"><i class="fas fa-list"></i></span>
                    </div>
                    <div class="bento-card-value">${pendingCount + approvedCount + rejectedCount + refundedCount}</div>
                    <div class="bento-card-desc desc-all">Toàn bộ yêu cầu</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/refund-requests?status=pending"
                   class="bento-card ${selectedStatus == 'pending' ? 'active' : ''}">
                    <div class="bento-card-header">
                        <span class="bento-card-title">Chờ xử lý</span>
                        <span class="bento-icon-wrapper bento-icon-pending"><i class="fas fa-clock"></i></span>
                    </div>
                    <div class="bento-card-value">${pendingCount}</div>
                    <div class="bento-card-desc desc-pending">Cần xem xét</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/refund-requests?status=approved"
                   class="bento-card ${selectedStatus == 'approved' ? 'active' : ''}">
                    <div class="bento-card-header">
                        <span class="bento-card-title">Đã duyệt</span>
                        <span class="bento-icon-wrapper bento-icon-completed"><i class="fas fa-check-circle"></i></span>
                    </div>
                    <div class="bento-card-value">${approvedCount}</div>
                    <div class="bento-card-desc desc-completed">Chờ chuyển tiền</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/refund-requests?status=rejected"
                   class="bento-card ${selectedStatus == 'rejected' ? 'active' : ''}">
                    <div class="bento-card-header">
                        <span class="bento-card-title">Từ chối</span>
                        <span class="bento-icon-wrapper bento-icon-cancelled"><i class="fas fa-ban"></i></span>
                    </div>
                    <div class="bento-card-value">${rejectedCount}</div>
                    <div class="bento-card-desc desc-cancelled">Không hợp lệ</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/refund-requests?status=refunded"
                   class="bento-card ${selectedStatus == 'refunded' ? 'active' : ''}">
                    <div class="bento-card-header">
                        <span class="bento-card-title">Đã hoàn tiền</span>
                        <span class="bento-icon-wrapper bento-icon-completed"><i class="fas fa-money-bill-wave"></i></span>
                    </div>
                    <div class="bento-card-value">${refundedCount}</div>
                    <div class="bento-card-desc desc-completed">Hoàn thành</div>
                </a>
            </div>

            <%-- Table --%>
            <div class="bento-table-card">
                <div class="table-responsive">
                    <table class="bento-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Đơn hàng</th>
                                <th>Khách hàng</th>
                                <th>Lý do</th>
                                <th>Số tiền</th>
                                <th>Ngân hàng</th>
                                <th>Trạng thái</th>
                                <th>Ngày gửi</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty requests}">
                                <tr>
                                    <td colspan="9">
                                        <div class="bento-empty-state">
                                            <i class="fas fa-inbox bento-empty-icon"></i>
                                            <div class="bento-empty-title">Không có yêu cầu hoàn tiền nào</div>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${requests}">
                                    <tr>
                                        <td>#${r.id}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${r.orderId}"
                                               target="_blank" style="font-weight:600;color:#16a34a;">
                                                #${r.orderId} <i class="fas fa-external-link-alt" style="font-size:11px;"></i>
                                            </a>
                                        </td>
                                        <td>
                                            <c:if test="${not empty r.user}">
                                                ${fn:escapeXml(r.user.name)}<br>
                                                <small style="color:#888;">${fn:escapeXml(r.user.email)}</small>
                                            </c:if>
                                            <c:if test="${empty r.user}">—</c:if>
                                        </td>
                                        <td style="max-width:160px;white-space:normal;">${fn:escapeXml(r.reason)}</td>
                                        <td style="font-weight:700;color:#2d6a2d;">${r.formattedRefundAmount}</td>
                                        <td>
                                            <small>${fn:escapeXml(r.bankName)}<br>
                                            ${fn:escapeXml(r.bankAccount)}</small>
                                        </td>
                                        <td>
                                            <span class="admin-refund-badge ${r.status}">${r.statusText}</span>
                                        </td>
                                        <td>
                                            <div class="bento-td-date">${r.formattedDate}</div>
                                        </td>
                                        <td>
                                            <div class="bento-actions">
                                                <a href="${pageContext.request.contextPath}/admin/refund-requests/detail?id=${r.id}"
                                                   class="btn-bento-icon bento-icon-primary" title="Chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${r.status == 'pending' && isAdminOrManager}">
                                                    <button type="button"
                                                            class="btn-bento-icon bento-icon-primary"
                                                            title="Duyệt"
                                                            onclick="openApproveModal(${r.id}, ${r.refundAmount})">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <button type="button"
                                                            class="btn-bento-icon bento-icon-danger"
                                                            title="Từ chối"
                                                            onclick="openRejectModal(${r.id})">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${r.status == 'approved' && isAdminOrManager}">
                                                    <button type="button"
                                                            class="btn-bento-icon bento-icon-primary"
                                                            title="Xác nhận đã chuyển tiền"
                                                            onclick="confirmRefunded(${r.id})">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                    </button>
                                                </c:if>
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
                    <div class="bento-table-footer">
                        <div class="bento-pagination">
                            <c:if test="${currentPage > 1}">
                                <a class="bento-page-btn" href="?page=${currentPage - 1}&status=${selectedStatus}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="bento-page-btn ${i == currentPage ? 'active' : ''}"
                                   href="?page=${i}&status=${selectedStatus}">${i}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a class="bento-page-btn" href="?page=${currentPage + 1}&status=${selectedStatus}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<%-- Approve Modal --%>
<div class="modal-overlay" id="approveModal">
    <div class="modal-box">
        <div class="modal-title"><i class="fas fa-check-circle"></i> Duyệt yêu cầu hoàn tiền</div>
        <div style="margin-bottom:14px;">
            <label class="modal-label">Số tiền hoàn (VND)</label>
            <input type="number" id="approveAmount" class="modal-input" min="0" step="1000">
        </div>
        <div style="margin-bottom:6px;">
            <label class="modal-label">Ghi chú (tuỳ chọn)</label>
            <textarea id="approveNote" class="modal-textarea" placeholder="Nhập ghi chú cho khách..."></textarea>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-secondary" onclick="closeModal('approveModal')">Hủy</button>
            <button class="btn-modal-primary" onclick="submitApprove()"><i class="fas fa-check"></i> Xác nhận duyệt</button>
        </div>
    </div>
</div>

<%-- Reject Modal --%>
<div class="modal-overlay" id="rejectModal">
    <div class="modal-box">
        <div class="modal-title"><i class="fas fa-times-circle"></i> Từ chối yêu cầu hoàn tiền</div>
        <div style="margin-bottom:6px;">
            <label class="modal-label">Lý do từ chối <span style="color:#dc3545;">*</span></label>
            <textarea id="rejectNote" class="modal-textarea" placeholder="Nhập lý do từ chối cho khách..."></textarea>
        </div>
        <div class="modal-actions">
            <button class="btn-modal-secondary" onclick="closeModal('rejectModal')">Hủy</button>
            <button class="btn-modal-danger" onclick="submitReject()"><i class="fas fa-times"></i> Từ chối</button>
        </div>
    </div>
</div>

<div class="toast-msg" id="actionToast"></div>

<script>
    var currentRefundId = 0;
    var ctxPath = '${pageContext.request.contextPath}';

    function openApproveModal(refundId, amount) {
        currentRefundId = refundId;
        document.getElementById('approveAmount').value = amount;
        document.getElementById('approveNote').value = '';
        document.getElementById('approveModal').classList.add('active');
    }

    function openRejectModal(refundId) {
        currentRefundId = refundId;
        document.getElementById('rejectNote').value = '';
        document.getElementById('rejectModal').classList.add('active');
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('active');
    }

    function submitApprove() {
        var note   = document.getElementById('approveNote').value;
        var amount = document.getElementById('approveAmount').value;
        postAction(ctxPath + '/admin/refund-requests/approve',
            { refundId: currentRefundId, adminNote: note, refundAmount: amount },
            function(msg) {
                closeModal('approveModal');
                showToast(msg, true);
                setTimeout(function() { location.reload(); }, 1500);
            });
    }

    function submitReject() {
        var note = document.getElementById('rejectNote').value.trim();
        if (!note) { alert('Vui lòng nhập lý do từ chối'); return; }
        postAction(ctxPath + '/admin/refund-requests/reject',
            { refundId: currentRefundId, adminNote: note },
            function(msg) {
                closeModal('rejectModal');
                showToast(msg, true);
                setTimeout(function() { location.reload(); }, 1500);
            });
    }

    function confirmRefunded(refundId) {
        if (!confirm('Xác nhận đã chuyển tiền hoàn thành công?')) return;
        postAction(ctxPath + '/admin/refund-requests/confirm',
            { refundId: refundId },
            function(msg) {
                showToast(msg, true);
                setTimeout(function() { location.reload(); }, 1500);
            });
    }

    function postAction(url, data, onSuccess) {
        var formData = new FormData();
        for (var k in data) formData.append(k, data[k]);
        fetch(url, { method: 'POST', body: formData })
            .then(function(r) { return r.json(); })
            .then(function(json) {
                if (json.success) onSuccess(json.message);
                else showToast(json.message, false);
            })
            .catch(function() { showToast('Lỗi kết nối', false); });
    }

    function showToast(msg, success) {
        var t = document.getElementById('actionToast');
        t.textContent = msg;
        t.className = 'toast-msg show ' + (success ? 'toast-success' : 'toast-error');
        setTimeout(function() { t.classList.remove('show'); }, 3000);
    }

    // Auto-dismiss flash toast
    var flashToast = document.getElementById('flashToast');
    if (flashToast) {
        setTimeout(function() { flashToast.classList.remove('show'); }, 3500);
    }
</script>
</body>
</html>
