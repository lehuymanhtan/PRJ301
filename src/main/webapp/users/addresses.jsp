<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
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
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <a href="${pageContext.request.contextPath}/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/users">Profile</a>
            <a href="${pageContext.request.contextPath}/users/addresses" class="active">Addresses</a>
            <% if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
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
                                <div class="btn btn--ghost btn--sm">
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
