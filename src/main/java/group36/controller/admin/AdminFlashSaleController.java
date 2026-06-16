package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.FlashSale;
import group36.model.Product;
import group36.model.Category;
import group36.service.FlashSaleService;
import group36.service.ProductService;
import group36.service.CategoryService;
import group36.service.UserNotificationService;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;




@WebServlet(name = "AdminFlashSaleController", urlPatterns = { "/admin/flash-sales", "/admin/flash-sales/*" })
public class AdminFlashSaleController extends HttpServlet {
    private final FlashSaleService flashSaleService;
    private final ProductService productService;
    private final CategoryService categoryService;
    private final UserNotificationService userNotificationService;

    public AdminFlashSaleController() {
        this.flashSaleService = new FlashSaleService();
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
        this.userNotificationService = new UserNotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listFlashSales(request, response);
            } else if (pathInfo.equals("/add")) {
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listFlashSales(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            } else if (pathInfo.equals("/add")) {
                createFlashSale(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateFlashSale(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteFlashSale(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/flash-sales");
        }
    }

    private void listFlashSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<FlashSale> flashSales = flashSaleService.getAllFlashSales();
        request.setAttribute("flashSales", flashSales);

        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/flash-sales.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.getAllProducts();
        List<Category> categories = categoryService.getAllActiveCategories();
        
        List<FlashSale> activeFlashSales = flashSaleService.getActiveFlashSales();
        List<Integer> activeFlashSaleProductIds = activeFlashSales.stream()
                .map(FlashSale::getProductId)
                .toList();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("activeFlashSaleProductIds", activeFlashSaleProductIds);
        request.getRequestDispatcher("/admin/flash-sale-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/flash-sales");
            return;
        }

        int id = Integer.parseInt(idParam);
        FlashSale flashSale = flashSaleService.getFlashSaleById(id);
        List<Product> products = productService.getAllProducts();

        request.setAttribute("flashSale", flashSale);
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/flash-sale-edit.jsp").forward(request, response);
    }

    private void createFlashSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String[] productIdsStr = request.getParameterValues("productIds");
        double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
        int stockLimit = Integer.parseInt(request.getParameter("stockLimit"));
        int maxQtyPerUser = 0;
        String maxQtyPerUserStr = request.getParameter("maxQtyPerUser");
        if (maxQtyPerUserStr != null && !maxQtyPerUserStr.trim().isEmpty()) {
            maxQtyPerUser = Integer.parseInt(maxQtyPerUserStr.trim());
        }

        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        Timestamp startTime = parseTimestamp(startTimeStr);
        Timestamp endTime = parseTimestamp(endTimeStr);

        int count = 0;
        HttpSession session = request.getSession();

        if (productIdsStr != null && productIdsStr.length > 0) {
            for (String pidStr : productIdsStr) {
                if (pidStr == null || pidStr.trim().isEmpty()) continue;
                int productId = Integer.parseInt(pidStr.trim());
                FlashSale flashSale = new FlashSale(productId, discountPercent, stockLimit, startTime, endTime, maxQtyPerUser);
                flashSaleService.createFlashSale(flashSale);

                try {
                    Product product = productService.getProductById(productId);
                    String productName = (product != null) ? product.getName() : "Sản phẩm";
                    userNotificationService.createFlashSaleNotificationForAll(productName, discountPercent);
                } catch (Exception e) {
                    System.err.println("[FlashSale] Error broadcasting notification: " + e.getMessage());
                }
                count++;
            }
        } else {
            String singleProductIdStr = request.getParameter("productId");
            if (singleProductIdStr != null && !singleProductIdStr.trim().isEmpty()) {
                int productId = Integer.parseInt(singleProductIdStr.trim());
                FlashSale flashSale = new FlashSale(productId, discountPercent, stockLimit, startTime, endTime, maxQtyPerUser);
                flashSaleService.createFlashSale(flashSale);

                try {
                    Product product = productService.getProductById(productId);
                    String productName = (product != null) ? product.getName() : "Sản phẩm";
                    userNotificationService.createFlashSaleNotificationForAll(productName, discountPercent);
                } catch (Exception e) {
                    System.err.println("[FlashSale] Error broadcasting notification: " + e.getMessage());
                }
                count++;
            }
        }

        if (count > 0) {
            session.setAttribute("success", "Thêm thành công " + count + " Flash Sale!");
        } else {
            session.setAttribute("error", "Không có sản phẩm nào được chọn!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/flash-sales");
    }

    private void updateFlashSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
        int stockLimit = Integer.parseInt(request.getParameter("stockLimit"));
        int soldCount = Integer.parseInt(request.getParameter("soldCount"));
        int maxQtyPerUser = 0;
        String maxQtyPerUserStr = request.getParameter("maxQtyPerUser");
        if (maxQtyPerUserStr != null && !maxQtyPerUserStr.trim().isEmpty()) {
            maxQtyPerUser = Integer.parseInt(maxQtyPerUserStr.trim());
        }

        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        Timestamp startTime = parseTimestamp(startTimeStr);
        Timestamp endTime = parseTimestamp(endTimeStr);

        FlashSale flashSale = new FlashSale(productId, discountPercent, stockLimit, startTime, endTime, maxQtyPerUser);
        flashSale.setId(id);
        flashSale.setSoldCount(soldCount);

        flashSaleService.updateFlashSale(flashSale);

        HttpSession session = request.getSession();
        session.setAttribute("success", "Cập nhật Flash Sale thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/flash-sales");
    }

    private void deleteFlashSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        flashSaleService.deleteFlashSale(id);

        HttpSession session = request.getSession();
        session.setAttribute("success", "Xóa Flash Sale thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/flash-sales");
    }

    private Timestamp parseTimestamp(String datetimeStr) {
        if (datetimeStr == null || datetimeStr.isEmpty())
            return null;
        
        LocalDateTime ldt = LocalDateTime.parse(datetimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        return Timestamp.valueOf(ldt);
    }
}
