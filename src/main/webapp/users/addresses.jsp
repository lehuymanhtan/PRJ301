<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .page-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .nav-breadcrumb {
            display: flex;
            justify-content: center;
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
            flex-wrap: wrap;
        }

        .nav-breadcrumb a {
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-lg);
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--transition-colors);
            font-size: var(--text-sm);
            background: var(--surface-tertiary);
            border: 1px solid var(--gray-200);
        }

        .nav-breadcrumb a:hover,
        .nav-breadcrumb a.active {
            background: var(--glass-primary);
            color: var(--text-inverse);
            transform: translateY(-1px);
        }

        .address-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-xl);
            flex-wrap: wrap;
            gap: var(--space-md);
        }

        .address-count {
            font-size: var(--text-sm);
            color: var(--text-secondary);
        }

        .address-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: var(--space-lg);
            margin-bottom: var(--space-xl);
        }

        .address-card {
            position: relative;
            transition: var(--transition-base);
        }

        .address-card:hover {
            transform: translateY(-2px);
        }

        .address-card--default {
            border-color: var(--success);
            box-shadow: 0 0 0 1px var(--success-glass);
        }

        .address-card--default::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-success);
            border-radius: var(--radius-xl) var(--radius-xl) 0 0;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--space-md);
        }

        .address-name {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            margin-bottom: var(--space-1);
        }

        .address-phone {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: var(--space-1);
        }

        .address-text {
            color: var(--text-primary);
            line-height: var(--leading-relaxed);
            margin: var(--space-md) 0;
            padding: var(--space-md);
            background: var(--surface-tertiary);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
        }

        .address-actions-row {
            display: flex;
            gap: var(--space-sm);
            flex-wrap: wrap;
        }

        .address-actions-row .btn {
            flex: 1;
            min-width: 80px;
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

        .back-button {
            margin-bottom: var(--space-lg);
        }

        .checkout-notice {
            background: var(--info-bg);
            color: var(--info-dark);
            padding: var(--space-md);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-lg);
            border: 1px solid var(--info);
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }

        @media (max-width: 768px) {
            .address-grid {
                grid-template-columns: 1fr;
                gap: var(--space-md);
            }

            .nav-breadcrumb {
                flex-direction: column;
                align-items: center;
            }

            .address-actions {
                flex-direction: column;
                text-align: center;
            }

            .address-actions-row {
                flex-direction: column;
            }

            .address-actions-row .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body class="bg-surface-secondary">

<%
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    Boolean fromCheckout = (Boolean) request.getAttribute("fromCheckout");
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Back Button -->
        <div class="back-button">
            <a href="${pageContext.request.contextPath}/users" class="btn btn--back btn--sm">
                ← Back to Profile
            </a>
        </div>

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                📍 My Shipping Addresses
            </h1>
            <p class="text-secondary">
                Manage your delivery locations for a seamless shopping experience
            </p>
        </div>

        <!-- Navigation Breadcrumb -->
        <nav class="nav-breadcrumb">
            <a href="${pageContext.request.contextPath}/">🏠 Home</a>
            <a href="${pageContext.request.contextPath}/users">👤 Profile</a>
            <a href="${pageContext.request.contextPath}/users/addresses" class="active">📍 Addresses</a>
            <a href="${pageContext.request.contextPath}/orders">📦 Orders</a>
            <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
        </nav>

        <!-- Checkout Notice -->
        <% if (fromCheckout != null && fromCheckout) { %>
            <div class="checkout-notice">
                <div>ℹ️</div>
                <div>
                    <strong>Address Required:</strong> You need at least one shipping address to complete your checkout. Please add an address below.
                </div>
            </div>
        <% } %>

        <!-- Success Messages -->
        <% if (success != null) { %>
            <div class="message message--success mb-lg">
                <% if ("added".equals(success)) { %>
                    ✅ Address added successfully!
                <% } else if ("updated".equals(success)) { %>
                    ✅ Address updated successfully!
                <% } else if ("deleted".equals(success)) { %>
                    ✅ Address deleted successfully!
                <% } else if ("defaultSet".equals(success)) { %>
                    ✅ Default address updated!
                <% } %>
            </div>
        <% } %>

        <!-- Error Messages -->
        <% if (error != null) { %>
            <div class="message message--error mb-lg">
                <% if ("notfound".equals(error)) { %>
                    ❌ Address not found or unauthorized access!
                <% } else { %>
                    ❌ An error occurred while processing your request!
                <% } %>
            </div>
        <% } %>

        <!-- Address Actions -->
        <div class="address-actions">
            <div class="address-count">
                <% if (addresses != null && !addresses.isEmpty()) { %>
                    Showing <%= addresses.size() %> address<%= addresses.size() == 1 ? "" : "es" %>
                <% } else { %>
                    No addresses found
                <% } %>
            </div>

            <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn--success btn--md">
                ➕ Add New Address
            </a>
        </div>

        <!-- Address Grid -->
        <% if (addresses == null || addresses.isEmpty()) { %>
            <div class="surface-card">
                <div class="empty-state">
                    <div class="empty-state-icon">🏠</div>
                    <div class="empty-state-title">No Shipping Addresses Yet</div>
                    <p>Add your first delivery address to start shopping with confidence.</p>
                    <div class="mt-lg">
                        <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn--success">
                            ➕ Add Your First Address
                        </a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="address-grid">
                <% for (UserAddress addr : addresses) { %>
                    <div class="surface-card address-card <%= addr.isDefault() ? "address-card--default" : "" %>">
                        <!-- Address Header -->
                        <div class="address-header">
                            <div>
                                <div class="address-name"><%= addr.getFullName() %></div>
                                <div class="address-phone">
                                    📞 <%= addr.getPhone() %>
                                </div>
                            </div>

                            <% if (addr.isDefault()) { %>
                                <div class="badge badge--completed badge--sm">
                                    DEFAULT
                                </div>
                            <% } %>
                        </div>

                        <!-- Address Text -->
                        <div class="address-text">
                            📍 <%= addr.getFormattedAddress() %>
                        </div>

                        <!-- Address Actions -->
                        <div class="address-actions-row">
                            <a href="${pageContext.request.contextPath}/users/addresses?action=edit&id=<%= addr.getId() %>"
                               class="btn btn--primary btn--sm">
                                ✏️ Edit
                            </a>

                            <% if (!addr.isDefault()) { %>
                                <a href="${pageContext.request.contextPath}/users/addresses?action=setDefault&id=<%= addr.getId() %>"
                                   class="btn btn--secondary btn--sm">
                                    ⭐ Set Default
                                </a>

                                <a href="${pageContext.request.contextPath}/users/addresses?action=delete&id=<%= addr.getId() %>"
                                   class="btn btn--error btn--sm"
                                   onclick="return confirm('🗑️ Are you sure you want to delete this address? This action cannot be undone.')">
                                    🗑️ Delete
                                </a>
                            <% } else { %>
                                <div class="btn btn--ghost btn--sm" style="opacity: 0.5; cursor: not-allowed;">
                                    🔒 Protected
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <!-- Quick Actions -->
        <div class="mt-xl text-center">
            <% if (fromCheckout != null && fromCheckout) { %>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn--primary btn--md mr-md">
                    🛒 Continue Checkout
                </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/users" class="btn btn--secondary btn--md">
                👤 Back to Profile
            </a>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate address cards
            const addressCards = document.querySelectorAll('.address-card');
            addressCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150 + 200);
            });

            // Enhanced hover effects
            const cards = document.querySelectorAll('.address-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    if (!this.classList.contains('address-card--default')) {
                        this.style.borderColor = 'var(--glass-primary)';
                    }
                });

                card.addEventListener('mouseleave', function() {
                    if (!this.classList.contains('address-card--default')) {
                        this.style.borderColor = '';
                    }
                });
            });

            // Confirm delete with custom styling
            const deleteButtons = document.querySelectorAll('a[onclick*="confirm"]');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const confirmDelete = confirm(this.getAttribute('onclick').match(/confirm\(['"]([^'"]+)['"]\)/)[1]);
                    if (confirmDelete) {
                        window.location.href = this.href;
                    }
                });
                // Remove inline onclick to use our custom handler
                button.removeAttribute('onclick');
            });
        });
    </script>

</body>
</html>
