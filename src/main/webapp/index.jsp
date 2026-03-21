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
    <!-- Page-specific styles -->
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
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
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
