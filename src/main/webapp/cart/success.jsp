<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Orders</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                text-align: center;
            }

            .box {
                display: inline-block;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 40px 60px;
                margin-top: 60px;
            }

            .tick {
                font-size: 60px;
                color: #2e7d32;
            }

            .cross {
                font-size: 60px;
                color: #c62828;
            }

            h1.ok {
                color: #2e7d32;
            }

            h1.err {
                color: #c62828;
            }

            p {
                color: #555;
                margin-bottom: 10px;
            }

            .detail-row {
                font-size: 13px;
                color: #666;
                margin: 3px 0;
            }

            .btn {
                display: inline-block;
                padding: 8px 20px;
                background: #1565c0;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                margin: 4px;
            }

            .btn-red {
                background: #c62828;
            }

            .vnpay-badge {
                background: #005baa;
                color: #fff;
                font-weight: bold;
                font-size: 11px;
                padding: 1px 6px;
                border-radius: 3px;
            }
        </style>
    </head>

    <body>
        <% // â”€â”€ Detect which flow landed here
            â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            // VNPay return: request attributes set by VNPayReturnServlet (forward) Boolean vnpaySuccess=(Boolean)
            request.getAttribute("vnpaySuccess"); boolean isVnpay=(vnpaySuccess !=null); // COD flow: session attributes
            set by CheckoutServlet (redirect) Integer codOrderId=(Integer) session.getAttribute("lastOrderId"); String
            codPayment=(String) session.getAttribute("lastPaymentMethod"); if (!isVnpay) {
            session.removeAttribute("lastOrderId"); session.removeAttribute("lastPaymentMethod"); } if (isVnpay) { //
            â”€â”€ VNPay result branch
            â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            String orderId=(String) request.getAttribute("vnpayOrderId"); String transNo=(String)
            request.getAttribute("vnpayTransactionNo"); String bankCode=(String) request.getAttribute("vnpayBankCode");
            String amountRaw=(String) request.getAttribute("vnpayAmount"); String responseCode=(String)
            request.getAttribute("vnpayResponseCode"); boolean
            validSig=Boolean.TRUE.equals(request.getAttribute("vnpayValidSig")); long displayAmount=0; try { if
            (amountRaw !=null) displayAmount=Long.parseLong(amountRaw) / 100L; } catch (Exception ignored) {} if
            (vnpaySuccess) { %>
            <div class="box">
                <div class="tick">&#10004;</div>
                <h1 class="ok">Payment Successful!</h1>
                <p>Your order has been paid via <strong>#<%= orderId %></strong> <span class="vnpay-badge">VNPAY</span>.
                </p>
                <p class="detail-row">Transaction No: <strong>
                        <%= transNo !=null ? transNo : "-" %>
                    </strong></p>
                <p class="detail-row">Bank: <strong>
                        <%= bankCode !=null ? bankCode : "-" %>
                    </strong></p>
                <p class="detail-row">Amount paid: <strong>
                        <%= String.format("%,d", displayAmount) %> VND
                    </strong></p>
                <br>
                <p>We will process your order shortly. Thank you for shopping with us!</p>
                <a href="${pageContext.request.contextPath}/orders" class="btn">My Orders</a>
                <a href="${pageContext.request.contextPath}/products" class="btn">Continue Shopping</a>
            </div>
            <% } else { %>
                <div class="box">
                    <div class="cross">&#10008;</div>
                    <h1 class="err">Payment Failed</h1>
                    <p>Your payment could not be completed. <span class="vnpay-badge">VNPAY</span>.</p>
                    <% if (responseCode !=null && !responseCode.isEmpty()) { %>
                        <p class="detail-row">Error code: <strong>
                                <%= responseCode %>
                            </strong></p>
                        <% } %>
                            <% if (!validSig) { %>
                                <p class="detail-row" style="color:#c62828;">Warning: invalid signature detected.</p>
                                <% } %>
                                    <br>
                                    <p>Your order has been cancelled. No money was deducted.</p>
                                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-red">Back to
                                        Cart</a>
                                    <a href="${pageContext.request.contextPath}/products" class="btn">Continue
                                        Shopping</a>
                </div>
                <% } } else { // â”€â”€ COD result branch
                    â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    %>
                    <div class="box">
                        <div class="tick">&#10004;</div>
                        <h1 class="ok">Order Placed Successfully!</h1>
                        <% if (codOrderId !=null) { %>
                            <p>Your order has been paid via <strong>#<%= codOrderId %></strong>.</p>
                            <% } else { %>
                                <p>Your order has been received.</p>
                                <% } %>
                                    <% if (codPayment !=null) { %>
                                        <p>Payment Method: <strong>
                                                <%= codPayment %>
                                            </strong></p>
                                        <% } %>
                                            <p>We will process your order shortly. Thank you for shopping with us!</p>
                                            <a href="${pageContext.request.contextPath}/orders" class="btn">My
                                                Orders</a>
                                            <a href="${pageContext.request.contextPath}/products" class="btn">Continue
                                                Shopping</a>
                    </div>
                    <% } %>

    </body>

    </html>