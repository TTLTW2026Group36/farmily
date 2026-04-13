<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/orders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body data-page="orders">
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />

        <main class="admin-main">
            <jsp:include page="header.jsp" />

            <div class="admin-content">
                <div class="orders-page-header">
                    <div>
                        <h1 class="orders-page-title">Danh sách đơn hàng</h1>
                        <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i>
                                            Dashboard</a>
                                        <span>/</span>
                                        <span>Đơn hàng</span>
                                    </div>
                    </div>
                </div>

                <div class="bento-stat-grid">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="bento-card ${empty selectedStatus ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Tất cả đơn</span>
                            <span class="bento-icon-wrapper bento-icon-all"><i class="fas fa-list"></i></span>
                        </div>
                        <div class="bento-card-value">${totalOrders}</div>
                        <div class="bento-card-desc desc-all">Quản lý toàn bộ</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=pending" class="bento-card ${selectedStatus == 'pending' ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Chờ xác nhận</span>
                            <div class="bento-icon-wrapper bento-icon-pending"><i class="fas fa-clock"></i></div>
                        </div>
                        <div class="bento-card-value">${pendingCount}</div>
                        <div class="bento-card-desc desc-pending">Cần xử lý ngay</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=processing" class="bento-card ${selectedStatus == 'processing' ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Đang xử lý</span>
                            <div class="bento-icon-wrapper bento-icon-processing"><i class="fas fa-box-open"></i></div>
                        </div>
                        <div class="bento-card-value">${processingCount}</div>
                        <div class="bento-card-desc desc-processing">Đang đóng gói</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=shipping" class="bento-card ${selectedStatus == 'shipping' ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Đang giao</span>
                            <div class="bento-icon-wrapper bento-icon-shipping"><i class="fas fa-truck"></i></div>
                        </div>
                        <div class="bento-card-value">${shippingCount}</div>
                        <div class="bento-card-desc desc-shipping">Đang vận chuyển</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=completed" class="bento-card ${selectedStatus == 'completed' ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Hoàn thành</span>
                            <div class="bento-icon-wrapper bento-icon-completed"><i class="fas fa-check-circle"></i></div>
                        </div>
                        <div class="bento-card-value">${completedCount}</div>
                        <div class="bento-card-desc desc-completed">Giao thành công</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=cancelled" class="bento-card ${selectedStatus == 'cancelled' ? 'active' : ''}">
                        <div class="bento-card-header">
                            <span class="bento-card-title">Đã hủy</span>
                            <div class="bento-icon-wrapper bento-icon-cancelled"><i class="fas fa-ban"></i></div>
                        </div>
                        <div class="bento-card-value">${cancelledCount}</div>
                        <div class="bento-card-desc desc-cancelled">Đơn hàng bị hủy</div>
                    </a>
                </div>


                <section class="bento-filter-section">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="bento-filter-grid">
                        <c:if test="${not empty selectedStatus}">
                            <input type="hidden" name="status" value="${selectedStatus}">
                        </c:if>
                        <div class="bento-filter-group">
                            <label>Tìm kiếm</label>
                            <div class="search-input-wrapper">
                                <i class="fas fa-search"></i>
                                <input type="text" name="q" class="bento-input" placeholder="Mã đơn, tên khách..." value="${keyword}">
                            </div>
                        </div>
                        <div class="bento-filter-group">
                            <label>Từ ngày</label>
                            <input type="date" name="fromDate" class="bento-input" value="${fromDate}">
                        </div>
                        <div class="bento-filter-group">
                            <label>Đến ngày</label>
                            <input type="date" name="toDate" class="bento-input" value="${toDate}">
                        </div>
                        <div class="bento-filter-actions">
                            <button type="submit" class="btn-bento-primary">Lọc</button>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn-bento-secondary" style="height: 41px;">Đặt lại</a>
                        </div>
                    </form>
                </section>


                <div class="bento-table-card">
                    <div class="table-responsive">
                        <table class="bento-table">
                            <thead>
                                    <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Tổng tiền</th>
                                    <th>Phương thức TT</th>
                                    <th>Trạng thái TT</th>
                                    <th>Trạng thái đơn</th>
                                    <th>Ngày đặt</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <tr>
                                            <td colspan="9">
                                                <div class="bento-empty-state">
                                                    <i class="fas fa-inbox bento-empty-icon"></i>
                                                    <div class="bento-empty-title">Không có đơn hàng nào</div>
                                                    <div class="bento-empty-desc">Thử thay đổi bộ lọc hoặc tìm kiếm khác</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="order" items="${orders}">
                                            <tr>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}" class="bento-td-id">#DH-0${order.id}</a>
                                                </td>
                                                <td class="bento-td-customer">
                                                    <p class="bento-td-customer-name">${order.customerName}</p>
                                                    <p class="bento-td-customer-phone">${order.customerPhone}</p>
                                                </td>
                                                <td class="bento-td-product">
                                                    <c:choose>
                                                        <c:when test="${not empty order.orderDetails}">
                                                            <p class="bento-td-product-name">${order.orderDetails[0].product.name}...</p>
                                                            <p class="bento-td-product-count">${order.orderDetails.size()} mặt hàng</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="bento-td-product-name">—</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="bento-td-price"><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" />₫</div>
                                                </td>
                                                <td>
                                                    <span class="bento-tag">${order.paymentMethodText}</span>
                                                </td>
                                                <td>
                                                    <span class="bento-status-badge ${order.paymentStatusBadgeClass}">${order.paymentStatusText}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'pending'}"><span class="bento-status-badge bento-badge-pending">Chờ xác nhận</span></c:when>
                                                        <c:when test="${order.status == 'confirmed' || order.status == 'processing'}"><span class="bento-status-badge bento-badge-processing">Đang xử lý</span></c:when>
                                                        <c:when test="${order.status == 'shipping'}"><span class="bento-status-badge bento-badge-shipping">Đang giao</span></c:when>
                                                        <c:when test="${order.status == 'completed'}"><span class="bento-status-badge bento-badge-completed">Hoàn thành</span></c:when>
                                                        <c:when test="${order.status == 'cancelled'}"><span class="bento-status-badge bento-badge-cancelled">Đã hủy</span></c:when>
                                                        <c:otherwise><span class="bento-status-badge">${order.status}</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="bento-td-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></div>
                                                    <div class="bento-td-time"><fmt:formatDate value="${order.orderDate}" pattern="HH:mm" /></div>
                                                </td>
                                                <td>
                                                    <div class="bento-actions">
                                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}" class="btn-bento-icon" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${order.status == 'pending'}">
                                                                <button class="btn-bento-icon bento-icon-primary" onclick="confirmNextStep(${order.id}, 'processing', 'Xác nhận đơn hàng #${order.id}?', 'Đơn hàng sẽ được chuyển sang Đang xử lý.')" title="Xác nhận">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                                <button class="btn-bento-icon bento-icon-danger" onclick="confirmNextStep(${order.id}, 'cancelled', 'Hủy đơn hàng #${order.id}?', 'Đơn hàng này sẽ bị hủy bỏ.')" title="Hủy đơn">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                                <button class="btn-bento-icon bento-icon-primary" onclick="confirmNextStep(${order.id}, 'shipping', 'Bàn giao vận chuyển #${order.id}?', 'Đơn hàng sẽ được chuyển sang Đang giao.')" title="Giao hàng">
                                                                    <i class="fas fa-truck"></i>
                                                                </button>
                                                                <button class="btn-bento-icon bento-icon-danger" onclick="confirmNextStep(${order.id}, 'cancelled', 'Hủy đơn hàng #${order.id}?', 'Đơn hàng này sẽ bị hủy bỏ.')" title="Hủy đơn">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${order.status == 'shipping'}">
                                                                <button class="btn-bento-icon bento-icon-primary" onclick="confirmNextStep(${order.id}, 'completed', 'Xác nhận hoàn thành #${order.id}?', 'Khách đã nhận hàng thành công.')" title="Hoàn thành">
                                                                    <i class="fas fa-check-double"></i>
                                                                </button>
                                                            </c:when>
                                                        </c:choose>
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
                                    <a class="bento-page-btn" href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="bento-page-btn active">${i}</span>
                                        </c:when>
                                        <c:when test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                            <a class="bento-page-btn" href="${pageContext.request.contextPath}/admin/orders?page=${i}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">${i}</a>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a class="bento-page-btn" href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">
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

    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <h3 class="modal-title" id="modalTitle">Xác nhận cập nhật?</h3>
            <p style="margin-top:8px;font-size:14px;color:var(--bento-on-surface-variant);" id="modalDesc"></p>
            <div style="display:flex;justify-content:flex-end;gap:8px;margin-top:24px;">
                <button class="btn-bento-secondary" style="height:36px;padding:0 12px;font-size:13px;" onclick="closeModal()">Hủy bỏ</button>
                <button class="btn-bento-primary" style="height:36px;padding:0 12px;font-size:13px;" id="modalConfirmBtn" onclick="doUpdateStatus()">Xác nhận</button>
            </div>
        </div>
    </div>

    <div class="toast-container" id="toastContainer"></div>

    <script>
        var contextPath = '${pageContext.request.contextPath}';
        var pendingOrderId = null;
        var pendingStatus = null;

        function confirmNextStep(orderId, newStatus, title, desc) {
            pendingOrderId = orderId;
            pendingStatus = newStatus;
            document.getElementById('modalTitle').textContent = title;
            document.getElementById('modalDesc').textContent = desc;
            document.getElementById('confirmModal').classList.add('open');
        }

        function closeModal() {
            document.getElementById('confirmModal').classList.remove('open');
            pendingOrderId = null;
            pendingStatus = null;
        }

        function doUpdateStatus() {
            if (!pendingOrderId || !pendingStatus) return;

            var btn = document.getElementById('modalConfirmBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

            fetch(contextPath + '/admin/orders/update-status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'orderId=' + pendingOrderId + '&status=' + encodeURIComponent(pendingStatus)
            })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                closeModal();
                if (data.success) {
                    showToast('Cập nhật trạng thái thành công!', 'success');
                    setTimeout(function () { location.reload(); }, 800);
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                    btn.disabled = false;
                    btn.innerHTML = 'Xác nhận';
                }
            })
            .catch(function (err) {
                closeModal();
                showToast('Có lỗi xảy ra khi kết nối', 'error');
                btn.disabled = false;
                btn.innerHTML = 'Xác nhận';
            });
        }

        document.getElementById('confirmModal').addEventListener('click', function (e) {
            if (e.target === this) closeModal();
        });

        function showToast(message, type) {
            var toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            toast.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + '"></i> ' + message;
            document.getElementById('toastContainer').appendChild(toast);
            setTimeout(function () { toast.classList.add('show'); }, 10);
            setTimeout(function () {
                toast.classList.remove('show');
                setTimeout(function () { toast.remove(); }, 300);
            }, 3000);
        }
    </script>
</body>
</html>