package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Category;
import models.Product;
import services.CategoryService;
import services.ProductService;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = { "/category" })
public class CategoryProductsServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private static final int PAGE_SIZE = 24;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int categoryId = Integer.parseInt(idStr);
            Category currentCategory = categoryService.findById(categoryId);
            if (currentCategory == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            int pageNumber = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    pageNumber = Integer.parseInt(pageParam);
                    if (pageNumber < 1) pageNumber = 1;
                } catch (NumberFormatException e) {
                    pageNumber = 1;
                }
            }

            long totalCount = productService.countByCategoryId(categoryId);
            long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
            if (pageNumber > totalPages && totalPages > 0) {
                pageNumber = (int) totalPages;
            }

            List<Product> products = productService.findPageByCategoryId(categoryId, pageNumber, PAGE_SIZE);
            
            request.setAttribute("currentCategory", currentCategory);
            request.setAttribute("products", products);
            request.setAttribute("pageNumber", pageNumber);
            request.setAttribute("pageSize", PAGE_SIZE);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("categories", categoryService.findAll());
            
            request.getRequestDispatcher("/products/category.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
