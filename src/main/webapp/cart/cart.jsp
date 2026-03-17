<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Cart, models.CartItem, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('cart.title')}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h1 {
                    margin-bottom: 10px;
                }

                nav {
                    margin-bottom: 20px;
                }

                nav a {
                    margin-right: 10px;
                }

                .msg {
                    color: green;
                    margin-bottom: 12px;
                }

                .msg-warning {
                    color: orange;
                    margin-bottom: 12px;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    max-width: 700px;
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

                .qty-form {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .qty-form input[type="number"] {
                    width: 60px;
                    padding: 3px;
                    border: 1px solid #ccc;
                    border-radius: 3px;
                }

                .btn {
                    display: inline-block;
                    padding: 4px 10px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    cursor: pointer;
                    font-size: 13px;
                }

                .btn-save {
                    background: #4caf50;
                    color: white;
                    border-color: #4caf50;
                }

                .btn-remove {
                    background: #f44336;
                    color: white;
                    border-color: #f44336;
                }

                .btn-shop {
                    background: #1565c0;
                    color: white;
                    border-color: #1565c0;
                }

                .btn-checkout {
                    background: #2e7d32;
                    color: white;
                    border-color: #2e7d32;
                }

                .total-row td {
                    font-weight: bold;
                }

                .empty-msg {
                    color: #777;
                    margin-top: 15px;
                }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user"); Cart cart=(Cart) request.getAttribute("cart");
                String cartMessage=(String) request.getAttribute("cartMessage"); String stockMessage=(String)
                request.getAttribute("stockMessage"); %>

                <h1>${i18n.get('cart.title')}</h1>
                <nav>
                        ${i18n.get('nav.welcome')}, <strong>
                            <%= currentUser !=null ? currentUser.getUsername() : "" %>
                        </strong> |
                        <a href="${pageContext.request.contextPath}/products">${i18n.get('nav.continueShopping')}</a> |
                        <a href="${pageContext.request.contextPath}/orders">${i18n.get('nav.myOrders')}</a> |
                        <a href="${pageContext.request.contextPath}/users">${i18n.get('nav.myProfile')}</a> |
                        <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                </nav>

                <% if (cartMessage !=null) { %>
                    <p class="msg">
                        <%= cartMessage %>
                    </p>
                    <% } %>
                        <% if (stockMessage !=null) { %>
                            <p class="msg-warning">
                                <%= stockMessage %>
                            </p>
                            <% } %>

                                <% if (cart==null || cart.isEmpty()) { %>
                                    <p class="empty-msg">${i18n.get('cart.empty')}</p>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="btn btn-shop">${i18n.get('cart.browseProducts')}</a>
                                    <% } else { %>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>${i18n.get('cart.product')}</th>
                                                    <th>${i18n.get('cart.price')}</th>
                                                    <th>${i18n.get('cart.quantity')}</th>
                                                    <th>${i18n.get('cart.subtotal')}</th>
                                                    <th>${i18n.get('cart.action')}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% double grandTotal=0; for (CartItem item : cart) { grandTotal
                                                    +=item.getSubtotal(); %>
                                                    <tr>
                                                        <td>
                                                            <%= item.getProduct().getName() %>
                                                        </td>
                                                        <td>
                                                            <%= String.format("%,.0f", item.getProduct().getPrice()) %>
                                                                ₫
                                                        </td>
                                                        <td>
                                                            <form class="qty-form"
                                                                action="${pageContext.request.contextPath}/cart"
                                                                method="post">
                                                                <input type="hidden" name="productId"
                                                                    value="<%= item.getProduct().getId() %>">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="number" name="quantity"
                                                                    value="<%= item.getQuantity() %>" min="1"
                                                                    max="<%= item.getProduct().getStock() %>">
                                                                <button type="submit"
                                                                    class="btn btn-save">${i18n.get('action.update')}</button>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <%= String.format("%,.0f", item.getSubtotal()) %> ₫
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/cart"
                                                                method="post">
                                                                <input type="hidden" name="productId"
                                                                    value="<%= item.getProduct().getId() %>">
                                                                <input type="hidden" name="action" value="remove">
                                                                <button type="submit"
                                                                    class="btn btn-remove">${i18n.get('action.remove')}</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                                        <tr class="total-row">
                                                            <td colspan="3" style="text-align:right;">
                                                                ${i18n.get('cart.total')}:</td>
                                                            <td>
                                                                <%= String.format("%,.0f", grandTotal) %> ₫
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                            </tbody>
                                        </table>

                                        <div style="margin-top: 15px;">
                                            <a href="${pageContext.request.contextPath}/products" class="btn btn-shop">
                                                ${i18n.get('nav.continueShopping')}
                                            </a>
                                            <a href="${pageContext.request.contextPath}/checkout"
                                                class="btn btn-checkout" style="margin-left: 10px;">
                                                ${i18n.get('cart.proceedToCheckout')}
                                            </a>
                                        </div>
                                        <% } %>

        </body>

        </html>
