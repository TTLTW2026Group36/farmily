(() => {
  'use strict';

  const GHN_API = window.ghnApiBase || (window.contextPath + '/api/ghn');
  let apiAvailable = true;
  window.currentShippingFee = 0;


  async function loadProvinces() {
    const provinceSelect = document.getElementById('province');
    if (!provinceSelect) return;

    try {
      const response = await fetch(GHN_API + '/provinces');
      if (!response.ok) throw new Error('API Error');

      const result = await response.json();
      const provinces = result.data || [];
      provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
      provinces.forEach(p => {
        const option = document.createElement('option');
        option.value = p.ProvinceID;
        option.dataset.name = p.ProvinceName;
        option.textContent = p.ProvinceName;
        provinceSelect.appendChild(option);
      });
      apiAvailable = true;
    } catch (error) {
      console.warn('GHN Province API failed, switching to fallback:', error);
      switchToFallbackInputs();
    }
  }

  async function loadDistricts(provinceId, targetDistrictId, targetWardId) {
    const districtSelect = document.getElementById(targetDistrictId || 'district');
    const wardSelect = document.getElementById(targetWardId || 'ward');
    if (!districtSelect || !apiAvailable) return;

    districtSelect.disabled = true;
    districtSelect.innerHTML = '<option value="">Đang tải...</option>';
    if (wardSelect) {
      wardSelect.disabled = true;
      wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
    }

    try {
      const response = await fetch(GHN_API + '/districts?provinceId=' + provinceId);
      if (!response.ok) throw new Error('API Error');

      const result = await response.json();
      const districts = result.data || [];
      districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
      districts.forEach(d => {
        const option = document.createElement('option');
        option.value = d.DistrictID;
        option.dataset.name = d.DistrictName;
        option.textContent = d.DistrictName;
        districtSelect.appendChild(option);
      });
      districtSelect.disabled = false;
    } catch (error) {
      console.warn('GHN Districts API failed:', error);
      districtSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
    }

    updateShippingDisplay(null);
  }

  async function loadWards(districtId, targetWardId) {
    const wardSelect = document.getElementById(targetWardId || 'ward');
    if (!wardSelect || !apiAvailable) return;

    wardSelect.disabled = true;
    wardSelect.innerHTML = '<option value="">Đang tải...</option>';

    try {
      const response = await fetch(GHN_API + '/wards?districtId=' + districtId);
      if (!response.ok) throw new Error('API Error');

      const result = await response.json();
      const wards = result.data || [];
      wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
      wards.forEach(w => {
        const option = document.createElement('option');
        option.value = w.WardCode;
        option.dataset.name = w.WardName;
        option.textContent = w.WardName;
        wardSelect.appendChild(option);
      });
      wardSelect.disabled = false;
    } catch (error) {
      console.warn('GHN Wards API failed:', error);
      wardSelect.innerHTML = '<option value="">-- Lỗi tải dữ liệu --</option>';
    }
  }

  async function calculateShippingFee() {
    const districtSelect = document.getElementById('district');
    const wardSelect = document.getElementById('ward');

    if (!districtSelect || !wardSelect) return;

    const districtId = districtSelect.value;
    const wardCode = wardSelect.value;

    if (!districtId || !wardCode) {
      updateShippingDisplay(null);
      return;
    }

    const ghnDistrictInput = document.getElementById('ghnDistrictId');
    const ghnWardInput = document.getElementById('ghnWardCode');
    if (ghnDistrictInput) ghnDistrictInput.value = districtId;
    if (ghnWardInput) ghnWardInput.value = wardCode;

    updateShippingDisplay('loading');

    try {
      const params = new URLSearchParams();
      params.append('toDistrictId', districtId);
      params.append('toWardCode', wardCode);
      params.append('insuranceValue', window.subtotal || 0);

      const response = await fetch(GHN_API + '/calculate-fee', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      });

      const result = await response.json();
      if (result.success) {
        updateShippingDisplay(result.shippingFee);
      } else {
        updateShippingDisplay('error', result.message || 'Không thể tính phí');
      }
    } catch (error) {
      console.error('Calculate fee error:', error);
      updateShippingDisplay('error', 'Không thể tính phí vận chuyển');
    }
  }

  function updateShippingDisplay(fee, errorMsg) {
    const shippingText = document.getElementById('shippingFeeText');
    const grandTotal = document.getElementById('grandTotalText');
    const subtotalVal = window.subtotal || 0;

    if (fee === null) {
      if (shippingText) shippingText.innerHTML = '<span style="color:#999">Chọn địa chỉ để tính phí</span>';
      if (grandTotal) grandTotal.innerHTML = new Intl.NumberFormat('vi-VN').format(subtotalVal) + 'đ';
      window.currentShippingFee = 0;
    } else if (fee === 'loading') {
      if (shippingText) shippingText.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tính...';
    } else if (fee === 'error') {
      if (shippingText) shippingText.innerHTML = '<span style="color:#d32f2f">' + (errorMsg || 'Lỗi') + '</span>';
      window.currentShippingFee = 0;
    } else {
      if (shippingText) shippingText.innerHTML = new Intl.NumberFormat('vi-VN').format(fee) + 'đ';
      if (grandTotal) grandTotal.innerHTML = new Intl.NumberFormat('vi-VN').format(subtotalVal + fee) + 'đ';
      window.currentShippingFee = fee;
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
    const trigger = document.getElementById('addressSelectTrigger');
    const wrapper = document.getElementById('addressSelector');
    const options = document.querySelectorAll('.address-option-item');
    const hiddenInput = document.getElementById('selectedAddressId');
    const manualFields = document.getElementById('manualAddressFields');

    if (!trigger || !wrapper) return;

    trigger.addEventListener('click', (e) => {
      e.stopPropagation();
      wrapper.classList.toggle('open');
    });

    document.addEventListener('click', () => {
      wrapper.classList.remove('open');
    });

    let selectedItem = null;
    options.forEach(opt => {
      if (opt.classList.contains('selected')) {
        selectedItem = opt;
      }
      opt.addEventListener('click', (e) => {
        e.stopPropagation();
        selectAddressOption(opt);
        wrapper.classList.remove('open');
      });
    });

    if (selectedItem) {
      selectAddressOption(selectedItem);
    } else if (options.length > 0) {
      selectAddressOption(options[0]);
    }

    if (manualFields && options.length > 0) {
      manualFields.style.display = 'none';
    }
  }

  function selectAddressOption(opt) {
    const options = document.querySelectorAll('.address-option-item');
    const hiddenInput = document.getElementById('selectedAddressId');

    options.forEach(o => o.classList.remove('selected'));
    opt.classList.add('selected');

    if (hiddenInput) hiddenInput.value = opt.dataset.addressId;
    updateSelectedDisplay(opt);
    fillFormFromOption(opt);

    const ghnDistrictId = opt.dataset.ghnDistrictId;
    const ghnWardCode = opt.dataset.ghnWardCode;
    const ghnDistrictInput = document.getElementById('ghnDistrictId');
    const ghnWardInput = document.getElementById('ghnWardCode');
    if (ghnDistrictInput) ghnDistrictInput.value = ghnDistrictId || '';
    if (ghnWardInput) ghnWardInput.value = ghnWardCode || '';

    if (ghnDistrictId && ghnWardCode && ghnDistrictId !== 'null' && ghnWardCode !== 'null') {
      calculateShippingFeeFromSaved(ghnDistrictId, ghnWardCode);
    } else {
      updateShippingDisplay('error', 'Vui lòng cập nhật địa chỉ để tính phí ship');
    }
  }

  async function calculateShippingFeeFromSaved(districtId, wardCode) {
    updateShippingDisplay('loading');
    try {
      const params = new URLSearchParams();
      params.append('toDistrictId', districtId);
      params.append('toWardCode', wardCode);
      params.append('insuranceValue', window.subtotal || 0);

      const response = await fetch(GHN_API + '/calculate-fee', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      });

      const result = await response.json();
      if (result.success) {
        updateShippingDisplay(result.shippingFee);
      } else {
        updateShippingDisplay('error', result.message || 'Không thể tính phí');
      }
    } catch (error) {
      console.error('Calculate fee from saved address error:', error);
      updateShippingDisplay('error', 'Không thể tính phí vận chuyển');
    }
  }

  function updateSelectedDisplay(opt) {
    const display = document.getElementById('selectedAddressDisplay');
    if (!display) return;

    const name = opt.dataset.receiver || '';
    const phone = opt.dataset.phone || '';
    const full = opt.dataset.full || '';

    display.innerHTML = `
      <div class="name-phone">${escapeHtml(name)} | ${escapeHtml(phone)}</div>
      <div class="full-addr">${escapeHtml(full)}</div>
    `;
  }

  function fillFormFromOption(opt) {
    const fullname = document.getElementById('fullname');
    const phone = document.getElementById('phone');
    const street = document.getElementById('street');

    if (fullname) fullname.value = opt.dataset.receiver || '';
    if (phone) phone.value = opt.dataset.phone || '';
    if (street) street.value = opt.dataset.detail || '';
  }


  function setupModal() {
    const overlay = document.getElementById('addressModalOverlay');
    if (!overlay) return;

    const openBtns = [
      document.getElementById('btnOpenAddressModal'),
      document.getElementById('btnOpenAddressModalEmpty')
    ].filter(Boolean);

    const closeBtns = [
      document.getElementById('btnCloseModal'),
      document.getElementById('btnCancelModal')
    ].filter(Boolean);

    openBtns.forEach(btn => btn.addEventListener('click', openModal));
    closeBtns.forEach(btn => btn.addEventListener('click', closeModal));

    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) closeModal();
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && overlay.classList.contains('active')) closeModal();
    });

    const form = document.getElementById('addressModalForm');
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        submitNewAddress();
      });
    }

    const modalProvince = document.getElementById('modalProvince');
    const modalDistrict = document.getElementById('modalDistrict');

    if (modalProvince) {
      loadModalProvinces();
      modalProvince.addEventListener('change', function () {
        if (this.value) {
          loadDistricts(this.value, 'modalDistrict', 'modalWard');
        }
      });
    }

    if (modalDistrict) {
      modalDistrict.addEventListener('change', function () {
        if (this.value) {
          loadWards(this.value, 'modalWard');
        }
      });
    }
  }

  async function loadModalProvinces() {
    const select = document.getElementById('modalProvince');
    if (!select) return;

    try {
      const response = await fetch(GHN_API + '/provinces');
      if (!response.ok) throw new Error('API Error');

      const result = await response.json();
      const provinces = result.data || [];
      select.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
      provinces.forEach(p => {
        const option = document.createElement('option');
        option.value = p.ProvinceID;
        option.dataset.name = p.ProvinceName;
        option.textContent = p.ProvinceName;
        select.appendChild(option);
      });
    } catch (error) {
      console.warn('Modal province API failed:', error);
    }
  }

  function openModal() {
    const overlay = document.getElementById('addressModalOverlay');
    if (overlay) {
      overlay.classList.add('active');
      document.body.style.overflow = 'hidden';
      const firstInput = document.getElementById('modalReceiver');
      if (firstInput) setTimeout(() => firstInput.focus(), 100);
    }
  }

  function closeModal() {
    const overlay = document.getElementById('addressModalOverlay');
    if (overlay) {
      overlay.classList.remove('active');
      document.body.style.overflow = '';
      resetModalForm();
    }
  }

  function resetModalForm() {
    const form = document.getElementById('addressModalForm');
    if (form) form.reset();

    const modalDistrict = document.getElementById('modalDistrict');
    const modalWard = document.getElementById('modalWard');
    if (modalDistrict) {
      modalDistrict.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
      modalDistrict.disabled = true;
    }
    if (modalWard) {
      modalWard.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
      modalWard.disabled = true;
    }

    const modalError = document.getElementById('modalError');
    if (modalError) {
      modalError.display = 'none';
      modalError.textContent = '';
    }

    document.querySelectorAll('#addressModalForm .input-error').forEach(el => {
      el.classList.remove('input-error');
    });
  }

  async function submitNewAddress() {
    const receiver = document.getElementById('modalReceiver');
    const phone = document.getElementById('modalPhone');
    const province = document.getElementById('modalProvince');
    const district = document.getElementById('modalDistrict');
    const ward = document.getElementById('modalWard');
    const detail = document.getElementById('modalDetail');

    [receiver, phone, province, district, ward, detail].forEach(el => {
      if (el) el.classList.remove('input-error');
    });

    let valid = true;
    if (!receiver.value.trim()) { receiver.classList.add('input-error'); valid = false; }
    if (!phone.value.trim()) { phone.classList.add('input-error'); valid = false; }
    if (!province.value) { province.classList.add('input-error'); valid = false; }
    if (district && !district.value && !district.disabled) { district.classList.add('input-error'); valid = false; }
    if (ward && !ward.value && !ward.disabled && ward.options.length > 1) { ward.classList.add('input-error'); valid = false; }
    if (!detail.value.trim()) { detail.classList.add('input-error'); valid = false; }

    const modalError = document.getElementById('modalError');
    if (modalError) {
      modalError.style.display = 'none';
      modalError.textContent = '';
    }

    if (phone.value.trim()) {
      const phoneClean = phone.value.trim().replace(/\s+/g, '');
      if (!/^0[0-9]{9,10}$/.test(phoneClean)) {
        phone.classList.add('input-error');
        showModalError('Số điện thoại không hợp lệ');
        return;
      }
    }

    if (!valid) {
      showModalError('Vui lòng điền đầy đủ thông tin bắt buộc');
      return;
    }

    const saveBtn = document.getElementById('btnSaveAddress');
    const originalText = saveBtn.innerHTML;
    saveBtn.disabled = true;
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';

    try {
      const params = new URLSearchParams();
      params.append('receiver', receiver.value.trim());
      params.append('phone', phone.value.trim());
      params.append('city', province.options[province.selectedIndex].dataset.name || province.value);
      params.append('district', district ? (district.options[district.selectedIndex].dataset.name || district.value) : '');
      params.append('addressDetail', detail.value.trim());
      if (district) params.append('ghnDistrictId', district.value || '');
      const wardEl = document.getElementById('modalWard');
      if (wardEl) params.append('ghnWardCode', wardEl.value || '');

      const wardVal = ward ? ward.value : '';
      let fullDetail = detail.value.trim();
      if (wardVal) fullDetail += ', ' + wardVal;

      const response = await fetch(window.contextPath + '/api/address', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      });

      const result = await response.json();

      if (result.success && result.address) {
        const addr = result.address;
        addAddressCard(addr);
        closeModal();
        showSuccess('Đã thêm địa chỉ mới');
      } else {
        showModalError(result.message || 'Không thể tạo địa chỉ');
      }
    } catch (error) {
      console.error('Create address error:', error);
      showModalError('Lỗi kết nối, vui lòng thử lại');
    } finally {
      saveBtn.disabled = false;
      saveBtn.innerHTML = originalText;
    }
  }

  function showModalError(message) {
    const errorDiv = document.getElementById('modalError');
    if (errorDiv) {
      errorDiv.textContent = message;
      errorDiv.style.display = 'block';
      errorDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }

  function addAddressCard(addr) {
    const listContainer = document.querySelector('.address-options-list');
    const emptyState = document.querySelector('.address-placeholder-box');
    const section = document.getElementById('addressBookSection');

    if (emptyState) {
      emptyState.remove();
    }

    if (!listContainer) {
      if (section) {
        section.innerHTML = `
          <div class="address-book-header">
            <h2><i class="fas fa-map-marker-alt"></i> Địa chỉ giao hàng</h2>
            <button type="button" class="btn-add-address-sm" id="btnOpenAddressModal">
              <i class="fas fa-plus"></i> Thêm địa chỉ mới
            </button>
          </div>
          <div class="address-selector" id="addressSelector">
            <div class="address-selected-box" id="addressSelectTrigger">
              <div class="selected-content" id="selectedAddressDisplay"></div>
              <i class="fas fa-chevron-down arrow-icon"></i>
            </div>
            <div class="address-options-wrapper">
              <div class="address-options-list"></div>
            </div>
          </div>
        `;
        setupAddressBook();
        setupModal();
      }
    }

    const container = document.querySelector('.address-options-list');
    if (!container) return;

    const fullAddress = [addr.addressDetail, addr.district, addr.city].filter(Boolean).join(', ');

    const item = document.createElement('div');
    item.className = 'address-option-item';
    item.dataset.addressId = addr.id;
    item.dataset.receiver = addr.receiver || '';
    item.dataset.phone = addr.phone || '';
    item.dataset.detail = addr.addressDetail || '';
    item.dataset.district = addr.district || '';
    item.dataset.city = addr.city || '';
    item.dataset.full = fullAddress;
    item.dataset.ghnDistrictId = addr.ghnDistrictId || '';
    item.dataset.ghnWardCode = addr.ghnWardCode || '';

    item.innerHTML = `
      <div class="option-check"><i class="fas fa-check"></i></div>
      <div class="option-info">
        <div class="option-top">
          <span class="option-name">${escapeHtml(addr.receiver || '')}</span>
          <span class="option-divider">|</span>
          <span class="option-phone">${escapeHtml(addr.phone || '')}</span>
        </div>
        <p class="option-address-text">${escapeHtml(fullAddress)}</p>
      </div>
    `;

    item.addEventListener('click', (e) => {
      e.stopPropagation();
      selectAddressOption(item);
      document.getElementById('addressSelector').classList.remove('open');
    });

    container.appendChild(item);
    selectAddressOption(item);

    const manualFields = document.getElementById('manualAddressFields');
    if (manualFields) manualFields.style.display = 'none';
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function validateForm() {
    const addressId = document.getElementById('selectedAddressId');
    if (window.isLoggedIn && addressId && addressId.value && addressId.value !== '') {
      return true;
    }

    const required = [
      { id: 'email', name: 'Email' },
      { id: 'fullname', name: 'Họ và tên' },
      { id: 'phone', name: 'Số điện thoại' },
      { id: 'street', name: 'Địa chỉ' }
    ];

    for (const field of required) {
      const el = document.getElementById(field.id);
      const val = el ? el.value : '';
      if (!el || !val || val.trim() === '') {
        showError('Vui lòng nhập ' + field.name);
        if (el) el.focus();
        return false;
      }
    }

    const email = document.getElementById('email').value.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showError('Email không hợp lệ');
      document.getElementById('email').focus();
      return false;
    }

    const phone = document.getElementById('phone').value.trim().replace(/\s+/g, '');
    if (!/^0[0-9]{9,10}$/.test(phone)) {
      showError('Số điện thoại không hợp lệ (VD: 0901234567)');
      document.getElementById('phone').focus();
      return false;
    }

    if (apiAvailable) {
      const province = document.getElementById('province');
      const district = document.getElementById('district');
      const ward = document.getElementById('ward');
      
      if (province && (!province.value || province.value.trim() === '')) {
        showError('Vui lòng chọn Tỉnh/Thành');
        return false;
      }
      if (district && (!district.value || district.value.trim() === '')) {
        showError('Vui lòng chọn Quận/Huyện');
        return false;
      }
      if (ward && !ward.disabled && ward.options.length > 1 && (!ward.value || ward.value.trim() === '')) {
        showError('Vui lòng chọn Phường/Xã');
        return false;
      }
    } else {
      const provinceFb = document.getElementById('province-fallback');
      const districtFb = document.getElementById('district-fallback');
      const wardFb = document.getElementById('ward-fallback');
      
      if (provinceFb && (!provinceFb.value || provinceFb.value.trim() === '')) {
        showError('Vui lòng nhập Tỉnh/Thành');
        return false;
      }
      if (districtFb && (!districtFb.value || districtFb.value.trim() === '')) {
        showError('Vui lòng nhập Quận/Huyện');
        return false;
      }
      if (wardFb && (!wardFb.value || wardFb.value.trim() === '')) {
        showError('Vui lòng nhập Phường/Xã');
        return false;
      }
    }

    return true;
  }


  async function placeOrder() {
    if (!validateForm()) return;

    const placeOrderBtn = document.getElementById('placeOrder');
    const originalText = placeOrderBtn.innerHTML;

    placeOrderBtn.disabled = true;
    placeOrderBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';

    try {
      const params = new URLSearchParams();
      const addressId = document.getElementById('selectedAddressId');

      if (window.isLoggedIn && addressId && addressId.value) {
        params.append('addressId', addressId.value);

        params.append('email', window.userEmail || '');
        params.append('fullname', document.getElementById('fullname') ? document.getElementById('fullname').value.trim() : (window.userName || ''));
        params.append('phone', document.getElementById('phone') ? document.getElementById('phone').value.trim() : (window.userPhone || ''));

        const selectedOpt = document.querySelector('.address-option-item.selected');
        if (selectedOpt) {
          params.append('street', selectedOpt.dataset.detail || '');
          params.append('province', selectedOpt.dataset.city || '');
          params.append('district', selectedOpt.dataset.district || '');
          params.append('ward', '');
          params.append('ghnDistrictId', selectedOpt.dataset.ghnDistrictId || '');
          params.append('ghnWardCode', selectedOpt.dataset.ghnWardCode || '');
        }
      } else {
        params.append('email', document.getElementById('email').value.trim());
        params.append('fullname', document.getElementById('fullname').value.trim());
        params.append('phone', document.getElementById('phone').value.trim());
        params.append('street', document.getElementById('street').value.trim());

        if (apiAvailable) {
          const prov = document.getElementById('province');
          const dist = document.getElementById('district');
          const ward = document.getElementById('ward');
          params.append('province', prov && prov.options[prov.selectedIndex] ? (prov.options[prov.selectedIndex].dataset.name || '') : '');
          params.append('district', dist && dist.options[dist.selectedIndex] ? (dist.options[dist.selectedIndex].dataset.name || '') : '');
          params.append('ward', ward && ward.options[ward.selectedIndex] ? (ward.options[ward.selectedIndex].dataset.name || '') : '');
          params.append('ghnDistrictId', dist ? dist.value : '');
          params.append('ghnWardCode', ward ? ward.value : '');
        } else {
          const provFb = document.getElementById('province-fallback');
          const distFb = document.getElementById('district-fallback');
          const wardFb = document.getElementById('ward-fallback');
          params.append('province', provFb ? provFb.value : '');
          params.append('district', distFb ? distFb.value : '');
          params.append('ward', wardFb ? wardFb.value : '');
        }
      }

      const noteEl = document.getElementById('note');
      params.append('note', noteEl ? noteEl.value.trim() : '');

      const paymentRadio = document.querySelector('input[name="payment"]:checked');
      params.append('payment', paymentRadio ? paymentRadio.value : '1');

      const isBuyNowInput = document.querySelector('input[name="isBuyNow"]');
      if (isBuyNowInput) {
        params.append('isBuyNow', isBuyNowInput.value);
      }

      const extraCb = document.getElementById('extraProductCb');
      if (extraCb && extraCb.checked) {
        params.append('extraProductId', extraCb.value);
        const extraVarId = document.getElementById('extraVariantId');
        if (extraVarId && extraVarId.value) {
            params.append('extraVariantId', extraVarId.value);
        }
        const extraQty = document.getElementById('extraQuantity');
        if (extraQty && extraQty.value) {
            params.append('extraQuantity', extraQty.value);
        }
      }

      const url = window.contextPath + '/place-order';
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      });

      const responseText = await response.text();
      let result;
      try {
        result = JSON.parse(responseText);
      } catch (e) {
        showError('Lỗi server: ' + responseText.substring(0, 200));
        placeOrderBtn.disabled = false;
        placeOrderBtn.innerHTML = originalText;
        return;
      }

      if (result.success) {
        if (result.paymentRedirect && result.checkoutFormHtml) {
          showSuccess('Đang chuyển đến cổng thanh toán...');
          const container = document.getElementById('sepay-form-container');
          if (container) {
            container.innerHTML = result.checkoutFormHtml;
            const form = container.querySelector('form');
            if (form) {
              setTimeout(() => { form.submit(); }, 600);
              return;
            }
          }
          window.location.replace(window.contextPath + '/order-confirmation?id=' + result.orderId);
        } else {
          showSuccess('Đặt hàng thành công!');
          setTimeout(() => {
            window.location.replace(window.contextPath + '/order-confirmation?id=' + result.orderId);
          }, 1000);
        }
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
    const container = document.querySelector('.ThanhToan_container');
    if (container) container.prepend(notification);
    notification.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    setTimeout(() => notification.remove(), 5000);
  }

  function showSuccess(message) {
    removeNotifications();
    const notification = document.createElement('div');
    notification.className = 'checkout-notification success';
    notification.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
    const container = document.querySelector('.ThanhToan_container');
    if (container) container.prepend(notification);
  }

  function removeNotifications() {
    document.querySelectorAll('.checkout-notification').forEach(n => n.remove());
  }


  function setupEventListeners() {
    const provinceSelect = document.getElementById('province');
    if (provinceSelect) {
      provinceSelect.addEventListener('change', function () {
        if (this.value) {
          loadDistricts(this.value, 'district', 'ward');
        }
      });
    }

    const districtSelect = document.getElementById('district');
    if (districtSelect) {
      districtSelect.addEventListener('change', function () {
        if (this.value) {
          loadWards(this.value, 'ward');
        }
      });
    }

    const wardSelect = document.getElementById('ward');
    if (wardSelect) {
      wardSelect.addEventListener('change', function () {
        if (this.value) {
          calculateShippingFee();
        } else {
          updateShippingDisplay(null);
        }
      });
    }

    const placeOrderBtn = document.getElementById('placeOrder');
    if (placeOrderBtn) {
      placeOrderBtn.addEventListener('click', placeOrder);
    }

    const extraCb = document.getElementById('extraProductCb');
    const extraVariantSelect = document.getElementById('extraVariantId');
    const extraQtyInput = document.getElementById('extraQuantity');
    const recPriceDisplay = document.getElementById('rec-price-display');
    const qtyMinus = document.querySelector('.rec-qty-btn.minus');
    const qtyPlus = document.querySelector('.rec-qty-btn.plus');

    function updateRecommendationTotals() {
      if (!extraCb) return;
      
      let unitPrice = parseFloat(extraCb.getAttribute('data-base-price')) || 0;
      if (extraVariantSelect && extraVariantSelect.tagName.toLowerCase() === 'select') {
        const selectedOpt = extraVariantSelect.options[extraVariantSelect.selectedIndex];
        if (selectedOpt && selectedOpt.getAttribute('data-price')) {
          unitPrice = parseFloat(selectedOpt.getAttribute('data-price')) || 0;
        }
      }
      
      let qty = 1;
      if (extraQtyInput) {
        qty = parseInt(extraQtyInput.value, 10) || 1;
      }
      
      let addPrice = unitPrice * qty;
      if (recPriceDisplay) {
        recPriceDisplay.innerHTML = '+' + new Intl.NumberFormat('vi-VN').format(addPrice) + 'đ';
      }
      
      let currentSub = window.subtotal;
      if (extraCb.checked) {
        currentSub += addPrice;
      }
      
      const subtotalText = document.getElementById('subtotalText');
      if (subtotalText) {
          subtotalText.innerHTML = new Intl.NumberFormat('vi-VN').format(currentSub) + 'đ';
      }
      
      let shippingFee = window.currentShippingFee || 0;
      
      let currentTotal = currentSub + shippingFee;
      
      const shippingText = document.getElementById('shippingFeeText');
      if (shippingText && shippingFee > 0) {
        shippingText.innerHTML = new Intl.NumberFormat('vi-VN').format(shippingFee) + 'đ';
      }
      
      const grandTotal = document.getElementById('grandTotalText');
      if (grandTotal) {
        grandTotal.innerHTML = new Intl.NumberFormat('vi-VN').format(currentTotal) + 'đ';
      }
    }

    if (extraCb) {
      extraCb.addEventListener('change', updateRecommendationTotals);
    }
    if (extraVariantSelect && extraVariantSelect.tagName.toLowerCase() === 'select') {
      extraVariantSelect.addEventListener('change', updateRecommendationTotals);
    }
    if (qtyMinus && extraQtyInput) {
      qtyMinus.addEventListener('click', function(e) {
          e.preventDefault();
          e.stopPropagation();
          let current = parseInt(extraQtyInput.value, 10) || 1;
          if (current > 1) {
              extraQtyInput.value = current - 1;
              updateRecommendationTotals();
          }
      });
    }
    if (qtyPlus && extraQtyInput) {
      qtyPlus.addEventListener('click', function(e) {
          e.preventDefault();
          e.stopPropagation();
          let current = parseInt(extraQtyInput.value, 10) || 1;
          if (current < 99) {
              extraQtyInput.value = current + 1;
              updateRecommendationTotals();
          }
      });
    }
  }


  document.addEventListener('DOMContentLoaded', function () {
    loadProvinces();
    setupEventListeners();
    setupAddressBook();
    setupModal();
  });

})();