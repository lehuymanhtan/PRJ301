<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.TierStatistic, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loyalty Management - Ruby Tech Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    int pointRate    = (Integer) request.getAttribute("pointRate");
    List<TierStatistic> stats = (List<TierStatistic>) request.getAttribute("stats");
    String success = request.getParameter("success");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="loyalty-header">
            <h1 class="loyalty-title">⭐ Loyalty Management</h1>
            <p class="loyalty-subtitle">Welcome back, <strong><%= currentUser.getUsername() %></strong></p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty" class="active">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Success Message -->
        <% if ("updated".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Point rate updated successfully!
            </div>
        <% } %>

        <!-- Content Grid -->
        <div class="section-grid">
            <!-- Point Conversion Rate Section -->
            <div class="surface-card">
                <h2 class="text-xl font-semibold text-primary mb-md">💰 Point Conversion Rate</h2>
                <p class="text-secondary mb-lg">
                    Current rate: <strong class="text-primary"><%= pointRate %></strong> points per 1,000 VND spent
                </p>

                <form method="post" action="${pageContext.request.contextPath}/admin/loyalty" class="rate-form">
                    <input type="hidden" name="action" value="updateRate">
                    <div class="rate-input-group">
                        <label for="rate" class="form-label">New Rate *</label>
                        <input type="number"
                               id="rate"
                               name="rate"
                               class="form-input"
                               value="<%= pointRate %>"
                               min="1"
                               required
                               placeholder="Enter points per 1,000 VND">
                    </div>
                    <button type="submit" class="btn btn--primary">
                        💾 Save Rate
                    </button>
                </form>
            </div>

            <!-- Members by Tier Section -->
            <div class="surface-card">
                <h2 class="text-xl font-semibold text-primary mb-md">👥 Members by Tier</h2>

                <% if (stats == null || stats.isEmpty()) { %>
                    <div class="empty-state">
                        <p class="text-secondary text-center py-lg">No membership data available</p>
                    </div>
                <% } else { %>
                    <div class="stats-table-container">
                        <table class="table stats-table">
                            <thead>
                                <tr>
                                    <th>Tier Level</th>
                                    <th>Member Count</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (TierStatistic s : stats) {
                                    String tierClass = s.getTier().toLowerCase().replace(" ", "-");
                                %>
                                    <tr>
                                        <td>
                                            <span class="tier-badge tier-badge--<%= tierClass %>">
                                                <%= s.getTier() %>
                                            </span>
                                        </td>
                                        <td class="font-semibold text-primary">
                                            <%= String.format("%,d", s.getTotal()) %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>

                <!-- Action Links -->
                <div class="mt-lg pt-lg border-t border-primary">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn--secondary">
                        👤 Manage User Points
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Effects -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
