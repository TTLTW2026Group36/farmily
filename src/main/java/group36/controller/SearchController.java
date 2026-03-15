package group36.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.model.Product;
import group36.model.ProductImage;
import group36.model.ProductVariant;
import group36.service.ProductService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;





@WebServlet(name = "SearchController", urlPatterns = { "/api/search" })
public class SearchController extends HttpServlet {

    private ProductService productService;
    private Gson gson;

    private static final int MAX_SUGGESTIONS = 8;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        gson = new GsonBuilder().create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        String keyword = request.getParameter("q");

        if (keyword == null || keyword.trim().isEmpty()) {
            out.print(gson.toJson(new ArrayList<>()));
            return;
        }

        try {
            
            List<Product> products = productService.searchProducts(keyword.trim());

            
            if (products.size() > MAX_SUGGESTIONS) {
                products = products.subList(0, MAX_SUGGESTIONS);
            }

            
            List<Map<String, Object>> suggestions = new ArrayList<>();

            for (Product product : products) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", product.getId());
                item.put("name", product.getName());

                
                String imageUrl = "https://via.placeholder.com/50";
                if (product.getImages() != null && !product.getImages().isEmpty()) {
                    imageUrl = product.getImages().get(0).getImageUrl();
                }
                item.put("image", imageUrl);

                
                double minPrice = 0;
                String unit = "";
                if (product.getVariants() != null && !product.getVariants().isEmpty()) {
                    ProductVariant firstVariant = product.getVariants().get(0);
                    minPrice = firstVariant.getPrice();
                    unit = firstVariant.getOptionsValue();

                    
                    for (ProductVariant variant : product.getVariants()) {
                        if (variant.getPrice() < minPrice) {
                            minPrice = variant.getPrice();
                            unit = variant.getOptionsValue();
                        }
                    }
                }
                item.put("price", minPrice);
                item.put("unit", unit);

                suggestions.add(item);
            }

            out.print(gson.toJson(suggestions));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Search failed: " + e.getMessage());
            out.print(gson.toJson(error));
        }
    }
}
