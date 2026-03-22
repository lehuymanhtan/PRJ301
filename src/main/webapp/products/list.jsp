<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String cartMessage = (String) request.getAttribute("cartMessage");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/products">Products</a></li>
                <% if (currentUser != null) { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a></li>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <% if (currentUser != null) { %>
                    <% if ("admin".equalsIgnoreCase(currentUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <% } %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white opacity-75" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <%= currentUser.getName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users">Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/points">Point History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="rt-hero">
    <div class="container">
        <h1>Next-Gen Tech is Here 🚀</h1>
        <p>Discover cutting-edge appliances and upgrade your home with our premium product collection.</p>
        <div class="d-flex gap-3 justify-content-center flex-wrap">
            <a href="#products" class="btn btn-rt-primary btn-lg hero-action-btn">
                <i class="bi bi-bag me-2"></i>Shop Now
            </a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-rt-outline btn-lg">
                    <i class="bi bi-cart3 me-2"></i>View Cart
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-rt-outline btn-lg">
                    <i class="bi bi-stars me-2"></i>Join Now
                </a>
            <% } %>
        </div>
    </div>
</section>

<!-- Main Content -->
<div class="container py-5" id="products">
    <!-- Cart Message -->
    <% if (cartMessage != null) { %>
        <div class="alert alert-success alert-dismissible fade show auto-dismiss" role="alert">
            <i class="bi bi-cart-check me-2"></i><%= cartMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <h2 class="section-title mb-4">Featured Products</h2>

    <!-- Products Grid -->
    <% if (products == null || products.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-box-seam" style="font-size:4rem; color:#cbd5e1"></i>
            <h3 class="mt-3 text-muted">No Products Available</h3>
            <p class="text-muted">We're working on adding more products. Please check back soon!</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-rt-primary">
                <i class="bi bi-house me-2"></i>Go Home
            </a>
        </div>
    <% } else { %>
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
            <% for (Product p : products) { %>
                <div class="col">
                    <div class="card product-card h-100 shadow-sm">
                        <img src="${pageContext.request.contextPath}/<%= (p.getImagePath() != null && !p.getImagePath().isEmpty()) ? p.getImagePath() : "assets/img/products/default.jpg" %>" class="card-img-top" alt="<%= p.getName().replace("\"", "&quot;") %>" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= p.getName() %></h5>
                            <p class="product-price mb-2">
                                <i class="bi bi-tag me-1"></i><%= String.format("%,.0f", p.getPrice()) %> ₫
                            </p>

                            <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                                <p class="card-text text-muted small flex-grow-1"><%= p.getDescription() %></p>
                            <% } else { %><div class="flex-grow-1"></div><% } %>

                            <!-- Stock -->
                            <div class="mb-3">
                                <% if (p.getStock() <= 0) { %>
                                    <span class="badge badge-out-of-stock">
                                        <i class="bi bi-x-circle me-1"></i>Out of Stock
                                    </span>
                                <% } else if (p.getStock() <= 10) { %>
                                    <span class="badge badge-low-stock">
                                        <i class="bi bi-exclamation-triangle me-1"></i>Low Stock: <%= p.getStock() %> left
                                    </span>
                                <% } else { %>
                                    <span class="badge badge-in-stock">
                                        <i class="bi bi-check-circle me-1"></i>In Stock: <%= p.getStock() %>
                                    </span>
                                <% } %>
                            </div>

                            <!-- Add to Cart -->
                            <% if (p.getStock() > 0) { %>
                                <form class="add-to-cart-form" action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="hidden" name="action" value="add">
                                    <div class="input-group">
                                        <input type="number"
                                               name="quantity"
                                               value="1"
                                               min="1"
                                               max="<%= p.getStock() %>"
                                               class="form-control qty-input"
                                               style="max-width:80px"
                                               title="Quantity">
                                        <button type="submit" class="btn btn-success">
                                            <i class="bi bi-cart-plus me-1"></i>Add to Cart
                                        </button>
                                    </div>
                                </form>
                            <% } else { %>
                                <button class="btn btn-outline-secondary" disabled>
                                    <i class="bi bi-slash-circle me-2"></i>Unavailable
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Pagination -->
        <%
            Long totalPages = (Long) request.getAttribute("totalPages");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            if (totalPages != null && totalPages > 1) {
        %>
        <nav class="mt-5" aria-label="Product pagination">
            <ul class="pagination justify-content-center">
                <% if (pageNumber > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=1">First</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=<%= pageNumber - 1 %>">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                <% } %>
                
                <%
                    long startPage = Math.max(1, pageNumber - 2);
                    long endPage = Math.min(totalPages, pageNumber + 2);
                    
                    if (startPage > 1) {
                %>
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/products?page=1">1</a></li>
                        <% if (startPage > 2) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                <%  }
                    
                    for (long i = startPage; i <= endPage; i++) {
                %>
                        <li class="page-item <%= (i == pageNumber) ? "active" : "" %>">
                            <a class="page-link" href="${pageContext.request.contextPath}/products?page=<%= i %>"><%= i %></a>
                        </li>
                <%  }
                    
                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) {
                %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                <%      } %>
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/products?page=<%= totalPages %>"><%= totalPages %></a></li>
                <%  } %>

                <% if (pageNumber < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=<%= pageNumber + 1 %>">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=<%= totalPages %>">Last</a>
                    </li>
                <% } %>
            </ul>
        </nav>
        <% } %>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
