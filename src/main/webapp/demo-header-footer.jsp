<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Demo Header/Footer Động - Farmily</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
            <style>
                .demo-container {
                    max-width: 1200px;
                    margin: 40px auto;
                    padding: 20px;
                    background: #f8f9fa;
                    border-radius: 8px;
                }

                .demo-section {
                    background: white;
                    padding: 30px;
                    margin: 20px 0;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .demo-section h2 {
                    color: #2e7d32;
                    margin-bottom: 15px;
                }

                .info-box {
                    background: #e8f5e9;
                    border-left: 4px solid #4CAF50;
                    padding: 15px;
                    margin: 15px 0;
                }

                .code-box {
                    background: #2d2d2d;
                    color: #f8f8f2;
                    padding: 15px;
                    border-radius: 4px;
                    overflow-x: auto;
                    font-family: 'Courier New', monospace;
                }

                .status-badge {
                    display: inline-block;
                    padding: 5px 15px;
                    border-radius: 15px;
                    font-size: 14px;
                    font-weight: bold;
                }

                .status-logged-in {
                    background: #4CAF50;
                    color: white;
                }

                .status-guest {
                    background: #ff9800;
                    color: white;
                }
            </style>
        </head>

        <body>

            
                <jsp:include page="common/header.jsp" />

                <div class="demo-container">
                    <div class="demo-section">
                        <h1><i class="fas fa-star"></i> Demo Header & Footer Động</h1>
                        <p>Trang này demo cách sử dụng header và footer động dựa trên trạng thái đăng nhập.</p>
                    </div>

                    <div class="demo-section">
                        <h2><i class="fas fa-info-circle"></i> Trạng Thái Hiện Tại</h2>
                        <c:choose>
                            <c:when test="${not empty sessionScope.auth}">
                                <span class="status-badge status-logged-in">
                                    <i class="fas fa-check-circle"></i> ĐÃ ĐĂNG NHẬP
                                </span>
                                <div class="info-box">
                                    <strong>Thông tin người dùng:</strong><br>
                                    Tên: <strong>${sessionScope.auth.name}</strong><br>
                                    Email: ${sessionScope.auth.email}
                                </div>
                                <p>Header hiện tại đang hiển thị:</p>
                                <ul>
                                    <li>Dropdown menu với tên bạn</li>
                                    <li>Link đến Hồ sơ, Đơn hàng</li>
                                    <li>Nút Đăng xuất</li>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-guest">
                                    <i class="fas fa-user-slash"></i> CHƯA ĐĂNG NHẬP
                                </span>
                                <div class="info-box">
                                    Bạn chưa đăng nhập. Header hiện tại đang hiển thị nút "Đăng nhập".
                                </div>
                                <p>
                                    <a href="${pageContext.request.contextPath}/DangNhap.jsp" class="btn"
                                        style="display: inline-block; background: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">
                                        Đăng nhập ngay
                                    </a>
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="demo-section">
                        <h2><i class="fas fa-code"></i> Cách Sử Dụng</h2>

                        <h3>Bước 1: Thêm JSTL taglib</h3>
                        <div class="code-box">&lt;%@ taglib prefix="c" uri="jakarta.tags.core" %&gt;</div>

                        <h3>Bước 2: Include header và footer</h3>
                        <div class="code-box">
                            &lt;%-- Include Header --%&gt;
                            &lt;jsp:include page="common/header.jsp" /&gt;

                            &lt;!-- Nội dung trang của bạn --&gt;
                            &lt;main&gt;
                            &lt;h1&gt;Nội dung trang&lt;/h1&gt;
                            &lt;/main&gt;

                            &lt;%-- Include Footer --%&gt;
                            &lt;jsp:include page="common/footer.jsp" /&gt;
                        </div>

                        <h3>Bước 3: Đảm bảo CSS được load</h3>
                        <div class="code-box">&lt;link rel="stylesheet"
                            href="${pageContext.request.contextPath}/css/HeaderFooter.css"&gt;</div>
                    </div>

                    <div class="demo-section">
                        <h2><i class="fas fa-magic"></i> Tính Năng Tự Động</h2>
                        <ul style="line-height: 2;">
                            <li><i class="fas fa-check" style="color: #4CAF50;"></i> Header tự động kiểm tra
                                <code>sessionScope.auth</code>
                            </li>
                            <li><i class="fas fa-check" style="color: #4CAF50;"></i> Hiển thị dropdown menu khi đã đăng
                                nhập</li>
                            <li><i class="fas fa-check" style="color: #4CAF50;"></i> Hiển thị nút "Đăng nhập" khi chưa
                                đăng nhập</li>
                            <li><i class="fas fa-check" style="color: #4CAF50;"></i> Footer cũng thay đổi link tương ứng
                            </li>
                            <li><i class="fas fa-check" style="color: #4CAF50;"></i> Không cần code trùng lặp trong mỗi
                                trang</li>
                        </ul>
                    </div>

                    <div class="demo-section">
                        <h2><i class="fas fa-file-code"></i> Files Liên Quan</h2>
                        <ul>
                            <li><code>src/main/webapp/common/header.jsp</code> - Header component</li>
                            <li><code>src/main/webapp/common/footer.jsp</code> - Footer component</li>
                            <li><code>src/main/java/.../controller/LoginController.java</code> - Xử lý đăng nhập</li>
                            <li><code>src/main/java/.../controller/LogoutController.java</code> - Xử lý đăng xuất</li>
                        </ul>
                    </div>

                    <div class="demo-section">
                        <h2><i class="fas fa-link"></i> Liên Kết Nhanh</h2>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/"
                                style="padding: 10px 20px; background: #2196F3; color: white; text-decoration: none; border-radius: 4px;">
                                <i class="fas fa-home"></i> Trang chủ
                            </a>
                            <a href="${pageContext.request.contextPath}/DangNhap.jsp"
                                style="padding: 10px 20px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px;">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </a>
                            <c:if test="${not empty sessionScope.auth}">
                                <a href="${pageContext.request.contextPath}/logout"
                                    style="padding: 10px 20px; background: #f44336; color: white; text-decoration: none; border-radius: 4px;">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>

                
                    <jsp:include page="common/footer.jsp" />

        </body>

        </html>