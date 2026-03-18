<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Product, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Header Navigation */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-4) var(--space-6);
            background: var(--surface-primary);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: var(--space-lg);
            border-radius: var(--radius-xl);
            backdrop-filter: blur(18px);
            border: 1px solid var(--gray-200);
        }

        .logo {
            font-size: var(--text-xl);
            font-weight: var(--font-weight-bold);
            color: var(--glass-primary);
        }

        .logo-icon {
            margin-right: var(--space-2);
        }

        .nav-menu {
            display: flex;
            gap: var(--space-lg);
            align-items: center;
        }

        .nav-menu a {
            text-decoration: none;
            color: var(--text-secondary);
            font-weight: var(--font-weight-medium);
            font-size: var(--text-sm);
            transition: var(--transition-colors);
            position: relative;
        }

        .nav-menu a:hover {
            color: var(--glass-primary);
            transform: translateY(-1px);
        }

        .nav-menu a:after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--glass-primary);
            transition: width 0.3s ease;
        }

        .nav-menu a:hover:after {
            width: 100%;
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            font-size: var(--text-sm);
        }

        .user-section a {
            text-decoration: none;
            color: var(--text-secondary);
            transition: var(--transition-colors);
            padding: var(--space-2) var(--space-3);
            border-radius: var(--radius-md);
        }

        .user-section a:hover {
            background: var(--glass-primary-light);
            color: var(--glass-primary);
        }

        .user-name {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        /* Hero Section */
        .hero {
            width: 90%;
            margin: var(--space-xl) auto;
            padding: var(--space-3xl) var(--space-xl);
            border-radius: var(--radius-2xl);
            background: linear-gradient(135deg, var(--gray-900), var(--glass-primary));
            color: var(--text-inverse);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero h1 {
            font-size: clamp(var(--text-2xl), 5vw, var(--text-4xl));
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-md);
            line-height: var(--leading-tight);
        }

        .hero p {
            font-size: var(--text-lg);
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: var(--space-xl);
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-buttons {
            display: flex;
            gap: var(--space-md);
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-hero-primary {
            background: var(--surface-primary);
            color: var(--glass-primary);
            border: none;
            padding: var(--space-3) var(--space-6);
            border-radius: var(--radius-lg);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: var(--transition-base);
            font-size: var(--text-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-hero-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .btn-hero-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: var(--text-inverse);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: var(--space-3) var(--space-6);
            border-radius: var(--radius-lg);
            font-weight: var(--font-weight-semibold);
            cursor: pointer;
            transition: var(--transition-base);
            font-size: var(--text-base);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-hero-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        /* Message Alerts */
        .alert-message {
            max-width: var(--container-md);
            margin: 0 auto var(--space-lg) auto;
            padding: var(--space-4);
            border-radius: var(--radius-xl);
            background: var(--glass-success);
            color: var(--success-dark);
            border: 1px solid var(--success-light);
            backdrop-filter: blur(10px);
            text-align: center;
        }

        /* Container */
        .main-container {
            max-width: var(--container-xl);
            margin: 0 auto;
            padding: 0 var(--space-lg);
        }

        .section-title {
            font-size: var(--text-2xl);
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            margin-bottom: var(--space-xl);
            text-align: center;
        }

        .products-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
        }

        .product-card {
            position: relative;
            transition: var(--transition-base);
            overflow: hidden;
        }

        .product-card:hover {
            transform: translateY(-4px);
        }

        .product-header {
            margin-bottom: var(--space-md);
        }

        .product-name {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            margin-bottom: var(--space-1);
            line-height: var(--leading-tight);
        }

        .product-price {
            font-size: var(--text-xl);
            font-weight: var(--font-weight-bold);
            color: var(--success);
            display: flex;
            align-items: center;
            gap: var(--space-1);
        }

        .product-description {
            color: var(--text-secondary);
            font-size: var(--text-sm);
            line-height: var(--leading-relaxed);
            margin: var(--space-md) 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-stock {
            display: flex;
            align-items: center;
            gap: var(--space-1);
            margin-bottom: var(--space-md);
            font-size: var(--text-sm);
        }

        .stock-available {
            color: var(--success);
            font-weight: var(--font-weight-medium);
        }

        .stock-low {
            color: var(--warning);
            font-weight: var(--font-weight-medium);
        }

        .stock-out {
            color: var(--error);
            font-weight: var(--font-weight-semibold);
            font-style: italic;
        }

        .add-to-cart-form {
            display: flex;
            align-items: center;
            gap: var(--space-sm);
            margin-top: auto;
        }

        .quantity-input {
            width: 70px;
            padding: var(--space-2) var(--space-3);
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            background: var(--surface-primary);
            color: var(--text-primary);
            transition: var(--transition-colors);
        }

        .quantity-input:focus {
            border-color: var(--glass-primary);
            outline: none;
            box-shadow: 0 0 0 2px var(--glass-primary-light);
        }

        .add-to-cart-btn {
            flex: 1;
        }

        .empty-state {
            text-align: center;
            padding: var(--space-3xl) var(--space-lg);
            color: var(--text-secondary);
        }

        .empty-state-icon {
            font-size: var(--text-6xl);
            margin-bottom: var(--space-lg);
            opacity: 0.5;
        }

        .empty-state-title {
            font-size: var(--text-xl);
            font-weight: var(--font-weight-semibold);
            margin-bottom: var(--space-md);
            color: var(--text-primary);
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: var(--space-md);
            margin-top: var(--space-xl);
            padding: var(--space-lg);
            background: var(--surface-secondary);
            border-radius: var(--radius-xl);
            flex-wrap: wrap;
        }

        .pagination-info {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            margin: 0 var(--space-md);
        }

        .pagination-btn {
            display: flex;
            align-items: center;
            gap: var(--space-1);
            padding: var(--space-2) var(--space-3);
            text-decoration: none;
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            transition: var(--transition-colors);
        }

        .pagination-btn:hover {
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: var(--space-md);
                padding: var(--space-4);
            }

            .nav-menu {
                order: 3;
                width: 100%;
                justify-content: center;
                flex-wrap: wrap;
                gap: var(--space-md);
            }

            .user-section {
                order: 2;
                gap: var(--space-sm);
            }

            .hero {
                width: 95%;
                padding: var(--space-2xl) var(--space-md);
                margin: var(--space-lg) auto;
            }

            .hero h1 {
                font-size: var(--text-2xl);
            }

            .hero p {
                font-size: var(--text-base);
                margin-bottom: var(--space-lg);
            }

            .hero-buttons {
                flex-direction: column;
                align-items: center;
                gap: var(--space-sm);
            }

            .btn-hero-primary,
            .btn-hero-secondary {
                width: 100%;
                justify-content: center;
                max-width: 300px;
            }

            .products-container {
                grid-template-columns: 1fr;
                gap: var(--space-md);
            }

            .add-to-cart-form {
                flex-direction: column;
                gap: var(--space-md);
            }

            .quantity-input {
                width: 100%;
            }

            .pagination-container {
                flex-direction: column;
                gap: var(--space-sm);
            }
        }
    </style>
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
            <span class="logo-icon">⚡</span>TechStore
        </div>

        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products" style="color: var(--glass-primary);">Products</a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/cart">Cart</a>
                <a href="${pageContext.request.contextPath}/orders">Orders</a>
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
                            <div class="btn btn--ghost btn--md" style="opacity: 0.5; cursor: not-allowed; width: 100%;">
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
