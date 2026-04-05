<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa Khách hàng #${user.id} - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/customers-edit.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />
                    <main class="admin-main">
                        <jsp:include page="header.jsp" />
                        <div class="admin-content">

                            <c:if test="${not empty success}">
                                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                            </c:if>

                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Chỉnh sửa Khách hàng <span
                                            class="user-id-badge">#${user.id}</span></h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/users">Khách hàng</a>
                                        <span>/</span>
                                        <span>Chỉnh sửa #${user.id}</span>
                                    </div>
                                </div>
                                <div class="header-actions">
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                            </div>

                            <div class="edit-layout">
                                <!-- LEFT: Basic Info -->
                                <div class="edit-left">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users/edit"
                                        id="editForm">
                                        <input type="hidden" name="id" value="${user.id}">
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title"><i class="fas fa-user"></i> Thông tin cơ bản</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <label for="name">Họ và tên</label>
                                                    <input type="text" id="name" name="name" value="${user.name}"
                                                        placeholder="Nhập họ và tên">
                                                </div>
                                                <div class="form-group">
                                                    <label>Email <span class="readonly-label">(không thể thay
                                                            đổi)</span></label>
                                                    <input type="email" value="${user.email}" disabled
                                                        class="input-readonly">
                                                </div>
                                                <div class="form-group">
                                                    <label for="phone">Số điện thoại</label>
                                                    <input type="tel" id="phone" name="phone" value="${user.phone}"
                                                        placeholder="Nhập số điện thoại (VD: 0912345678)">
                                                </div>
                                                <div class="form-group">
                                                    <label for="role">Vai trò</label>
                                                    <select id="role" name="role">
                                                        <option value="user" ${user.role=='user' ? 'selected' : '' }>
                                                            Người dùng</option>
                                                        <option value="admin" ${user.role=='admin' ? 'selected' : '' }>
                                                            Admin</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title"><i class="fas fa-info-circle"></i> Thông tin tài
                                                    khoản</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="info-display">
                                                    <div class="info-item">
                                                        <span class="info-label">Ngày đăng ký</span>
                                                        <span class="info-value">
                                                            <fmt:formatDate value="${user.created_at}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Cập nhật lần cuối</span>
                                                        <span class="info-value">
                                                            <fmt:formatDate value="${user.updated_at}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <button type="button" class="btn btn-danger" onclick="confirmDelete()">
                                                <i class="fas fa-trash"></i> Xóa khách hàng
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Lưu thay đổi
                                            </button>
                                        </div>
                                    </form>

                                    <form id="deleteForm" method="post"
                                        action="${pageContext.request.contextPath}/admin/users/delete"
                                        style="display:none;">
                                        <input type="hidden" name="id" value="${user.id}">
                                    </form>
                                </div>
                                <div class="edit-right">
                                    <div class="card address-card" id="addressCard">
                                        <div class="card-header">
                                            <h3 class="card-title"><i class="fas fa-map-marked-alt"></i> Sổ địa chỉ</h3>
                                            <button class="btn btn-sm btn-primary" onclick="openAddressModal(null)">
                                                <i class="fas fa-plus"></i> Thêm địa chỉ
                                            </button>
                                        </div>
                                        <div class="card-body" id="addressListContainer">
                                            <div class="loading-state"><i class="fas fa-spinner fa-spin"></i> Đang
                                                tải...</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <div class="modal-overlay" id="addressModal">
                    <div class="modal-box">
                        <div class="modal-header">
                            <h4 class="modal-title" id="modalTitle"><i class="fas fa-map-marker-alt"></i> Thêm địa chỉ</h4>
                            <button class="modal-close" onclick="closeAddressModal()"><i class="fas fa-times"></i></button>
                        </div>
                        <div class="modal-body">
                            <div id="modalError" class="alert alert-danger" style="display:none;"></div>
                            <input type="hidden" id="modalAddressId">
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Người nhận <span class="required">*</span></label>
                                    <input type="text" id="mReceiver" placeholder="Họ tên người nhận" required>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại <span class="required">*</span></label>
                                    <input type="tel" id="mPhone" placeholder="0xxxxxxxxx" required maxlength="11">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Địa chỉ cụ thể <span class="required">*</span></label>
                                <input type="text" id="mAddressDetail" placeholder="Số nhà, tên đường..." required>
                            </div>

                            <div class="form-split">
                                <div class="form-group">
                                    <label>Tỉnh/Thành phố <span class="required">*</span></label>
                                    <select id="addr-province" required>
                                        <option value="">Chọn Tỉnh/Thành</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Quận/Huyện</label>
                                    <select id="addr-district" disabled>
                                        <option value="">Chọn Quận/Huyện</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Phường/Xã</label>
                                <select id="addr-ward" disabled>
                                    <option value="">Chọn Phường/Xã</option>
                                </select>
                            </div>

                            <input type="hidden" id="mCity">
                            <input type="hidden" id="mDistrict">

                            <div class="form-group check-group">
                                <label class="checkbox-label">
                                    <input type="checkbox" id="mIsDefault"> Đặt làm địa chỉ mặc định
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-outline" onclick="closeAddressModal()">Hủy</button>
                            <button class="btn btn-primary" onclick="saveAddress()" id="saveAddressBtn">
                                <i class="fas fa-save"></i> Lưu địa chỉ
                            </button>
                        </div>
                    </div>
                </div>

                <div class="modal-overlay" id="deleteAddrModal">
                    <div class="modal-box modal-sm">
                        <div class="modal-header">
                            <h4 class="modal-title"><i class="fas fa-trash" style="color:#ef4444;"></i> Xóa địa chỉ</h4>
                            <button class="modal-close" onclick="closeDeleteModal()"><i
                                    class="fas fa-times"></i></button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn xóa địa chỉ này không?</p>
                            <input type="hidden" id="deleteAddrId">
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-outline" onclick="closeDeleteModal()">Hủy</button>
                            <button class="btn btn-danger" onclick="confirmDeleteAddress()">
                                <i class="fas fa-trash"></i> Xóa
                            </button>
                        </div>
                    </div>
                </div>

                <script>
                    const CTX = '${pageContext.request.contextPath}';
                    const USER_ID = parseInt('${user.id}');
                    const PROVINCE_API = 'https://provinces.open-api.vn/api/';

                    document.addEventListener('DOMContentLoaded', () => {
                        loadAddresses();
                        loadAddrProvinces();
                        initAddressDropdowns();
                    });

                    async function loadAddrProvinces() {
                        const sel = document.getElementById('addr-province');
                        if (!sel) return;
                        try {
                            const res = await fetch(PROVINCE_API + '?depth=1');
                            const provinces = await res.json();
                            sel.innerHTML = '<option value="">Chọn Tỉnh/Thành</option>';
                            provinces.forEach(p => {
                                const opt = document.createElement('option');
                                opt.value = p.name;
                                opt.dataset.code = p.code;
                                opt.textContent = p.name;
                                sel.appendChild(opt);
                            });
                        } catch (e) { console.warn('Province API error'); }
                    }

                    async function loadAddrDistricts(provinceCode) {
                        const distSel = document.getElementById('addr-district');
                        const wardSel = document.getElementById('addr-ward');
                        if (!distSel) return;
                        distSel.disabled = true;
                        distSel.innerHTML = '<option value="">Đang tải...</option>';
                        if (wardSel) { wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>'; wardSel.disabled = true; }
                        try {
                            const res = await fetch(PROVINCE_API + 'p/' + provinceCode + '?depth=2');
                            const data = await res.json();
                            distSel.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                            data.districts.forEach(d => {
                                const opt = document.createElement('option');
                                opt.value = d.name;
                                opt.dataset.code = d.code;
                                opt.textContent = d.name;
                                distSel.appendChild(opt);
                            });
                            distSel.disabled = false;
                        } catch (e) { }
                    }

                    async function loadAddrWards(districtCode) {
                        const wardSel = document.getElementById('addr-ward');
                        if (!wardSel) return;
                        wardSel.disabled = true;
                        wardSel.innerHTML = '<option value="">Đang tải...</option>';
                        try {
                            const res = await fetch(PROVINCE_API + 'd/' + districtCode + '?depth=2');
                            const data = await res.json();
                            wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                            data.wards.forEach(w => {
                                const opt = document.createElement('option');
                                opt.value = w.name;
                                opt.textContent = w.name;
                                wardSel.appendChild(opt);
                            });
                            wardSel.disabled = false;
                        } catch (e) { }
                    }

                    function initAddressDropdowns() {
                        const provSel = document.getElementById('addr-province');
                        const distSel = document.getElementById('addr-district');

                        if (provSel) {
                            provSel.addEventListener('change', function () {
                                const selectedOpt = this.options[this.selectedIndex];
                                document.getElementById('mCity').value = selectedOpt.value;
                                if (distSel) {
                                    distSel.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                                    distSel.disabled = true;
                                    document.getElementById('mDistrict').value = '';
                                }
                                if (selectedOpt.dataset.code) loadAddrDistricts(selectedOpt.dataset.code);
                            });
                        }

                        if (distSel) {
                            distSel.addEventListener('change', function () {
                                document.getElementById('mDistrict').value = this.value;
                                const selectedOpt = this.options[this.selectedIndex];
                                if (selectedOpt && selectedOpt.dataset.code) loadAddrWards(selectedOpt.dataset.code);
                            });
                        }
                    }

                    function loadAddresses() {
                        const container = document.getElementById('addressListContainer');
                        container.innerHTML = '<div class="loading-state"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';

                        fetch(CTX + '/admin/api/address?userId=' + USER_ID)
                            .then(r => r.json())
                            .then(data => {
                                if (!Array.isArray(data)) {
                                    container.innerHTML = '<div class="empty-addr">Không tải được danh sách địa chỉ.</div>';
                                    return;
                                }
                                if (data.length === 0) {
                                    container.innerHTML = '<div class="empty-addr"><i class="fas fa-map-marker-alt"></i><p>Chưa có địa chỉ nào</p></div>';
                                    return;
                                }
                                renderAddresses(data);
                            })
                            .catch(() => {
                                container.innerHTML = '<div class="empty-addr">Lỗi khi tải danh sách địa chỉ.</div>';
                            });
                    }

                    function renderAddresses(list) {
                        var container = document.getElementById('addressListContainer');
                        container.innerHTML = list.map(function (a) {
                            var defaultBadge = a.isDefault ? '<span class="default-badge">M\u1eb7c \u0111\u1ecbnh</span>' : '';
                            var defaultBtn = !a.isDefault
                                ? '<button class="addr-btn addr-btn-default" onclick="setDefault(' + a.id + ')" title="\u0110\u1eb7t m\u1eb7c \u0111\u1ecbnh"><i class="fas fa-star"></i></button>'
                                : '';
                            var fullAddr = escHtml(a.fullAddress || [a.addressDetail, a.district, a.city].filter(Boolean).join(', '));
                            return '<div class="addr-item" id="addr-' + a.id + '">'
                                + '<div class="addr-item-head">'
                                + '<div class="addr-receiver">'
                                + '<i class="fas fa-user-circle"></i>'
                                + '<strong>' + escHtml(a.receiver) + '</strong>'
                                + '<span class="addr-phone">' + escHtml(a.phone) + '</span>'
                                + defaultBadge
                                + '</div>'
                                + '<div class="addr-actions">'
                                + defaultBtn
                                + '<button class="addr-btn addr-btn-edit" onclick="openAddressModal(' + a.id + ')" title="Ch\u1ec9nh s\u1eeda"><i class="fas fa-edit"></i></button>'
                                + '<button class="addr-btn addr-btn-delete" onclick="openDeleteModal(' + a.id + ')" title="X\u00f3a"><i class="fas fa-trash"></i></button>'
                                + '</div>'
                                + '</div>'
                                + '<div class="addr-detail"><i class="fas fa-map-marker-alt"></i> ' + fullAddr + '</div>'
                                + '</div>';
                        }).join('');
                    }

                    function openAddressModal(addressId) {
                        clearModalError();
                        document.getElementById('mReceiver').value = '';
                        document.getElementById('mPhone').value = '';
                        document.getElementById('mAddressDetail').value = '';
                        document.getElementById('mDistrict').value = '';
                        document.getElementById('mCity').value = '';
                        document.getElementById('mIsDefault').checked = false;
                        document.getElementById('modalAddressId').value = '';

                        if (addressId) {
                            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa địa chỉ';
                            document.getElementById('modalAddressId').value = addressId;

                            fetch(CTX + '/admin/api/address?userId=' + USER_ID)
                                .then(r => r.json())
                                .then(list => {
                                    const addr = list.find(a => a.id == addressId);
                                    if (addr) {
                                        document.getElementById('mReceiver').value = addr.receiver || '';
                                        document.getElementById('mPhone').value = addr.phone || '';
                                        document.getElementById('mAddressDetail').value = addr.addressDetail || '';
                                        document.getElementById('mDistrict').value = addr.district || '';
                                        document.getElementById('mCity').value = addr.city || '';
                                        document.getElementById('mIsDefault').checked = addr.isDefault;
                                        populateDropdowns(addr.city, addr.district);
                                    }
                                });
                        } else {
                            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus"></i> Thêm địa chỉ mới';
                        }

                        document.getElementById('addressModal').classList.add('open');
                    }

                    async function populateDropdowns(city, district) {
                        const provSel = document.getElementById('addr-province');
                        if (!provSel || !city) return;
                        const opt = Array.from(provSel.options).find(o => o.value === city);
                        if (opt) {
                            provSel.value = city;
                            if (opt.dataset.code) {
                                await loadAddrDistricts(opt.dataset.code);
                                const distSel = document.getElementById('addr-district');
                                if (distSel && district) {
                                    distSel.value = district;
                                    const dOpt = Array.from(distSel.options).find(o => o.value === district);
                                    if (dOpt && dOpt.dataset.code) await loadAddrWards(dOpt.dataset.code);
                                }
                            }
                        }
                    }

                    function closeAddressModal() {
                        document.getElementById('addressModal').classList.remove('open');
                    }

                    function saveAddress() {
                        const addressId = document.getElementById('modalAddressId').value;
                        clearModalError();
                        const saveBtn = document.getElementById('saveAddressBtn');
                        saveBtn.disabled = true;

                        const addressDetail = document.getElementById('mAddressDetail').value.trim();
                        const ward = document.getElementById('addr-ward').value;
                        
                        let fullAddr = addressDetail;
                        if (ward && ward !== 'Chọn Phường/Xã') fullAddr += ', ' + ward;

                        const params = new URLSearchParams();
                        params.append('userId', USER_ID);
                        params.append('receiver', document.getElementById('mReceiver').value.trim());
                        params.append('phone', document.getElementById('mPhone').value.trim());
                        params.append('addressDetail', fullAddr);
                        params.append('district', document.getElementById('mDistrict').value.trim());
                        params.append('city', document.getElementById('mCity').value.trim());
                        params.append('isDefault', document.getElementById('mIsDefault').checked);

                        const isEdit = !!addressId;
                        const url = isEdit ? CTX + '/admin/api/address/' + addressId : CTX + '/admin/api/address';
                        const method = isEdit ? 'PUT' : 'POST';

                        fetch(url, { method, body: params })
                            .then(r => r.json())
                            .then(data => {
                                saveBtn.disabled = false;
                                if (data.success) {
                                    closeAddressModal();
                                    loadAddresses();
                                } else {
                                    showModalError(data.message || 'Không thể lưu địa chỉ');
                                }
                            })
                            .catch(() => {
                                saveBtn.disabled = false;
                                showModalError('Lỗi kết nối server');
                            });
                    }

                    function setDefault(addressId) {
                        const params = new URLSearchParams();
                        params.append('userId', USER_ID);
                        params.append('addressId', addressId);

                        fetch(CTX + '/admin/api/address/set-default', { method: 'POST', body: params })
                            .then(r => r.json())
                            .then(data => {
                                if (data.success) loadAddresses();
                            });
                    }

                    function openDeleteModal(addressId) {
                        document.getElementById('deleteAddrId').value = addressId;
                        document.getElementById('deleteAddrModal').classList.add('open');
                    }

                    function closeDeleteModal() {
                        document.getElementById('deleteAddrModal').classList.remove('open');
                    }

                    function confirmDeleteAddress() {
                        const addressId = document.getElementById('deleteAddrId').value;
                        closeDeleteModal();
                        fetch(CTX + '/admin/api/address/' + addressId + '?userId=' + USER_ID, { method: 'DELETE' })
                            .then(r => r.json())
                            .then(data => {
                                if (data.success) loadAddresses();
                            });
                    }

                    function confirmDelete() {
                        if (confirm('Bạn có chắc chắn muốn xóa khách hàng này? Hành động này không thể hoàn tác.')) {
                            document.getElementById('deleteForm').submit();
                        }
                    }

                    function showModalError(msg) {
                        const el = document.getElementById('modalError');
                        el.textContent = msg;
                        el.style.display = 'block';
                    }

                    function clearModalError() {
                        const el = document.getElementById('modalError');
                        el.style.display = 'none';
                        el.textContent = '';
                    }

                    function escHtml(str) {
                        if (!str) return '';
                        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
                    }

                    ['addressModal', 'deleteAddrModal'].forEach(id => {
                        document.getElementById(id).addEventListener('click', function (e) {
                            if (e.target === this) this.classList.remove('open');
                        });
                    });

                    loadAddresses();
                </script>
            </body>

            </html>