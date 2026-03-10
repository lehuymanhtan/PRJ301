package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.RefundRequest;
import services.OrderService;
import services.OrderServiceImpl;
import services.RefundService;
import services.RefundServiceImpl;
import java.io.IOException;
import java.util.List;

/**
 * Admin refund management at /admin/refunds.
 *
 * GET  (default)         → list all refund requests
 * GET  action=detail&id=N → view a single refund request
 * POST action=update      → update status (and optionally returnAddress)
 */
@WebServlet(urlPatterns = {"/admin/refunds"})
public class AdminRefundServlet extends HttpServlet {

    private final RefundService refundService = new RefundServiceImpl();
    private final OrderService  orderService  = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                viewDetail(request, response);
                break;
            default:
                listRefunds(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateRefund(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/refunds");
        }
    }

    private void listRefunds(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RefundRequest> refunds = refundService.getAllRefunds();
        request.setAttribute("refunds", refunds);
        request.getRequestDispatcher("/admin/refunds/list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = Integer.parseInt(request.getParameter("id"));
        RefundRequest refund = refundService.findById(id);
        if (refund == null) {
            response.sendRedirect(request.getContextPath() + "/admin/refunds");
            return;
        }
        Order order = orderService.getOrderById(refund.getOrderId());
        request.setAttribute("refund", refund);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/admin/refunds/detail.jsp").forward(request, response);
    }

    private void updateRefund(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id     = Integer.parseInt(request.getParameter("id"));
        String  status = request.getParameter("status");
        String  returnAddress = request.getParameter("returnAddress");

        RefundRequest refund = refundService.findById(id);
        if (refund != null && status != null && !status.isEmpty()) {
            refund.setStatus(status);
            if (returnAddress != null && !returnAddress.trim().isEmpty()) {
                refund.setReturnAddress(returnAddress.trim());
            }
            refundService.updateRefund(refund);

            // When refund is completed, mark the order as Refunded
            if ("Done".equals(status)) {
                Order order = orderService.getOrderById(refund.getOrderId());
                if (order != null) {
                    order.setStatus("Refunded");
                    orderService.updateOrder(order);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/refunds?action=detail&id=" + id);
    }
}
