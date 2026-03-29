package group36.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import group36.model.Category;
import group36.model.Product;
import group36.model.ProductVariant;
import group36.service.CategoryService;
import group36.service.ProductService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;





@WebServlet(name = "AdminProductController", urlPatterns = { "/admin/products", "/admin/products/*" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
        maxFileSize = 1024 * 1024 * 10, 
        maxRequestSize = 1024 * 1024 * 50 
)
public class AdminProductController extends HttpServlet {
    private final ProductService productService;
    private final CategoryService categoryService;

    private static final int PAGE_SIZE = 10;

    public AdminProductController() {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                
                listProducts(request, response);
            } else if (pathInfo.equals("/add")) {
                
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                
                showEditForm(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            listProducts(request, response);
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
                createProduct(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateProduct(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteProduct(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    


    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String categoryParam = request.getParameter("category");
        int categoryId = 0;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }

        String status = request.getParameter("status");
        String sort = request.getParameter("sort");
        String search = request.getParameter("search");
        if (search != null) search = search.trim();

        List<Product> products = productService.getProductsFiltered(categoryId, status, search, sort, page, PAGE_SIZE);
        int totalProducts = productService.getTotalProductsFiltered(categoryId, status, search);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        List<Category> categories = categoryService.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedStatus", status != null ? status : "");
        request.setAttribute("selectedSort", sort != null ? sort : "");
        request.setAttribute("searchKeyword", search != null ? search : "");
        request.setAttribute("pageSize", PAGE_SIZE);

        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    


    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
    }

    


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productService.getProductById(id);
            List<Category> categories = categoryService.getAllCategories();

            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sản phẩm không hợp lệ");
            listProducts(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listProducts(request, response);
        }
    }

    


    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("productName");
        String categoryIdParam = request.getParameter("category");
        String[] variantNames = request.getParameterValues("variantName");
        String[] variantPrices = request.getParameterValues("variantPrice");
        String[] variantStocks = request.getParameterValues("variantStock");
        String[] imageUrls = request.getParameterValues("imageUrl");

        try {
            int categoryId = Integer.parseInt(categoryIdParam);

            if (variantNames == null || variantNames.length == 0) {
                throw new IllegalArgumentException("Cần ít nhất 1 biến thể sản phẩm");
            }

            Product product = new Product(categoryId, name);

            List<ProductVariant> variants = new ArrayList<>();
            for (int i = 0; i < variantNames.length; i++) {
                String vName = variantNames[i];
                if (vName == null || vName.trim().isEmpty()) continue;

                ProductVariant variant = new ProductVariant();
                variant.setOptionsValue(vName.trim());
                variant.setPrice(Double.parseDouble(variantPrices[i]));
                variant.setStock(Integer.parseInt(variantStocks[i]));
                variants.add(variant);
            }

            if (variants.isEmpty()) {
                throw new IllegalArgumentException("Cần ít nhất 1 biến thể sản phẩm");
            }

            List<String> validImageUrls = new ArrayList<>();
            if (imageUrls != null) {
                for (String url : imageUrls) {
                    if (url != null && !url.trim().isEmpty()) {
                        validImageUrls.add(url.trim());
                    }
                }
            }

            Product created = productService.createProduct(product, variants, validImageUrls);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Thêm sản phẩm '" + created.getName() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra giá và số lượng.");
            request.setAttribute("productName", name);
            request.setAttribute("selectedCategory", categoryIdParam);
            showAddForm(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("productName", name);
            request.setAttribute("selectedCategory", categoryIdParam);
            showAddForm(request, response);
        }
    }

    


    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("productName");
        String categoryIdParam = request.getParameter("category");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            int categoryId = Integer.parseInt(categoryIdParam);

            Product product = productService.getProductById(id);
            product.setName(name);
            product.setCategoryId(categoryId);
            productService.updateProduct(product);

            updateVariantsFromRequest(request, id);
            addNewVariantsFromRequest(request, id);

            addNewImagesFromRequest(request, id);
            deleteImagesFromRequest(request, id);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Cập nhật sản phẩm '" + product.getName() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/products/edit?id=" + idParam);
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products/edit?id=" + idParam);
        }
    }

    


    private void updateVariantsFromRequest(HttpServletRequest request, int productId) {
        String[] variantIds = request.getParameterValues("variantId");
        String[] variantOptions = request.getParameterValues("variantOptions");
        String[] variantStocks = request.getParameterValues("variantStock");
        String[] variantPrices = request.getParameterValues("variantPrice");

        if (variantIds == null || variantOptions == null || variantStocks == null || variantPrices == null) {
            return;
        }

        for (int i = 0; i < variantIds.length; i++) {
            try {
                int variantId = Integer.parseInt(variantIds[i]);
                String options = variantOptions[i];
                int stock = Integer.parseInt(variantStocks[i]);
                double price = Double.parseDouble(variantPrices[i]);

                ProductVariant variant = new ProductVariant();
                variant.setId(variantId);
                variant.setProductId(productId);
                variant.setOptionsValue(options);
                variant.setStock(stock);
                variant.setPrice(price);

                productService.updateVariant(variant);
            } catch (Exception e) {
                
                e.printStackTrace();
            }
        }
    }

    private void addNewVariantsFromRequest(HttpServletRequest request, int productId) {
        String[] names = request.getParameterValues("newVariantName");
        String[] prices = request.getParameterValues("newVariantPrice");
        String[] stocks = request.getParameterValues("newVariantStock");

        if (names == null || prices == null || stocks == null) {
            return;
        }

        for (int i = 0; i < names.length; i++) {
            try {
                String vName = names[i];
                if (vName == null || vName.trim().isEmpty()) continue;

                ProductVariant variant = new ProductVariant();
                variant.setProductId(productId);
                variant.setOptionsValue(vName.trim());
                variant.setPrice(Double.parseDouble(prices[i]));
                variant.setStock(Integer.parseInt(stocks[i]));

                productService.addVariant(variant);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void addNewImagesFromRequest(HttpServletRequest request, int productId) {
        String[] imageUrls = request.getParameterValues("newImageUrls");
        if (imageUrls == null) {
            return;
        }

        for (String url : imageUrls) {
            try {
                if (url != null && !url.trim().isEmpty()) {
                    productService.addImage(productId, url.trim());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void deleteImagesFromRequest(HttpServletRequest request, int productId) {
        String[] deleteIds = request.getParameterValues("deleteImageId");
        if (deleteIds == null) {
            return;
        }

        for (String idStr : deleteIds) {
            try {
                int imageId = Integer.parseInt(idStr);
                
                productService.deleteImage(imageId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }



    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productService.getProductById(id);
            String productName = product.getName();

            productService.deleteProduct(id);

            HttpSession session = request.getSession();
            session.setAttribute("success", "Xóa sản phẩm '" + productName + "' thành công!");

            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID sản phẩm không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } catch (IllegalArgumentException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}
