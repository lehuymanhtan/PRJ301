package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Product;
import services.ProductService;
import services.CategoryService;
import java.io.IOException;
import java.util.List;

/**
 * Public product listing at /products.
 * Users can browse products and add them to their cart.
 *
 * GET (default) → list all products with pagination
 */
@WebServlet(urlPatterns = { "/products" })
public class ProductListingServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private static final int PAGE_SIZE = 24;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNumber = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                pageNumber = Integer.parseInt(pageParam);
                if (pageNumber < 1)
                    pageNumber = 1;
            } catch (NumberFormatException e) {
                pageNumber = 1;
            }
        }

        String keyword = request.getParameter("keyword");

        long totalCount;
        long totalPages;
        List<Product> products;

        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();
            totalCount = productService.countByName(keyword);
            totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
            if (pageNumber > totalPages && totalPages > 0) {
                pageNumber = (int) totalPages;
            }
            products = productService.searchByName(keyword, pageNumber, PAGE_SIZE);
            request.setAttribute("keyword", keyword);
        } else {
            totalCount = productService.countAll();
            totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
            if (pageNumber > totalPages && totalPages > 0) {
                pageNumber = (int) totalPages;
            }
            products = productService.findPage(pageNumber, PAGE_SIZE);
        }

        request.setAttribute("products", products);
        request.setAttribute("pageNumber", pageNumber);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories", categoryService.findAll());
        request.getRequestDispatcher("/products/list.jsp").forward(request, response);
    }
}
