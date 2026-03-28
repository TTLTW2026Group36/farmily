
document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    const currentTab = urlParams.get('tab');

    if (currentTab === 'address') {
        loadAddresses();
    }


    initAddressForm();
    initPasswordForm();
    initProfileForm();
});

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
}




function openAddressModal() {
    const modal = document.getElementById('address-modal');
    const form = document.getElementById('address-form');
    const title = document.getElementById('modal-title');

    if (!modal || !form) return;


    form.reset();
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


            document.getElementById('address-id').value = address.id;
            document.getElementById('receiver').value = address.receiver || '';
            document.getElementById('phone').value = address.phone || '';
            document.getElementById('addressDetail').value = address.addressDetail || '';
            document.getElementById('district').value = address.district || '';
            document.getElementById('city').value = address.city || '';
            document.getElementById('isDefault').checked = address.isDefault;

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


    const formData = new URLSearchParams();
    formData.append('receiver', document.getElementById('receiver').value.trim());
    formData.append('phone', document.getElementById('phone').value.trim());
    formData.append('addressDetail', document.getElementById('addressDetail').value.trim());
    formData.append('district', document.getElementById('district').value.trim());
    formData.append('city', document.getElementById('city').value.trim());
    formData.append('isDefault', document.getElementById('isDefault').checked ? 'true' : 'false');


    if (!formData.get('receiver') || !formData.get('addressDetail')) {
        showToast('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }


    saveBtn.disabled = true;
    saveBtn.textContent = 'Đang lưu...';

    const isUpdate = addressId !== '';
    const url = isUpdate ?
        `${window.contextPath}/api/address/${addressId}` :
        `${window.contextPath}/api/address`;

    fetch(url, {
        method: isUpdate ? 'PUT' : 'POST',
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
                method: 'PUT',
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




function showToast(message, type = 'success') {

    const existingToast = document.querySelector('.toast');
    if (existingToast) {
        existingToast.remove();
    }

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








function toggleEditMode() {
    const viewMode = document.getElementById('profile-view-mode');
    const editMode = document.getElementById('profile-edit-mode');
    const editBtn = document.getElementById('btn-edit-profile');

    if (!viewMode || !editMode) return;

    viewMode.style.display = 'none';
    editMode.style.display = 'block';
    editBtn.style.display = 'none';


    const nameInput = document.getElementById('edit-name');
    if (nameInput) {
        nameInput.focus();
    }
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

    if (editName && displayName) {
        editName.value = displayName.textContent.trim();
    }
    if (editPhone && displayPhone) {
        editPhone.value = displayPhone.textContent.trim();
    }
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


        if (!name) {
            showToast('Vui lòng nhập họ tên', 'error');
            nameInput.focus();
            return;
        }


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








document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'wishlist') {
        loadWishlist();
    }
});




function loadWishlist() {
    const container = document.getElementById('wishlist-container');
    const emptyState = document.getElementById('wishlist-empty');
    if (!container) return;

    fetch((window.contextPath || '') + '/api/wishlist', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
    })
        .then(response => response.json())
        .then(data => {
            console.log('[Wishlist] API Response:', data);
            if (data.success && data.items && data.items.length > 0) {
                renderWishlistItems(data.items);
                container.style.display = 'grid';
                if (emptyState) emptyState.style.display = 'none';
            } else {
                container.innerHTML = '';
                container.style.display = 'none';
                if (emptyState) emptyState.style.display = 'flex';
            }
        })
        .catch(error => {
            console.error('Error loading wishlist:', error);
            container.innerHTML = '<p class="error-msg">Co loi xay ra khi tai wishlist</p>';
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
        const price = new Intl.NumberFormat('vi-VN').format(product.price) + 'd';

        html += '<div class="wishlist-item" data-id="' + item.id + '">' +
            '<div class="wishlist-item-image">' +
            '<a href="' + (window.contextPath || '') + '/chi-tiet-san-pham?id=' + product.id + '">' +
            '<img src="' + imageUrl + '" alt="' + escapeHtml(product.name) + '">' +
            '</a>' +
            '</div>' +
            '<div class="wishlist-item-info">' +
            '<a href="' + (window.contextPath || '') + '/chi-tiet-san-pham?id=' + product.id + '" class="wishlist-item-name">' +
            escapeHtml(product.name) +
            '</a>' +
            '<p class="wishlist-item-price">' + price + '</p>' +
            '</div>' +
            '<button class="btn-remove-wishlist" onclick="removeFromWishlist(' + item.id + ', ' + product.id + ')" title="Xoa khoi yeu thich">' +
            '<i class="fas fa-times"></i>' +
            '</button>' +
            '</div>';
    });

    container.innerHTML = html;
}




function removeFromWishlist(wishlistId, productId) {
    if (!confirm('Ban co chac muon xoa san pham nay khoi danh sach yeu thich?')) return;

    fetch((window.contextPath || '') + '/api/wishlist?productId=' + productId, {
        method: 'DELETE'
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Da xoa khoi yeu thich', 'success');
                loadWishlist();

                const badge = document.getElementById('wishlistCount');
                if (badge && data.wishlistCount !== undefined) {
                    badge.textContent = data.wishlistCount;
                    if (data.wishlistCount > 0) badge.classList.remove('badge-hidden');
                    else badge.classList.add('badge-hidden');
                }
            } else {
                showToast(data.message || 'Co loi xay ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error removing from wishlist:', error);
            showToast('Khong the xoa san pham', 'error');
        });
}
