
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
        const btnBuyNow = document.getElementById('btnBuyNow');

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


        let currentStock = null;
        let stockFetched = false;

        const updatePlusButtonState = () => {
            const plusBtn = document.querySelector('.qty-btn[data-step="1"]');
            if (!plusBtn || !qtyInput) return;
            const currentQty = Number(qtyInput.value);
            if (stockFetched && currentQty >= currentStock) {
                plusBtn.disabled = false;
                plusBtn.style.opacity = '0.5';
                plusBtn.style.cursor = 'not-allowed';
            } else {
                plusBtn.disabled = false;
                plusBtn.style.opacity = '1';
                plusBtn.style.cursor = 'pointer';
            }
        };

        const fetchStock = () => {
            const productId = document.getElementById('productId')?.value;
            let selectedVariant = document.querySelector('input[name="variantId"]:checked');
            if (!selectedVariant) {
                selectedVariant = document.querySelector('input[name="weight"]:checked');
            }
            if (!productId) return;

            const variantId = selectedVariant ? selectedVariant.value : '';

            const url = new URL((window.contextPath || '') + '/api/product/stock', window.location.origin);
            url.searchParams.append('productId', productId);
            if (variantId) url.searchParams.append('variantId', variantId);

            fetch(url)
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        currentStock = data.stock;
                        stockFetched = true;

                        if (qtyInput && Number(qtyInput.value) > currentStock) {
                            qtyInput.value = Math.max(1, currentStock);
                        }
                        updatePlusButtonState();
                    }
                })
                .catch(err => console.error('Error fetching stock:', err));
        };

        document.querySelectorAll('input[name="variantId"]').forEach(radio => {
            radio.addEventListener('change', () => {
                updatePrice();
                fetchStock();
                if (qtyInput) {
                    qtyInput.value = 1;
                    updatePlusButtonState();
                }
            });
        });

        document.querySelectorAll('input[name="weight"]').forEach(radio => {
            radio.addEventListener('change', () => {
                updatePrice();
                fetchStock();
                if (qtyInput) {
                    qtyInput.value = 1;
                    updatePlusButtonState();
                }
            });
        });


        document.querySelectorAll('.qty-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const step = Number(btn.dataset.step);
                if (qtyInput) {
                    if (step === 1 && stockFetched) {
                        if (Number(qtyInput.value) >= currentStock) {
                            showToast('Số lượng tồn kho không đủ. Chỉ còn ' + currentStock + ' sản phẩm.', 'warning');
                            return;
                        }
                    }
                    qtyInput.value = clampQty(Number(qtyInput.value) + step);
                    updatePlusButtonState();
                }
            });
        });

        if (qtyInput) {
            qtyInput.addEventListener('input', () => {
                let val = clampQty(qtyInput.value);
                if (stockFetched && val > currentStock) {
                    val = Math.max(1, currentStock);
                    showToast('Số lượng tồn kho không đủ. Chỉ còn ' + currentStock + ' sản phẩm.', 'warning');
                }
                qtyInput.value = val;
                updatePlusButtonState();
            });
        }


        updatePrice();
        fetchStock();


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


        const handlePurchase = (isBuyNow) => {
            console.log('handlePurchase triggered! isBuyNow:', isBuyNow);

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
                if (!isBuyNow) submitBtn.textContent = 'Đang xử lý...';
            }

            const originalBuyNowText = btnBuyNow ? btnBuyNow.textContent : '';
            if (btnBuyNow) {
                btnBuyNow.disabled = true;
                if (isBuyNow) btnBuyNow.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            }

            if (isBuyNow) {
                if (window.isLoggedIn === false) {
                    if (confirm('Vui lòng đăng nhập để mua hàng.\n\nBấm OK để chuyển đến trang đăng nhập.')) {
                        window.location.href = (window.contextPath || '') + '/DangNhap.jsp';
                    }
                    if (btnBuyNow) {
                        btnBuyNow.disabled = false;
                        btnBuyNow.innerHTML = originalBuyNowText;
                    }
                    const submitBtn = purchaseForm.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.textContent = originalText;
                    }
                    return;
                }

                const url = new URL((window.contextPath || '') + '/thanh-toan', window.location.origin);
                url.searchParams.append('buyNow', 'true');
                url.searchParams.append('productId', productId);
                if (variantId) url.searchParams.append('variantId', variantId);
                url.searchParams.append('quantity', qty);
                window.location.href = url.pathname + url.search;
                return;
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
                    console.error('Purchase error:', error);
                    alert('Có lỗi xảy ra, vui lòng thử lại!');
                })
                .finally(() => {
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        if (!isBuyNow) submitBtn.textContent = originalText;
                    }
                    if (btnBuyNow) {
                        btnBuyNow.disabled = false;
                        if (isBuyNow) btnBuyNow.textContent = originalBuyNowText;
                    }
                });
        };

        purchaseForm.addEventListener('submit', (e) => {
            e.preventDefault();
            handlePurchase(false);
        });

        if (btnBuyNow) {
            btnBuyNow.addEventListener('click', (e) => {
                e.preventDefault();
                handlePurchase(true);
            });
        }

        function showToast(message, type) {
            type = type || 'info';
            const toast = document.createElement('div');
            toast.className = 'toast-notification toast-' + type;
            let icon = 'fa-check-circle';
            if (type === 'warning') icon = 'fa-exclamation-triangle';
            toast.innerHTML = '<i class="fas ' + icon + '"></i> ' + message;

            let bgColor = '#3b82f6';
            if (type === 'success') bgColor = '#16a34a';
            else if (type === 'warning') bgColor = '#f59e0b';

            toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:' +
                bgColor +
                ';color:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,.15);z-index:9999;display:flex;align-items:center;gap:8px;font-weight:500;animation:slideIn .3s ease;';
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        function bindReportButtons() {
            document.querySelectorAll('.report-btn:not([data-bound])').forEach(btn => {
                btn.dataset.bound = 'true';
                btn.addEventListener('click', async function () {
                    if (!window.isLoggedIn) {
                        alert('Vui lòng đăng nhập để báo cáo');
                        return;
                    }
                    if (!confirm('Bạn có chắc muốn báo cáo đánh giá này?')) return;

                    const reviewId = this.dataset.reviewId;
                    try {
                        const res = await fetch((window.contextPath || '') + '/api/review/report', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'reviewId=' + reviewId
                        });

                        if (res.ok) {
                            this.disabled = true;
                            this.innerHTML = '<i class="fas fa-flag"></i> Đã báo cáo';
                            this.classList.add('reported');
                            if (typeof showToast === 'function') {
                                showToast('Đã báo cáo đánh giá!', 'success');
                            }
                        } else {
                            alert('Có lỗi xảy ra khi báo cáo.');
                        }
                    } catch (err) {
                        console.error('Report error:', err);
                        alert('Có lỗi xảy ra, vui lòng thử lại.');
                    }
                });
            });
        }
        bindReportButtons();

        function bindHelpfulButtons() {
            document.querySelectorAll('.helpful-btn:not([data-bound])').forEach(btn => {
                btn.dataset.bound = 'true';
                btn.addEventListener('click', function () {
                    if (!window.isLoggedIn) {
                        alert('Vui lòng đăng nhập để đánh dấu hữu ích');
                        return;
                    }

                    const reviewId = this.dataset.reviewId;
                    const wasHelpful = this.dataset.helpfulByUser === 'true';
                    const currentCount = parseInt(this.dataset.helpfulCount) || 0;
                    const countEl = this.querySelector('.helpful-count');
                    const icon = this.querySelector('i');
                    const newCount = wasHelpful ? currentCount - 1 : currentCount + 1;

                    // Optimistic update
                    this.dataset.helpfulByUser = String(!wasHelpful);
                    this.dataset.helpfulCount = String(newCount);
                    this.classList.toggle('is-helpful');
                    if (icon) icon.className = !wasHelpful ? 'fas fa-thumbs-up' : 'far fa-thumbs-up';
                    if (newCount > 0) {
                        if (countEl) countEl.textContent = newCount;
                        else this.insertAdjacentHTML('beforeend', ` (<span class="helpful-count">${newCount}</span>)`);
                    } else if (countEl) {
                        countEl.parentNode.removeChild(countEl);
                    }

                    fetch(`${window.contextPath || ''}/review-api/helpful?reviewId=${reviewId}`, { method: 'POST' })
                        .then(r => r.json())
                        .then(data => {
                            this.dataset.helpfulByUser = String(data.helpful);
                            this.dataset.helpfulCount = String(data.count);
                            const syncEl = this.querySelector('.helpful-count');
                            if (data.count > 0) {
                                if (syncEl) syncEl.textContent = data.count;
                                else this.insertAdjacentHTML('beforeend', ` (<span class="helpful-count">${data.count}</span>)`);
                            } else if (syncEl) syncEl.parentNode.removeChild(syncEl);
                        })
                        .catch(() => {
                            // Rollback
                            this.dataset.helpfulByUser = String(wasHelpful);
                            this.dataset.helpfulCount = String(currentCount);
                            this.classList.toggle('is-helpful');
                            if (icon) icon.className = wasHelpful ? 'fas fa-thumbs-up' : 'far fa-thumbs-up';
                            const rollbackEl = this.querySelector('.helpful-count');
                            if (currentCount > 0) {
                                if (rollbackEl) rollbackEl.textContent = currentCount;
                                else this.insertAdjacentHTML('beforeend', ` (<span class="helpful-count">${currentCount}</span>)`);
                            } else if (rollbackEl) rollbackEl.parentNode.removeChild(rollbackEl);
                        });
                });
            });
        }
        bindHelpfulButtons();


        // Review filter + load-more (AJAX)
        let activeFilter = 'all';
        let activeVariantId = null;
        let reviewCurrentPage = 1;
        const productId = window.productData ? window.productData.id : 0;

        function buildReviewHtml(review) {
            const stars = Array.from({ length: 5 }, (_, i) =>
                i < review.rating
                    ? '<i class="fas fa-star"></i>'
                    : '<i class="far fa-star"></i>'
            ).join('');

            const verified = review.verifiedPurchase
                ? '<span class="verified"><i class="fas fa-check-circle"></i> Đã mua hàng</span>'
                : '';

            const variant = review.variantDisplayText
                ? `<div class="review-variant">Phân loại: ${escapeHtml(review.variantDisplayText)}</div>`
                : '';

            let imagesHtml = '';
            if (review.hasImages && review.images && review.images.length > 0) {
                imagesHtml = '<div class="review-media-grid">' +
                    review.images.map(m => {
                        if (m.mediaType === 'video') {
                            return `<video src="${escapeHtml(m.imageUrl)}" preload="metadata" class="review-media-thumb"></video>`;
                        }
                        return `<img src="${escapeHtml(m.imageUrl)}" alt="Ảnh đánh giá" class="review-media-thumb">`;
                    }).join('') +
                    '</div>';
            }

            return `<article class="review-item" data-rating="${review.rating}"
                        data-verified="${review.verifiedPurchase}"
                        data-has-images="${review.hasImages}">
                        <div class="review-header">
                            <div class="user-avatar">${escapeHtml(review.userInitial)}</div>
                            <div class="user-info">
                                <h4 class="user-name">${escapeHtml(review.userDisplayName)}</h4>
                                <div class="review-meta">
                                    <div class="stars">${stars}</div>
                                    <span class="date">${escapeHtml(review.formattedDate)}</span>
                                    ${verified}
                                </div>
                            </div>
                        </div>
                        <div class="review-content">
                            <p class="review-text">${escapeHtml(review.reviewText)}</p>
                            ${variant}
                            ${imagesHtml}
                            <div class="review-actions">
                                <button class="action-btn helpful-btn ${review.helpfulByCurrentUser ? 'is-helpful' : ''}"
                                        data-review-id="${review.id}"
                                        data-helpful-count="${review.helpfulCount || 0}"
                                        data-helpful-by-user="${review.helpfulByCurrentUser || false}">
                                    <i class="${review.helpfulByCurrentUser ? 'fas' : 'far'} fa-thumbs-up"></i>
                                    Hữu ích${review.helpfulCount > 0 ? ` (<span class="helpful-count">${review.helpfulCount}</span>)` : ''}
                                </button>
                                <button class="action-btn report-btn"
                                        data-review-id="${review.id}"
                                        title="Báo cáo đánh giá không phù hợp">
                                    <i class="far fa-flag"></i> Báo cáo
                                </button>
                            </div>
                        </div>
                    </article>`;
        }

        function escapeHtml(str) {
            if (!str) return '';
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function buildReviewApiUrl(filter, variantId, page) {
            let url = `${window.contextPath}/review-api?productId=${productId}&page=${page}`;
            if (filter === 'variant' && variantId) {
                url += `&filter=variant&variantId=${variantId}`;
            } else if (filter && filter !== 'all') {
                url += `&filter=${encodeURIComponent(filter)}`;
                if (filter.match(/^[1-5]$/)) url += `&rating=${filter}`;
            } else {
                url += '&filter=all';
            }
            return url;
        }

        function loadReviews(filter, variantId, page, append) {
            const list = document.querySelector('.reviews-list');
            const btnLoadMore = document.getElementById('btnLoadMore');
            if (!list) return;

            if (!append) {
                list.innerHTML = '<div style="text-align:center;padding:20px;color:#6b7280;">Đang tải...</div>';
            }
            if (btnLoadMore) { btnLoadMore.disabled = true; btnLoadMore.textContent = 'Đang tải...'; }

            fetch(buildReviewApiUrl(filter, variantId, page))
                .then(r => r.json())
                .then(data => {
                    if (!append) {
                        if (data.reviews && data.reviews.length > 0) {
                            list.innerHTML = data.reviews.map(buildReviewHtml).join('');
                        } else {
                            list.innerHTML = '<div class="no-reviews" style="text-align:center;padding:40px;color:#6b7280;">' +
                                '<i class="far fa-comment-dots" style="font-size:48px;margin-bottom:16px;"></i>' +
                                '<p>Không có đánh giá nào phù hợp.</p></div>';
                        }
                    } else {
                        if (data.reviews && data.reviews.length > 0) {
                            list.insertAdjacentHTML('beforeend', data.reviews.map(buildReviewHtml).join(''));
                        }
                    }

                    reviewCurrentPage = data.page;
                    const container = document.getElementById('loadMoreContainer');
                    if (btnLoadMore && container) {
                        if (data.hasMore) {
                            btnLoadMore.disabled = false;
                            btnLoadMore.textContent = 'Xem thêm đánh giá';
                            container.style.display = '';
                        } else {
                            container.style.display = 'none';
                        }
                    }

                    bindReportButtons();
                    bindHelpfulButtons();
                })
                .catch(() => {
                    if (!append) list.innerHTML = '<div style="text-align:center;padding:20px;color:#e53e3e;">Có lỗi xảy ra khi tải đánh giá.</div>';
                    if (btnLoadMore) { btnLoadMore.disabled = false; btnLoadMore.textContent = 'Xem thêm đánh giá'; }
                });
        }

        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                activeFilter = btn.dataset.filter;
                activeVariantId = btn.dataset.variantId || null;
                reviewCurrentPage = 1;
                loadReviews(activeFilter, activeVariantId, 1, false);
            });
        });

        const btnLoadMore = document.getElementById('btnLoadMore');
        if (btnLoadMore) {
            btnLoadMore.addEventListener('click', () => {
                loadReviews(activeFilter, activeVariantId, reviewCurrentPage + 1, true);
            });
        }
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
