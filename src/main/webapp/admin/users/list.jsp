<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Ruby Tech Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <style>
        .table-container { overflow-x: auto; }
        .user-table { width: 100%; border-collapse: collapse; font-size: var(--text-sm); }
        .user-table th,
        .user-table td {
            padding: var(--space-3) var(--space-4);
            text-align: left;
            border-bottom: 1px solid var(--border-primary);
            vertical-align: middle;
        }
        .user-table th {
            background: var(--surface-tertiary);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            font-size: var(--text-xs);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .user-table tr:hover { background: rgba(59, 130, 246, 0.04); }
        .user-actions { display: flex; gap: var(--space-2); align-items: center; flex-wrap: wrap; }
        .search-form {
            display: flex;
            align-items: center;
            gap: var(--space-3);
            width: 100%;
            max-width: 640px;
        }
        .tier-pill {
            display: inline-flex;
            align-items: center;
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-full);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-semibold);
            background: var(--surface-tertiary);
            color: var(--text-primary);
        }
    </style>
</head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    List<User> users = (List<User>) request.getAttribute("users");
    String kw = (String) request.getAttribute("searchKeyword");
    String success = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">User Management</h1>
            <p class="dashboard-subtitle">Manage users, permissions, and loyalty overview</p>
        </div>

        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
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
        <% if ("created".equals(success)) { %>
            <div class="message message--success mb-lg">✅ User created successfully.</div>
        <% } %>
        <% if ("updated".equals(success)) { %>
            <div class="message message--success mb-lg">✅ User updated successfully.</div>
        <% } %>
        <% if ("deleted".equals(success)) { %>
            <div class="message message--success mb-lg">✅ User deleted successfully.</div>
        <% } %>
        <% if ("notfound".equals(errParam)) { %>
            <div class="message message--danger mb-lg">❌ User not found.</div>
        <% } %>
        <% if (errParam != null && !"notfound".equals(errParam)) { %>
            <div class="message message--danger mb-lg">❌ Error: <%= errParam %></div>
        <% } %>

        <div class="flex justify-between items-center mb-lg" style="gap: var(--space-3); flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn--success btn--md">+ Add User</a>

            <form class="search-form" method="get" action="${pageContext.request.contextPath}/admin/users">
                <input type="text" name="q" class="form-input" placeholder="Search by username"
                       value="<%= kw != null ? kw : "" %>">
                <button type="submit" class="btn btn--primary btn--sm">Search</button>
                <% if (kw != null && !kw.isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn--secondary btn--sm">Clear</a>
                <% } %>
            </form>
        </div>

        <div class="surface-card">
            <div class="table-container">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Password</th>
                            <th>Role</th>
                            <th>Points</th>
                            <th>Tier</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (users == null || users.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center py-xl">
                                    <div class="text-secondary">👤 No users found.</div>
                                </td>
                            </tr>
                        <% } else {
                            for (User u : users) { %>
                            <tr>
                                <td><span class="font-semibold text-primary">#<%= u.getUserId() %></span></td>
                                <td><span class="font-medium text-primary"><%= u.getUsername() %></span></td>
                                <td><span class="text-secondary"><%= u.getPassword() %></span></td>
                                <td><span class="text-secondary"><%= u.getRole() %></span></td>
                                <td><span class="font-semibold text-primary"><%= String.format("%,d", u.getPoints()) %></span></td>
                                <td><span class="tier-pill"><%= u.getMembershipTier() %></span></td>
                                <td>
                                    <div class="user-actions">
                                        <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= u.getUserId() %>"
                                           class="btn btn--primary btn--xs">Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/point-history?userId=<%= u.getUserId() %>"
                                           class="btn btn--info btn--xs">Points</a>
                                        <% if (!u.getUserId().equals(currentUser.getUserId())) { %>
                                            <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= u.getUserId() %>"
                                               class="btn btn--danger btn--xs"
                                               onclick="return confirm('Delete user <%= u.getUsername().replace("'", "\\'") %>?')">Delete</a>
                                        <% } %>
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

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>

