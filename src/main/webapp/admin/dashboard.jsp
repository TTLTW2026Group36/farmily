<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/index.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <div class="admin-layout">
                    
                    <jsp:include page="sidebar.jsp" />
                    

                    
                    <main class="admin-main">
                        
                        <jsp:include page="header.jsp" />
                        

                        
                        <div class="admin-content">
                            <div class="content-header">
                                <h1 class="content-title">Dashboard</h1>
                                <div class="content-breadcrumb">
                                    <i class="fas fa-home"></i>
                                    <span>Dashboard</span>
                                </div>
                            </div>

                            
                            <div class="stats-grid">
                                <div class="stat-card primary">
                                    <div class="stat-info">
                                        <h3>Tổng doanh thu</h3>
                                        <div class="number">
                                            <fmt:formatNumber value="${totalRevenue}" type="number" pattern="#,###" />đ
                                        </div>
                                        <div class="change ${revenueChangePercent >= 0 ? 'up' : 'down'}">
                                            <c:choose>
                                                <c:when test="${revenueChangePercent >= 0}">
                                                    <i class="fas fa-arrow-up"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-arrow-down"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            <fmt:formatNumber
                                                value="${revenueChangePercent >= 0 ? revenueChangePercent : -revenueChangePercent}"
                                                type="number" pattern="#,##0.0" />% so với tháng trước
                                        </div>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                </div>

                                <div class="stat-card info">
                                    <div class="stat-info">
                                        <h3>Đơn hàng</h3>
                                        <div class="number">
                                            <fmt:formatNumber value="${totalOrders}" type="number" pattern="#,###" />
                                        </div>
                                        <div class="change ${ordersChangePercent >= 0 ? 'up' : 'down'}">
                                            <c:choose>
                                                <c:when test="${ordersChangePercent >= 0}">
                                                    <i class="fas fa-arrow-up"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-arrow-down"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            <fmt:formatNumber
                                                value="${ordersChangePercent >= 0 ? ordersChangePercent : -ordersChangePercent}"
                                                type="number" pattern="#,##0.0" />% so với tháng trước
                                        </div>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                </div>

                                <div class="stat-card warning">
                                    <div class="stat-info">
                                        <h3>Sản phẩm</h3>
                                        <div class="number">
                                            <fmt:formatNumber value="${totalProducts}" type="number" pattern="#,###" />
                                        </div>
                                        <div class="change up">
                                            <i class="fas fa-box"></i>
                                            ${newProductsCount} sản phẩm mới
                                        </div>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="fas fa-box"></i>
                                    </div>
                                </div>

                                <div class="stat-card danger">
                                    <div class="stat-info">
                                        <h3>Khách hàng</h3>
                                        <div class="number">
                                            <fmt:formatNumber value="${totalCustomers}" type="number" pattern="#,###" />
                                        </div>
                                        <div class="change up">
                                            <i class="fas fa-users"></i>
                                            Tổng số khách hàng
                                        </div>
                                    </div>
                                    <div class="stat-icon">
                                        <i class="fas fa-users"></i>
                                    </div>
                                </div>
                            </div>

                            
                            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-top: 20px;">
                                
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Đơn hàng gần đây</h3>
                                        <a href="${pageContext.request.contextPath}/admin/orders"
                                            class="btn btn-sm btn-outline">Xem tất cả</a>
                                    </div>
                                    <div class="card-body" style="padding: 0;">
                                        <div class="table-wrapper">
                                            <table class="admin-table">
                                                <thead>
                                                    <tr>
                                                        <th>Mã đơn</th>
                                                        <th>Khách hàng</th>
                                                        <th>Tổng tiền</th>
                                                        <th>Trạng thái</th>
                                                        <th>Ngày</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty recentOrders}">
                                                            <c:forEach var="order" items="${recentOrders}">
                                                                <tr>
                                                                    <td>
                                                                        <a
                                                                            href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.id}">
                                                                            <strong>#ORD${String.format("%03d",
                                                                                order.id)}</strong>
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${order.guestOrder}">
                                                                                ${order.guestName}
                                                                            </c:when>
                                                                            <c:when test="${not empty order.user}">
                                                                                ${order.user.name}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Khách vãng lai
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <strong>
                                                                            <fmt:formatNumber
                                                                                value="${order.totalPrice}"
                                                                                type="number" pattern="#,###" />đ
                                                                        </strong>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${order.status == 'pending'}">
                                                                                <span class="badge warning">Chờ xác
                                                                                    nhận</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'confirmed'}">
                                                                                <span class="badge info">Đã xác
                                                                                    nhận</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'shipping'}">
                                                                                <span class="badge info">Đang
                                                                                    giao</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'completed'}">
                                                                                <span class="badge success">Hoàn
                                                                                    thành</span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${order.status == 'cancelled'}">
                                                                                <span class="badge danger">Đã hủy</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span
                                                                                    class="badge secondary">${order.status}</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatDate value="${order.orderDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td colspan="5"
                                                                    style="text-align: center; padding: 20px; color: #64748b;">
                                                                    <i class="fas fa-inbox"
                                                                        style="font-size: 24px; margin-bottom: 10px;"></i>
                                                                    <p>Chưa có đơn hàng nào</p>
                                                                </td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Sản phẩm bán chạy</h3>
                                    </div>
                                    <div class="card-body">
                                        <div style="display: flex; flex-direction: column; gap: 15px;">
                                            <c:choose>
                                                <c:when test="${not empty bestSellingProducts}">
                                                    <c:forEach var="product" items="${bestSellingProducts}">
                                                        <div style="display: flex; gap: 12px; align-items: center;">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${not empty product.images && not empty product.images[0]}">
                                                                    <img src="${product.images[0].imageUrl}"
                                                                        alt="${product.name}"
                                                                        style="width: 50px; height: 50px; object-fit: cover; border-radius: 6px;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="https://i.postimg.cc/xdZztWKq/demosanpham.jpg"
                                                                        alt="${product.name}"
                                                                        style="width: 50px; height: 50px; object-fit: cover; border-radius: 6px;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div style="flex: 1;">
                                                                <div style="font-weight: 600; margin-bottom: 4px;">
                                                                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.id}"
                                                                        style="color: inherit; text-decoration: none;">
                                                                        ${product.name}
                                                                    </a>
                                                                </div>
                                                                <div style="font-size: 13px; color: #64748b;">
                                                                    Đã bán:
                                                                    <fmt:formatNumber value="${product.soldCount}"
                                                                        type="number" pattern="#,###" />
                                                                </div>
                                                            </div>
                                                            <div style="font-weight: 700; color: #16a34a;">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty product.variants && not empty product.variants[0]}">
                                                                        <fmt:formatNumber
                                                                            value="${product.variants[0].price}"
                                                                            type="number" pattern="#,###" />đ
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        --
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="text-align: center; padding: 20px; color: #64748b;">
                                                        <i class="fas fa-box-open"
                                                            style="font-size: 24px; margin-bottom: 10px;"></i>
                                                        <p>Chưa có sản phẩm bán chạy</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            
                            <div class="card" style="margin-top: 20px;">
                                <div class="card-header">
                                    <h3 class="card-title">Thao tác nhanh</h3>
                                </div>
                                <div class="card-body">
                                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px;">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=add"
                                            class="btn btn-primary" style="justify-content: center;">
                                            <i class="fas fa-plus"></i>
                                            Thêm sản phẩm
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-info"
                                            style="justify-content: center; background: #3b82f6; color: white;">
                                            <i class="fas fa-shopping-cart"></i>
                                            Xem đơn hàng
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/users"
                                            class="btn btn-secondary" style="justify-content: center;">
                                            <i class="fas fa-users"></i>
                                            Quản lý khách hàng
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/settings.jsp"
                                            class="btn btn-outline" style="justify-content: center;">
                                            <i class="fas fa-cog"></i>
                                            Cài đặt
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>