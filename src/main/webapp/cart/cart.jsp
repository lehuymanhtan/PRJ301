<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Cart, models.CartItem, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    Cart cart        = (Cart) request.getAttribute("cart");
    String cartMessage  = (String) request.getAttribute("cartMessage");
    String stockMessage = (String) request.getAttribute("stockMessage");
%>

<!-- Header Navigation -->
<div class="main-container">
    <div class="app-header">
        <a href="${pageContext.request.contextPath}/" class="app-header__logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </a>

        <div class="app-header__nav">
            <a href="${pageContext.request.contextPath}/" class="app-header__nav-link">Home</a>
            <a href="${pageContext.request.contextPath}/products" class="app-header__nav-link">Products</a>
            <a href="${pageContext.request.contextPath}/cart" class="app-header__nav-link app-header__nav-link--active">Cart</a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/orders" class="app-header__nav-link">Orders</a>
                <% if ("admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="app-header__nav-link">Admin Dashboard</a>
                <% } %>
            <% } %>
        </div>

        <div class="app-header__user">
            <% if (currentUser != null) { %>
                <span class="app-header__user-name"><%= currentUser.getName() %></span>
                <a href="${pageContext.request.contextPath}/users" class="app-header__user-link">Profile</a>
                <a href="${pageContext.request.contextPath}/logout" class="app-header__user-link">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="app-header__user-link">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="app-header__user-link">Register</a>
            <% } %>
        </div>
    </div>
</div>

<!-- Page Content -->
<div class="main-container">
    <!-- Page Title Section -->
    <div>
        <h1>
            🛒 Shopping Cart
        </h1>
        <p>
            Review your items before checkout
        </p>
    </div>

    <!-- Success/Warning Messages -->
    <% if (cartMessage != null) { %>
        <div class="alert-message">
            ✅ <%= cartMessage %>
        </div>
    <% } %>
    <% if (stockMessage != null) { %>
        <div class="alert-message">
            ⚠️ <%= stockMessage %>
        </div>
    <% } %>

        <!-- Cart Content -->
        <% if (cart == null || cart.isEmpty()) { %>
            <div class="surface-card">
                <div class="empty-state">
                    <div class="empty-state-icon">🛒</div>
                    <div class="empty-state-title">Your Cart is Empty</div>
                    <p>Start shopping to add items to your cart. Discover our amazing products!</p>
                    <div class="mt-lg">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn--primary btn--lg">
                            🛍️ Browse Products
                        </a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <!-- Cart Items -->
                <div class="cart-items">
                    <%
                        double grandTotal = 0;
                        for (CartItem item : cart) {
                            grandTotal += item.getSubtotal();
                    %>
                        <div class="surface-card cart-item">
                            <div class="cart-item-content">
                                <!-- Item Info -->
                                <div class="item-info">
                                    <div class="item-name">
                                        📦 <%= item.getProduct().getName() %>
                                    </div>
                                    <div class="item-price">
                                        💰 <%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫
                                    </div>
                                </div>

                                <!-- Quantity Controls -->
                                <div class="quantity-controls">
                                    <form class="quantity-form"
                                          action="${pageContext.request.contextPath}/cart"
                                          method="post">
                                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                        <input type="hidden" name="action" value="update">
                                        <input type="number"
                                               name="quantity"
                                               value="<%= item.getQuantity() %>"
                                               min="1"
                                               max="<%= item.getProduct().getStock() %>"
                                               class="quantity-input"
                                               title="Quantity">
                                        <button type="submit" class="btn btn--primary btn--sm">
                                            🔄 Update
                                        </button>
                                    </form>
                                </div>

                                <!-- Item Actions -->
                                <div class="item-actions">
                                    <div class="item-subtotal">
                                        <%= String.format("%,.0f", item.getSubtotal()) %> ₫
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                        <input type="hidden" name="action" value="remove">
                                        <button type="submit"
                                                class="btn btn--error btn--sm"
                                                onclick="return confirm('🗑️ Remove this item from your cart?')">
                                            🗑️ Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Cart Summary Sidebar -->
                <div class="cart-sidebar">
                    <div class="surface-card cart-summary">
                        <h3 class="text-lg font-semibold text-primary mb-md">
                            📊 Order Summary
                        </h3>

                        <div class="summary-row">
                            <span class="summary-label">Items:</span>
                            <span class="summary-value"><%= cart.size() %></span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Subtotal:</span>
                            <span class="summary-value"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                        </div>

                        <div class="summary-row">
                            <span class="summary-label">Total:</span>
                            <span class="summary-value"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                        </div>
                    </div>

                    <!-- Cart Actions -->
                    <div class="cart-actions">
                        <a href="${pageContext.request.contextPath}/checkout"
                           class="btn btn--success btn--lg">
                            💳 Proceed to Checkout
                        </a>
                        <a href="${pageContext.request.contextPath}/products"
                           class="btn btn--secondary btn--md">
                            🛍️ Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
</div>

<!-- Glassmorphism Interactive Effects -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate cart items
            const cartItems = document.querySelectorAll('.cart-item');
            cartItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    item.style.transition = 'all 0.6s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 150 + 200);
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

                    // Auto-update form on change (optional enhancement)
                    const form = this.closest('form');
                    const updateButton = form.querySelector('button[type="submit"]');
                    if (updateButton) {
                        updateButton.style.background = 'var(--warning)';
                        updateButton.innerHTML = '⚡ Update';
                    }
                });
            });

            // Form submission enhancements
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function() {
                    const button = this.querySelector('button[type="submit"]');
                    if (button && !button.disabled) {
                        const originalText = button.innerHTML;

                        // Add loading state
                        button.disabled = true;
                        button.style.opacity = '0.7';

                        if (button.innerHTML.includes('Update')) {
                            button.innerHTML = '<span class="loading-spinner loading-spinner--sm"></span> Updating...';
                        } else if (button.innerHTML.includes('Remove')) {
                            button.innerHTML = '<span class="loading-spinner loading-spinner--sm"></span> Removing...';
                        }

                        // Reset after 3 seconds if no redirect happens
                        setTimeout(() => {
                            button.disabled = false;
                            button.style.opacity = '';
                            button.innerHTML = originalText;
                        }, 3000);
                    }
                });
            });

            // Enhanced remove confirmation
            const removeButtons = document.querySelectorAll('button[onclick*="confirm"]');
            removeButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const productName = this.closest('.cart-item').querySelector('.item-name').textContent.trim();
                    const confirmRemove = confirm(`🗑️ Remove "${productName}" from your cart?\n\nThis action cannot be undone.`);
                    if (confirmRemove) {
                        this.closest('form').submit();
                    }
                });
                // Remove inline onclick to use our custom handler
                button.removeAttribute('onclick');
            });
        });
    </script>

</body>
</html>
