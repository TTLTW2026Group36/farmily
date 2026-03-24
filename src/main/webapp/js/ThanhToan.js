(() => {
  'use strict';

  
  
  
  const PROVINCE_API = 'https://provinces.open-api.vn/api/';
  let apiAvailable = true;

  
  async function loadProvinces() {
    const provinceSelect = document.getElementById('province');
    if (!provinceSelect) return;

    try {
      const response = await fetch(PROVINCE_API + '?depth=1');
      if (!response.ok) throw new Error('API Error');

      const provinces = await response.json();
      provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
      provinces.forEach(p => {
        const option = document.createElement('option');
        option.value = p.name;
        option.dataset.code = p.code;
        option.textContent = p.name;
        provinceSelect.appendChild(option);
      });
      apiAvailable = true;
    } catch (error) {
      console.warn('Province API failed, switching to fallback:', error);
      switchToFallbackInputs();
    }
  }

  
  async function loadDistricts(provinceCode) {
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');
    if (!districtSelect || !apiAvailable) return;

    districtSelect.disabled = true;
    districtSelect.innerHTML = '<option value="">Đang tải...</option>';
    wardSelect.disabled = true;
    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

    try {
      const response = await fetch(PROVINCE_API + 'p/' + provinceCode + '?depth=2');
      if (!response.ok) throw new Error('API Error');

      const data = await response.json();
      districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
      data.districts.forEach(d => {
        const option = document.createElement('option');
        option.value = d.name;
        option.dataset.code = d.code;
        option.textContent = d.name;
        districtSelect.appendChild(option);
      });
      districtSelect.disabled = false;
    } catch (error) {
      console.warn('Districts API failed:', error);
      districtSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
    }
  }

  
  async function loadWards(districtCode) {
    const wardSelect = document.getElementById('ward');
    if (!wardSelect || !apiAvailable) return;

    wardSelect.disabled = true;
    wardSelect.innerHTML = '<option value="">Đang tải...</option>';

    try {
      const response = await fetch(PROVINCE_API + 'd/' + districtCode + '?depth=2');
      if (!response.ok) throw new Error('API Error');

      const data = await response.json();
      wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
      data.wards.forEach(w => {
        const option = document.createElement('option');
        option.value = w.name;
        option.textContent = w.name;
        wardSelect.appendChild(option);
      });
      wardSelect.disabled = false;
    } catch (error) {
      console.warn('Wards API failed:', error);
      wardSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
    }
  }

  
  function switchToFallbackInputs() {
    apiAvailable = false;
    ['province', 'district', 'ward'].forEach(field => {
      const select = document.getElementById(field);
      const fallback = document.getElementById(field + '-fallback');
      if (select && fallback) {
        select.style.display = 'none';
        select.removeAttribute('required');
        select.name = field + '-select';
        fallback.style.display = 'block';
        fallback.name = field;
        if (field !== 'ward') fallback.setAttribute('required', 'required');
      }
    });
  }

  
  
  
  function setupAddressBook() {
    const addressBook = document.getElementById('addressBook');
    if (!addressBook) return;

    addressBook.addEventListener('change', function () {
      const selected = this.options[this.selectedIndex];
      if (this.value === 'new') {
        document.getElementById('fullname').value = window.userName || '';
        document.getElementById('street').value = '';
        document.getElementById('province').value = '';
        document.getElementById('district').value = '';
        document.getElementById('ward').value = '';
        toggleAddressFields(false);
      } else {
        document.getElementById('fullname').value = selected.dataset.receiver || '';
        document.getElementById('street').value = selected.dataset.detail || '';
        if (apiAvailable) {
          const provinceSelect = document.getElementById('province');
          const savedCity = selected.dataset.city;
          for (let opt of provinceSelect.options) {
            if (opt.value === savedCity) {
              opt.selected = true;
              break;
            }
          }
        } else {
          const provinceFallback = document.getElementById('province-fallback');
          const districtFallback = document.getElementById('district-fallback');
          if (provinceFallback) provinceFallback.value = selected.dataset.city || '';
          if (districtFallback) districtFallback.value = selected.dataset.district || '';
        }
      }
    });
  }

  function toggleAddressFields(disabled) {
    ['street', 'province', 'district', 'ward'].forEach(field => {
      const el = document.getElementById(field);
      const fallback = document.getElementById(field + '-fallback');
      if (el) el.disabled = disabled;
      if (fallback) fallback.disabled = disabled;
    });
  }

  
  
  
  function validateForm() {
    const required = [
      { id: 'email', name: 'Email' },
      { id: 'fullname', name: 'Họ và tên' },
      { id: 'phone', name: 'Số điện thoại' },
      { id: 'street', name: 'Địa chỉ' }
    ];

    for (const field of required) {
      const el = document.getElementById(field.id);
      const val = el ? el.value : '';
      console.log('Validating:', field.id, '=', val);
      if (!el || !val || val.trim() === '') {
        showError('Vui lòng nhập ' + field.name);
        if (el) el.focus();
        return false;
      }
    }

    
    const email = document.getElementById('email').value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      showError('Email không hợp lệ');
      document.getElementById('email').focus();
      return false;
    }

    
    const phone = document.getElementById('phone').value.trim().replace(/\s+/g, '');
    const phoneRegex = /^0[0-9]{9,10}$/;
    if (!phoneRegex.test(phone)) {
      showError('Số điện thoại không hợp lệ (VD: 0901234567)');
      document.getElementById('phone').focus();
      return false;
    }

    
    const province = document.getElementById('province');
    const provinceFallback = document.getElementById('province-fallback');
    let provinceValue = '';
    if (apiAvailable && province) {
      provinceValue = province.value;
    } else if (provinceFallback) {
      provinceValue = provinceFallback.value;
    }

    if (!provinceValue || provinceValue.trim() === '') {
      showError('Vui lòng chọn Tỉnh/Thành');
      return false;
    }

    return true;
  }

  
  
  
  async function placeOrder() {
    console.log('=== PLACE ORDER STARTED ===');

    if (!validateForm()) {
      console.log('Validation failed');
      return;
    }
    console.log('Validation passed');

    const placeOrderBtn = document.getElementById('placeOrder');
    const originalText = placeOrderBtn.innerHTML;

    placeOrderBtn.disabled = true;
    placeOrderBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

    try {
      
      const params = new URLSearchParams();
      params.append('email', document.getElementById('email').value.trim());
      params.append('fullname', document.getElementById('fullname').value.trim());
      params.append('phone', document.getElementById('phone').value.trim());
      params.append('street', document.getElementById('street').value.trim());

      const noteEl = document.getElementById('note');
      params.append('note', noteEl ? noteEl.value.trim() : '');

      
      if (apiAvailable) {
        const prov = document.getElementById('province');
        const dist = document.getElementById('district');
        const ward = document.getElementById('ward');
        params.append('province', prov ? prov.value : '');
        params.append('district', dist ? dist.value : '');
        params.append('ward', ward ? ward.value : '');
      } else {
        const provFb = document.getElementById('province-fallback');
        const distFb = document.getElementById('district-fallback');
        const wardFb = document.getElementById('ward-fallback');
        params.append('province', provFb ? provFb.value : '');
        params.append('district', distFb ? distFb.value : '');
        params.append('ward', wardFb ? wardFb.value : '');
      }

      
      const paymentRadio = document.querySelector('input[name="payment"]:checked');
      params.append('payment', paymentRadio ? paymentRadio.value : '1');

      
      const addressBook = document.getElementById('addressBook');
      if (addressBook && addressBook.value !== 'new') {
        params.append('addressId', addressBook.value);
      }

      
      const url = window.contextPath + '/place-order';
      console.log('Sending to:', url);
      for (const [key, value] of params.entries()) {
        console.log('  ' + key + ' = ' + value);
      }

      
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
      });

      console.log('Response status:', response.status);
      const responseText = await response.text();
      console.log('Response body:', responseText);

      let result;
      try {
        result = JSON.parse(responseText);
      } catch (e) {
        console.error('JSON parse error:', e);
        showError('Lỗi server: ' + responseText.substring(0, 200));
        placeOrderBtn.disabled = false;
        placeOrderBtn.innerHTML = originalText;
        return;
      }

      if (result.success) {
        showSuccess('Đặt hàng thành công!');
        setTimeout(() => {
          window.location.href = window.contextPath + '/order-confirmation?id=' + result.orderId;
        }, 1000);
      } else {
        showError(result.message || 'Có lỗi xảy ra, vui lòng thử lại');
        placeOrderBtn.disabled = false;
        placeOrderBtn.innerHTML = originalText;
      }

    } catch (error) {
      console.error('Place order error:', error);
      showError('Lỗi kết nối: ' + (error.message || 'Vui lòng thử lại'));
      placeOrderBtn.disabled = false;
      placeOrderBtn.innerHTML = originalText;
    }
  }

  
  
  
  function showError(message) {
    removeNotifications();
    const notification = document.createElement('div');
    notification.className = 'checkout-notification error';
    notification.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
    const checkoutInfo = document.querySelector('.checkout-info');
    if (checkoutInfo) {
      checkoutInfo.prepend(notification);
    }
    setTimeout(() => notification.remove(), 5000);
  }

  function showSuccess(message) {
    removeNotifications();
    const notification = document.createElement('div');
    notification.className = 'checkout-notification success';
    notification.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
    const checkoutInfo = document.querySelector('.checkout-info');
    if (checkoutInfo) {
      checkoutInfo.prepend(notification);
    }
  }

  function removeNotifications() {
    document.querySelectorAll('.checkout-notification').forEach(n => n.remove());
  }

  
  
  
  function setupEventListeners() {
    const provinceSelect = document.getElementById('province');
    if (provinceSelect) {
      provinceSelect.addEventListener('change', function () {
        const selected = this.options[this.selectedIndex];
        if (selected.dataset.code) {
          loadDistricts(selected.dataset.code);
        }
      });
    }

    const districtSelect = document.getElementById('district');
    if (districtSelect) {
      districtSelect.addEventListener('change', function () {
        const selected = this.options[this.selectedIndex];
        if (selected.dataset.code) {
          loadWards(selected.dataset.code);
        }
      });
    }

    const placeOrderBtn = document.getElementById('placeOrder');
    if (placeOrderBtn) {
      placeOrderBtn.addEventListener('click', placeOrder);
    }

    setupAddressBook();
  }

  
  
  
  function injectStyles() {
    const style = document.createElement('style');
    style.textContent = `
      .checkout-notification {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 16px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
        animation: slideIn 0.3s ease;
      }
      .checkout-notification.error {
        background: #fef2f2;
        color: #dc2626;
        border: 1px solid #fecaca;
      }
      .checkout-notification.success {
        background: #f0fdf4;
        color: #16a34a;
        border: 1px solid #bbf7d0;
      }
      .free-ship-notice {
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
        padding: 12px 16px;
        border-radius: 8px;
        margin: 16px 0;
        font-size: 13px;
        color: #92400e;
        text-align: center;
      }
      .free-ship-notice i {
        margin-right: 8px;
      }
      .free-shipping {
        color: #16a34a;
        font-weight: 600;
      }
      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateY(-10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
    `;
    document.head.appendChild(style);
  }

  
  
  
  document.addEventListener('DOMContentLoaded', function () {
    injectStyles();
    loadProvinces();
    setupEventListeners();
  });

})();