<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Cart, models.CartItem, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Shopping Cart</title>
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

                <h1>Shopping Cart</h1>
                <nav>
                        Welcome, <strong>
                            <%= currentUser !=null ? currentUser.getUsername() : "" %>
                        </strong> |
                        <a href="${pageContext.request.contextPath}/products">Continue Shopping</a> |
                        <a href="${pageContext.request.contextPath}/orders">My Orders</a> |
                        <a href="${pageContext.request.contextPath}/users">My Profile</a> |
                        <a href="${pageContext.request.contextPath}/logout">Logout</a>
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
                                    <p class="empty-msg">Your cart is empty</p>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="btn btn-shop">Browse Products</a>
                                    <% } else { %>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Price</th>
                                                    <th>Quantity</th>
                                                    <th>Subtotal</th>
                                                    <th>Action</th>
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
                                                                &#8363;
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
                                                                    class="btn btn-save">Update</button>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <%= String.format("%,.0f", item.getSubtotal()) %> &#8363;
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/cart"
                                                                method="post">
                                                                <input type="hidden" name="productId"
                                                                    value="<%= item.getProduct().getId() %>">
                                                                <input type="hidden" name="action" value="remove">
                                                                <button type="submit"
                                                                    class="btn btn-remove">Remove</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                                        <tr class="total-row">
                                                            <td colspan="3" style="text-align:right;">
                                                                Total:</td>
                                                            <td>
                                                                <%= String.format("%,.0f", grandTotal) %> &#8363;
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                            </tbody>
                                        </table>

                                        <div style="margin-top: 15px;">
                                            <a href="${pageContext.request.contextPath}/products" class="btn btn-shop">
                                                Continue Shopping
                                            </a>
                                            <a href="${pageContext.request.contextPath}/checkout"
                                                class="btn btn-checkout" style="margin-left: 10px;">
                                                Proceed to Checkout
                                            </a>
                                        </div>
                                        <% } %>

        </body>

        </html>


