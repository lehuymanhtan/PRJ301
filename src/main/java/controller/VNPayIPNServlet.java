package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Order;
import services.OrderService;
import services.OrderServiceImpl;
import util.VNPayUtil;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * VNPay IPN (Instant Payment Notification) handler  –  /vnpay-ipn
 *
 * This is a server-to-server callback called by VNPay's servers directly.
 * It must:
 *   1. Verify the checksum (reject tampered requests).
 *   2. Look up the order in the database.
 *   3. Compare the paid amount with the expected amount.
 *   4. Update the order status only if it is still in "Pending" state.
 *   5. Reply with a JSON object { "RspCode": "xx", "Message": "..." }.
 *
 * VNPay retries this URL up to 10 times (5-minute intervals) for
 * RspCode 01, 04, 97, 99 or timeout.  Codes 00 and 02 stop retries.
 *
 * Register this URL in the VNPay merchant portal after deployment.
 */
@WebServlet(urlPatterns = {"/vnpay-ipn"})
public class VNPayIPNServlet extends HttpServlet {

    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String rspCode;
        String message;

        try {
            // ── 1. Verify checksum ─────────────────────────────────────────
            if (!VNPayUtil.verifyChecksum(request.getParameterMap())) {
                out.print("{\"RspCode\":\"97\",\"Message\":\"Invalid signature\"}");
                return;
            }

            // ── 2. Parse params ────────────────────────────────────────────
            String txnRef        = request.getParameter("vnp_TxnRef");
            String amountStr     = request.getParameter("vnp_Amount");   // already *100
            String responseCode  = request.getParameter("vnp_ResponseCode");
            String transStatus   = request.getParameter("vnp_TransactionStatus");

            if (txnRef == null || amountStr == null) {
                out.print("{\"RspCode\":\"99\",\"Message\":\"Missing parameters\"}");
                return;
            }

            int  orderId   = Integer.parseInt(txnRef);
            long paidAmount = Long.parseLong(amountStr) / 100L;  // strip the *100 factor

            // ── 3. Look up the order ───────────────────────────────────────
            Order order = orderService.getOrderById(orderId);
            if (order == null) {
                out.print("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
                return;
            }

            // ── 4. Compare amounts ─────────────────────────────────────────
            long expectedAmount = (long) order.getTotalPrice();
            if (expectedAmount != paidAmount) {
                out.print("{\"RspCode\":\"04\",\"Message\":\"Invalid amount\"}");
                return;
            }

            // ── 5. Guard against duplicate IPN calls ───────────────────────
            if (!"Pending".equals(order.getStatus())) {
                // Already processed (02 tells VNPay to stop retrying)
                out.print("{\"RspCode\":\"02\",\"Message\":\"Order already confirmed\"}");
                return;
            }

            // ── 6. Update order status ─────────────────────────────────────
            boolean paid = "00".equals(responseCode) || "00".equals(transStatus);
            order.setStatus(paid ? "Processing" : "Cancelled");
            orderService.updateOrder(order);

            rspCode = "00";
            message = "Confirm Success";

        } catch (NumberFormatException e) {
            rspCode = "99";
            message = "Invalid number format";
        } catch (Exception e) {
            getServletContext().log("VNPay IPN error", e);
            rspCode = "99";
            message = "Unknown error";
        }

        out.print("{\"RspCode\":\"" + rspCode + "\",\"Message\":\"" + message + "\"}");
    }
}
