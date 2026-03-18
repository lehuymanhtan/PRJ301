<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - TechStore</title>

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

        .user-info {
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-lg);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            background: var(--glass-primary);
            color: var(--text-inverse);
        }

        .orders-container {
            display: flex;
            flex-direction: column;
            gap: var(--space-lg);
        }

        .order-card {
            transition: var(--transition-base);
            border-left: 4px solid transparent;
            position: relative;
        }

        .order-card:hover {
            transform: translateY(-2px);
            border-left-color: var(--glass-primary);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-md);
        }

        .order-id {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-bold);
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .order-total {
            font-size: var(--text-xl);
            font-weight: var(--font-weight-bold);
            color: var(--success);
        }

        .order-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: var(--space-md);
        }

        .order-status {
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        /* Status badges with glassmorphism styling */
        .status-badge {
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-full);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-semibold);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            gap: var(--space-1);
        }

        .status-badge--pending {
            background: rgba(251, 191, 36, 0.2);
            color: #92400e;
            border-color: rgba(251, 191, 36, 0.3);
        }

        .status-badge--processing {
            background: rgba(59, 130, 246, 0.2);
            color: #1e40af;
            border-color: rgba(59, 130, 246, 0.3);
        }

        .status-badge--shipped {
            background: rgba(14, 165, 233, 0.2);
            color: #0c4a6e;
            border-color: rgba(14, 165, 233, 0.3);
        }

        .status-badge--delivered {
            background: rgba(34, 197, 94, 0.2);
            color: #15803d;
            border-color: rgba(34, 197, 94, 0.3);
        }

        .status-badge--completed {
            background: rgba(16, 185, 129, 0.2);
            color: #047857;
            border-color: rgba(16, 185, 129, 0.3);
        }

        .status-badge--cancelled {
            background: rgba(239, 68, 68, 0.2);
            color: #dc2626;
            border-color: rgba(239, 68, 68, 0.3);
        }

        .status-badge--refunded {
            background: rgba(139, 92, 246, 0.2);
            color: #7c3aed;
            border-color: rgba(139, 92, 246, 0.3);
        }

        .order-actions {
            display: flex;
            gap: var(--space-sm);
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

        .orders-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
        }

        .summary-card {
            text-align: center;
            padding: var(--space-lg);
        }

        .summary-number {
            font-size: var(--text-2xl);
            font-weight: var(--font-weight-bold);
            color: var(--glass-primary);
            display: block;
        }

        .summary-label {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            margin-top: var(--space-1);
        }

        @media (max-width: 768px) {
            .nav-breadcrumb {
                flex-direction: column;
                align-items: center;
            }

            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: var(--space-sm);
            }

            .order-details {
                flex-direction: column;
                align-items: flex-start;
                gap: var(--space-sm);
            }

            .order-actions {
                width: 100%;
            }

            .order-actions .btn {
                flex: 1;
                justify-content: center;
            }

            .orders-summary {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
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
