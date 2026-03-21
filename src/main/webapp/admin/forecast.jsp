<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.ProphetForecast" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Forecast - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .chart-image { max-width: 100%; height: auto; border-radius: 0.375rem; box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075); margin-bottom: 1.5rem; }
    </style>
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
    boolean forecastAvailable = (Boolean) request.getAttribute("forecastAvailable");
    ProphetForecast forecast = (ProphetForecast) request.getAttribute("forecast");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String forecastPlotBase64 = (String) request.getAttribute("forecastPlotBase64");
    String monthlyBarBase64 = (String) request.getAttribute("monthlyBarBase64");
    String componentsPlotBase64 = (String) request.getAttribute("componentsPlotBase64");
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
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
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
        <div>
            <h1 class="h3 fw-bold mb-1"><i class="bi bi-robot text-success me-2"></i>Sales Forecast</h1>
            <p class="text-muted mb-0">Powered by Facebook Prophet - AI-driven revenue predictions</p>
        </div>
        <div class="text-muted small mt-2 mt-md-0">
            <i class="bi bi-clock-history me-1"></i>Last Updated: <%= java.time.LocalDateTime.now() %>
        </div>
    </div>

    <div class="row">
        <%
            if (forecastAvailable && forecast != null) {
        %>
            <!-- Forecast Available -->
            <div class="col-12 mb-4">
                <div class="card shadow-sm border-0 bg-success bg-opacity-10 border-start border-5 border-success">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                            <div>
                                <h5 class="fw-bold text-success mb-3"><i class="bi bi-check-circle-fill me-2"></i>Forecast data is available and current</h5>
                                <p class="mb-1"><strong class="text-dark">Last Prediction Time:</strong> <span class="text-muted"><%= forecast.predictedAt %></span></p>
                                <p class="mb-1"><strong class="text-dark">Job ID:</strong> <code class="bg-white px-2 py-1 rounded border"><%= forecast.jobId %></code></p>
                                <p class="mb-0">
                                    <strong class="text-dark">Status:</strong> 
                                    <span class="badge bg-success ms-1"><i class="bi bi-check-lg me-1"></i><%= forecast.status.toUpperCase() %></span>
                                </p>
                            </div>
                            <div>
                                <button class="btn btn-outline-success" id="forecastTriggerBtn" onclick="triggerForecast()">
                                    <i class="bi bi-rocket-takeoff me-1"></i> Run New Forecast
                                </button>
                            </div>
                        </div>
                        <div id="forecastAlert" class="alert mt-3 mb-0" style="display: none;"></div>
                    </div>
                </div>
            </div>

            <!-- Forecast Charts -->
            <div class="col-12">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-2">
                        <h4 class="fw-bold m-0"><i class="bi bi-bar-chart-fill text-primary me-2"></i>Forecast Charts</h4>
                        <p class="text-muted small mb-0 mt-1">
                            These charts show predicted daily and monthly revenue for the next 3 months,
                            including confidence intervals (shaded areas).
                        </p>
                    </div>
                    <div class="card-body">
                        <div class="row g-4">
                            <div class="col-12">
                                <h5 class="fw-bold border-bottom pb-2"><i class="bi bi-graph-up me-2"></i>Full Timeline (Historical + Forecast)</h5>
                                <img src="data:image/png;base64,<%= forecastPlotBase64 %>" alt="Forecast Plot" class="chart-image w-100">
                            </div>

                            <div class="col-lg-6">
                                <h5 class="fw-bold border-bottom pb-2"><i class="bi bi-bar-chart-line me-2"></i>Monthly Revenue</h5>
                                <img src="data:image/png;base64,<%= monthlyBarBase64 %>" alt="Monthly Bar Chart" class="chart-image w-100">
                            </div>

                            <div class="col-lg-6">
                                <h5 class="fw-bold border-bottom pb-2"><i class="bi bi-layers me-2"></i>Trend Decomposition</h5>
                                <img src="data:image/png;base64,<%= componentsPlotBase64 %>" alt="Components Plot" class="chart-image w-100">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <%
            } else {
        %>
            <!-- No Forecast Available -->
            <div class="col-md-8 mx-auto">
                <div class="card shadow-sm border-0 mt-4">
                    <div class="card-body p-5 text-center">
                        <i class="bi bi-exclamation-triangle-fill text-warning fs-1 mb-3 d-block"></i>
                        <h4 class="fw-bold mb-4">No Forecast Available</h4>

                        <%
                            if (errorMessage != null && !errorMessage.isEmpty()) {
                        %>
                            <div class="alert alert-danger mb-4 text-start">
                                <i class="bi bi-x-circle-fill me-2"></i><strong>Error:</strong> <%= errorMessage %>
                            </div>
                        <%
                            }
                        %>

                        <div class="bg-light p-4 rounded text-start mb-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-info-circle me-2 text-primary"></i>How it works:</h6>
                            <ul class="text-muted small mb-0">
                                <li class="mb-2"><strong>Data Collection:</strong> Daily revenue is extracted from all completed and pending orders</li>
                                <li class="mb-2"><strong>Model Training:</strong> Prophet learns from historical sales patterns and trends</li>
                                <li class="mb-2"><strong>Prediction:</strong> Generates 3-month forecasts with confidence intervals (95%)</li>
                                <li><strong>Visualization:</strong> Charts display trends, seasonality, and forecast ranges</li>
                            </ul>
                        </div>
                        
                        <p class="text-muted small mb-4">
                            ℹ️ The forecast system runs automatically every day at <strong>2:00 AM</strong>.
                            <br/>You can also manually trigger the forecast now:
                        </p>

                        <button class="btn btn-primary btn-lg px-5" id="forecastTriggerBtn" onclick="triggerForecast()">
                            <i class="bi bi-rocket-takeoff me-2"></i>Run Forecast Now
                        </button>
                        
                        <div id="forecastAlert" class="alert mt-4 text-start" style="display: none;"></div>
                    </div>
                </div>
            </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Forecast trigger function
function triggerForecast() {
    var btn = document.getElementById('forecastTriggerBtn');
    var alert = document.getElementById('forecastAlert');

    // Disable button and show loading state
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Triggering forecast...';
    alert.style.display = 'block';
    alert.className = 'alert alert-info mt-4 text-start';
    alert.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>⏳ Forecast job is running. This may take 2-5 minutes...';

    // Make API call
    fetch('${pageContext.request.contextPath}/admin/forecast/trigger', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert.className = 'alert alert-success mt-4 text-start';
            alert.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i>✅ ' + data.message + ' Refreshing page in 5 seconds...';
            btn.innerHTML = '<i class="bi bi-rocket-takeoff me-2"></i>Run Forecast Now';
            btn.disabled = false;

            // Auto-refresh after 5 seconds
            setTimeout(function() {
                location.reload();
            }, 5000);
        } else {
            alert.className = 'alert alert-danger mt-4 text-start';
            alert.innerHTML = '<i class="bi bi-x-circle-fill me-2"></i>❌ ' + data.message;
            btn.innerHTML = '<i class="bi bi-rocket-takeoff me-2"></i>Run Forecast Now';
            btn.disabled = false;
        }
    })
    .catch(error => {
        alert.className = 'alert alert-danger mt-4 text-start';
        alert.innerHTML = '<i class="bi bi-exclamation-triangle-fill me-2"></i>❌ Error: ' + error.message;
        btn.innerHTML = '<i class="bi bi-rocket-takeoff me-2"></i>Run Forecast Now';
        btn.disabled = false;
    });
}
</script>

</body>
</html>
