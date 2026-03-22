<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Cart, models.CartItem, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    Cart cart        = (Cart) request.getAttribute("cart");
    String cartMessage  = (String) request.getAttribute("cartMessage");
    String stockMessage = (String) request.getAttribute("stockMessage");
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/cart">Cart</a></li>
            </ul>
            <form class="d-flex mx-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search product..." aria-label="Search" value="${not empty keyword ? keyword : ''}">
                <button class="btn btn-outline-light" type="submit"><i class="bi bi-search"></i></button>
            </form>
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
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Page Content -->
<div class="container py-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-cart3 me-2"></i>Shopping Cart</h1>
    <p class="text-muted mb-4">Review your items before checkout</p>

    <!-- Messages -->
    <% if (cartMessage != null) { %>
        <div class="alert alert-success alert-dismissible fade show auto-dismiss" role="alert">
            <i class="bi bi-check-circle me-2"></i><%= cartMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if (stockMessage != null) { %>
        <div class="alert alert-warning alert-dismissible fade show auto-dismiss" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i><%= stockMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Cart Content -->
    <% if (cart == null || cart.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-cart-x" style="font-size:4rem; color:#cbd5e1"></i>
            <h3 class="mt-3 text-muted">Your Cart is Empty</h3>
            <p class="text-muted">Start shopping to add items to your cart.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-rt-primary btn-lg">
                <i class="bi bi-bag me-2"></i>Browse Products
            </a>
        </div>
    <% } else { %>
        <div class="row g-4">
            <!-- Cart Items -->
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>Product</th>
                                    <th>Unit Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    double grandTotal = 0;
                                    for (CartItem item : cart) {
                                        grandTotal += item.getSubtotal();
                                %>
                                <tr class="cart-item">
                                    <td>
                                        <div class="fw-semibold"><%= item.getProduct().getName() %></div>
                                    </td>
                                    <td class="text-muted"><%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫</td>
                                    <td style="width:160px">
                                        <form class="d-flex gap-1" action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                            <input type="hidden" name="action" value="update">
                                            <input type="number"
                                                   name="quantity"
                                                   value="<%= item.getQuantity() %>"
                                                   min="1"
                                                   max="<%= item.getProduct().getStock() %>"
                                                   class="form-control form-control-sm qty-input"
                                                   style="width:65px">
                                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-arrow-repeat"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="fw-semibold text-orange"><%= String.format("%,.0f", item.getSubtotal()) %> ₫</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                            <input type="hidden" name="action" value="remove">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Remove this item from cart?')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Order Summary Sidebar -->
            <div class="col-lg-4 summary-sidebar">
                <div class="card shadow-sm">
                    <div class="card-header bg-navy text-white fw-bold">
                        <i class="bi bi-receipt me-2"></i>Order Summary
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Items:</span>
                            <span class="fw-semibold"><%= cart.size() %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal:</span>
                            <span class="fw-semibold"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="fw-bold">Total:</span>
                            <span class="fw-bold fs-5 text-orange"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                        </div>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-rt-primary btn-lg">
                                <i class="bi bi-credit-card me-2"></i>Proceed to Checkout
                            </a>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                                <i class="bi bi-bag me-2"></i>Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
