document.addEventListener('DOMContentLoaded', function () {
    initSortButtons();
    initWishlistButtons();
    initPriceFilter();
});


function initSortButtons() {
    const sortButtons = document.querySelectorAll('.sort-btn');

    sortButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            const sortValue = this.getAttribute('data-sort');

            const url = new URL(window.location.href);

            if (sortValue && sortValue !== 'default') {
                url.searchParams.set('sort', sortValue);
            } else {
                url.searchParams.delete('sort');
            }

            url.searchParams.set('page', '1');

            window.location.href = url.toString();
        });
    });
}


function initWishlistButtons() {
    const wishlistBtns = document.querySelectorAll('.wishlist-btn');

    wishlistBtns.forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            const productId = this.getAttribute('data-product-id');
            const icon = this.querySelector('i');
            const currentBtn = this;

            currentBtn.disabled = true;

            fetch((window.contextPath || '') + '/api/wishlist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'same-origin',
                body: 'productId=' + productId
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (data.added) {
                            currentBtn.classList.add('active');
                            if (icon) {
                                icon.classList.remove('far');
                                icon.classList.add('fas');
                            }
                            currentBtn.style.animation = 'heartBeat 0.5s';
                            setTimeout(() => currentBtn.style.animation = '', 500);
                        } else {
                            currentBtn.classList.remove('active');
                            if (icon) {
                                icon.classList.remove('fas');
                                icon.classList.add('far');
                            }
                        }

                        const badge = document.getElementById('wishlistCount');
                        if (badge) {
                            badge.textContent = data.wishlistCount;
                            if (data.wishlistCount > 0) badge.classList.remove('badge-hidden');
                            else badge.classList.add('badge-hidden');
                        }
                    } else if (data.requireLogin) {
                        if (confirm('Vui lòng đăng nhập để thêm vào yêu thích.')) {
                            window.location.href = (window.contextPath || '') + '/DangNhap.jsp';
                        }
                    } else {
                        alert(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(error => {
                    console.error('Wishlist error:', error);
                    alert('Có lỗi xảy ra, vui lòng thử lại!');
                })
                .finally(() => {
                    currentBtn.disabled = false;
                });
        });
    });
}


function initPriceFilter() {
    const priceRange = document.getElementById('priceRange');
    const minPrice = document.getElementById('minPrice');
    const maxPrice = document.getElementById('maxPrice');

    if (priceRange && minPrice && maxPrice) {
        priceRange.addEventListener('input', function () {
            const value = parseInt(this.value);
            minPrice.textContent = '0 ₫';
            maxPrice.textContent = formatPrice(value) + ' ₫';
        });
    }
}


function formatPrice(price) {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
}


(function () {
    var s = document.createElement('style');
    s.textContent = `
        .filter-link.active { color: #27ae60; font-weight: 600; }
        .no-products {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .no-products i { font-size: 64px; color: #ccc; margin-bottom: 20px; }
        .no-products p { font-size: 18px; margin-bottom: 20px; }
        .btn-back {
            display: inline-block;
            padding: 12px 24px;
            background: #27ae60;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .btn-back:hover { background: #219a52; }
        .product-count { color: #666; font-size: 14px; margin-left: 10px; }
    `;
    document.head.appendChild(s);
})();
