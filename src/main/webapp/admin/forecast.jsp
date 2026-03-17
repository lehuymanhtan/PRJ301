<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.ProphetForecast" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Forecast - Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
        }
        h1 {
            margin-bottom: 6px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 20px;
        }
        nav {
            margin-bottom: 24px;
            font-size: 14px;
        }
        nav a {
            margin-right: 12px;
            text-decoration: none;
            color: #333;
        }
        nav a:hover {
            text-decoration: underline;
        }
        .container {
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 24px;
            margin-bottom: 20px;
        }
        .info-bar {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .info-bar.error {
            background: #ffebee;
            border-left-color: #f44336;
        }
        .info-bar.warning {
            background: #fff3e0;
            border-left-color: #ff9800;
        }
        .prediction-details {
            background: #f9f9f9;
            border: 1px solid #eee;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .prediction-details strong {
            color: #333;
        }
        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .chart-box {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            background: #fafafa;
        }
        .chart-box h3 {
            margin: 0 0 12px 0;
            font-size: 14px;
            color: #333;
        }
        .chart-box img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
        }
        .full-width {
            grid-column: 1 / -1;
        }
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        .button-group a {
            display: inline-block;
            padding: 10px 20px;
            background: #2196f3;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            border: none;
            cursor: pointer;
        }
        .button-group a:hover {
            background: #1976d2;
        }
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #2196f3;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
            vertical-align: middle;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .trigger-btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .trigger-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .trigger-btn:active {
            transform: translateY(0);
        }
        .trigger-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 4px;
            margin-top: 12px;
            font-size: 14px;
            display: none;
        }
        .alert.success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            display: block;
        }
        .alert.error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            display: block;
        }
        .alert.info {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            display: block;
        }
        .spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #667eea;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
            margin-right: 8px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    boolean forecastAvailable = (Boolean) request.getAttribute("forecastAvailable");
    ProphetForecast forecast = (ProphetForecast) request.getAttribute("forecast");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String forecastPlotBase64 = (String) request.getAttribute("forecastPlotBase64");
    String monthlyBarBase64 = (String) request.getAttribute("monthlyBarBase64");
    String componentsPlotBase64 = (String) request.getAttribute("componentsPlotBase64");
%>

<h1>3-Month Sales Forecast</h1>
<p class="subtitle">Powered by Facebook Prophet - AI-driven revenue predictions</p>

<nav>
    <a href="${pageContext.request.contextPath}/admin/dashboard"><strong>Dashboard</strong></a> |
    <a href="${pageContext.request.contextPath}/admin/users">Users</a> |
    <a href="${pageContext.request.contextPath}/admin/products">Products</a> |
    <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a> |
    <a href="${pageContext.request.contextPath}/admin/orders">Orders</a> |
    <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a> |
    <a href="${pageContext.request.contextPath}/admin/income">Income Report</a> |
    <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a> |
    <a href="${pageContext.request.contextPath}/">Go to Shop</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="container">
    <%
        if (forecastAvailable && forecast != null) {
    %>
        <div class="info-bar">
            ✓ Forecast data is available and current
        </div>

        <div class="prediction-details">
            <strong>Last Prediction Time:</strong> <%= forecast.predictedAt %> <br/>
            <strong>Job ID:</strong> <code><%= forecast.jobId %></code> <br/>
            <strong>Status:</strong> <span style="color: #4caf50; font-weight: bold;"><%= forecast.status.toUpperCase() %></span>
        </div>

        <div style="margin-bottom: 20px;">
            <button class="trigger-btn" id="forecastTriggerBtn" onclick="triggerForecast()">
                🚀 Run New Forecast
            </button>
            <div id="forecastAlert" class="alert"></div>
        </div>

        <h2 style="margin-top: 24px; margin-bottom: 16px;">Forecast Charts</h2>
        <p style="color: #666; font-size: 14px; margin-bottom: 20px;">
            These charts show predicted daily and monthly revenue for the next 3 months,
            including confidence intervals (shaded areas).
        </p>

        <div class="chart-grid">
            <div class="chart-box full-width">
                <h3>📈 Full Timeline (Historical + Forecast)</h3>
                <img src="data:image/png;base64,<%= forecastPlotBase64 %>" alt="Forecast Plot">
            </div>

            <div class="chart-box">
                <h3>📊 Monthly Revenue Bar Chart</h3>
                <img src="data:image/png;base64,<%= monthlyBarBase64 %>" alt="Monthly Bar Chart">
            </div>

            <div class="chart-box">
                <h3>🔍 Trend Decomposition</h3>
                <img src="data:image/png;base64,<%= componentsPlotBase64 %>" alt="Components Plot">
            </div>
        </div>

    <%
        } else {
    %>
        <div class="info-bar warning">
            <strong>⚠️ No forecast available</strong>
        </div>

        <%
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="info-bar error">
                <strong>Error:</strong> <%= errorMessage %>
            </div>
        <%
            }
        %>

        <p style="color: #666; font-size: 14px; margin: 20px 0;">
            ℹ️ The forecast system runs automatically every day at <strong>2:00 AM</strong>.
            <br/>It analyzes historical sales data and generates a 3-month revenue prediction using Facebook Prophet.
            <br/>You can also manually trigger the forecast now:
        </p>

        <div style="margin-bottom: 20px;">
            <button class="trigger-btn" id="forecastTriggerBtn" onclick="triggerForecast()">
                🚀 Run Forecast Now
            </button>
            <div id="forecastAlert" class="alert"></div>
        </div>

        <div style="background: #f9f9f9; border: 1px solid #ddd; border-radius: 4px; padding: 16px; margin-top: 20px;">
            <h3 style="margin-top: 0;">How it works:</h3>
            <ul style="color: #666; line-height: 1.6;">
                <li><strong>Data Collection:</strong> Daily revenue is extracted from all completed and pending orders</li>
                <li><strong>Model Training:</strong> Prophet learns from historical sales patterns and trends</li>
                <li><strong>Prediction:</strong> Generates 3-month forecasts with confidence intervals (95%)</li>
                <li><strong>Visualization:</strong> Charts display trends, seasonality, and forecast ranges</li>
            </ul>
        </div>

    <%
        }
    %>
</div>

<div style="text-align: center; color: #999; font-size: 12px; margin-top: 40px;">
    Forecast Engine: Facebook Prophet | Last Updated: <%= java.time.LocalDateTime.now() %>
</div>

<script>
// Forecast trigger function
function triggerForecast() {
    var btn = document.getElementById('forecastTriggerBtn');
    var alert = document.getElementById('forecastAlert');

    // Disable button and show loading state
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>Triggering forecast...';
    alert.innerHTML = '';
    alert.className = 'alert info';
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
            alert.className = 'alert success';
            alert.innerHTML = '✓ ' + data.message + ' Refreshing page...';
            btn.innerHTML = '🚀 Run Forecast Now';
            btn.disabled = false;

            // Auto-refresh after 5 seconds
            setTimeout(function() {
                location.reload();
            }, 5000);
        } else {
            alert.className = 'alert error';
            alert.innerHTML = '✗ ' + data.message;
            btn.innerHTML = '🚀 Run Forecast Now';
            btn.disabled = false;
        }
    })
    .catch(error => {
        alert.className = 'alert error';
        alert.innerHTML = '✗ Error: ' + error.message;
        btn.innerHTML = '🚀 Run Forecast Now';
        btn.disabled = false;
    });
}
</script>

</body>
</html>
