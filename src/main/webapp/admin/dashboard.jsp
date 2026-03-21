<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.DailyIncome" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
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

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Admin Dashboard</h1>
            <p class="dashboard-subtitle">Welcome back, <strong><%= currentUser.getUsername() %></strong></p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
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

    <!-- Admin Content -->
    <div class="admin-content">
        <!-- Stats Grid -->
        <div class="stats-grid mb-xl">
            <div class="stats-card stats-card--info">
                <div class="stats-card__icon">👥</div>
                <div class="stats-card__value"><%= String.format("%,d", totalUsers) %></div>
                <div class="stats-card__label">Total Users</div>
            </div>

            <div class="stats-card stats-card--success">
                <div class="stats-card__icon">📦</div>
                <div class="stats-card__value"><%= String.format("%,d", totalProducts) %></div>
                <div class="stats-card__label">Products</div>
            </div>

            <div class="stats-card stats-card--warning">
                <div class="stats-card__icon">🏪</div>
                <div class="stats-card__value"><%= String.format("%,d", totalSuppliers) %></div>
                <div class="stats-card__label">Suppliers</div>
            </div>

            <div class="stats-card stats-card--primary">
                <div class="stats-card__icon">🛒</div>
                <div class="stats-card__value"><%= String.format("%,d", totalOrders) %></div>
                <div class="stats-card__label">Order Count</div>
            </div>

            <div class="stats-card">
                <div class="stats-card__icon">🔄</div>
                <div class="stats-card__value"><%= String.format("%,d", totalRefunds) %></div>
                <div class="stats-card__label">Refunds</div>
            </div>
        </div>

        <!-- Income Chart Section -->
        <div class="surface-card mb-xl">
            <h2 class="text-xl font-semibold text-primary mb-lg">Income Last 7 Days</h2>
            <div class="chart-container">
                <canvas id="dashboardChart"></canvas>
            </div>
            <div class="chart-footer">
                <a href="${pageContext.request.contextPath}/admin/income" class="btn btn--secondary btn--sm">
                    View full income report →
                </a>
            </div>
        </div>

        <!-- Quick Links Section -->
        <div class="surface-card">
            <h2 class="text-xl font-semibold text-primary mb-lg">Quick Access</h2>
            <div class="quick-links-grid">
                <a href="${pageContext.request.contextPath}/admin/users" class="quick-link">
                    <span class="quick-link-icon">👥</span>
                    <span class="quick-link-text">Manage Users</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/products" class="quick-link">
                    <span class="quick-link-icon">📦</span>
                    <span class="quick-link-text">Manage Products</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/suppliers" class="quick-link">
                    <span class="quick-link-icon">🏪</span>
                    <span class="quick-link-text">Manage Suppliers</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="quick-link">
                    <span class="quick-link-icon">🛒</span>
                    <span class="quick-link-text">Manage Orders</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/refunds" class="quick-link">
                    <span class="quick-link-icon">🔄</span>
                    <span class="quick-link-text">Manage Refunds</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/income" class="quick-link">
                    <span class="quick-link-icon">📊</span>
                    <span class="quick-link-text">Income Report</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/loyalty" class="quick-link">
                    <span class="quick-link-icon">⭐</span>
                    <span class="quick-link-text">Loyalty Management</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/forecast" class="quick-link">
                    <span class="quick-link-icon">📈</span>
                    <span class="quick-link-text">Sales Forecast</span>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Features -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

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

    // Modern glassmorphism-themed chart
    new Chart(document.getElementById("dashboardChart"), {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Completed Revenue (₫)",
                    data: completed,
                    backgroundColor: "rgba(34, 197, 94, 0.8)",
                    borderColor: "#22c55e",
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
                    order: 2
                },
                {
                    label: "Pending Revenue (₫)",
                    data: pending,
                    backgroundColor: "rgba(251, 146, 60, 0.8)",
                    borderColor: "#fb923c",
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
                    order: 2
                },
                {
                    label: "Total Revenue (₫)",
                    data: total,
                    type: "line",
                    borderColor: "#3b82f6",
                    backgroundColor: "rgba(59, 130, 246, 0.1)",
                    borderWidth: 3,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    pointBackgroundColor: "#3b82f6",
                    pointBorderColor: "#ffffff",
                    pointBorderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    order: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: "index",
                intersect: false
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        font: {
                            family: 'Poppins',
                            size: 14,
                            weight: '500'
                        },
                        color: '#f8fafc'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(17, 24, 39, 0.95)',
                    titleColor: '#f8fafc',
                    bodyColor: '#f8fafc',
                    borderColor: 'rgba(255, 255, 255, 0.25)',
                    borderWidth: 1,
                    cornerRadius: 12,
                    titleFont: {
                        family: 'Poppins',
                        size: 14,
                        weight: '600'
                    },
                    bodyFont: {
                        family: 'Poppins',
                        size: 13
                    },
                    callbacks: {
                        label: function(ctx) {
                            return ctx.dataset.label + ": " +
                                new Intl.NumberFormat("vi-VN").format(ctx.parsed.y) + " ₫";
                        }
                    }
                }
            },
            scales: {
                x: {
                    grid: {
                        color: 'rgba(255, 255, 255, 0.2)',
                        borderColor: 'rgba(255, 255, 255, 0.3)'
                    },
                    ticks: {
                        font: {
                            family: 'Poppins',
                            size: 12
                        },
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
                        font: {
                            family: 'Poppins',
                            size: 12
                        },
                        color: '#f8fafc',
                        callback: function(v) {
                            return new Intl.NumberFormat("vi-VN", {
                                notation: 'compact',
                                compactDisplay: 'short'
                            }).format(v) + " ₫";
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
