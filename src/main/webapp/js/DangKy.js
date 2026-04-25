var diemMatKhau = 0;
document.querySelector("form").addEventListener("submit", function (e) {
    e.preventDefault();

    const tenInput = document.querySelector('input[name="name"]');
    const sdtInput = document.querySelector('input[name="phone"]');
    const emailInput = document.querySelector('input[name="email"]');
    const pwdInput = document.querySelector('input[name="password"]');

    const ho = tenInput ? tenInput.value.trim() : "";
    const ten = ho; 
    const sdt = sdtInput ? sdtInput.value.trim() : "";
    const email = emailInput ? emailInput.value.trim() : "";
    const password = pwdInput ? pwdInput.value.trim() : "";

    if (!ho || !ten || !sdt || !email || !password) {
        alert("Vui lòng nhập đầy đủ thông tin!");
        return;
    }

    if (diemMatKhau < 3) {
        alert("Mật khẩu quá yếu! Vui lòng nhập mật khẩu từ mức trung bình trở lên");
        if(pwdInput) pwdInput.focus();
        return;
    }

    alert("Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.");
    window.location.href = "DangNhap.jsp";
});

document.addEventListener("DOMContentLoaded", function () {
    var password = document.getElementById("password"); // Đúng biến password
    var strengthContainer = document.getElementById("strength-container");
    var strengthBar = document.getElementById("strength-bar")
    var strengthText = document.getElementById("strength-text");


    var ruleUpper = document.getElementById("rule-upper");
    var ruleLower = document.getElementById("rule-lower");
    var ruleDigit = document.getElementById("rule-number");
    var ruleSpecial = document.getElementById("rule-special");
    var ruleLength = document.getElementById("rule-length");

    if (password) {
        password.addEventListener("input", function () {
            var value = password.value;

            if (value.length > 0) {
                strengthContainer.style.display = "block";
            } else {
                strengthContainer.style.display = "none"
            }
            var score = 0;
            var hasUpper = false;
            for (var i = 0; i < value.length; i++) {
                if (value.charAt(i) >= 'A' && value.charAt(i) <= 'Z')
                    hasUpper = true;
            }
            if (hasUpper) {
                score++;
                ruleUpper.style.color = "green";
                ruleUpper.innerHTML = "Có chữ viết hoa";
            } else {
                ruleUpper.style.color = "red";
                ruleUpper.innerHTML = "Không có chữ viết hoa";
            }
            
            var hasLower = false;
            for (var j = 0; j < value.length; j++) {
                if (value.charAt(j) >= 'a' && value.charAt(j) <= 'z')
                    hasLower = true;
            }
            if (hasLower) {
                score++;
                ruleLower.style.color = "green";
                ruleLower.innerHTML = "Có chữ viết thường";
            } else {
                ruleLower.style.color = "red";
                ruleLower.innerHTML = "Không có chữ viết thường";
            }

            var hasDigit = false;
            for (var k = 0; k < value.length; k++) {
                if (value.charAt(k) >= '0' && value.charAt(k) <= '9')
                    hasDigit = true;
            }
            if (hasDigit) {
                score++;
                ruleDigit.style.color = "green";
                ruleDigit.innerHTML = "Có chữ số";
            } else {
                ruleDigit.style.color = "red";
                ruleDigit.innerHTML = "Không có chữ số";
            }

            var hasSpecial = /[^A-Za-z0-9]/;
            if (hasSpecial.test(value)) {
                score++;
                ruleSpecial.style.color = "green";
                ruleSpecial.innerHTML = "Có ký tự đặc biệt";
            } else {
                ruleSpecial.style.color = "red";
                ruleSpecial.innerHTML = "Không có ký tự đặc biệt";
            }

            if(value.length >= 8) {
                score++;
                ruleLength.style.color = "green";
                ruleLength.innerHTML = "Có ít nhất 8 ký tự";
            } else {
                ruleLength.style.color = "red";
                ruleLength.innerHTML= "Không đủ 8 ký tự";
            }

            if (score <= 2) {
                strengthBar.style.width = "33%";
                strengthBar.style.backgroundColor = "red";
                strengthText.innerHTML = "Độ mạnh: Yếu";
                strengthText.style.color = "red";
            } else if (score == 3 || score == 4) {
                strengthBar.style.width = "66%";
                strengthBar.style.backgroundColor = "orange";
                strengthText.innerHTML = "Độ mạnh: Trung bình";
                strengthText.style.color = "orange";
            } else if (score == 5) {
                strengthBar.style.width = "100%";
                strengthBar.style.backgroundColor = "green";
                strengthText.innerHTML = "Độ mạnh: Mạnh";
                strengthText.style.color = "green";
            }
            diemMatKhau = score;
        });
    }
});
