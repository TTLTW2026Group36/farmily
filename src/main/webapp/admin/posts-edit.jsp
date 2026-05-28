<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa Bài viết - Admin Farmily</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/posts.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                
                <script
                    src="https://cdn.tiny.cloud/1/55k82785hwgngja2sfqjim6xvkxnmmpkj79wkzdhyx8z571l/tinymce/8/tinymce.min.js"
                    referrerpolicy="origin"></script>

                <style>
                    .alert {
                        padding: 12px 16px;
                        border-radius: 8px;
                        margin-bottom: 16px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .alert-error {
                        background: #fef2f2;
                        color: #dc2626;
                        border: 1px solid #fecaca;
                    }

                    .alert-success {
                        background: #dcfce7;
                        color: #166534;
                        border: 1px solid #bbf7d0;
                    }

                    .editor-container {
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        overflow: hidden;
                    }

                    .tox-tinymce {
                        border: none !important;
                        border-radius: 8px !important;
                    }

                    .editor-note {
                        background: #f0fdf4;
                        border: 1px solid #bbf7d0;
                        border-radius: 8px;
                        padding: 12px 16px;
                        margin-bottom: 16px;
                        display: flex;
                        align-items: flex-start;
                        gap: 10px;
                    }

                    .editor-note i {
                        color: #22c55e;
                        margin-top: 2px;
                    }

                    .editor-note p {
                        margin: 0;
                        color: #166534;
                        font-size: 14px;
                    }

                    /* Toast Notification Center */
                    .toast-container {
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        z-index: 9999;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 12px;
                        pointer-events: none;
                    }

                    .custom-toast {
                        pointer-events: auto;
                        background: rgba(255, 255, 255, 0.98);
                        border-left: 5px solid #3b82f6;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                        padding: 16px 28px;
                        border-radius: 8px;
                        font-size: 15px;
                        font-weight: 500;
                        color: #1e293b;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        min-width: 320px;
                        max-width: 480px;
                        animation: toastFadeIn 0.35s cubic-bezier(0.34, 1.56, 0.64, 1), toastFadeOut 0.35s ease forwards 2.65s;
                        backdrop-filter: blur(8px);
                        border: 1px solid rgba(226, 232, 240, 0.8);
                    }

                    .custom-toast.toast-success {
                        border-left-color: #22c55e;
                    }

                    .custom-toast.toast-error {
                        border-left-color: #ef4444;
                    }

                    .custom-toast.toast-warning {
                        border-left-color: #f59e0b;
                    }

                    .custom-toast i {
                        font-size: 18px;
                    }

                    .custom-toast.toast-success i {
                        color: #22c55e;
                    }

                    .custom-toast.toast-error i {
                        color: #ef4444;
                    }

                    .custom-toast.toast-warning i {
                        color: #f59e0b;
                    }

                    /* Custom Confirm Dialog */
                    .confirm-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(15, 23, 42, 0.45);
                        backdrop-filter: blur(4px);
                        z-index: 10000;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        animation: fadeInBg 0.2s ease;
                    }

                    .confirm-box {
                        background: #ffffff;
                        border-radius: 12px;
                        padding: 24px;
                        width: 90%;
                        max-width: 400px;
                        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.05);
                        text-align: center;
                        animation: scaleInConfirm 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
                        border: 1px solid rgba(226, 232, 240, 0.8);
                    }

                    .confirm-box i {
                        font-size: 42px;
                        color: #eab308;
                        margin-bottom: 16px;
                    }

                    .confirm-box h3 {
                        margin: 0 0 8px 0;
                        font-size: 18px;
                        color: #0f172a;
                        font-weight: 600;
                    }

                    .confirm-box p {
                        margin: 0 0 24px 0;
                        font-size: 14px;
                        color: #64748b;
                        line-height: 1.5;
                    }

                    .confirm-buttons {
                        display: flex;
                        gap: 12px;
                        justify-content: center;
                    }

                    .confirm-btn {
                        padding: 10px 22px;
                        border-radius: 6px;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.2s;
                        border: 1px solid transparent;
                    }

                    .confirm-btn-cancel {
                        background: #f8fafc;
                        color: #475569;
                        border-color: #cbd5e1;
                    }

                    .confirm-btn-cancel:hover {
                        background: #f1f5f9;
                        border-color: #94a3b8;
                    }

                    .confirm-btn-ok {
                        background: #0f172a;
                        color: #ffffff;
                    }

                    .confirm-btn-ok:hover {
                        background: #1e293b;
                    }

                    @keyframes toastFadeIn {
                        from {
                            opacity: 0;
                            transform: scale(0.9);
                        }
                        to {
                            opacity: 1;
                            transform: scale(1);
                        }
                    }

                    @keyframes toastFadeOut {
                        from {
                            opacity: 1;
                            transform: scale(1);
                        }
                        to {
                            opacity: 0;
                            transform: scale(0.9);
                        }
                    }

                    @keyframes fadeInBg {
                        from { opacity: 0; }
                        to { opacity: 1; }
                    }

                    @keyframes scaleInConfirm {
                        from { transform: scale(0.9); opacity: 0; }
                        to { transform: scale(1); opacity: 1; }
                    }

                    /* Form Controls styling overrides for Premium look */
                    .form-control {
                        width: 100%;
                        padding: 10px 16px;
                        border: 1px solid #cbd5e1;
                        border-radius: 8px;
                        font-size: 14px;
                        color: #1e293b;
                        background-color: #ffffff;
                        transition: all 0.2s ease-in-out;
                        box-sizing: border-box;
                    }

                    .form-control:focus {
                        border-color: #22c55e;
                        outline: none;
                        box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
                    }

                    .form-control:disabled {
                        background-color: #f8fafc;
                        color: #94a3b8;
                        cursor: not-allowed;
                        border-color: #e2e8f0;
                    }

                    textarea.form-control {
                        resize: vertical;
                        min-height: 100px;
                        line-height: 1.5;
                    }

                    select.form-control {
                        appearance: none;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 16px center;
                        background-size: 16px;
                        padding-right: 40px;
                        cursor: pointer;
                    }
                </style>
            </head>

            <body>
                <div class="admin-layout">
                    <jsp:include page="sidebar.jsp" />

                    <main class="admin-main">
                        <jsp:include page="header.jsp" />

                        <div class="admin-content">
                            <div class="content-header">
                                <div>
                                    <h1 class="content-title">Chỉnh sửa Bài viết</h1>
                                    <div class="content-breadcrumb">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="fas fa-home"></i> Dashboard</a>
                                        <span>/</span>
                                        <a href="${pageContext.request.contextPath}/admin/posts">Bài viết</a>
                                        <span>/</span>
                                        <span>Chỉnh sửa</span>
                                    </div>
                                </div>
                            </div>

                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-circle"></i> ${error}
                                </div>
                            </c:if>

                            <form class="post-form" action="${pageContext.request.contextPath}/admin/posts/edit"
                                method="POST" id="editForm">
                                <input type="hidden" name="id" value="${post.id}">

                                <div class="post-form-grid">

                                    
                                    <div class="post-main-content">
                                        
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Ảnh đại diện</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="image-upload-area">
                                                    <div class="upload-placeholder" id="imageContainer">
                                                        <c:choose>
                                                            <c:when test="${not empty post.imageUrl}">
                                                                <img src="${post.imageUrl}" id="previewImg"
                                                                    style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-image"
                                                                    style="font-size: 48px; color: #cbd5e1;"></i>
                                                                <p style="color: #64748b;">Chưa có ảnh</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="form-group" style="margin-top: 12px;">
                                                    <label for="imageUrl">URL ảnh mới</label>
                                                    <input type="text" id="imageUrl" name="imageUrl"
                                                        class="form-control"
                                                        value="${post.imageUrl}"
                                                        placeholder="https://example.com/image.jpg">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Nội dung bài viết</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <label for="postId">ID bài viết</label>
                                                    <input type="text" id="postId" class="form-control" value="${post.id}" disabled>
                                                </div>

                                                <div class="form-group">
                                                    <label for="title">Tiêu đề bài viết <span
                                                            class="required">*</span></label>
                                                    <input type="text" id="title" name="title" class="form-control" value="${post.title}"
                                                        required>
                                                </div>

                                                <div class="form-group">
                                                    <label for="excerpt">Mô tả ngắn (Excerpt)</label>
                                                    <textarea id="excerpt" name="excerpt" class="form-control"
                                                        rows="3">${post.excerpt}</textarea>
                                                </div>

                                                <div class="form-group">
                                                    <label for="content">Nội dung <span
                                                            class="required">*</span></label>

                                                    <div class="editor-note">
                                                        <i class="fas fa-lightbulb"></i>
                                                        <p>Sử dụng thanh công cụ bên trên để format nội dung như trong
                                                            Word. Bạn có thể chèn hình ảnh, tạo danh sách, thay đổi font
                                                            chữ và nhiều hơn nữa!</p>
                                                    </div>

                                                    <div class="editor-container">
                                                        <textarea id="content" name="content">${post.content}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <div class="post-sidebar">
                                        
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Xuất bản</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <label for="status">Trạng thái</label>
                                                    <select id="status" name="status" class="form-control">
                                                        <option value="draft" ${post.status=='draft' ? 'selected' : ''
                                                            }>Nháp</option>
                                                        <option value="published" ${post.status=='published'
                                                            ? 'selected' : '' }>Đã đăng</option>
                                                        <option value="pending" ${post.status=='pending' ? 'selected'
                                                            : '' }>Chờ duyệt</option>
                                                    </select>
                                                </div>

                                                <div class="info-display" style="margin-top: 16px;">
                                                    <div class="info-item">
                                                        <span class="info-label">Lượt xem:</span>
                                                        <span class="info-value"><strong>
                                                                <fmt:formatNumber value="${post.viewCount}" />
                                                            </strong> lượt</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Ngày tạo:</span>
                                                        <span class="info-value">
                                                            <fmt:formatDate value="${post.createdAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <c:if test="${post.updatedAt != null}">
                                                        <div class="info-item">
                                                            <span class="info-label">Cập nhật:</span>
                                                            <span class="info-value">
                                                                <fmt:formatDate value="${post.updatedAt}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">Danh mục</h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <select id="categoryId" name="categoryId" class="form-control">
                                                        <option value="">-- Chọn danh mục --</option>
                                                        <c:forEach var="category" items="${categories}">
                                                            <option value="${category.id}"
                                                                ${post.categoryId==category.id ? 'selected' : '' }>
                                                                ${category.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/admin/posts" class="btn btn-outline">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                    <button type="button" class="btn btn-danger" id="btnDelete">
                                        <i class="fas fa-trash"></i> Xóa bài viết
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-check"></i> Cập nhật
                                    </button>
                                </div>
                            </form>

                        </div>
                    </main>
                </div>

                <script src="${pageContext.request.contextPath}/admin/js/sidebarHeader.js"></script>
                <script>
                    // Initialize TinyMCE
                    tinymce.init({
                        selector: '#content',
                        height: 500,
                        language: 'vi',
                        plugins: [
                            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                            'insertdatetime', 'media', 'table', 'help', 'wordcount'
                        ],
                        toolbar: 'undo redo | blocks | ' +
                            'bold italic underline strikethrough | forecolor backcolor | ' +
                            'alignleft aligncenter alignright alignjustify | ' +
                            'bullist numlist outdent indent | ' +
                            'link image media table | ' +
                            'removeformat | code fullscreen | help',
                        menubar: 'file edit view insert format tools table help',
                        content_style: `
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    padding: 10px;
                }
                h1, h2, h3, h4, h5, h6 { color: #1e293b; margin-top: 1em; margin-bottom: 0.5em; }
                p { margin: 0 0 1em 0; }
                ul, ol { margin: 0 0 1em 1.5em; }
                a { color: #22c55e; }
                img { max-width: 100%; height: auto; }
            `,
                        branding: false,
                        promotion: false,
                        statusbar: true,
                        resize: true,
                        browser_spellcheck: true,
                        contextmenu: 'link image table',
                        images_upload_handler: function (blobInfo, progress) {
                            return new Promise(function (resolve, reject) {
                                var reader = new FileReader();
                                reader.onload = function () {
                                    resolve(reader.result);
                                };
                                reader.onerror = function () {
                                    reject('Could not upload image');
                                };
                                reader.readAsDataURL(blobInfo.blob());
                            });
                        },
                        setup: function (editor) {
                            editor.on('submit', function () {
                                editor.save();
                            });
                        }
                    });

                    // Ensure TinyMCE content is saved before form submit
                    document.getElementById('editForm').addEventListener('submit', function (e) {
                        tinymce.triggerSave();
                    });

                    // Image URL preview
                    document.getElementById('imageUrl').addEventListener('input', function (e) {
                        const url = e.target.value.trim();
                        const container = document.getElementById('imageContainer');

                        if (url) {
                            container.innerHTML = '<img src="' + url + '" id="previewImg" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">';
                        }
                    });

                    // Helper functions for Custom Alerts and Confirms
                    function showAlert(type, message) {
                        let container = document.querySelector('.toast-container');
                        if (!container) {
                            container = document.createElement('div');
                            container.className = 'toast-container';
                            document.body.appendChild(container);
                        }

                        const toast = document.createElement('div');
                        toast.className = 'custom-toast toast-' + type;

                        let icon = 'info-circle';
                        if (type === 'success') icon = 'check-circle';
                        else if (type === 'error') icon = 'exclamation-circle';
                        else if (type === 'warning') icon = 'exclamation-triangle';

                        toast.innerHTML = '<i class="fas fa-' + icon + '"></i> <span>' + message + '</span>';
                        container.appendChild(toast);

                        setTimeout(() => {
                            toast.remove();
                            if (container.childElementCount === 0) {
                                container.remove();
                            }
                        }, 3000);
                    }

                    function showConfirm(title, message, onConfirm) {
                        const overlay = document.createElement('div');
                        overlay.className = 'confirm-overlay';
                        overlay.innerHTML = 
                            '<div class="confirm-box">' +
                                '<i class="fas fa-exclamation-triangle"></i>' +
                                '<h3>' + title + '</h3>' +
                                '<p>' + message + '</p>' +
                                '<div class="confirm-buttons">' +
                                    '<button class="confirm-btn confirm-btn-cancel">Hủy</button>' +
                                    '<button class="confirm-btn confirm-btn-ok">Xác nhận</button>' +
                                '</div>' +
                            '</div>';
                        document.body.appendChild(overlay);

                        overlay.querySelector('.confirm-btn-cancel').addEventListener('click', () => overlay.remove());
                        overlay.querySelector('.confirm-btn-ok').addEventListener('click', () => {
                            overlay.remove();
                            onConfirm();
                        });
                    }

                    // Delete button
                    document.getElementById('btnDelete').addEventListener('click', function () {
                        showConfirm('Xác nhận xóa', 'Bạn có chắc chắn muốn xóa vĩnh viễn bài viết này không?', () => {
                            const postId = '${post.id}';

                            fetch('${pageContext.request.contextPath}/admin/posts/delete', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: 'id=' + postId
                            })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        showAlert('success', 'Xóa bài viết thành công. Đang chuyển hướng...');
                                        setTimeout(() => {
                                            window.location.href = '${pageContext.request.contextPath}/admin/posts';
                                        }, 1500);
                                    } else {
                                        showAlert('error', data.message);
                                    }
                                })
                                .catch(err => {
                                    console.error(err);
                                    showAlert('error', 'Đã xảy ra lỗi khi xóa bài viết');
                                });
                        });
                    });
                </script>
            </body>

            </html>