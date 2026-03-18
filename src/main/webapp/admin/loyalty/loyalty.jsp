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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .loyalty-header {
            margin-bottom: var(--space-xl);
        }

        .loyalty-title {
            color: var(--text-primary);
            font-size: var(--text-3xl);
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-2);
        }

        .loyalty-subtitle {
            color: var(--text-secondary);
            font-size: var(--text-lg);
        }

        .section-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: var(--space-xl);
            max-width: 800px;
        }

        .rate-form {
            display: flex;
            align-items: end;
            gap: var(--space-md);
            margin-top: var(--space-md);
        }

        .rate-input-group {
            flex: 1;
        }

        .stats-table-container {
            overflow-x: auto;
        }

        .stats-table {
            width: 100%;
            max-width: 500px;
        }

        .tier-badge {
            display: inline-block;
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-md);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            color: var(--text-inverse);
            background: var(--gradient-primary);
        }

        .tier-badge--regular { background: var(--surface-tertiary); color: var(--text-primary); }
        .tier-badge--bronze { background: linear-gradient(135deg, #cd7f32 0%, #a0522d 100%); }
        .tier-badge--silver { background: linear-gradient(135deg, #c0c0c0 0%, #708090 100%); }
        .tier-badge--gold { background: linear-gradient(135deg, #ffd700 0%, #ffb300 100%); color: var(--text-primary); }
        .tier-badge--platinum { background: linear-gradient(135deg, #e5e4e2 0%, #b8860b 100%); color: var(--text-primary); }
        .tier-badge--diamond { background: linear-gradient(135deg, #b9f2ff 0%, #00bfff 100%); }

        @media (max-width: 768px) {
            .rate-form {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
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
