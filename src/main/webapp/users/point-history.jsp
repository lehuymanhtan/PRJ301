<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.PointHistory, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Point History - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">

<%
    User currentUser = (User) session.getAttribute("user");
    List<PointHistory> pointHistory = (List<PointHistory>) request.getAttribute("pointHistory");
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
                💎 Point History
            </h1>
            <p class="text-secondary">
                Track all your loyalty point transactions and activities
            </p>
        </div>

        <!-- Navigation Breadcrumb -->
        <nav class="nav-breadcrumb">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <a href="${pageContext.request.contextPath}/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/users">Profile</a>
            <a href="${pageContext.request.contextPath}/points" class="active">Point History</a>
            <% if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>

        <!-- Current Stats Overview -->
        <div class="stats-overview">
            <div class="surface-card stat-card stat-card--balance">
                <div class="stat-value"><%= String.format("%,d", currentUser.getPoints()) %></div>
                <div class="stat-label">Current Balance</div>
            </div>
            <div class="surface-card stat-card stat-card--tier">
                <div class="stat-value"><%= currentUser.getMembershipTier() %></div>
                <div class="stat-label">Membership Tier</div>
            </div>
            <div class="surface-card stat-card">
                <div class="stat-value">
                    <% if (pointHistory != null) { %>
                        <%= pointHistory.size() %>
                    <% } else { %>
                        0
                    <% } %>
                </div>
                <div class="stat-label">Total Transactions</div>
            </div>
        </div>

        <!-- Transaction History Table -->
        <div class="table-container">
            <div class="table-header">
                <div>
                    <div class="table-title">Transaction History</div>
                    <div class="table-count">
                        <% if (pointHistory != null && !pointHistory.isEmpty()) { %>
                            Showing <%= pointHistory.size() %> transactions
                        <% } else { %>
                            No transactions found
                        <% } %>
                    </div>
                </div>
            </div>

            <% if (pointHistory == null || pointHistory.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">💸</div>
                    <div class="empty-state-title">No Point History Yet</div>
                    <p>Start shopping to earn loyalty points and see your transaction history here!</p>
                    <div class="mt-lg">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn--primary">
                            🛍️ Start Shopping
                        </a>
                    </div>
                </div>
            <% } else { %>
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date & Time</th>
                            <th>Order Reference</th>
                            <th>Amount (VND)</th>
                            <th>Points</th>
                            <th>Transaction Type</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (PointHistory h : pointHistory) {
                           String badgeClass = "badge--completed";
                           String badgeText = h.getType();

                           if ("USE".equals(h.getType())) {
                               badgeClass = "badge--processing";
                               badgeText = "Redeemed";
                           } else if ("REFUND".equals(h.getType())) {
                               badgeClass = "badge--cancelled";
                               badgeText = "Refunded";
                           } else if ("Adjust".equals(h.getType())) {
                               badgeClass = "badge--shipped";
                               badgeText = "Adjusted";
                           } else if ("EARN".equals(h.getType())) {
                               badgeClass = "badge--completed";
                               badgeText = "Earned";
                           }

                           boolean isPositive = (h.getPointsEarned() != null && h.getPointsEarned() >= 0);
                           String pointsClass = isPositive ? "points-earned" : "points-spent";
                           String pointsSign = (h.getPointsEarned() != null && h.getPointsEarned() > 0) ? "+" : "";
                    %>
                        <tr>
                            <td><span class="transaction-id">#<%= h.getId() %></span></td>

                            <td>
                                <%= h.getCreatedAt() != null ?
                                    h.getCreatedAt().toString().replace("T", " ").substring(0, 16) :
                                    "-" %>
                            </td>

                            <td>
                                <% if (h.getOrderId() != null) { %>
                                    <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=<%= h.getOrderId() %>"
                                       class="order-link">
                                        Order #<%= h.getOrderId() %>
                                    </a>
                                <% } else { %>
                                    <span class="text-tertiary">Manual Entry</span>
                                <% } %>
                            </td>

                            <td>
                                <% if (h.getAmount() != null && h.getAmount() > 0) { %>
                                    <span class="amount-value"><%= String.format("%,.0f", h.getAmount()) %> ₫</span>
                                <% } else { %>
                                    <span class="text-tertiary">-</span>
                                <% } %>
                            </td>

                            <td>
                                <span class="<%= pointsClass %> font-semibold">
                                    <%= pointsSign %><%= h.getPointsEarned() %> pts
                                </span>
                            </td>

                            <td>
                                <span class="badge <%= badgeClass %>">
                                    <%= badgeText %>
                                </span>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Quick Actions -->
        <div class="mt-xl text-center">
            <a href="${pageContext.request.contextPath}/products" class="btn btn--primary btn--md mr-md">
                🛍️ Continue Shopping
            </a>
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
            // Animate stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150 + 200);
            });

            // Add hover effects to table rows
            const tableRows = document.querySelectorAll('.history-table tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.01)';
                });

                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });
            });

            // Animate table appearance
            const tableContainer = document.querySelector('.table-container');
            if (tableContainer) {
                tableContainer.style.opacity = '0';
                tableContainer.style.transform = 'translateY(30px)';

                setTimeout(() => {
                    tableContainer.style.transition = 'all 0.8s ease';
                    tableContainer.style.opacity = '1';
                    tableContainer.style.transform = 'translateY(0)';
                }, 600);
            }
        });
    </script>

</body>
</html>
