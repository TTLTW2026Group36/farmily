package group36.service;

import group36.dao.FlashSaleDAO;
import group36.dao.OrderDetailDAO;
import group36.dao.ProductDAO;
import group36.dao.ProductImageDAO;
import group36.dao.ProductVariantDAO;
import group36.model.Cart;
import group36.model.CartItem;
import group36.model.FlashSale;
import group36.model.Product;
import group36.model.ProductVariant;
import group36.util.RedisPool;
import redis.clients.jedis.Jedis;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

public class CartService {

    private final ProductDAO productDAO;
    private final ProductVariantDAO variantDAO;
    private final ProductImageDAO imageDAO;
    private final FlashSaleDAO flashSaleDAO;
    private final OrderDetailDAO orderDetailDAO;

    private static final int CART_TTL_SECONDS;

    static {
        Properties props = new Properties();
        int ttl = 2592000;
        try (InputStream in = CartService.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in != null) {
                props.load(in);
                String val = props.getProperty("redis.cart.ttl.seconds");
                if (val != null && !val.trim().isEmpty()) {
                    ttl = Integer.parseInt(val.trim());
                }
            }
        } catch (IOException | NumberFormatException ignored) {
        }
        CART_TTL_SECONDS = ttl;
    }

    public CartService() {
        this.productDAO = new ProductDAO();
        this.variantDAO = new ProductVariantDAO();
        this.imageDAO = new ProductImageDAO();
        this.flashSaleDAO = new FlashSaleDAO();
        this.orderDetailDAO = new OrderDetailDAO();
    }

    private String cartKey(int userId) {
        return "cart:user:" + userId;
    }

    private String encodeField(int productId, Integer variantId) {
        return productId + "_" + (variantId != null ? variantId : 0);
    }

    private int encodeItemId(int productId, Integer variantId) {
        return productId * 1000000 + (variantId != null ? variantId : 0);
    }

    private int[] decodeItemId(int itemId) {
        int productId = itemId / 1000000;
        int variantId = itemId % 1000000;
        return new int[]{productId, variantId};
    }

    public Cart getCartByUserId(int userId) {
        Cart cart = new Cart(userId);
        try (Jedis jedis = RedisPool.getConnection()) {
            Map<String, String> hash = jedis.hgetAll(cartKey(userId));
            if (hash == null || hash.isEmpty()) {
                return cart;
            }
            List<CartItem> items = new ArrayList<>();
            for (Map.Entry<String, String> entry : hash.entrySet()) {
                String[] parts = entry.getKey().split("_");
                int productId = Integer.parseInt(parts[0]);
                int variantIdRaw = Integer.parseInt(parts[1]);
                Integer variantId = variantIdRaw == 0 ? null : variantIdRaw;
                int quantity = Integer.parseInt(entry.getValue());

                CartItem item = new CartItem(0, productId, variantId, quantity);
                item.setId(encodeItemId(productId, variantId));
                loadItemDetails(item, userId);
                items.add(item);
            }
            cart.setItems(items);
        }
        return cart;
    }

    public int getCartItemCount(int userId) {
        try (Jedis jedis = RedisPool.getConnection()) {
            return (int) jedis.hlen(cartKey(userId));
        }
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

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(productId);
        if (flashSaleOpt.isPresent()) {
            FlashSale fs = flashSaleOpt.get();
            if (fs.getMaxQtyPerUser() > 0) {
                int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, productId, fs.getStartTime(), fs.getEndTime());
                int currentInCart = getCurrentQuantityFromRedis(userId, productId, variantId);
                int newQty = currentInCart + quantity;
                if (purchased >= fs.getMaxQtyPerUser()) {
                    throw new IllegalArgumentException("Bạn đã mua sản phẩm này đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                }
                if (purchased + newQty > fs.getMaxQtyPerUser()) {
                    int allowed = fs.getMaxQtyPerUser() - purchased - currentInCart;
                    throw new IllegalArgumentException("Bạn chỉ được mua thêm tối đa " + allowed + " sản phẩm này trong chương trình Flash Sale (đã mua: " + purchased + ")");
                }
            }
        }

        String field = encodeField(productId, variantId);
        int newQuantity;
        try (Jedis jedis = RedisPool.getConnection()) {
            String current = jedis.hget(cartKey(userId), field);
            int currentQty = current != null ? Integer.parseInt(current) : 0;
            newQuantity = currentQty + quantity;

            if (variant != null && variant.getStock() < newQuantity) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }

            jedis.hset(cartKey(userId), field, String.valueOf(newQuantity));
            jedis.expire(cartKey(userId), CART_TTL_SECONDS);
        }

        CartItem item = new CartItem(0, productId, variantId, newQuantity);
        item.setId(encodeItemId(productId, variantId));
        item.setProduct(product);
        item.setVariant(variant);
        applyFlashSalePrice(item, userId);
        return item;
    }

    public CartItem updateQuantity(int userId, int itemId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }

        int[] decoded = decodeItemId(itemId);
        int productId = decoded[0];
        Integer variantId = decoded[1] == 0 ? null : decoded[1];

        if (productId <= 0) {
            throw new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng");
        }

        try (Jedis jedis = RedisPool.getConnection()) {
            String field = encodeField(productId, variantId);
            String existing = jedis.hget(cartKey(userId), field);
            if (existing == null) {
                throw new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng");
            }

            if (variantId != null) {
                ProductVariant variant = variantDAO.findById(variantId).orElse(null);
                if (variant != null && variant.getStock() < quantity) {
                    throw new IllegalArgumentException(
                            "Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
                }
            }

            Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(productId);
            if (flashSaleOpt.isPresent()) {
                FlashSale fs = flashSaleOpt.get();
                if (fs.getMaxQtyPerUser() > 0) {
                    int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, productId, fs.getStartTime(), fs.getEndTime());
                    if (purchased >= fs.getMaxQtyPerUser()) {
                        throw new IllegalArgumentException("Bạn đã mua sản phẩm này đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                    }
                    if (purchased + quantity > fs.getMaxQtyPerUser()) {
                        int allowed = fs.getMaxQtyPerUser() - purchased;
                        throw new IllegalArgumentException("Bạn chỉ được mua tối đa " + allowed + " sản phẩm này trong chương trình Flash Sale (đã mua: " + purchased + ")");
                    }
                }
            }

            jedis.hset(cartKey(userId), field, String.valueOf(quantity));
            jedis.expire(cartKey(userId), CART_TTL_SECONDS);
        }

        CartItem item = new CartItem(0, productId, variantId, quantity);
        item.setId(itemId);
        loadItemDetails(item, userId);
        return item;
    }

    public void removeItem(int userId, int itemId) {
        int[] decoded = decodeItemId(itemId);
        int productId = decoded[0];
        Integer variantId = decoded[1] == 0 ? null : decoded[1];

        if (productId <= 0) {
            throw new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng");
        }

        try (Jedis jedis = RedisPool.getConnection()) {
            jedis.hdel(cartKey(userId), encodeField(productId, variantId));
        }
    }

    public void clearCart(int userId) {
        try (Jedis jedis = RedisPool.getConnection()) {
            jedis.del(cartKey(userId));
        }
    }

    public CartItem updateVariant(int userId, int itemId, int newVariantId) {
        int[] decoded = decodeItemId(itemId);
        int productId = decoded[0];
        Integer oldVariantId = decoded[1] == 0 ? null : decoded[1];

        if (productId <= 0) {
            throw new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng");
        }

        ProductVariant newVariant = variantDAO.findById(newVariantId)
                .orElseThrow(() -> new IllegalArgumentException("Phân loại sản phẩm không tồn tại"));

        if (newVariant.getProductId() != productId) {
            throw new IllegalArgumentException("Phân loại không thuộc sản phẩm này");
        }

        String oldField = encodeField(productId, oldVariantId);
        String newField = encodeField(productId, newVariantId);

        int finalQty;
        try (Jedis jedis = RedisPool.getConnection()) {
            String oldQtyStr = jedis.hget(cartKey(userId), oldField);
            if (oldQtyStr == null) {
                throw new IllegalArgumentException("Sản phẩm không tồn tại trong giỏ hàng");
            }
            int oldQty = Integer.parseInt(oldQtyStr);

            String existingNewStr = jedis.hget(cartKey(userId), newField);
            int existingNewQty = existingNewStr != null ? Integer.parseInt(existingNewStr) : 0;
            finalQty = oldQty + existingNewQty;

            if (newVariant.getStock() < finalQty) {
                throw new IllegalArgumentException(
                        "Số lượng tồn kho không đủ cho việc gộp. Chỉ còn " + newVariant.getStock() + " sản phẩm.");
            }

            Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(productId);
            if (flashSaleOpt.isPresent()) {
                FlashSale fs = flashSaleOpt.get();
                if (fs.getMaxQtyPerUser() > 0) {
                    int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, productId, fs.getStartTime(), fs.getEndTime());
                    if (purchased >= fs.getMaxQtyPerUser()) {
                        throw new IllegalArgumentException("Bạn đã mua sản phẩm này đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                    }
                    if (purchased + finalQty > fs.getMaxQtyPerUser()) {
                        int allowed = fs.getMaxQtyPerUser() - purchased;
                        throw new IllegalArgumentException("Bạn chỉ được mua tối đa " + allowed + " sản phẩm này trong chương trình Flash Sale (đã mua: " + purchased + ")");
                    }
                }
            }

            jedis.hdel(cartKey(userId), oldField);
            jedis.hset(cartKey(userId), newField, String.valueOf(finalQty));
            jedis.expire(cartKey(userId), CART_TTL_SECONDS);
        }

        CartItem item = new CartItem(0, productId, newVariantId, finalQty);
        item.setId(encodeItemId(productId, newVariantId));
        loadItemDetails(item, userId);
        return item;
    }

    public List<ProductVariant> getProductVariants(int productId) {
        return variantDAO.findByProductId(productId);
    }

    private int getCurrentQuantityFromRedis(int userId, int productId, Integer variantId) {
        try (Jedis jedis = RedisPool.getConnection()) {
            String val = jedis.hget(cartKey(userId), encodeField(productId, variantId));
            return val != null ? Integer.parseInt(val) : 0;
        }
    }

    private void loadItemDetails(CartItem item, Integer userId) {
        if (item == null) return;

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

        applyFlashSalePrice(item, userId);
    }

    private void applyFlashSalePrice(CartItem item, Integer userId) {
        if (item == null) return;

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(item.getProductId());

        if (flashSaleOpt.isPresent()) {
            FlashSale flashSale = flashSaleOpt.get();

            if (flashSale.getRemainingStock() > 0) {
                if (userId != null && userId > 0 && flashSale.getMaxQtyPerUser() > 0) {
                    int purchasedQty = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, flashSale.getProductId(), flashSale.getStartTime(), flashSale.getEndTime());
                    if (purchasedQty >= flashSale.getMaxQtyPerUser()) {
                        return;
                    }
                }

                double originalPrice = item.getOriginalUnitPrice();
                if (originalPrice > 0) {
                    double salePrice = flashSale.getSalePrice(originalPrice);
                    item.setFlashSalePrice(salePrice);
                }
            }
        }
    }

    public Cart createBuyNowCart(int userId, int productId, Integer variantId, int quantity) {
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
                throw new IllegalArgumentException("Số lượng tồn kho không đủ. Chỉ còn " + variant.getStock() + " sản phẩm.");
            }
        }

        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(productId);
        if (flashSaleOpt.isPresent()) {
            FlashSale fs = flashSaleOpt.get();
            if (fs.getMaxQtyPerUser() > 0) {
                int purchased = orderDetailDAO.getPurchasedQuantityInTimeRange(userId, productId, fs.getStartTime(), fs.getEndTime());
                if (purchased >= fs.getMaxQtyPerUser()) {
                    throw new IllegalArgumentException("Bạn đã mua sản phẩm này đạt giới hạn tối đa của chương trình Flash Sale (" + fs.getMaxQtyPerUser() + " sản phẩm)");
                }
                if (purchased + quantity > fs.getMaxQtyPerUser()) {
                    int allowed = fs.getMaxQtyPerUser() - purchased;
                    throw new IllegalArgumentException("Bạn chỉ được mua tối đa " + allowed + " sản phẩm này trong chương trình Flash Sale (đã mua: " + purchased + ")");
                }
            }
        }

        Cart cart = new Cart(userId);
        CartItem item = new CartItem(0, productId, variantId, quantity);
        item.setProduct(product);
        item.setVariant(variant);
        applyFlashSalePrice(item, userId);

        product.setImages(imageDAO.findByProductId(product.getId()));
        List<ProductVariant> variants = variantDAO.findByProductId(product.getId());
        product.setVariants(variants);

        cart.getItems().add(item);
        return cart;
    }
}
