<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Category, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo">Ruby Tech Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Shop</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h3 fw-bold mb-0"><i class="bi bi-tags me-2"></i>Category Management</h1>
            <p class="text-muted small">Manage product categories</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/categories?action=create" class="btn btn-success">
            <i class="bi bi-plus-circle me-2"></i>Add Category
        </a>
    </div>

    <% if ("created".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Category created successfully.</div><% } %>
    <% if ("updated".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Category updated successfully.</div><% } %>
    <% if ("deleted".equals(success)) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Category deleted successfully.</div><% } %>
    <% if (errParam != null) { %><div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= "notfound".equals(errParam) ? "Category not found." : "Error: " + errParam %></div><% } %>

    <div class="card shadow-sm" style="max-width: 900px;">
        <div class="card-body p-0">
            <table class="table admin-table table-hover mb-0">
                <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th style="width: 150px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (categories == null || categories.isEmpty()) { %>
                        <tr><td colspan="4" class="text-center py-4 text-muted"><i class="bi bi-tag me-2"></i>No categories found. <a href="${pageContext.request.contextPath}/admin/categories?action=create">Add your first category</a></td></tr>
                    <% } else { for (Category c : categories) { %>
                    <tr>
                        <td><span class="fw-semibold text-orange">#<%= c.getId() %></span></td>
                        <td class="fw-semibold"><%= c.getName() %></td>
                        <td class="text-muted text-truncate" style="max-width: 300px;"><%= c.getDescription() != null ? c.getDescription() : "-" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=<%= c.getId() %>" class="btn btn-sm btn-outline-primary me-1">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=<%= c.getId() %>"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Delete category <%= c.getName().replace("'", "\\'") %>?')">Delete</a>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
