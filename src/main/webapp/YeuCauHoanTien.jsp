<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} | Farmily</title>
    <meta name="description" content="Gửi yêu cầu hoàn tiền cho đơn hàng của bạn tại Farmily.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoSo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/DonHang.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoanTien.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css?v=4">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<jsp:include page="common/header.jsp"/>

<nav class="site-breadcrumb" aria-label="Breadcrumb">
    <div class="breadcrumb-container">
        <ol class="breadcrumb-list">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/ho-so">Hồ sơ cá nhân</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/ho-so/don-hang">Đơn hàng của bạn</a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}">Đơn hàng #${order.id}</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">Yêu cầu hoàn tiền</li>
        </ol>
    </div>
</nav>

<div class="profile-container">

    <%-- Left nav: same as DonHangChiTiet --%>
    <div class="profile-menu">
        <h2>TRANG TÀI KHOẢN</h2>
        <p>Xin chào, <span class="highlight-name">${sessionScope.auth.name}</span>!</p>
        <ul>
            <li><a href="${pageContext.request.contextPath}/ho-so?tab=info"><i class="fas fa-user"></i> Thông tin tài khoản</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ho-so/don-hang"><i class="fas fa-box"></i> Đơn hàng của bạn</a></li>
            <li><a href="${pageContext.request.contextPath}/ho-so?tab=address"><i class="fas fa-map-marker-alt"></i> Sổ địa chỉ</a></li>
            <li><a href="${pageContext.request.contextPath}/ho-so?tab=password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
            <li><a href="${pageContext.request.contextPath}/ho-so?tab=wishlist"><i class="fas fa-heart"></i> Sản phẩm yêu thích</a></li>
            <li><a href="${pageContext.request.contextPath}/ho-so?tab=coupons"><i class="fas fa-ticket-alt"></i> Ví voucher</a></li>
        </ul>
    </div>

    <div class="profile-info">
        <div class="order-detail-header">
            <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}" class="btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <h2>YÊU CẦU HOÀN TIỀN</h2>
        </div>

        <%-- Flash messages --%>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger" role="alert" style="background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;padding:14px 18px;border-radius:8px;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
                <i class="fas fa-circle-exclamation"></i>
                ${fn:escapeXml(sessionScope.errorMessage)}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="refund-form-container">
            <h2><i class="fas fa-money-bill-wave"></i> Gửi yêu cầu hoàn tiền</h2>
            <p class="form-subtitle">Điền đầy đủ thông tin để chúng tôi xem xét và hoàn tiền cho bạn.</p>

            <%-- Order summary --%>
            <div class="refund-order-summary">
                <div>
                    <div class="order-ref">Đơn hàng #${order.id}</div>
                    <div style="font-size:13px;color:#666;margin-top:2px;">
                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
                <div>
                    <div style="font-size:13px;color:#666;">Tổng tiền</div>
                    <div class="order-total-ref">
                        <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>đ
                    </div>
                </div>
            </div>

            <%-- 72h notice --%>
            <div class="refund-notice">
                <i class="fas fa-circle-info"></i>
                <span>Yêu cầu hoàn tiền chỉ được chấp nhận trong vòng <strong>72 giờ</strong> sau khi đơn hàng hoàn thành.
                Sau khi gửi, Admin sẽ xem xét và phản hồi trong vòng 1–3 ngày làm việc.</span>
            </div>

            <form class="refund-form" id="refundForm"
                  action="${pageContext.request.contextPath}/ho-so/hoan-tien"
                  method="post"
                  enctype="multipart/form-data"
                  onsubmit="return validateRefundForm(this)">

                <input type="hidden" name="orderId" value="${order.id}">

                <%-- Reason --%>
                <div class="form-group">
                    <label class="form-label" for="reason">Lý do hoàn tiền <span class="required">*</span></label>
                    <select class="form-control" id="reason" name="reason" required>
                        <option value="">— Chọn lý do —</option>
                        <c:forEach var="reason" items="${refundReasons}">
                            <option value="${fn:escapeXml(reason)}">${fn:escapeXml(reason)}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Description --%>
                <div class="form-group">
                    <label class="form-label" for="description">Mô tả chi tiết</label>
                    <textarea class="form-control" id="description" name="description"
                              placeholder="Mô tả tình trạng sản phẩm, vấn đề gặp phải..." rows="4"
                              maxlength="1000"></textarea>
                    <div class="form-hint"><span id="descCount">0</span>/1000 ký tự</div>
                </div>

                <%-- Media upload --%>
                <div class="form-group">
                    <label class="form-label">Hình ảnh / Video minh chứng</label>
                    <div class="refund-media-upload" id="mediaDropZone">
                        <input type="file" name="mediaFiles" id="mediaFiles" multiple
                               accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm">
                        <div class="upload-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                        <div class="upload-text">Nhấn để chọn hoặc kéo thả file vào đây</div>
                        <div class="upload-hint">Tối đa 3 ảnh + 1 video, mỗi file ≤ 10MB</div>
                    </div>
                    <div class="refund-media-preview" id="mediaPreview"></div>
                </div>

                <%-- Bank info section --%>
                <div class="form-section-title">
                    <i class="fas fa-university"></i> Thông tin tài khoản nhận hoàn tiền
                </div>

                <div class="form-group">
                    <label class="form-label" for="bankName">Tên ngân hàng <span class="required">*</span></label>
                    <input type="text" class="form-control" id="bankName" name="bankName"
                           placeholder="VD: Vietcombank, BIDV, Techcombank..."
                           maxlength="100" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="bankAccount">Số tài khoản <span class="required">*</span></label>
                    <input type="text" class="form-control" id="bankAccount" name="bankAccount"
                           placeholder="Nhập số tài khoản ngân hàng"
                           maxlength="50" pattern="[0-9]+" title="Số tài khoản chỉ được chứa chữ số" required>
                    <div class="form-hint">Chỉ nhập chữ số, không dấu chấm hoặc khoảng trắng</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="bankHolder">Tên chủ tài khoản <span class="required">*</span></label>
                    <input type="text" class="form-control" id="bankHolder" name="bankHolder"
                           placeholder="Nhập tên chủ tài khoản (chữ IN HOA)"
                           maxlength="100" required>
                    <div class="form-hint">Nhập đúng như trên thẻ ngân hàng để tránh sai sót</div>
                </div>

                <%-- Actions --%>
                <div class="refund-form-actions">
                    <button type="submit" class="btn-submit-refund" id="btnSubmit">
                        <i class="fas fa-paper-plane"></i> Gửi yêu cầu hoàn tiền
                    </button>
                    <a href="${pageContext.request.contextPath}/ho-so/don-hang/chi-tiet?id=${order.id}"
                       class="btn-cancel-refund">
                        <i class="fas fa-times"></i> Hủy bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/chat-widget.jsp" />
                <jsp:include page="common/footer.jsp" />

<script>
(function() {
    // Description char counter
    var descArea = document.getElementById('description');
    var descCount = document.getElementById('descCount');
    if (descArea) {
        descArea.addEventListener('input', function() {
            descCount.textContent = this.value.length;
        });
    }

    // Dynamic Description Requirement based on Reason
    var reasonSelect = document.getElementById('reason');
    var descLabelSpan = document.querySelector('label[for="description"]');
    if (reasonSelect && descArea && descLabelSpan) {
        function handleReasonChange() {
            if (reasonSelect.value === 'Lý do khác') {
                descArea.required = true;
                descLabelSpan.innerHTML = 'Mô tả chi tiết <span class="required">*</span>';
                descArea.placeholder = 'Vui lòng mô tả chi tiết lý do hoàn tiền của bạn... (bắt buộc)';
            } else {
                descArea.required = false;
                descLabelSpan.innerHTML = 'Mô tả chi tiết';
                descArea.placeholder = 'Mô tả tình trạng sản phẩm, vấn đề gặp phải...';
            }
        }
        reasonSelect.addEventListener('change', handleReasonChange);
        handleReasonChange(); // Initial check
    }

    // Media preview
    var fileInput  = document.getElementById('mediaFiles');
    var preview    = document.getElementById('mediaPreview');
    var dataTransfer = new DataTransfer();

    if (fileInput) {
        fileInput.addEventListener('change', function(e) {
            var files = Array.from(e.target.files);
            var imageCount = 0, videoCount = 0;

            // Count existing
            Array.from(dataTransfer.files).forEach(function(f) {
                if (f.type.startsWith('image/')) imageCount++;
                if (f.type.startsWith('video/')) videoCount++;
            });

            files.forEach(function(file) {
                if (file.type.startsWith('image/') && imageCount >= 3) {
                    alert('Tối đa 3 ảnh');
                    return;
                }
                if (file.type.startsWith('video/') && videoCount >= 1) {
                    alert('Tối đa 1 video');
                    return;
                }
                if (file.size > 10 * 1024 * 1024) {
                    alert('File "' + file.name + '" vượt quá 10MB');
                    return;
                }

                dataTransfer.items.add(file);
                if (file.type.startsWith('image/')) imageCount++;
                if (file.type.startsWith('video/')) videoCount++;

                var reader = new FileReader();
                reader.onload = function(ev) {
                    var item = document.createElement('div');
                    item.className = 'preview-item';
                    item.dataset.name = file.name;

                    if (file.type.startsWith('video/')) {
                        item.innerHTML = '<video src="' + ev.target.result + '" muted style="width:100%;height:100%;object-fit:cover;"></video>';
                    } else {
                        item.innerHTML = '<img src="' + ev.target.result + '" alt="preview">';
                    }

                    var removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'preview-remove';
                    removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                    removeBtn.addEventListener('click', function() {
                        var newDT = new DataTransfer();
                        Array.from(dataTransfer.files).forEach(function(f) {
                            if (f.name !== file.name) newDT.items.add(f);
                        });
                        // Reassign
                        dataTransfer = newDT;
                        fileInput.files = dataTransfer.files;
                        preview.removeChild(item);
                    });

                    item.appendChild(removeBtn);
                    preview.appendChild(item);
                };
                reader.readAsDataURL(file);
            });

            fileInput.files = dataTransfer.files;
        });
    }

    // Form validation
    window.validateRefundForm = function(form) {
        var reason = form.querySelector('#reason').value;
        if (!reason) {
            alert('Vui lòng chọn lý do hoàn tiền');
            return false;
        }
        var desc = form.querySelector('#description').value.trim();
        if (reason === 'Lý do khác' && !desc) {
            alert('Vui lòng mô tả chi tiết lý do hoàn tiền khác');
            form.querySelector('#description').focus();
            return false;
        }
        var bankName = form.querySelector('#bankName').value.trim();
        var bankAccount = form.querySelector('#bankAccount').value.trim();
        var bankHolder = form.querySelector('#bankHolder').value.trim();
        if (!bankName || !bankAccount || !bankHolder) {
            alert('Vui lòng điền đầy đủ thông tin ngân hàng');
            return false;
        }
        if (!/^\d+$/.test(bankAccount)) {
            alert('Số tài khoản chỉ được chứa chữ số');
            return false;
        }

        var btn = document.getElementById('btnSubmit');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
        return true;
    };
})();
</script>
</body>
</html>
