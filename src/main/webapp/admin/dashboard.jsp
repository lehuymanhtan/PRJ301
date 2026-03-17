<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.DailyIncome" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
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
        .chart-section {
            margin-top: 32px; background: white; border: 1px solid #ddd;
            border-radius: 6px; padding: 24px;
        }
        .chart-section h2 { margin: 0 0 16px; }
        .chart-section .chart-footer {
            margin-top: 10px; text-align: right;
        }
        .chart-section .chart-footer a {
            font-size: 13px; color: #2196f3; text-decoration: none;
        }
        .chart-section .chart-footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    int totalUsers     = (Integer) request.getAttribute("totalUsers");
    int totalProducts  = (Integer) request.getAttribute("totalProducts");
    int totalSuppliers = (Integer) request.getAttribute("totalSuppliers");
    int totalOrders    = (Integer) request.getAttribute("totalOrders");
    int totalRefunds   = (Integer) request.getAttribute("totalRefunds");
    @SuppressWarnings("unchecked")
    List<DailyIncome> chartData = (List<DailyIncome>) request.getAttribute("dashboardChartData");
%>

<h1>Admin Dashboard</h1>
<p class="subtitle">Welcome back, <strong><%= currentUser.getUsername() %></strong></p>

<nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard"><strong>Dashboard</strong></a> |
    <a href="${pageContext.request.contextPath}/admin/users">Users</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Products</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a> |
    <a href="${pageContext.request.contextPath}/admin/orders">Orders</a> |
    <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a> |
    <a href="${pageContext.request.contextPath}/admin/income">Income Report</a> |
    <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a> |
    <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a> |
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
    <div class="card" style="border-color:#ddd;">
        <div class="count" style="color:#e53935;"><%= totalRefunds %></div>
        <div class="label">Refunds</div>
    </div>
</div>

<div class="chart-section">
    <h2>Income Last 7 Days</h2>
    <canvas id="dashboardChart" height="90"></canvas>
    <div class="chart-footer">
        <a href="${pageContext.request.contextPath}/admin/income">View full income report &rarr;</a>
    </div>
</div>

<div class="links" style="margin-top:32px;">
    <h2>Quick Links</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/admin/users">&#9654; Manage Users</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/products">&#9654; Manage Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/suppliers">&#9654; Manage Suppliers</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/orders">&#9654; Manage Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/refunds">&#9654; Manage Refunds</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/income">&#9654; Income Report</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/loyalty">&#9654; Loyalty Management</a></li>
    </ul>
</div>

<script>
(function () {
    var labels    = [<%
        if (chartData != null) {
            for (int i = 0; i < chartData.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + chartData.get(i).getIncomeDate() + "\"");
            }
        }
    %>];
    var completed = [<%
        if (chartData != null) {
            for (int i = 0; i < chartData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(chartData.get(i).getCompletedIncome());
            }
        }
    %>];
    var pending   = [<%
        if (chartData != null) {
            for (int i = 0; i < chartData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(chartData.get(i).getPendingIncome());
            }
        }
    %>];
    var total     = [<%
        if (chartData != null) {
            for (int i = 0; i < chartData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(chartData.get(i).getTotalIncome());
            }
        }
    %>];

    new Chart(document.getElementById("dashboardChart"), {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Completed (\u20AB)",
                    data: completed,
                    backgroundColor: "rgba(76,175,80,0.7)",
                    borderColor: "#4caf50",
                    borderWidth: 1,
                    order: 2
                },
                {
                    label: "Pending (\u20AB)",
                    data: pending,
                    backgroundColor: "rgba(255,152,0,0.7)",
                    borderColor: "#ff9800",
                    borderWidth: 1,
                    order: 2
                },
                {
                    label: "Total (\u20AB)",
                    data: total,
                    type: "line",
                    borderColor: "#2196f3",
                    backgroundColor: "rgba(33,150,243,0.08)",
                    borderWidth: 2,
                    pointRadius: 4,
                    fill: false,
                    tension: 0.3,
                    order: 1
                }
            ]
        },
        options: {
            responsive: true,
            interaction: { mode: "index", intersect: false },
            scales: {
                x: { stacked: false },
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(v) {
                            return new Intl.NumberFormat("vi-VN").format(v) + " \u20AB";
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            return ctx.dataset.label + ": " +
                                new Intl.NumberFormat("vi-VN").format(ctx.parsed.y) + " \u20AB";
                        }
                    }
                }
            }
        }
    });
}());
</script>
</body>
</html>
