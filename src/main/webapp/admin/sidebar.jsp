<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-logo">
                    <img src="https://i.postimg.cc/5N6zh927/logo-white.png" alt="Logo">



                </a>
            </div>

            <ul class="admin-menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" data-page="dashboard">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a></li>
                <li><a href="${pageContext.request.contextPath}/admin/notifications" data-page="notifications">
                        <i class="fas fa-bell"></i>
                        <span>Thông báo</span>
                    </a></li>

                <div class="menu-section-title">Quản lý bán hàng</div>

                <li><a href="${pageContext.request.contextPath}/admin/products" data-page="products">
                        <i class="fas fa-box"></i>
                        <span>Sản phẩm</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/flash-sales" data-page="flash-sales">
                        <i class="fas fa-bolt"></i>
                        <span>Flash Sale</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/categories" data-page="categories">
                        <i class="fas fa-list"></i>
                        <span>Danh mục</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/orders" data-page="orders">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Đơn hàng</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/reviews" data-page="reviews">
                        <i class="fas fa-star"></i>
                        <span>Đánh giá</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/users" data-page="customers">
                        <i class="fas fa-users"></i>
                        <span>Khách hàng</span>
                    </a></li>

                <div class="menu-section-title">Nội dung</div>

                <li><a href="${pageContext.request.contextPath}/admin/posts" data-page="posts">
                        <i class="fas fa-newspaper"></i>
                        <span>Bài viết</span>
                    </a></li>

                <li><a href="${pageContext.request.contextPath}/admin/static-pages" data-page="static-pages">
                        <i class="fas fa-file-alt"></i>
                        <span>Trang tĩnh</span>
                    </a></li>

                <div class="menu-section-title">Hệ thống</div>






                <li><a href="${pageContext.request.contextPath}/admin/logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Đăng xuất</span>
                    </a></li>
            </ul>
        </aside>