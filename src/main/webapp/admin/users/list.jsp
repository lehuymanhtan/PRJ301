<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<User> users = (List<User>) request.getAttribute("users");
    String kw = (String) request.getAttribute("searchKeyword");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <div>
            <h1 class="h3 fw-bold mb-0"><i class="bi bi-people me-2"></i>User Management</h1>
            <p class="text-muted small">Manage users, permissions, and loyalty overview</p>
        </div>
        <div class="d-flex gap-2 align-items-center flex-wrap">
            <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/admin/users">
                <input type="text" name="q" class="form-control form-control-sm" placeholder="Search by username"
                       value="<%= kw != null ? kw : "" %>" style="min-width:200px">
                <button type="submit" class="btn btn-sm btn-outline-primary"><i class="bi bi-search me-1"></i>Search</button>
                <% if (kw != null && !kw.isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-secondary">Clear</a>
                <% } %>
            </form>
            <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-success btn-sm">
                <i class="bi bi-plus-circle me-1"></i>Add User
            </a>
        </div>
    </div>

    <% if (success != null) { %><div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i><%= "created".equals(success) ? "User created." : "updated".equals(success) ? "User updated." : "User deleted." %></div><% } %>
    <% if (errParam != null) { %><div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= "notfound".equals(errParam) ? "User not found." : "Error: " + errParam %></div><% } %>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table admin-table table-hover mb-0">
                <thead><tr><th>ID</th><th>Username</th><th>Password</th><th>Role</th><th>Points</th><th>Tier</th><th>Actions</th></tr></thead>
                <tbody>
                    <% if (users == null || users.isEmpty()) { %>
                        <tr><td colspan="7" class="text-center py-4 text-muted"><i class="bi bi-person me-2"></i>No users found.</td></tr>
                    <% } else { for (User u : users) { %>
                    <tr>
                        <td><span class="fw-semibold text-orange">#<%= u.getUserId() %></span></td>
                        <td><strong><%= u.getUsername() %></strong></td>
                        <td><small class="text-muted font-monospace"><%= u.getPassword() %></small></td>
                        <td><span class="badge <%= "admin".equalsIgnoreCase(u.getRole()) ? "bg-danger" : "bg-secondary" %>"><%= u.getRole() %></span></td>
                        <td><span class="fw-semibold text-orange"><%= String.format("%,d", u.getPoints()) %></span></td>
                        <td><span class="badge bg-light text-dark border"><%= u.getMembershipTier() %></span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= u.getUserId() %>" class="btn btn-sm btn-outline-primary me-1">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/point-history?userId=<%= u.getUserId() %>" class="btn btn-sm btn-outline-info me-1">Points</a>
                            <% if (!u.getUserId().equals(currentUser.getUserId())) { %>
                                <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= u.getUserId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Delete user <%= u.getUsername().replace("'", "\\'") %>?')">Delete</a>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <% 
        Long totalPages = (Long) request.getAttribute("totalPages");
        Integer pageNumber = (Integer) request.getAttribute("pageNumber");
        String queryString = (kw != null && !kw.isEmpty()) ? "&q=" + java.net.URLEncoder.encode(kw, "UTF-8") : "";
    %>
    <% if (totalPages != null && totalPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <% if (pageNumber > 1) { %>
                <li class="page-item"><a class="page-link" href="?page=1<%= queryString %>">First</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber - 1 %><%= queryString %>">← Prev</a></li>
            <% } %>
            
            <%
                long startPage = Math.max(1, pageNumber - 2);
                long endPage = Math.min(totalPages, pageNumber + 2);
                
                if (startPage > 1) {
            %>
                    <li class="page-item"><a class="page-link" href="?page=1<%= queryString %>">1</a></li>
                    <% if (startPage > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                    <% } %>
            <%  }
                for (long i = startPage; i <= endPage; i++) {
            %>
                    <li class="page-item <%= (i == pageNumber) ? "active" : "" %>">
                        <a class="page-link" href="?page=<%= i %><%= queryString %>"><%= i %></a>
                    </li>
            <%  }
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
            %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
            <%      } %>
                    <li class="page-item"><a class="page-link" href="?page=<%= totalPages %><%= queryString %>"><%= totalPages %></a></li>
            <%  } %>

            <% if (pageNumber < totalPages) { %>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber + 1 %><%= queryString %>">Next →</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= totalPages %><%= queryString %>">Last</a></li>
            <% } %>
        </ul>
    </nav>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
