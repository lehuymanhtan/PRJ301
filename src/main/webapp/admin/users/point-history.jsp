<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.PointHistory, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Point History</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        table { border-collapse: collapse; width: 100%; max-width: 800px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .type-earn   { color: green; font-weight: bold; }
        .type-use    { color: #e65100; font-weight: bold; }
        .type-refund { color: #c62828; font-weight: bold; }
        .type-adjust { color: #1565c0; font-weight: bold; }
        .pts-pos { color: green; }
        .pts-neg { color: red; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<PointHistory> histories = (List<PointHistory>) request.getAttribute("histories");
    Integer targetUserId = (Integer) request.getAttribute("targetUserId");
%>

<h1>Admin - Point History for User #<%= targetUserId %></h1>
<nav>
    Welcome, <strong><%= currentUser.getUsername() %></strong> |
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/users">User Management</a> |
    <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if (histories == null || histories.isEmpty()) { %>
    <p>No point history for this user.</p>
<% } else { %>
<table>
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
           if ("USE".equals(h.getType()))    typeClass = "type-use";
           if ("REFUND".equals(h.getType())) typeClass = "type-refund";
           if ("Adjust".equals(h.getType())) typeClass = "type-adjust";
           String ptsClass = (h.getPointsEarned() != null && h.getPointsEarned() >= 0) ? "pts-pos" : "pts-neg";
           String ptsSign  = (h.getPointsEarned() != null && h.getPointsEarned() > 0) ? "+" : "";
    %>
        <tr>
            <td><%= h.getId() %></td>
            <td><%= h.getCreatedAt() != null ? h.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "-" %></td>
            <td><%= h.getOrderId() != null ? "#" + h.getOrderId() : "-" %></td>
            <td><%= (h.getAmount() != null && h.getAmount() > 0) ? String.format("%,.0f", h.getAmount()) : "-" %></td>
            <td class="<%= ptsClass %>"><%= ptsSign %><%= h.getPointsEarned() %></td>
            <td class="<%= typeClass %>"><%= h.getType() %></td>
        </tr>
    <% } %>
    </tbody>
</table>
<% } %>

<p><a href="${pageContext.request.contextPath}/admin/users">&larr; Back to Users</a></p>
</body>
</html>
