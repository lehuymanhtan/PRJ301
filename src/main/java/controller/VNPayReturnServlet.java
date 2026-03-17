package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import models.User;
import services.LoyaltyService;
import services.OrderService;
import services.OrderServiceImpl;
import services.UserService;
import util.VNPayUtil;
import java.io.IOException;

/**
 * VNPay Return URL handler  –  /vnpay-return
 *
 * VNPay redirects the customer's browser here after the payment attempt.
 * This endpoint verifies the checksum, shows the result to the user,
 * and (as a fallback) updates the order status if the IPN was not yet
 * processed.
 *
 * NOTE: per VNPay documentation the authoritative status update should
 *       happen in the IPN handler ({@link VNPayIPNServlet}), not here.
 */
@WebServlet(urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {

    private final OrderService   orderService   = new OrderServiceImpl();
    private final LoyaltyService loyaltyService = new LoyaltyService();
    private final UserService    userService    = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Verify checksum ────────────────────────────────────────────
        boolean validSignature = VNPayUtil.verifyChecksum(request.getParameterMap());

        // ── 2. Read response params ───────────────────────────────────────
        String responseCode   = request.getParameter("vnp_ResponseCode");
        String txnRef         = request.getParameter("vnp_TxnRef");           // our orderId
        String transactionNo  = request.getParameter("vnp_TransactionNo");    // VNPay txn id
        String bankCode       = request.getParameter("vnp_BankCode");
        String amountStr      = request.getParameter("vnp_Amount");
        String payDate        = request.getParameter("vnp_PayDate");

        boolean success = validSignature && "00".equals(responseCode);

        // ── 3. Update order status (fallback – IPN is the authoritative path)
        if (txnRef != null) {
            try {
                int orderId = Integer.parseInt(txnRef);
                Order order = orderService.getOrderById(orderId);
                if (order != null && "Pending".equals(order.getStatus())) {
                    order.setStatus(success ? "Processing" : "Cancelled");
                    orderService.updateOrder(order);

                    // ── 3a. Apply loyalty points for successful payment ──────
                    if (success && order.getUserId() != null) {
                        HttpSession session = request.getSession(false);
                        int usedPoints = (session != null && session.getAttribute("usedPoints") != null)
                                ? (Integer) session.getAttribute("usedPoints") : 0;

                        if (usedPoints > 0) {
                            loyaltyService.usePoints(order.getUserId(), orderId, usedPoints);
                        }
                        loyaltyService.addPoints(order.getUserId(), orderId, order.getTotalPrice());

                        // Refresh session user with updated points/tier
                        User refreshed = userService.findById(order.getUserId());
                        if (refreshed != null && session != null) {
                            session.setAttribute("user", refreshed);
                        }
                        if (session != null) session.removeAttribute("usedPoints");
                    }
                }
            } catch (NumberFormatException ignored) {}
        }

        // ── 4. Forward to result page ─────────────────────────────────────
        request.setAttribute("vnpaySuccess",       success);
        request.setAttribute("vnpayResponseCode",  responseCode);
        request.setAttribute("vnpayOrderId",       txnRef);
        request.setAttribute("vnpayTransactionNo", transactionNo);
        request.setAttribute("vnpayBankCode",      bankCode);
        request.setAttribute("vnpayAmount",        amountStr);
        request.setAttribute("vnpayPayDate",       payDate);
        request.setAttribute("vnpayValidSig",      validSignature);

        request.getRequestDispatcher("/cart/success.jsp").forward(request, response);
    }
}
