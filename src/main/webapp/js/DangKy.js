document.querySelector("form").addEventListener("submit", function(e) {
    e.preventDefault();

    const ho = document.querySelectorAll('input[type="text"]')[0].value.trim();
    const ten = document.querySelectorAll('input[type="text"]')[1].value.trim();
    const sdt = document.querySelectorAll('input[type="text"]')[2].value.trim();
    const email = document.querySelector('input[type="email"]').value.trim();
    const password = document.querySelector('input[type="password"]').value.trim();

    if (!ho || !ten || !sdt || !email || !password) {
        alert("Vui lòng nhập đầy đủ thông tin!");
        return;
    }


    alert("Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.");
    window.location.href = "DangNhap.jsp";
});
