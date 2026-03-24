<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>
                <c:out value="${not empty pageTitle ? pageTitle : 'Chính sách nhận và hoàn trả hàng hóa'}" />
            </title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ChinhSachNhanVaHoanTra.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
        </head>

        <body>
            
            <jsp:include page="common/header.jsp" />

            
            <nav class="site-breadcrumb" aria-label="Breadcrumb">
                <div class="breadcrumb-container">
                    <ol class="breadcrumb-list">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="fas fa-home"></i>
                                Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            Chính sách nhận và hoàn trả hàng hóa
                        </li>
                    </ol>
                </div>
            </nav>

            <section class="page section">
                <div class="ChinhSachNhanVaHoanTra_container">
                    <div class="wrap_background_aside margin-bottom-40">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12">
                                <div class="heading-bar">
                                    <h1 class="title_page"><a href="#">Chính sách nhận và hoàn trả hàng hóa</a></h1>
                                </div>

                                <div class="content-page rte py-3">
                                    ${pageContent}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            
            <jsp:include page="common/footer.jsp" />
        </body>

        </html>