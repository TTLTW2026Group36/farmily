
function startGiaTotCountdown() {
    const hoursElement = document.getElementById('gt-hours');
    const minutesElement = document.getElementById('gt-minutes');
    const secondsElement = document.getElementById('gt-seconds');

    if (!hoursElement || !minutesElement || !secondsElement) {
        return;
    }

    
    const now = new Date();
    const endOfDay = new Date();
    endOfDay.setHours(23, 59, 59, 999);

    let timeRemaining = Math.floor((endOfDay - now) / 1000); 

    function updateCountdown() {
        if (timeRemaining <= 0) {
            
            timeRemaining = 24 * 60 * 60;
        }

        const hours = Math.floor(timeRemaining / 3600);
        const minutes = Math.floor((timeRemaining % 3600) / 60);
        const seconds = timeRemaining % 60;

        hoursElement.textContent = String(hours).padStart(2, '0');
        minutesElement.textContent = String(minutes).padStart(2, '0');
        secondsElement.textContent = String(seconds).padStart(2, '0');

        timeRemaining--;
    }

    
    updateCountdown();

    
    setInterval(updateCountdown, 1000);
}


document.addEventListener('DOMContentLoaded', startGiaTotCountdown);


const wishlistButtons = document.querySelectorAll('.wishlist-btn');

wishlistButtons.forEach(btn => {
    btn.addEventListener('click', function (e) {
        e.preventDefault();
        this.classList.toggle('active');

        
        const icon = this.querySelector('i');
        icon.style.animation = 'none';
        setTimeout(() => {
            icon.style.animation = 'heartBeat 0.5s ease';
        }, 10);
    });
});


const heartBeatStyle = document.createElement('style');
heartBeatStyle.textContent = `
    @keyframes heartBeat {
        0%, 100% { transform: scale(1); }
        25% { transform: scale(1.3); }
        50% { transform: scale(1.1); }
        75% { transform: scale(1.2); }
    }
`;
document.head.appendChild(heartBeatStyle);






window.addToCart = function (productId) {
    const API_URL = (window.contextPath || '') + '/api/cart';

    
    const button = event ? event.target.closest('button') : null;
    const originalText = button ? button.innerHTML : '';
    if (button) {
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang thêm...';
    }

    fetch(API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `productId=${productId}&quantity=1`
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                
                updateCartBadge(data.cartCount);
                
                showToast('Đã thêm vào giỏ hàng!', 'success');
            } else if (data.requireLogin) {
                
                showToast('Vui lòng đăng nhập để thêm vào giỏ hàng', 'warning');
                setTimeout(() => {
                    window.location.href = (window.contextPath || '') + '/dang-nhap?redirect=' + encodeURIComponent(window.location.pathname);
                }, 1500);
            } else {
                showToast(data.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Add to cart error:', error);
            showToast('Có lỗi xảy ra, vui lòng thử lại!', 'error');
        })
        .finally(() => {
            
            if (button) {
                button.disabled = false;
                button.innerHTML = originalText;
            }
        });
};




function updateCartBadge(count) {
    const badge = document.getElementById('cartCount');
    if (badge) {
        badge.textContent = count;
        badge.style.transform = 'scale(1.3)';
        setTimeout(() => { badge.style.transform = 'scale(1)'; }, 200);
    }
}




function showToast(message, type = 'success') {
    
    document.querySelectorAll('.giatot-toast').forEach(t => t.remove());

    const toast = document.createElement('div');
    toast.className = 'giatot-toast';

    const icons = {
        success: 'fa-check-circle',
        error: 'fa-times-circle',
        warning: 'fa-exclamation-circle'
    };

    const colors = {
        success: '#16a34a',
        error: '#dc2626',
        warning: '#f59e0b'
    };

    toast.innerHTML = `<i class="fas ${icons[type] || icons.success}"></i> ${message}`;
    toast.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: ${colors[type] || colors.success};
        color: #fff;
        padding: 12px 24px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,.15);
        z-index: 9999;
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        animation: slideInUp .3s ease;
    `;

    
    if (!document.getElementById('toast-animation')) {
        const style = document.createElement('style');
        style.id = 'toast-animation';
        style.textContent = `
            @keyframes slideInUp {
                from {
                    transform: translateY(20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
        `;
        document.head.appendChild(style);
    }

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 2500);
}





function initSorting() {
    const sortButtons = document.querySelectorAll('.sort-btn[data-sort]');
    const productsGrid = document.querySelector('.products-grid');

    if (!sortButtons.length || !productsGrid) return;

    sortButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            const sortType = this.dataset.sort;

            
            sortButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            
            sortProducts(sortType);
        });
    });
}





function sortProducts(sortType) {
    const productsGrid = document.querySelector('.products-grid');
    const products = Array.from(productsGrid.querySelectorAll('.flash-product-item'));

    if (!products.length) return;

    
    productsGrid.style.opacity = '0.5';
    productsGrid.style.transition = 'opacity 0.2s ease';

    setTimeout(() => {
        
        const productData = products.map(product => {
            
            const priceEl = product.querySelector('.new-price');
            const discountEl = product.querySelector('.discount-badge');
            const originalOrder = product.dataset.originalOrder || products.indexOf(product);

            
            let price = 0;
            if (priceEl) {
                const priceText = priceEl.textContent.replace(/[^\d]/g, '');
                price = parseInt(priceText, 10) || 0;
            }

            
            let discount = 0;
            if (discountEl) {
                const discountText = discountEl.textContent.replace(/[^\d]/g, '');
                discount = parseInt(discountText, 10) || 0;
            }

            return {
                element: product,
                price: price,
                discount: discount,
                originalOrder: parseInt(originalOrder, 10)
            };
        });

        
        productData.forEach((item, index) => {
            if (!item.element.dataset.originalOrder) {
                item.element.dataset.originalOrder = index;
            }
        });

        
        switch (sortType) {
            case 'price-asc':
                productData.sort((a, b) => a.price - b.price);
                break;
            case 'price-desc':
                productData.sort((a, b) => b.price - a.price);
                break;
            case 'discount':
                productData.sort((a, b) => b.discount - a.discount);
                break;
            case 'default':
            default:
                productData.sort((a, b) => a.originalOrder - b.originalOrder);
                break;
        }

        
        productData.forEach(item => {
            productsGrid.appendChild(item.element);
        });

        
        productsGrid.style.opacity = '1';

        
        productData.forEach((item, index) => {
            item.element.style.animation = 'none';
            item.element.offsetHeight; 
            item.element.style.animation = `fadeInUp 0.4s ease-out ${index * 0.05}s forwards`;
        });

    }, 200);
}


document.addEventListener('DOMContentLoaded', function () {
    initSorting();
    console.log('GiaTot.js: Sorting initialized');
});
