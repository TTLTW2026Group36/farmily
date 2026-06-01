<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Liên hệ - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    .contact-modal {
                        display: none;
                        position: fixed;
                        z-index: 1000;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        overflow: auto;
                        background-color: rgba(15, 23, 42, 0.4);
                        backdrop-filter: blur(4px);
                        align-items: center;
                        justify-content: center;
                        opacity: 0;
                        transition: opacity 0.25s ease;
                    }

                    .contact-modal.show {
                        display: flex;
                        opacity: 1;
                    }

                    .contact-modal-content {
                        background-color: #ffffff;
                        border-radius: 16px;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                        width: 90%;
                        max-width: 600px;
                        animation: modalFadeIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
                        border: 1px solid #e2e8f0;
                    }

                    @keyframes modalFadeIn {
                        from {
                            opacity: 0;
                            transform: scale(0.95) translateY(10px);
                        }

                        to {
                            opacity: 1;
                            transform: scale(1) translateY(0);
                        }
                    }

                    .contact-modal-header {
                        padding: 20px 24px;
                        border-bottom: 1px solid #f1f5f9;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .contact-modal-title {
                        font-size: 18px;
                        font-weight: 700;
                        color: #0f172a;
                        margin: 0;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .contact-modal-close {
                        background: none;
                        border: none;
                        font-size: 28px;
                        color: #94a3b8;
                        cursor: pointer;
                        line-height: 1;
                        padding: 0;
                        transition: color 0.2s;
                    }

                    .contact-modal-close:hover {
                        color: #475569;
                    }

                    .contact-modal-body {
                        padding: 24px;
                    }

                    .detail-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 16px;
                    }

                    .detail-row {
                        display: flex;
                        flex-direction: column;
                        gap: 4px;
                    }

                    .detail-label {
                        font-size: 11px;
                        font-weight: 700;
                        color: #64748b;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .detail-val {
                        font-size: 14px;
                        color: #334155;
                        word-break: break-word;
                    }

                    .detail-val a {
                        color: #10b981;
                        text-decoration: none;
                        font-weight: 500;
                    }

                    .detail-val a:hover {
                        text-decoration: underline;
                    }

                    .detail-msg-box {
                        background-color: #f8fafc;
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        padding: 16px;
                        font-size: 14px;
                        line-height: 1.6;
                        color: #334155;
                        white-space: pre-wrap;
                        max-height: 200px;
                        overflow-y: auto;
                    }

                    .contact-modal-footer {
                        padding: 16px 24px;
                        border-top: 1px solid #f1f5f9;
                        display: flex;
                        justify-content: flex-end;
                        gap: 12px;
                        background-color: #f8fafc;
                        border-bottom-left-radius: 16px;
                        border-bottom-right-radius: 16px;
                    }

                    .text-muted {
                        color: #64748b;
                    }
                </style>
            </head>

            <body data-page="contacts">
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">
                            <div class="orders-page-header">
                                <div>
                                    <h1 class="orders-page-title">Quản lý Liên hệ</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Liên hệ</span>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success"
                                    style="background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-error"
                                    style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="bento-table-card">
                                <div class="table-responsive">
                                    <table class="bento-table" id="contactsTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 80px;">ID</th>
                                                <th>Họ và Tên</th>
                                                <th>Email</th>
                                                <th>Số điện thoại</th>
                                                <th>Tiêu đề</th>
                                                <th>Ngày gửi</th>
                                                <th style="width: 120px; text-align: right;">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty contacts}">
                                                    <tr>
                                                        <td colspan="7">
                                                            <div class="bento-empty-state">
                                                                <i class="fas fa-inbox bento-empty-icon"></i>
                                                                <div class="bento-empty-title">Chưa có liên hệ nào</div>
                                                                <div class="bento-empty-desc">Khi khách hàng gửi liên hệ
                                                                    qua trang chủ, thông tin sẽ xuất hiện tại đây.</div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="c" items="${contacts}">
                                                        <tr>
                                                            <td class="bento-td-id">#${c.id}</td>
                                                            <td>
                                                                <div class="bento-td-customer-name">${c.fullname}</div>
                                                                <c:if test="${not empty c.organization}">
                                                                    <small class="text-muted"><i class="fas fa-building"
                                                                            style="font-size: 10px; margin-right: 4px;"></i>${c.organization}</small>
                                                                </c:if>
                                                            </td>
                                                            <td><a href="mailto:${c.email}"
                                                                    style="color: #10b981; font-weight: 500; text-decoration: none;">${c.email}</a>
                                                            </td>
                                                            <td><a href="tel:${c.phone}"
                                                                    style="color: #64748b; text-decoration: none;">${c.phone}</a>
                                                            </td>
                                                            <td><span
                                                                    style="font-weight: 600; color: #334155;">${c.subject}</span>
                                                            </td>
                                                            <td>
                                                                <div class="bento-td-date">
                                                                    <fmt:formatDate value="${c.createdAt}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="bento-actions">
                                                                    <button type="button"
                                                                        class="btn-bento-icon bento-icon-primary"
                                                                        title="Xem chi tiết"
                                                                        onclick="viewContactDetails(${c.id})">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/admin/contacts/delete"
                                                                        method="post" class="action-form"
                                                                        style="display:inline-block; margin:0;"
                                                                        onsubmit="return confirm('Bạn có chắc chắn muốn xóa liên hệ này?');">
                                                                        <input type="hidden" name="id" value="${c.id}">
                                                                        <button type="submit"
                                                                            class="btn-bento-icon bento-icon-danger"
                                                                            title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </form>
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
                                        <div class="bento-footer-text">Hiển thị trang ${currentPage} / ${totalPages}
                                        </div>
                                        <div class="bento-pagination">
                                            <c:if test="${currentPage > 1}">
                                                <a class="bento-page-btn"
                                                    href="?page=${currentPage - 1}&size=${pageSize}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:if>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <a class="bento-page-btn ${i == currentPage ? 'active' : ''}"
                                                    href="?page=${i}&size=${pageSize}">${i}</a>
                                            </c:forEach>
                                            <c:if test="${currentPage < totalPages}">
                                                <a class="bento-page-btn"
                                                    href="?page=${currentPage + 1}&size=${pageSize}">
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

                <div id="contactModal" class="contact-modal" onclick="event.target === this && closeModal()">
                    <div class="contact-modal-content">
                        <div class="contact-modal-header">
                            <h3 class="contact-modal-title"><i class="fas fa-envelope-open-text"
                                    style="color: #10b981;"></i> Chi tiết liên hệ</h3>
                            <button class="contact-modal-close" onclick="closeModal()">&times;</button>
                        </div>
                        <div class="contact-modal-body">
                            <div class="detail-grid">
                                <div class="detail-row">
                                    <span class="detail-label">Họ và tên</span>
                                    <span class="detail-val" id="modalFullname"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Đơn vị / Tổ chức</span>
                                    <span class="detail-val" id="modalOrg"></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Email</span>
                                    <span class="detail-val"><a id="modalEmail" href=""></a></span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Số điện thoại</span>
                                    <span class="detail-val"><a id="modalPhone" href=""></a></span>
                                </div>
                                <div class="detail-row" style="grid-column: span 2;">
                                    <span class="detail-label">Ngày gửi</span>
                                    <span class="detail-val" id="modalDate"></span>
                                </div>
                                <div class="detail-row" style="grid-column: span 2;">
                                    <span class="detail-label">Tiêu đề</span>
                                    <span class="detail-val" id="modalSubject"
                                        style="font-weight: 600; color: #1e293b;"></span>
                                </div>
                                <div class="detail-row"
                                    style="grid-column: span 2; border-top: 1px dashed #e2e8f0; padding-top: 16px; margin-top: 8px;">
                                    <span class="detail-label">Nội dung tin nhắn</span>
                                    <div class="detail-msg-box" id="modalMessage"></div>
                                </div>
                            </div>
                        </div>
                        <div class="contact-modal-footer">
                            <a id="replyEmailBtn" href="" class="btn-bento-primary"
                                style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fas fa-reply"></i> Phản hồi qua Email
                            </a>
                            <button class="btn-bento-secondary" onclick="closeModal()">Đóng</button>
                        </div>
                    </div>
                </div>

                <script>
                    function viewContactDetails(id) {
                        const contextPath = '${pageContext.request.contextPath}';
                        fetch(contextPath + '/admin/contacts/view-api?id=' + id)
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Lỗi khi tải chi tiết liên hệ');
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data.success && data.contact) {
                                    const c = data.contact;
                                    document.getElementById('modalFullname').textContent = c.fullname || '-';
                                    document.getElementById('modalOrg').textContent = c.organization || 'Không có';

                                    const emailEl = document.getElementById('modalEmail');
                                    emailEl.textContent = c.email;
                                    emailEl.href = 'mailto:' + c.email;

                                    const phoneEl = document.getElementById('modalPhone');
                                    phoneEl.textContent = c.phone;
                                    phoneEl.href = 'tel:' + c.phone;

                                    let dateStr = c.createdAt;
                                    try {
                                        const date = new Date(c.createdAt);
                                        if (!isNaN(date.getTime())) {
                                            const pad = (n) => n.toString().padStart(2, '0');
                                            dateStr = pad(date.getDate()) + '/' + pad(date.getMonth() + 1) + '/' + date.getFullYear() + ' ' + pad(date.getHours()) + ':' + pad(date.getMinutes());
                                        }
                                    } catch (e) { }

                                    document.getElementById('modalDate').textContent = dateStr;
                                    document.getElementById('modalSubject').textContent = c.subject;
                                    document.getElementById('modalMessage').textContent = c.message;

                                    const replyBtn = document.getElementById('replyEmailBtn');
                                    replyBtn.href = 'mailto:' + c.email + '?subject=Re: ' + encodeURIComponent(c.subject);

                                    const modal = document.getElementById('contactModal');
                                    modal.style.display = 'flex';
                                    setTimeout(() => modal.classList.add('show'), 10);
                                } else {
                                    alert(data.message || 'Không tìm thấy dữ liệu liên hệ.');
                                }
                            })
                            .catch(error => {
                                console.error(error);
                                alert('Đã xảy ra lỗi khi tải dữ liệu liên hệ.');
                            });
                    }

                    function closeModal() {
                        const modal = document.getElementById('contactModal');
                        modal.classList.remove('show');
                        setTimeout(() => modal.style.display = 'none', 250);
                    }

                    document.addEventListener('keydown', function (event) {
                        if (event.key === 'Escape') {
                            closeModal();
                        }
                    });
                </script>
            </body>

            </html>