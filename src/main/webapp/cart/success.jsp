<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>${i18n.get('order.title')}</title>
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
        <%
            // VNPay return: request attributes set by VNPayReturnServlet (forward)
            Boolean vnpaySuccess = (Boolean) request.getAttribute("vnpaySuccess");
            boolean isVnpay = (vnpaySuccess != null);
            // COD flow: session attributes set by CheckoutServlet (redirect)
            Integer codOrderId = (Integer) session.getAttribute("lastOrderId");
            String codPayment = (String) session.getAttribute("lastPaymentMethod");
            if (!isVnpay) {
                session.removeAttribute("lastOrderId");
                session.removeAttribute("lastPaymentMethod");
            }
            if (isVnpay) {
                // VNPay result branch
                String orderId = (String) request.getAttribute("vnpayOrderId");
                String transNo = (String) request.getAttribute("vnpayTransactionNo");
                String bankCode = (String) request.getAttribute("vnpayBankCode");
                String amountRaw = (String) request.getAttribute("vnpayAmount");
                String responseCode = (String) request.getAttribute("vnpayResponseCode");
                boolean validSig = Boolean.TRUE.equals(request.getAttribute("vnpayValidSig"));
                long displayAmount = 0;
                try {
                    if (amountRaw != null) displayAmount = Long.parseLong(amountRaw) / 100L;
                } catch (Exception ignored) {}
                if (vnpaySuccess) { %>
            <div class="box">
                <div class="tick">&#10004;</div>
                <h1 class="ok">${i18n.get('success.paymentSuccess')}</h1>
                <p>${i18n.get('success.paidVia')} <strong>#<%= orderId %></strong> <span
                        class="vnpay-badge">VNPAY</span>.</p>
                <p class="detail-row">${i18n.get('success.transNo')}: <strong>
                        <%= transNo !=null ? transNo : "–" %>
                    </strong></p>
                <p class="detail-row">${i18n.get('success.bank')}: <strong>
                        <%= bankCode !=null ? bankCode : "–" %>
                    </strong></p>
                <p class="detail-row">${i18n.get('success.amountPaid')}: <strong>
                        <%= String.format("%,d", displayAmount) %> VND
                    </strong></p>
                <br>
                <p>${i18n.get('success.processShortly')}</p>
                <a href="${pageContext.request.contextPath}/orders" class="btn">${i18n.get('nav.myOrders')}</a>
                <a href="${pageContext.request.contextPath}/products"
                    class="btn">${i18n.get('nav.continueShopping')}</a>
            </div>
            <% } else { %>
                <div class="box">
                    <div class="cross">&#10008;</div>
                    <h1 class="err">${i18n.get('success.paymentFailed')}</h1>
                    <p>${i18n.get('success.paymentFailed2')} <span class="vnpay-badge">VNPAY</span>.</p>
                    <% if (responseCode !=null && !responseCode.isEmpty()) { %>
                        <p class="detail-row">${i18n.get('success.errorCode')}: <strong>
                                <%= responseCode %>
                            </strong></p>
                        <% } %>
                            <% if (!validSig) { %>
                                <p class="detail-row" style="color:#c62828;">${i18n.get('success.invalidSig')}</p>
                                <% } %>
                                    <br>
                                    <p>${i18n.get('success.noMoneyDeducted')}</p>
                                    <a href="${pageContext.request.contextPath}/cart"
                                        class="btn btn-red">${i18n.get('checkout.backToCart')}</a>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="btn">${i18n.get('nav.continueShopping')}</a>
                </div>
                <% } } else { // ── COD result branch ────────────────────────────────────────────── %>
                    <div class="box">
                        <div class="tick">&#10004;</div>
                        <h1 class="ok">${i18n.get('success.orderPlaced')}</h1>
                        <% if (codOrderId !=null) { %>
                            <p>${i18n.get('success.paidVia')} <strong>#<%= codOrderId %></strong>.</p>
                            <% } else { %>
                                <p>${i18n.get('success.orderReceived')}</p>
                                <% } %>
                                    <% if (codPayment !=null) { %>
                                        <p>${i18n.get('checkout.paymentMethod')}: <strong>
                                                <%= codPayment %>
                                            </strong></p>
                                        <% } %>
                                            <p>${i18n.get('success.processShortly')}</p>
                                            <a href="${pageContext.request.contextPath}/orders"
                                                class="btn">${i18n.get('nav.myOrders')}</a>
                                            <a href="${pageContext.request.contextPath}/products"
                                                class="btn">${i18n.get('nav.continueShopping')}</a>
                    </div>
                    <% } %>

    </body>

    </html>