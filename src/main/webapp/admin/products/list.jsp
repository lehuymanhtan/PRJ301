<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Product Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .msg-success { color: green; margin-bottom: 10px; }
        .msg-error   { color: red;   margin-bottom: 10px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        a.btn { display: inline-block; padding: 4px 10px; margin-right: 5px;
                text-decoration: none; border: 1px solid #999; border-radius: 3px; }
        a.btn-add  { background: #4caf50; color: white; border-color: #4caf50; }
        a.btn-edit { background: #2196f3; color: white; border-color: #2196f3; }
        a.btn-del  { background: #f44336; color: white; border-color: #f44336; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<h1>Admin - Product Management</h1>
<nav>
    Welcome, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong> |
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/users">User Management</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Product Management</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Supplier Management</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if ("created".equals(success)) { %><p class="msg-success">Product created successfully.</p><% } %>
<% if ("updated".equals(success)) { %><p class="msg-success">Product updated successfully.</p><% } %>
<% if ("deleted".equals(success)) { %><p class="msg-success">Product deleted successfully.</p><% } %>
<% if ("notfound".equals(errParam)) { %><p class="msg-error">Product not found.</p><% } %>
<% if (errParam != null && !"notfound".equals(errParam)) { %><p class="msg-error">Error: <%= errParam %></p><% } %>

<div style="margin-bottom:15px;">
    <a href="${pageContext.request.contextPath}/admin/products?action=create" class="btn btn-add">+ Add Product</a>
</div>

<table>
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
            <tr><td colspan="8">No products found.</td></tr>
        <% } else {
            for (Product p : products) { %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getName() %></td>
                <td><%= String.format("%,.0f", p.getPrice()) %> ₫</td>
                <td><%= p.getStock() %></td>
                <td><%= p.getCategory() != null ? p.getCategory() : "" %></td>
                <td><%= p.getImportDate() != null ? p.getImportDate() : "" %></td>
                <td><%= p.getSupplier() != null ? p.getSupplier().getName() : "-" %></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= p.getId() %>" class="btn btn-edit">Edit</a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=<%= p.getId() %>"
                       class="btn btn-del"
                       onclick="return confirm('Delete product <%= p.getName() %>?')">Delete</a>
                </td>
            </tr>
        <% } } %>
    </tbody>
</table>

<%
    Long totalPages = (Long) request.getAttribute("totalPages");
    Integer pageNumber = (Integer) request.getAttribute("pageNumber");
    if (totalPages != null && totalPages > 1) {
%>
<div style="margin-top: 20px; text-align: center;">
    <% if (pageNumber > 1) { %>
        <a href="${pageContext.request.contextPath}/admin/products?page=1" class="btn">First</a>
        <a href="${pageContext.request.contextPath}/admin/products?page=<%= pageNumber - 1 %>" class="btn">Previous</a>
    <% } %>
    <span style="margin: 0 10px;">Page <%= pageNumber %> of <%= totalPages %></span>
    <% if (pageNumber < totalPages) { %>
        <a href="${pageContext.request.contextPath}/admin/products?page=<%= pageNumber + 1 %>" class="btn">Next</a>
        <a href="${pageContext.request.contextPath}/admin/products?page=<%= totalPages %>" class="btn">Last</a>
    <% } %>
</div>
<% } %>
</body>
</html>
