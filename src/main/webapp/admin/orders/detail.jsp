<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #${order.id} Details - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    Order          order   = (Order)          request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    RefundRequest  refund  = (RefundRequest)  request.getAttribute("refund");
    String statusClass = "status-badge--" + order.getStatus().toLowerCase();
%>

<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Order #<%= order.getId() %></h1>
            <p class="dashboard-subtitle">Detailed information and line items</p>
        </div>

        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="active">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <div class="admin-content">
        <div class="surface-card mb-lg">
            <div class="order-meta-grid">
                <div class="meta-item">
                    <div class="meta-label">Order ID</div>
                    <div class="meta-value">#<%= order.getId() %></div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Customer</div>
                    <div class="meta-value">User ID: <%= order.getUserId() %></div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Total Price</div>
                    <div class="meta-value"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Status</div>
                    <div class="meta-value">
                        <span class="status-badge <%= statusClass %>"><%= order.getStatus() %></span>
                    </div>
                </div>
                <% if (refund != null) { %>
                <div class="meta-item">
                    <div class="meta-label">Related Refund</div>
                    <div class="meta-value">
                        <a href="${pageContext.request.contextPath}/admin/refunds?action=detail&id=<%= refund.getId() %>"
                           class="text-primary">#<%= refund.getId() %> - <%= refund.getStatus() %></a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <div class="surface-card">
            <h2 class="text-xl font-semibold text-primary mb-md">Order Items</h2>

            <div class="table-container">
                <table class="items-table">
                    <thead>
                    <tr>
                        <th>Product</th>
                        <th>Unit Price</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (details != null && !details.isEmpty()) {
                           double total = 0;
                           for (OrderDetail d : details) {
                               total += d.getSubtotal(); %>
                        <tr>
                            <td><%= d.getProductName() %></td>
                            <td><span class="price"><%= String.format("%,.0f", d.getPrice()) %> ₫</span></td>
                            <td><span class="qty"><%= d.getQuantity() %></span></td>
                            <td><span class="price"><%= String.format("%,.0f", d.getSubtotal()) %> ₫</span></td>
                        </tr>
                    <%  } %>
                        <tr class="total-row">
                            <td colspan="3" class="text-right">Total</td>
                            <td><span class="price"><%= String.format("%,.0f", total) %> ₫</span></td>
                        </tr>
                    <% } else { %>
                        <tr>
                            <td colspan="4" class="text-center py-lg text-secondary">No items found.</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn--secondary">← Back to Orders</a>
                <a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= order.getId() %>" class="btn btn--warning">✏️ Edit Status</a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
