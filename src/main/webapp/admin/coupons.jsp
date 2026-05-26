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
                                                        <span class="badge ${c.statusBadgeClass}">${c.statusText}</span>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=${c.id}" class="btn btn-sm btn-outline" title="Sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <form action="${pageContext.request.contextPath}/admin/coupons/delete" method="post" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa mã giảm giá này không?');">
                                                                <input type="hidden" name="id" value="${c.id}">
                                                                <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
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
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
