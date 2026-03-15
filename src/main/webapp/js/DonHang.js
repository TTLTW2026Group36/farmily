



document.addEventListener('DOMContentLoaded', function () {
    console.log('DonHang.js loaded');

    
    animateOrderCards();

    
    initSmoothScroll();
});





function toggleProductList(orderId) {
    const hiddenProducts = document.getElementById(`hidden-products-${orderId}`);
    const toggleBtn = document.querySelector(`button[data-order-id="${orderId}"]`);

    if (!hiddenProducts || !toggleBtn) return;

    const icon = toggleBtn.querySelector('i');
    const text = toggleBtn.querySelector('.toggle-text');
    const isHidden = hiddenProducts.style.display === 'none';

    if (isHidden) {
        
        hiddenProducts.style.display = 'flex';
        icon.classList.remove('fa-chevron-down');
        icon.classList.add('fa-chevron-up');
        text.textContent = 'Thu gọn';
        toggleBtn.classList.add('expanded');

        
        hiddenProducts.style.maxHeight = hiddenProducts.scrollHeight + 'px';
        setTimeout(() => {
            hiddenProducts.style.maxHeight = 'none';
        }, 300);
    } else {
        
        hiddenProducts.style.maxHeight = hiddenProducts.scrollHeight + 'px';

        
        void hiddenProducts.offsetHeight;

        hiddenProducts.style.maxHeight = '0';

        setTimeout(() => {
            hiddenProducts.style.display = 'none';
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');

            
            const orderCard = toggleBtn.closest('.order-card');
            const allProducts = orderCard.querySelectorAll('.product-item').length;
            text.textContent = `Xem đầy đủ (${allProducts} sản phẩm)`;
            toggleBtn.classList.remove('expanded');
        }, 300);
    }
}




function animateOrderCards() {
    const orderCards = document.querySelectorAll('.order-card');

    orderCards.forEach((card, index) => {
        
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.4s ease, transform 0.4s ease';

        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}




function initSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');

    links.forEach(link => {
        link.addEventListener('click', function (e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const target = document.querySelector(targetId);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}






function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}





function copyOrderId(orderId) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(orderId).then(() => {
            showNotification('Đã copy mã đơn hàng!', 'success');
        }).catch(err => {
            console.error('Không thể copy:', err);
        });
    } else {
        
        const tempInput = document.createElement('input');
        tempInput.value = orderId;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand('copy');
        document.body.removeChild(tempInput);
        showNotification('Đã copy mã đơn hàng!', 'success');
    }
}






function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 16px 24px;
        background: ${type === 'success' ? '#2d6a2d' : type === 'error' ? '#dc3545' : '#17a2b8'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideIn 0.3s ease;
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}


const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .hidden-products {
        overflow: hidden;
        transition: max-height 0.3s ease;
    }
`;
document.head.appendChild(style);
