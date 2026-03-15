package group36.controller;

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





@WebServlet(name = "AddressApiController", urlPatterns = { "/api/address", "/api/address/*" })
public class AddressApiController extends HttpServlet {

    private AddressService addressService;

    @Override
    public void init() throws ServletException {
        addressService = new AddressService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();

            if (pathInfo == null || pathInfo.equals("/")) {
                
                List<Address> addresses = addressService.getAddressesByUserId(user.getId());
                out.print(toJsonArray(addresses));
            } else {
                
                int addressId = Integer.parseInt(pathInfo.substring(1));
                Optional<Address> addressOpt = addressService.getAddressById(addressId);

                if (addressOpt.isPresent() && addressOpt.get().getUserId() == user.getId()) {
                    out.print(toJson(addressOpt.get()));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"success\":false,\"message\":\"Địa chỉ không tồn tại\"}");
                }
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            
            String receiver = request.getParameter("receiver");
            String phone = request.getParameter("phone");
            String addressDetail = request.getParameter("addressDetail");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            boolean isDefault = "true".equals(request.getParameter("isDefault"));

            if (isEmpty(receiver) || isEmpty(addressDetail)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Vui lòng điền đầy đủ thông tin\"}");
                return;
            }

            Address address = new Address();
            address.setUserId(user.getId());
            address.setReceiver(receiver);
            address.setPhone(phone);
            address.setAddressDetail(addressDetail);
            address.setDistrict(district);
            address.setCity(city);
            address.setDefault(isDefault);

            Address created = addressService.createAddress(address);
            out.print("{\"success\":true,\"address\":" + toJson(created) + "}");

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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu ID địa chỉ\"}");
                return;
            }

            int addressId = Integer.parseInt(pathInfo.substring(1));
            Optional<Address> existingOpt = addressService.getAddressById(addressId);

            if (existingOpt.isEmpty() || existingOpt.get().getUserId() != user.getId()) {
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

            if (isEmpty(receiver) || isEmpty(addressDetail)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Vui lòng điền đầy đủ thông tin\"}");
                return;
            }

            Address address = existingOpt.get();
            address.setReceiver(receiver);
            address.setPhone(phone);
            address.setAddressDetail(addressDetail);
            address.setDistrict(district);
            address.setCity(city);
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu ID địa chỉ\"}");
                return;
            }

            int addressId = Integer.parseInt(pathInfo.substring(1));
            boolean deleted = addressService.deleteAddress(user.getId(), addressId);

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

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private String toJson(Address address) {
        return String.format(
                "{\"id\":%d,\"userId\":%d,\"receiver\":\"%s\",\"phone\":\"%s\",\"addressDetail\":\"%s\"," +
                        "\"district\":\"%s\",\"city\":\"%s\",\"isDefault\":%b,\"fullAddress\":\"%s\"}",
                address.getId(),
                address.getUserId(),
                escapeJson(address.getReceiver()),
                escapeJson(address.getPhone()),
                escapeJson(address.getAddressDetail()),
                escapeJson(address.getDistrict()),
                escapeJson(address.getCity()),
                address.isDefault(),
                escapeJson(address.getFullAddress()));
    }

    private String toJsonArray(List<Address> addresses) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < addresses.size(); i++) {
            if (i > 0)
                sb.append(",");
            sb.append(toJson(addresses.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
