package group36.service;

import group36.dao.ProductDAO;
import group36.dao.ProductImageDAO;
import group36.dao.ProductVariantDAO;
import group36.dao.WishlistDAO;
import group36.model.Product;
import group36.model.ProductImage;
import group36.model.ProductVariant;
import group36.model.Wishlist;

import java.util.List;
import java.util.Optional;

public class WishlistService {

    private final WishlistDAO wishlistDAO;
    private final ProductDAO productDAO;
    private final ProductImageDAO productImageDAO;
    private final ProductVariantDAO productVariantDAO;

    public WishlistService() {
        this.wishlistDAO = new WishlistDAO();
        this.productDAO = new ProductDAO();
        this.productImageDAO = new ProductImageDAO();
        this.productVariantDAO = new ProductVariantDAO();
    }

    public List<Wishlist> getWishlistByUserId(int userId) {
        List<Wishlist> wishlistItems = wishlistDAO.findByUserId(userId);

        
        for (Wishlist item : wishlistItems) {
            loadProductDetails(item);
        }

        return wishlistItems;
    }

    public int getWishlistCount(int userId) {
        return wishlistDAO.countByUserId(userId);
    }

    public boolean isInWishlist(int userId, int productId) {
        return wishlistDAO.exists(userId, productId);
    }

    public Wishlist addToWishlist(int userId, int productId) {
        
        Optional<Product> productOpt = productDAO.findById(productId);
        if (productOpt.isEmpty()) {
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }

        
        if (wishlistDAO.exists(userId, productId)) {
            throw new IllegalArgumentException("Sản phẩm đã có trong danh sách yêu thích");
        }

        
        Wishlist wishlist = new Wishlist(userId, productId);
        int id = wishlistDAO.insert(wishlist);
        wishlist.setId(id);
        wishlist.setProduct(productOpt.get());

        return wishlist;
    }

    public void removeFromWishlist(int userId, int productId) {
        int deleted = wishlistDAO.deleteByUserIdAndProductId(userId, productId);
        if (deleted == 0) {
            throw new IllegalArgumentException("Sản phẩm không có trong danh sách yêu thích");
        }
    }

    public boolean toggleWishlist(int userId, int productId) {
        
        Optional<Product> productOpt = productDAO.findById(productId);
        if (productOpt.isEmpty()) {
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }

        
        if (wishlistDAO.exists(userId, productId)) {
            
            wishlistDAO.deleteByUserIdAndProductId(userId, productId);
            return false;
        } else {
            
            Wishlist wishlist = new Wishlist(userId, productId);
            wishlistDAO.insert(wishlist);
            return true;
        }
    }

    public void removeById(int userId, int wishlistId) {
        
        
        int deleted = wishlistDAO.delete(wishlistId);
        if (deleted == 0) {
            throw new IllegalArgumentException("Không tìm thấy mục yêu thích");
        }
    }

    public void clearWishlist(int userId) {
        wishlistDAO.deleteAllByUserId(userId);
    }

    private void loadProductDetails(Wishlist item) {
        productDAO.findById(item.getProductId()).ifPresent(product -> {
            
            List<ProductImage> images = productImageDAO.findByProductId(product.getId());
            product.setImages(images);

            
            List<ProductVariant> variants = productVariantDAO.findByProductId(product.getId());
            product.setVariants(variants);

            item.setProduct(product);
        });
    }
}
