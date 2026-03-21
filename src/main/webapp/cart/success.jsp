<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Result - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-gradient-auth">
<%
    // ── Detect which flow landed here ──────────────────────────────────────
    // VNPay return: request attributes set by VNPayReturnServlet (forward)
    Boolean vnpaySuccess = (Boolean) request.getAttribute("vnpaySuccess");
    boolean isVnpay      = (vnpaySuccess != null);

    // COD flow: session attributes set by CheckoutServlet (redirect)
    Integer codOrderId  = (Integer) session.getAttribute("lastOrderId");
    String  codPayment  = (String)  session.getAttribute("lastPaymentMethod");
    if (!isVnpay) {
        session.removeAttribute("lastOrderId");
        session.removeAttribute("lastPaymentMethod");
    }

    if (isVnpay) {
        // ── VNPay result branch ────────────────────────────────────────────
        String  orderId       = (String) request.getAttribute("vnpayOrderId");
        String  transNo       = (String) request.getAttribute("vnpayTransactionNo");
        String  bankCode      = (String) request.getAttribute("vnpayBankCode");
        String  amountRaw     = (String) request.getAttribute("vnpayAmount");
        String  responseCode  = (String) request.getAttribute("vnpayResponseCode");
        boolean validSig      = Boolean.TRUE.equals(request.getAttribute("vnpayValidSig"));

        long displayAmount = 0;
        try { if (amountRaw != null) displayAmount = Long.parseLong(amountRaw) / 100L; } catch (Exception ignored) {}

        if (vnpaySuccess) {
%>
    <!-- VNPay Success -->
    <div class="result-container">
        <div class="glass-card result-card">
            <span class="result-icon result-icon--success">✅</span>
            <h1 class="result-title result-title--success">Payment Successful!</h1>
            <p class="result-description">
                Your order <strong>#<%= orderId %></strong> has been paid via <span class="vnpay-badge">VNPay</span>.
            </p>

            <div class="result-details">
                <div class="detail-row">
                    <span class="detail-label">Transaction No:</span>
                    <span class="detail-value"><%= transNo != null ? transNo : "–" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Bank:</span>
                    <span class="detail-value"><%= bankCode != null ? bankCode : "–" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Amount Paid:</span>
                    <span class="detail-value"><%= String.format("%,d VND", displayAmount) %></span>
                </div>
            </div>

            <p class="result-description">
                We will process your order shortly. Thank you for shopping with us!
            </p>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn--glass-primary">
                    📋 My Orders
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn btn--glass-secondary">
                    🛒 Continue Shopping
                </a>
            </div>
        </div>
    </div>
<%  } else { %>
    <!-- VNPay Failure -->
    <div class="result-container">
        <div class="glass-card result-card">
            <span class="result-icon result-icon--error">❌</span>
            <h1 class="result-title result-title--error">Payment Failed</h1>
            <p class="result-description">
                Your payment via <span class="vnpay-badge">VNPay</span> could not be completed.
            </p>

            <div class="result-details">
                <% if (responseCode != null && !responseCode.isEmpty()) { %>
                    <div class="detail-row">
                        <span class="detail-label">Error Code:</span>
                        <span class="detail-value"><%= responseCode %></span>
                    </div>
                <% } %>
                <% if (!validSig) { %>
                    <div class="detail-row">
                        <span class="detail-label">Security:</span>
                        <span class="detail-value warning-text">Invalid signature detected</span>
                    </div>
                <% } %>
            </div>

            <p class="result-description">
                Your order <strong>#<%= orderId %></strong> has been cancelled. No money was deducted.
            </p>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/cart" class="btn btn--glass-danger">
                    🛒 Back to Cart
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn btn--glass-secondary">
                    🛍️ Continue Shopping
                </a>
            </div>
        </div>
    </div>
<%  }
    } else {
        // ── COD result branch ──────────────────────────────────────────────
%>
    <!-- COD Success -->
    <div class="result-container">
        <div class="glass-card result-card">
            <span class="result-icon result-icon--success">✅</span>
            <h1 class="result-title result-title--success">Order Placed Successfully!</h1>

            <% if (codOrderId != null) { %>
                <p class="result-description">
                    Your order <strong>#<%= codOrderId %></strong> has been received.
                </p>
            <% } else { %>
                <p class="result-description">
                    Your order has been received.
                </p>
            <% } %>

            <% if (codPayment != null) { %>
                <div class="result-details">
                    <div class="detail-row">
                        <span class="detail-label">Payment Method:</span>
                        <span class="detail-value"><%= codPayment %></span>
                    </div>
                </div>
            <% } %>

            <p class="result-description">
                We will process it shortly. Thank you for shopping with us!
            </p>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn--glass-primary">
                    📋 My Orders
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn btn--glass-secondary">
                    🛒 Continue Shopping
                </a>
            </div>
        </div>
    </div>
<% } %>

<!-- Glassmorphism Interactive Effects -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
