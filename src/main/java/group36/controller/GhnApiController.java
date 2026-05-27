package group36.controller;

import com.google.gson.Gson;
import group36.service.GhnService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "GhnApiController", urlPatterns = {"/api/ghn/*"})
public class GhnApiController extends HttpServlet {

    private GhnService ghnService;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        ghnService = new GhnService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String pathInfo = request.getPathInfo();

        if (pathInfo == null) {
            sendError(response, 404, "Endpoint không tồn tại");
            return;
        }

        try {
            switch (pathInfo) {
                case "/provinces":
                    String provinces = ghnService.getProvinces();
                    response.getWriter().write(provinces);
                    break;

                case "/districts":
                    String provinceIdStr = request.getParameter("provinceId");
                    if (provinceIdStr == null || provinceIdStr.isEmpty()) {
                        sendError(response, 400, "Thiếu tham số provinceId");
                        return;
                    }
                    int provinceId = Integer.parseInt(provinceIdStr);
                    String districts = ghnService.getDistricts(provinceId);
                    response.getWriter().write(districts);
                    break;

                case "/wards":
                    String districtIdStr = request.getParameter("districtId");
                    if (districtIdStr == null || districtIdStr.isEmpty()) {
                        sendError(response, 400, "Thiếu tham số districtId");
                        return;
                    }
                    int districtId = Integer.parseInt(districtIdStr);
                    String wards = ghnService.getWards(districtId);
                    response.getWriter().write(wards);
                    break;

                default:
                    sendError(response, 404, "Endpoint không tồn tại: " + pathInfo);
                    break;
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "Tham số không hợp lệ: " + e.getMessage());
        } catch (RuntimeException e) {
            System.err.println("[GhnApi] Error: " + e.getMessage());
            sendError(response, 503, "Không thể kết nối dịch vụ vận chuyển");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        String pathInfo = request.getPathInfo();

        if (!"/calculate-fee".equals(pathInfo)) {
            sendError(response, 404, "Endpoint không tồn tại: " + pathInfo);
            return;
        }

        try {
            String toDistrictIdStr = request.getParameter("toDistrictId");
            String toWardCode = request.getParameter("toWardCode");

            if (toDistrictIdStr == null || toDistrictIdStr.isEmpty()
                    || toWardCode == null || toWardCode.isEmpty()) {
                sendError(response, 400, "Thiếu tham số toDistrictId hoặc toWardCode");
                return;
            }

            int toDistrictId = Integer.parseInt(toDistrictIdStr);

            String insuranceValueStr = request.getParameter("insuranceValue");
            double insuranceValue = 0;
            if (insuranceValueStr != null && !insuranceValueStr.isEmpty()) {
                try {
                    insuranceValue = Double.parseDouble(insuranceValueStr);
                } catch (NumberFormatException ignored) {
                }
            }

            double fee = ghnService.calculateFee(toDistrictId, toWardCode, insuranceValue);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("shippingFee", fee);
            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            sendError(response, 400, "Tham số không hợp lệ: " + e.getMessage());
        } catch (RuntimeException e) {
            System.err.println("[GhnApi] Fee calculation error: " + e.getMessage());
            sendError(response, 503, "Không thể tính phí vận chuyển: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        out.write(gson.toJson(error));
    }
}
