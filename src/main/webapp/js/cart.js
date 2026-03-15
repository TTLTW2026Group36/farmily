




function addToCart(productId, variantId) {
    if (typeof window.isLoggedIn === 'undefined' || typeof window.contextPath === 'undefined') {
        console.error('Missing global configuration for cart');
        return;
    }

    if (!window.isLoggedIn) {
        window.location.href = window.contextPath + '/dang-nhap?redirect=' + encodeURIComponent(window.location.pathname);
        return;
    }

    
    variantId = variantId || 0;

    const body = 'productId=' + productId + (variantId !== 0 ? '&variantId=' + variantId : '') + '&quantity=1';

    fetch(window.contextPath + '/api/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body
    })
        .then(response => {
            if (!response.ok && response.status === 404) {
                throw new Error('API not found (404)');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                const cartBadge = document.getElementById('cartCount');
                if (cartBadge) {
                    cartBadge.textContent = data.cartCount;
                    cartBadge.style.display = 'flex';
                }
                showToast('Đã thêm vào giỏ hàng!', 'success');
            } else {
                if (data.requireLogin) {
                    window.location.href = window.contextPath + '/dang-nhap';
                } else {
                    showToast(data.message || 'Có lỗi xảy ra', 'error');
                }
            }
        })
        .catch(error => {
            console.error('Add to cart error:', error);
            showToast('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.', 'error');
        });
}

function showToast(message, type) {
    
    const existingToast = document.querySelector('.toast-notification');
    if (existingToast) existingToast.remove();

    
    const toast = document.createElement('div');
    toast.className = 'toast-notification ' + type;
    toast.innerHTML = '<i class="fas ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle') + '"></i><span>' + message + '</span>';

    
    toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:' + (type === 'success' ? '#4CAF50' : '#f44336') + ';color:white;padding:15px 25px;border-radius:8px;display:flex;align-items:center;gap:10px;box-shadow:0 4px 12px rgba(0,0,0,0.3);z-index:10000;animation:slideIn 0.3s ease;';

    document.body.appendChild(toast);

    
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => { if (toast.parentNode) toast.remove(); }, 300);
    }, 3000);
}


if (!document.querySelector('#toast-styles')) {
    const style = document.createElement('style');
    style.id = 'toast-styles';
    style.textContent = '@keyframes slideIn{from{transform:translateX(100%);opacity:0}to{transform:translateX(0);opacity:1}}@keyframes slideOut{from{transform:translateX(0);opacity:1}to{transform:translateX(100%);opacity:0}}';
    document.head.appendChild(style);
}
