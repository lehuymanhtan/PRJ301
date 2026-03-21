<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Management - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">

<%
    List<RefundRequest> refunds = (List<RefundRequest>) request.getAttribute("refunds");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Refund Management</h1>
            <p class="dashboard-subtitle">Review and process customer refund requests</p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds" class="active">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Refunds Table -->
        <div class="surface-card">
            <div class="table-container">
                <table class="refund-table">
                    <thead>
                        <tr>
                            <th>Refund ID</th>
                            <th>Order</th>
                            <th>Customer</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Submitted</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (refunds != null && !refunds.isEmpty()) {
                           for (RefundRequest r : refunds) {
                               String statusClass = "status-badge--" + r.getStatus().toLowerCase();
                       %>
                        <tr>
                            <td>
                                <span class="refund-id">#<%= r.getId() %></span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= r.getOrderId() %>"
                                   class="order-id-link">#<%= r.getOrderId() %></a>
                            </td>
                            <td>
                                <div class="text-secondary">User ID: <%= r.getUserId() %></div>
                            </td>
                            <td>
                                <div class="reason-text">
                                    <%= r.getReason() != null && !r.getReason().isEmpty() ? r.getReason() : "No reason provided" %>
                                </div>
                            </td>
                            <td>
                                <span class="status-badge <%= statusClass %>">
                                    <%
                                        String status = r.getStatus();
                                        String emoji = "";
                                        switch (status) {
                                            case "Pending": emoji = "⏳"; break;
                                            case "WaitForReturn": emoji = "📦"; break;
                                            case "Verifying": emoji = "🔍"; break;
                                            case "Done": emoji = "✅"; break;
                                            case "Rejected": emoji = "❌"; break;
                                            case "Cancelled": emoji = "🚫"; break;
                                            default: emoji = "📋"; break;
                                        }
                                    %>
                                    <%= emoji %> <%= status %>
                                </span>
                            </td>
                            <td>
                                <span class="date-display">
                                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toLocalDate().toString() : "-" %>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/refunds?action=detail&id=<%= r.getId() %>"
                                   class="btn btn--info btn--xs">👁️ View Details</a>
                            </td>
                        </tr>
                    <% }
                       } else { %>
                        <tr>
                            <td colspan="7" class="text-center py-xl">
                                <div class="text-secondary">
                                    💰 No refund requests found.
                                    <div class="mt-2">
                                        <span class="text-xs">All customers are satisfied with their purchases! 🎉</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Statistics Footer -->
        <div class="stats-footer">
            📊 Total refund requests: <%= refunds != null ? String.format("%,d", refunds.size()) : 0 %>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
