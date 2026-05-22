(function () {
    'use strict';

    const MAX_IMAGES = 5;
    const MAX_VIDEOS = 1;
    const MAX_SIZE = 10 * 1024 * 1024;

    function init() {
        document.querySelectorAll('.review-form').forEach(form => {
            const input = form.querySelector('.media-file-input');
            const preview = form.querySelector('.media-preview');
            if (!input || !preview) return;

            const selected = [];

            input.addEventListener('change', function () {
                for (const file of Array.from(this.files)) {
                    if (validate(file, selected)) {
                        selected.push(file);
                        addPreview(file, preview, selected, input);
                    }
                }
                this.value = '';
                syncInput(input, selected);
            });

            form.addEventListener('submit', function () {
                const btn = form.querySelector('button[type=submit]');
                if (btn) {
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
                }
            });
        });
    }

    function validate(file, current) {
        if (file.size > MAX_SIZE) {
            alert('File "' + file.name + '" vượt quá 10MB');
            return false;
        }
        const isVideo = file.type.startsWith('video/');
        const isImage = file.type.startsWith('image/');
        if (!isVideo && !isImage) {
            alert('File "' + file.name + '" không phải ảnh hoặc video');
            return false;
        }
        const imgCount = current.filter(f => f.type.startsWith('image/')).length;
        const vidCount = current.filter(f => f.type.startsWith('video/')).length;
        if (isImage && imgCount >= MAX_IMAGES) {
            alert('Tối đa ' + MAX_IMAGES + ' ảnh');
            return false;
        }
        if (isVideo && vidCount >= MAX_VIDEOS) {
            alert('Tối đa ' + MAX_VIDEOS + ' video');
            return false;
        }
        return true;
    }

    function addPreview(file, container, list, input) {
        const wrap = document.createElement('div');
        wrap.className = 'media-preview-item';
        const url = URL.createObjectURL(file);
        const isVideo = file.type.startsWith('video/');
        wrap.innerHTML = isVideo
            ? '<video src="' + url + '" muted></video><button type="button" class="remove-btn" aria-label="Xóa">&times;</button>'
            : '<img src="' + url + '" alt=""><button type="button" class="remove-btn" aria-label="Xóa">&times;</button>';

        wrap.querySelector('.remove-btn').addEventListener('click', function () {
            const idx = list.indexOf(file);
            if (idx >= 0) list.splice(idx, 1);
            URL.revokeObjectURL(url);
            wrap.remove();
            syncInput(input, list);
        });
        container.appendChild(wrap);
    }

    function syncInput(input, files) {
        try {
            const dt = new DataTransfer();
            files.forEach(f => dt.items.add(f));
            input.files = dt.files;
        } catch (e) {
            console.warn('DataTransfer not supported, files may not submit correctly');
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
