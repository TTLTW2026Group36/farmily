<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hồ sơ cá nhân | Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SanPham.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HoSo.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <script>
                window.contextPath = '${pageContext.request.contextPath}';
            </script>
        </head>

        <body>

            <jsp:include page="common/header.jsp" />

            <nav class="site-breadcrumb" aria-label="Breadcrumb">
                <div class="breadcrumb-container">
                    <ol class="breadcrumb-list">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="fas fa-home"></i>
                                Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            Hồ sơ cá nhân
                        </li>
                    </ol>
                </div>
            </nav>

            <div class="profile-container">
                <div class="profile-menu">
                    <h2>TRANG TÀI KHOẢN</h2>
                    <p>Xin chào, <span id="user-name-sidebar" class="highlight-name">${sessionScope.auth.name}</span>!
                    </p>
                    <ul>
                        <li class="${param.tab == null || param.tab == 'info' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/ho-so?tab=info">
                                <i class="fas fa-user"></i> Thông tin tài khoản
                            </a>
                        </li>
                        <li class="${param.tab == 'orders' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/ho-so/don-hang">
                                <i class="fas fa-box"></i> Đơn hàng của bạn
                            </a>
                        </li>
                        <li class="${param.tab == 'address' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/ho-so?tab=address">
                                <i class="fas fa-map-marker-alt"></i> Sổ địa chỉ
                            </a>
                        </li>
                        <li class="${param.tab == 'password' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/ho-so?tab=password">
                                <i class="fas fa-lock"></i> Đổi mật khẩu
                            </a>
                        </li>
                        <li class="${param.tab == 'wishlist' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/ho-so?tab=wishlist">
                                <i class="fas fa-heart"></i> Sản phẩm yêu thích
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="profile-info">

                    <c:if test="${param.tab == null || param.tab == 'info'}">
                        <div class="info-header">
                            <h2>THÔNG TIN TÀI KHOẢN</h2>
                            <button class="btn-edit-profile" id="btn-edit-profile" onclick="toggleEditMode()">
                                <i class="fas fa-pen"></i> Chỉnh sửa
                            </button>
                        </div>


                        <div class="info-content" id="profile-view-mode">
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-user"></i> Họ Tên:</span>
                                <span class="info-value" id="display-name">${sessionScope.auth.name}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-envelope"></i> Email:</span>
                                <span class="info-value">${sessionScope.auth.email}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-phone"></i> Số Điện Thoại:</span>
                                <span class="info-value" id="display-phone">${sessionScope.auth.phone}</span>
                            </div>
                        </div>


                        <form class="info-content edit-mode" id="profile-edit-mode" style="display: none;">
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-user"></i> Họ Tên:</span>
                                <input type="text" class="info-input" id="edit-name" name="name"
                                    value="${sessionScope.auth.name}" required>
                            </div>
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-envelope"></i> Email:</span>
                                <span class="info-value info-disabled">${sessionScope.auth.email} <small>(Không
                                        thể thay đổi)</small></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label"><i class="fas fa-phone"></i> Số Điện Thoại:</span>
                                <div class="input-wrapper">
                                    <input type="tel" class="info-input" id="edit-phone" name="phone"
                                        value="${sessionScope.auth.phone}" placeholder="Nhập số điện thoại"
                                        maxlength="11">
                                    <span class="field-error" id="edit-phone-error"></span>
                                </div>
                            </div>
                            <div class="edit-actions">
                                <button type="button" class="btn-cancel-edit" onclick="cancelEditMode()">Hủy</button>
                                <button type="submit" class="btn-save-profile" id="btn-save-profile">
                                    <i class="fas fa-check"></i> Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </c:if>


                    <c:if test="${param.tab == 'address'}">
                        <div class="address-header">
                            <h2>ĐỊA CHỈ CỦA TÔI</h2>
                            <button class="btn-add-address" onclick="openAddressModal()">
                                <i class="fas fa-plus"></i> Thêm địa chỉ mới
                            </button>
                        </div>

                        <div class="address-section">
                            <h3 class="address-subtitle">Địa chỉ</h3>
                            <div id="address-list" class="address-list">

                                <div class="loading-spinner">
                                    <i class="fas fa-spinner fa-spin"></i> Đang tải...
                                </div>
                            </div>
                        </div>
                    </c:if>


                    <c:if test="${param.tab == 'password'}">
                        <h2>ĐỔI MẬT KHẨU</h2>
                        <form class="password-form" id="password-form">
                            <div class="form-group">
                                <label for="current-password">Mật khẩu hiện tại</label>
                                <input type="password" id="current-password" name="currentPassword" required>
                            </div>
                            <div class="form-group">
                                <label for="new-password">Mật khẩu mới</label>
                                <input type="password" id="new-password" name="newPassword" required>
                            </div>
                            <div class="form-group">
                                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                                <input type="password" id="confirm-password" name="confirmPassword" required>
                            </div>
                            <button type="submit" class="btn-submit">Đổi mật khẩu</button>
                        </form>
                    </c:if>


                    <c:if test="${param.tab == 'wishlist'}">
                        <div class="wishlist-section">
                            <h2>SẢN PHẨM YÊU THÍCH</h2>
                            <div id="wishlist-toolbar" class="wishlist-toolbar" style="display: none;">
                                <label class="checkbox-label">
                                    <input type="checkbox" id="wishlist-select-all">
                                    <span>Chọn tất cả</span>
                                </label>
                                <button id="btn-delete-selected" class="btn-delete-selected" disabled>
                                    <i class="fas fa-trash"></i> Xóa yêu thích
                                </button>
                            </div>
                            <div id="wishlist-container" class="wishlist-grid">
                                <div class="loading-spinner">
                                    <i class="fas fa-spinner fa-spin"></i>
                                    <p>Đang tải...</p>
                                </div>
                            </div>
                            <div id="wishlist-empty" class="empty-wishlist" style="display: none;">
                                <i class="far fa-heart"></i>
                                <h3>Chưa có sản phẩm yêu thích</h3>
                                <p>Hãy khám phá và thêm sản phẩm vào danh sách yêu thích của bạn!
                                </p>
                                <a href="${pageContext.request.contextPath}/san-pham" class="btn-explore">Khám phá sản
                                    phẩm</a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>


            <div id="address-modal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modal-title">Thêm địa chỉ mới</h3>
                        <button class="modal-close" onclick="closeAddressModal()">&times;</button>
                    </div>
                    <form id="address-form" class="address-form">
                        <input type="hidden" id="address-id" name="id" value="">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="receiver">Họ và tên người nhận <span class="required">*</span></label>
                                <input type="text" id="receiver" name="receiver" placeholder="Nhập họ tên" required>
                                <span class="field-error" id="receiver-error"></span>
                            </div>
                            <div class="form-group">
                                <label for="phone">Số điện thoại <span class="required">*</span></label>
                                <input type="tel" id="phone" name="phone" placeholder="0912345678" required
                                    maxlength="11">
                                <span class="field-error" id="phone-error"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="addressDetail">Địa chỉ cụ thể <span class="required">*</span></label>
                            <input type="text" id="addressDetail" name="addressDetail"
                                placeholder="Số nhà, tên đường, khu phố..." required>
                            <span class="field-error" id="addressDetail-error"></span>
                        </div>
                        <div class="form-split">
                            <div class="form-group">
                                <label for="addr-province">Tỉnh/Thành phố <span class="required">*</span></label>
                                <select id="addr-province" name="addr-province" required>
                                    <option value="">-- Chọn Tỉnh/Thành --</option>
                                </select>
                                <input id="addr-province-fallback" name="city" type="text"
                                    placeholder="VD: TP Hồ Chí Minh" style="display:none;">
                                <span class="field-error" id="city-error"></span>
                            </div>
                            <div class="form-group">
                                <label for="addr-district">Quận/Huyện</label>
                                <select id="addr-district" name="addr-district" disabled>
                                    <option value="">-- Chọn Quận/Huyện --</option>
                                </select>
                                <input id="addr-district-fallback" name="district" type="text" placeholder="VD: Quận 1"
                                    style="display:none;">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="addr-ward">Phường/Xã</label>
                            <select id="addr-ward" name="addr-ward" disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                            <input id="addr-ward-fallback" name="ward" type="text" placeholder="VD: Phường Bến Nghé"
                                style="display:none;">
                        </div>
                        <input type="hidden" id="city" name="city" value="">
                        <input type="hidden" id="district" name="district" value="">
                        <div class="form-group checkbox-group">
                            <label class="checkbox-label">
                                <input type="checkbox" id="isDefault" name="isDefault">
                                <span>Đặt làm địa chỉ mặc định</span>
                            </label>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-cancel" onclick="closeAddressModal()">Hủy</button>
                            <button type="submit" class="btn-save">Lưu địa chỉ</button>
                        </div>
                    </form>
                </div>
            </div>


            <div id="confirm-modal" class="modal">
                <div class="modal-content confirm-modal-content">
                    <div class="modal-header">
                        <h3>Xác nhận xóa</h3>
                        <button class="modal-close" onclick="closeConfirmModal()">&times;</button>
                    </div>
                    <p class="confirm-message">Bạn có chắc chắn muốn xóa địa chỉ này?</p>
                    <div class="modal-actions">
                        <button type="button" class="btn-cancel" onclick="closeConfirmModal()">Hủy</button>
                        <button type="button" class="btn-delete" id="confirm-delete-btn">Xóa</button>
                    </div>
                </div>
            </div>


            <jsp:include page="common/footer.jsp" />

            <script src="${pageContext.request.contextPath}/js/HoSo.js?v=2"></script>
        </body>

        </html>