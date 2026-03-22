<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Supplier, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body class="bg-light">

<%
    User currentUser = (User) session.getAttribute("user");
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
    String success  = request.getParameter("success");
    String errParam = request.getParameter("error");
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Go to Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= currentUser != null ? currentUser.getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-building me-2"></i>Supplier Management</h1>
    <p class="text-muted mb-4">Manage your business partners and suppliers</p>

    <!-- Messages -->
    <% if ("created".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>Supplier created successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if ("updated".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>Supplier updated successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if ("deleted".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>Supplier deleted successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if ("notfound".equals(errParam)) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>Supplier not found.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if (errParam != null && !"notfound".equals(errParam)) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>Error: <%= errParam %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <!-- Actions Bar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="${pageContext.request.contextPath}/admin/suppliers?action=create" class="btn btn-success">
            <i class="bi bi-plus-lg me-1"></i> Add Supplier
        </a>
    </div>

    <!-- Suppliers Table -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
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
                                <td colspan="6" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="bi bi-shop fs-1 text-secondary mb-3 d-block"></i>
                                        No suppliers found.
                                        <br>
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=create" class="text-primary text-decoration-none mt-2 d-inline-block">Add your first supplier</a>
                                    </div>
                                </td>
                            </tr>
                        <% } else {
                            for (Supplier s : suppliers) { %>
                            <tr>
                                <td>
                                    <span class="fw-semibold text-primary">#<%= s.getId() %></span>
                                </td>
                                <td>
                                    <div class="fw-bold"><%= s.getName() %></div>
                                </td>
                                <td>
                                    <div class="small">
                                        <% if (s.getPhone() != null && !s.getPhone().isEmpty()) { %>
                                            <div><i class="bi bi-telephone me-1 text-muted"></i><%= s.getPhone() %></div>
                                        <% } %>
                                        <% if (s.getEmail() != null && !s.getEmail().isEmpty()) { %>
                                            <div><i class="bi bi-envelope me-1 text-muted"></i><%= s.getEmail() %></div>
                                        <% } %>
                                        <% if ((s.getPhone() == null || s.getPhone().isEmpty()) &&
                                               (s.getEmail() == null || s.getEmail().isEmpty())) { %>
                                            <span class="text-muted fst-italic">No contact info</span>
                                        <% } %>
                                    </div>
                                </td>
                                <td>
                                    <div class="text-truncate" style="max-width: 250px;" title="<%= s.getAddress() != null ? s.getAddress().replace("\"", "&quot;") : "" %>">
                                        <%= s.getAddress() != null && !s.getAddress().isEmpty() ? s.getAddress() : "<span class='text-muted fst-italic'>No address</span>" %>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge <%= s.isStatus() ? "bg-success" : "bg-secondary" %>">
                                        <i class="bi <%= s.isStatus() ? "bi-check-circle" : "bi-x-circle" %> me-1"></i><%= s.isStatus() ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=edit&id=<%= s.getId() %>"
                                           class="btn btn-outline-primary btn-sm" title="Edit">
                                           <i class="bi bi-pencil-square"></i> Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/suppliers?action=delete&id=<%= s.getId() %>"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Delete supplier <%= s.getName().replace("'", "\\'") %>?\n\nThis will also remove the supplier from all associated products.')"
                                           title="Delete">
                                           <i class="bi bi-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <% 
        Long totalPages = (Long) request.getAttribute("totalPages");
        Integer pageNumber = (Integer) request.getAttribute("pageNumber");
        String queryString = "";
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
</body>
</html>
