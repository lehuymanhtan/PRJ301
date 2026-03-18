<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Supplier" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Supplier editSupplier = (Supplier) request.getAttribute("supplier");
        boolean isEdit = (editSupplier != null);
    %>
    <title><%= isEdit ? "Edit Supplier" : "Add Supplier" %> - Ruby Tech Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <style>
        .form-shell { max-width: 840px; margin: 0 auto; }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: var(--space-md);
        }
        .full-span { grid-column: 1 / -1; }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: var(--space-3);
            margin-top: var(--space-lg);
        }
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body class="bg-surface-secondary">
<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title"><%= isEdit ? "Edit Supplier" : "Create Supplier" %></h1>
            <p class="dashboard-subtitle">Maintain supplier profile and active status</p>
        </div>
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

    <div class="admin-content">
        <div class="form-shell">
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn--secondary btn--sm">← Back to Supplier List</a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--danger mb-lg">❌ <%= request.getAttribute("error") %></div>
            <% } %>

            <div class="surface-card surface-card--form">
                <form method="post" action="${pageContext.request.contextPath}/admin/suppliers">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= editSupplier.getId() %>">
                    <% } %>

                    <div class="form-grid">
                        <div class="form-group full-span">
                            <label for="name" class="form-label">Name <span class="required">*</span></label>
                            <input type="text" id="name" name="name" class="form-input" required
                                   value="<%= isEdit ? editSupplier.getName() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="phone" class="form-label">Phone</label>
                            <input type="tel" id="phone" name="phone" class="form-input"
                                   value="<%= isEdit && editSupplier.getPhone() != null ? editSupplier.getPhone() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" id="email" name="email" class="form-input"
                                   value="<%= isEdit && editSupplier.getEmail() != null ? editSupplier.getEmail() : "" %>">
                        </div>

                        <div class="form-group full-span">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" id="address" name="address" class="form-input"
                                   value="<%= isEdit && editSupplier.getAddress() != null ? editSupplier.getAddress() : "" %>">
                        </div>

                        <% if (isEdit) { %>
                        <div class="form-group">
                            <label for="status" class="form-label">Status</label>
                            <select id="status" name="status" class="form-input">
                                <option value="true" <%= editSupplier.isStatus() ? "selected" : "" %>>Active</option>
                                <option value="false" <%= !editSupplier.isStatus() ? "selected" : "" %>>Inactive</option>
                            </select>
                        </div>
                        <% } %>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn--secondary btn--md">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--md"><%= isEdit ? "Update Supplier" : "Create Supplier" %></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>

