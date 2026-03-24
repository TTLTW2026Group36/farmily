package group36.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private int id;
    private int cartId;
    private int productId;
    private Integer variantId; 
    private int quantity;

    private Product product;
    private ProductVariant variant;
    private Double flashSalePrice;

    
    public CartItem() {
    }

    public CartItem(int cartId, int productId, Integer variantId, int quantity) {
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
    }

    public CartItem(int id, int cartId, int productId, Integer variantId, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getVariantId() {
        return variantId;
    }

    public void setVariantId(Integer variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public Double getFlashSalePrice() {
        return flashSalePrice;
    }

    public void setFlashSalePrice(Double flashSalePrice) {
        this.flashSalePrice = flashSalePrice;
    }

    
    public String getProductName() {
        return product != null ? product.getName() : "";
    }

    public String getVariantText() {
        return variant != null ? variant.getOptionsValue() : "";
    }

    public double getUnitPrice() {
        
        if (flashSalePrice != null && flashSalePrice > 0) {
            return flashSalePrice;
        }
        if (variant != null) {
            return variant.getPrice();
        }
        if (product != null) {
            return product.getMinPrice();
        }
        return 0;
    }

    public double getOriginalUnitPrice() {
        if (variant != null) {
            return variant.getPrice();
        }
        if (product != null) {
            return product.getMinPrice();
        }
        return 0;
    }

    public boolean hasFlashSalePrice() {
        return flashSalePrice != null && flashSalePrice > 0;
    }

    public String getFormattedUnitPrice() {
        return String.format("%,.0f", getUnitPrice()).replace(",", ".") + "đ";
    }

    public double getSubtotal() {
        return getUnitPrice() * quantity;
    }

    public String getFormattedSubtotal() {
        return String.format("%,.0f", getSubtotal()).replace(",", ".") + "đ";
    }

    public String getImageUrl() {
        return product != null ? product.getPrimaryImageUrl() : null;
    }

    public int getStock() {
        return variant != null ? variant.getStock() : 0;
    }

    public boolean isStockSufficient() {
        return getStock() >= quantity;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", cartId=" + cartId +
                ", productId=" + productId +
                ", variantId=" + variantId +
                ", quantity=" + quantity +
                '}';
    }
}
