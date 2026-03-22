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
    <title>Income Report - Ruby Tech Admin</title>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
    int dayFilter   = (Integer) request.getAttribute("dayFilter");
    int monthFilter = (Integer) request.getAttribute("monthFilter");
    int yearFilter  = (Integer) request.getAttribute("yearFilter");
    @SuppressWarnings("unchecked") List<DailyIncome>   dayData   = (List<DailyIncome>)   request.getAttribute("dayData");
    @SuppressWarnings("unchecked") List<MonthlyIncome> monthData = (List<MonthlyIncome>) request.getAttribute("monthData");
    @SuppressWarnings("unchecked") List<YearlyIncome>  yearData  = (List<YearlyIncome>)  request.getAttribute("yearData");
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-graph-up text-primary me-2"></i>Income Reports</h1>
    <p class="text-muted mb-4">Comprehensive revenue analysis and trends</p>

    <!-- Charts Grid -->
    <div class="row g-4">
        <!-- Daily Income Chart -->
        <div class="col-12">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-2 d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <h5 class="fw-bold m-0"><i class="bi bi-bar-chart-line me-2 text-primary"></i>Daily Income Analysis</h5>
                    <div class="btn-group" role="group">
                        <a href="?dayFilter=7&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="btn btn-sm btn-outline-primary <%= dayFilter == 7 ? "active" : "" %>">Last 7 Days</a>
                        <a href="?dayFilter=14&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="btn btn-sm btn-outline-primary <%= dayFilter == 14 ? "active" : "" %>">Last 14 Days</a>
                        <a href="?dayFilter=30&monthFilter=<%= monthFilter %>&yearFilter=<%= yearFilter %>"
                           class="btn btn-sm btn-outline-primary <%= dayFilter == 30 ? "active" : "" %>">Last 30 Days</a>
                    </div>
                </div>
                <div class="card-body">
                    <div style="height: 350px; position: relative;">
                        <canvas id="dayChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Monthly Income Chart -->
        <div class="col-lg-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-2">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                        <h5 class="fw-bold m-0"><i class="bi bi-graph-up-arrow me-2 text-success"></i>Monthly Income Trends</h5>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-success dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Filter Months
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item <%= monthFilter == 1 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=1&yearFilter=<%= yearFilter %>">This Month</a></li>
                                <li><a class="dropdown-item <%= monthFilter == 2 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=2&yearFilter=<%= yearFilter %>">Last Month</a></li>
                                <li><a class="dropdown-item <%= monthFilter == 3 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=3&yearFilter=<%= yearFilter %>">3 Months</a></li>
                                <li><a class="dropdown-item <%= monthFilter == 6 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=6&yearFilter=<%= yearFilter %>">6 Months</a></li>
                                <li><a class="dropdown-item <%= monthFilter == 12 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=12&yearFilter=<%= yearFilter %>">12 Months</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-body pt-0">
                    <div style="height: 300px; position: relative;">
                        <canvas id="monthChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Yearly Income Chart -->
        <div class="col-lg-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-2">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                        <h5 class="fw-bold m-0"><i class="bi bi-calendar-check me-2 text-info"></i>Yearly Performance Overview</h5>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-info dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Filter Years
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item <%= yearFilter == 1 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=1">This Year</a></li>
                                <li><a class="dropdown-item <%= yearFilter == 2 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=2">Last 2 Years</a></li>
                                <li><a class="dropdown-item <%= yearFilter == 3 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=3">Last 3 Years</a></li>
                                <li><a class="dropdown-item <%= yearFilter == 5 ? "active" : "" %>" href="?dayFilter=<%= dayFilter %>&monthFilter=<%= monthFilter %>&yearFilter=5">Last 5 Years</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="card-body pt-0">
                    <div style="height: 300px; position: relative;">
                        <canvas id="yearChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
                        backgroundColor: "rgba(34, 197, 94, 0.8)", // Green 500
                        borderColor: "#22c55e",
                        borderWidth: 1,
                        borderRadius: 4,
                        order: 2
                    },
                    {
                        label: "Pending (₫)",
                        data: pending,
                        backgroundColor: "rgba(249, 115, 22, 0.8)", // Orange 500
                        borderColor: "#f97316",
                        borderWidth: 1,
                        borderRadius: 4,
                        order: 2
                    },
                    {
                        label: "Total (₫)",
                        data: total,
                        type: "line",
                        borderColor: "#3b82f6", // Blue 500
                        backgroundColor: "rgba(59, 130, 246, 0.1)",
                        borderWidth: 2,
                        pointRadius: 4,
                        fill: true,
                        tension: 0.3,
                        order: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: "index", intersect: false },
                scales: {
                    x: {
                        stacked: false,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)',
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)',
                        },
                        ticks: {
                            callback: function(v) { 
                                return new Intl.NumberFormat("vi-VN", { notation: "compact" }).format(v) + " ₫";
                            }
                        }
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
