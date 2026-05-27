<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Mã giảm giá - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .badge.active {
            background: #d1fae5;
            color: #065f46;
        }
        .badge.expired {
            background: #fee2e2;
            color: #991b1b;
        }
        .badge.upcoming {
            background: #dbeafe;
            color: #1e40af;
        }
        .badge.disabled {
            background: #e5e7eb;
            color: #6b7280;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        @media (max-width: 992px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }
        
        .stat-icon.blue { background: #eff6ff; color: #3b82f6; }
        .stat-icon.green { background: #f0fdf4; color: #22c55e; }
        .stat-icon.orange { background: #fff7ed; color: #f97316; }
        
        .stat-value {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
        }
        .stat-label {
            font-size: 13px;
            color: #64748b;
        }
        
        .info-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f5f9;
        }
        .info-table tr:last-child td {
            border-bottom: none;
        }
        .info-label {
            color: #64748b;
            font-weight: 500;
            width: 160px;
        }
        .info-value {
            color: #1e293b;
            font-weight: 600;
        }
    </style>
</head>
<body data-page="coupons">
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        <main class="admin-main">
            <jsp:include page="header.jsp" />
            <div class="admin-content">
                <div class="content-header">
                    <div>
                        <h1 class="content-title">Chi tiết Mã giảm giá: <span style="font-family: monospace; font-size: 28px; background: #f1f5f9; padding: 2px 10px; border-radius: 6px; color: #0f172a;">${coupon.code}</span></h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/admin/coupons">Mã giảm giá</a>
                            <span>/</span>
                            <span>Chi tiết</span>
                        </div>
                    </div>
                    <div class="page-actions">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=${coupon.id}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Sửa mã
                        </a>
                    </div>
                </div>

                <!-- Stats Overview -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon green">
                            <i class="fas fa-ticket-alt"></i>
                        </div>
                        <div>
                            <div class="stat-value">${coupon.usedCount} / ${coupon.quantity}</div>
                            <div class="stat-label">Đã dùng / Tổng số lượng</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon blue">
                            <i class="fas fa-hand-holding-usd"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${totalDiscount}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                            </div>
                            <div class="stat-label">Tổng số tiền đã giảm</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orange">
                            <i class="fas fa-percent"></i>
                        </div>
                        <div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${coupon.quantity > 0}">
                                        <fmt:formatNumber value="${(coupon.usedCount * 100.0) / coupon.quantity}" type="number" maxFractionDigits="1"/>%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Tỷ lệ sử dụng</div>
                        </div>
                    </div>
                </div>

                <!-- Detail Grid -->
                <div class="detail-grid">
                    <!-- Left: Configuration info -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Cấu hình mã giảm giá</h3>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <table class="info-table" style="width: 100%; border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="info-label">Mã code</td>
                                        <td class="info-value"><strong style="font-family: monospace; font-size: 16px;">${coupon.code}</strong></td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Loại giảm giá</td>
                                        <td class="info-value"><span class="badge active">${coupon.discountTypeText}</span></td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Giá trị giảm</td>
                                        <td class="info-value" style="color: #22c55e; font-size: 16px;">
                                            <c:choose>
                                                <c:when test="${coupon.discountType == 'percent'}">
                                                    Giảm <fmt:formatNumber value="${coupon.discountValue}" type="number" maxFractionDigits="0"/>%
                                                    <c:if test="${not empty coupon.maxDiscount}">
                                                        <div style="font-size: 12px; color: #64748b; font-weight: normal;">(Tối đa: <fmt:formatNumber value="${coupon.maxDiscount}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ)</div>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${coupon.discountType == 'fixed'}">
                                                    Giảm <fmt:formatNumber value="${coupon.discountValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                </c:when>
                                                <c:when test="${coupon.discountType == 'freeship'}">
                                                    Miễn phí vận chuyển
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Đơn tối thiểu</td>
                                        <td class="info-value">
                                            <fmt:formatNumber value="${coupon.minOrderValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Giới hạn/User</td>
                                        <td class="info-value">Tối đa ${coupon.maxUsagePerUser} lần/khách hàng</td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Thời gian bắt đầu</td>
                                        <td class="info-value"><i class="far fa-clock"></i> <fmt:formatDate value="${coupon.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Thời gian kết thúc</td>
                                        <td class="info-value"><i class="far fa-clock"></i> <fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    </tr>
                                    <tr>
                                        <td class="info-label">Trạng thái</td>
                                        <td class="info-value"><span class="badge ${coupon.statusBadgeClass}">${coupon.statusText}</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Right: Usage History -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Lịch sử sử dụng mã giảm giá</h3>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <div class="table-wrapper">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Đơn hàng</th>
                                            <th>Khách hàng</th>
                                            <th>Tiền giảm</th>
                                            <th>Thời gian dùng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty usageHistory}">
                                                <tr>
                                                    <td colspan="4" style="text-align: center; padding: 40px; color: #64748b;">
                                                        <i class="fas fa-history" style="font-size: 36px; color: #cbd5e1; margin-bottom: 8px;"></i>
                                                        <p>Chưa có lượt sử dụng nào cho mã này</p>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="usage" items="${usageHistory}">
                                                    <tr>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${usage.orderId}" style="color: #3b82f6; font-weight: 700; text-decoration: underline;">
                                                                #${usage.orderId}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty usage.userName}">
                                                                    <strong>${usage.userName}</strong>
                                                                    <div style="font-size: 12px; color: #64748b;">${usage.userEmail}</div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge disabled">Khách vãng lai</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <strong style="color: #22c55e;">
                                                                -<fmt:formatNumber value="${usage.discountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                            </strong>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${usage.usedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
