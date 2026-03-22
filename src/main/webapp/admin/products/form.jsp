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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
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
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4" style="max-width:780px">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Product List
        </a>
    </div>
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-box-seam me-2"></i><%= isEdit ? "Edit Product" : "Create Product" %></h1>
    <p class="text-muted mb-4">Configure inventory details and supplier mapping</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/products" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                <% if (isEdit) { %><input type="hidden" name="id" value="<%= editProduct.getId() %>"><% } %>

                <div class="row g-3">
                    <div class="col-12">
                        <label for="name" class="form-label fw-semibold">Name <span class="text-danger">*</span></label>
                        <input type="text" id="name" name="name" class="form-control" required
                               value="<%= isEdit ? editProduct.getName() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="price" class="form-label fw-semibold">Price (VND) <span class="text-danger">*</span></label>
                        <input type="number" id="price" name="price" class="form-control" required min="0" step="1"
                               value="<%= isEdit ? (long)editProduct.getPrice() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="stock" class="form-label fw-semibold">Stock <span class="text-danger">*</span></label>
                        <input type="number" id="stock" name="stock" class="form-control" required min="0"
                               value="<%= isEdit ? editProduct.getStock() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="category" class="form-label fw-semibold">Category</label>
                        <input type="text" id="category" name="category" class="form-control"
                               value="<%= isEdit && editProduct.getCategory() != null ? editProduct.getCategory() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="importDate" class="form-label fw-semibold">Import Date</label>
                        <input type="date" id="importDate" name="importDate" class="form-control"
                               value="<%= isEdit && editProduct.getImportDate() != null ? editProduct.getImportDate() : "" %>">
                    </div>
                    <div class="col-12">
                        <label for="supplierId" class="form-label fw-semibold">Supplier</label>
                        <select id="supplierId" name="supplierId" class="form-select">
                            <option value="">-- None --</option>
                            <% if (suppliers != null) { for (Supplier s : suppliers) {
                                boolean selected = isEdit && editProduct.getSupplier() != null
                                    && editProduct.getSupplier().getId().equals(s.getId()); %>
                                <option value="<%= s.getId() %>" <%= selected ? "selected" : "" %>><%= s.getName() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-12">
                        <label for="image" class="form-label fw-semibold">Product Image</label>
                        <input type="file" id="image" name="image" class="form-control" accept="image/*">
                        <% if (isEdit && editProduct.getImagePath() != null && !editProduct.getImagePath().isEmpty()) { %>
                            <div class="mt-2">
                                <img src="${pageContext.request.contextPath}/<%= editProduct.getImagePath() %>" alt="Current Image" class="img-thumbnail" style="max-height: 120px;">
                                <p class="text-muted small mt-1">Current image will be kept if no new file is selected.</p>
                            </div>
                        <% } %>
                    </div>
                    <div class="col-12">
                        <label for="description" class="form-label fw-semibold">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4"><%= isEdit && editProduct.getDescription() != null ? editProduct.getDescription() : "" %></textarea>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-rt-primary"><i class="bi bi-floppy me-2"></i><%= isEdit ? "Update Product" : "Create Product" %></button>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary"><i class="bi bi-x me-1"></i>Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
