
function updateCartBadge(count) {
    var badge = document.getElementById('cartCount');
    if (!badge) return;

    if (badge.textContent != count) {
        badge.textContent = count;
    }
    if (count > 0) {
        if (badge.style.display !== 'inline-flex') {
            badge.style.display = 'inline-flex';
        }
    } else {
        if (badge.style.display !== 'none') {
            badge.style.display = 'none';
        }
    }
}

function refreshCartCount() {
    var ctx = window.contextPath || '';
    fetch(ctx + '/api/cart', { method: 'GET', credentials: 'same-origin' })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.success) {
                updateCartBadge(data.count);
            }
        })
        .catch(function (err) {
            console.warn('refreshCartCount failed:', err);
        });
}

window.updateCartBadge = updateCartBadge;
window.refreshCartCount = refreshCartCount;

function updateWishlistBadge(count) {
    var badge = document.getElementById('wishlistCount');
    if (!badge) return;

    if (badge.textContent != count) {
        badge.textContent = count;
    }
    if (count > 0) {
        if (badge.style.display !== 'inline-flex') {
            badge.style.display = 'inline-flex';
        }
    } else {
        if (badge.style.display !== 'none') {
            badge.style.display = 'none';
        }
    }
}

function refreshWishlistCount() {
    var ctx = window.contextPath || '';
    fetch(ctx + '/api/wishlist?action=count', { method: 'GET', credentials: 'same-origin' })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.success) {
                updateWishlistBadge(data.count);
            }
        })
        .catch(function (err) {
            console.warn('refreshWishlistCount failed:', err);
        });
}

window.updateWishlistBadge = updateWishlistBadge;
window.refreshWishlistCount = refreshWishlistCount;

function addToCart(productId, variantId) {
    var ctx = window.contextPath || '';

    if (!window.isLoggedIn) {
        window.location.href = ctx + '/dang-nhap?redirect=' + encodeURIComponent(window.location.pathname);
        return;
    }

    variantId = variantId || 0;

    var body = 'productId=' + productId + (variantId !== 0 ? '&variantId=' + variantId : '') + '&quantity=1';

    fetch(ctx + '/api/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        credentials: 'same-origin',
        body: body
    })
        .then(function (response) {
            if (!response.ok && response.status === 404) {
                throw new Error('API not found (404)');
            }
            return response.json();
        })
        .then(function (data) {
            if (data.success) {
                updateCartBadge(data.cartCount);
                showToast('Đã thêm vào giỏ hàng!', 'success');
            } else {
                if (data.requireLogin) {
                    window.location.href = ctx + '/dang-nhap';
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            }
        })
        .catch(function (error) {
            console.error('Add to cart error:', error);
            showToast('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.', 'error');
        });
}


function showToast(message, type) {
    var existingToast = document.querySelector('.toast-notification');
    if (existingToast) existingToast.remove();

    var toast = document.createElement('div');
    toast.className = 'toast-notification ' + type;
    toast.innerHTML = '<i class="fas ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle') + '"></i><span>' + message + '</span>';

    toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:' + (type === 'success' ? '#4CAF50' : '#f44336') + ';color:white;padding:15px 25px;border-radius:8px;display:flex;align-items:center;gap:10px;box-shadow:0 4px 12px rgba(0,0,0,0.3);z-index:10000;animation:slideIn 0.3s ease;';

    document.body.appendChild(toast);

    setTimeout(function () {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(function () { if (toast.parentNode) toast.remove(); }, 300);
    }, 3000);
}


if (!document.querySelector('#toast-styles')) {
    var style = document.createElement('style');
    style.id = 'toast-styles';
    style.textContent =
        '@keyframes slideIn{from{transform:translateX(100%);opacity:0}to{transform:translateX(0);opacity:1}}' +
        '@keyframes slideOut{from{transform:translateX(0);opacity:1}to{transform:translateX(100%);opacity:0}}';
    document.head.appendChild(style);
}

document.addEventListener('DOMContentLoaded', function () {
    if (window.isLoggedIn) {
        refreshCartCount();
        refreshWishlistCount();
    }
});
