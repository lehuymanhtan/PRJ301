package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Product;
import services.ProductService;
import java.io.IOException;
import java.util.List;

/**
 * Public product listing at /products.
 * Users can browse products and add them to their cart.
 *
 * GET (default) → list all products
 */
@WebServlet(urlPatterns = {"/products"})
public class ProductListingServlet extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/products/list.jsp").forward(request, response);
    }
}
