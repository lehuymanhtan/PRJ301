package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.OrderDetail;
import models.RefundRequest;
import models.User;
import services.OrderService;
import services.OrderServiceImpl;
import services.RefundService;
import services.RefundServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * User's own order history at /orders.
 *
 * GET  (default)          → list the logged-in user's orders
 * GET  action=detail&id=N → view one order's details (user must own it)
 */
@WebServlet(urlPatterns = {"/orders"})
public class UserOrderServlet extends HttpServlet {

    private final OrderService  orderService  = new OrderServiceImpl();
    private final RefundService refundService = new RefundServiceImpl();
    private static final int PAGE_SIZE = 25;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            viewDetail(request, response, user);
        } else {
            listOrders(request, response, user);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
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

        long totalCount = orderService.countOrdersByUserId(user.getUserId());
        long totalPages = (totalCount + PAGE_SIZE - 1) / PAGE_SIZE;
        if (pageNumber > totalPages && totalPages > 0) pageNumber = (int) totalPages;

        List<Order> orders = orderService.getOrdersPageByUserId(user.getUserId(), pageNumber, PAGE_SIZE);

        request.setAttribute("orders", orders);
        request.setAttribute("pageNumber", pageNumber);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/orders/list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        Integer id = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(id);

        // Ensure the order belongs to this user
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            request.getSession().setAttribute("cartMessage", "Order not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        List<OrderDetail> details = orderService.getOrderDetails(id);
        RefundRequest refund = refundService.findByOrderId(id);
        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.setAttribute("refund", refund);
        request.getRequestDispatcher("/orders/detail.jsp").forward(request, response);
    }
}
