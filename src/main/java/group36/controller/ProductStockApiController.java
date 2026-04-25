package group36.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.model.Product;
import group36.model.ProductVariant;
import group36.service.ProductService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductStockApiController", urlPatterns = {"/api/product/stock"})
public class ProductStockApiController extends HttpServlet {

    private ProductService productService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        try {
            String productIdStr = request.getParameter("productId");
            String variantIdStr = request.getParameter("variantId");

            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Thiếu productId");
                out.print(gson.toJson(result));
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            Product product = productService.getProductById(productId);

            if (product == null) {
                result.put("success", false);
                result.put("message", "Không tìm thấy sản phẩm");
                out.print(gson.toJson(result));
                return;
            }

            int stock = 0;
            if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                int variantId = Integer.parseInt(variantIdStr);
                if (product.getVariants() != null) {
                    for (ProductVariant variant : product.getVariants()) {
                        if (variant.getId() == variantId) {
                            stock = variant.getStock();
                            break;
                        }
                    }
                }
            } else {
                stock = product.getTotalStock();
            }

            result.put("success", true);
            result.put("stock", stock);
            out.print(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi server");
            out.print(gson.toJson(result));
        } finally {
            out.flush();
        }
    }
}
