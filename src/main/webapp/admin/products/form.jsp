<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Product, models.Supplier, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        Product editProduct = (Product) request.getAttribute("product");
        List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
        boolean isEdit = (editProduct != null);
    %>
    <title><%= isEdit ? "Edit Product" : "Add Product" %> - Ruby Tech Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
<body class="bg-surface-secondary">
<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title"><%= isEdit ? "Edit Product" : "Create Product" %></h1>
            <p class="dashboard-subtitle">Configure inventory details and supplier mapping</p>
        </div>
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="active">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
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
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn--secondary btn--sm">← Back to Product List</a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--danger mb-lg">❌ <%= request.getAttribute("error") %></div>
            <% } %>

            <div class="surface-card surface-card--form">
                <form method="post" action="${pageContext.request.contextPath}/admin/products">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= editProduct.getId() %>">
                    <% } %>

                    <div class="form-grid">
                        <div class="form-group full-span">
                            <label for="name" class="form-label">Name <span class="required">*</span></label>
                            <input type="text" id="name" name="name" class="form-input" required
                                   value="<%= isEdit ? editProduct.getName() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="price" class="form-label">Price (VND) <span class="required">*</span></label>
                            <input type="number" id="price" name="price" class="form-input" required min="0" step="1"
                                   value="<%= isEdit ? (long) editProduct.getPrice() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="stock" class="form-label">Stock <span class="required">*</span></label>
                            <input type="number" id="stock" name="stock" class="form-input" required min="0"
                                   value="<%= isEdit ? editProduct.getStock() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="category" class="form-label">Category</label>
                            <input type="text" id="category" name="category" class="form-input"
                                   value="<%= isEdit && editProduct.getCategory() != null ? editProduct.getCategory() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="importDate" class="form-label">Import Date</label>
                            <input type="date" id="importDate" name="importDate" class="form-input"
                                   value="<%= isEdit && editProduct.getImportDate() != null ? editProduct.getImportDate() : "" %>">
                        </div>

                        <div class="form-group full-span">
                            <label for="supplierId" class="form-label">Supplier</label>
                            <select id="supplierId" name="supplierId" class="form-input">
                                <option value="">-- None --</option>
                                <% if (suppliers != null) {
                                    for (Supplier s : suppliers) {
                                        boolean selected = isEdit && editProduct.getSupplier() != null
                                                && editProduct.getSupplier().getId().equals(s.getId());
                                %>
                                    <option value="<%= s.getId() %>" <%= selected ? "selected" : "" %>><%= s.getName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group full-span">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-input description-box"><%= isEdit && editProduct.getDescription() != null ? editProduct.getDescription() : "" %></textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn--secondary btn--md">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--md"><%= isEdit ? "Update Product" : "Create Product" %></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
