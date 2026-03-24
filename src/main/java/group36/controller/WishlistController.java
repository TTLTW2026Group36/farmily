package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import group36.model.Product;
import group36.model.User;
import group36.model.Wishlist;
import group36.service.WishlistService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "WishlistController", urlPatterns = { "/api/wishlist", "/api/wishlist/*" })
public class WishlistController extends HttpServlet {

    private WishlistService wishlistService;

    @Override
    public void init() throws ServletException {
        wishlistService = new WishlistService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            out.print("{\"success\":true,\"count\":0,\"items\":[]}");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("count".equals(action)) {

                int count = wishlistService.getWishlistCount(user.getId());
                session.setAttribute("wishlistCount", count);
                out.print("{\"success\":true,\"count\":" + count + "}");

            } else if ("check".equals(action)) {

                int productId = parseIntParam(request, "productId", 0);
                if (productId <= 0) {
                    out.print("{\"success\":false,\"message\":\"ID sản phẩm không hợp lệ\"}");
                    return;
                }
                boolean inWishlist = wishlistService.isInWishlist(user.getId(), productId);
                out.print("{\"success\":true,\"inWishlist\":" + inWishlist + "}");

            } else {

                List<Wishlist> wishlistItems = wishlistService.getWishlistByUserId(user.getId());
                out.print(buildWishlistJson(wishlistItems));
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(
                    "{\"success\":false,\"message\":\"Vui lòng đăng nhập để thêm vào yêu thích\",\"requireLogin\":true}");
            return;
        }

        try {
            int productId = parseIntParam(request, "productId", 0);
            String action = request.getParameter("action");

            if (productId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"ID sản phẩm không hợp lệ\"}");
                return;
            }

            if ("add".equals(action)) {
                boolean alreadyExists = wishlistService.isInWishlist(user.getId(), productId);
                if (!alreadyExists) {
                    wishlistService.addToWishlist(user.getId(), productId);
                }
                int wishlistCount = wishlistService.getWishlistCount(user.getId());
                session.setAttribute("wishlistCount", wishlistCount);
                String message = alreadyExists ? "Sản phẩm đã có trong yêu thích" : "Đã thêm vào yêu thích";
                out.print("{\"success\":true,\"message\":\"" + message + "\"," +
                        "\"added\":true," +
                        "\"alreadyExists\":" + alreadyExists + "," +
                        "\"wishlistCount\":" + wishlistCount + "}");
            } else {
                boolean added = wishlistService.toggleWishlist(user.getId(), productId);

                int wishlistCount = wishlistService.getWishlistCount(user.getId());
                session.setAttribute("wishlistCount", wishlistCount);

                String message = added ? "Đã thêm vào yêu thích" : "Đã xóa khỏi yêu thích";
                out.print("{\"success\":true,\"message\":\"" + message + "\"," +
                        "\"added\":" + added + "," +
                        "\"wishlistCount\":" + wishlistCount + "}");
            }

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            int productId = parseIntParam(request, "productId", 0);

            if (productId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"ID sản phẩm không hợp lệ\"}");
                return;
            }

            wishlistService.removeFromWishlist(user.getId(), productId);

            int wishlistCount = wishlistService.getWishlistCount(user.getId());
            session.setAttribute("wishlistCount", wishlistCount);

            out.print(
                    "{\"success\":true,\"message\":\"Đã xóa khỏi yêu thích\",\"wishlistCount\":" + wishlistCount + "}");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra\"}");
        }
    }

    private int parseIntParam(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String buildWishlistJson(List<Wishlist> items) {
        StringBuilder sb = new StringBuilder();
        sb.append("{\"success\":true,\"count\":").append(items.size()).append(",\"items\":[");

        for (int i = 0; i < items.size(); i++) {
            if (i > 0)
                sb.append(",");
            Wishlist item = items.get(i);
            Product product = item.getProduct();

            sb.append("{");
            sb.append("\"id\":").append(item.getId()).append(",");
            sb.append("\"productId\":").append(item.getProductId()).append(",");
            sb.append("\"createdAt\":\"").append(item.getCreatedAt()).append("\"");

            if (product != null) {
                sb.append(",\"product\":{");
                sb.append("\"id\":").append(product.getId()).append(",");
                sb.append("\"name\":\"").append(escapeJson(product.getName())).append("\",");
                sb.append("\"avgRating\":").append(product.getAvgRating()).append(",");
                sb.append("\"soldCount\":").append(product.getSoldCount()).append(",");

                if (product.getVariants() != null && !product.getVariants().isEmpty()) {
                    double price = product.getVariants().get(0).getPrice();
                    sb.append("\"price\":").append(price).append(",");
                } else {
                    sb.append("\"price\":0,");
                }
                if (product.getImages() != null && !product.getImages().isEmpty()) {
                    sb.append("\"imageUrl\":\"").append(escapeJson(product.getImages().get(0).getImageUrl()))
                            .append("\"");
                } else {
                    sb.append("\"imageUrl\":\"\"");
                }
                sb.append("}");
            }
            sb.append("}");
        }
        sb.append("]}");
        return sb.toString();
    }
}
