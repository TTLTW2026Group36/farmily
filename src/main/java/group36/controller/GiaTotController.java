package group36.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import group36.model.FlashSale;
import group36.service.FlashSaleService;

import java.io.IOException;
import java.util.List;





@WebServlet(name = "GiaTotController", urlPatterns = { "/gia-tot", "/flashsale" })
public class GiaTotController extends HttpServlet {

    private FlashSaleService flashSaleService;

    @Override
    public void init() throws ServletException {
        flashSaleService = new FlashSaleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        List<FlashSale> flashSales = flashSaleService.getActiveFlashSales();
        request.setAttribute("flashSales", flashSales);

        
        java.sql.Timestamp flashSaleEndTime = flashSaleService.getNearestFlashSaleEndTime();
        if (flashSaleEndTime != null) {
            request.setAttribute("flashSaleEndTime", flashSaleEndTime.getTime());
        }

        
        request.getRequestDispatcher("/GiaTot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
