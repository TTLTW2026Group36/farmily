document.querySelector("form").addEventListener("submit", function (e) {
    e.preventDefault();

    const email = document.querySelector('input[type="email"]').value.trim();

    if(email === "") {
        alert("Vui lòng nhập email!");
        return;
    }

    const users = JSON.parse(localStorage.getItem("users")) || [];
    const foundUser = users.find(u => u.email === email);

    if (foundUser) {
        alert(`Một email đặt lại mật khẩu đã được gửi đến: ${email}`);
    } else {
        alert("Không tìm thấy tài khoản với email này!");
    }
})