<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ruby Tech</title>
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

        <h1 class="h4 text-center fw-bold mb-1">Welcome Back</h1>
        <p class="text-center text-muted small mb-4">Sign in to your account</p>

        <!-- Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger auto-dismiss" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success auto-dismiss" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% String loginMsg = request.getParameter("msg");
           if ("account_deleted".equals(loginMsg)) { %>
            <div class="alert alert-info auto-dismiss" role="alert">
                Your account has been deleted.
            </div>
        <% } %>

        <% String successMessage = (String) session.getAttribute("successMessage");
           if (successMessage != null) { %>
            <div class="alert alert-success auto-dismiss" role="alert">
                <i class="bi bi-check-circle me-2"></i><%= successMessage %>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>

        <!-- Login Form -->
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">
                    Username <span class="text-danger">*</span>
                </label>
                <input type="text"
                       id="username"
                       name="username"
                       class="form-control"
                       placeholder="Enter your username"
                       required
                       autofocus>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label fw-semibold">
                    Password <span class="text-danger">*</span>
                </label>
                <div class="input-group">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="Enter your password"
                           required>
                    <button class="btn btn-outline-secondary" type="button"
                            onclick="togglePassword('password', this)">Show</button>
                </div>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-rt-primary btn-lg">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                </button>
            </div>
        </form>

        <!-- Footer Links -->
        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/forgot-password" class="text-muted small">
                Forgot your password?
            </a>
        </div>
        <hr>
        <p class="text-center small mb-0">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-orange">Create Account</a>
        </p>
        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Back to Store
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
