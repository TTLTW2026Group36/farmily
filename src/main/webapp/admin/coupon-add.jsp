<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Mã giảm giá - Admin Farmily</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/product-add.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                <div class="content-header">
                    <div>
                        <h1 class="content-title">Thêm mã giảm giá mới</h1>
                        <div class="content-breadcrumb">
                            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Dashboard</a>
                            <span>/</span>
                            <a href="${pageContext.request.contextPath}/admin/coupons">Mã giảm giá</a>
                            <span>/</span>
                            <span>Thêm mới</span>
                        </div>
                    </div>
                    <div class="page-actions">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </div>

                <form class="admin-form" action="${pageContext.request.contextPath}/admin/coupons/add" method="post">
                    <div class="form-section">
                        <h3 class="form-section-title">Thông tin mã giảm giá</h3>

                        <div class="form-group">
                            <label for="code">Mã giảm giá <span class="required">*</span></label>
                            <input type="text" id="code" name="code" class="form-control" placeholder="VD: NHAP20, FSHIP" style="text-transform: uppercase;" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="discountType">Loại giảm giá <span class="required">*</span></label>
                                <select id="discountType" name="discountType" class="form-control" required>
                                    <option value="percent">Giảm theo %</option>
                                    <option value="fixed">Giảm số tiền cố định</option>
                                    <option value="freeship">Miễn phí vận chuyển</option>
                                </select>
                            </div>

                            <div class="form-group" id="discountValueGroup">
                                <label for="discountValue">Giá trị giảm <span class="required">*</span></label>
                                <input type="number" id="discountValue" name="discountValue" class="form-control" placeholder="VD: 20 hoặc 50000" min="0" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group" id="maxDiscountGroup">
                                <label for="maxDiscount">Giảm tối đa (đ)</label>
                                <input type="number" id="maxDiscount" name="maxDiscount" class="form-control" placeholder="Để trống nếu không giới hạn" min="0">
                            </div>

                            <div class="form-group">
                                <label for="minOrderValue">Đơn hàng tối thiểu (đ) <span class="required">*</span></label>
                                <input type="number" id="minOrderValue" name="minOrderValue" class="form-control" placeholder="VD: 150000" min="0" value="0" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="quantity">Số lượng mã phát hành <span class="required">*</span></label>
                                <input type="number" id="quantity" name="quantity" class="form-control" placeholder="VD: 100" min="1" required>
                            </div>

                            <div class="form-group">
                                <label for="maxUsagePerUser">Giới hạn sử dụng/khách hàng <span class="required">*</span></label>
                                <input type="number" id="maxUsagePerUser" name="maxUsagePerUser" class="form-control" placeholder="VD: 1" min="1" value="1" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate">Thời gian bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" id="startDate" name="startDate" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label for="endDate">Thời gian kết thúc <span class="required">*</span></label>
                                <input type="datetime-local" id="endDate" name="endDate" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                                <input type="checkbox" id="isActive" name="isActive" checked style="width: auto;">
                                Kích hoạt ngay lập tức
                            </label>
                        </div>
                    </div>

                    <div style="display: flex; gap: 10px; justify-content: flex-end; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn btn-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu mã giảm giá
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

            function toggleFields() {
                var val = typeSelect.value;
                if (val === 'freeship') {
                    valGroup.style.display = 'none';
                    valInput.required = false;
                    valInput.value = '0';
                    maxGroup.style.display = 'none';
                    maxInput.value = '';
                } else if (val === 'percent') {
                    valGroup.style.display = '';
                    valInput.required = true;
                    maxGroup.style.display = '';
                } else {
                    valGroup.style.display = '';
                    valInput.required = true;
                    maxGroup.style.display = 'none';
                    maxInput.value = '';
                }
            }

            typeSelect.addEventListener('change', toggleFields);
            toggleFields();
        });
    </script>
</body>
</html>
