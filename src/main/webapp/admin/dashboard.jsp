<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.DailyIncome" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        h1 { margin-bottom: 6px; }
        .subtitle { color: #666; margin-bottom: 20px; }
        nav { margin-bottom: 24px; }
        nav a { margin-right: 12px; text-decoration: none; color: #333; }
        nav a:hover { text-decoration: underline; }
        .cards { display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 32px; }
        .card {
            background: white; border: 1px solid #ddd; border-radius: 6px;
            padding: 24px 32px; min-width: 160px; text-align: center;
        }
        .card .count { font-size: 40px; font-weight: bold; margin-bottom: 6px; }
        .card .label { color: #666; font-size: 14px; }
        .card.blue   .count { color: #2196f3; }
        .card.green  .count { color: #4caf50; }
        .card.orange .count { color: #ff9800; }
        .card.purple .count { color: #9c27b0; }
        .links h2 { margin-bottom: 12px; }
        .links ul { list-style: none; padding: 0; }
        .links ul li { margin-bottom: 8px; }
        .links ul li a {
            display: inline-block; padding: 8px 18px;
            background: white; border: 1px solid #ccc; border-radius: 4px;
            text-decoration: none; color: #333; min-width: 200px;
        }
        .links ul li a:hover { background: #e8e8e8; }
        .income-section { margin-top: 32px; }
        .income-section h2 { margin-bottom: 12px; }
        .income-table {
            width: 100%; border-collapse: collapse; background: white;
            border: 1px solid #ddd; border-radius: 6px; overflow: hidden;
        }
        .income-table th, .income-table td {
            padding: 10px 16px; text-align: right; border-bottom: 1px solid #eee;
        }
        .income-table th { background: #f0f0f0; text-align: right; font-weight: bold; }
        .income-table th:first-child, .income-table td:first-child { text-align: left; }
        .income-table tr:last-child td { border-bottom: none; }
        .income-table .completed { color: #4caf50; }
        .income-table .pending   { color: #ff9800; }
        .income-table .total     { color: #2196f3; font-weight: bold; }
        .no-data { color: #999; font-style: italic; padding: 12px 0; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    int totalUsers     = (Integer) request.getAttribute("totalUsers");
    int totalProducts  = (Integer) request.getAttribute("totalProducts");
    int totalSuppliers = (Integer) request.getAttribute("totalSuppliers");
    int totalOrders    = (Integer) request.getAttribute("totalOrders");
    @SuppressWarnings("unchecked")
    List<DailyIncome> dailyIncome = (List<DailyIncome>) request.getAttribute("dailyIncome");
    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
%>

<h1>Admin Dashboard</h1>
<p class="subtitle">Welcome back, <strong><%= currentUser.getUsername() %></strong></p>

<nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard"><strong>Dashboard</strong></a> |
    <a href="${pageContext.request.contextPath}/admin/users">Users</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Products</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a> |
    <a href="${pageContext.request.contextPath}/admin/orders">Orders</a> |
    <a href="${pageContext.request.contextPath}/">Go to Shop</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="cards">
    <div class="card blue">
        <div class="count"><%= totalUsers %></div>
        <div class="label">Users</div>
    </div>
    <div class="card green">
        <div class="count"><%= totalProducts %></div>
        <div class="label">Products</div>
    </div>
    <div class="card orange">
        <div class="count"><%= totalSuppliers %></div>
        <div class="label">Suppliers</div>
    </div>
    <div class="card purple">
        <div class="count"><%= totalOrders %></div>
        <div class="label">Orders</div>
    </div>
</div>

<div class="links">
    <h2>Quick Links</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/admin/users">&#9654; Manage Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/products">&#9654; Manage Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/suppliers">&#9654; Manage Suppliers</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/orders">&#9654; Manage Orders</a></li>
    </ul>
</div>

<div class="income-section">
    <h2>Daily Income</h2>
    <%
        if (dailyIncome == null || dailyIncome.isEmpty()) {
    %>
        <p class="no-data">No income data available yet.</p>
    <%
        } else {
    %>
    <table class="income-table">
        <thead>
            <tr>
                <th>Date</th>
                <th>Completed Income (&#8363;)</th>
                <th>Pending Income (&#8363;)</th>
                <th>Total Income (&#8363;)</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (DailyIncome row : dailyIncome) {
        %>
            <tr>
                <td><%= row.getIncomeDate() %></td>
                <td class="completed"><%= nf.format(row.getCompletedIncome()) %></td>
                <td class="pending"><%= nf.format(row.getPendingIncome()) %></td>
                <td class="total"><%= nf.format(row.getTotalIncome()) %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        }
    %>
</div>
</body>
</html>
