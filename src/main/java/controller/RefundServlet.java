package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.RefundRequest;
import models.User;
import services.OrderService;
import services.OrderServiceImpl;
import services.RefundService;
import services.RefundServiceImpl;
import java.io.IOException;

/**
 * User-facing refund controller at /refund.
 *
 * GET  action=create&orderId=N  → show create-refund form
 * POST action=create            → submit new refund request
 * GET  action=detail&id=N       → view refund details
 * POST action=cancel            → cancel a Pending refund
 */
@WebServlet(urlPatterns = {"/refund"})
public class RefundServlet extends HttpServlet {

    private final OrderService  orderService  = new OrderServiceImpl();
    private final RefundService refundService = new RefundServiceImpl();

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
        if (action == null) action = "";

        switch (action) {
            case "create":
                showCreateForm(request, response, user);
                break;
            case "detail":
                viewDetail(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":
                createRefund(request, response, user);
                break;
            case "cancel":
                cancelRefund(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    // ── Handlers ───────────────────────────────────────────────────────────

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Integer orderId = Integer.parseInt(orderIdParam);
        Order order = orderService.getOrderById(orderId);

        if (order == null || !order.getUserId().equals(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        if (!"Delivered".equals(order.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + orderId);
            return;
        }
        if (refundService.findByOrderId(orderId) != null) {
            // Refund already exists — go to existing refund
            RefundRequest existing = refundService.findByOrderId(orderId);
            response.sendRedirect(request.getContextPath() + "/refund?action=detail&id=" + existing.getId());
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/orders/refund-create.jsp").forward(request, response);
    }

    private void createRefund(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String orderIdParam  = request.getParameter("orderId");
        String reason        = request.getParameter("reason");
        String description   = request.getParameter("description");

        if (orderIdParam == null || reason == null || reason.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Integer orderId = Integer.parseInt(orderIdParam);
        Order order = orderService.getOrderById(orderId);

        if (order == null || !order.getUserId().equals(user.getUserId())
                || !"Delivered".equals(order.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        if (refundService.findByOrderId(orderId) != null) {
            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + orderId);
            return;
        }

        RefundRequest refund = new RefundRequest(orderId, user.getUserId(), reason,
                description != null ? description.trim() : null);
        Integer newId = refundService.createRefund(refund);

        response.sendRedirect(request.getContextPath() + "/refund?action=detail&id=" + newId);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Integer id = Integer.parseInt(idParam);
        RefundRequest refund = refundService.findById(id);

        if (refund == null || !refund.getUserId().equals(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Order order = orderService.getOrderById(refund.getOrderId());
        request.setAttribute("refund", refund);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/orders/refund-detail.jsp").forward(request, response);
    }

    private void cancelRefund(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Integer id = Integer.parseInt(idParam);
        RefundRequest refund = refundService.findById(id);

        if (refund == null || !refund.getUserId().equals(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        if (!"Pending".equals(refund.getStatus())) {
            // Only Pending refunds can be cancelled by the user
            response.sendRedirect(request.getContextPath() + "/refund?action=detail&id=" + id);
            return;
        }

        refund.setStatus("Cancelled");
        refundService.updateRefund(refund);
        response.sendRedirect(request.getContextPath() + "/refund?action=detail&id=" + id);
    }
}
