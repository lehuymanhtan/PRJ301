<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .msg-success { color: green; margin-bottom: 10px; }
        .msg-error   { color: red;   margin-bottom: 10px; }
        .search-form { margin-bottom: 15px; }
        .search-form input[type="text"] { padding: 5px; width: 250px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        a.btn { display: inline-block; padding: 4px 10px; margin-right: 5px;
                text-decoration: none; border: 1px solid #999; border-radius: 3px; }
        a.btn-add   { background: #4caf50; color: white; border-color: #4caf50; }
        a.btn-edit  { background: #2196f3; color: white; border-color: #2196f3; }
        a.btn-del   { background: #f44336; color: white; border-color: #f44336; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<User> users = (List<User>) request.getAttribute("users");
    String kw      = (String) request.getAttribute("searchKeyword");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<h1>Admin - User Management</h1>
<nav>
    Welcome, <strong><%= currentUser.getUsername() %></strong> |
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/users">User Management</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Product Management</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Supplier Management</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if ("created".equals(success)) { %><p class="msg-success">User created successfully.</p><% } %>
<% if ("updated".equals(success)) { %><p class="msg-success">User updated successfully.</p><% } %>
<% if ("deleted".equals(success)) { %><p class="msg-success">User deleted successfully.</p><% } %>
<% if ("notfound".equals(errParam)) { %><p class="msg-error">User not found.</p><% } %>
<% if (errParam != null && !"notfound".equals(errParam)) { %><p class="msg-error">Error: <%= errParam %></p><% } %>

<div>
    <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-add">+ Add User</a>
</div>

<form class="search-form" method="get" action="${pageContext.request.contextPath}/admin/users">
    <input type="text" name="q" placeholder="Search by username"
           value="<%= kw != null ? kw : "" %>">
    <button type="submit">Search</button>
    <% if (kw != null && !kw.isEmpty()) { %>
        <a href="${pageContext.request.contextPath}/admin/users">Clear</a>
    <% } %>
</form>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Password</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% if (users == null || users.isEmpty()) { %>
            <tr><td colspan="5">No users found.</td></tr>
        <% } else {
            for (User u : users) { %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getPassword() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= u.getUserId() %>" class="btn btn-edit">Edit</a>
                    <% if (!u.getUserId().equals(currentUser.getUserId())) { %>
                        <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= u.getUserId() %>"
                           class="btn btn-del"
                           onclick="return confirm('Delete user <%= u.getUsername() %>?')">Delete</a>
                    <% } %>
                </td>
            </tr>
        <% } } %>
    </tbody>
</table>
</body>
</html>
