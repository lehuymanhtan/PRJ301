<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String cartMessage = (String) request.getAttribute("cartMessage");
%>

<!-- Header Navigation -->
<div class="main-container">
    <div class="header">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/cart">Cart</a>
                <a href="${pageContext.request.contextPath}/orders">Orders</a>
                <% if ("admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                <% } %>
            <% } %>
        </div>

        <div class="user-section">
            <% if (currentUser != null) { %>
                <span class="user-name"><%= currentUser.getName() %></span>
                <a href="${pageContext.request.contextPath}/users">Profile</a>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
            <% } %>
        </div>
    </div>
</div>

<!-- Hero Section -->
<div class="hero">
    <div class="hero-content">
        <h1>Next-Gen Tech is Here 🚀</h1>
        <p>Discover cutting-edge technology and upgrade your digital lifestyle with our premium product collection.</p>

        <div class="hero-buttons">
            <a href="#products" class="btn-hero-primary">🛍️ Shop Now</a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/cart" class="btn-hero-secondary">🛒 View Cart</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/register" class="btn-hero-secondary">✨ Join Now</a>
            <% } %>
        </div>
    </div>
</div>

<div class="main-container">
    <!-- Success Messages -->
    <% if (cartMessage != null) { %>
        <div class="alert-message">
            🛒 <%= cartMessage %>
        </div>
    <% } %>

    <!-- Section Title -->
    <div class="section-title" id="products">Featured Products</div>

        <!-- Products Grid -->
        <% if (products == null || products.isEmpty()) { %>
            <div class="surface-card">
                <div class="empty-state">
                    <div class="empty-state-icon">📦</div>
                    <div class="empty-state-title">No Products Available</div>
                    <p>We're working on adding more products to our catalog. Please check back soon!</p>
                    <div class="mt-lg">
                        <a href="${pageContext.request.contextPath}/" class="btn btn--primary">
                            🏠 Go Home
                        </a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="products-container">
                <% for (Product p : products) { %>
                    <div class="surface-card product-card">
                        <!-- Product Header -->
                        <div class="product-header">
                            <div class="product-name"><%= p.getName() %></div>
                            <div class="product-price">
                                💰 <%= String.format("%,.0f", p.getPrice()) %> ₫
                            </div>
                        </div>

                        <!-- Product Description -->
                        <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                            <div class="product-description">
                                <%= p.getDescription() %>
                            </div>
                        <% } %>

                        <!-- Stock Information -->
                        <div class="product-stock">
                            <% if (p.getStock() <= 0) { %>
                                <span class="stock-out">❌ Out of Stock</span>
                            <% } else if (p.getStock() <= 10) { %>
                                <span class="stock-low">⚠️ Low Stock: <%= p.getStock() %> remaining</span>
                            <% } else { %>
                                <span class="stock-available">✅ In Stock: <%= p.getStock() %> available</span>
                            <% } %>
                        </div>

                        <!-- Add to Cart Form -->
                        <% if (p.getStock() > 0) { %>
                            <form class="add-to-cart-form" action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <input type="hidden" name="action" value="add">
                                <input type="number"
                                       name="quantity"
                                       value="1"
                                       min="1"
                                       max="<%= p.getStock() %>"
                                       class="quantity-input"
                                       title="Quantity">
                                <button type="submit" class="btn btn--success btn--md add-to-cart-btn">
                                    🛒 Add to Cart
                                </button>
                            </form>
                        <% } else { %>
                            <div class="btn btn--ghost btn--md">
                                🚫 Unavailable
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Pagination -->
        <%
            Long totalPages = (Long) request.getAttribute("totalPages");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            if (totalPages != null && totalPages > 1) {
        %>
            <div class="pagination-container">
                <% if (pageNumber > 1) { %>
                    <a href="${pageContext.request.contextPath}/products?page=1" class="btn btn--secondary btn--sm pagination-btn">
                        ⏮️ First
                    </a>
                    <a href="${pageContext.request.contextPath}/products?page=<%= pageNumber - 1 %>" class="btn btn--secondary btn--sm pagination-btn">
                        ⬅️ Previous
                    </a>
                <% } %>

                <div class="pagination-info">
                    📄 Page <%= pageNumber %> of <%= totalPages %>
                </div>

                <% if (pageNumber < totalPages) { %>
                    <a href="${pageContext.request.contextPath}/products?page=<%= pageNumber + 1 %>" class="btn btn--secondary btn--sm pagination-btn">
                        Next ➡️
                    </a>
                    <a href="${pageContext.request.contextPath}/products?page=<%= totalPages %>" class="btn btn--secondary btn--sm pagination-btn">
                        Last ⏭️
                    </a>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate product cards
            const productCards = document.querySelectorAll('.product-card');
            productCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100 + 200);
            });

            // Enhanced quantity input validation
            const quantityInputs = document.querySelectorAll('.quantity-input');
            quantityInputs.forEach(input => {
                input.addEventListener('input', function() {
                    const max = parseInt(this.getAttribute('max'));
                    const min = parseInt(this.getAttribute('min'));
                    let value = parseInt(this.value);

                    if (value > max) {
                        this.value = max;
                        this.style.borderColor = 'var(--warning)';
                        setTimeout(() => {
                            this.style.borderColor = '';
                        }, 1000);
                    } else if (value < min) {
                        this.value = min;
                    }
                });
            });

            // Add to cart form enhancement
            const addToCartForms = document.querySelectorAll('.add-to-cart-form');
            addToCartForms.forEach(form => {
                form.addEventListener('submit', function() {
                    const button = this.querySelector('button[type="submit"]');
                    const originalText = button.innerHTML;

                    // Add loading state
                    button.disabled = true;
                    button.innerHTML = '<span class="loading-spinner loading-spinner--sm"></span> Adding...';

                    // Reset after 3 seconds if no redirect happens
                    setTimeout(() => {
                        button.disabled = false;
                        button.innerHTML = originalText;
                    }, 3000);
                });
            });
        });
    </script>

</body>
</html>
