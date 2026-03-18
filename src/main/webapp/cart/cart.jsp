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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .main-container {
            max-width: var(--container-xl);
            margin: 0 auto;
            padding: 0 var(--space-lg);
        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: var(--space-xl);
            align-items: start;
        }

        .cart-items {
            display: flex;
            flex-direction: column;
            gap: var(--space-lg);
        }

        .cart-item {
            transition: var(--transition-base);
            border-left: 4px solid transparent;
        }

        .cart-item:hover {
            transform: translateY(-2px);
            border-left-color: var(--glass-primary);
        }

        .cart-item-content {
            display: grid;
            grid-template-columns: 1fr auto auto;
            gap: var(--space-lg);
            align-items: center;
        }

        .item-info {
            display: flex;
            flex-direction: column;
            gap: var(--space-sm);
        }

        .item-name {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .item-price {
            font-size: var(--text-md);
            color: var(--success);
            font-weight: var(--font-weight-medium);
        }

        .quantity-controls {
            display: flex;
            flex-direction: column;
            gap: var(--space-sm);
            align-items: center;
        }

        .quantity-form {
            display: flex;
            align-items: center;
            gap: var(--space-sm);
        }

        .quantity-input {
            width: 70px;
            padding: var(--space-2) var(--space-3);
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            text-align: center;
            background: var(--surface-primary);
            color: var(--text-primary);
        }

        .quantity-input:focus {
            border-color: var(--glass-primary);
            outline: none;
            box-shadow: 0 0 0 2px var(--glass-primary-light);
        }

        .item-actions {
            display: flex;
            flex-direction: column;
            gap: var(--space-sm);
            align-items: flex-end;
        }

        .item-subtotal {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            text-align: right;
        }

        .cart-sidebar {
            position: sticky;
            top: var(--space-lg);
        }

        .cart-summary {
            margin-bottom: var(--space-lg);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-md) 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .summary-row:last-child {
            border-bottom: none;
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            font-size: var(--text-lg);
            border-top: 2px solid var(--glass-primary);
            padding-top: var(--space-lg);
            margin-top: var(--space-md);
        }

        .summary-label {
            color: var(--text-secondary);
        }

        .summary-value {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .cart-actions {
            display: flex;
            flex-direction: column;
            gap: var(--space-md);
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

        @media (max-width: 968px) {
            .cart-layout {
                grid-template-columns: 1fr;
                gap: var(--space-lg);
            }

            .cart-item-content {
                grid-template-columns: 1fr;
                gap: var(--space-md);
                text-align: center;
            }

            .item-actions {
                align-items: center;
            }

            .nav-breadcrumb {
                flex-direction: column;
                align-items: center;
            }
        }

        @media (max-width: 640px) {
            .quantity-form {
                flex-direction: column;
                gap: var(--space-sm);
            }

            .cart-actions {
                gap: var(--space-sm);
            }

            .cart-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
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
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo" style="height: 36px; width: auto; vertical-align: middle;">
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
    <div style="text-align: center; margin: var(--space-xl) 0;">
        <h1 style="font-size: var(--text-3xl); font-weight: var(--font-weight-bold); color: var(--text-primary); margin-bottom: var(--space-md);">
            🛒 Shopping Cart
        </h1>
        <p style="color: var(--text-secondary); font-size: var(--text-lg);">
            Review your items before checkout
        </p>
    </div>

    <!-- Success/Warning Messages -->
    <% if (cartMessage != null) { %>
        <div class="alert-message" style="background: var(--glass-success); color: var(--success-dark); margin-bottom: var(--space-lg);">
            ✅ <%= cartMessage %>
        </div>
    <% } %>
    <% if (stockMessage != null) { %>
        <div class="alert-message" style="background: var(--glass-warning); color: var(--warning-dark); margin-bottom: var(--space-lg);">
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

