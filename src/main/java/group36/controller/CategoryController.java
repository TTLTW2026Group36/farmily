package group36.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import group36.model.Category;
import group36.service.CategoryService;

@WebServlet("/api/categories")
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryService categoryService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryService = new CategoryService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Category> categories = categoryService.getAllCategories();
            String json = gson.toJson(categories);

            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
            out.flush();
        }
    }
}
