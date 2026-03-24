<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Bài viết mới - Admin Farmily</title>
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
                                <h1 class="content-title">Thêm Bài viết mới</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                            class="fas fa-home"></i> Dashboard</a>
                                    <span>/</span>
                                    <a href="${pageContext.request.contextPath}/admin/posts">Bài viết</a>
                                    <span>/</span>
                                    <span>Thêm mới</span>
                                </div>
                            </div>
                        </div>

                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>

                        <form class="post-form" action="${pageContext.request.contextPath}/admin/posts/add"
                            method="POST" id="addForm">
                            <div class="post-form-grid">

                                
                                <div class="post-main-content">
                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Ảnh đại diện</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="imageUrl">URL ảnh đại diện</label>
                                                <input type="text" id="imageUrl" name="imageUrl"
                                                    placeholder="https://example.com/image.jpg">
                                                <small
                                                    style="color: #64748b; font-size: 12px; display: block; margin-top: 4px;">
                                                    Nhập URL ảnh hoặc để trống
                                                </small>
                                            </div>
                                            <div class="image-preview" id="imagePreview"
                                                style="display: none; margin-top: 12px;">
                                                <img src="" alt="Preview"
                                                    style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Nội dung bài viết</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="title">Tiêu đề bài viết <span
                                                        class="required">*</span></label>
                                                <input type="text" id="title" name="title"
                                                    placeholder="Nhập tiêu đề bài viết..." required>
                                            </div>

                                            <div class="form-group">
                                                <label for="excerpt">Mô tả ngắn (Excerpt)</label>
                                                <textarea id="excerpt" name="excerpt" rows="3"
                                                    placeholder="Nhập mô tả ngắn hiển thị trong danh sách bài viết..."></textarea>
                                            </div>

                                            <div class="form-group">
                                                <label for="content">Nội dung <span class="required">*</span></label>

                                                <div class="editor-note">
                                                    <i class="fas fa-lightbulb"></i>
                                                    <p>Sử dụng thanh công cụ bên trên để format nội dung như trong Word.
                                                        Bạn có thể chèn hình ảnh, tạo danh sách, thay đổi font chữ và
                                                        nhiều hơn nữa!</p>
                                                </div>

                                                <div class="editor-container">
                                                    <textarea id="content" name="content"></textarea>
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
                                                <select id="status" name="status">
                                                    <option value="draft">Nháp</option>
                                                    <option value="published">Đã đăng</option>
                                                    <option value="pending">Chờ duyệt</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Danh mục</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <select id="categoryId" name="categoryId">
                                                    <option value="">-- Chọn danh mục --</option>
                                                    <c:forEach var="category" items="${categories}">
                                                        <option value="${category.id}">${category.name}</option>
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
                                <button type="submit" name="submitAction" value="draft" class="btn btn-secondary">
                                    <i class="fas fa-save"></i> Lưu nháp
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane"></i> Xuất bản
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
                document.getElementById('addForm').addEventListener('submit', function (e) {
                    tinymce.triggerSave();
                });

                // Image URL preview
                document.getElementById('imageUrl').addEventListener('input', function (e) {
                    const url = e.target.value.trim();
                    const preview = document.getElementById('imagePreview');

                    if (url) {
                        preview.style.display = 'block';
                        preview.querySelector('img').src = url;
                    } else {
                        preview.style.display = 'none';
                    }
                });
            </script>
        </body>

        </html>