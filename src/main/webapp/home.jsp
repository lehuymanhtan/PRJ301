<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.Category, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String cartMessage = (String) request.getAttribute("cartMessage");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="categoriesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Categories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="categoriesDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products">All Products</a></li>
                        <% if (categories != null) { for (Category c : categories) { %>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/category?id=<%= c.getId() %>"><%= c.getName() %></a></li>
                        <% } } %>
                    </ul>
                </li>
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

    <!-- Hot Products (Low Stock) -->
    <h2 class="section-title mb-4">Hot</h2>
    <%
        java.util.List<Product> hotProducts = new java.util.ArrayList<>();
        if (products != null) {
            for (Product p : products) {
                if (p.getStock() > 0 && p.getStock() <= 25) {
                    hotProducts.add(p);
                }
            }
            // Sort by stock ascending (lowest stock first)
            hotProducts.sort((a, b) -> Integer.compare(a.getStock(), b.getStock()));
            // Keep only first 12
            if (hotProducts.size() > 12) {
                hotProducts = hotProducts.subList(0, 12);
            }
        }
    %>
    <% if (!hotProducts.isEmpty()) { %>
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
            <% for (Product p : hotProducts) { %>
                <div class="col">
                    <div class="card product-card h-100 shadow-sm border-warning-subtle">
                        <img src="${pageContext.request.contextPath}/<%= (p.getImagePath() != null && !p.getImagePath().isEmpty()) ? p.getImagePath() : "assets/img/products/default.jpg" %>" class="card-img-top" alt="<%= p.getName().replace("\"", "&quot;") %>" style="height: 200px; object-fit: contain;">
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
                                <span class="badge badge-low-stock">
                                    <i class="bi bi-fire me-1"></i>Only <%= p.getStock() %> left
                                </span>
                            </div>

                            <!-- Add to Cart -->
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
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <p class="text-muted mb-5">No low-stock products at the moment.</p>
    <% } %>

    <!-- New Arrival Products -->
    <h2 class="section-title mb-4">New Arrival</h2>
    <%
        java.util.List<Product> newArrivalProducts = new java.util.ArrayList<>();
        if (products != null) {
            newArrivalProducts.addAll(products);
            // Sort by ID descending (newest first)
            newArrivalProducts.sort((a, b) -> Integer.compare(b.getId().intValue(), a.getId().intValue()));
            // Keep only first 12
            if (newArrivalProducts.size() > 12) {
                newArrivalProducts = newArrivalProducts.subList(0, 12);
            }
        }
    %>
    <% if (!newArrivalProducts.isEmpty()) { %>
        <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
            <% for (Product p : newArrivalProducts) { %>
                <div class="col">
                    <div class="card product-card h-100 shadow-sm border-success-subtle">
                        <img src="${pageContext.request.contextPath}/<%= (p.getImagePath() != null && !p.getImagePath().isEmpty()) ? p.getImagePath() : "assets/img/products/default.jpg" %>" class="card-img-top" alt="<%= p.getName().replace("\"", "&quot;") %>" style="height: 200px; object-fit: contain;">
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
    <% } else { %>
        <p class="text-muted mb-5">No new arrival products at the moment.</p>
    <% } %>

    <!-- Show More Button -->
    <div class="text-center mt-5">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-rt-primary btn-lg">
            <i class="bi bi-arrow-right me-2"></i>Show More Products
        </a>
    </div>
</div>

<footer class="bg-navy text-white mt-5 py-4">
    <div class="container text-center">
        <p class="mb-1 fw-semibold">Ruby Tech</p>
        <p class="mb-0 small text-white-50">&copy; <%= java.time.Year.now().getValue() %> Ruby Tech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
