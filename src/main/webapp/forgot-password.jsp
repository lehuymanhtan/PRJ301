<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <!-- Logo -->
        <div class="auth-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <h1 class="h4 text-center fw-bold mb-1">Reset Your Password</h1>
        <p class="text-center text-muted small mb-4">
            Enter your email and we'll send you a reset link.
        </p>

        <!-- Messages -->
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger auto-dismiss" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= error %>
            </div>
        <% } %>

        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="alert alert-success auto-dismiss" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= success %>
            </div>
        <% } %>

        <!-- Forgot Password Form -->
        <form method="post" action="${pageContext.request.contextPath}/forgot-password">
            <div class="mb-3">
                <label for="email" class="form-label fw-semibold">
                    Email Address <span class="text-danger">*</span>
                </label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="Enter your registered email"
                       required
                       autofocus>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-rt-primary btn-lg">
                    <i class="bi bi-envelope me-2"></i>Send Reset Link
                </button>
            </div>
        </form>

        <div class="alert alert-light mt-3 small text-muted text-center mb-0" role="alert">
            <i class="bi bi-lightbulb text-warning me-1"></i>
            <strong>Tip:</strong> Check your spam folder if you don't receive the email within a few minutes.
        </div>

        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Back to Login
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
