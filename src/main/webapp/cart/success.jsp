<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Result - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .result-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--space-lg);
        }

        .result-card {
            max-width: 500px;
            width: 100%;
            text-align: center;
            animation: fadeInScale var(--duration-500) var(--ease-out);
        }

        .result-icon {
            font-size: 4rem;
            margin-bottom: var(--space-lg);
            display: block;
        }

        .result-icon--success {
            color: var(--color-success);
        }

        .result-icon--error {
            color: var(--color-danger);
        }

        .result-title {
            font-size: var(--text-2xl);
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-md);
        }

        .result-title--success {
            color: var(--color-success);
        }

        .result-title--error {
            color: var(--color-danger);
        }

        .result-description {
            color: var(--text-secondary);
            margin-bottom: var(--space-lg);
            line-height: 1.6;
        }

        .result-details {
            background: var(--surface-tertiary);
            border: 1px solid var(--border-secondary);
            border-radius: var(--radius-md);
            padding: var(--space-md);
            margin-bottom: var(--space-lg);
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-2);
            font-size: var(--text-sm);
        }

        .detail-row:last-child {
            margin-bottom: 0;
        }

        .detail-label {
            color: var(--text-secondary);
        }

        .detail-value {
            font-weight: var(--font-weight-medium);
            color: var(--text-primary);
        }

        .vnpay-badge {
            display: inline-block;
            background: linear-gradient(135deg, #005baa 0%, #004080 100%);
            color: var(--text-inverse);
            font-weight: var(--font-weight-bold);
            font-size: var(--text-xs);
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .warning-text {
            color: var(--color-danger);
            font-weight: var(--font-weight-medium);
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: var(--space-md);
            justify-content: center;
            margin-top: var(--space-xl);
        }

        .action-buttons .btn {
            flex: 1;
            min-width: 160px;
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95) translateY(20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
            }
        }
    </style>
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