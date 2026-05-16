package group36.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import group36.model.Review;
import group36.model.ReviewImage;
import group36.service.ReviewService;

import java.util.HashSet;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ReviewApiController", urlPatterns = {"/review-api"})
public class ReviewApiController extends HttpServlet {

    private static final int PAGE_SIZE = 5;
    private final ReviewService reviewService = new ReviewService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int productId = parseIntParam(request, "productId", 0);
            if (productId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"productId required\"}");
                return;
            }

            String filterType = request.getParameter("filter");
            if (filterType == null || filterType.isEmpty()) filterType = "all";

            int page = parseIntParam(request, "page", 1);
            if (page < 1) page = 1;

            // Resolve filterValue: variantId for "variant", rating value for "rating"
            Integer filterValue = null;
            if ("variant".equals(filterType)) {
                filterValue = parseIntParamNullable(request, "variantId");
                if (filterValue == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"variantId required for variant filter\"}");
                    return;
                }
            } else if ("rating".equals(filterType)) {
                filterValue = parseIntParamNullable(request, "rating");
                if (filterValue == null) {
                    // fallback: try numeric filter param (e.g. filter=5)
                    try {
                        filterValue = Integer.parseInt(filterType);
                        filterType = "rating";
                    } catch (NumberFormatException e) {
                        filterValue = null;
                    }
                }
            }

            // Handle numeric filter shorthand: filter=5 means rating=5
            if (filterType.matches("[1-5]")) {
                filterValue = Integer.parseInt(filterType);
                filterType = "rating";
            }

            List<Review> reviews = reviewService.getReviewsFiltered(productId, filterType, filterValue, page, PAGE_SIZE);
            int total = reviewService.countReviewsFiltered(productId, filterType, filterValue);
            boolean hasMore = (long) page * PAGE_SIZE < total;

            JsonObject result = new JsonObject();
            result.addProperty("page", page);
            result.addProperty("total", total);
            result.addProperty("hasMore", hasMore);
            result.add("reviews", buildReviewsJson(reviews));

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Internal server error\"}");
            e.printStackTrace();
        }
    }

    private JsonArray buildReviewsJson(List<Review> reviews) {
        JsonArray arr = new JsonArray();
        for (Review r : reviews) {
            JsonObject obj = new JsonObject();
            obj.addProperty("id", r.getId());
            obj.addProperty("rating", r.getRating());
            obj.addProperty("reviewText", r.getReviewText() != null ? r.getReviewText() : "");
            obj.addProperty("formattedDate", r.getFormattedDate());
            obj.addProperty("verifiedPurchase", r.isVerifiedPurchase());
            obj.addProperty("variantDisplayText", r.getVariantDisplayText());
            obj.addProperty("hasImages", r.hasImages());
            obj.addProperty("userDisplayName", r.getUserDisplayName());
            obj.addProperty("userInitial", r.getUserInitial());

            JsonArray images = new JsonArray();
            Set<String> addedUrls = new HashSet<>();
            if (r.getImages() != null) {
                for (ReviewImage img : r.getImages()) {
                    if (img.getImageUrl() != null && addedUrls.add(img.getImageUrl())) {
                        JsonObject imgObj = new JsonObject();
                        imgObj.addProperty("imageUrl", img.getImageUrl());
                        images.add(imgObj);
                    }
                }
            }
            if (r.getImageUrl() != null && !r.getImageUrl().isEmpty()
                    && addedUrls.add(r.getImageUrl())) {
                JsonObject imgObj = new JsonObject();
                imgObj.addProperty("imageUrl", r.getImageUrl());
                images.add(imgObj);
            }
            obj.add("images", images);

            arr.add(obj);
        }
        return arr;
    }

    private int parseIntParam(HttpServletRequest request, String name, int defaultValue) {
        String val = request.getParameter(name);
        if (val == null || val.trim().isEmpty()) return defaultValue;
        try { return Integer.parseInt(val.trim()); } catch (NumberFormatException e) { return defaultValue; }
    }

    private Integer parseIntParamNullable(HttpServletRequest request, String name) {
        String val = request.getParameter(name);
        if (val == null || val.trim().isEmpty()) return null;
        try { return Integer.parseInt(val.trim()); } catch (NumberFormatException e) { return null; }
    }
}
