<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết Đơn hàng #${order.id} - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/order-detail.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script>window.contextPath = '${pageContext.request.contextPath}';</script>
            </head>

            <body>
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">

                            <div class="content-header">
                                <div>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a>
                                        <span>/</span>
                                        <span>#${order.id}</span>
                                    </div>
                                    <div class="detail-title-row">
                                        <h1 class="content-title">Đơn hàng #${order.id}</h1>
                                        <!-- Status Badge -->
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <span class="status-badge status-pending">Chờ xác nhận</span>
                                            </c:when>
                                            <c:when
                                                test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                <span class="status-badge status-processing">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${order.status == 'shipping'}">
                                                <span class="status-badge status-shipping">Đang giao</span>
                                            </c:when>
                                            <c:when test="${order.status == 'completed'}">
                                                <span class="status-badge status-completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${order.status == 'cancelled'}">
                                                <span class="status-badge status-cancelled">Đã hủy</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                    <button class="btn btn-secondary" onclick="window.print()">
                                        <i class="fas fa-print"></i> In đơn
                                    </button>
                                </div>
                            </div>

                            <!-- Next-step action bar -->
                            <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                                <div class="action-bar">
                                    <div class="action-bar-left">
                                        <i class="fas fa-info-circle" style="color:#3b82f6;"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${order.status == 'pending'}">Đơn vừa đặt — Gọi xác nhận
                                                    với khách rồi bấm xác nhận bên dưới.</c:when>
                                                <c:when
                                                    test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                    Đơn đang được đóng gói — Bấm "Giao hàng" khi đã bàn giao cho vận
                                                    chuyển.</c:when>
                                                <c:when test="${order.status == 'shipping'}">Đơn đang trên đường giao —
                                                    Bấm "Hoàn thành" khi khách đã nhận hàng.</c:when>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="action-bar-right">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <button class="btn btn-primary"
                                                    onclick="openStatusModal('processing', 'Xác nhận đơn hàng?', 'Đơn hàng sẽ chuyển sang trạng thái Đang xử lý (đóng gói).')">
                                                    <i class="fas fa-check"></i> Xác nhận đơn
                                                </button>
                                            </c:when>
                                            <c:when
                                                test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                <button class="btn btn-shipping"
                                                    onclick="openStatusModal('shipping', 'Bàn giao vận chuyển?', 'Đơn hàng sẽ chuyển sang trạng thái Đang giao hàng.')">
                                                    <i class="fas fa-truck"></i> Giao hàng
                                                </button>
                                            </c:when>
                                            <c:when test="${order.status == 'shipping'}">
                                                <button class="btn btn-complete"
                                                    onclick="openStatusModal('completed', 'Xác nhận hoàn thành?', 'Đơn hàng sẽ được đánh dấu là đã giao thành công.')">
                                                    <i class="fas fa-check-double"></i> Đã nhận hàng
                                                </button>
                                            </c:when>
                                        </c:choose>
                                        <button class="btn btn-cancel-order"
                                            onclick="openStatusModal('cancelled', 'Hủy đơn hàng này?', 'Thao tác này không thể hoàn tác. Đơn hàng sẽ bị hủy.')">
                                            <i class="fas fa-ban"></i> Hủy đơn
                                        </button>
                                    </div>
                                </div>
                            </c:if>

                            <div class="detail-grid">

                                <div class="detail-main">
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-history"
                                                    style="color:var(--primary);margin-right:6px;"></i> Lịch sử xử lý
                                            </h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="order-timeline">

                                                <div class="timeline-step done">
                                                    <div class="timeline-dot"><i class="fas fa-check"></i></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đơn hàng được đặt</div>
                                                        <div class="timeline-desc">Khách hàng xác nhận đơn và hệ thống
                                                            ghi nhận</div>
                                                        <div class="timeline-time">
                                                            <fmt:formatDate value="${order.orderDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                    </div>
                                                </div>

                                                <c:set var="step2done"
                                                    value="${order.status == 'confirmed' || order.status == 'processing' || order.status == 'shipping' || order.status == 'completed'}" />
                                                <div
                                                    class="timeline-step ${step2done ? 'done' : (order.status == 'cancelled' ? 'skipped' : 'pending')}">
                                                    <div class="timeline-dot"><i
                                                            class="fas fa-${step2done ? 'check' : 'clock'}"></i></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Nhân viên xác nhận đơn</div>
                                                        <div class="timeline-desc">Gọi điện xác nhận với khách hàng
                                                        </div>
                                                        <c:if test="${!step2done}">
                                                            <div class="timeline-time pending-label">Chưa thực hiện
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <c:set var="step3done"
                                                    value="${order.status == 'processing' || order.status == 'shipping' || order.status == 'completed'}" />
                                                <div
                                                    class="timeline-step ${step3done ? 'done' : (order.status == 'cancelled' ? 'skipped' : 'pending')}">
                                                    <div class="timeline-dot"><i
                                                            class="fas fa-${step3done ? 'check' : 'box'}"></i></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Đóng gói sản phẩm</div>
                                                        <div class="timeline-desc">Kiểm tra và đóng gói đơn hàng để giao
                                                        </div>
                                                        <c:if test="${!step3done}">
                                                            <div class="timeline-time pending-label">Chưa thực hiện
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <c:set var="step4done"
                                                    value="${order.status == 'shipping' || order.status == 'completed'}" />
                                                <div
                                                    class="timeline-step ${step4done ? 'done' : (order.status == 'cancelled' ? 'skipped' : 'pending')}">
                                                    <div class="timeline-dot"><i
                                                            class="fas fa-${step4done ? 'check' : 'truck'}"></i></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-title">Bàn giao vận chuyển</div>
                                                        <div class="timeline-desc">Đã bàn giao cho đơn vị giao hàng
                                                        </div>
                                                        <c:if test="${!step4done}">
                                                            <div class="timeline-time pending-label">Chưa thực hiện
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <c:choose>
                                                    <c:when test="${order.status == 'completed'}">
                                                        <div class="timeline-step done final">
                                                            <div class="timeline-dot"><i
                                                                    class="fas fa-check-double"></i></div>
                                                            <div class="timeline-content">
                                                                <div class="timeline-title">Giao hàng thành công ✅</div>
                                                                <div class="timeline-desc">Khách hàng đã nhận được hàng
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${order.status == 'cancelled'}">
                                                        <div class="timeline-step cancelled final">
                                                            <div class="timeline-dot"><i class="fas fa-ban"></i></div>
                                                            <div class="timeline-content">
                                                                <div class="timeline-title">Đơn hàng đã bị hủy ❌</div>
                                                                <div class="timeline-desc">Đơn hàng không được tiếp tục
                                                                    xử lý</div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="timeline-step pending final">
                                                            <div class="timeline-dot"><i
                                                                    class="fas fa-flag-checkered"></i></div>
                                                            <div class="timeline-content">
                                                                <div class="timeline-title">Hoàn thành</div>
                                                                <div class="timeline-desc">Khách hàng xác nhận đã nhận
                                                                    được hàng</div>
                                                                <div class="timeline-time pending-label">Chưa hoàn thành
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-shopping-basket"
                                                    style="color:var(--primary);margin-right:6px;"></i> Sản phẩm
                                                (${order.orderDetails.size()})</h3>
                                        </div>
                                        <div class="card-body" style="padding:0;">
                                            <table class="admin-table">
                                                <thead>
                                                    <tr>
                                                        <th>Sản phẩm</th>
                                                        <th style="width:150px;">Phân loại</th>
                                                        <th style="width:100px;">Đơn giá</th>
                                                        <th style="width:70px;">SL</th>
                                                        <th style="width:110px;">Thành tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="item" items="${order.orderDetails}">
                                                        <tr>
                                                            <td>
                                                                <div class="product-cell">
                                                                    <img src="${item.imageUrl.startsWith('http') ? item.imageUrl : pageContext.request.contextPath.concat(item.imageUrl)}"
                                                                        alt="${item.productName}" class="product-img"
                                                                        onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                                                                    <div>
                                                                        <div class="product-name">${item.productName}</div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty item.variantText}">
                                                                        <span class="variant-badge">${item.variantText}</span>
                                                                    </c:when>
                                                                    <c:otherwise><span class="empty-val">—</span></c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><span class="price-value">${item.formattedUnitPrice}</span></td>
                                                            <td><span class="qty-badge">x${item.quantity}</span></td>
                                                            <td><strong class="price-total">${item.formattedSubtotal}</strong></td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty order.orderDetails}">
                                                        <tr>
                                                            <td colspan="5"
                                                                style="text-align:center;color:#94a3b8;padding:24px;">
                                                                Không có sản phẩm nào</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="order-total-footer">
                                            <div class="total-row">
                                                <span>Tạm tính</span>
                                                <span>${order.formattedSubtotal}</span>
                                            </div>
                                            <div class="total-row">
                                                <span>Phí vận chuyển</span>
                                                <span>${order.formattedShippingFee}</span>
                                            </div>
                                            <div class="total-row total-final">
                                                <strong>Tổng cộng</strong>
                                                <strong class="price-grand">${order.formattedTotalPrice}</strong>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- <div class="card shipping-block">
                                        <div class="card-header">
                                            <h3 class="card-title">
                                                <i class="fas fa-truck" style="color:#7c3aed;margin-right:6px;"></i>
                                                Thông tin vận chuyển
                                            </h3>
                                            <span class="placeholder-badge"><i class="fas fa-code-branch"></i> Sẵn sàng
                                                tích hợp API</span>
                                        </div>
                                        <div class="card-body">
                                            <div class="shipping-manual">
                                                <div class="shipping-field">
                                                    <label class="field-label">Đơn vị vận chuyển</label>
                                                    <select class="form-control" id="shippingCarrier"
                                                        style="max-width:280px;">
                                                        <option value="">— Chọn đơn vị —</option>
                                                        <option value="ghn">GHN (Giao Hàng Nhanh)</option>
                                                        <option value="ghtk">GHTK (Giao Hàng Tiết Kiệm)</option>
                                                        <option value="viettel">Viettel Post</option>
                                                        <option value="vnpost">Vietnam Post</option>
                                                        <option value="other">Khác</option>
                                                    </select>
                                                </div>
                                                <div class="shipping-field">
                                                    <label class="field-label">Mã vận đơn</label>
                                                    <div
                                                        style="display:flex;gap:8px;align-items:center;max-width:400px;">
                                                        <input type="text" class="form-control" id="trackingCode"
                                                            placeholder="Nhập mã vận đơn thủ công..." style="flex:1;">
                                                        <button class="btn btn-secondary btn-sm"
                                                            onclick="saveTracking()"><i class="fas fa-save"></i>
                                                            Lưu</button>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="api-notice">
                                                <i class="fas fa-plug"></i>
                                                <span>Tích hợp API GHN/GHTK để tạo vận đơn và theo dõi tự động sẽ được
                                                    thêm vào đây trong phiên bản tiếp theo.</span>
                                            </div>
                                        </div>
                                    </div> -->

                                    
                                </div>

                                <div class="detail-sidebar">

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-user"
                                                    style="color:var(--primary);margin-right:6px;"></i> Khách hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-row">
                                                <span class="info-label">Họ tên</span>
                                                <strong class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty order.customerName}">
                                                            ${order.customerName}</c:when>
                                                        <c:otherwise><span class="empty-val">—</span></c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Số điện thoại</span>
                                                <c:choose>
                                                    <c:when test="${not empty order.customerPhone}">
                                                        <a href="tel:${order.customerPhone}" class="phone-link">
                                                            <i class="fas fa-phone-alt"></i> ${order.customerPhone}
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise><span class="empty-val">—</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Email</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty order.customerEmail}">
                                                            ${order.customerEmail}</c:when>
                                                        <c:otherwise><span class="empty-val">—</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Loại</span>
                                                <span
                                                    class="customer-type-badge ${order.guestOrder ? 'guest' : 'member'}">
                                                    ${order.guestOrder ? 'Khách vãng lai' : 'Thành viên'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-map-marker-alt"
                                                    style="color:#ef4444;margin-right:6px;"></i> Địa chỉ giao hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${order.address != null}">
                                                    <div class="address-block">
                                                        <div class="address-name">${order.address.receiver}</div>
                                                        <div class="address-phone">${order.address.phone}</div>
                                                        <div class="address-detail">
                                                            ${order.address.addressDetail}<c:if
                                                                test="${not empty order.address.district}">,
                                                                ${order.address.district}</c:if>
                                                            <c:if test="${not empty order.address.city}">,
                                                                ${order.address.city}</c:if>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-val">Không có thông tin địa chỉ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-credit-card"
                                                    style="color:#f59e0b;margin-right:6px;"></i> Thanh toán</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-row">
                                                <span class="info-label">Phương thức</span>
                                                <strong class="info-value">${order.paymentMethodText}</strong>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Trạng thái TT</span>
                                                <span class="pay-badge ${order.paymentStatusBadgeClass}">${order.paymentStatusText}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngày đặt</span>
                                                <span class="info-value">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <c:if test="${order.latestPayment != null}">
                                                <c:if test="${not empty order.latestPayment.provider}">
                                                    <div class="info-row">
                                                        <span class="info-label">Nhà cung cấp</span>
                                                        <span class="info-value">${order.latestPayment.provider}</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty order.latestPayment.transactionId}">
                                                    <div class="info-row">
                                                        <span class="info-label">Mã giao dịch</span>
                                                        <span class="info-value payment-txn">${order.latestPayment.transactionId}</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${order.latestPayment.paidAt != null}">
                                                    <div class="info-row">
                                                        <span class="info-label">Thanh toán lúc</span>
                                                        <span class="info-value">
                                                            <fmt:formatDate value="${order.latestPayment.paidAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Note -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-sticky-note"
                                                    style="color:#64748b;margin-right:6px;"></i> Ghi chú</h3>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty order.note}">
                                                    <p class="note-text">${order.note}</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="empty-val" style="font-style:italic;">Không có ghi chú</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <div class="modal-overlay" id="statusModal">
                    <div class="modal-box">
                        <div class="modal-icon" id="modalIconEl"><i class="fas fa-sync-alt"></i></div>
                        <h3 class="modal-title" id="modalTitleEl">Xác nhận?</h3>
                        <p class="modal-desc" id="modalDescEl"></p>
                        <div class="modal-actions">
                            <button class="btn btn-outline" onclick="closeModal()">Hủy bỏ</button>
                            <button class="btn btn-primary" id="modalConfirmBtn" onclick="doUpdateStatus()">Xác
                                nhận</button>
                        </div>
                    </div>
                </div>

                <div class="toast-container" id="toastContainer"></div>

                <script>
                    var pendingStatus = null;
                    var orderId = ${ order.id };

                    function openStatusModal(newStatus, title, desc) {
                        pendingStatus = newStatus;
                        document.getElementById('modalTitleEl').textContent = title;
                        document.getElementById('modalDescEl').textContent = desc;
                        var icon = document.getElementById('modalIconEl');
                        if (newStatus === 'cancelled') {
                            icon.innerHTML = '<i class="fas fa-exclamation-triangle" style="color:#ef4444;"></i>';
                            document.getElementById('modalConfirmBtn').className = 'btn btn-danger-solid';
                        } else {
                            icon.innerHTML = '<i class="fas fa-sync-alt" style="color:var(--primary);"></i>';
                            document.getElementById('modalConfirmBtn').className = 'btn btn-primary';
                        }
                        document.getElementById('statusModal').classList.add('open');
                    }

                    function closeModal() {
                        document.getElementById('statusModal').classList.remove('open');
                        pendingStatus = null;
                    }

                    function doUpdateStatus() {
                        if (!pendingStatus) return;
                        var btn = document.getElementById('modalConfirmBtn');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

                        fetch(window.contextPath + '/admin/orders/update-status', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'orderId=' + orderId + '&status=' + encodeURIComponent(pendingStatus)
                        })
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                closeModal();
                                if (data.success) {
                                    showToast('Cập nhật trạng thái thành công!', 'success');
                                    setTimeout(function () { location.reload(); }, 900);
                                } else {
                                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                                    btn.disabled = false;
                                    btn.innerHTML = 'Xác nhận';
                                }
                            })
                            .catch(function () {
                                closeModal();
                                showToast('Lỗi kết nối. Thử lại sau.', 'error');
                            });
                    }

                    document.getElementById('statusModal').addEventListener('click', function (e) {
                        if (e.target === this) closeModal();
                    });

                    function saveTracking() {
                        var code = document.getElementById('trackingCode').value.trim();
                        if (!code) { showToast('Vui lòng nhập mã vận đơn', 'error'); return; }
                        showToast('Đã lưu mã vận đơn: ' + code, 'success');
                    }

                    function showToast(msg, type) {
                        var t = document.createElement('div');
                        t.className = 'toast toast-' + type;
                        t.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + '"></i> ' + msg;
                        document.getElementById('toastContainer').appendChild(t);
                        setTimeout(function () { t.classList.add('show'); }, 10);
                        setTimeout(function () { t.classList.remove('show'); setTimeout(function () { t.remove(); }, 300); }, 3500);
                    }
                </script>
            </body>

            </html>