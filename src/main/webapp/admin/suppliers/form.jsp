<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Supplier, models.User" %>
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

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
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

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <h1 class="h3 fw-bold mb-1"><i class="bi bi-<%= isEdit ? "pencil-square" : "building-add" %> me-2"></i><%= isEdit ? "Edit Supplier" : "Create Supplier" %></h1>
            <p class="text-muted mb-4">Maintain supplier profile and active status</p>

            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Back to Suppliers</a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i><%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/admin/suppliers">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editSupplier.getId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold">Company Name <span class="text-danger">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" required
                                   value="<%= isEdit ? editSupplier.getName() : "" %>">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label fw-semibold">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control"
                                       value="<%= isEdit && editSupplier.getPhone() != null ? editSupplier.getPhone() : "" %>">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label fw-semibold">Email Address</label>
                                <input type="email" id="email" name="email" class="form-control"
                                       value="<%= isEdit && editSupplier.getEmail() != null ? editSupplier.getEmail() : "" %>">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label fw-semibold">Physical Address</label>
                            <input type="text" id="address" name="address" class="form-control"
                                   value="<%= isEdit && editSupplier.getAddress() != null ? editSupplier.getAddress() : "" %>">
                        </div>

                        <% if (isEdit) { %>
                        <div class="mb-4">
                            <label for="status" class="form-label fw-semibold">Status</label>
                            <select id="status" name="status" class="form-select">
                                <option value="true" <%= editSupplier.isStatus() ? "selected" : "" %>>Active</option>
                                <option value="false" <%= !editSupplier.isStatus() ? "selected" : "" %>>Inactive</option>
                            </select>
                        </div>
                        <% } else { %>
                            <div class="mb-4"></div>
                        <% } %>

                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-4">
                            <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn-light border">Cancel</a>
                            <button type="submit" class="btn btn-primary"><span class="bi bi-save me-1"></span><%= isEdit ? "Update Supplier" : "Create Supplier" %></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
