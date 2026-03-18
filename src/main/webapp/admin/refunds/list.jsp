<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Management - TechStore Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Refund management specific enhancements */
        .table-container {
            overflow-x: auto;
        }

        .refund-table {
            width: 100%;
            border-collapse: collapse;
            font-size: var(--text-sm);
        }

        .refund-table th,
        .refund-table td {
            padding: var(--space-3) var(--space-4);
            text-align: left;
            border-bottom: 1px solid var(--border-primary);
            vertical-align: middle;
        }

        .refund-table th {
            background: var(--surface-tertiary);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .refund-table tr:hover {
            background: rgba(59, 130, 246, 0.04);
        }

        .refund-id {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            font-family: var(--font-mono);
        }

        .order-id-link {
            font-family: var(--font-mono);
            color: var(--glass-primary);
            text-decoration: none;
            font-weight: var(--font-weight-medium);
        }

        .order-id-link:hover {
            text-decoration: underline;
        }

        .reason-text {
            max-width: 200px;
            color: var(--text-secondary);
            font-size: var(--text-sm);
            line-height: 1.4;
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

        .status-badge--waitforreturn {
            background: var(--surface-info);
            color: var(--text-info);
        }

        .status-badge--verifying {
            background: rgba(59, 130, 246, 0.1);
            color: var(--glass-primary);
        }

        .status-badge--done {
            background: var(--surface-success);
            color: var(--text-success);
        }

        .status-badge--rejected {
            background: var(--surface-danger);
            color: var(--text-danger);
        }

        .status-badge--cancelled {
            background: rgba(107, 114, 128, 0.1);
            color: #6b7280;
        }

        .date-display {
            color: var(--text-secondary);
            font-family: var(--font-mono);
            font-size: var(--text-xs);
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
