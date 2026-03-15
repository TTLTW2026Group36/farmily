<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Liên hệ — Farmily</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HeaderFooter.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/LienHe.css">
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
                Liên Hệ
              </li>
            </ol>
          </div>
        </nav>

        <div class="LienHe_container">
          <div class="grid">
            
            <aside class="card" aria-labelledby="thong-tin-lien-he">
              <h2>CÁC PHÒNG BAN PHỤ TRÁCH</h2>

              <div class="contact-block">
                <h3>Phòng Kinh doanh, Mua bán, Kế toán</h3>
                <ul>
                  <li>Email: <a href="mailto:Farmily@gmail.com">Farmily@gmail.com</a></li>
                  <li>Điện thoại: <a href="tel:0332991664">0332991664</a></li>
                  <li>Địa chỉ: Phường Hoàn Kiếm, Quận Hoàn Kiếm, Thành phố Hà Nội</li>
                </ul>
              </div>

              <div class="contact-block">
                <h3>Phòng Hành chính – Nhân sự</h3>
                <ul>
                  <li>Email: <a href="mailto:hcns@nongsanfarmily.site">hcns@nongsanfarmily.site</a></li>
                  <li>Điện thoại: <a href="tel:0378827924">0378827924</a></li>
                  <li>Địa chỉ: Trường Đại Học Nông Lâm Thành Phố Hồ Chí Minh</li>
                </ul>
              </div>

              <div class="contact-block">
                <h3>Phòng Xử lý Thông tin chung</h3>
                <ul>
                  <li>Email: <a href="mailto:info@nongsanfarmily.site">info@nongsanfarmily.site</a></li>
                  <li>Điện thoại: <a href="tel:0332991664">0332991664</a></li>
                  <li>Địa chỉ: Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh</li>
                </ul>
              </div>

              <div class="contact-hotline">
                <h3>HOTLINE TOÀN QUỐC</h3>
                <ul>
                  <li><strong>Hồ Chí Minh:</strong> <a href="tel:0332991664">0332991664</a></li>
                  <li><strong>Hà Nội:</strong> <a href="tel:0378827924">0378827924</a></li>
                </ul>
              </div>
            </aside>

            
            <section class="card" aria-labelledby="gui-lien-he">
              <h2 id="gui-lien-he">Gửi liên hệ</h2>

              <div id="notice" class="ok"></div>
              <div id="error-notice" class="error-notice"></div>

              <form id="contactForm" class="form" action="${pageContext.request.contextPath}/lien-he" method="post"
                novalidate>
                
                <div class="row">
                  <div>
                    <label for="name">Họ và tên *</label>
                    <input id="name" name="name" autocomplete="name" required
                      placeholder="Nhập họ và tên đầy đủ của bạn" />
                    <div class="err" id="err-name">Vui lòng nhập họ và tên.</div>
                  </div>
                </div>

                
                <div class="row">
                  <div>
                    <label for="email">Email *</label>
                    <input id="email" name="email" type="email" autocomplete="email" required
                      placeholder="example@email.com" />
                    <div class="err" id="err-email">Email chưa đúng định dạng.</div>
                  </div>
                </div>

                
                <div class="row">
                  <div>
                    <label for="phone">Số điện thoại *</label>
                    <input id="phone" name="phone" type="tel" inputmode="numeric" required placeholder="0912 345 678" />
                    <div class="err" id="err-phone">Vui lòng nhập số điện thoại hợp lệ.</div>
                  </div>
                </div>

                
                <div class="row">
                  <div>
                    <label for="org">Đơn vị</label>
                    <input id="org" name="org" placeholder="Tên công ty hoặc tổ chức (không bắt buộc)" />
                  </div>
                </div>

                
                <div class="row">
                  <div>
                    <label for="subject">Tiêu đề *</label>
                    <input id="subject" name="subject" required placeholder="Tiêu đề nội dung liên hệ" />
                    <div class="err" id="err-subject">Vui lòng nhập tiêu đề.</div>
                  </div>
                </div>

                
                <div class="row">
                  <div>
                    <label for="message">Nội dung *</label>
                    <textarea id="message" name="message" required
                      placeholder="Nhập nội dung chi tiết bạn muốn gửi đến chúng tôi..."></textarea>
                    <div class="err" id="err-message">Vui lòng nhập nội dung.</div>
                  </div>
                </div>

                <div class="actions">
                  <button type="submit" class="btn-submit" aria-label="Gửi">
                    <span class="btn-text">Gửi</span>
                    <span class="btn-loading" style="display: none;">
                      <i class="fas fa-spinner fa-spin"></i> Đang gửi...
                    </span>
                  </button>
                </div>
              </form>
            </section>
          </div>
        </div>

        
        
          <jsp:include page="common/footer.jsp" />

          <script src="${pageContext.request.contextPath}/js/LienHe.js"></script>
    </body>

    </html>