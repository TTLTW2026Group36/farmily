package group36.model;

import java.io.Serializable;





public class OrderDetail implements Serializable {
    private int id;
    private int orderId;
    private int productId;
    private Integer variantId; 
    private int quantity;
    private double unitPrice;
    private double subtotal;

    
    private Product product;
    private ProductVariant variant;

    
    public OrderDetail() {
    }

    public OrderDetail(int orderId, int productId, Integer variantId, int quantity, double unitPrice) {
        this.orderId = orderId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = unitPrice * quantity;
    }

    public OrderDetail(int id, int orderId, int productId, Integer variantId,
            int quantity, double unitPrice, double subtotal) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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
        
        this.subtotal = this.unitPrice * quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        
        this.subtotal = unitPrice * this.quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
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

    

    




    public String getProductName() {
        return product != null ? product.getName() : "";
    }

    




    public String getVariantText() {
        return variant != null ? variant.getOptionsValue() : "";
    }

    




    public String getFormattedUnitPrice() {
        return String.format("%,.0f", unitPrice).replace(",", ".") + "đ";
    }

    




    public String getFormattedSubtotal() {
        return String.format("%,.0f", subtotal).replace(",", ".") + "đ";
    }

    




    public String getImageUrl() {
        if (product == null) {
            System.out.println("DEBUG OrderDetail.getImageUrl(): product is NULL");
            return "/images/placeholder.jpg";
        }

        String imageUrl = product.getPrimaryImageUrl();
        System.out.println("DEBUG OrderDetail.getImageUrl(): productId=" + product.getId() +
                ", imageUrl=" + imageUrl +
                ", imagesCount=" + (product.getImages() != null ? product.getImages().size() : "null"));

        
        if (imageUrl == null || imageUrl.isEmpty()) {
            return "/images/placeholder.jpg";
        }

        
        if (imageUrl.startsWith("http://") || imageUrl.startsWith("https://")) {
            System.out.println("DEBUG: External URL detected, returning as-is");
            return imageUrl;
        }

        
        if (!imageUrl.startsWith("/images/")) {
            
            if (imageUrl.startsWith("/")) {
                imageUrl = imageUrl.substring(1);
            }
            imageUrl = "/images/" + imageUrl;
            System.out.println("DEBUG: Fixed local path to: " + imageUrl);
        }

        return imageUrl;
    }

    






    public static OrderDetail fromCartItem(CartItem cartItem, int orderId) {
        OrderDetail detail = new OrderDetail();
        detail.setOrderId(orderId);
        detail.setProductId(cartItem.getProductId());
        detail.setVariantId(cartItem.getVariantId());
        detail.setQuantity(cartItem.getQuantity());
        detail.setUnitPrice(cartItem.getUnitPrice());
        detail.setSubtotal(cartItem.getSubtotal());
        detail.setProduct(cartItem.getProduct());
        detail.setVariant(cartItem.getVariant());
        return detail;
    }

    @Override
    public String toString() {
        return "OrderDetail{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", variantId=" + variantId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", subtotal=" + subtotal +
                '}';
    }
}
