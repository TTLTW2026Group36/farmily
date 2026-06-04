<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Mã giảm giá - Admin Farmily</title>
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
        .status-filter {
            display: flex;
            gap: 12px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        .status-filter a {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            color: #64748b;
            background: #f1f5f9;
            font-size: 14px;
            transition: all 0.2s;
        }
        .status-filter a:hover {
            background: #e2e8f0;
        }
        .status-filter a.active {
            background: #22c55e;
            color: white;
        }
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 40px;
            height: 22px;
        }
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            border-radius: 22px;
            transition: .3s;
        }
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            border-radius: 50%;
            transition: .3s;
        }
        .toggle-switch input:checked + .toggle-slider {
            background-color: #22c55e;
        }
        .toggle-switch input:checked + .toggle-slider:before {
            transform: translateX(18px);
        }
    </style>
</head>
<body data-page="coupons">
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        <main class="admin-main">
            <jsp:include page="header.jsp" />
            <div class="admin-content">
                <c:if test="${not empty success}">
                    <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                <div class="content-header">
                    <div>
                        <h1 class="content-title">Quản lý Mã giảm giá</h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                            <span>/</span>
                            <span>Mã giảm giá</span>
                        </div>
                    </div>
                    <div class="page-actions">
                        <a href="${pageContext.request.contextPath}/admin/coupons/add" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Thêm mã giảm giá
                        </a>
                    </div>
                </div>
                <div class="filters-bar" style="display: flex; gap: 15px; margin-bottom: 20px; align-items: center; flex-wrap: wrap; background: white; padding: 20px; border-radius: 12px; box-shadow: var(--shadow);">
                    <form method="get" action="${pageContext.request.contextPath}/admin/coupons" 
                          style="display: flex; gap: 10px; align-items: center; flex: 1; margin: 0;">
                        <div style="position: relative; flex: 1; max-width: 300px;">
                            <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #999;"></i>
                            <input type="text" name="keyword" placeholder="Tìm theo mã..." 
                                   value="${currentKeyword}" 
                                   style="width: 100%; padding: 8px 12px 8px 36px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; outline: none;">
                        </div>
                        <input type="hidden" name="status" value="${currentStatus}">
                        <button type="submit" class="btn btn-outline" style="padding: 8px 16px; display: flex; align-items: center; gap: 5px; cursor: pointer;">
                            <i class="fas fa-search"></i> Tìm
                        </button>
                    </form>
                    
                    <div class="status-filter" style="margin-bottom: 0;">
                        <a href="?keyword=${currentKeyword}" 
                           class="${empty currentStatus ? 'active' : ''}">Tất cả</a>
                        <a href="?keyword=${currentKeyword}&status=active" 
                           class="${currentStatus == 'active' ? 'active' : ''}">Hoạt động</a>
                        <a href="?keyword=${currentKeyword}&status=upcoming" 
                           class="${currentStatus == 'upcoming' ? 'active' : ''}">Sắp diễn ra</a>
                        <a href="?keyword=${currentKeyword}&status=expired" 
                           class="${currentStatus == 'expired' ? 'active' : ''}">Hết hạn</a>
                        <a href="?keyword=${currentKeyword}&status=disabled" 
                           class="${currentStatus == 'disabled' ? 'active' : ''}">Đã tắt</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Danh sách mã giảm giá</h3>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-wrapper">
                            <table class="admin-table" id="couponsTable">
                                <thead>
                                    <tr>
                                        <th>Mã</th>
                                        <th>Loại</th>
                                        <th>Giá trị giảm</th>
                                        <th>Đơn tối thiểu</th>
                                        <th>Đã dùng / Tổng số</th>
                                        <th>Thời gian</th>
                                        <th>Trạng thái</th>
                                        <th style="width: 150px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty coupons}">
                                            <tr>
                                                <td colspan="8" style="text-align: center; padding: 40px;">
                                                    <i class="fas fa-ticket-alt" style="font-size: 48px; color: #ccc; margin-bottom: 10px;"></i>
                                                    <p style="color: #666;">Chưa có mã giảm giá nào</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="c" items="${coupons}">
                                                <tr>
                                                    <td><strong style="font-family: monospace; font-size: 14px;">${c.code}</strong></td>
                                                    <td><span class="badge active">${c.discountTypeText}</span></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${c.discountType == 'percent'}">
                                                                <strong>Giảm <fmt:formatNumber value="${c.discountValue}" type="number" maxFractionDigits="0"/>%</strong>
                                                                <c:if test="${not empty c.maxDiscount}">
                                                                    <div style="font-size: 11px; color: #666;">(Tối đa: <fmt:formatNumber value="${c.maxDiscount}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ)</div>
                                                                </c:if>
                                                            </c:when>
                                                            <c:when test="${c.discountType == 'fixed'}">
                                                                <strong>Giảm <fmt:formatNumber value="${c.discountValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ</strong>
                                                            </c:when>
                                                            <c:when test="${c.discountType == 'freeship'}">
                                                                <strong>Miễn phí vận chuyển</strong>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${c.minOrderValue}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                                    </td>
                                                    <td>
                                                        ${c.usedCount} / ${c.quantity}
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 13px;">
                                                            <i class="far fa-clock"></i>
                                                            <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy HH:mm" /><br>
                                                            <i class="fas fa-arrow-right" style="font-size: 10px; margin: 0 5px;"></i><br>
                                                            <i class="far fa-clock"></i>
                                                            <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 8px;">
                                                            <label class="toggle-switch">
                                                                <input type="checkbox" ${c.active ? 'checked' : ''} onchange="toggleCoupon(${c.id}, this)">
                                                                <span class="toggle-slider"></span>
                                                            </label>
                                                            <span class="badge ${c.statusBadgeClass}" id="status-badge-${c.id}">${c.statusText}</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/admin/coupons/detail?id=${c.id}" class="btn btn-sm btn-outline" style="border-color: #22c55e; color: #22c55e;" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=${c.id}" class="btn btn-sm btn-outline" title="Sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${c.usedCount > 0}">
                                                                    <button class="btn btn-sm btn-danger" disabled
                                                                        title="Không thể xoá mã đã được sử dụng"
                                                                        style="opacity: 0.4; cursor: not-allowed;">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form action="${pageContext.request.contextPath}/admin/coupons/delete" method="post" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa mã giảm giá này không?');">
                                                                        <input type="hidden" name="id" value="${c.id}">
                                                                        <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </form>
                                                                </c:otherwise>
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
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script>
        function toggleCoupon(id, checkbox) {
            fetch('${pageContext.request.contextPath}/admin/coupons/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id
            })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    const badge = document.getElementById('status-badge-' + id);
                    badge.textContent = data.statusText;
                    badge.className = 'badge ' + data.statusClass;
                } else {
                    checkbox.checked = !checkbox.checked;
                    alert('Lỗi: ' + data.message);
                }
            })
            .catch(() => {
                checkbox.checked = !checkbox.checked;
                alert('Có lỗi xảy ra');
            });
        }
    </script>
</body>
</html>

