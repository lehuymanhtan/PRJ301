<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.DailyIncome" %>
<%@ page import="models.MonthlyIncome" %>
<%@ page import="models.YearlyIncome" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Income Report – Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        h1   { margin-bottom: 6px; }
        .subtitle { color: #666; margin-bottom: 20px; }
        nav { margin-bottom: 24px; }
        nav a { margin-right: 12px; text-decoration: none; color: #333; }
        nav a:hover { text-decoration: underline; }

        .chart-card {
            background: white; border: 1px solid #ddd; border-radius: 6px;
            padding: 24px; margin-bottom: 28px;
        }
        .chart-card h2 { margin: 0 0 14px; font-size: 18px; }

        .filter-bar { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 18px; }
        .filter-bar a {
            display: inline-block; padding: 5px 14px;
            border: 1px solid #ccc; border-radius: 20px;
            text-decoration: none; color: #333; font-size: 13px;
            background: #f9f9f9; transition: background 0.15s;
        }
        .filter-bar a:hover  { background: #e0e0e0; }
        .filter-bar a.active {
            background: #2196f3; color: white;
            border-color: #1976d2; font-weight: bold;
        }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    int dayFilter   = (Integer) request.getAttribute("dayFilter");
    int monthFilter = (Integer) request.getAttribute("monthFilter");
    int yearFilter  = (Integer) request.getAttribute("yearFilter");
    @SuppressWarnings("unchecked") List<DailyIncome>   dayData   = (List<DailyIncome>)   request.getAttribute("dayData");
    @SuppressWarnings("unchecked") List<MonthlyIncome> monthData = (List<MonthlyIncome>) request.getAttribute("monthData");
    @SuppressWarnings("unchecked") List<YearlyIncome>  yearData  = (List<YearlyIncome>)  request.getAttribute("yearData");
%>

<h1>Income Report</h1>
<p class="subtitle">Logged in as <strong><%= currentUser.getUsername() %></strong></p>

<nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/users">Users</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Products</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a> |
    <a href="${pageContext.request.contextPath}/admin/orders">Orders</a> |
    <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a> |
    <a href="${pageContext.request.contextPath}/admin/income"><strong>Income Report</strong></a> |
    <a href="${pageContext.request.contextPath}/">Go to Shop</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<%-- ═══════════════════════════════════════════════════════════════
     CHART 1 — Income by Day
     ════════════════════════════════════════════════════════════════ --%>
<div class="chart-card">
    <h2>Income by Day</h2>
    <div class="filter-bar">
        <a href="?dayFilter=7&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
           class="<%= dayFilter == 7  ? "active" : "" %>">Last 7 Days</a>
        <a href="?dayFilter=14&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
           class="<%= dayFilter == 14 ? "active" : "" %>">Last 14 Days</a>
        <a href="?dayFilter=30&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
           class="<%= dayFilter == 30 ? "active" : "" %>">Last 30 Days</a>
    </div>
    <canvas id="dayChart" height="90"></canvas>
</div>

<%-- ═══════════════════════════════════════════════════════════════
     CHART 2 — Income by Month
     ════════════════════════════════════════════════════════════════ --%>
<div class="chart-card">
    <h2>Income by Month</h2>
    <div class="filter-bar">
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=1&yearFilter=<%= yearFilter %>"
           class="<%= monthFilter == 1  ? "active" : "" %>">This Month</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=2&yearFilter=<%= yearFilter %>"
           class="<%= monthFilter == 2  ? "active" : "" %>">Last Month</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=3&yearFilter=<%= yearFilter %>"
           class="<%= monthFilter == 3  ? "active" : "" %>">3 Months</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=6&yearFilter=<%= yearFilter %>"
           class="<%= monthFilter == 6  ? "active" : "" %>">6 Months</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=12&yearFilter=<%= yearFilter %>"
           class="<%= monthFilter == 12 ? "active" : "" %>">12 Months</a>
    </div>
    <canvas id="monthChart" height="90"></canvas>
</div>

<%-- ═══════════════════════════════════════════════════════════════
     CHART 3 — Income by Year
     ════════════════════════════════════════════════════════════════ --%>
<div class="chart-card">
    <h2>Income by Year</h2>
    <div class="filter-bar">
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=1"
           class="<%= yearFilter == 1 ? "active" : "" %>">This Year</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=2"
           class="<%= yearFilter == 2 ? "active" : "" %>">Last 2 Years</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=3"
           class="<%= yearFilter == 3 ? "active" : "" %>">Last 3 Years</a>
        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=5"
           class="<%= yearFilter == 5 ? "active" : "" %>">Last 5 Years</a>
    </div>
    <canvas id="yearChart" height="90"></canvas>
</div>

<script>
(function () {
    /* ── Daily chart data ── */
    var dayLabels = [<%
        if (dayData != null) {
            for (int i = 0; i < dayData.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + dayData.get(i).getIncomeDate() + "\"");
            }
        }
    %>];
    var dayCompleted = [<%
        if (dayData != null) {
            for (int i = 0; i < dayData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(dayData.get(i).getCompletedIncome());
            }
        }
    %>];
    var dayPending = [<%
        if (dayData != null) {
            for (int i = 0; i < dayData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(dayData.get(i).getPendingIncome());
            }
        }
    %>];
    var dayTotal = [<%
        if (dayData != null) {
            for (int i = 0; i < dayData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(dayData.get(i).getTotalIncome());
            }
        }
    %>];

    /* ── Monthly chart data ── */
    var monthLabels = [<%
        if (monthData != null) {
            for (int i = 0; i < monthData.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + monthData.get(i).getLabel() + "\"");
            }
        }
    %>];
    var monthCompleted = [<%
        if (monthData != null) {
            for (int i = 0; i < monthData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(monthData.get(i).getCompletedIncome());
            }
        }
    %>];
    var monthPending = [<%
        if (monthData != null) {
            for (int i = 0; i < monthData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(monthData.get(i).getPendingIncome());
            }
        }
    %>];
    var monthTotal = [<%
        if (monthData != null) {
            for (int i = 0; i < monthData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(monthData.get(i).getTotalIncome());
            }
        }
    %>];

    /* ── Yearly chart data ── */
    var yearLabels = [<%
        if (yearData != null) {
            for (int i = 0; i < yearData.size(); i++) {
                if (i > 0) out.print(",");
                out.print("\"" + yearData.get(i).getYear() + "\"");
            }
        }
    %>];
    var yearCompleted = [<%
        if (yearData != null) {
            for (int i = 0; i < yearData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(yearData.get(i).getCompletedIncome());
            }
        }
    %>];
    var yearPending = [<%
        if (yearData != null) {
            for (int i = 0; i < yearData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(yearData.get(i).getPendingIncome());
            }
        }
    %>];
    var yearTotal = [<%
        if (yearData != null) {
            for (int i = 0; i < yearData.size(); i++) {
                if (i > 0) out.print(",");
                out.print(yearData.get(i).getTotalIncome());
            }
        }
    %>];

    /* ── Chart factory ── */
    function vndFmt(v) {
        return new Intl.NumberFormat("vi-VN").format(v) + " ₫";
    }

    function buildChart(id, labels, completed, pending, total) {
        new Chart(document.getElementById(id), {
            type: "bar",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "Completed (₫)",
                        data: completed,
                        backgroundColor: "rgba(76,175,80,0.75)",
                        borderColor: "#4caf50",
                        borderWidth: 1,
                        order: 2
                    },
                    {
                        label: "Pending (₫)",
                        data: pending,
                        backgroundColor: "rgba(255,152,0,0.75)",
                        borderColor: "#ff9800",
                        borderWidth: 1,
                        order: 2
                    },
                    {
                        label: "Total (₫)",
                        data: total,
                        type: "line",
                        borderColor: "#2196f3",
                        backgroundColor: "rgba(33,150,243,0.08)",
                        borderWidth: 2,
                        pointRadius: 5,
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
                        ticks: { callback: function(v) { return vndFmt(v); } }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                return ctx.dataset.label + ": " + vndFmt(ctx.parsed.y);
                            }
                        }
                    }
                }
            }
        });
    }

    buildChart("dayChart",   dayLabels,   dayCompleted,   dayPending,   dayTotal);
    buildChart("monthChart", monthLabels, monthCompleted, monthPending, monthTotal);
    buildChart("yearChart",  yearLabels,  yearCompleted,  yearPending,  yearTotal);
}());
</script>
</body>
</html>
