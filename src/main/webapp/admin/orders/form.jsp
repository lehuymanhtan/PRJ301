<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Order Status - Ruby Tech Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
<body class="bg-surface-secondary">
<%
    Order order = (Order) request.getAttribute("order");
%>

<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Edit Order Status</h1>
            <p class="dashboard-subtitle">Track and update the current order state</p>
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
        <div class="form-shell">
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn--secondary btn--sm">← Back to Orders</a>
            </div>

            <div class="surface-card surface-card--form">
                <div class="order-meta">
                    <div class="meta-card">
                        <div class="meta-label">Order ID</div>
                        <div class="meta-value">#<%= order.getId() %></div>
                    </div>
                    <div class="meta-card">
                        <div class="meta-label">Customer ID</div>
                        <div class="meta-value"><%= order.getUserId() %></div>
                    </div>
                    <div class="meta-card">
                        <div class="meta-label">Total Price</div>
                        <div class="meta-value"><%= String.format("%,.0f", order.getTotalPrice()) %> VND</div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= order.getId() %>">

                    <div class="form-group">
                        <label for="status" class="form-label">Status</label>
                        <select id="status" name="status" class="form-input">
                            <option value="Pending" <%= "Pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                            <option value="Processing" <%= "Processing".equals(order.getStatus()) ? "selected" : "" %>>Processing</option>
                            <option value="Shipped" <%= "Shipped".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                            <option value="Delivered" <%= "Delivered".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                            <option value="Completed" <%= "Completed".equals(order.getStatus()) ? "selected" : "" %>>Completed</option>
                            <option value="Cancelled" <%= "Cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                            <option value="Refunded" <%= "Refunded".equals(order.getStatus()) ? "selected" : "" %>>Refunded</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn--secondary btn--md">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--md">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
