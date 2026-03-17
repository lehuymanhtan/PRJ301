<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Cart, models.CartItem, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('checkout.title')}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h1 {
                    margin-bottom: 6px;
                }

                nav {
                    margin-bottom: 20px;
                }

                nav a {
                    margin-right: 10px;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    max-width: 700px;
                    margin-bottom: 20px;
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background: #f0f0f0;
                }

                .total-row td {
                    font-weight: bold;
                }

                .summary {
                    max-width: 400px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    padding: 16px;
                }

                .summary p {
                    margin: 6px 0;
                }

                .payment-option {
                    margin-bottom: 10px;
                }

                .payment-option label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    cursor: pointer;
                    font-size: 14px;
                }

                .vnpay-badge {
                    background: #005baa;
                    color: #fff;
                    font-weight: bold;
                    font-size: 12px;
                    padding: 2px 7px;
                    border-radius: 3px;
                    letter-spacing: .5px;
                }

                .btn {
                    display: inline-block;
                    padding: 8px 16px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    cursor: pointer;
                    font-size: 14px;
                }

                .btn-confirm {
                    background: #2e7d32;
                    color: white;
                    border-color: #2e7d32;
                }

                .btn-back {
                    background: #555;
                    color: white;
                    border-color: #555;
                }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user"); Cart cart=(Cart) request.getAttribute("cart");
                double grandTotal=(cart !=null) ? cart.getTotalCost() : 0; %>

                <h1>${i18n.get('checkout.title')}</h1>
                <nav>
                        ${i18n.get('nav.welcome')}, <strong>
                            <%= currentUser !=null ? currentUser.getUsername() : "" %>
                        </strong> |
                        <a href="${pageContext.request.contextPath}/cart">${i18n.get('checkout.backToCart')}</a> |
                        <a href="${pageContext.request.contextPath}/products">${i18n.get('product.title')}</a> |
                        <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                </nav>

                <h2>${i18n.get('checkout.summary')}</h2>
                <table>
                    <thead>
                        <tr>
                            <th>${i18n.get('checkout.product')}</th>
                            <th>${i18n.get('cart.price')}</th>
                            <th>${i18n.get('checkout.qty')}</th>
                            <th>${i18n.get('cart.subtotal')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (cart !=null) { for (CartItem item : cart) { %>
                            <tr>
                                <td>
                                    <%= item.getProduct().getName() %>
                                </td>
                                <td>
                                    <%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫
                                </td>
                                <td>
                                    <%= item.getQuantity() %>
                                </td>
                                <td>
                                    <%= String.format("%,.0f", item.getSubtotal()) %> ₫
                                </td>
                            </tr>
                            <% } } %>
                                <tr class="total-row">
                                    <td colspan="3" style="text-align:right;">${i18n.get('cart.total')}:</td>
                                    <td>
                                        <%= String.format("%,.0f", grandTotal) %> ₫
                                    </td>
                                </tr>
                    </tbody>
                </table>

                <div class="summary">
                    <form action="${pageContext.request.contextPath}/checkout" method="post">
                        <h3 style="margin-top:0;">${i18n.get('checkout.paymentMethod')}</h3>
                        <div class="payment-option">
                            <label>
                                <input type="radio" name="paymentMethod" value="COD" checked>
                                Cash on Delivery (COD)
                            </label>
                        </div>
                        <div class="payment-option">
                            <label>
                                <input type="radio" name="paymentMethod" value="VNPAY">
                                <span class="vnpay-badge">VNPAY</span>
                                ${i18n.get('checkout.paymentOnline')}
                            </label>
                        </div>
                        <hr>
                        <p><strong>${i18n.get('checkout.shipping')}:</strong> ${i18n.get('checkout.free')}</p>
                        <p><strong>Total: <%= String.format("%,.0f", grandTotal) %> ₫</strong></p>
                        <br>
                        <button type="submit" class="btn btn-confirm">${i18n.get('checkout.placeOrder')}</button>
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-back"
                            style="margin-left:8px;">${i18n.get('checkout.backToCart')}</a>
                    </form>
                </div>

        </body>

        </html>
