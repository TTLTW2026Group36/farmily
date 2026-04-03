package group36.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Address;
import group36.model.User;
import group36.service.AddressService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "AdminAddressApiController", urlPatterns = { "/admin/api/address", "/admin/api/address/*" })
public class AdminAddressApiController extends HttpServlet {

    private AddressService addressService;

    @Override
    public void init() throws ServletException {
        addressService = new AddressService();
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("adminUser");
        if (admin == null) {
            admin = (User) session.getAttribute("auth");
        }
        if (admin == null || !"admin".equals(admin.getRole().toLowerCase())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"success\":false,\"message\":\"Không có quyền truy cập\"}");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (!isAdmin(request, response, out))
            return;

        try {
            String userIdParam = request.getParameter("userId");
            if (isEmpty(userIdParam)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu userId\"}");
                return;
            }
            int userId = Integer.parseInt(userIdParam);
            List<Address> addresses = addressService.getAddressesByUserId(userId);
            out.print(toJsonArray(addresses));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"userId không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (!isAdmin(request, response, out))
            return;

        String pathInfo = request.getPathInfo();

        // Route: POST /admin/api/address/set-default
        if ("/set-default".equals(pathInfo)) {
            handleSetDefault(request, response, out);
            return;
        }

        try {
            String userIdParam = request.getParameter("userId");
            if (isEmpty(userIdParam)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu userId\"}");
                return;
            }
            int userId = Integer.parseInt(userIdParam);

            String receiver = request.getParameter("receiver");
            String phone = request.getParameter("phone");
            String addressDetail = request.getParameter("addressDetail");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            boolean isDefault = "true".equals(request.getParameter("isDefault"));

            String validationError = validate(receiver, phone, addressDetail, city);
            if (validationError != null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"" + escapeJson(validationError) + "\"}");
                return;
            }

            Address address = new Address();
            address.setUserId(userId);
            address.setReceiver(receiver.trim());
            address.setPhone(phone.trim());
            address.setAddressDetail(addressDetail.trim());
            address.setDistrict(district != null ? district.trim() : "");
            address.setCity(city.trim());
            address.setDefault(isDefault);

            Address created = addressService.createAddress(address);
            out.print("{\"success\":true,\"address\":" + toJson(created) + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"userId không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (!isAdmin(request, response, out))
            return;

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu ID địa chỉ\"}");
                return;
            }
            int addressId = Integer.parseInt(pathInfo.substring(1));

            String userIdParam = request.getParameter("userId");
            if (isEmpty(userIdParam)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu userId\"}");
                return;
            }
            int userId = Integer.parseInt(userIdParam);

            Optional<Address> existingOpt = addressService.getAddressById(addressId);
            if (existingOpt.isEmpty() || existingOpt.get().getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Địa chỉ không tồn tại\"}");
                return;
            }

            String receiver = request.getParameter("receiver");
            String phone = request.getParameter("phone");
            String addressDetail = request.getParameter("addressDetail");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            boolean isDefault = "true".equals(request.getParameter("isDefault"));

            String validationError = validate(receiver, phone, addressDetail, city);
            if (validationError != null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"" + escapeJson(validationError) + "\"}");
                return;
            }

            Address address = existingOpt.get();
            address.setReceiver(receiver.trim());
            address.setPhone(phone.trim());
            address.setAddressDetail(addressDetail.trim());
            address.setDistrict(district != null ? district.trim() : "");
            address.setCity(city.trim());
            address.setDefault(isDefault);

            boolean updated = addressService.updateAddress(address);
            if (updated) {
                out.print("{\"success\":true,\"address\":" + toJson(address) + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Không thể cập nhật địa chỉ\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        if (!isAdmin(request, response, out))
            return;

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu ID địa chỉ\"}");
                return;
            }
            int addressId = Integer.parseInt(pathInfo.substring(1));

            String userIdParam = request.getParameter("userId");
            if (isEmpty(userIdParam)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu userId\"}");
                return;
            }
            int userId = Integer.parseInt(userIdParam);

            boolean deleted = addressService.deleteAddress(userId, addressId);
            if (deleted) {
                out.print("{\"success\":true}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Không thể xóa địa chỉ\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    private void handleSetDefault(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
            throws IOException {
        try {
            String userIdParam = request.getParameter("userId");
            String addressIdParam = request.getParameter("addressId");
            if (isEmpty(userIdParam) || isEmpty(addressIdParam)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu userId hoặc addressId\"}");
                return;
            }
            int userId = Integer.parseInt(userIdParam);
            int addressId = Integer.parseInt(addressIdParam);
            boolean result = addressService.setDefaultAddress(userId, addressId);
            out.print("{\"success\":" + result + "}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
        }
    }

    private String validate(String receiver, String phone, String addressDetail, String city) {
        if (isEmpty(receiver))
            return "Vui lòng nhập họ tên người nhận";
        if (isEmpty(phone))
            return "Vui lòng nhập số điện thoại";
        if (!phone.trim().matches("^0[3-9][0-9]{8}$"))
            return "Số điện thoại không hợp lệ (VD: 0912345678)";
        if (isEmpty(addressDetail))
            return "Vui lòng nhập địa chỉ cụ thể";
        if (isEmpty(city))
            return "Vui lòng nhập tỉnh/thành phố";
        return null;
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private String toJson(Address a) {
        return String.format(
                "{\"id\":%d,\"userId\":%d,\"receiver\":\"%s\",\"phone\":\"%s\"," +
                        "\"addressDetail\":\"%s\",\"district\":\"%s\",\"city\":\"%s\"," +
                        "\"isDefault\":%b,\"fullAddress\":\"%s\"}",
                a.getId(), a.getUserId(),
                escapeJson(a.getReceiver()),
                escapeJson(a.getPhone()),
                escapeJson(a.getAddressDetail()),
                escapeJson(a.getDistrict()),
                escapeJson(a.getCity()),
                a.isDefault(),
                escapeJson(a.getFullAddress()));
    }

    private String toJsonArray(List<Address> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0)
                sb.append(",");
            sb.append(toJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}
