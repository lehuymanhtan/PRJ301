package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.OrderDetail;
import models.RefundRequest;
import services.OrderService;
import services.OrderServiceImpl;
import services.RefundService;
import services.RefundServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * Admin order management at /admin/orders.
 *
 * GET  action=list   (default) → list all orders
 * GET  action=detail&id=N      → view order details
 * GET  action=edit&id=N        → show edit-status form
 * POST action=update           → update order status
 * POST action=delete           → soft-delete order
 */
@WebServlet(urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {

    private final OrderService  orderService  = new OrderServiceImpl();
    private final RefundService refundService = new RefundServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                viewDetail(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "update":
                updateStatus(request, response);
                break;
            case "delete":
                deleteOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderService.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders/list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(id);
        List<OrderDetail> details = orderService.getOrderDetails(id);
        RefundRequest refund = refundService.findByOrderId(id);
        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("refund", refund);
        request.getRequestDispatcher("/admin/orders/detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(id);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/admin/orders/form.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id   = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        Order order = orderService.getOrderById(id);
        if (order != null) {
            order.setStatus(status);
            orderService.updateOrder(order);
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = Integer.parseInt(request.getParameter("id"));
        orderService.deleteOrder(id);
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
