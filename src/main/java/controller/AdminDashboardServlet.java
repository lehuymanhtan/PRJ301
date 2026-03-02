package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import services.ProductService;
import services.SupplierService;
import services.UserService;
import java.io.IOException;

/**
 * Admin dashboard at /admin/dashboard.
 * Loads summary counts and forwards to the dashboard view.
 */
@WebServlet(urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final UserService userService         = new UserService();
    private final ProductService productService   = new ProductService();
    private final SupplierService supplierService = new SupplierService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalUsers",     userService.getAllUsers().size());
        request.setAttribute("totalProducts",  productService.findAll().size());
        request.setAttribute("totalSuppliers", supplierService.findAll().size());

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
