package group36.service;

import group36.dao.ReviewDAO;
import group36.dao.ReviewImageDAO;
import group36.dao.UserDAO;
import group36.dao.ProductVariantDAO;
import group36.model.Review;
import group36.model.ReviewImage;
import group36.model.User;
import group36.model.ProductVariant;

import java.util.*;
import java.util.stream.Collectors;





public class ReviewService {

    private final ReviewDAO reviewDAO;
    private final ReviewImageDAO reviewImageDAO;
    private final UserDAO userDAO;
    private final ProductVariantDAO variantDAO;

    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.reviewImageDAO = new ReviewImageDAO();
        this.userDAO = new UserDAO();
        this.variantDAO = new ProductVariantDAO();
    }

    





    public List<Review> getReviewsByProduct(int productId) {
        List<Review> reviews = reviewDAO.findByProductId(productId);
        loadReviewDetails(reviews);
        return reviews;
    }

    







    public List<Review> getReviewsByProductPaginated(int productId, int page, int size) {
        List<Review> reviews = reviewDAO.findByProductIdPaginated(productId, page, size);
        loadReviewDetails(reviews);
        return reviews;
    }

    






    public List<Review> getReviewsByProductAndRating(int productId, int rating) {
        List<Review> reviews = reviewDAO.findByProductIdAndRating(productId, rating);
        loadReviewDetails(reviews);
        return reviews;
    }

    





    public List<Review> getReviewsWithImages(int productId) {
        List<Review> reviews = reviewDAO.findByProductIdWithImages(productId);
        loadReviewDetails(reviews);
        return reviews;
    }

    





    public List<Review> getVerifiedReviews(int productId) {
        List<Review> reviews = reviewDAO.findVerifiedByProductId(productId);
        loadReviewDetails(reviews);
        return reviews;
    }

    





    public ReviewSummary getReviewSummary(int productId) {
        ReviewSummary summary = new ReviewSummary();

        summary.setTotalReviews(reviewDAO.countByProductId(productId));
        summary.setAverageRating(reviewDAO.getAverageRating(productId));

        
        summary.setCount5Star(reviewDAO.countByProductIdAndRating(productId, 5));
        summary.setCount4Star(reviewDAO.countByProductIdAndRating(productId, 4));
        summary.setCount3Star(reviewDAO.countByProductIdAndRating(productId, 3));
        summary.setCount2Star(reviewDAO.countByProductIdAndRating(productId, 2));
        summary.setCount1Star(reviewDAO.countByProductIdAndRating(productId, 1));

        
        summary.setCountWithImages(reviewDAO.countWithImagesByProductId(productId));
        summary.setCountVerified(reviewDAO.countVerifiedByProductId(productId));

        return summary;
    }

    





    public int getTotalReviews(int productId) {
        return reviewDAO.countByProductId(productId);
    }

    


    private void loadReviewDetails(List<Review> reviews) {
        if (reviews == null || reviews.isEmpty()) {
            return;
        }

        
        Set<Integer> userIds = new HashSet<>();
        Set<Integer> variantIds = new HashSet<>();
        List<Integer> reviewIds = new ArrayList<>();

        for (Review review : reviews) {
            userIds.add(review.getUserId());
            if (review.getVariantId() != null) {
                variantIds.add(review.getVariantId());
            }
            reviewIds.add(review.getId());
        }

        
        Map<Integer, User> userMap = new HashMap<>();
        for (Integer userId : userIds) {
            userDAO.findById(userId).ifPresent(user -> userMap.put(userId, user));
        }

        
        Map<Integer, ProductVariant> variantMap = new HashMap<>();
        for (Integer variantId : variantIds) {
            variantDAO.findById(variantId).ifPresent(variant -> variantMap.put(variantId, variant));
        }

        
        List<ReviewImage> allImages = reviewImageDAO.findByReviewIds(reviewIds);
        Map<Integer, List<ReviewImage>> imageMap = allImages.stream()
                .collect(Collectors.groupingBy(ReviewImage::getReviewId));

        
        for (Review review : reviews) {
            review.setUser(userMap.get(review.getUserId()));

            if (review.getVariantId() != null) {
                review.setVariant(variantMap.get(review.getVariantId()));
            }

            review.setImages(imageMap.getOrDefault(review.getId(), Collections.emptyList()));
        }
    }

    


    public static class ReviewSummary {
        private int totalReviews;
        private double averageRating;
        private int count5Star;
        private int count4Star;
        private int count3Star;
        private int count2Star;
        private int count1Star;
        private int countWithImages;
        private int countVerified;

        
        public int getTotalReviews() {
            return totalReviews;
        }

        public void setTotalReviews(int totalReviews) {
            this.totalReviews = totalReviews;
        }

        public double getAverageRating() {
            return averageRating;
        }

        public void setAverageRating(double averageRating) {
            this.averageRating = averageRating;
        }

        public int getCount5Star() {
            return count5Star;
        }

        public void setCount5Star(int count5Star) {
            this.count5Star = count5Star;
        }

        public int getCount4Star() {
            return count4Star;
        }

        public void setCount4Star(int count4Star) {
            this.count4Star = count4Star;
        }

        public int getCount3Star() {
            return count3Star;
        }

        public void setCount3Star(int count3Star) {
            this.count3Star = count3Star;
        }

        public int getCount2Star() {
            return count2Star;
        }

        public void setCount2Star(int count2Star) {
            this.count2Star = count2Star;
        }

        public int getCount1Star() {
            return count1Star;
        }

        public void setCount1Star(int count1Star) {
            this.count1Star = count1Star;
        }

        public int getCountWithImages() {
            return countWithImages;
        }

        public void setCountWithImages(int countWithImages) {
            this.countWithImages = countWithImages;
        }

        public int getCountVerified() {
            return countVerified;
        }

        public void setCountVerified(int countVerified) {
            this.countVerified = countVerified;
        }

        


        public int getPercentage(int star) {
            if (totalReviews == 0)
                return 0;
            int count = 0;
            switch (star) {
                case 5:
                    count = count5Star;
                    break;
                case 4:
                    count = count4Star;
                    break;
                case 3:
                    count = count3Star;
                    break;
                case 2:
                    count = count2Star;
                    break;
                case 1:
                    count = count1Star;
                    break;
            }
            return (int) Math.round((count * 100.0) / totalReviews);
        }

        


        public String getFormattedAvgRating() {
            return String.format("%.1f", averageRating);
        }
    }
}
