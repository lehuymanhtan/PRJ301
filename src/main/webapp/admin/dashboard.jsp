<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.DailyIncome, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser   = (User) session.getAttribute("user");
    int totalUsers     = (Integer) request.getAttribute("totalUsers");
    int totalProducts  = (Integer) request.getAttribute("totalProducts");
    int totalSuppliers = (Integer) request.getAttribute("totalSuppliers");
    int totalOrders    = (Integer) request.getAttribute("totalOrders");
    int totalRefunds   = (Integer) request.getAttribute("totalRefunds");
    @SuppressWarnings("unchecked")
    List<DailyIncome> chartData = (List<DailyIncome>) request.getAttribute("dashboardChartData");
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</h1>
    <p class="text-muted mb-4">Welcome back, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong></p>

    <!-- Stats Grid -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-4 col-xl-2-4">
            <div class="card stat-card stat-card-blue">
                <div class="card-body text-center">
                    <i class="bi bi-people fs-2 mb-2 d-block"></i>
                    <div class="stat-value"><%= String.format("%,d", totalUsers) %></div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-4 col-xl-2-4">
            <div class="card stat-card stat-card-green">
                <div class="card-body text-center">
                    <i class="bi bi-box-seam fs-2 mb-2 d-block"></i>
                    <div class="stat-value"><%= String.format("%,d", totalProducts) %></div>
                    <div class="stat-label">Products</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-4 col-xl-2-4">
            <div class="card stat-card stat-card-orange">
                <div class="card-body text-center">
                    <i class="bi bi-building fs-2 mb-2 d-block"></i>
                    <div class="stat-value"><%= String.format("%,d", totalSuppliers) %></div>
                    <div class="stat-label">Suppliers</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-4 col-xl-2-4">
            <div class="card stat-card stat-card-purple">
                <div class="card-body text-center">
                    <i class="bi bi-bag-check fs-2 mb-2 d-block"></i>
                    <div class="stat-value"><%= String.format("%,d", totalOrders) %></div>
                    <div class="stat-label">Orders</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-4 col-xl-2-4">
            <div class="card stat-card" style="background:linear-gradient(135deg,#dc2626,#b91c1c)">
                <div class="card-body text-center text-white">
                    <i class="bi bi-arrow-counterclockwise fs-2 mb-2 d-block"></i>
                    <div class="stat-value"><%= String.format("%,d", totalRefunds) %></div>
                    <div class="stat-label">Refunds</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-bar-chart me-2"></i>Income Last 7 Days</div>
        <div class="card-body">
            <div style="height:320px;position:relative">
                <canvas id="dashboardChart"></canvas>
            </div>
            <div class="text-end mt-2">
                <a href="${pageContext.request.contextPath}/admin/income" class="btn btn-sm btn-outline-secondary">
                    View full income report <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="card shadow-sm">
        <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-lightning me-2"></i>Quick Access</div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary w-100"><i class="bi bi-people me-2"></i>Manage Users</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-success w-100"><i class="bi bi-box-seam me-2"></i>Manage Products</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn-outline-warning w-100"><i class="bi bi-building me-2"></i>Manage Suppliers</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-info w-100"><i class="bi bi-bag-check me-2"></i>Manage Orders</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/refunds" class="btn btn-outline-danger w-100"><i class="bi bi-arrow-counterclockwise me-2"></i>Manage Refunds</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/income" class="btn btn-outline-secondary w-100"><i class="bi bi-bar-chart me-2"></i>Income Report</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/loyalty" class="btn btn-outline-primary w-100"><i class="bi bi-gem me-2"></i>Loyalty</a></div>
                <div class="col-6 col-md-3"><a href="${pageContext.request.contextPath}/admin/forecast" class="btn btn-outline-success w-100"><i class="bi bi-graph-up-arrow me-2"></i>Forecast</a></div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
(function() {
    var labels    = [<% if (chartData != null) { for (int i = 0; i < chartData.size(); i++) { if (i>0) out.print(","); out.print("\"" + chartData.get(i).getIncomeDate() + "\""); } } %>];
    var completed = [<% if (chartData != null) { for (int i = 0; i < chartData.size(); i++) { if (i>0) out.print(","); out.print(chartData.get(i).getCompletedIncome()); } } %>];
    var pending   = [<% if (chartData != null) { for (int i = 0; i < chartData.size(); i++) { if (i>0) out.print(","); out.print(chartData.get(i).getPendingIncome()); } } %>];
    var total     = [<% if (chartData != null) { for (int i = 0; i < chartData.size(); i++) { if (i>0) out.print(","); out.print(chartData.get(i).getTotalIncome()); } } %>];

    new Chart(document.getElementById("dashboardChart"), {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                { label: "Completed Revenue (₫)", data: completed, backgroundColor: "rgba(34,197,94,0.8)", borderColor: "#22c55e", borderWidth: 2, borderRadius: 6, order: 2 },
                { label: "Pending Revenue (₫)",   data: pending,   backgroundColor: "rgba(251,146,60,0.8)", borderColor: "#fb923c", borderWidth: 2, borderRadius: 6, order: 2 },
                { label: "Total Revenue (₫)",      data: total,     type: "line", borderColor: "#3b82f6", backgroundColor: "rgba(59,130,246,0.1)", borderWidth: 3, pointRadius: 5, fill: true, tension: 0.4, order: 1 }
            ]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            interaction: { mode: "index", intersect: false },
            plugins: {
                legend: { position: "top" },
                tooltip: { callbacks: { label: function(ctx) { return ctx.dataset.label + ": " + new Intl.NumberFormat("vi-VN").format(ctx.parsed.y) + " ₫"; } } }
            },
            scales: {
                y: { beginAtZero: true, ticks: { callback: function(v) { return new Intl.NumberFormat("vi-VN", { notation: "compact" }).format(v) + " ₫"; } } }
            }
        }
    });
}());
</script>
</body>
</html>
