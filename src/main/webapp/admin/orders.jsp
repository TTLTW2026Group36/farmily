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

            <body>
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


                            <div class="stats-grid" style="grid-template-columns: repeat(5, 1fr); margin-bottom: 20px;">
                                <div class="stat-card" style="padding: 20px;">
                                    <div style="text-align: center;">
                                        <div style="color: #64748b; font-size: 13px; margin-bottom: 8px;">Tất cả</div>
                                        <div style="font-size: 24px; font-weight: 700;">${totalOrders}</div>
                                    </div>
                                </div>
                                <div class="stat-card warning" style="padding: 20px;">
                                    <div style="text-align: center;">
                                        <div style="color: #92400e; font-size: 13px; margin-bottom: 8px;">Chờ xác nhận
                                        </div>
                                        <div style="font-size: 24px; font-weight: 700;">${pendingCount}</div>
                                    </div>
                                </div>
                                <div class="stat-card info" style="padding: 20px;">
                                    <div style="text-align: center;">
                                        <div style="color: #1e40af; font-size: 13px; margin-bottom: 8px;">Đang giao
                                        </div>
                                        <div style="font-size: 24px; font-weight: 700;">${shippingCount}</div>
                                    </div>
                                </div>
                                <div class="stat-card primary" style="padding: 20px;">
                                    <div style="text-align: center;">
                                        <div style="color: #166534; font-size: 13px; margin-bottom: 8px;">Hoàn thành
                                        </div>
                                        <div style="font-size: 24px; font-weight: 700;">${completedCount}</div>
                                    </div>
                                </div>
                                <div class="stat-card danger" style="padding: 20px;">
                                    <div style="text-align: center;">
                                        <div style="color: #991b1b; font-size: 13px; margin-bottom: 8px;">Đã hủy</div>
                                        <div style="font-size: 24px; font-weight: 700;">${cancelledCount}</div>
                                    </div>
                                </div>
                            </div>


                            <form action="${pageContext.request.contextPath}/admin/orders" method="get"
                                class="filters-bar">
                                <div class="filter-group">
                                    <label>Trạng thái</label>
                                    <select class="form-control" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="pending" ${selectedStatus=='pending' ? 'selected' : '' }>Chờ xác
                                            nhận</option>
                                        <option value="confirmed" ${selectedStatus=='confirmed' ? 'selected' : '' }>Đã
                                            xác nhận</option>
                                        <option value="processing" ${selectedStatus=='processing' ? 'selected' : '' }>
                                            Đang xử lý</option>
                                        <option value="shipping" ${selectedStatus=='shipping' ? 'selected' : '' }>Đang
                                            giao</option>
                                        <option value="delivered" ${selectedStatus=='delivered' ? 'selected' : '' }>Hoàn
                                            thành</option>
                                        <option value="cancelled" ${selectedStatus=='cancelled' ? 'selected' : '' }>Đã
                                            hủy</option>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label>Từ ngày</label>
                                    <input type="date" class="form-control" name="fromDate" value="${param.fromDate}">
                                </div>

                                <div class="filter-group">
                                    <label>Đến ngày</label>
                                    <input type="date" class="form-control" name="toDate" value="${param.toDate}">
                                </div>

                                <div class="filter-group" style="display: flex; align-items: end;">
                                    <button type="submit" class="btn btn-secondary">
                                        <i class="fas fa-filter"></i>
                                        Lọc
                                    </button>
                                </div>
                            </form>


                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">Danh sách đơn hàng (${totalOrders})</h3>
                                    <button class="btn btn-sm btn-outline" onclick="exportExcel()">
                                        <i class="fas fa-download"></i>
                                        Xuất Excel
                                    </button>
                                </div>
                                <div class="card-body" style="padding: 0;">
                                    <div class="table-wrapper">
                                        <table class="admin-table" id="ordersTable">
                                            <thead>
                                                <tr>
                                                    <th>Mã đơn</th>
                                                    <th>Khách hàng</th>
                                                    <th>Sản phẩm</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày đặt</th>
                                                    <th style="width: 150px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty orders}">
                                                        <tr>
                                                            <td colspan="7"
                                                                style="text-align: center; padding: 40px; color: #64748b;">
                                                                <i class="fas fa-inbox"
                                                                    style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                                                                Không có đơn hàng nào
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="order" items="${orders}">
                                                            <tr data-order-id="${order.id}">
                                                                <td><strong>#${order.id}</strong></td>
                                                                <td>
                                                                    <div style="font-weight: 500;">${order.customerName}
                                                                    </div>
                                                                    <div style="font-size: 12px; color: #64748b;">
                                                                        ${order.customerPhone}</div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty order.orderDetails}">
                                                                            ${order.orderDetails.size()} sản phẩm
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            0 sản phẩm
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <strong style="color: #16a34a;">
                                                                        <fmt:formatNumber value="${order.totalPrice}"
                                                                            type="number" groupingUsed="true" />đ
                                                                    </strong>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${order.status == 'delivered'}">
                                                                            <span
                                                                                class="badge success">${order.statusText}</span>
                                                                        </c:when>
                                                                        <c:when test="${order.status == 'cancelled'}">
                                                                            <span
                                                                                class="badge danger">${order.statusText}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <select class="status-select"
                                                                                data-order-id="${order.id}"
                                                                                style="padding: 4px 8px; border-radius: 6px; border: 1px solid #e2e8f0; font-size: 13px;">
                                                                                <option value="pending"
                                                                                    ${order.status=='pending'
                                                                                    ? 'selected' : '' }>Chờ xác nhận
                                                                                </option>
                                                                                <option value="confirmed"
                                                                                    ${order.status=='confirmed'
                                                                                    ? 'selected' : '' }>Đã xác nhận
                                                                                </option>
                                                                                <option value="processing"
                                                                                    ${order.status=='processing'
                                                                                    ? 'selected' : '' }>Đang xử lý
                                                                                </option>
                                                                                <option value="shipping"
                                                                                    ${order.status=='shipping'
                                                                                    ? 'selected' : '' }>Đang giao
                                                                                </option>
                                                                                <option value="delivered"
                                                                                    ${order.status=='delivered'
                                                                                    ? 'selected' : '' }>Hoàn thành
                                                                                </option>
                                                                                <option value="cancelled"
                                                                                    ${order.status=='cancelled'
                                                                                    ? 'selected' : '' }>Đã hủy</option>
                                                                            </select>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatDate value="${order.orderDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </td>
                                                                <td>
                                                                    <div class="action-buttons">
                                                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}"
                                                                            class="btn btn-sm btn-primary"
                                                                            title="Xem chi tiết">
                                                                            <i class="fas fa-eye"></i>
                                                                        </a>
                                                                        <button class="btn btn-sm btn-outline"
                                                                            title="In đơn"
                                                                            onclick="printOrder(${order.id})">
                                                                            <i class="fas fa-print"></i>
                                                                        </button>
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
                                                    href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">
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
                                                            href="${pageContext.request.contextPath}/admin/orders?page=${i}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">${i}</a>
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
                                                    href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}${not empty selectedStatus ? '&status='.concat(selectedStatus) : ''}">
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

                <script>
                    var contextPath = '${pageContext.request.contextPath}';

                    document.querySelectorAll('.status-select').forEach(function (select) {
                        select.addEventListener('change', function () {
                            var orderId = this.dataset.orderId;
                            var newStatus = this.value;

                            fetch(contextPath + '/admin/orders/update-status', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: 'orderId=' + orderId + '&status=' + encodeURIComponent(newStatus)
                            })
                                .then(function (response) { return response.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showNotification('Cập nhật trạng thái thành công', 'success');
                                        if (newStatus === 'delivered' || newStatus === 'cancelled') {
                                            setTimeout(function () { location.reload(); }, 1000);
                                        }
                                    } else {
                                        showNotification(data.message || 'Có lỗi xảy ra', 'error');
                                    }
                                })
                                .catch(function (error) {
                                    console.error('Error:', error);
                                    showNotification('Có lỗi xảy ra', 'error');
                                });
                        });
                    });

                    function showNotification(message, type) {
                        var notification = document.createElement('div');
                        var bgColor = type === 'success' ? '#16a34a' : '#dc2626';
                        notification.style.position = 'fixed';
                        notification.style.top = '20px';
                        notification.style.right = '20px';
                        notification.style.padding = '16px 24px';
                        notification.style.borderRadius = '8px';
                        notification.style.color = 'white';
                        notification.style.fontWeight = '500';
                        notification.style.zIndex = '9999';
                        notification.style.animation = 'slideIn 0.3s ease';
                        notification.style.background = bgColor;
                        notification.textContent = message;
                        document.body.appendChild(notification);

                        setTimeout(function () {
                            notification.style.animation = 'slideOut 0.3s ease';
                            setTimeout(function () { notification.remove(); }, 300);
                        }, 3000);
                    }

                    function exportExcel() {
                        showNotification('Đang xuất file Excel...', 'success');
                    }

                    function printOrder(orderId) {
                        window.open(contextPath + '/admin/orders/detail?id=' + orderId + '&print=true', '_blank');
                    }
                </script>

                <style>
                    @keyframes slideIn {
                        from {
                            transform: translateX(100%);
                            opacity: 0;
                        }

                        to {
                            transform: translateX(0);
                            opacity: 1;
                        }
                    }

                    @keyframes slideOut {
                        from {
                            transform: translateX(0);
                            opacity: 1;
                        }

                        to {
                            transform: translateX(100%);
                            opacity: 0;
                        }
                    }
                </style>
            </body>

            </html>