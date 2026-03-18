<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.ProphetForecast" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Forecast - TechStore Admin</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .forecast-header {
            margin-bottom: var(--space-xl);
        }

        .forecast-title {
            color: var(--text-primary);
            font-size: var(--text-3xl);
            font-weight: var(--font-weight-bold);
            margin-bottom: var(--space-2);
        }

        .forecast-subtitle {
            color: var(--text-secondary);
            font-size: var(--text-lg);
        }

        .forecast-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: var(--space-xl);
        }

        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-lg);
        }

        .chart-box {
            background: var(--surface-primary);
            border: 1px solid var(--border-primary);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: var(--transition-base);
        }

        .chart-box:hover {
            transform: translateY(-2px);
            box-shadow: var(--glass-shadow-medium);
        }

        .chart-box--full {
            grid-column: 1 / -1;
        }

        .chart-title {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            margin-bottom: var(--space-md);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .chart-image {
            width: 100%;
            height: auto;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-secondary);
        }

        .forecast-details {
            background: var(--surface-tertiary);
            border: 1px solid var(--border-secondary);
            padding: var(--space-md);
            border-radius: var(--radius-md);
            margin-bottom: var(--space-lg);
        }

        .forecast-details strong {
            color: var(--text-primary);
        }

        .status-badge {
            display: inline-block;
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-sm);
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            color: var(--text-inverse);
            background: var(--gradient-success);
        }

        .trigger-btn {
            position: relative;
            overflow: hidden;
            background: var(--gradient-primary);
            border: none;
            color: var(--text-inverse);
            font-weight: var(--font-weight-semibold);
            transition: var(--transition-base);
        }

        .trigger-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--glass-shadow-large);
        }

        .trigger-btn:active {
            transform: translateY(0);
        }

        .trigger-btn:disabled {
            background: var(--surface-tertiary);
            color: var(--text-tertiary);
            cursor: not-allowed;
            transform: none;
        }

        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid var(--text-inverse-tertiary);
            border-top: 2px solid var(--text-inverse);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-right: var(--space-2);
            vertical-align: middle;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .info-section {
            background: var(--surface-tertiary);
            border: 1px solid var(--border-secondary);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin-top: var(--space-lg);
        }

        .info-section h3 {
            color: var(--text-primary);
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            margin-top: 0;
            margin-bottom: var(--space-md);
        }

        .info-section ul {
            color: var(--text-secondary);
            line-height: 1.6;
        }

        .info-section li {
            margin-bottom: var(--space-2);
        }

        .timestamp {
            text-align: center;
            color: var(--text-tertiary);
            font-size: var(--text-sm);
            margin-top: var(--space-xl);
            padding-top: var(--space-lg);
            border-top: 1px solid var(--border-secondary);
        }

        @media (max-width: 768px) {
            .chart-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="bg-surface-secondary">
<%
    User currentUser = (User) session.getAttribute("user");
    boolean forecastAvailable = (Boolean) request.getAttribute("forecastAvailable");
    ProphetForecast forecast = (ProphetForecast) request.getAttribute("forecast");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String forecastPlotBase64 = (String) request.getAttribute("forecastPlotBase64");
    String monthlyBarBase64 = (String) request.getAttribute("monthlyBarBase64");
    String componentsPlotBase64 = (String) request.getAttribute("componentsPlotBase64");
%>

<!-- Admin Layout Container -->
<div class="admin-layout">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="forecast-header">
            <h1 class="forecast-title">📈 Sales Forecast</h1>
            <p class="forecast-subtitle">Powered by Facebook Prophet - AI-driven revenue predictions</p>
        </div>

        <!-- Admin Navigation -->
        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast" class="active">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <!-- Admin Content -->
    <div class="admin-content">
        <div class="forecast-grid">
            <%
                if (forecastAvailable && forecast != null) {
            %>
                <!-- Forecast Available -->
                <div class="surface-card">
                    <div class="message message--success mb-lg">
                        ✅ Forecast data is available and current
                    </div>

                    <div class="forecast-details">
                        <p><strong>Last Prediction Time:</strong> <%= forecast.predictedAt %></p>
                        <p><strong>Job ID:</strong> <code><%= forecast.jobId %></code></p>
                        <p><strong>Status:</strong> <span class="status-badge"><%= forecast.status.toUpperCase() %></span></p>
                    </div>

                    <div class="mb-lg">
                        <button class="btn btn--lg trigger-btn" id="forecastTriggerBtn" onclick="triggerForecast()">
                            🚀 Run New Forecast
                        </button>
                        <div id="forecastAlert" class="message mt-md" style="display: none;"></div>
                    </div>
                </div>

                <!-- Forecast Charts -->
                <div class="surface-card">
                    <h2 class="text-xl font-semibold text-primary mb-md">📊 Forecast Charts</h2>
                    <p class="text-secondary mb-lg">
                        These charts show predicted daily and monthly revenue for the next 3 months,
                        including confidence intervals (shaded areas).
                    </p>

                    <div class="chart-grid">
                        <div class="chart-box chart-box--full">
                            <h3 class="chart-title">📈 Full Timeline (Historical + Forecast)</h3>
                            <img src="data:image/png;base64,<%= forecastPlotBase64 %>" alt="Forecast Plot" class="chart-image">
                        </div>

                        <div class="chart-box">
                            <h3 class="chart-title">📊 Monthly Revenue</h3>
                            <img src="data:image/png;base64,<%= monthlyBarBase64 %>" alt="Monthly Bar Chart" class="chart-image">
                        </div>

                        <div class="chart-box">
                            <h3 class="chart-title">🔍 Trend Decomposition</h3>
                            <img src="data:image/png;base64,<%= componentsPlotBase64 %>" alt="Components Plot" class="chart-image">
                        </div>
                    </div>
                </div>

            <%
                } else {
            %>
                <!-- No Forecast Available -->
                <div class="surface-card">
                    <div class="message message--warning mb-lg">
                        ⚠️ <strong>No forecast available</strong>
                    </div>

                    <%
                        if (errorMessage != null && !errorMessage.isEmpty()) {
                    %>
                        <div class="message message--error mb-lg">
                            <strong>Error:</strong> <%= errorMessage %>
                        </div>
                    <%
                        }
                    %>

                    <p class="text-secondary mb-lg">
                        ℹ️ The forecast system runs automatically every day at <strong>2:00 AM</strong>.
                        <br/>It analyzes historical sales data and generates a 3-month revenue prediction using Facebook Prophet.
                        <br/>You can also manually trigger the forecast now:
                    </p>

                    <div class="mb-lg">
                        <button class="btn btn--lg trigger-btn" id="forecastTriggerBtn" onclick="triggerForecast()">
                            🚀 Run Forecast Now
                        </button>
                        <div id="forecastAlert" class="message mt-md" style="display: none;"></div>
                    </div>

                    <div class="info-section">
                        <h3>How it works:</h3>
                        <ul>
                            <li><strong>Data Collection:</strong> Daily revenue is extracted from all completed and pending orders</li>
                            <li><strong>Model Training:</strong> Prophet learns from historical sales patterns and trends</li>
                            <li><strong>Prediction:</strong> Generates 3-month forecasts with confidence intervals (95%)</li>
                            <li><strong>Visualization:</strong> Charts display trends, seasonality, and forecast ranges</li>
                        </ul>
                    </div>
                </div>

            <%
                }
            %>
        </div>

        <div class="timestamp">
            Forecast Engine: Facebook Prophet | Last Updated: <%= java.time.LocalDateTime.now() %>
        </div>
    </div>
</div>

<!-- Glassmorphism Interactive Effects -->
<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

<script>
// Forecast trigger function
function triggerForecast() {
    var btn = document.getElementById('forecastTriggerBtn');
    var alert = document.getElementById('forecastAlert');

    // Disable button and show loading state
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>Triggering forecast...';
    alert.style.display = 'block';
    alert.className = 'message message--info mt-md';
    alert.innerHTML = '⏳ Forecast job is running. This may take 2-5 minutes...';

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
            alert.className = 'message message--success mt-md';
            alert.innerHTML = '✅ ' + data.message + ' Refreshing page...';
            btn.innerHTML = '🚀 Run Forecast Now';
            btn.disabled = false;

            // Auto-refresh after 5 seconds
            setTimeout(function() {
                location.reload();
            }, 5000);
        } else {
            alert.className = 'message message--error mt-md';
            alert.innerHTML = '❌ ' + data.message;
            btn.innerHTML = '🚀 Run Forecast Now';
            btn.disabled = false;
        }
    })
    .catch(error => {
        alert.className = 'message message--error mt-md';
        alert.innerHTML = '❌ Error: ' + error.message;
        btn.innerHTML = '🚀 Run Forecast Now';
        btn.disabled = false;
    });
}
</script>

</body>
</html>