<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script>
        setTimeout(function() {
            window.location.replace("${pageContext.request.contextPath}/products");
        }, 2000);
    </script>
</head>
<body>
<div class="splash-screen">
    <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
    <h1 class="h3 fw-bold mb-2">Ruby Tech</h1>
    <p class="mb-4 opacity-75">Welcome to the Future of Shopping</p>
    <div class="spinner-border text-light mb-3" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <p class="small opacity-75">Taking you to our products...</p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
