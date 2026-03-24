package group36.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.model.Order;
import group36.model.Product;
import group36.service.OrderService;
import group36.service.ProductService;
import group36.service.UserService;

import java.io.IOException;
import java.util.List;





@WebServlet(urlPatterns = { "/admin/dashboard", "/admin/", "/admin" })
public class AdminDashboardController extends HttpServlet {

    private final OrderService orderService;
    private final ProductService productService;
    private final UserService userService;

    public AdminDashboardController() {
        this.orderService = new OrderService();
        this.productService = new ProductService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        double totalRevenue = orderService.getTotalRevenue();
        double revenueThisMonth = orderService.getRevenueThisMonth();
        double revenueChangePercent = orderService.getRevenueChangePercent();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("revenueThisMonth", revenueThisMonth);
        request.setAttribute("revenueChangePercent", revenueChangePercent);

        
        int totalOrders = orderService.countOrders();
        int ordersThisMonth = orderService.getOrdersThisMonth();
        double ordersChangePercent = orderService.getOrdersChangePercent();

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("ordersThisMonth", ordersThisMonth);
        request.setAttribute("ordersChangePercent", ordersChangePercent);

        
        int totalProducts = productService.getTotalProducts();
        
        List<Product> newestProducts = productService.getNewestProducts(15);
        int newProductsCount = newestProducts.size();

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("newProductsCount", newProductsCount);

        
        int totalCustomers = userService.getTotalCustomers();
        request.setAttribute("totalCustomers", totalCustomers);

        
        List<Order> recentOrders = orderService.getRecentOrders(5);
        request.setAttribute("recentOrders", recentOrders);

        
        List<Product> bestSellingProducts = productService.getBestSellingProducts(5);
        request.setAttribute("bestSellingProducts", bestSellingProducts);

        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
