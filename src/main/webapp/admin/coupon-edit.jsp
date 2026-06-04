<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Mã giảm giá - Admin Farmily</title>
    <link class="styles" rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link class="styles" rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link class="styles" rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/product-add.css">
    <link class="styles" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />
        <main class="admin-main">
            <jsp:include page="header.jsp" />
            <div class="admin-content">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <c:if test="${hasUsage}">
                    <div style="background: #fff3cd; color: #856404; padding: 14px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; border: 1px solid #ffc107;">
                        <i class="fas fa-lock"></i>
                        <div>
                            <strong>Mã này đã được sử dụng ${actualUsedCount} lượt.</strong>
                            Một số thông tin không thể sửa để đảm bảo đúng dữ liệu đơn hàng cũ.
                        </div>
                    </div>
                </c:if>

                <div class="content-header">
                    <div>
                        <h1 class="content-title">Sửa mã giảm giá</h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/admin/coupons">Mã giảm giá</a>
                            <span>/</span>
                            <span>Sửa</span>
                        </div>
                    </div>
                    <div class="page-actions">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>

                <form class="admin-form" action="${pageContext.request.contextPath}/admin/coupons/edit" method="post">
                    <input type="hidden" name="id" value="${coupon.id}">
                    <input type="hidden" name="usedCount" value="${coupon.usedCount}">

                    <c:if test="${hasUsage}">
                        <input type="hidden" name="code" value="${coupon.code}">
                        <input type="hidden" name="discountType" value="${coupon.discountType}">
                        <input type="hidden" name="discountValue" value="${coupon.discountValue}">
                        <input type="hidden" name="maxDiscount" value="${coupon.maxDiscount}">
                        <input type="hidden" name="maxUsagePerUser" value="${coupon.maxUsagePerUser}">
                    </c:if>

                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin mã giảm giá</h3>

                        <div class="form-group">
                            <label for="code">Mã giảm giá <span class="required">*</span></label>
                            <input type="text" id="code" name="${hasUsage ? '_code_locked' : 'code'}" class="form-control"
                                value="${coupon.code}" placeholder="VD: NHAP20, FSHIP"
                                style="text-transform: uppercase;${hasUsage ? ' opacity: 0.6; cursor: not-allowed;' : ''}"
                                ${hasUsage ? 'disabled' : ''} required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="discountType">Loại giảm giá <span class="required">*</span></label>
                                <select id="discountType" name="${hasUsage ? '_discountType_locked' : 'discountType'}" class="form-control"
                                    ${hasUsage ? 'disabled' : ''} required
                                    style="${hasUsage ? 'opacity: 0.6; cursor: not-allowed;' : ''}">
                                    <option value="percent" ${coupon.discountType == 'percent' ? 'selected' : ''}>Giảm theo %</option>
                                    <option value="fixed" ${coupon.discountType == 'fixed' ? 'selected' : ''}>Giảm số tiền cố định</option>
                                    <option value="freeship" ${coupon.discountType == 'freeship' ? 'selected' : ''}>Miễn phí vận chuyển</option>
                                </select>
                            </div>

                            <div class="form-group" id="discountValueGroup">
                                <label for="discountValue">Giá trị giảm <span class="required">*</span></label>
                                <input type="number" id="discountValue" name="${hasUsage ? '_discountValue_locked' : 'discountValue'}" class="form-control"
                                    value="${coupon.discountValue}" placeholder="VD: 20 hoặc 50000" min="0"
                                    ${hasUsage ? 'disabled' : ''} required
                                    style="${hasUsage ? 'opacity: 0.6; cursor: not-allowed;' : ''}">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group" id="maxDiscountGroup">
                                <label for="maxDiscount">Giảm tối đa (đ)</label>
                                <input type="number" id="maxDiscount" name="${hasUsage ? '_maxDiscount_locked' : 'maxDiscount'}" class="form-control"
                                    value="${coupon.maxDiscount}" placeholder="Để trống nếu không giới hạn" min="0"
                                    ${hasUsage ? 'disabled' : ''}
                                    style="${hasUsage ? 'opacity: 0.6; cursor: not-allowed;' : ''}">
                            </div>

                            <div class="form-group">
                                <label for="minOrderValue">Đơn hàng tối thiểu (đ) <span class="required">*</span></label>
                                <input type="number" id="minOrderValue" name="minOrderValue" class="form-control" value="${coupon.minOrderValue}" placeholder="VD: 150000" min="0" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="quantity">Số lượng mã phát hành <span class="required">*</span></label>
                                <input type="number" id="quantity" name="quantity" class="form-control"
                                    value="${coupon.quantity}" placeholder="VD: 100"
                                    min="${hasUsage ? actualUsedCount : 1}" required>
                                <c:if test="${hasUsage}">
                                    <small style="color: #6b7280; font-size: 12px;">
                                        Tối thiểu: ${actualUsedCount} (số lượt đã dùng)
                                    </small>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="maxUsagePerUser">Giới hạn sử dụng/khách hàng <span class="required">*</span></label>
                                <input type="number" id="maxUsagePerUser" name="${hasUsage ? '_maxUsagePerUser_locked' : 'maxUsagePerUser'}" class="form-control"
                                    value="${coupon.maxUsagePerUser}" placeholder="VD: 1" min="1"
                                    ${hasUsage ? 'disabled' : ''} required
                                    style="${hasUsage ? 'opacity: 0.6; cursor: not-allowed;' : ''}">
                            </div>

                            <div class="form-group">
                                <label>Đã sử dụng</label>
                                <input type="text" class="form-control" value="${coupon.usedCount}" readonly style="background-color: #f1f5f9;">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">Thời gian bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" id="startDate" name="startDate" class="form-control" value="<fmt:formatDate value='${coupon.startDate}' pattern='yyyy-MM-dd' />T<fmt:formatDate value='${coupon.startDate}' pattern='HH:mm' />" required>
                            </div>

                            <div class="form-group">
                                <label for="endDate">Thời gian kết thúc <span class="required">*</span></label>
                                <input type="datetime-local" id="endDate" name="endDate" class="form-control" value="<fmt:formatDate value='${coupon.endDate}' pattern='yyyy-MM-dd' />T<fmt:formatDate value='${coupon.endDate}' pattern='HH:mm' />" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" id="isActive" name="isActive" ${coupon.isActive() ? 'checked' : ''} style="width: auto;">
                                Kích hoạt mã giảm giá
                            </label>
                        </div>
                    </div>

                    <div style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Cập nhật mã giảm giá
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var typeSelect = document.getElementById('discountType');
            var valGroup = document.getElementById('discountValueGroup');
            var valInput = document.getElementById('discountValue');
            var maxGroup = document.getElementById('maxDiscountGroup');
            var maxInput = document.getElementById('maxDiscount');
            var hasUsage = ${hasUsage != null && hasUsage ? 'true' : 'false'};

            function toggleFields() {
                var val = typeSelect.value;
                if (val === 'freeship') {
                    valGroup.style.display = 'none';
                    if (!hasUsage) { valInput.required = false; valInput.value = '0'; }
                    maxGroup.style.display = 'none';
                    if (!hasUsage) { maxInput.value = ''; }
                } else if (val === 'percent') {
                    valGroup.style.display = '';
                    if (!hasUsage) { valInput.required = true; }
                    maxGroup.style.display = '';
                } else {
                    valGroup.style.display = '';
                    if (!hasUsage) { valInput.required = true; }
                    maxGroup.style.display = 'none';
                    if (!hasUsage) { maxInput.value = ''; }
                }
            }

            typeSelect.addEventListener('change', toggleFields);
            toggleFields();
        });
    </script>
</body>
</html>
