
(function () {
    'use strict';

    var formatVND = function (n) { return (n || 0).toLocaleString('vi-VN') + 'đ'; };
    var API_URL = (window.contextPath || '') + '/api/cart';

    function getItemCheckboxes() {
        return document.querySelectorAll('.cart-item-check');
    }

    function getSelectedItemIds() {
        var ids = [];
        getItemCheckboxes().forEach(function (cb) {
            if (cb.checked) ids.push(parseInt(cb.dataset.itemId, 10));
        });
        return ids;
    }

    function syncSelectAllCheckboxes(state) {
        var all = getItemCheckboxes();
        var checked = document.querySelectorAll('.cart-item-check:checked');
        var isAll = all.length > 0 && checked.length === all.length;
        var isIndeterminate = checked.length > 0 && checked.length < all.length;

        ['selectAllTop', 'selectAllBar'].forEach(function (id) {
            var el = document.getElementById(id);
            if (!el) return;
            el.checked = isAll;
            el.indeterminate = isIndeterminate;
        });
    }

    function updateSelectionUI() {
        var all = getItemCheckboxes();
        var checked = document.querySelectorAll('.cart-item-check:checked');

        syncSelectAllCheckboxes();

        var deleteBtn = document.getElementById('deleteSelectedBtn');
        var wishBtn = document.getElementById('wishSelectedBtn');
        var checkoutBtn = document.getElementById('checkoutBtn');

        if (deleteBtn) deleteBtn.disabled = checked.length === 0;
        if (wishBtn) wishBtn.disabled = checked.length === 0;
        if (checkoutBtn) checkoutBtn.disabled = checked.length === 0;

        all.forEach(function (cb) {
            var row = cb.closest('.cart-row');
            if (!row) return;
            if (cb.checked) row.classList.add('row-selected');
            else row.classList.remove('row-selected');
        });

        updateCartTotals();

        var countEl = document.getElementById('selectAllCount');
        if (countEl) countEl.textContent = all.length;

        var titleEl = document.getElementById('cartTitleCount');
        if (titleEl) titleEl.textContent = all.length;
    }

    window.toggleSelectAll = function (masterCb) {
        var state = masterCb.checked;
        getItemCheckboxes().forEach(function (cb) { cb.checked = state; });
        ['selectAllTop', 'selectAllBar'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el && el !== masterCb) el.checked = state;
        });
        updateSelectionUI();
    };

    window.onItemCheckChange = function () {
        updateSelectionUI();
    };

    window.changeQuantity = function (itemId, delta) {
        var input = document.getElementById('qty-' + itemId);
        if (!input) return;
        var row = document.querySelector('.cart-row[data-item-id="' + itemId + '"]');
        var stock = row ? parseInt(row.dataset.stock, 10) : 999;
        var newQty = parseInt(input.value, 10) + delta;
        if (newQty < 1) newQty = 1;
        if (stock > 0 && newQty > stock) {
            newQty = stock;
            input.value = newQty;
            showToast('Số lượng bạn chọn đã đạt mức tối đa của sản phẩm này');
            return;
        }
        if (newQty > 999) newQty = 999;
        input.value = newQty;
        updateCartQuantity(itemId, newQty);
    };

    window.updateCartQuantity = function (itemId, quantity) {
        quantity = parseInt(quantity, 10);
        if (isNaN(quantity) || quantity < 1) {
            if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                removeCartItem(itemId);
            } else {
                var input = document.getElementById('qty-' + itemId);
                if (input) input.value = 1;
            }
            return;
        }
        var row = document.querySelector('.cart-row[data-item-id="' + itemId + '"]');
        var stock = row ? parseInt(row.dataset.stock, 10) : 999;
        if (stock > 0 && quantity > stock) {
            quantity = stock;
            var inp = document.getElementById('qty-' + itemId);
            if (inp) inp.value = stock;
            showToast('Số lượng bạn chọn đã đạt mức tối đa của sản phẩm này');
        }
        if (quantity > 999) quantity = 999;

        var buttons = row ? row.querySelectorAll('.qty-btn') : [];
        buttons.forEach(function (b) { b.disabled = true; });

        fetch(API_URL + '?itemId=' + itemId + '&quantity=' + quantity, { method: 'PUT' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.success) {
                    updateItemUI(itemId, data.item);
                    updateCartTotals();
                    updateCartBadge(data.cartCount);
                } else {
                    showToast(data.message || 'Có lỗi xảy ra');
                    location.reload();
                }
            })
            .catch(function () { showToast('Có lỗi xảy ra, vui lòng thử lại!'); })
            .finally(function () {
                buttons.forEach(function (b) {
                    b.disabled = false;
                    if (b.classList.contains('minus')) {
                        var inp = document.getElementById('qty-' + itemId);
                        if (inp && parseInt(inp.value, 10) <= 1) b.disabled = true;
                    }
                });
            });
    };

    window.onChipClick = function (itemId, variantId, chipEl) {
        var container = chipEl.closest('.variant-chips');
        if (!container) return;
        if (chipEl.classList.contains('active')) return;
        var prevActive = container.querySelector('.variant-chip.active');
        var originalVariantId = container.dataset.original;
        container.querySelectorAll('.variant-chip').forEach(function (c) {
            c.classList.remove('active');
            c.classList.add('loading');
        });
        chipEl.classList.add('active');

        fetch(API_URL + '?itemId=' + itemId + '&variantId=' + variantId, { method: 'PUT' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.success) {
                    updateItemUI(itemId, data.item);
                    updateCartTotals();
                    updateCartBadge(data.cartCount);
                    container.dataset.original = variantId;
                    showToast('Đã cập nhật phân loại');
                    if (data.item.id != itemId) {
                        setTimeout(function () { location.reload(); }, 1200);
                    }
                } else {
                    container.querySelectorAll('.variant-chip').forEach(function (c) {
                        c.classList.remove('active');
                    });
                    if (prevActive) prevActive.classList.add('active');
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(function () {
                container.querySelectorAll('.variant-chip').forEach(function (c) {
                    c.classList.remove('active');
                });
                if (prevActive) prevActive.classList.add('active');
                alert('Có lỗi xảy ra, vui lòng thử lại!');
            })
            .finally(function () {
                container.querySelectorAll('.variant-chip').forEach(function (c) {
                    c.classList.remove('loading');
                });
            });
    };

    function updateItemUI(itemId, item) {
        var row = document.querySelector('.cart-row[data-item-id="' + itemId + '"]');
        if (!row) return;

        var priceEl = document.getElementById('price-' + itemId);
        if (priceEl) priceEl.innerHTML = '<span class="price-main">' + formatVND(item.unitPrice) + '</span>';

        row.dataset.price = item.unitPrice;

        var qtyInput = document.getElementById('qty-' + itemId);
        if (qtyInput) qtyInput.value = item.quantity;

        var subtotalEl = document.getElementById('subtotal-' + itemId);
        if (subtotalEl) subtotalEl.textContent = formatVND(item.subtotal);

        var minusBtn = row.querySelector('.qty-btn.minus');
        if (minusBtn) minusBtn.disabled = item.quantity <= 1;

        if (typeof item.stock !== 'undefined') {
            row.dataset.stock = item.stock;
            updateStockWarning(itemId, item.stock);
        }
    }

    function updateStockWarning(itemId, stock) {
        var row = document.querySelector('.cart-row[data-item-id="' + itemId + '"]');
        if (!row) return;
        var td = row.querySelector('td.col-qty');
        if (!td) return;
        var warn = document.getElementById('stock-warn-' + itemId);

        if (stock > 0 && stock <= 5) {
            if (!warn) {
                warn = document.createElement('span');
                warn.className = 'low-stock-warn';
                warn.id = 'stock-warn-' + itemId;
                td.appendChild(warn);
            }
            warn.textContent = 'Còn lại ' + stock + ' sản phẩm';
        } else if (warn) {
            warn.remove();
        }
    }

    window.removeCartItem = function (itemId) {
        if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;

        fetch(API_URL + '?itemId=' + itemId, { method: 'DELETE' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.success) {
                    var row = document.querySelector('.cart-row[data-item-id="' + itemId + '"]');
                    if (row) row.remove();

                    var remaining = document.querySelectorAll('.cart-row');
                    if (remaining.length === 0) {
                        location.reload();
                    } else {
                        updateSelectionUI();
                    }
                    updateCartBadge(data.cartCount);
                    showToast('Đã xóa sản phẩm khỏi giỏ hàng');
                } else {
                    alert(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(function () { alert('Có lỗi xảy ra, vui lòng thử lại!'); });
    };

    window.deleteSelectedItems = function () {
        var selectedIds = getSelectedItemIds();
        if (selectedIds.length === 0) { showToast('Vui lòng chọn sản phẩm cần xóa'); return; }

        var msg = selectedIds.length === 1
            ? 'Bạn có chắc muốn xóa sản phẩm đã chọn?'
            : 'Bạn có chắc muốn xóa ' + selectedIds.length + ' sản phẩm đã chọn?';
        if (!confirm(msg)) return;

        var deleteBtn = document.getElementById('deleteSelectedBtn');
        if (deleteBtn) { deleteBtn.disabled = true; deleteBtn.textContent = 'Đang xóa...'; }

        var promises = selectedIds.map(function (itemId) {
            return fetch(API_URL + '?itemId=' + itemId, { method: 'DELETE' })
                .then(function (r) { return r.json(); })
                .then(function (d) { return { itemId: itemId, success: d.success, cartCount: d.cartCount }; })
                .catch(function () { return { itemId: itemId, success: false }; });
        });

        Promise.all(promises).then(function (results) {
            var lastCount = 0, deleted = 0;
            results.forEach(function (r) {
                if (r.success) {
                    deleted++;
                    lastCount = r.cartCount;
                    var row = document.querySelector('.cart-row[data-item-id="' + r.itemId + '"]');
                    if (row) row.remove();
                }
            });

            var remaining = document.querySelectorAll('.cart-row');
            if (remaining.length === 0) { location.reload(); return; }

            updateSelectionUI();
            updateCartBadge(lastCount);
            if (deleted > 0) showToast('Đã xóa ' + deleted + ' sản phẩm');
        }).finally(function () {
            if (deleteBtn) { deleteBtn.textContent = 'Xóa'; }
        });
    };

    window.saveToWishlist = function () {
        var selectedIds = getSelectedItemIds();
        if (selectedIds.length === 0) { showToast('Vui lòng chọn sản phẩm'); return; }

        var rows = document.querySelectorAll('.cart-row');
        var productIds = [];
        rows.forEach(function (row) {
            var itemId = parseInt(row.dataset.itemId, 10);
            if (selectedIds.indexOf(itemId) !== -1) {
                var pid = parseInt(row.dataset.productId, 10);
                if (!isNaN(pid) && productIds.indexOf(pid) === -1) {
                    productIds.push(pid);
                }
            }
        });

        if (productIds.length === 0) { showToast('Không tìm thấy sản phẩm để lưu'); return; }

        var wishBtn = document.getElementById('wishSelectedBtn');
        if (wishBtn) { wishBtn.disabled = true; wishBtn.textContent = 'Đang lưu...'; }

        var ctx = window.contextPath || '';
        var promises = productIds.map(function (pid) {
            return fetch(ctx + '/api/wishlist?productId=' + pid + '&action=add', { method: 'POST', credentials: 'same-origin' })
                .then(function (r) { return r.json(); })
                .catch(function () { return { success: false }; });
        });

        Promise.all(promises).then(function (results) {
            var saved = 0;
            var alreadyExisted = 0;
            var lastCount = 0;
            results.forEach(function (r) {
                if (r.success) {
                    lastCount = r.wishlistCount || lastCount;
                    if (r.alreadyExists) {
                        alreadyExisted++;
                    } else {
                        saved++;
                    }
                }
            });

            updateWishlistBadge(lastCount);

            if (saved > 0 && alreadyExisted > 0) {
                showWishlistNotification('Đã lưu ' + saved + ' sản phẩm vào yêu thích, ' + alreadyExisted + ' sản phẩm đã có trong danh sách');
            } else if (saved > 0) {
                showWishlistNotification('Đã lưu ' + saved + ' sản phẩm vào mục yêu thích');
            } else if (alreadyExisted > 0) {
                showWishlistNotification('Sản phẩm đã có trong mục yêu thích của bạn');
            } else {
                showWishlistNotification('Không thể lưu, vui lòng thử lại sau');
            }
        }).finally(function () {
            if (wishBtn) { wishBtn.disabled = false; wishBtn.textContent = 'Lưu vào mục Yêu thích'; }
        });
    };

    function showWishlistNotification(message) {
        var existing = document.getElementById('wishlistToast');
        if (existing) existing.remove();

        var toast = document.createElement('div');
        toast.id = 'wishlistToast';
        toast.className = 'wl-simple-toast';
        toast.textContent = message;

        document.body.appendChild(toast);

        setTimeout(function () {
            toast.classList.add('hidden');
            setTimeout(function () { if (toast.parentNode) toast.remove(); }, 400);
        }, 2500);
    }

    window.proceedToCheckout = function () {
        var selectedIds = getSelectedItemIds();
        if (selectedIds.length === 0) { showToast('Vui lòng chọn ít nhất 1 sản phẩm'); return; }
        var ctx = window.contextPath || '';
        var params = selectedIds.map(function (id) { return 'itemId=' + id; }).join('&');
        window.location.href = ctx + '/checkout?' + params;
    };

    function updateCartTotals() {
        var total = 0;
        var selectedCount = 0;
        var allRows = document.querySelectorAll('.cart-row');

        allRows.forEach(function (row) {
            var cb = row.querySelector('.cart-item-check');
            if (cb && cb.checked) {
                var price = parseFloat(row.dataset.price) || 0;
                var qtyInput = row.querySelector('.qty-input');
                var qty = parseInt(qtyInput ? qtyInput.value : 0, 10) || 0;
                total += price * qty;
                selectedCount++;
            }
        });

        var grandTotalEl = document.getElementById('grandTotal');
        var itemsEl = document.getElementById('totalItems');

        if (grandTotalEl) grandTotalEl.textContent = formatVND(total);
        if (itemsEl) itemsEl.textContent = selectedCount;
    }

    function showToast(message) {
        document.querySelectorAll('.cart-toast').forEach(function (t) { t.remove(); });
        var toast = document.createElement('div');
        toast.className = 'cart-toast';
        toast.textContent = message;
        toast.style.cssText = 'position:fixed;bottom:70px;right:20px;background:#333;color:#fff;padding:10px 18px;border-radius:3px;z-index:9999;font-size:13px;';
        document.body.appendChild(toast);
        setTimeout(function () { toast.remove(); }, 2500);
    }

    document.addEventListener('DOMContentLoaded', function () {
        updateSelectionUI();
    });

})();
