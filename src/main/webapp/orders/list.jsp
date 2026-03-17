<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Order, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('order.title')}</title>
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
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px 12px;
                    text-align: left;
                }

                th {
                    background: #f0f0f0;
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

                .empty-msg {
                    color: #777;
                    margin-top: 15px;
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

                .btn-shop {
                    background: #1565c0;
                    color: white;
                    border-color: #1565c0;
                }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user"); List<Order> orders = (List<Order>)
                    request.getAttribute("orders");
                    String msg = (String) session.getAttribute("cartMessage");
                    if (msg != null) session.removeAttribute("cartMessage");
                    %>

                    <h1>${i18n.get('order.title')}</h1>
                    <nav>
                            ${i18n.get('nav.welcome')}, <strong>
                                <%= currentUser !=null ? currentUser.getUsername() : "" %>
                            </strong> |
                            <a href="${pageContext.request.contextPath}/products">${i18n.get('product.title')}</a> |
                            <a href="${pageContext.request.contextPath}/cart">${i18n.get('cart.title')}</a> |
                            <a href="${pageContext.request.contextPath}/users">${i18n.get('nav.myProfile')}</a> |
                            <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                    </nav>

                    <% if (msg !=null) { %>
                        <p style="color:#c62828;">
                            <%= msg %>
                        </p>
                        <% } %>

                            <% if (orders==null || orders.isEmpty()) { %>
                                <p class="empty-msg">${i18n.get('order.noOrdersYet')}</p>
                                <a href="${pageContext.request.contextPath}/products"
                                    class="btn btn-shop">${i18n.get('order.browseProducts')}</a>
                                <% } else { %>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>${i18n.get('order.id')}</th>
                                                <th>${i18n.get('order.total')}</th>
                                                <th>${i18n.get('order.status')}</th>
                                                <th>${i18n.get('order.actions')}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Order o : orders) { String badge="badge-" +
                                                o.getStatus().toLowerCase(); %>
                                                <tr>
                                                    <td>#<%= o.getId() %>
                                                    </td>
                                                    <td>
                                                        <%= String.format("%,.0f", o.getTotalPrice()) %> ₫
                                                    </td>
                                                    <td><span class="badge <%= badge %>">
                                                            <%= o.getStatus() %>
                                                        </span></td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= o.getId() %>"
                                                            class="btn btn-view">${i18n.get('order.viewDetails')}</a>
                                                    </td>
                                                </tr>
                                                <% } %>
                                        </tbody>
                                    </table>
                                    <% } %>

        </body>

        </html>
