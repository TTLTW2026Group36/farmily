/**
 * Shared review media lightbox
 * Dùng chung cho ChiTietSanPham, DonHangList, admin/reviews
 *
 * Cách dùng:
 *   - Thêm class "review-media-thumb" vào img/video thumbnail
 *   - Wrap thumbnails trong container có class "review-media-grid"
 *   - Include file này + thêm #reviewSharedLightbox vào trang
 */
(function () {
    'use strict';

    var _items = [];
    var _idx = 0;

    function getLightbox() {
        return document.getElementById('reviewSharedLightbox');
    }

    function show(idx) {
        var item = _items[idx];
        if (!item) return;

        var img = document.getElementById('rslImg');
        var video = document.getElementById('rslVideo');
        var prev = document.getElementById('rslPrev');
        var next = document.getElementById('rslNext');

        if (item.isVideo) {
            if (img) img.style.display = 'none';
            if (video) { video.src = item.src; video.style.display = 'block'; }
        } else {
            if (video) { video.pause(); video.src = ''; video.style.display = 'none'; }
            if (img) { img.src = item.src; img.style.display = 'block'; }
        }

        if (prev) prev.style.display = _items.length > 1 ? '' : 'none';
        if (next) next.style.display = _items.length > 1 ? '' : 'none';
    }

    function open(el) {
        var src = el.getAttribute('src') || el.src || el.currentSrc;
        var isVideo = el.tagName === 'VIDEO';
        var container = el.closest('.review-media-grid');

        _items = [];
        if (container) {
            container.querySelectorAll('.review-media-thumb').forEach(function (m) {
                _items.push({
                    src: m.getAttribute('src') || m.src || m.currentSrc,
                    isVideo: m.tagName === 'VIDEO'
                });
            });
            _idx = _items.findIndex(function (m) { return m.src === src; });
            if (_idx < 0) _idx = 0;
        } else {
            _items = [{ src: src, isVideo: isVideo }];
            _idx = 0;
        }

        show(_idx);
        var lb = getLightbox();
        if (lb) { lb.classList.add('active'); document.body.style.overflow = 'hidden'; }
    }

    function close() {
        var lb = getLightbox();
        var video = document.getElementById('rslVideo');
        if (!lb) return;
        lb.classList.remove('active');
        if (video) { video.pause(); video.src = ''; }
        document.body.style.overflow = '';
        _items = [];
        _idx = 0;
    }

    function navigate(dir) {
        _idx = (_idx + dir + _items.length) % _items.length;
        show(_idx);
    }

    // Event delegation — bắt click trên bất kỳ .review-media-thumb nào
    document.addEventListener('click', function (e) {
        var el = e.target.closest('.review-media-thumb');
        if (!el) return;
        e.preventDefault();
        e.stopPropagation();
        open(el);
    });

    // Keyboard navigation
    document.addEventListener('keydown', function (e) {
        var lb = getLightbox();
        if (!lb || !lb.classList.contains('active')) return;
        if (e.key === 'Escape') close();
        if (e.key === 'ArrowLeft') navigate(-1);
        if (e.key === 'ArrowRight') navigate(1);
    });

    // Expose để nút close trong HTML gọi được
    window.reviewLightbox = { close: close, navigate: navigate };
})();
