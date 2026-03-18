<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .welcome-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            padding: var(--space-lg);
        }

        .welcome-logo {
            font-size: var(--text-6xl);
            font-weight: var(--font-weight-bold);
            color: var(--text-inverse);
            text-shadow: 0 4px 8px rgba(0,0,0,0.3);
            margin-bottom: var(--space-xl);
            animation: logoFloat 3s ease-in-out infinite;
        }

        .welcome-message {
            font-size: var(--text-2xl);
            color: var(--text-inverse-secondary);
            margin-bottom: var(--space-xl);
            opacity: 0;
            animation: fadeIn 1s ease-out 0.5s forwards;
        }

        .loading-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: var(--space-lg);
            opacity: 0;
            animation: fadeIn 1s ease-out 1s forwards;
        }

        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top: 3px solid var(--text-inverse);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        .loading-text {
            color: var(--text-inverse-tertiary);
            font-size: var(--text-md);
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

    <!-- Auto-redirect script -->
    <script>
        // Enhanced redirect with loading animation
        setTimeout(function() {
            window.location.replace("${pageContext.request.contextPath}/products");
        }, 2000);

        // Preload the products page for faster transition
        document.addEventListener('DOMContentLoaded', function() {
            const link = document.createElement('link');
            link.rel = 'prefetch';
            link.href = '${pageContext.request.contextPath}/products';
            document.head.appendChild(link);
        });
    </script>
</head>
<body class="bg-gradient-auth">

    <div class="welcome-container">
        <!-- Welcome Logo -->
        <div class="welcome-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo" style="height: 96px; width: auto;">
        </div>

        <!-- Welcome Message -->
        <div class="welcome-message">
            Welcome to the Future of Shopping
        </div>

        <!-- Loading Animation -->
        <div class="loading-container">
            <div class="loading-spinner"></div>
            <div class="loading-text">
                Taking you to our products...
            </div>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>

