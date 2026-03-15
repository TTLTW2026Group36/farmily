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
                <script>
                    window.contextPath = '${pageContext.request.contextPath}';
                </script>
            </head>

            <body>
                <div class="admin-layout">
                    
                    <jsp:include page="sidebar.jsp" />
                    

                    
                    <main class="admin-main">
                        
                        <jsp:include page="header.jsp" />
                        

                        <div class="admin-content">
                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Chi tiết Đơn hàng #${order.id}</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a>
                                        <span>/</span>
                                        <span>#${order.id}</span>
                                    </div>
                                </div>
                                <div class="page-actions">
                                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline"><i
                                            class="fas fa-arrow-left"></i> Quay
                                        lại</a>
                                    <button class="btn btn-secondary" onclick="window.print()"><i
                                            class="fas fa-print"></i>
                                        In
                                        đơn</button>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;">
                                
                                <div>
                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin đơn hàng</h3>
                                            <c:choose>
                                                <c:when test="${order.status == 'pending'}">
                                                    <span class="badge warning">${order.statusText}</span>
                                                </c:when>
                                                <c:when
                                                    test="${order.status == 'confirmed' || order.status == 'processing'}">
                                                    <span class="badge info">${order.statusText}</span>
                                                </c:when>
                                                <c:when test="${order.status == 'shipping'}">
                                                    <span class="badge primary">${order.statusText}</span>
                                                </c:when>
                                                <c:when test="${order.status == 'delivered'}">
                                                    <span class="badge success">${order.statusText}</span>
                                                </c:when>
                                                <c:when test="${order.status == 'cancelled'}">
                                                    <span class="badge danger">${order.statusText}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge secondary">${order.statusText}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="card-body">
                                            <div
                                                style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 20px;">
                                                <div>
                                                    <div style="color: #64748b; font-size: 13px; margin-bottom: 5px;">
                                                        Ngày đặt:
                                                    </div>
                                                    <div style="font-weight: 600;">
                                                        <fmt:formatDate value="${order.orderDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </div>
                                                <div>
                                                    <div style="color: #64748b; font-size: 13px; margin-bottom: 5px;">
                                                        Phương thức thanh toán:
                                                    </div>
                                                    <div style="font-weight: 600;">
                                                        <c:choose>
                                                            <c:when test="${order.paymentMethod != null}">
                                                                ${order.paymentMethod.name}
                                                            </c:when>
                                                            <c:otherwise>
                                                                COD (Thanh toán khi nhận hàng)
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                            <div>
                                                <label style="display: block; margin-bottom: 8px; font-weight: 600;">Cập
                                                    nhật trạng thái:</label>
                                                <select class="form-control status-select" id="statusSelect"
                                                    data-order-id="${order.id}">
                                                    <option value="pending" ${order.status=='pending' ? 'selected' : ''
                                                        }>Chờ xác nhận</option>
                                                    <option value="confirmed" ${order.status=='confirmed' ? 'selected'
                                                        : '' }>Đã xác nhận</option>
                                                    <option value="processing" ${order.status=='processing' ? 'selected'
                                                        : '' }>Đang xử lý</option>
                                                    <option value="shipping" ${order.status=='shipping' ? 'selected'
                                                        : '' }>Đang giao hàng</option>
                                                    <option value="delivered" ${order.status=='delivered' ? 'selected'
                                                        : '' }>Đã giao hàng</option>
                                                    <option value="cancelled" ${order.status=='cancelled' ? 'selected'
                                                        : '' }>Đã hủy</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Sản phẩm (${order.orderDetails.size()})</h3>
                                        </div>
                                        <div class="card-body" style="padding: 0;">
                                            <table class="admin-table">
                                                <thead>
                                                    <tr>
                                                        <th>Sản phẩm</th>
                                                        <th>Đơn giá</th>
                                                        <th>Số lượng</th>
                                                        <th>Thành tiền</th>
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
                                                                        <div class="product-name">
                                                                            ${item.productName}
                                                                            <c:if test="${not empty item.variantText}">
                                                                                (${item.variantText})
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>${item.formattedUnitPrice}</td>
                                                            <td>x${item.quantity}</td>
                                                            <td><strong>${item.formattedSubtotal}</strong></td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty order.orderDetails}">
                                                        <tr>
                                                            <td colspan="4"
                                                                style="text-align: center; color: #64748b; padding: 20px;">
                                                                Không có sản phẩm nào
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                
                                <div>
                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin khách hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <div style="display: flex; gap: 10px; margin-bottom: 12px;">
                                                <span style="color: #64748b;">Họ tên:</span>
                                                <c:choose>
                                                    <c:when test="${not empty order.customerName}">
                                                        <strong>${order.customerName}</strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8;">Không có thông tin</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div style="display: flex; gap: 10px; margin-bottom: 12px;">
                                                <span style="color: #64748b;">Số điện thoại:</span>
                                                <c:choose>
                                                    <c:when test="${not empty order.customerPhone}">
                                                        <strong><a href="tel:${order.customerPhone}"
                                                                style="text-decoration: none; color: inherit;">${order.customerPhone}</a></strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8;">Không có thông tin</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div style="display: flex; gap: 10px;">
                                                <span style="color: #64748b;">Email:</span>
                                                <c:choose>
                                                    <c:when test="${not empty order.customerEmail}">
                                                        <span>${order.customerEmail}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8;">Không có thông tin</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Ghi chú</h3>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty order.note}">
                                                    <p style="color: #475569; margin: 0;">${order.note}</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p style="color: #94a3b8; font-style: italic; margin: 0;">Không có
                                                        ghi chú</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Tổng kết đơn hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <div
                                                style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                                <span>Tạm tính:</span>
                                                <strong>${order.formattedSubtotal}</strong>
                                            </div>
                                            <div
                                                style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                                <span>Phí vận chuyển:</span>
                                                <strong>${order.formattedShippingFee}</strong>
                                            </div>
                                            <div
                                                style="border-top: 2px solid #e2e8f0; padding-top: 12px; display: flex; justify-content: space-between; font-size: 18px;">
                                                <strong>Tổng cộng:</strong>
                                                <strong style="color: #16a34a;">${order.formattedTotalPrice}</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <script>
                    // Status update functionality
                    document.getElementById('statusSelect').addEventListener('change', function () {
                        const orderId = this.dataset.orderId;
                        const newStatus = this.value;

                        if (!confirm('Bạn có chắc muốn cập nhật trạng thái đơn hàng?')) {
                            // Reset to previous value
                            location.reload();
                            return;
                        }

                        fetch(window.contextPath + '/admin/orders/update-status', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: `orderId=${orderId}&status=${newStatus}`
                        })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    // Reload page to reflect changes
                                    location.reload();
                                } else {
                                    alert('Lỗi: ' + data.message);
                                    location.reload();
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Có lỗi xảy ra khi cập nhật trạng thái');
                                location.reload();
                            });
                    });
                </script>
            </body>

            </html>