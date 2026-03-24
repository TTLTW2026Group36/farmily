package group36.service;

import group36.dao.FlashSaleDAO;
import group36.dao.ProductDAO;
import group36.dao.ProductImageDAO;
import group36.dao.ProductVariantDAO;
import group36.model.FlashSale;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;





public class FlashSaleService {

    private final FlashSaleDAO flashSaleDAO;
    private final ProductDAO productDAO;
    private final ProductImageDAO productImageDAO;
    private final ProductVariantDAO productVariantDAO;

    public FlashSaleService() {
        this.flashSaleDAO = new FlashSaleDAO();
        this.productDAO = new ProductDAO();
        this.productImageDAO = new ProductImageDAO();
        this.productVariantDAO = new ProductVariantDAO();
    }

    


    public List<FlashSale> getActiveFlashSales() {
        List<FlashSale> flashSales = flashSaleDAO.findActiveFlashSales();
        loadProductDetails(flashSales);
        return flashSales;
    }

    


    public List<FlashSale> getActiveFlashSales(int limit) {
        List<FlashSale> flashSales = flashSaleDAO.findActiveFlashSales(limit);
        loadProductDetails(flashSales);
        return flashSales;
    }

    


    public FlashSale getFlashSaleById(int id) {
        FlashSale flashSale = flashSaleDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Flash sale not found: " + id));
        loadProductDetail(flashSale);
        return flashSale;
    }

    


    public Optional<FlashSale> getActiveFlashSaleForProduct(int productId) {
        Optional<FlashSale> flashSaleOpt = flashSaleDAO.findActiveByProductId(productId);
        flashSaleOpt.ifPresent(this::loadProductDetail);
        return flashSaleOpt;
    }

    


    public List<FlashSale> getAllFlashSales() {
        List<FlashSale> flashSales = flashSaleDAO.findAll();
        loadProductDetails(flashSales);
        return flashSales;
    }

    


    public Timestamp getNearestFlashSaleEndTime() {
        return flashSaleDAO.getNearestEndTime();
    }

    


    public FlashSale createFlashSale(FlashSale flashSale) {
        validateFlashSale(flashSale);
        productDAO.findById(flashSale.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + flashSale.getProductId()));

        Optional<FlashSale> existing = flashSaleDAO.findActiveByProductId(flashSale.getProductId());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Product already has an active flash sale: " + flashSale.getProductId());
        }

        int id = flashSaleDAO.insert(flashSale);
        flashSale.setId(id);
        loadProductDetail(flashSale);
        return flashSale;
    }

    


    public FlashSale updateFlashSale(FlashSale flashSale) {
        validateFlashSale(flashSale);
        flashSaleDAO.findById(flashSale.getId())
                .orElseThrow(() -> new IllegalArgumentException("Flash sale not found: " + flashSale.getId()));
        flashSaleDAO.update(flashSale);
        loadProductDetail(flashSale);
        return flashSale;
    }

    


    public void deleteFlashSale(int id) {
        int affected = flashSaleDAO.delete(id);
        if (affected == 0) {
            throw new IllegalArgumentException("Flash sale not found: " + id);
        }
    }

    


    public boolean incrementSoldCount(int id, int quantity) {
        return flashSaleDAO.incrementSoldCount(id, quantity) > 0;
    }

    

    private void loadProductDetails(List<FlashSale> flashSales) {
        for (FlashSale flashSale : flashSales) {
            loadProductDetail(flashSale);
        }
    }

    private void loadProductDetail(FlashSale flashSale) {
        productDAO.findById(flashSale.getProductId()).ifPresent(product -> {
            product.setImages(productImageDAO.findByProductId(product.getId()));
            product.setVariants(productVariantDAO.findByProductId(product.getId()));
            flashSale.setProduct(product);
        });
    }

    private void validateFlashSale(FlashSale flashSale) {
        if (flashSale.getProductId() <= 0) {
            throw new IllegalArgumentException("Product ID is required");
        }
        if (flashSale.getDiscountPercent() <= 0 || flashSale.getDiscountPercent() > 100) {
            throw new IllegalArgumentException("Discount percent must be between 0 and 100");
        }
        if (flashSale.getStockLimit() <= 0) {
            throw new IllegalArgumentException("Stock limit must be positive");
        }
        if (flashSale.getStartTime() == null) {
            throw new IllegalArgumentException("Start time is required");
        }
        if (flashSale.getEndTime() == null) {
            throw new IllegalArgumentException("End time is required");
        }
        if (flashSale.getEndTime().before(flashSale.getStartTime())) {
            throw new IllegalArgumentException("End time must be after start time");
        }
    }
}
