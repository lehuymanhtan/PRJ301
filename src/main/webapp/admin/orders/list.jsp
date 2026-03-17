<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Order" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Order Management</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                    background: #f5f5f5;
                }

                h1 {
                    margin-bottom: 6px;
                }

                nav {
                    margin-bottom: 20px;
                }

                nav a {
                    margin-right: 12px;
                    text-decoration: none;
                    color: #333;
                }

                nav a:hover {
                    text-decoration: underline;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    background: white;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 8px 12px;
                    text-align: left;
                }

                th {
                    background: #f0f0f0;
                }

                tr:hover td {
                    background: #fafafa;
                }

                .badge {
                    display: inline-block;
                    padding: 2px 8px;
                    border-radius: 10px;
                    font-size: 12px;
                    font-weight: bold;
                }

                .badge-pending {
                    background: #fff3cd;
                    color: #856404;
                }

                .badge-processing {
                    background: #cce5ff;
                    color: #004085;
                }

                .badge-shipped {
                    background: #d1ecf1;
                    color: #0c5460;
                }

                .badge-delivered {
                    background: #d4edda;
                    color: #155724;
                }

                .badge-completed {
                    background: #c3e6cb;
                    color: #155724;
                }

                .badge-cancelled {
                    background: #f8d7da;
                    color: #721c24;
                }

                .badge-refunded {
                    background: #e8eaf6;
                    color: #283593;
                }

                .btn {
                    display: inline-block;
                    padding: 4px 10px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    font-size: 12px;
                }

                .btn-view {
                    background: #0277bd;
                    color: white;
                    border-color: #0277bd;
                }

                .btn-edit {
                    background: #f57c00;
                    color: white;
                    border-color: #f57c00;
                }

                .btn-delete {
                    background: #c62828;
                    color: white;
                    border-color: #c62828;
                    cursor: pointer;
                }

                .footer {
                    color: #777;
                    margin-top: 10px;
                    font-size: 13px;
                }
            </style>
        </head>

        <body>
            <% List<Order> orders = (List<Order>) request.getAttribute("orders");
                    %>

                    <h1>Order Management</h1>
                    <nav>
                            <a
                                href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                            |
                            <a href="${pageContext.request.contextPath}/admin/users">Users</a> |
                            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
                            |
                            <a
                                href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
                            |
                            <strong>Orders</strong> |
                            <a href="${pageContext.request.contextPath}/logout">Logout</a>
                    </nav>

                    <table>
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>ID</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (orders !=null && !orders.isEmpty()) { for (Order o : orders) { String badge="badge-"
                                + o.getStatus().toLowerCase(); %>
                                <tr>
                                    <td>#<%= o.getId() %>
                                    </td>
                                    <td>
                                        <%= o.getUserId() %>
                                    </td>
                                    <td>
                                        <%= String.format("%,.0f", o.getTotalPrice()) %> &#8363;
                                    </td>
                                    <td><span class="badge <%= badge %>">
                                            <%= o.getStatus() %>
                                        </span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= o.getId() %>"
                                            class="btn btn-view">View</a>
                                        <a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= o.getId() %>"
                                            class="btn btn-edit">Edit</a>
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post"
                                            style="display:inline;"
                                            onsubmit="return confirm('Are you sure you want to delete?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= o.getId() %>">
                                            <button type="submit"
                                                class="btn btn-delete">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="5" style="text-align:center; color:#777; padding:20px;">
                                            No orders found.
                                        </td>
                                    </tr>
                                    <% } %>
                        </tbody>
                    </table>

                    <p class="footer">Total orders: <%= (orders !=null) ? orders.size() : 0 %>
                    </p>

        </body>

        </html>


