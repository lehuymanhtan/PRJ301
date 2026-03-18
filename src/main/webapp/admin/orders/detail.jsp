<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #${order.id} Details - TechStore Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .order-meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: var(--space-3);
        }

        .meta-item {
            padding: var(--space-3);
            border: 1px solid var(--border-primary);
            border-radius: var(--radius-md);
            background: var(--surface-secondary);
        }

        .meta-label {
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-secondary);
            margin-bottom: var(--space-1);
            font-weight: var(--font-weight-semibold);
        }

        .meta-value {
            font-size: var(--text-md);
            color: var(--text-primary);
            font-weight: var(--font-weight-semibold);
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

        .items-table {
            width: 100%;
            border-collapse: collapse;
            font-size: var(--text-sm);
        }

        .items-table th,
        .items-table td {
            padding: var(--space-3) var(--space-4);
            border-bottom: 1px solid var(--border-primary);
            text-align: left;
            vertical-align: middle;
        }

        .items-table th {
            background: var(--surface-tertiary);
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .items-table tr:hover {
            background: rgba(59, 130, 246, 0.04);
        }

        .price {
            font-family: var(--font-mono);
            color: var(--text-primary);
            font-weight: var(--font-weight-semibold);
        }

        .qty {
            font-weight: var(--font-weight-semibold);
            color: var(--text-secondary);
        }

        .total-row td {
            font-weight: var(--font-weight-bold);
            background: var(--surface-tertiary);
        }

        .actions {
            display: flex;
            gap: var(--space-2);
            flex-wrap: wrap;
            margin-top: var(--space-lg);
        }

        @media (max-width: 768px) {
            .items-table th,
            .items-table td {
                padding: var(--space-2) var(--space-3);
            }
        }
    </style>
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
                <div class="meta-item" style="grid-column: 1 / -1;">
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
