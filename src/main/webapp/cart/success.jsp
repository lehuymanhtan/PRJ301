<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Result - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">
<%
    Boolean vnpaySuccess = (Boolean) request.getAttribute("vnpaySuccess");
    boolean isVnpay      = (vnpaySuccess != null);

    Integer codOrderId  = (Integer) session.getAttribute("lastOrderId");
    String  codPayment  = (String)  session.getAttribute("lastPaymentMethod");
    if (!isVnpay) {
        session.removeAttribute("lastOrderId");
        session.removeAttribute("lastPaymentMethod");
    }
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">

<% if (isVnpay) {
    String  orderId      = (String) request.getAttribute("vnpayOrderId");
    String  transNo      = (String) request.getAttribute("vnpayTransactionNo");
    String  bankCode     = (String) request.getAttribute("vnpayBankCode");
    String  amountRaw    = (String) request.getAttribute("vnpayAmount");
    String  responseCode = (String) request.getAttribute("vnpayResponseCode");
    boolean validSig     = Boolean.TRUE.equals(request.getAttribute("vnpayValidSig"));
    long displayAmount = 0;
    try { if (amountRaw != null) displayAmount = Long.parseLong(amountRaw) / 100L; } catch (Exception ignored) {}

    if (vnpaySuccess) { %>
            <!-- VNPay Success -->
            <div class="card shadow-sm text-center border-success">
                <div class="card-body py-5">
                    <i class="bi bi-check-circle-fill success-icon"></i>
                    <h2 class="mt-3 fw-bold text-success">Payment Successful!</h2>
                    <p class="text-muted">
                        Your order <strong>#<%= orderId %></strong> has been paid via
                        <span class="vnpay-badge">VNPAY</span>.
                    </p>
                    <table class="table table-sm mx-auto mt-3" style="max-width:320px">
                        <tbody>
                            <tr><th class="text-start">Transaction No:</th><td><%= transNo != null ? transNo : "–" %></td></tr>
                            <tr><th class="text-start">Bank:</th><td><%= bankCode != null ? bankCode : "–" %></td></tr>
                            <tr><th class="text-start">Amount Paid:</th><td><%= String.format("%,d VND", displayAmount) %></td></tr>
                        </tbody>
                    </table>
                    <p class="text-muted small">We will process your order shortly. Thank you for shopping!</p>
                    <div class="d-flex gap-2 justify-content-center mt-3">
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-rt-primary">
                            <i class="bi bi-list-check me-2"></i>My Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                            <i class="bi bi-bag me-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>
            </div>

    <% } else { %>
            <!-- VNPay Failure -->
            <div class="card shadow-sm text-center border-danger">
                <div class="card-body py-5">
                    <i class="bi bi-x-circle-fill" style="font-size:4rem; color:#dc2626"></i>
                    <h2 class="mt-3 fw-bold text-danger">Payment Failed</h2>
                    <p class="text-muted">Your payment via <span class="vnpay-badge">VNPAY</span> could not be completed.</p>
                    <% if (responseCode != null && !responseCode.isEmpty()) { %>
                        <p class="text-muted small">Error Code: <strong><%= responseCode %></strong></p>
                    <% } %>
                    <% if (!validSig) { %>
                        <div class="alert alert-warning small">Invalid signature detected.</div>
                    <% } %>
                    <p class="text-muted small">Order <strong>#<%= orderId %></strong> was cancelled. No money was deducted.</p>
                    <div class="d-flex gap-2 justify-content-center mt-3">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-danger">
                            <i class="bi bi-cart3 me-2"></i>Back to Cart
                        </a>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                            <i class="bi bi-bag me-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
    <% } } else { %>
            <!-- COD Success -->
            <div class="card shadow-sm text-center border-success">
                <div class="card-body py-5">
                    <i class="bi bi-bag-check-fill success-icon"></i>
                    <h2 class="mt-3 fw-bold text-success">Order Placed Successfully!</h2>
                    <% if (codOrderId != null) { %>
                        <p class="text-muted">Your order <strong>#<%= codOrderId %></strong> has been received.</p>
                    <% } else { %>
                        <p class="text-muted">Your order has been received.</p>
                    <% } %>
                    <% if (codPayment != null) { %>
                        <p class="text-muted small">Payment Method: <strong><%= codPayment %></strong></p>
                    <% } %>
                    <p class="text-muted small">We will process it shortly. Thank you for shopping!</p>
                    <div class="d-flex gap-2 justify-content-center mt-3">
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-rt-primary">
                            <i class="bi bi-list-check me-2"></i>My Orders
                        </a>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                            <i class="bi bi-bag me-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
    <% } %>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
