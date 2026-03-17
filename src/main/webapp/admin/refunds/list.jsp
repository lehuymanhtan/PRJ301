<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.RefundRequest" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('admin.refundManagement')}</title>
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

                .badge-Pending {
                    background: #fff3cd;
                    color: #856404;
                }

                .badge-WaitForReturn {
                    background: #cce5ff;
                    color: #004085;
                }

                .badge-Verifying {
                    background: #d1ecf1;
                    color: #0c5460;
                }

                .badge-Done {
                    background: #d4edda;
                    color: #155724;
                }

                .badge-Rejected {
                    background: #f8d7da;
                    color: #721c24;
                }

                .badge-Cancelled {
                    background: #e2e3e5;
                    color: #383d41;
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

                .footer {
                    color: #777;
                    margin-top: 10px;
                    font-size: 13px;
                }
            </style>
        </head>

        <body>
            <% List<RefundRequest> refunds = (List<RefundRequest>) request.getAttribute("refunds");
                    %>

                    <h1>${i18n.get('admin.refundManagement')}</h1>
                    <nav>
                            <a
                                href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                            |
                            <a href="${pageContext.request.contextPath}/admin/users">${i18n.get('nav.users')}</a> |
                            <a href="${pageContext.request.contextPath}/admin/products">${i18n.get('nav.products')}</a>
                            |
                            <a
                                href="${pageContext.request.contextPath}/admin/suppliers">${i18n.get('nav.suppliers')}</a>
                            |
                            <a href="${pageContext.request.contextPath}/admin/orders">${i18n.get('nav.orders')}</a> |
                            <strong>${i18n.get('nav.refunds')}</strong> |
                            <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                    </nav>

                    <table>
                        <thead>
                            <tr>
                                <th>${i18n.get('refund.id')}</th>
                                <th>${i18n.get('refund.orderId')}</th>
                                <th>${i18n.get('table.id')}</th>
                                <th>${i18n.get('refund.reasonLabel')}</th>
                                <th>${i18n.get('refund.status')}</th>
                                <th>${i18n.get('refund.submitted')}</th>
                                <th>${i18n.get('table.actions')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (refunds !=null && !refunds.isEmpty()) { for (RefundRequest r : refunds) { %>
                                <tr>
                                    <td>#<%= r.getId() %>
                                    </td>
                                    <td>#<%= r.getOrderId() %>
                                    </td>
                                    <td>
                                        <%= r.getUserId() %>
                                    </td>
                                    <td>
                                        <%= r.getReason() %>
                                    </td>
                                    <td><span class="badge badge-<%= r.getStatus() %>">
                                            <%= r.getStatus() %>
                                        </span></td>
                                    <td>
                                        <%= r.getCreatedAt() !=null ? r.getCreatedAt().toLocalDate() : "" %>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/refunds?action=detail&id=<%= r.getId() %>"
                                            class="btn btn-view">${i18n.get('action.view')}</a>
                                    </td>
                                </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="7" style="text-align:center; color:#777;">No refund requests found.
                                        </td>
                                    </tr>
                                    <% } %>
                        </tbody>
                    </table>

                    <p class="footer">Total: <%= refunds !=null ? refunds.size() : 0 %> refund request(s)</p>

        </body>

        </html>
