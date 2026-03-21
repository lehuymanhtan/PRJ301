<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.PointHistory, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Point History - Ruby Tech Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    List<PointHistory> histories = (List<PointHistory>) request.getAttribute("histories");
    Integer targetUserId = (Integer) request.getAttribute("targetUserId");
%>

<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Point History</h1>
            <p class="dashboard-subtitle">User #<%= targetUserId %> loyalty transaction timeline</p>
        </div>

        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <div class="admin-content">
        <div class="mb-lg">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn--secondary btn--sm">← Back to Users</a>
        </div>

        <div class="surface-card">
            <% if (histories == null || histories.isEmpty()) { %>
                <div class="text-secondary text-center py-xl">No point history for this user.</div>
            <% } else { %>
                <div class="table-container">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Date</th>
                                <th>Order</th>
                                <th>Amount (VND)</th>
                                <th>Points</th>
                                <th>Type</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (PointHistory h : histories) {
                               String typeClass = "type-earn";
                               if ("USE".equals(h.getType())) typeClass = "type-use";
                               if ("REFUND".equals(h.getType())) typeClass = "type-refund";
                               if ("Adjust".equals(h.getType())) typeClass = "type-adjust";
                               String ptsClass = (h.getPointsEarned() != null && h.getPointsEarned() >= 0) ? "pts-pos" : "pts-neg";
                               String ptsSign = (h.getPointsEarned() != null && h.getPointsEarned() > 0) ? "+" : "";
                        %>
                            <tr>
                                <td><span class="font-semibold text-primary">#<%= h.getId() %></span></td>
                                <td><span class="text-secondary"><%= h.getCreatedAt() != null ? h.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "-" %></span></td>
                                <td><span class="text-secondary"><%= h.getOrderId() != null ? "#" + h.getOrderId() : "-" %></span></td>
                                <td><span class="text-primary"><%= (h.getAmount() != null && h.getAmount() > 0) ? String.format("%,.0f", h.getAmount()) : "-" %></span></td>
                                <td class="<%= ptsClass %>"><%= ptsSign %><%= h.getPointsEarned() %></td>
                                <td><span class="type-tag <%= typeClass %>"><%= h.getType() %></span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
