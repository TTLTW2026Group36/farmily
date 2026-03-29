<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <header>
            <div class="topbar" role="banner">
                <div class="wrap">
                    <a class="logo" href="${pageContext.request.contextPath}/" title="Trang chủ">
                        <span class="img">
                            <img src="https://i.postimg.cc/5N6zh927/logo-white.png" alt="Logo cửa hàng"
                                onerror="this.style.display='none'">
                        </span>
                    </a>

                    <div class="search-wrap" role="search" aria-label="Tìm kiếm">
                        <form class="search-box" action="${pageContext.request.contextPath}/san-pham" method="GET"
                            autocomplete="off">
                            <input type="search" id="header-search-input" name="keyword"
                                placeholder="Tìm kiếm sản phẩm..." aria-label="Tìm kiếm sản phẩm">
                            <button type="submit" class="btn search-btn" aria-label="Tìm">
                                <i class="fa-solid fa-magnifying-glass"></i>
                            </button>

                            <div class="search-suggestions" id="search-suggestions"></div>
                        </form>
                    </div>

                    <div class="actions" role="navigation" aria-label="Hành động">
                        <div class="support" aria-hidden="false">
                            <i class="fa-solid fa-phone"></i>
                            <div class="support-text">
                                <span>Hỗ trợ khách hàng</span>
                                <strong>0378827924</strong>
                            </div>
                        </div>


                        <c:choose>

                            <c:when test="${not empty sessionScope.auth}">
                                <div class="user-menu">
                                    <a class="icon-btn-login" href="#" title="Tài khoản">
                                        <i class="fa-solid fa-user"></i>
                                        <span><strong>${sessionScope.auth.name}</strong></span>
                                    </a>
                                    <ul class="user-dropdown">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/ho-so">
                                                <i class="fa-solid fa-user-pen"></i> Hồ sơ của tôi
                                            </a>
                                        </li>
                                        <li>
                                            <a href="${pageContext.request.contextPath}/ho-so/don-hang">
                                                <i class="fa-solid fa-box"></i> Đơn hàng
                                            </a>
                                        </li>
                                        <li>
                                            <a href="${pageContext.request.contextPath}/logout">
                                                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                                            </a>
                                        </li>
                                    </ul>
                                </div>


                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const userMenu = document.querySelector('.user-menu');
                                        if (userMenu) {
                                            const userBtn = userMenu.querySelector('.icon-btn-login');
                                            const dropdown = userMenu.querySelector('.user-dropdown');

                                            userBtn.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                dropdown.classList.toggle('show');
                                            });

                                            userMenu.addEventListener('mouseenter', function () {
                                                dropdown.classList.add('show');
                                            });

                                            userMenu.addEventListener('mouseleave', function () {
                                                dropdown.classList.remove('show');
                                            });

                                            document.addEventListener('click', function (e) {
                                                if (!userMenu.contains(e.target)) {
                                                    dropdown.classList.remove('show');
                                                }
                                            });
                                        }
                                    });
                                </script>
                            </c:when>


                            <c:otherwise>
                                <a class="icon-btn-login" href="${pageContext.request.contextPath}/dang-nhap"
                                    title="Tài khoản">
                                    <i class="fa-solid fa-user"></i> Đăng nhập
                                </a>
                            </c:otherwise>
                        </c:choose>



                        <a class="icon-btn-wishlist" href="${pageContext.request.contextPath}/ho-so?tab=wishlist"
                            title="Yêu thích">
                            <i class="fa-solid fa-heart"></i>
                            <span
                                class="wishlist-badge ${empty sessionScope.wishlistCount || sessionScope.wishlistCount == 0 ? 'badge-hidden' : ''}"
                                id="wishlistCount">
                                <c:out value="${sessionScope.wishlistCount}" default="0" />
                            </span>
                        </a>

                        <a class="icon-btn-shopping-cart" href="${pageContext.request.contextPath}/gio-hang"
                            title="Giỏ hàng">
                            <i class="fa-solid fa-shopping-cart"></i> <span class="cart-text">Giỏ hàng</span>
                            <span
                                class="cart-badge ${empty sessionScope.cartCount || sessionScope.cartCount == 0 ? 'badge-hidden' : ''}"
                                id="cartCount">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.cartCount}">
                                        ${sessionScope.cartCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </span>
                        </a>
                    </div>
                </div>
            </div>


            <div class="mini-nav" role="navigation" aria-label="Menu chính">
                <div class="wrap">
                    <div class="cats-toggle">
                        <i class="fa-solid fa-bars"></i>
                        <span>Danh sách sản phẩm</span>
                        <ul class="dropdown" id="category-dropdown-header">
                        </ul>
                    </div>

                    <div class="nav-links" aria-hidden="false">
                        <a href="${pageContext.request.contextPath}/">Trang Chủ</a>
                        <a href="${pageContext.request.contextPath}/GioiThieu.jsp">Giới Thiệu</a>
                        <a href="${pageContext.request.contextPath}/san-pham">Sản Phẩm</a>
                        <a href="${pageContext.request.contextPath}/gia-tot">Giá Tốt</a>
                        <a href="${pageContext.request.contextPath}/tin-tuc">Tin Tức</a>
                        <a href="${pageContext.request.contextPath}/lien-he">Liên Hệ</a>
                    </div>
                </div>
            </div>
        </header>


        <script>
            (function () {
                var searchInput = document.getElementById('header-search-input');
                var suggestionsContainer = document.getElementById('search-suggestions');
                var debounceTimer;
                var contextPath = '<%= request.getContextPath() %>';

                if (!searchInput || !suggestionsContainer) return;

                function debounce(func, wait) {
                    return function () {
                        var args = arguments;
                        var context = this;
                        clearTimeout(debounceTimer);
                        debounceTimer = setTimeout(function () { func.apply(context, args); }, wait);
                    };
                }

                function formatPrice(price) {
                    return new Intl.NumberFormat('vi-VN').format(price) + '₫';
                }

                function fetchSuggestions(keyword) {
                    if (!keyword || keyword.trim().length < 2) {
                        hideSuggestions();
                        return;
                    }

                    suggestionsContainer.innerHTML = '<div class="search-loading"><i class="fa-solid fa-spinner fa-spin"></i> Đang tìm...</div>';
                    suggestionsContainer.classList.add('show');

                    fetch(contextPath + '/api/search?q=' + encodeURIComponent(keyword))
                        .then(function (response) { return response.json(); })
                        .then(function (data) {
                            if (data.length === 0) {
                                suggestionsContainer.innerHTML = '<div class="search-no-results">Không tìm thấy sản phẩm</div>';
                                return;
                            }

                            var html = '';
                            data.forEach(function (product) {
                                html += '<a href="' + contextPath + '/chi-tiet-san-pham?id=' + product.id + '" class="search-suggestion-item">';
                                html += '<img src="' + product.image + '" alt="' + product.name + '" onerror="this.src=\'https://via.placeholder.com/50\'">';
                                html += '<div class="info">';
                                html += '<div class="name">' + product.name + '</div>';
                                html += '<div class="price">' + formatPrice(product.price) + '/' + product.unit + '</div>';
                                html += '</div>';
                                html += '</a>';
                            });

                            html += '<a href="' + contextPath + '/san-pham?keyword=' + encodeURIComponent(keyword) + '" class="search-view-all">';
                            html += '<i class="fa-solid fa-search"></i> Xem tất cả kết quả cho "' + keyword + '"';
                            html += '</a>';

                            suggestionsContainer.innerHTML = html;
                        })
                        .catch(function (error) {
                            console.error('Search error:', error);
                            suggestionsContainer.innerHTML = '<div class="search-no-results">Có lỗi xảy ra</div>';
                        });
                }

                function hideSuggestions() {
                    suggestionsContainer.classList.remove('show');
                    suggestionsContainer.innerHTML = '';
                }

                searchInput.addEventListener('input', debounce(function (e) {
                    fetchSuggestions(e.target.value);
                }, 300));

                searchInput.addEventListener('focus', function () {
                    if (this.value.trim().length >= 2) {
                        fetchSuggestions(this.value);
                    }
                });

                document.addEventListener('click', function (e) {
                    if (!searchInput.contains(e.target) && !suggestionsContainer.contains(e.target)) {
                        hideSuggestions();
                    }
                });

                suggestionsContainer.addEventListener('click', function (e) {
                    if (e.target.closest('.search-suggestion-item')) {
                        e.stopPropagation();
                    }
                });

                function loadHeaderCategories() {
                    var dropdown = document.getElementById('category-dropdown-header');
                    if (!dropdown) return;

                    fetch(contextPath + '/api/categories')
                        .then(function (res) { return res.json(); })
                        .then(function (categories) {
                            if (!categories || categories.length === 0) {
                                dropdown.innerHTML = '<li><a href="javascript:void(0)">Chưa có danh mục</a></li>';
                                return;
                            }
                            var html = '';
                            categories.forEach(function (cat) {
                                html += '<li><a href="' + contextPath + '/san-pham?categoryId=' + cat.id + '">' + cat.name + '</a></li>';
                            });
                            dropdown.innerHTML = html;
                        })
                        .catch(function (err) {
                            console.error('Lỗi khi tải danh mục header:', err);
                            dropdown.innerHTML = '<li><a href="javascript:void(0)">Lỗi tải danh mục</a></li>';
                        });
                }
                loadHeaderCategories();
            })();
        </script>
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
            window.isLoggedIn = ${not empty sessionScope.auth ? 'true' : 'false' };
        </script>
        <script src="${pageContext.request.contextPath}/js/cart.js"></script>