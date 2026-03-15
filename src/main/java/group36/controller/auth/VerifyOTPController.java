package group36.controller.auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.service.PasswordResetService;

import java.io.IOException;





@WebServlet(name = "VerifyOTPController", value = { "/verify-otp", "/xac-nhan-otp" })
public class VerifyOTPController extends HttpServlet {
    private final PasswordResetService passwordResetService = new PasswordResetService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.setAttribute("email", email);
        request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        
        String otp = request.getParameter("otp");
        if (otp == null || otp.isEmpty()) {
            
            StringBuilder otpBuilder = new StringBuilder();
            for (int i = 1; i <= 6; i++) {
                String digit = request.getParameter("otp" + i);
                if (digit != null && !digit.isEmpty()) {
                    otpBuilder.append(digit);
                }
            }
            otp = otpBuilder.toString();
        }

        if (otp == null || otp.trim().length() != 6) {
            request.setAttribute("error", "Vui lòng nhập đủ 6 chữ số mã OTP");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);
            return;
        }

        try {
            
            passwordResetService.verifyOTP(email, otp.trim());

            
            session.setAttribute("verifiedOtp", otp.trim());
            session.setAttribute("otpVerified", true);

            
            request.getRequestDispatcher("/DatLaiMatKhau.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/XacNhanOTP.jsp").forward(request, response);
        }
    }
}
