<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.TierStatistic, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Loyalty Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .msg-success { color: green; margin-bottom: 10px; }
        .section { border: 1px solid #ccc; border-radius: 4px; padding: 16px; max-width: 500px; margin-bottom: 20px; }
        .section h2 { margin-top: 0; }
        .section label { display: inline-block; width: 120px; }
        .section input[type="number"] { width: 100px; padding: 4px; }
        table { border-collapse: collapse; max-width: 400px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .btn { display: inline-block; padding: 6px 14px; text-decoration: none;
               border: 1px solid #999; border-radius: 3px; cursor: pointer; }
        .btn-save { background: #2e7d32; color: white; border-color: #2e7d32; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    int pointRate    = (Integer) request.getAttribute("pointRate");
    List<TierStatistic> stats = (List<TierStatistic>) request.getAttribute("stats");
    String success = request.getParameter("success");
%>

<h1>Admin - Loyalty Management</h1>
<nav>
    Welcome, <strong><%= currentUser.getUsername() %></strong> |
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/users">User Management</a> |
    <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if ("updated".equals(success)) { %>
    <p class="msg-success">Point rate updated.</p>
<% } %>

<div class="section">
    <h2>Point Conversion Rate</h2>
    <p>Current rate: <strong><%= pointRate %></strong> points per 1,000 VND spent</p>
    <form method="post" action="${pageContext.request.contextPath}/admin/loyalty">
        <input type="hidden" name="action" value="updateRate">
        <label>New rate:</label>
        <input type="number" name="rate" value="<%= pointRate %>" min="1" required>
        <button type="submit" class="btn btn-save">Save</button>
    </form>
</div>

<div class="section">
    <h2>Members by Tier</h2>
    <% if (stats == null || stats.isEmpty()) { %>
        <p>No data.</p>
    <% } else { %>
    <table>
        <thead>
            <tr><th>Tier</th><th>Members</th></tr>
        </thead>
        <tbody>
        <% for (TierStatistic s : stats) { %>
            <tr>
                <td><%= s.getTier() %></td>
                <td><%= s.getTotal() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>

<p><a href="${pageContext.request.contextPath}/admin/users">Manage User Points &rarr;</a></p>
</body>
</html>
