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

                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Quản lý Đơn hàng</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <span>Đơn hàng</span>
                                    </div>
                                </div>
                            </div>


                            <div class="orders-stat-grid">
                                <a href="${pageContext.request.contextPath}/admin/orders"
                                    class="stat-card-link ${empty selectedStatus ? 'active' : ''}">
                                    <div class="stat-card-icon all"><i class="fas fa-list-ul"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${totalOrders}</div>
                                        <div class="stat-card-label">Tất cả đơn</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders?status=pending"
                                    class="stat-card-link ${selectedStatus == 'pending' ? 'active' : ''}">
                                    <div class="stat-card-icon pending"><i class="fas fa-clock"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${pendingCount}</div>
                                        <div class="stat-card-label">Chờ xác nhận</div>
                                    </div>

                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders?status=processing"
                                    class="stat-card-link ${selectedStatus == 'processing' ? 'active' : ''}">
                                    <div class="stat-card-icon processing"><i class="fas fa-box-open"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${processingCount}</div>
                                        <div class="stat-card-label">Đang xử lý</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders?status=shipping"
                                    class="stat-card-link ${selectedStatus == 'shipping' ? 'active' : ''}">
                                    <div class="stat-card-icon shipping"><i class="fas fa-truck"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${shippingCount}</div>
                                        <div class="stat-card-label">Đang giao</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders?status=completed"
                                    class="stat-card-link ${selectedStatus == 'completed' ? 'active' : ''}">
                                    <div class="stat-card-icon completed"><i class="fas fa-check-circle"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${completedCount}</div>
                                        <div class="stat-card-label">Hoàn thành</div>
                                    </div>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders?status=cancelled"
                                    class="stat-card-link ${selectedStatus == 'cancelled' ? 'active' : ''}">
                                    <div class="stat-card-icon cancelled"><i class="fas fa-ban"></i></div>
                                    <div class="stat-card-body">
                                        <div class="stat-card-number">${cancelledCount}</div>
                                        <div class="stat-card-label">Đã hủy</div>
                                    </div>
                                </a>
                            </div>

                            <form action="${pageContext.request.contextPath}/admin/orders" method="get"
                                class="filters-bar-new">
                                <c:if test="${not empty selectedStatus}">
                                    <input type="hidden" name="status" value="${selectedStatus}">
                                </c:if>
                                <!-- <div class="search-group">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="text" name="q" class="search-input"
                                        placeholder="Tìm tên, SĐT, mã đơn hàng..." value="${keyword}">
                                </div> -->
                                <div class="date-group">
                                    <label class="date-label">Từ ngày</label>
                                    <input type="date" name="fromDate" class="date-input" value="${fromDate}">
                                </div>
                                <div class="date-group">
                                    <label class="date-label">Đến ngày</label>
                                    <input type="date" name="toDate" class="date-input" value="${toDate}">
                                </div>
                                <button type="submit" class="btn btn-secondary btn-filter">
                                    <i class="fas fa-filter"></i> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/orders"
                                    class="btn btn-outline btn-filter">
                                    <i class="fas fa-times"></i> Xoá
                                </a>
                            </form>

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">
                                        <c:choose>
                                            <c:when test="${not empty selectedStatus}">
                                                Đơn hàng — <span class="filter-label-inline">${selectedStatus ==
                                                    'pending' ? 'Chờ xác nhận' : selectedStatus == 'processing' ? 'Đang
                                                    xử lý' : selectedStatus == 'shipping' ? 'Đang giao' : selectedStatus
                                                    == 'completed' ? 'Hoàn thành' : selectedStatus == 'cancelled' ? 'Đã
                                                    hủy' : ''}</span>
                                                (${totalOrders})
                                            </c:when>
                                            <c:otherwise>Danh sách đơn hàng (${totalOrders})</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/admin/orders?status=cancelled"
                                        class="btn btn-sm btn-outline">
                                        <i class="fas fa-ban"></i> Xem đơn hủy
                                    </a>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <div class="table-wrapper">
                                        <table class="admin-table" id="ordersTable">
                                            <thead>
                                                <tr>
                                                    <th style="width:110px;">Mã đơn</th>
                                                    <th style="width:180px;">Khách hàng</th>
                                                    <th style="width:120px;">Sản phẩm</th>
                                                    <th style="width:120px;">Tổng tiền</th>
                                                    <th style="width:110px;">Thanh toán</th>
                                                    <th style="width:140px;">Trạng thái</th>
                                                    <th style="width:110px;">Ngày đặt</th>
                                                    <th style="width:250px;">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty orders}">
                                                        <tr>
                                                            <td colspan="8" class="empty-state">
                                                                <i class="fas fa-inbox empty-icon"></i>
                                                                <div>Không có đơn hàng nào</div>
                                                                <small style="color:#94a3b8;">Thử thay đổi bộ lọc hoặc
                                                                    tìm kiếm khác</small>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="order" items="${orders}">
                                                            <tr class="order-row" data-order-id="${order.id}">
                                                                <!-- Mã đơn -->
                                                                <td>
                                                                    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}"
                                                                        class="order-id-link">#${order.id}</a>
                                                                </td>

                                                                <!-- Khách hàng -->
                                                                <td>
                                                                    <div class="customer-name">${order.customerName}
                                                                    </div>
                                                                    <div class="customer-phone">
                                                                        <i class="fas fa-phone-alt"
                                                                            style="font-size:10px;"></i>
                                                                        ${order.customerPhone}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty order.orderDetails}">

                                                                            <div class="product-count">
                                                                                ${order.orderDetails.size()} sản phẩm
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span style="color:#94a3b8;">—</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <strong class="price-value">
                                                                        <fmt:formatNumber value="${order.totalPrice}"
                                                                            type="number" groupingUsed="true" />đ
                                                                    </strong>
                                                                </td>

                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${order.paymentMethod != null}">
                                                                            <span
                                                                                class="badge-payment">${order.paymentMethod.name}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge-payment">COD</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${order.status == 'pending'}">
                                                                            <span class="status-badge status-pending">
                                                                                Chờ xác nhận</span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                                            <span
                                                                                class="status-badge status-processing">
                                                                                Đang xử lý</span>
                                                                        </c:when>
                                                                        <c:when test="${order.status == 'shipping'}">
                                                                            <span class="status-badge status-shipping">
                                                                                Đang giao</span>
                                                                        </c:when>
                                                                        <c:when test="${order.status == 'completed'}">
                                                                            <span class="status-badge status-completed">
                                                                                Hoàn thành</span>
                                                                        </c:when>
                                                                        <c:when test="${order.status == 'cancelled'}">
                                                                            <span class="status-badge status-cancelled">
                                                                                Đã hủy</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="status-badge">${order.status}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="date-cell">
                                                                    <fmt:formatDate value="${order.orderDate}"
                                                                        pattern="dd/MM/yyyy" />
                                                                    <div class="date-time">
                                                                        <fmt:formatDate value="${order.orderDate}"
                                                                            pattern="HH:mm" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="action-group">
                                                                        <!-- Nút bước tiếp theo -->
                                                                        <c:choose>
                                                                            <c:when test="${order.status == 'pending'}">
                                                                                <button class="btn-next-step"
                                                                                    onclick="confirmNextStep(${order.id}, 'processing', 'Xác nhận đơn hàng #${order.id}?', 'Đơn hàng sẽ được chuyển sang trạng thái Đang xử lý.')">
                                                                                    <i class="fas fa-check"></i> Xác
                                                                                    nhận
                                                                                </button>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                                                <button class="btn-next-step"
                                                                                    onclick="confirmNextStep(${order.id}, 'shipping', 'Bàn giao vận chuyển #${order.id}?', 'Đơn hàng sẽ được chuyển sang Đang giao.')">
                                                                                    <i class="fas fa-truck"></i> Giao
                                                                                    hàng
                                                                                </button>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'shipping'}">
                                                                                <button
                                                                                    class="btn-next-step btn-complete"
                                                                                    onclick="confirmNextStep(${order.id}, 'completed', 'Xác nhận hoàn thành #${order.id}?', 'Khách đã nhận hàng thành công.')">
                                                                                    <i class="fas fa-check-double"></i>
                                                                                    Hoàn thành
                                                                                </button>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'completed'}">
                                                                                <span class="done-label"><i
                                                                                        class="fas fa-check-circle"></i>
                                                                                    Đã xong</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'cancelled'}">
                                                                                <span class="cancelled-label"><i
                                                                                        class="fas fa-ban"></i> Đã
                                                                                    hủy</span>
                                                                            </c:when>
                                                                        </c:choose>

                                                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}"
                                                                            class="btn-icon-detail"
                                                                            title="Xem chi tiết">
                                                                            <i class="fas fa-eye"></i>
                                                                        </a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer">
                                        <div class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <a
                                                    href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${currentPage == 1}">
                                                <a href="#" class="disabled"><i class="fas fa-chevron-left"></i></a>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="active">${i}</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i <= 3 || i > totalPages - 2 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                        <a
                                                            href="${pageContext.request.contextPath}/admin/orders?page=${i}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">${i}</a>
                                                    </c:when>
                                                    <c:when test="${i == 4 && currentPage > 5}">
                                                        <span>...</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i == totalPages - 2 && currentPage < totalPages - 4}">
                                                        <span>...</span>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <a
                                                    href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}${not empty keyword ? '&q='.concat(keyword) : ''}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${currentPage == totalPages}">
                                                <a href="#" class="disabled"><i class="fas fa-chevron-right"></i></a>
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
                        <div class="modal-icon"><i class="fas fa-sync-alt"></i></div>
                        <h3 class="modal-title" id="modalTitle">Xác nhận cập nhật?</h3>
                        <p class="modal-desc" id="modalDesc"></p>
                        <div class="modal-actions">
                            <button class="btn btn-outline" onclick="closeModal()">Hủy bỏ</button>
                            <button class="btn btn-primary" id="modalConfirmBtn" onclick="doUpdateStatus()">Xác
                                nhận</button>
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

                <style>
                    @keyframes slideIn {
                        from {
                            opacity: 0;
                            transform: translateX(40px);
                        }

                        to {
                            opacity: 1;
                            transform: translateX(0);
                        }
                    }
                </style>
            </body>

            </html>