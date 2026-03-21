<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Order Management</h1>
            <p class="dashboard-subtitle">Monitor and manage customer orders</p>
        </div>

        <!-- Admin Navigation -->
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

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Orders Table -->
        <div class="surface-card">
            <div class="table-container">
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Total Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (orders != null && !orders.isEmpty()) {
                           for (Order o : orders) {
                               String statusClass = "status-badge--" + o.getStatus().toLowerCase();
                       %>
                        <tr>
                            <td>
                                <span class="order-id">#<%= o.getId() %></span>
                            </td>
                            <td>
                                <div class="text-secondary">User ID: <%= o.getUserId() %></div>
                            </td>
                            <td>
                                <span class="price-display"><%= String.format("%,.0f", o.getTotalPrice()) %> ₫</span>
                            </td>
                            <td>
                                <span class="status-badge <%= statusClass %>">
                                    <%= o.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= o.getId() %>"
                                       class="btn btn--info btn--xs">👁️ View</a>
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= o.getId() %>"
                                       class="btn btn--warning btn--xs">✏️ Edit</a>
                                    <form class="delete-form" method="post"
                                          action="${pageContext.request.contextPath}/admin/orders"
                                          onsubmit="return confirm('Delete order #<%= o.getId() %>? This action cannot be undone.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= o.getId() %>">
                                        <button type="submit" class="btn btn--danger btn--xs">🗑️ Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="5" class="text-center py-xl">
                                <div class="text-secondary">
                                    🛒 No orders found.
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/" class="text-primary">
                                            Visit the store to place orders
                                        </a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <%
            Long totalPages = (Long) request.getAttribute("totalPages");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            Long totalCount = (Long) request.getAttribute("totalCount");
            if (totalPages != null && totalPages > 1) {
        %>
        <div class="pagination-container">
            <% if (pageNumber > 1) { %>
                <a href="${pageContext.request.contextPath}/admin/orders?page=1"
                   class="btn btn--secondary btn--sm">First</a>
                <a href="${pageContext.request.contextPath}/admin/orders?page=<%= pageNumber - 1 %>"
                   class="btn btn--secondary btn--sm">← Previous</a>
            <% } %>

            <div class="pagination-info">
                Page <%= pageNumber %> of <%= totalPages %>
            </div>

            <% if (pageNumber < totalPages) { %>
                <a href="${pageContext.request.contextPath}/admin/orders?page=<%= pageNumber + 1 %>"
                   class="btn btn--secondary btn--sm">Next →</a>
                <a href="${pageContext.request.contextPath}/admin/orders?page=<%= totalPages %>"
                   class="btn btn--secondary btn--sm">Last</a>
            <% } %>
        </div>
        <% } %>

        <!-- Statistics Footer -->
        <div class="stats-footer">
            📊 Total orders: <%= (totalCount != null) ? String.format("%,d", totalCount) : 0 %>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
