package group36.service;

import group36.dao.CartDAO;
import group36.dao.CartItemDAO;
import group36.dao.FlashSaleDAO;
import group36.dao.ProductDAO;
import group36.dao.ProductImageDAO;
import group36.dao.ProductVariantDAO;
import group36.model.Cart;
import group36.model.CartItem;
import group36.model.FlashSale;
import group36.model.Product;
import group36.model.ProductVariant;

import java.util.List;
import java.util.Optional;

public class CartService {
    private final CartDAO cartDAO;
    private final CartItemDAO cartItemDAO;
    private final ProductDAO productDAO;
    private final ProductVariantDAO variantDAO;
    private final ProductImageDAO imageDAO;
    private final FlashSaleDAO flashSaleDAO;

    public CartService() {
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productDAO = new ProductDAO();
        this.variantDAO = new ProductVariantDAO();
        this.imageDAO = new ProductImageDAO();
        this.flashSaleDAO = new FlashSaleDAO();
    }

    





    public Cart getCartByUserId(int userId) {
        Optional<Cart> cartOpt = cartDAO.findByUserId(userId);

        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            loadCartItems(cart);
            return cart;
        }

        
        Cart emptyCart = new Cart(userId);
        return emptyCart;
    }

    





    public Cart getOrCreateCart(int userId) {
        Optional<Cart> cartOpt = cartDAO.findByUserId(userId);

        if (cartOpt.isPresent()) {
            return cartOpt.get();
        }

        
        Cart cart = new Cart(userId);
        int cartId = cartDAO.insert(cart);
        cart.setId(cartId);
        return cart;
    }

    





    public int getCartItemCount(int userId) {
        Optional<Cart> cartOpt = cartDAO.findByUserId(userId);
        if (cartOpt.isPresent()) {
            return cartItemDAO.countByCartId(cartOpt.get().getId());
        }
        return 0;
    }

    









    public CartItem addToCart(int userId, int productId, Integer variantId, int quantity) {
        
        if (quantity <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }

        Product product = productDAO.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại"));

        ProductVariant variant = null;
        if (variantId != null) {
            variant = variantDAO.findById(variantId)
                    .orElseThrow(() -> new IllegalArgumentException("Phân loại sản phẩm không tồn tại"));

            if (variant.getStock() < quantity) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }
        }

        Cart cart = getOrCreateCart(userId);

        Optional<CartItem> existingItem = cartItemDAO.findByCartAndProduct(cart.getId(), productId, variantId);

        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            int newQuantity = item.getQuantity() + quantity;

            if (variant != null && variant.getStock() < newQuantity) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }

            cartItemDAO.updateQuantity(item.getId(), newQuantity);
            item.setQuantity(newQuantity);
            item.setProduct(product);
            item.setVariant(variant);
            return item;
        } else {
            CartItem item = new CartItem(cart.getId(), productId, variantId, quantity);
            int itemId = cartItemDAO.insert(item);
            item.setId(itemId);
            item.setProduct(product);
            item.setVariant(variant);
            return item;
        }
    }

    








    public CartItem updateQuantity(int userId, int itemId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }

        
        CartItem item = cartItemDAO.findById(itemId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng"));

        
        Cart cart = cartDAO.findById(item.getCartId())
                .orElseThrow(() -> new IllegalArgumentException("Giỏ hàng không tồn tại"));

        if (cart.getUserId() != userId) {
            throw new IllegalArgumentException("Không có quyền cập nhật giỏ hàng này");
        }

        
        if (item.getVariantId() != null) {
            ProductVariant variant = variantDAO.findById(item.getVariantId()).orElse(null);
            if (variant != null && variant.getStock() < quantity) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }
        }

        
        cartItemDAO.updateQuantity(itemId, quantity);
        item.setQuantity(quantity);

        
        loadItemDetails(item);

        return item;
    }

    






    public void removeItem(int userId, int itemId) {
        
        CartItem item = cartItemDAO.findById(itemId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng"));

        
        Cart cart = cartDAO.findById(item.getCartId())
                .orElseThrow(() -> new IllegalArgumentException("Giỏ hàng không tồn tại"));

        if (cart.getUserId() != userId) {
            throw new IllegalArgumentException("Không có quyền xóa sản phẩm này");
        }

        cartItemDAO.delete(itemId);
    }

    




    public void clearCart(int userId) {
        Optional<Cart> cartOpt = cartDAO.findByUserId(userId);
        if (cartOpt.isPresent()) {
            cartItemDAO.deleteByCartId(cartOpt.get().getId());
        }
    }

    








    public CartItem updateVariant(int userId, int itemId, int variantId) {
        CartItem item = cartItemDAO.findById(itemId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng"));

        Cart cart = cartDAO.findById(item.getCartId())
                .orElseThrow(() -> new IllegalArgumentException("Giỏ hàng không tồn tại"));

        if (cart.getUserId() != userId) {
            throw new IllegalArgumentException("Không có quyền cập nhật giỏ hàng này");
        }

        ProductVariant variant = variantDAO.findById(variantId)
                .orElseThrow(() -> new IllegalArgumentException("Phân loại sản phẩm không tồn tại"));

        if (variant.getProductId() != item.getProductId()) {
            throw new IllegalArgumentException("Phân loại không thuộc sản phẩm này");
        }

        
        if (variant.getStock() < item.getQuantity()) {
            throw new IllegalArgumentException(
                    "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
        }

        Optional<CartItem> existing = cartItemDAO.findByCartAndProduct(cart.getId(), item.getProductId(), variantId);
        if (existing.isPresent() && existing.get().getId() != itemId) {
            CartItem existingItem = existing.get();
            int newQty = existingItem.getQuantity() + item.getQuantity();

            if (variant.getStock() < newQty) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ cho việc gộp. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }

            cartItemDAO.updateQuantity(existingItem.getId(), newQty);
            cartItemDAO.delete(itemId);

            existingItem.setQuantity(newQty);
            loadItemDetails(existingItem);
            return existingItem;
        }

        
        cartItemDAO.updateVariant(itemId, variantId);
        item.setVariantId(variantId);

        
        loadItemDetails(item);

        return item;
    }

    public List<ProductVariant> getProductVariants(int productId) {
        return variantDAO.findByProductId(productId);
    }

    
    private void loadCartItems(Cart cart) {
        if (cart == null)
            return;

        List<CartItem> items = cartItemDAO.findByCartId(cart.getId());

        for (CartItem item : items) {
            loadItemDetails(item);
        }

        cart.setItems(items);
    }

    private void loadItemDetails(CartItem item) {
        if (item == null)
            return;

        
        productDAO.findById(item.getProductId()).ifPresent(product -> {
            product.setImages(imageDAO.findByProductId(product.getId()));
            List<ProductVariant> variants = variantDAO.findByProductId(product.getId());
            product.setVariants(variants);
            item.setProduct(product);

            
            if (item.getVariantId() != null) {
                for (ProductVariant v : variants) {
                    if (Integer.valueOf(v.getId()).equals(item.getVariantId())) {
                        item.setVariant(v);
                        break;
                    }
                }
            }
        });

        
        if (item.getVariantId() != null && item.getVariant() == null) {
            variantDAO.findById(item.getVariantId()).ifPresent(item::setVariant);
        }

        
        applyFlashSalePrice(item);
    }

    private void applyFlashSalePrice(CartItem item) {
        if (item == null)
            return;

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(item.getProductId());

        if (flashSaleOpt.isPresent()) {
            FlashSale flashSale = flashSaleOpt.get();
            
            if (flashSale.getRemainingStock() > 0) {
                
                double originalPrice = item.getOriginalUnitPrice();

                if (originalPrice > 0) {
                    
                    double salePrice = flashSale.getSalePrice(originalPrice);
                    item.setFlashSalePrice(salePrice);
                }
            }
        }
    }
}
