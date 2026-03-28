
(function () {
    'use strict';


    const init = function () {
        console.log('ChiTietSanPham.js initialized');


        const formatVND = n => (n || 0).toLocaleString('vi-VN') + 'đ';
        const clampQty = n => {
            n = parseInt(n, 10);
            if (isNaN(n) || n < 1) return 1;
            if (n > 99) return 99;
            return n;
        };


        const mainImg = document.getElementById('mainImg');
        const thumbs = Array.from(document.querySelectorAll('.thumb'));
        const priceEl = document.getElementById('price');
        const qtyInput = document.getElementById('qtyInput');
        const purchaseForm = document.getElementById('purchaseForm');
        const msgEl = document.getElementById('msg');


        if (!purchaseForm) {
            console.log('purchaseForm not found, exiting init');
            return;
        }


        thumbs.forEach(btn => {
            btn.addEventListener('click', () => {
                thumbs.forEach(b => b.classList.remove('is-active'));
                btn.classList.add('is-active');
                const imgTag = btn.querySelector('img');
                if (imgTag && mainImg) {
                    mainImg.src = imgTag.src;
                }
            });
        });


        document.querySelectorAll('.sp-photo-main .nav').forEach(nav => {
            nav.addEventListener('click', () => {
                const dir = Number(nav.dataset.dir);
                const idx = thumbs.findIndex(b => b.classList.contains('is-active'));
                let next = idx + dir;
                if (next < 0) next = thumbs.length - 1;
                if (next >= thumbs.length) next = 0;
                if (thumbs[next]) thumbs[next].click();
            });
        });


        const updatePrice = () => {
            let selected = document.querySelector('input[name="variantId"]:checked');
            if (!selected) {
                selected = document.querySelector('input[name="weight"]:checked');
            }

            if (selected && priceEl) {
                const basePrice = Number(selected.dataset.price || 0);

                let finalUnitPrice = basePrice;
                const flashSale = window.productData?.flashSale;

                if (flashSale) {
                    finalUnitPrice = basePrice * (1 - flashSale.discountPercent / 100);
                }

                if (flashSale) {
                    priceEl.innerHTML = `
                        <span class="current-price">${formatVND(finalUnitPrice)}</span>
                        <span class="old-price">${formatVND(basePrice)}</span>
                        <span class="badge-sale-percent">-${flashSale.discountPercent}%</span>
                    `;
                } else {
                    priceEl.textContent = formatVND(basePrice);
                }


            }
        };


        document.querySelectorAll('input[name="variantId"]').forEach(radio => {
            radio.addEventListener('change', updatePrice);
        });

        document.querySelectorAll('input[name="weight"]').forEach(radio => {
            radio.addEventListener('change', updatePrice);
        });


        document.querySelectorAll('.qty-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const step = Number(btn.dataset.step);
                if (qtyInput) {
                    qtyInput.value = clampQty(Number(qtyInput.value) + step);
                }
            });
        });

        if (qtyInput) {
            qtyInput.addEventListener('input', () => {
                qtyInput.value = clampQty(qtyInput.value);
            });
        }


        updatePrice();


        const initFlashSale = () => {
            const timerEl = document.getElementById('flashTimer');
            if (!timerEl) return;

            const endTime = parseInt(timerEl.dataset.endTime);
            const hEl = document.getElementById('h');
            const mEl = document.getElementById('m');
            const sEl = document.getElementById('s');

            const updateTimer = () => {
                const now = new Date().getTime();
                const diff = endTime - now;

                if (diff <= 0) {
                    timerEl.innerHTML = 'Hết thời gian';
                    return;
                }

                const h = Math.floor(diff / (1000 * 60 * 60));
                const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                const s = Math.floor((diff % (1000 * 60)) / 1000);

                if (hEl) hEl.textContent = String(h).padStart(2, '0');
                if (mEl) mEl.textContent = String(m).padStart(2, '0');
                if (sEl) sEl.textContent = String(s).padStart(2, '0');
            };

            updateTimer();
            setInterval(updateTimer, 1000);
        };

        initFlashSale();


        purchaseForm.addEventListener('submit', (e) => {
            e.preventDefault();
            console.log('Submit handler triggered!');


            let selectedVariant = document.querySelector('input[name="variantId"]:checked');
            if (!selectedVariant) {
                selectedVariant = document.querySelector('input[name="weight"]:checked');
            }


            const variantInputs = document.querySelectorAll('input[name="variantId"], input[name="weight"]');
            const hasVariants = variantInputs.length > 0;

            if (hasVariants && !selectedVariant) {
                alert('Vui lòng chọn phân loại/khối lượng!');
                return;
            }

            const productId = document.getElementById('productId')?.value || '';
            const variantId = selectedVariant ? selectedVariant.value : '';
            const unitPrice = selectedVariant ? Number(selectedVariant.dataset.price) : 0;
            const stock = selectedVariant ? Number(selectedVariant.dataset.stock || 999) : 999;
            const qty = clampQty(qtyInput ? qtyInput.value : 1);
            const variantText = selectedVariant?.nextElementSibling?.textContent?.trim() || '';
            const productName = document.querySelector('.sp-title')?.textContent?.trim() || '';


            console.log('Add to cart:', { productId, variantId, qty, hasVariants });

            if (!productId) {
                alert('Không tìm thấy thông tin sản phẩm!');
                return;
            }

            if (qty > stock) {
                alert('Số lượng tồn kho không đủ! Chỉ còn ' + stock + ' sản phẩm.');
                return;
            }


            const submitBtn = purchaseForm.querySelector('button[type="submit"]');
            const originalText = submitBtn ? submitBtn.textContent : '';
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = 'Đang xử lý...';
            }


            const params = new URLSearchParams();
            params.append('productId', productId);
            if (variantId) params.append('variantId', variantId);
            params.append('quantity', qty);

            fetch((window.contextPath || '') + '/api/cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {

                        if (typeof updateCartBadge === 'function') {
                            updateCartBadge(data.cartCount);
                        } else {
                            const cartBadge = document.getElementById('cartCount');
                            if (cartBadge) cartBadge.textContent = data.cartCount;
                        }


                        if (msgEl) {
                            const msg = variantText
                                ? '✓ Đã thêm ' + qty + ' × ' + productName + ' (' + variantText + ') vào giỏ!'
                                : '✓ Đã thêm ' + qty + ' × ' + productName + ' vào giỏ!';
                            msgEl.textContent = msg;
                            msgEl.style.color = '#16a34a';
                            setTimeout(() => { msgEl.textContent = ''; }, 4000);
                        }


                        showToast('Đã thêm vào giỏ hàng!', 'success');
                    } else {

                        if (data.requireLogin) {
                            if (confirm('Vui lòng đăng nhập để thêm vào giỏ hàng.\n\nBấm OK để chuyển đến trang đăng nhập.')) {
                                window.location.href = (window.contextPath || '') + '/DangNhap.jsp';
                            }
                        } else {
                            alert(data.message || 'Có lỗi xảy ra');
                        }
                    }
                })
                .catch(error => {
                    console.error('Add to cart error:', error);
                    alert('Có lỗi xảy ra, vui lòng thử lại!');
                })
                .finally(() => {
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.textContent = originalText;
                    }
                });
        });

        function showToast(message, type) {
            type = type || 'info';
            const toast = document.createElement('div');
            toast.className = 'toast-notification toast-' + type;
            toast.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
            toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:' +
                (type === 'success' ? '#16a34a' : '#3b82f6') +
                ';color:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,.15);z-index:9999;display:flex;align-items:center;gap:8px;font-weight:500;animation:slideIn .3s ease;';
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }


        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                const filter = btn.dataset.filter;
                const reviewItems = document.querySelectorAll('.review-item');

                reviewItems.forEach(item => {
                    const rating = item.dataset.rating;
                    const verified = item.dataset.verified === 'true';
                    const hasImages = item.dataset.hasImages === 'true';
                    let show = false;

                    switch (filter) {
                        case 'all': show = true; break;
                        case '5': case '4': case '3': case '2': case '1':
                            show = rating === filter; break;
                        case 'with-images': show = hasImages; break;
                        case 'verified': show = verified; break;
                        default: show = true;
                    }

                    item.style.display = show ? 'block' : 'none';
                });
            });
        });
    };


    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {

        init();
    }

})();

(function () {
    function initWishlist() {
        var wishlistBtn = document.getElementById('wishlistBtn');
        console.log('[Wishlist] Init - Button found:', !!wishlistBtn);
        if (!wishlistBtn) return;

        wishlistBtn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            console.log('[Wishlist] Button clicked');
            var productId = this.dataset.productId;
            console.log('[Wishlist] Product ID:', productId);
            var icon = this.querySelector('i');
            var btn = this;

            btn.disabled = true;

            fetch((window.contextPath || '') + '/api/wishlist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'productId=' + productId
            })
                .then(function (response) { return response.json(); })
                .then(function (data) {
                    console.log('[Wishlist] API Response:', data);
                    if (data.success) {
                        if (data.added) {
                            btn.classList.add('active');
                            icon.className = 'fas fa-heart';
                            btn.title = 'Xoa khoi yeu thich';
                        } else {
                            btn.classList.remove('active');
                            icon.className = 'far fa-heart';
                            btn.title = 'Them vao yeu thich';
                        }
                        var badge = document.getElementById('wishlistCount');
                        if (badge) {
                            badge.textContent = data.wishlistCount;
                            if (data.wishlistCount > 0) badge.classList.remove('badge-hidden');
                            else badge.classList.add('badge-hidden');
                        }
                    } else if (data.requireLogin) {
                        if (confirm('Vui long dang nhap de them vao yeu thich.')) {
                            window.location.href = (window.contextPath || '') + '/DangNhap.jsp';
                        }
                    } else {
                        alert(data.message || 'Co loi xay ra');
                    }
                })
                .catch(function (error) { console.error('Wishlist error:', error); })
                .finally(function () { btn.disabled = false; });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initWishlist);
    } else {
        initWishlist();
    }
})();
