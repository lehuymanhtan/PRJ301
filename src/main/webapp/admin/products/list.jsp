<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
    Long totalPages   = (Long)    request.getAttribute("totalPages");
    Integer pageNumber = (Integer) request.getAttribute("pageNumber");
%>

<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo">Ruby Tech Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h3 fw-bold mb-0"><i class="bi bi-box-seam me-2"></i>Product Management</h1>
            <p class="text-muted small">Manage your product inventory</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products?action=create" class="btn btn-success">
            <i class="bi bi-plus-circle me-2"></i>Add Product
        </a>
    </div>

    <% if ("created".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Product created successfully.</div><% } %>
    <% if ("updated".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Product updated successfully.</div><% } %>
    <% if ("deleted".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Product deleted successfully.</div><% } %>
    <% if (errParam != null) { %><div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= "notfound".equals(errParam) ? "Product not found." : "Error: " + errParam %></div><% } %>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table admin-table table-hover mb-0">
                <thead>
                    <tr>
                        <th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Category</th><th>Import Date</th><th>Supplier</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products == null || products.isEmpty()) { %>
                        <tr><td colspan="8" class="text-center py-4 text-muted"><i class="bi bi-box me-2"></i>No products found. <a href="${pageContext.request.contextPath}/admin/products?action=create">Add your first product</a></td></tr>
                    <% } else { for (Product p : products) {
                        int stock = p.getStock();
                        String stockClass = stock > 50 ? "bg-success" : stock > 10 ? "bg-warning text-dark" : "bg-danger";
                    %>
                    <tr>
                        <td><span class="fw-semibold text-orange">#<%= p.getId() %></span></td>
                        <td><%= p.getName() %></td>
                        <td class="fw-semibold text-orange"><%= String.format("%,.0f", p.getPrice()) %> ₫</td>
                        <td><span class="badge <%= stockClass %>"><%= stock %></span></td>
                        <td><% if (p.getCategory() != null && !p.getCategory().isEmpty()) { %><span class="badge bg-light text-dark border"><%= p.getCategory() %></span><% } else { %>-<% } %></td>
                        <td><small class="text-muted"><%= p.getImportDate() != null ? p.getImportDate().toString() : "-" %></small></td>
                        <td><%= p.getSupplier() != null ? p.getSupplier().getName() : "-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= p.getId() %>" class="btn btn-sm btn-outline-primary me-1">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=<%= p.getId() %>"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Delete product <%= p.getName().replace("'", "\\'") %>?')">Delete</a>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <% if (totalPages != null && totalPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <% if (pageNumber > 1) { %>
                <li class="page-item"><a class="page-link" href="?page=1">First</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber - 1 %>">← Prev</a></li>
            <% } %>
            <li class="page-item disabled"><span class="page-link">Page <%= pageNumber %> of <%= totalPages %></span></li>
            <% if (pageNumber < totalPages) { %>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber + 1 %>">Next →</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= totalPages %>">Last</a></li>
            <% } %>
        </ul>
    </nav>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
