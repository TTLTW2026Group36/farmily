
const PROVINCE_API = 'https://provinces.open-api.vn/api/';
let addrApiAvailable = true;

document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    const currentTab = urlParams.get('tab');

    if (currentTab === 'address') {
        loadAddresses();
    }

    initAddressForm();
    initPasswordForm();
    initProfileForm();
    initPhoneInputBlocker();
    loadAddrProvinces();
});

async function loadAddrProvinces() {
    const sel = document.getElementById('addr-province');
    if (!sel) return;
    try {
        const res = await fetch(PROVINCE_API + '?depth=1');
        if (!res.ok) throw new Error('API error');
        const provinces = await res.json();
        sel.innerHTML = '<option value="">Chọn Tỉnh/Thành</option>';
        provinces.forEach(p => {
            const opt = document.createElement('option');
            opt.value = p.name;
            opt.dataset.code = p.code;
            opt.textContent = p.name;
            sel.appendChild(opt);
        });
        addrApiAvailable = true;
    } catch (e) {
        console.warn('Province API not available, switching to text fallback');
        addrApiAvailable = false;
        switchAddrToFallback();
    }
}

async function loadAddrDistricts(provinceCode) {
    const distSel = document.getElementById('addr-district');
    const wardSel = document.getElementById('addr-ward');
    if (!distSel || !addrApiAvailable) return;
    distSel.disabled = true;
    distSel.innerHTML = '<option value="">Đang tải...</option>';
    if (wardSel) { wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>'; wardSel.disabled = true; }
    try {
        const res = await fetch(PROVINCE_API + 'p/' + provinceCode + '?depth=2');
        if (!res.ok) throw new Error('API error');
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
    } catch (e) {
        distSel.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
    }
}

async function loadAddrWards(districtCode) {
    const wardSel = document.getElementById('addr-ward');
    if (!wardSel || !addrApiAvailable) return;
    wardSel.disabled = true;
    wardSel.innerHTML = '<option value="">Đang tải...</option>';
    try {
        const res = await fetch(PROVINCE_API + 'd/' + districtCode + '?depth=2');
        if (!res.ok) throw new Error('API error');
        const data = await res.json();
        wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>';
        data.wards.forEach(w => {
            const opt = document.createElement('option');
            opt.value = w.name;
            opt.textContent = w.name;
            wardSel.appendChild(opt);
        });
        wardSel.disabled = false;
    } catch (e) {
        wardSel.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
    }
}

function switchAddrToFallback() {
    const provSel = document.getElementById('addr-province');
    const distSel = document.getElementById('addr-district');
    const wardSel = document.getElementById('addr-ward');
    const provFb = document.getElementById('addr-province-fallback');
    const distFb = document.getElementById('addr-district-fallback');
    const wardFb = document.getElementById('addr-ward-fallback');
    if (provSel) { provSel.style.display = 'none'; provSel.removeAttribute('required'); }
    if (distSel) { distSel.style.display = 'none'; }
    if (wardSel) { wardSel.style.display = 'none'; }
    if (provFb) { provFb.style.display = 'block'; provFb.setAttribute('required', 'required'); }
    if (distFb) { distFb.style.display = 'block'; }
    if (wardFb) { wardFb.style.display = 'block'; }
}

function resetAddrDropdowns() {
    const provSel = document.getElementById('addr-province');
    const distSel = document.getElementById('addr-district');
    const wardSel = document.getElementById('addr-ward');
    const provFb = document.getElementById('addr-province-fallback');
    const distFb = document.getElementById('addr-district-fallback');
    const wardFb = document.getElementById('addr-ward-fallback');
    if (provSel) provSel.value = '';
    if (distSel) { distSel.innerHTML = '<option value="">Chọn Quận/Huyện</option>'; distSel.disabled = true; }
    if (wardSel) { wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>'; wardSel.disabled = true; }
    if (provFb) provFb.value = '';
    if (distFb) distFb.value = '';
    if (wardFb) wardFb.value = '';
    const cityHidden = document.getElementById('city');
    const distHidden = document.getElementById('district');
    if (cityHidden) cityHidden.value = '';
    if (distHidden) distHidden.value = '';
}

async function populateProvinceForEdit(cityName, districtName, wardName) {
    if (!addrApiAvailable || !cityName) return;
    const provSel = document.getElementById('addr-province');
    const distSel = document.getElementById('addr-district');
    if (!provSel) return;

    const provOpts = Array.from(provSel.options);
    const provOpt = provOpts.find(o => o.value === cityName);
    if (!provOpt) {
        const provFb = document.getElementById('addr-province-fallback');
        if (provFb) {
            provFb.value = cityName;
            switchAddrToFallback();
            const distFb = document.getElementById('addr-district-fallback');
            if (distFb) distFb.value = districtName || '';
            const wardFb = document.getElementById('addr-ward-fallback');
            if (wardFb) wardFb.value = wardName || '';
        }
        return;
    }
    provSel.value = cityName;

    if (provOpt.dataset.code) {
        await loadAddrDistricts(provOpt.dataset.code);
        if (districtName && distSel) {
            distSel.value = districtName;
            const distOpt = distSel.options[distSel.selectedIndex];
            if (distOpt && distOpt.dataset.code && wardName) {
                await loadAddrWards(distOpt.dataset.code);
                const wardSel = document.getElementById('addr-ward');
                if (wardSel) wardSel.value = wardName;
            }
        }
    }
}

function validatePhone(phone) {
    if (!phone) return false;
    const cleaned = phone.trim().replace(/\s+/g, '');
    return /^(0[3-9][0-9]{8})$/.test(cleaned);
}

function initPhoneInputBlocker() {
    const phoneFields = [
        document.getElementById('edit-phone'),
        document.getElementById('phone')
    ];
    phoneFields.forEach(input => {
        if (!input) return;
        input.addEventListener('keypress', function (e) {
            if (!/[0-9]/.test(e.key) && !['Enter', 'Backspace', 'Delete', 'Tab', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
                e.preventDefault();
            }
        });
        input.addEventListener('input', function () {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    });
}

function loadAddresses() {
    const addressList = document.getElementById('address-list');
    if (!addressList) return;

    addressList.innerHTML = `
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i> Đang tải...
        </div>
    `;

    fetch(`${window.contextPath}/api/address`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => {
            if (response.status === 401) {
                window.location.href = `${window.contextPath}/dang-nhap`;
                return;
            }
            return response.json();
        })
        .then(addresses => {
            if (!addresses) return;
            renderAddresses(addresses);
        })
        .catch(error => {
            console.error('Error loading addresses:', error);
            addressList.innerHTML = `
            <div class="empty-address">
                <i class="fas fa-exclamation-circle"></i>
                <p>Không thể tải danh sách địa chỉ</p>
            </div>
        `;
        });
}

function renderAddresses(addresses) {
    const addressList = document.getElementById('address-list');
    if (!addressList) return;

    if (addresses.length === 0) {
        addressList.innerHTML = `
            <div class="empty-address">
                <i class="fas fa-map-marker-alt"></i>
                <p>Bạn chưa có địa chỉ nào. Hãy thêm địa chỉ mới!</p>
            </div>
        `;
        return;
    }

    let html = '';
    addresses.forEach(address => {
        html += createAddressCard(address);
    });

    addressList.innerHTML = html;
}

function createAddressCard(address) {
    const defaultBadge = address.isDefault ?
        '<span class="default-badge">Mặc định</span>' : '';

    const setDefaultBtn = address.isDefault ?
        '<button class="btn-set-default disabled" disabled>Thiết lập mặc định</button>' :
        `<button class="btn-set-default" onclick="setDefaultAddress(${address.id})">Thiết lập mặc định</button>`;

    const phone = address.phone ? `(+84) ${address.phone.replace(/^0/, '')}` : '';

    return `
        <div class="address-card" data-id="${address.id}">
            <div class="address-info">
                <div class="address-receiver">
                    <span class="receiver-name">${escapeHtml(address.receiver)}</span>
                    ${phone ? `<span class="receiver-phone">${escapeHtml(phone)}</span>` : ''}
                </div>
                <div class="address-detail">${escapeHtml(address.addressDetail)}</div>
                <div class="address-location">${escapeHtml(address.district || '')}${address.district && address.city ? ', ' : ''}${escapeHtml(address.city || '')}</div>
                ${defaultBadge}
            </div>
            <div class="address-actions">
                <div class="action-links">
                    <button class="action-link" onclick="editAddress(${address.id})">Cập nhật</button>
                    <button class="action-link delete" onclick="confirmDeleteAddress(${address.id})">Xóa</button>
                </div>
                ${setDefaultBtn}
            </div>
        </div>
    `;
}




function initAddressForm() {
    const form = document.getElementById('address-form');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        e.preventDefault();
        saveAddress();
    });

    const provSel = document.getElementById('addr-province');
    const distSel = document.getElementById('addr-district');

    if (provSel) {
        provSel.addEventListener('change', function () {
            const selectedOpt = this.options[this.selectedIndex];
            const cityHidden = document.getElementById('city');
            if (cityHidden) cityHidden.value = selectedOpt.value;
            clearFieldError('city');

            if (distSel) {
                distSel.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                distSel.disabled = true;
                const distHidden = document.getElementById('district');
                if (distHidden) distHidden.value = '';
            }

            if (selectedOpt.dataset.code) {
                loadAddrDistricts(selectedOpt.dataset.code);
            }
        });
    }

    if (distSel) {
        distSel.addEventListener('change', function () {
            const distHidden = document.getElementById('district');
            if (distHidden) distHidden.value = this.value;
            const wardSel = document.getElementById('addr-ward');
            if (wardSel) { wardSel.innerHTML = '<option value="">Chọn Phường/Xã</option>'; wardSel.disabled = true; }
            const selectedOpt = this.options[this.selectedIndex];
            if (selectedOpt && selectedOpt.dataset.code) {
                loadAddrWards(selectedOpt.dataset.code);
            }
        });
    }

    const provFb = document.getElementById('addr-province-fallback');
    if (provFb) {
        provFb.addEventListener('input', function () {
            const cityHidden = document.getElementById('city');
            if (cityHidden) cityHidden.value = this.value.trim();
        });
    }

    const distFb = document.getElementById('addr-district-fallback');
    if (distFb) {
        distFb.addEventListener('input', function () {
            const distHidden = document.getElementById('district');
            if (distHidden) distHidden.value = this.value.trim();
        });
    }
}

function openAddressModal() {
    const modal = document.getElementById('address-modal');
    const form = document.getElementById('address-form');
    const title = document.getElementById('modal-title');

    if (!modal || !form) return;

    form.reset();
    clearAddressFormErrors();
    resetAddrDropdowns();
    document.getElementById('address-id').value = '';
    title.textContent = 'Thêm địa chỉ mới';

    modal.classList.add('active');
    document.body.style.overflow = 'hidden';

    setTimeout(() => {
        document.getElementById('receiver').focus();
    }, 100);
}

function closeAddressModal() {
    const modal = document.getElementById('address-modal');
    if (!modal) return;

    modal.classList.remove('active');
    document.body.style.overflow = '';
    clearAddressFormErrors();
    resetAddrDropdowns();
}

function clearAddressFormErrors() {
    const ids = ['receiver', 'phone', 'addressDetail', 'city'];
    ids.forEach(id => {
        const input = document.getElementById(id);
        const errEl = document.getElementById(id + '-error');
        if (input) input.classList.remove('field-invalid');
        if (errEl) errEl.textContent = '';
    });
    const provSel = document.getElementById('addr-province');
    if (provSel) provSel.classList.remove('field-invalid');
    const provFb = document.getElementById('addr-province-fallback');
    if (provFb) provFb.classList.remove('field-invalid');
}

function showFieldError(fieldId, message) {
    const input = document.getElementById(fieldId);
    const errEl = document.getElementById(fieldId + '-error');
    if (input) input.classList.add('field-invalid');
    if (errEl) {
        errEl.textContent = message;
        errEl.style.display = 'block';
    }
}

function clearFieldError(fieldId) {
    const input = document.getElementById(fieldId);
    const errEl = document.getElementById(fieldId + '-error');
    if (input) input.classList.remove('field-invalid');
    if (errEl) errEl.textContent = '';
}

function editAddress(addressId) {
    fetch(`${window.contextPath}/api/address/${addressId}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => response.json())
        .then(address => {
            const modal = document.getElementById('address-modal');
            const title = document.getElementById('modal-title');

            clearAddressFormErrors();
            resetAddrDropdowns();

            document.getElementById('address-id').value = address.id;
            document.getElementById('receiver').value = address.receiver || '';
            document.getElementById('phone').value = address.phone || '';
            document.getElementById('addressDetail').value = address.addressDetail || '';
            document.getElementById('isDefault').checked = address.isDefault;

            const cityHidden = document.getElementById('city');
            const distHidden = document.getElementById('district');
            if (cityHidden) cityHidden.value = address.city || '';
            if (distHidden) distHidden.value = address.district || '';

            if (addrApiAvailable) {
                populateProvinceForEdit(address.city || '', address.district || '');
            } else {
                const provFb = document.getElementById('addr-province-fallback');
                const distFb = document.getElementById('addr-district-fallback');
                if (provFb) provFb.value = address.city || '';
                if (distFb) distFb.value = address.district || '';
            }

            title.textContent = 'Cập nhật địa chỉ';
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        })
        .catch(error => {
            console.error('Error fetching address:', error);
            showToast('Không thể tải thông tin địa chỉ', 'error');
        });
}

function saveAddress() {
    const form = document.getElementById('address-form');
    const addressId = document.getElementById('address-id').value;
    const saveBtn = form.querySelector('.btn-save');

    const receiver = document.getElementById('receiver').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const addressDetail = document.getElementById('addressDetail').value.trim();
    const isDefault = document.getElementById('isDefault').checked;

    let city = '';
    let district = '';
    let ward = '';
    if (addrApiAvailable) {
        const provSel = document.getElementById('addr-province');
        const distSel = document.getElementById('addr-district');
        const wardSel = document.getElementById('addr-ward');
        city = provSel ? provSel.value.trim() : '';
        district = distSel ? distSel.value.trim() : '';
        ward = wardSel ? wardSel.value.trim() : '';
        const cityH = document.getElementById('city');
        const distH = document.getElementById('district');
        if (cityH) cityH.value = city;
        if (distH) distH.value = district;
    } else {
        const provFb = document.getElementById('addr-province-fallback');
        const distFb = document.getElementById('addr-district-fallback');
        const wardFb = document.getElementById('addr-ward-fallback');
        city = provFb ? provFb.value.trim() : '';
        district = distFb ? distFb.value.trim() : '';
        ward = wardFb ? wardFb.value.trim() : '';
    }

    // Build full addressDetail: "Số nhà..." + ", Phường X" if ward chosen
    let fullAddressDetail = addressDetail;
    if (ward) fullAddressDetail += ', ' + ward;

    let hasError = false;
    clearAddressFormErrors();

    if (!receiver) {
        showFieldError('receiver', 'Vui lòng nhập họ tên người nhận');
        hasError = true;
    }

    if (!phone) {
        showFieldError('phone', 'Vui lòng nhập số điện thoại');
        hasError = true;
    } else if (!validatePhone(phone)) {
        showFieldError('phone', 'Số điện thoại không hợp lệ (VD: 0912345678)');
        hasError = true;
    }

    if (!addressDetail) {
        showFieldError('addressDetail', 'Vui lòng nhập địa chỉ cụ thể');
        hasError = true;
    }

    if (!city) {
        const provSel = document.getElementById('addr-province');
        const provFb = document.getElementById('addr-province-fallback');
        const activeEl = (addrApiAvailable && provSel) ? provSel : provFb;
        if (activeEl) activeEl.classList.add('field-invalid');
        const cityErr = document.getElementById('city-error');
        if (cityErr) { cityErr.textContent = 'Vui lòng chọn tỉnh/thành phố'; cityErr.style.display = 'block'; }
        hasError = true;
    }

    if (hasError) return;

    saveBtn.disabled = true;
    saveBtn.textContent = 'Đang lưu...';

    const formData = new URLSearchParams();
    formData.append('receiver', receiver);
    formData.append('phone', phone);
    formData.append('addressDetail', fullAddressDetail);
    formData.append('district', district);
    formData.append('city', city);
    formData.append('isDefault', isDefault ? 'true' : 'false');

    const isUpdate = addressId !== '';
    const url = isUpdate ?
        `${window.contextPath}/api/address/${addressId}` :
        `${window.contextPath}/api/address`;

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData.toString()
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                closeAddressModal();
                loadAddresses();
                showToast(isUpdate ? 'Đã cập nhật địa chỉ' : 'Đã thêm địa chỉ mới', 'success');
            } else {
                showToast(data.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error saving address:', error);
            showToast('Không thể lưu địa chỉ', 'error');
        })
        .finally(() => {
            saveBtn.disabled = false;
            saveBtn.textContent = 'Lưu địa chỉ';
        });
}

function setDefaultAddress(addressId) {
    fetch(`${window.contextPath}/api/address/${addressId}`, {
        method: 'GET'
    })
        .then(response => response.json())
        .then(address => {
            const formData = new URLSearchParams();
            formData.append('receiver', address.receiver || '');
            formData.append('phone', address.phone || '');
            formData.append('addressDetail', address.addressDetail || '');
            formData.append('district', address.district || '');
            formData.append('city', address.city || '');
            formData.append('isDefault', 'true');

            return fetch(`${window.contextPath}/api/address/${addressId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            });
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                loadAddresses();
                showToast('Đã thiết lập địa chỉ mặc định', 'success');
            } else {
                showToast(data.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error setting default:', error);
            showToast('Không thể thiết lập mặc định', 'error');
        });
}

let deleteAddressId = null;

function confirmDeleteAddress(addressId) {
    deleteAddressId = addressId;
    const modal = document.getElementById('confirm-modal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    const confirmBtn = document.getElementById('confirm-delete-btn');
    if (confirmBtn) {
        confirmBtn.onclick = function () {
            deleteAddress(deleteAddressId);
        };
    }
}

function closeConfirmModal() {
    const modal = document.getElementById('confirm-modal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
    deleteAddressId = null;
}

function deleteAddress(addressId) {
    fetch(`${window.contextPath}/api/address/${addressId}`, {
        method: 'DELETE'
    })
        .then(response => response.json())
        .then(data => {
            closeConfirmModal();
            if (data.success) {
                loadAddresses();
                showToast('Đã xóa địa chỉ', 'success');
            } else {
                showToast(data.message || 'Không thể xóa địa chỉ', 'error');
            }
        })
        .catch(error => {
            console.error('Error deleting address:', error);
            closeConfirmModal();
            showToast('Không thể xóa địa chỉ', 'error');
        });
}

function initPasswordForm() {
    const form = document.getElementById('password-form');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        e.preventDefault();

        const currentPassword = document.getElementById('current-password').value;
        const newPassword = document.getElementById('new-password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const submitBtn = form.querySelector('.btn-submit');

        if (!currentPassword || !newPassword || !confirmPassword) {
            showToast('Vui lòng điền đầy đủ thông tin', 'error');
            return;
        }

        if (newPassword !== confirmPassword) {
            showToast('Mật khẩu xác nhận không khớp', 'error');
            return;
        }

        if (newPassword.length < 6) {
            showToast('Mật khẩu mới phải có ít nhất 6 ký tự', 'error');
            return;
        }

        submitBtn.disabled = true;
        submitBtn.textContent = 'Đang xử lý...';

        const formData = new URLSearchParams();
        formData.append('currentPassword', currentPassword);
        formData.append('newPassword', newPassword);
        formData.append('confirmPassword', confirmPassword);

        fetch(`${window.contextPath}/api/user/change-password`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message || 'Đổi mật khẩu thành công', 'success');
                    form.reset();
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(error => {
                console.error('Error changing password:', error);
                showToast('Không thể đổi mật khẩu', 'error');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Đổi mật khẩu';
            });
    });
}

function toggleEditMode() {
    const viewMode = document.getElementById('profile-view-mode');
    const editMode = document.getElementById('profile-edit-mode');
    const editBtn = document.getElementById('btn-edit-profile');

    if (!viewMode || !editMode) return;

    viewMode.style.display = 'none';
    editMode.style.display = 'block';
    editBtn.style.display = 'none';

    const nameInput = document.getElementById('edit-name');
    if (nameInput) nameInput.focus();
}

function cancelEditMode() {
    const viewMode = document.getElementById('profile-view-mode');
    const editMode = document.getElementById('profile-edit-mode');
    const editBtn = document.getElementById('btn-edit-profile');

    if (!viewMode || !editMode) return;

    viewMode.style.display = 'block';
    editMode.style.display = 'none';
    editBtn.style.display = 'inline-flex';

    const displayName = document.getElementById('display-name');
    const displayPhone = document.getElementById('display-phone');
    const editName = document.getElementById('edit-name');
    const editPhone = document.getElementById('edit-phone');

    if (editName && displayName) editName.value = displayName.textContent.trim();
    if (editPhone && displayPhone) editPhone.value = displayPhone.textContent.trim();

    clearFieldError('edit-phone');
}

function initProfileForm() {
    const profileForm = document.getElementById('profile-edit-mode');
    if (!profileForm) return;

    profileForm.addEventListener('submit', function (e) {
        e.preventDefault();

        const nameInput = document.getElementById('edit-name');
        const phoneInput = document.getElementById('edit-phone');
        const saveBtn = document.getElementById('btn-save-profile');

        const name = nameInput ? nameInput.value.trim() : '';
        const phone = phoneInput ? phoneInput.value.trim() : '';

        let hasError = false;
        clearFieldError('edit-phone');

        if (!name) {
            showToast('Vui lòng nhập họ tên', 'error');
            if (nameInput) nameInput.focus();
            return;
        }

        if (phone && !validatePhone(phone)) {
            showFieldError('edit-phone', 'Số điện thoại không hợp lệ (VD: 0912345678)');
            if (phoneInput) phoneInput.focus();
            hasError = true;
        }

        if (hasError) return;

        if (saveBtn) {
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
        }

        fetch(`${window.contextPath}/api/user/update-profile`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                name: name,
                phone: phone
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Cập nhật thông tin thành công!', 'success');

                    const displayName = document.getElementById('display-name');
                    const displayPhone = document.getElementById('display-phone');
                    const sidebarName = document.getElementById('user-name-sidebar');

                    if (displayName) displayName.textContent = name;
                    if (displayPhone) displayPhone.textContent = phone || '';
                    if (sidebarName) sidebarName.textContent = name;

                    cancelEditMode();
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            })
            .catch(error => {
                console.error('Error updating profile:', error);
                showToast('Không thể cập nhật thông tin. Vui lòng thử lại.', 'error');
            })
            .finally(() => {
                if (saveBtn) {
                    saveBtn.disabled = false;
                    saveBtn.innerHTML = '<i class="fas fa-check"></i> Lưu thay đổi';
                }
            });
    });
}

function showToast(message, type = 'success') {
    const existingToast = document.querySelector('.toast');
    if (existingToast) existingToast.remove();

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        ${message}
    `;

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideInRight 0.3s ease reverse';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}


document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal')) {
        if (e.target.id === 'address-modal') {
            closeAddressModal();
        } else if (e.target.id === 'confirm-modal') {
            closeConfirmModal();
        }
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeAddressModal();
        closeConfirmModal();
    }
});


document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'wishlist') {
        loadWishlist();
    }
    
    const selectAllCb = document.getElementById('wishlist-select-all');
    if (selectAllCb) {
        selectAllCb.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.wishlist-item-checkbox');
            checkboxes.forEach(cb => {
                cb.checked = this.checked;
            });
            updateWishlistSelectionState();
        });
    }

    const btnDeleteSelected = document.getElementById('btn-delete-selected');
    if (btnDeleteSelected) {
        btnDeleteSelected.addEventListener('click', function() {
            deleteSelectedWishlistItems();
        });
    }
});

function updateWishlistSelectionState() {
    const checkboxes = document.querySelectorAll('.wishlist-item-checkbox');
    const selectAllCheckbox = document.getElementById('wishlist-select-all');
    const btnDeleteSelected = document.getElementById('btn-delete-selected');
    
    if (checkboxes.length === 0) {
        if(selectAllCheckbox) selectAllCheckbox.checked = false;
        if(btnDeleteSelected) btnDeleteSelected.disabled = true;
        return;
    }
    
    let checkedCount = 0;
    checkboxes.forEach(cb => {
        if (cb.checked) checkedCount++;
    });
    
    if(selectAllCheckbox) {
        selectAllCheckbox.checked = (checkedCount === checkboxes.length);
    }
    
    if(btnDeleteSelected) {
        btnDeleteSelected.disabled = (checkedCount === 0);
    }
}

function loadWishlist() {
    const container = document.getElementById('wishlist-container');
    const emptyState = document.getElementById('wishlist-empty');
    const toolbar = document.getElementById('wishlist-toolbar');
    if (!container) return;

    fetch((window.contextPath || '') + '/api/wishlist', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
    })
        .then(response => response.json())
        .then(data => {
            if (data.success && data.items && data.items.length > 0) {
                renderWishlistItems(data.items);
                container.style.display = 'grid';
                if (toolbar) toolbar.style.display = 'flex';
                if (emptyState) emptyState.style.display = 'none';
            } else {
                container.innerHTML = '';
                container.style.display = 'none';
                if (toolbar) toolbar.style.display = 'none';
                if (emptyState) emptyState.style.display = 'flex';
            }
            updateWishlistSelectionState();
        })
        .catch(error => {
            console.error('Error loading wishlist:', error);
            container.innerHTML = '<p class="error-msg">Có lỗi xảy ra khi tải wishlist</p>';
        });
}

function renderWishlistItems(items) {
    const container = document.getElementById('wishlist-container');
    if (!container) return;

    let html = '';
    items.forEach(item => {
        const product = item.product;
        if (!product) return;

        const imageUrl = product.imageUrl || (window.contextPath || '') + '/images/placeholder.png';
        const price = new Intl.NumberFormat('vi-VN').format(product.price) + 'đ';

        html += '<div class="wishlist-item" data-id="' + item.id + '">' +
            '<div class="wishlist-item-image">' +
            '<a href="' + (window.contextPath || '') + '/chi-tiet-san-pham?id=' + product.id + '">' +
            '<img src="' + imageUrl + '" alt="' + escapeHtml(product.name) + '">' +
            '</a>' +
            '</div>' +
            '<input type="checkbox" class="wishlist-item-checkbox" value="' + product.id + '" onchange="updateWishlistSelectionState()">' +
            '<div class="wishlist-item-info">' +
            '<a href="' + (window.contextPath || '') + '/chi-tiet-san-pham?id=' + product.id + '" class="wishlist-item-name">' +
            escapeHtml(product.name) +
            '</a>' +
            '<p class="wishlist-item-price">' + price + '</p>' +
            '</div>' +
            '</div>';
    });

    container.innerHTML = html;
}

function deleteSelectedWishlistItems() {
    const checkedBoxes = document.querySelectorAll('.wishlist-item-checkbox:checked');
    if (checkedBoxes.length === 0) return;
    
    if (!confirm('Bạn có chắc muốn xóa ' + checkedBoxes.length + ' sản phẩm đã chọn khỏi danh sách yêu thích?')) return;
    
    const productIds = Array.from(checkedBoxes).map(cb => cb.value).join(',');
    
    fetch((window.contextPath || '') + '/api/wishlist?productIds=' + productIds, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Đã xóa các sản phẩm khỏi yêu thích', 'success');
            loadWishlist();
            
            const badge = document.getElementById('wishlistCount');
            if (badge && data.wishlistCount !== undefined) {
                badge.textContent = data.wishlistCount;
                if (data.wishlistCount > 0) badge.classList.remove('badge-hidden');
                else badge.classList.add('badge-hidden');
            }
        } else {
            showToast(data.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error removing multiple from wishlist:', error);
        showToast('Không thể xóa sản phẩm', 'error');
    });
}
