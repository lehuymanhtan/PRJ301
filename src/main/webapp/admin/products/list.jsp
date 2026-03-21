<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Product Management</h1>
            <p class="dashboard-subtitle">Manage your product inventory</p>
        </div>

        <!-- Admin Navigation -->
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

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Messages -->
        <% if ("created".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Product created successfully.
            </div>
        <% } %>
        <% if ("updated".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Product updated successfully.
            </div>
        <% } %>
        <% if ("deleted".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Product deleted successfully.
            </div>
        <% } %>
        <% if ("notfound".equals(errParam)) { %>
            <div class="message message--danger mb-lg">
                ❌ Product not found.
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
                <a href="${pageContext.request.contextPath}/admin/products?action=create" class="btn btn--success btn--md">
                    + Add Product
                </a>
            </div>
        </div>

        <!-- Products Table -->
        <div class="surface-card">
            <div class="table-container">
                <table class="product-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Category</th>
                            <th>Import Date</th>
                            <th>Supplier</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products == null || products.isEmpty()) { %>
                            <tr>
                                <td colspan="8" class="text-center py-xl">
                                    <div class="text-secondary">
                                        📦 No products found.
                                        <a href="${pageContext.request.contextPath}/admin/products?action=create"
                                           class="text-primary">Add your first product</a>
                                    </div>
                                </td>
                            </tr>
                        <% } else {
                            for (Product p : products) { %>
                            <tr>
                                <td>
                                    <span class="font-semibold text-primary">#<%= p.getId() %></span>
                                </td>
                                <td>
                                    <div class="font-medium"><%= p.getName() %></div>
                                </td>
                                <td>
                                    <span class="price-display"><%= String.format("%,.0f", p.getPrice()) %> ₫</span>
                                </td>
                                <td>
                                    <% int stock = p.getStock(); %>
                                    <span class="stock-badge <%= stock > 50 ? "stock-badge--high" : stock > 10 ? "stock-badge--medium" : "stock-badge--low" %>">
                                        <%= stock %>
                                    </span>
                                </td>
                                <td>
                                    <% if (p.getCategory() != null && !p.getCategory().isEmpty()) { %>
                                        <span class="category-tag"><%= p.getCategory() %></span>
                                    <% } else { %>
                                        <span class="text-tertiary">-</span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="text-secondary font-mono text-xs">
                                        <%= p.getImportDate() != null ? p.getImportDate().toString() : "-" %>
                                    </span>
                                </td>
                                <td>
                                    <span class="text-secondary">
                                        <%= p.getSupplier() != null ? p.getSupplier().getName() : "-" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="product-actions">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= p.getId() %>"
                                           class="btn btn--primary btn--xs">Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=<%= p.getId() %>"
                                           class="btn btn--danger btn--xs"
                                           onclick="return confirm('Delete product <%= p.getName().replace("'", "\\'") %>?')">Delete</a>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <%
            Long totalPages = (Long) request.getAttribute("totalPages");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            if (totalPages != null && totalPages > 1) {
        %>
        <div class="pagination-container">
            <% if (pageNumber > 1) { %>
                <a href="${pageContext.request.contextPath}/admin/products?page=1"
                   class="btn btn--secondary btn--sm">First</a>
                <a href="${pageContext.request.contextPath}/admin/products?page=<%= pageNumber - 1 %>"
                   class="btn btn--secondary btn--sm">← Previous</a>
            <% } %>

            <div class="pagination-info">
                Page <%= pageNumber %> of <%= totalPages %>
            </div>

            <% if (pageNumber < totalPages) { %>
                <a href="${pageContext.request.contextPath}/admin/products?page=<%= pageNumber + 1 %>"
                   class="btn btn--secondary btn--sm">Next →</a>
                <a href="${pageContext.request.contextPath}/admin/products?page=<%= totalPages %>"
                   class="btn btn--secondary btn--sm">Last</a>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
