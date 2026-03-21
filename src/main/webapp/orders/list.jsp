<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser  = (User)       session.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String msg = (String) session.getAttribute("cartMessage");
    if (msg != null) session.removeAttribute("cartMessage");
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                📦 Order History
            </h1>
            <p class="text-secondary">
                Track your orders and view purchase history
            </p>
        </div>

        <!-- Navigation Breadcrumb -->
        <nav class="nav-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <% if (currentUser != null) { %>
                <a href="${pageContext.request.contextPath}/cart">Cart</a>
                <a href="${pageContext.request.contextPath}/orders" class="active">Orders</a>
                <a href="${pageContext.request.contextPath}/users">Profile</a>
                <% if ("admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                <span class="user-info"><%= currentUser.getName() %></span>
            <% } %>
        </nav>

        <!-- Messages -->
        <% if (msg != null) { %>
            <div class="message message--error mb-lg">
                ❌ <%= msg %>
            </div>
        <% } %>

        <!-- Orders Content -->
        <% if (orders == null || orders.isEmpty()) { %>
            <div class="surface-card">
                <div class="empty-state">
                    <div class="empty-state-icon">📦</div>
                    <div class="empty-state-title">No Orders Found</div>
                    <p>You haven't placed any orders yet. Start shopping to see your order history here!</p>
                    <div class="mt-lg">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn--primary btn--lg">
                            🛍️ Start Shopping
                        </a>
                    </div>
                </div>
            </div>
        <% } else { %>
            <!-- Orders Summary -->
            <div class="orders-summary">
                <div class="summary-card surface-card">
                    <span class="summary-number"><%= orders.size() %></span>
                    <div class="summary-label">Total Orders</div>
                </div>
                <div class="summary-card surface-card">
                    <span class="summary-number">
                        <%= orders.stream()
                            .filter(o -> "Completed".equalsIgnoreCase(o.getStatus()) || "Delivered".equalsIgnoreCase(o.getStatus()))
                            .count() %>
                    </span>
                    <div class="summary-label">Completed</div>
                </div>
                <div class="summary-card surface-card">
                    <span class="summary-number">
                        <%= orders.stream()
                            .filter(o -> "Pending".equalsIgnoreCase(o.getStatus()) || "Processing".equalsIgnoreCase(o.getStatus()) || "Shipped".equalsIgnoreCase(o.getStatus()))
                            .count() %>
                    </span>
                    <div class="summary-label">In Progress</div>
                </div>
                <div class="summary-card surface-card">
                    <span class="summary-number">
                        <%= String.format("%,.0f", orders.stream()
                            .filter(o -> "Completed".equalsIgnoreCase(o.getStatus()) || "Delivered".equalsIgnoreCase(o.getStatus()))
                            .mapToDouble(Order::getTotalPrice)
                            .sum()) %> ₫
                    </span>
                    <div class="summary-label">Total Spent</div>
                </div>
            </div>

            <!-- Orders List -->
            <div class="orders-container">
                <% for (Order o : orders) {
                       String statusClass = "status-badge--" + o.getStatus().toLowerCase();
                       String statusIcon = "";

                       // Add status icons
                       switch(o.getStatus().toLowerCase()) {
                           case "pending": statusIcon = "⏳"; break;
                           case "processing": statusIcon = "⚙️"; break;
                           case "shipped": statusIcon = "🚚"; break;
                           case "delivered": statusIcon = "✅"; break;
                           case "completed": statusIcon = "🎉"; break;
                           case "cancelled": statusIcon = "❌"; break;
                           case "refunded": statusIcon = "💰"; break;
                           default: statusIcon = "📋"; break;
                       }
                %>
                    <div class="surface-card order-card">
                        <!-- Order Header -->
                        <div class="order-header">
                            <div class="order-id">
                                🧾 Order #<%= o.getId() %>
                            </div>
                            <div class="order-total">
                                💰 <%= String.format("%,.0f", o.getTotalPrice()) %> ₫
                            </div>
                        </div>

                        <!-- Order Details -->
                        <div class="order-details">
                            <div class="order-status">
                                <span class="status-badge <%= statusClass %>">
                                    <%= statusIcon %> <%= o.getStatus() %>
                                </span>
                            </div>

                            <div class="order-actions">
                                <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= o.getId() %>"
                                   class="btn btn--primary btn--sm">
                                    👁️ View Details
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Quick Actions -->
            <div class="mt-xl text-center">
                <a href="${pageContext.request.contextPath}/products" class="btn btn--secondary btn--md">
                    🛍️ Continue Shopping
                </a>
            </div>
        <% } %>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate order cards
            const orderCards = document.querySelectorAll('.order-card');
            orderCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100 + 200);
            });

            // Animate summary cards
            const summaryCards = document.querySelectorAll('.summary-card');
            summaryCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(10px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.4s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 50 + 100);
            });

            // Enhanced hover effects for order cards
            orderCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    const statusBadge = this.querySelector('.status-badge');
                    if (statusBadge) {
                        statusBadge.style.transform = 'scale(1.05)';
                        statusBadge.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
                    }
                });

                card.addEventListener('mouseleave', function() {
                    const statusBadge = this.querySelector('.status-badge');
                    if (statusBadge) {
                        statusBadge.style.transform = '';
                        statusBadge.style.boxShadow = '';
                    }
                });
            });

            // Number counter animation for summary cards
            const numberElements = document.querySelectorAll('.summary-number');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const element = entry.target;
                        const finalValue = element.textContent;

                        // Only animate if it's a number
                        if (/^\d+$/.test(finalValue)) {
                            const finalNumber = parseInt(finalValue);
                            let currentNumber = 0;
                            const increment = Math.ceil(finalNumber / 20);

                            const timer = setInterval(() => {
                                currentNumber += increment;
                                if (currentNumber >= finalNumber) {
                                    currentNumber = finalNumber;
                                    clearInterval(timer);
                                }
                                element.textContent = currentNumber.toLocaleString();
                            }, 50);
                        }

                        observer.unobserve(element);
                    }
                });
            });

            numberElements.forEach(el => {
                if (/^\d+$/.test(el.textContent)) {
                    observer.observe(el);
                }
            });
        });
    </script>

</body>
</html>
