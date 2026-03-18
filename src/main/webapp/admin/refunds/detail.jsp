<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund #${refund.id} Details - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .refund-meta-grid {
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
            font-weight: var(--font-weight-medium);
            word-break: break-word;
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

        .update-form {
            display: grid;
            gap: var(--space-md);
        }

        .form-group {
            display: grid;
            gap: var(--space-2);
        }

        .form-label {
            color: var(--text-primary);
            font-weight: var(--font-weight-semibold);
            font-size: var(--text-sm);
        }

        .form-control {
            width: 100%;
            padding: var(--space-3);
            border: 1px solid var(--border-primary);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            color: var(--text-primary);
            background: var(--surface-primary);
            box-sizing: border-box;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--glass-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        #returnAddressGroup { display: none; }

        .actions {
            display: flex;
            gap: var(--space-2);
            flex-wrap: wrap;
            margin-top: var(--space-lg);
        }

        .form-hint {
            color: var(--text-secondary);
            font-size: var(--text-xs);
        }
    </style>
    <script>
        function toggleReturnAddress() {
            var sel = document.getElementById("statusSelect");
            var grp = document.getElementById("returnAddressGroup");
            grp.style.display = (sel.value === "WaitForReturn") ? "block" : "none";
        }
        window.onload = function() { toggleReturnAddress(); };
    </script>
</head>
<body class="bg-surface-secondary">
<%
    RefundRequest refund = (RefundRequest) request.getAttribute("refund");
    Order         order  = (Order)         request.getAttribute("order");
    String        status = refund.getStatus();
    String        statusClass = "status-badge--" + status.toLowerCase();
%>

<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Refund #<%= refund.getId() %></h1>
            <p class="dashboard-subtitle">Review details and update refund workflow status</p>
        </div>

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

    <div class="admin-content">
        <div class="surface-card mb-lg">
            <div class="refund-meta-grid">
                <div class="meta-item">
                    <div class="meta-label">Refund ID</div>
                    <div class="meta-value">#<%= refund.getId() %></div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Order ID</div>
                    <div class="meta-value">
                        #<%= refund.getOrderId() %>
                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= refund.getOrderId() %>"
                           class="text-primary" style="margin-left: 8px;">View Order</a>
                    </div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Customer</div>
                    <div class="meta-value">User ID: <%= refund.getUserId() %></div>
                </div>
                <% if (order != null) { %>
                <div class="meta-item">
                    <div class="meta-label">Order Total</div>
                    <div class="meta-value"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</div>
                </div>
                <% } %>
                <div class="meta-item" style="grid-column: 1 / -1;">
                    <div class="meta-label">Reason</div>
                    <div class="meta-value"><%= refund.getReason() %></div>
                </div>
                <% if (refund.getDescription() != null && !refund.getDescription().isEmpty()) { %>
                <div class="meta-item" style="grid-column: 1 / -1;">
                    <div class="meta-label">Description</div>
                    <div class="meta-value"><%= refund.getDescription() %></div>
                </div>
                <% } %>
                <div class="meta-item">
                    <div class="meta-label">Submitted</div>
                    <div class="meta-value"><%= refund.getCreatedAt() != null ? refund.getCreatedAt().toLocalDate() : "" %></div>
                </div>
                <div class="meta-item">
                    <div class="meta-label">Status</div>
                    <div class="meta-value"><span class="status-badge <%= statusClass %>"><%= status %></span></div>
                </div>
                <% if (refund.getReturnAddress() != null && !refund.getReturnAddress().isEmpty()) { %>
                <div class="meta-item" style="grid-column: 1 / -1;">
                    <div class="meta-label">Return Address</div>
                    <div class="meta-value"><%= refund.getReturnAddress() %></div>
                </div>
                <% } %>
            </div>
        </div>

        <% if (!"Done".equals(status) && !"Rejected".equals(status) && !"Cancelled".equals(status)) { %>
        <div class="surface-card">
            <h2 class="text-xl font-semibold text-primary mb-md">Update Refund Status</h2>

            <form action="${pageContext.request.contextPath}/admin/refunds" method="post" class="update-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= refund.getId() %>">

                <div class="form-group">
                    <label class="form-label" for="statusSelect">New Status</label>
                    <select class="form-control" name="status" id="statusSelect" onchange="toggleReturnAddress()" required>
                        <option value="Pending"       <%="Pending"      .equals(status) ? "selected" : ""%>>Pending</option>
                        <option value="WaitForReturn" <%="WaitForReturn".equals(status) ? "selected" : ""%>>Wait for Return</option>
                        <option value="Verifying"     <%="Verifying"    .equals(status) ? "selected" : ""%>>Verifying</option>
                        <option value="Done"          <%="Done"         .equals(status) ? "selected" : ""%>>Done</option>
                        <option value="Rejected"      <%="Rejected"     .equals(status) ? "selected" : ""%>>Rejected</option>
                    </select>
                </div>

                <div class="form-group" id="returnAddressGroup">
                    <label class="form-label" for="returnAddress">Return Address</label>
                    <div class="form-hint">Shown to customer for return shipment.</div>
                    <textarea class="form-control" name="returnAddress" id="returnAddress"
                              placeholder="e.g. 123 Nguyen Hue, District 1, Ho Chi Minh City"><%= refund.getReturnAddress() != null ? refund.getReturnAddress() : "" %></textarea>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn--success">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/admin/refunds" class="btn btn--secondary">← Back to Refunds</a>
                </div>
            </form>
        </div>
        <% } else { %>
        <div class="surface-card">
            <div class="text-secondary">This refund is in a terminal state and can no longer be updated.</div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/admin/refunds" class="btn btn--secondary">← Back to Refunds</a>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>

