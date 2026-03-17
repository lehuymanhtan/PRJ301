package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.DailyIncome;
import services.ProductService;
import services.SupplierService;
import services.UserService;
import services.OrderService;
import services.OrderServiceImpl;
import services.RefundService;
import services.RefundServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * Admin dashboard at /admin/dashboard.
 * Loads summary counts and last-7-days income chart data, then forwards to the view.
 */
@WebServlet(urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final UserService userService         = new UserService();
    private final ProductService productService   = new ProductService();
    private final SupplierService supplierService = new SupplierService();
    private final OrderService orderService       = new OrderServiceImpl();
    private final RefundService refundService     = new RefundServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalUsers",     userService.getAllUsers().size());
        request.setAttribute("totalProducts",  productService.findAll().size());
        request.setAttribute("totalSuppliers", supplierService.findAll().size());
        request.setAttribute("totalOrders",    orderService.getAllOrders().size());
        request.setAttribute("totalRefunds",   refundService.getAllRefunds().size());

        // Last 7 days income for mini chart (ascending)
        List<DailyIncome> last7 = orderService.getDailyIncomeRange(7);
        request.setAttribute("dashboardChartData", last7);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
