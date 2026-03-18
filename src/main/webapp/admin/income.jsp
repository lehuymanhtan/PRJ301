<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.DailyIncome" %>
<%@ page import="models.MonthlyIncome" %>
<%@ page import="models.YearlyIncome" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Income Report - TechStore Admin</title>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Income report specific enhancements */
        .report-header {
            margin-bottom: var(--space-xl);
        }

        .report-title {
            color: var(--text-primary);
            font-size: var(--text-3xl);
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-2);
        }

        .report-subtitle {
            color: var(--text-secondary);
            font-size: var(--text-lg);
        }

        .chart-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: var(--space-xl);
        }

        .chart-card {
            background: var(--surface-primary);
            border-radius: var(--radius-xl);
            padding: var(--space-xl);
            box-shadow: var(--glass-shadow-light);
            border: 1px solid var(--border-primary);
            transition: var(--transition-base);
        }

        .chart-card:hover {
            box-shadow: var(--glass-shadow-medium);
            transform: translateY(-2px);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-lg);
            padding-bottom: var(--space-md);
            border-bottom: 1px solid var(--border-secondary);
        }

        .chart-title {
            color: var(--text-primary);
            font-size: var(--text-xl);
            font-weight: var(--font-weight-semibold);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .filter-bar {
            display: flex;
            gap: var(--space-2);
            flex-wrap: wrap;
        }

        .filter-btn {
            display: inline-flex;
            align-items: center;
            padding: var(--space-2) var(--space-4);
            border: 1px solid var(--border-primary);
            border-radius: var(--radius-full);
            text-decoration: none;
            color: var(--text-secondary);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            background: var(--surface-secondary);
            transition: var(--transition-base);
        }

        .filter-btn:hover {
            background: var(--surface-tertiary);
            border-color: var(--glass-primary);
            color: var(--text-primary);
        }

        .filter-btn.active {
            background: var(--gradient-primary-light);
            color: var(--text-inverse);
            border-color: var(--glass-primary);
            font-weight: var(--font-weight-semibold);
        }

        .chart-container {
            position: relative;
            height: 350px;
            margin-top: var(--space-lg);
        }

        @media (min-width: 1024px) {
            .chart-container {
                height: 400px;
            }
        }

        /* Chart enhancements */
        .chart-loading {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 300px;
            color: var(--text-secondary);
            font-size: var(--text-lg);
        }

        .chart-icon {
            font-size: var(--text-2xl);
        }
    </style>
</head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    int dayFilter   = (Integer) request.getAttribute("dayFilter");
    int monthFilter = (Integer) request.getAttribute("monthFilter");
    int yearFilter  = (Integer) request.getAttribute("yearFilter");
    @SuppressWarnings("unchecked") List<DailyIncome>   dayData   = (List<DailyIncome>)   request.getAttribute("dayData");
    @SuppressWarnings("unchecked") List<MonthlyIncome> monthData = (List<MonthlyIncome>) request.getAttribute("monthData");
    @SuppressWarnings("unchecked") List<YearlyIncome>  yearData  = (List<YearlyIncome>)  request.getAttribute("yearData");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="report-header">
            <h1 class="report-title">Income Reports</h1>
            <p class="report-subtitle">Comprehensive revenue analysis and trends</p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income" class="active">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Charts Grid -->
        <div class="chart-grid">
            <!-- Daily Income Chart -->
            <div class="chart-card">
                <div class="chart-header">
                    <h2 class="chart-title">
                        <span class="chart-icon">📊</span>
                        Daily Income Analysis
                    </h2>
                    <div class="filter-bar">
                        <a href="?dayFilter=7&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= dayFilter == 7 ? "active" : "" %>">Last 7 Days</a>
                        <a href="?dayFilter=14&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= dayFilter == 14 ? "active" : "" %>">Last 14 Days</a>
                        <a href="?dayFilter=30&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= dayFilter == 30 ? "active" : "" %>">Last 30 Days</a>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="dayChart"></canvas>
                </div>
            </div>

            <!-- Monthly Income Chart -->
            <div class="chart-card">
                <div class="chart-header">
                    <h2 class="chart-title">
                        <span class="chart-icon">📈</span>
                        Monthly Income Trends
                    </h2>
                    <div class="filter-bar">
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=1&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= monthFilter == 1 ? "active" : "" %>">This Month</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=2&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= monthFilter == 2 ? "active" : "" %>">Last Month</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=3&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= monthFilter == 3 ? "active" : "" %>">3 Months</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=6&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= monthFilter == 6 ? "active" : "" %>">6 Months</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=12&yearFilter=<%= yearFilter %>"
                           class="filter-btn <%= monthFilter == 12 ? "active" : "" %>">12 Months</a>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="monthChart"></canvas>
                </div>
            </div>

            <!-- Yearly Income Chart -->
            <div class="chart-card">
                <div class="chart-header">
                    <h2 class="chart-title">
                        <span class="chart-icon">📅</span>
                        Yearly Performance Overview
                    </h2>
                    <div class="filter-bar">
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=1"
                           class="filter-btn <%= yearFilter == 1 ? "active" : "" %>">This Year</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=2"
                           class="filter-btn <%= yearFilter == 2 ? "active" : "" %>">Last 2 Years</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=3"
                           class="filter-btn <%= yearFilter == 3 ? "active" : "" %>">Last 3 Years</a>
                        <a href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=5"
                           class="filter-btn <%= yearFilter == 5 ? "active" : "" %>">Last 5 Years</a>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="yearChart"></canvas>
                </div>
            </div>
        </div>
    </div>
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
                    x: {
                        stacked: false,
                        grid: {
                            color: 'rgba(255, 255, 255, 0.2)',
                            borderColor: 'rgba(255, 255, 255, 0.3)'
                        },
                        ticks: {
                            color: '#f8fafc'
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(255, 255, 255, 0.2)',
                            borderColor: 'rgba(255, 255, 255, 0.3)'
                        },
                        ticks: {
                            color: '#f8fafc',
                            callback: function(v) { return vndFmt(v); }
                        }
                    }
                },
                plugins: {
                    legend: {
                        labels: {
                            color: '#f8fafc'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(17, 24, 39, 0.95)',
                        titleColor: '#f8fafc',
                        bodyColor: '#f8fafc',
                        borderColor: 'rgba(255, 255, 255, 0.25)',
                        borderWidth: 1,
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

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
