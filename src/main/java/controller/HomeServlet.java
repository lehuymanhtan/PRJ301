package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product;
import models.Category;
import services.ProductService;
import services.CategoryService;
import java.io.IOException;
import java.util.List;

/**
 * Home page servlet at /home.
 * Displays featured products: hot products and new arrivals.
 */
@WebServlet(urlPatterns = { "/home" })
public class HomeServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        List<Category> categories = categoryService.findAll();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
