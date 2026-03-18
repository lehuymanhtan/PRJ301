<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Supplier, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Supplier management specific enhancements */
        .table-container {
            overflow-x: auto;
        }

        .supplier-table {
            width: 100%;
            border-collapse: collapse;
            font-size: var(--text-sm);
        }

        .supplier-table th,
        .supplier-table td {
            padding: var(--space-3) var(--space-4);
            text-align: left;
            border-bottom: 1px solid var(--border-primary);
            vertical-align: middle;
        }

        .supplier-table th {
            background: var(--surface-tertiary);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .supplier-table tr:hover {
            background: rgba(59, 130, 246, 0.04);
        }

        .supplier-actions {
            display: flex;
            gap: var(--space-2);
            align-items: center;
        }

        .supplier-id {
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
        }

        .supplier-name {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .contact-info {
            color: var(--text-secondary);
            font-size: var(--text-sm);
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            width: 100%;
            justify-content: center;
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-bold);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-badge--active {
            background: var(--surface-success);
            color: var(--text-success);
        }

        .status-badge--inactive {
            background: var(--surface-danger);
            color: var(--text-danger);
        }

        .address-cell {
            max-width: 200px;
            font-size: var(--text-xs);
            color: var(--text-secondary);
            line-height: 1.4;
        }
    </style>
</head>
<body class="bg-surface-secondary">

<%
    User currentUser = (User) session.getAttribute("user");
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Supplier Management</h1>
            <p class="dashboard-subtitle">Manage your business partners and suppliers</p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers" class="active">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
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
        <!-- Messages -->
        <% if ("created".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Supplier created successfully.
            </div>
        <% } %>
        <% if ("updated".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Supplier updated successfully.
            </div>
        <% } %>
        <% if ("deleted".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Supplier deleted successfully.
            </div>
        <% } %>
        <% if ("notfound".equals(errParam)) { %>
            <div class="message message--danger mb-lg">
                ❌ Supplier not found.
            </div>
        <% } %>
        <% if (errParam != null && !"notfound".equals(errParam)) { %>
            <div class="message message--danger mb-lg">
                ❌ Error: <%= errParam %>
            </div>
        <% } %>

        <!-- Actions Bar -->
        <div class="flex justify-between items-center mb-lg">
            <div>
                <a href="${pageContext.request.contextPath}/admin/suppliers?action=create" class="btn btn--success btn--md">
                    + Add Supplier
                </a>
            </div>
        </div>

        <!-- Suppliers Table -->
        <div class="surface-card">
            <div class="table-container">
                <table class="supplier-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Company Name</th>
                            <th>Contact Info</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (suppliers == null || suppliers.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="text-center py-xl">
                                    <div class="text-secondary">
                                        🏪 No suppliers found.
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=create"
                                           class="text-primary">Add your first supplier</a>
                                    </div>
                                </td>
                            </tr>
                        <% } else {
                            for (Supplier s : suppliers) { %>
                            <tr>
                                <td>
                                    <span class="supplier-id">#<%= s.getId() %></span>
                                </td>
                                <td>
                                    <div class="supplier-name"><%= s.getName() %></div>
                                </td>
                                <td>
                                    <div class="contact-info">
                                        <% if (s.getPhone() != null && !s.getPhone().isEmpty()) { %>
                                            <div>📞 <%= s.getPhone() %></div>
                                        <% } %>
                                        <% if (s.getEmail() != null && !s.getEmail().isEmpty()) { %>
                                            <div>📧 <%= s.getEmail() %></div>
                                        <% } %>
                                        <% if ((s.getPhone() == null || s.getPhone().isEmpty()) &&
                                               (s.getEmail() == null || s.getEmail().isEmpty())) { %>
                                            <span class="text-tertiary">No contact info</span>
                                        <% } %>
                                    </div>
                                </td>
                                <td>
                                    <div class="address-cell">
                                        <%= s.getAddress() != null && !s.getAddress().isEmpty() ? s.getAddress() : "No address" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%= s.isStatus() ? "status-badge--active" : "status-badge--inactive" %>">
                                        <%= s.isStatus() ? "✅ Active" : "❌ Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="supplier-actions">
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=edit&id=<%= s.getId() %>"
                                           class="btn btn--primary btn--xs">✏️ Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=delete&id=<%= s.getId() %>"
                                           class="btn btn--danger btn--xs"
                                           onclick="return confirm('Delete supplier <%= s.getName().replace("'", "\\'") %>?\n\nThis will also remove the supplier from all associated products.')">
                                           🗑️ Delete</a>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>

