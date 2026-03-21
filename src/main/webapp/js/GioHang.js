



(function () {
    'use strict';


    const formatVND = n => (n || 0).toLocaleString('vi-VN') + 'đ';


    const API_URL = (window.contextPath || '') + '/api/cart';




    window.changeQuantity = function (itemId, delta) {
        const input = document.getElementById('qty-' + itemId);
        if (!input) return;

        let newQty = parseInt(input.value, 10) + delta;
        if (newQty < 1) newQty = 1;
        if (newQty > 99) newQty = 99;

        input.value = newQty;
        updateCartQuantity(itemId, newQty);
    };




    window.updateCartQuantity = function (itemId, quantity) {
        quantity = parseInt(quantity, 10);

        if (isNaN(quantity) || quantity < 1) {
            if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                removeCartItem(itemId);
            } else {

                const input = document.getElementById('qty-' + itemId);
                if (input) input.value = 1;
            }
            return;
        }

        if (quantity > 99) quantity = 99;


        const itemEl = document.querySelector(`[data-item-id="${itemId}"]`);
        const buttons = itemEl?.querySelectorAll('.qty-btn');
        buttons?.forEach(btn => btn.disabled = true);


        const url = API_URL + '?itemId=' + itemId + '&quantity=' + quantity;

        fetch(url, { method: 'PUT' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateItemUI(itemId, data.item);
                    updateCartTotals();
                    updateCartBadge(data.cartCount);
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Update cart error:', error);
                alert('Có lỗi xảy ra, vui lòng thử lại!');
            })
            .finally(() => {

                buttons?.forEach(btn => {
                    btn.disabled = false;

                    if (btn.classList.contains('minus')) {
                        const input = itemEl?.querySelector('.qty-input');
                        if (input && parseInt(input.value, 10) <= 1) {
                            btn.disabled = true;
                        }
                    }
                });
            });
    };




    window.updateVariant = function (itemId, variantId, selectEl) {
        if (!variantId) return;


        const originalValue = selectEl.dataset.original;


        selectEl.disabled = true;
        selectEl.style.opacity = '0.5';


        const url = API_URL + '?itemId=' + itemId + '&variantId=' + variantId;

        fetch(url, { method: 'PUT' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {

                    updateItemUI(itemId, data.item);
                    updateCartTotals();
                    updateCartBadge(data.cartCount);


                    selectEl.dataset.original = variantId;


                    showToast('Đã cập nhật phân loại');


                    if (data.item.id != itemId) {
                        showToast('Sản phẩm đã được gộp với item cùng phân loại');
                        setTimeout(() => location.reload(), 1500);
                    }
                } else {

                    selectEl.value = originalValue;
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Update variant error:', error);
                selectEl.value = originalValue;
                alert('Có lỗi xảy ra, vui lòng thử lại!');
            })
            .finally(() => {
                selectEl.disabled = false;
                selectEl.style.opacity = '1';
            });
    };




    function updateItemUI(itemId, item) {
        const itemEl = document.querySelector(`[data-item-id="${itemId}"]`);
        if (!itemEl) return;


        const priceEl = document.getElementById('price-' + itemId);
        if (priceEl) priceEl.textContent = formatVND(item.unitPrice);


        itemEl.dataset.price = item.unitPrice;


        const qtyInput = itemEl.querySelector('.qty-input');
        if (qtyInput) qtyInput.value = item.quantity;


        const subtotalEl = document.getElementById('subtotal-' + itemId);
        if (subtotalEl) subtotalEl.textContent = formatVND(item.subtotal);


        const minusBtn = itemEl.querySelector('.qty-btn.minus');
        if (minusBtn) minusBtn.disabled = item.quantity <= 1;
    }




    window.removeCartItem = function (itemId) {
        if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
            return;
        }

        fetch(API_URL + '?itemId=' + itemId, { method: 'DELETE' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {

                    const itemEl = document.querySelector(`[data-item-id="${itemId}"]`);
                    if (itemEl) {
                        itemEl.style.transition = 'all 0.3s ease';
                        itemEl.style.opacity = '0';
                        itemEl.style.transform = 'translateX(-20px)';

                        setTimeout(() => {
                            itemEl.remove();


                            const remainingItems = document.querySelectorAll('.cart-item');
                            if (remainingItems.length === 0) {
                                location.reload();
                            } else {
                                updateCartTotals();
                            }
                        }, 300);
                    }


                    updateCartBadge(data.cartCount);


                    showToast('Đã xóa sản phẩm khỏi giỏ hàng');
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Remove cart item error:', error);
                alert('Có lỗi xảy ra, vui lòng thử lại!');
            });
    };




    function updateCartTotals() {
        let total = 0;
        const cartItems = document.querySelectorAll('.cart-item');
        const distinctCount = cartItems.length;

        cartItems.forEach(item => {
            const price = parseFloat(item.dataset.price) || 0;
            const qtyInput = item.querySelector('.qty-input');
            const qty = parseInt(qtyInput?.value, 10) || 0;
            total += price * qty;
        });

        const totalEl = document.getElementById('cartTotal');
        const grandTotalEl = document.getElementById('grandTotal');
        const itemsEl = document.getElementById('totalItems');
        const titleCountEl = document.getElementById('cartTitleCount');

        if (totalEl) totalEl.textContent = formatVND(total);
        if (grandTotalEl) grandTotalEl.textContent = formatVND(total);
        if (itemsEl) itemsEl.textContent = distinctCount;
        if (titleCountEl) titleCountEl.textContent = '(' + distinctCount + ' sản phẩm)';
    }







    function showToast(message) {

        document.querySelectorAll('.cart-toast').forEach(t => t.remove());

        const toast = document.createElement('div');
        toast.className = 'cart-toast';
        toast.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
        toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:#16a34a;color:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,.15);z-index:9999;display:flex;align-items:center;gap:8px;font-weight:500;animation:slideIn .3s ease;';
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 2000);
    }


    document.addEventListener('DOMContentLoaded', function () {
        console.log('GioHang.js initialized');
    });

})();
