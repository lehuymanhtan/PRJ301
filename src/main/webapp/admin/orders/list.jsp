<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - TechStore Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Order management specific enhancements */
        .table-container {
            overflow-x: auto;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            font-size: var(--text-sm);
        }

        .order-table th,
        .order-table td {
            padding: var(--space-3) var(--space-4);
            text-align: left;
            border-bottom: 1px solid var(--border-primary);
            vertical-align: middle;
        }

        .order-table th {
            background: var(--surface-tertiary);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .order-table tr:hover {
            background: rgba(59, 130, 246, 0.04);
        }

        .order-actions {
            display: flex;
            gap: var(--space-2);
            align-items: center;
        }

        .order-id {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            font-family: var(--font-mono);
        }

        .price-display {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-bold);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-badge--pending {
            background: var(--surface-warning);
            color: var(--text-warning);
        }

        .status-badge--processing {
            background: var(--surface-info);
            color: var(--text-info);
        }

        .status-badge--shipped {
            background: rgba(59, 130, 246, 0.1);
            color: var(--glass-primary);
        }

        .status-badge--delivered,
        .status-badge--completed {
            background: var(--surface-success);
            color: var(--text-success);
        }

        .status-badge--cancelled {
            background: var(--surface-danger);
            color: var(--text-danger);
        }

        .status-badge--refunded {
            background: rgba(124, 58, 237, 0.1);
            color: #7c3aed;
        }

        .delete-form {
            display: inline;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: var(--space-2);
            margin-top: var(--space-lg);
            padding: var(--space-lg) 0;
        }

        .pagination-info {
            padding: var(--space-2) var(--space-4);
            background: var(--surface-tertiary);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            color: var(--text-secondary);
            font-weight: var(--font-weight-medium);
        }

        .stats-footer {
            margin-top: var(--space-lg);
            text-align: center;
            color: var(--text-secondary);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
        }
    </style>
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
