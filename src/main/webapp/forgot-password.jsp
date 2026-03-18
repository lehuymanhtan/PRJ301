<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
</head>
<body class="bg-gradient-auth">

    <!-- Glass Forgot Password Container -->
    <div class="auth-container">
        <!-- Logo -->
        <div class="login-logo">
            ⚡ TechStore
        </div>

        <!-- Glass Forgot Password Card -->
        <div class="glass-card login-card">
            <!-- Back Link -->
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/login" class="btn btn--back btn--sm">
                    ← Back to Login
                </a>
            </div>

            <!-- Page Title -->
            <h1 class="text-3xl font-semibold text-center text-inverse mb-md">
                Reset Your Password
            </h1>
            <p class="text-center text-inverse-secondary mb-xl">
                Enter your email address and we'll send you a secure link to reset your password.
            </p>

            <!-- Messages -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="message message--glass-error">
                    <%= error %>
                </div>
            <% } %>

            <% String success = (String) request.getAttribute("success"); %>
            <% if (success != null) { %>
                <div class="message message--glass-success">
                    <%= success %>
                </div>
            <% } %>

            <!-- Forgot Password Form -->
            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <div class="form-group">
                    <label for="email" class="form-label form-label--glass">
                        Email Address <span class="required">*</span>
                    </label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-input form-input--glass"
                           placeholder="Enter your registered email"
                           required
                           autofocus>
                </div>

                <button type="submit" class="btn btn--glass-primary btn--lg mt-lg">
                    Send Reset Link
                </button>
            </form>

            <!-- Additional Info -->
            <div class="mt-xl p-4 bg-glass border border-glass-border rounded-lg">
                <div class="text-xs text-inverse-secondary text-center">
                    💡 <strong>Tip:</strong> Check your spam folder if you don't receive the email within a few minutes.
                </div>
            </div>

        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
