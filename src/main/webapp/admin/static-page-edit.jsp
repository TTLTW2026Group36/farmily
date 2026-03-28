<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chỉnh sửa Trang tĩnh - Admin Farmily</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/header.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/categories-add.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


            <script
                src="https://cdn.tiny.cloud/1/55k82785hwgngja2sfqjim6xvkxnmmpkj79wkzdhyx8z571l/tinymce/8/tinymce.min.js"
                referrerpolicy="origin"></script>

            <style>
                .slug-display {
                    background: #f1f5f9;
                    padding: 10px 14px;
                    border-radius: 8px;
                    font-family: monospace;
                    color: #475569;
                    border: 1px solid #e2e8f0;
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
                                <h1 class="content-title">Chỉnh sửa: ${staticPage.title}</h1>
                                <div class="content-breadcrumb">
                                    <a href="${pageContext.request.contextPath}/admin/index"><i class="fas fa-home"></i>
                                        Dashboard</a>
                                    <span>/</span>
                                    <a href="${pageContext.request.contextPath}/admin/static-pages">Trang tĩnh</a>
                                    <span>/</span>
                                    <span>Chỉnh sửa</span>
                                </div>
                            </div>
                        </div>


                        <c:if test="${not empty error}">
                            <div class="alert alert-error"
                                style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                                <i class="fas fa-exclamation-circle"></i>
                                ${error}
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/admin/static-pages/edit"
                            class="edit-form" id="editForm">
                            <input type="hidden" name="id" value="${staticPage.id}" />

                            <div class="form-grid">

                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">Nội dung trang</h3>
                                    </div>
                                    <div class="card-body">
                                        <div class="form-group">
                                            <label for="pageTitle">Tiêu đề <span class="required">*</span></label>
                                            <input type="text" name="title" id="pageTitle" value="${staticPage.title}"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label for="pageSlug">Slug (URL)</label>
                                            <div class="slug-display" id="pageSlug">${staticPage.slug}</div>
                                            <small style="color: #64748b; margin-top: 6px; display: block;">
                                                <i class="fas fa-info-circle"></i> Slug không thể thay đổi để tránh phá
                                                vỡ liên kết URL.
                                            </small>
                                        </div>

                                        <div class="form-group">
                                            <label for="pageContent">Nội dung</label>

                                            <div class="editor-note">
                                                <i class="fas fa-lightbulb"></i>
                                                <p>Sử dụng thanh công cụ bên trên để format nội dung như trong Word. Bạn
                                                    có thể chèn hình ảnh, tạo danh sách, thay đổi font chữ và nhiều hơn
                                                    nữa!</p>
                                            </div>

                                            <div class="editor-container">
                                                <textarea name="content"
                                                    id="pageContent">${staticPage.content}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div>
                                    <div class="card" style="margin-bottom: 24px;">
                                        <div class="card-header">
                                            <h3 class="card-title">Cài đặt</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="form-group">
                                                <label for="pageType">Loại trang</label>
                                                <input type="text" name="type" id="pageType" value="${staticPage.type}"
                                                    placeholder="info, policy, guide...">
                                            </div>

                                            <div class="form-group">
                                                <label for="pageStatus">Trạng thái</label>
                                                <select name="status" id="pageStatus">
                                                    <option value="active" ${staticPage.status=='active' ? 'selected'
                                                        : '' }>Hiển thị</option>
                                                    <option value="inactive" ${staticPage.status=='inactive'
                                                        ? 'selected' : '' }>Ẩn</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">Thông tin</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="info-display">
                                                <div class="info-item">
                                                    <span class="info-label">ID:</span>
                                                    <span class="info-value"><strong>${staticPage.id}</strong></span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Ngày tạo:</span>
                                                    <span class="info-value">${staticPage.createdAt}</span>
                                                </div>
                                                <div class="info-item">
                                                    <span class="info-label">Cập nhật:</span>
                                                    <span class="info-value">${staticPage.updatedAt}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/admin/static-pages" class="btn btn-outline">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>

            <script>
                // Initialize TinyMCE
                tinymce.init({
                    selector: '#pageContent',
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
                    // Image upload placeholder (can be configured for actual upload)
                    images_upload_handler: function (blobInfo, progress) {
                        return new Promise(function (resolve, reject) {
                            // For now, use base64 encoding (can be replaced with actual upload endpoint)
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
                        // Ensure content is synced before form submit
                        editor.on('submit', function () {
                            editor.save();
                        });
                    }
                });

                // Ensure TinyMCE content is saved before form submit
                document.getElementById('editForm').addEventListener('submit', function (e) {
                    tinymce.triggerSave();
                });
            </script>
        </body>

        </html>