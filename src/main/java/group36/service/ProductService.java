package group36.service;

import group36.dao.CategoryDAO;
import group36.dao.ProductDAO;
import group36.dao.ProductImageDAO;
import group36.dao.ProductVariantDAO;
import group36.model.Product;
import group36.model.ProductImage;
import group36.model.ProductVariant;

import java.util.List;

public class ProductService {
    private final ProductDAO productDAO;
    private final ProductVariantDAO variantDAO;
    private final ProductImageDAO imageDAO;
    private final CategoryDAO categoryDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
        this.variantDAO = new ProductVariantDAO();
        this.imageDAO = new ProductImageDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public List<Product> getAllProducts() {
        List<Product> products = productDAO.findAll();
        loadProductDetails(products);
        return products;
    }

    public List<Product> getProductsPaginated(int page, int size) {
        List<Product> products = productDAO.findAllPaginated(page, size);
        loadProductDetails(products);
        return products;
    }

    public List<Product> getProductsByCategoryPaginated(int categoryId, int page, int size) {
        List<Product> products = productDAO.findByCategoryIdPaginated(categoryId, page, size);
        loadProductDetails(products);
        return products;
    }

    public List<Product> getProductsFiltered(int categoryId, String status, String search, String sort, int page, int size) {
        List<Product> products = productDAO.findFiltered(categoryId, status, search, sort, page, size);
        loadProductDetails(products);
        return products;
    }

    public int getTotalProductsFiltered(int categoryId, String status, String search) {
        return productDAO.countFiltered(categoryId, status, search);
    }

    public Product getProductById(int id) {
        Product product = productDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + id));
        loadProductDetails(product);
        return product;
    }

    public List<Product> searchProducts(String keyword) {
        List<Product> products = productDAO.searchByName(keyword);
        loadProductDetails(products);
        return products;
    }

    public int getTotalProducts() {
        return productDAO.count();
    }

    public int getTotalProductsByCategory(int categoryId) {
        return productDAO.countByCategoryId(categoryId);
    }

    public List<Product> getBestSellingProducts(int limit) {
        List<Product> products = productDAO.findBestSelling(limit);
        loadProductDetails(products);
        return products;
    }

    public List<Product> getNewestProducts(int limit) {
        List<Product> products = productDAO.findNewest(limit);
        loadProductDetails(products);
        return products;
    }

    public List<Product> getRelatedProducts(int productId, int categoryId, int limit) {
        List<Product> products = productDAO.findByCategoryIdExcluding(categoryId, productId, limit);
        loadProductDetails(products);
        return products;
    }

    public List<Product> getProductsPaginatedSorted(int page, int size, String sort) {
        String[] sortParams = parseSortParam(sort);
        List<Product> products = productDAO.findAllPaginatedSorted(page, size, sortParams[0], sortParams[1]);
        loadProductDetails(products);

        if ("price".equals(sortParams[0])) {
            sortByPrice(products, "DESC".equals(sortParams[1]));
        }

        return products;
    }

    public List<Product> getProductsByCategoryPaginatedSorted(int categoryId, int page, int size, String sort) {
        String[] sortParams = parseSortParam(sort);
        List<Product> products = productDAO.findByCategoryIdPaginatedSorted(categoryId, page, size,
                sortParams[0], sortParams[1]);
        loadProductDetails(products);

        if ("price".equals(sortParams[0])) {
            sortByPrice(products, "DESC".equals(sortParams[1]));
        }

        return products;
    }

    private String[] parseSortParam(String sort) {
        if (sort == null || sort.isEmpty() || "default".equals(sort)) {
            return new String[] { "id", "DESC" };
        }
        switch (sort) {
            case "name-asc":
                return new String[] { "name", "ASC" };
            case "name-desc":
                return new String[] { "name", "DESC" };
            case "price-asc":
                return new String[] { "price", "ASC" };
            case "price-desc":
                return new String[] { "price", "DESC" };
            case "popular":
                return new String[] { "sold_count", "DESC" };
            case "newest":
                return new String[] { "created_at", "DESC" };
            default:
                return new String[] { "id", "DESC" };
        }
    }

    private void sortByPrice(List<Product> products, boolean descending) {
        products.sort((p1, p2) -> {
            double price1 = p1.getMinPrice();
            double price2 = p2.getMinPrice();
            return descending ? Double.compare(price2, price1) : Double.compare(price1, price2);
        });
    }

    public Product createProduct(Product product, List<ProductVariant> variants, List<String> imageUrls) {

        validateProduct(product);
        validateVariants(variants);

        categoryDAO.findById(product.getCategoryId())
                .orElseThrow(
                        () -> new IllegalArgumentException("Category not found with ID: " + product.getCategoryId()));

        int productId = productDAO.insert(product);
        product.setId(productId);

        if (variants != null && !variants.isEmpty()) {
            for (ProductVariant variant : variants) {
                variant.setProductId(productId);
                int variantId = variantDAO.insert(variant);
                variant.setId(variantId);
            }
            product.setVariants(variants);
        }

        if (imageUrls != null && !imageUrls.isEmpty()) {
            for (String imageUrl : imageUrls) {
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    ProductImage image = new ProductImage(productId, imageUrl.trim());
                    imageDAO.insert(image);
                }
            }
        }

        return product;
    }

    public Product updateProduct(Product product) {

        validateProduct(product);

        getProductById(product.getId());

        categoryDAO.findById(product.getCategoryId())
                .orElseThrow(
                        () -> new IllegalArgumentException("Category not found with ID: " + product.getCategoryId()));

        int rowsAffected = productDAO.update(product);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to update product");
        }

        return getProductById(product.getId());
    }

    public ProductVariant addVariant(int productId, String optionsValue, int stock, double price) {

        getProductById(productId);

        if (optionsValue == null || optionsValue.trim().isEmpty()) {
            throw new IllegalArgumentException("Options value cannot be empty");
        }
        if (price <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        if (stock < 0) {
            throw new IllegalArgumentException("Stock cannot be negative");
        }

        ProductVariant variant = new ProductVariant(productId, optionsValue.trim(), stock, price);
        int variantId = variantDAO.insert(variant);
        variant.setId(variantId);
        return variant;
    }

    public int updateVariant(ProductVariant variant) {
        if (variant.getOptionsValue() == null || variant.getOptionsValue().trim().isEmpty()) {
            throw new IllegalArgumentException("Options value cannot be empty");
        }
        if (variant.getPrice() <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        if (variant.getStock() < 0) {
            throw new IllegalArgumentException("Stock cannot be negative");
        }
        return variantDAO.update(variant);
    }

    public ProductVariant addVariant(ProductVariant variant) {
        getProductById(variant.getProductId());
        if (variant.getOptionsValue() == null || variant.getOptionsValue().trim().isEmpty()) {
            throw new IllegalArgumentException("Options value cannot be empty");
        }
        if (variant.getPrice() <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        if (variant.getStock() < 0) {
            throw new IllegalArgumentException("Stock cannot be negative");
        }
        int variantId = variantDAO.insert(variant);
        variant.setId(variantId);
        return variant;
    }

    public ProductImage addImage(int productId, String imageUrl) {

        getProductById(productId);

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            throw new IllegalArgumentException("Image URL cannot be empty");
        }

        ProductImage image = new ProductImage(productId, imageUrl.trim());
        int imageId = imageDAO.insert(image);
        image.setId(imageId);
        return image;
    }

    public void deleteProduct(int id) {

        getProductById(id);

        int rowsAffected = productDAO.delete(id);
        if (rowsAffected == 0) {
            throw new IllegalStateException("Failed to delete product");
        }
    }

    public int deleteVariant(int variantId) {
        return variantDAO.delete(variantId);
    }

    public int deleteImage(int imageId) {
        return imageDAO.delete(imageId);
    }

    private void loadProductDetails(Product product) {
        if (product == null)
            return;

        categoryDAO.findById(product.getCategoryId())
                .ifPresent(product::setCategory);

        product.setVariants(variantDAO.findByProductId(product.getId()));

        product.setImages(imageDAO.findByProductId(product.getId()));
    }

    private void loadProductDetails(List<Product> products) {
        if (products == null || products.isEmpty())
            return;
        for (Product product : products) {
            loadProductDetails(product);
        }
    }

    private void validateProduct(Product product) {
        if (product == null) {
            throw new IllegalArgumentException("Product cannot be null");
        }
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Product name cannot be empty");
        }
        if (product.getCategoryId() <= 0) {
            throw new IllegalArgumentException("Invalid category ID");
        }
        product.setName(product.getName().trim());
    }

    private void validateVariants(List<ProductVariant> variants) {
        if (variants == null || variants.isEmpty()) {
            return;
        }
        for (ProductVariant variant : variants) {
            if (variant.getPrice() <= 0) {
                throw new IllegalArgumentException("Variant price must be greater than 0");
            }
            if (variant.getStock() < 0) {
                throw new IllegalArgumentException("Variant stock cannot be negative");
            }
            if (variant.getOptionsValue() == null || variant.getOptionsValue().trim().isEmpty()) {
                throw new IllegalArgumentException("Variant options value cannot be empty");
            }
        }
    }
}
