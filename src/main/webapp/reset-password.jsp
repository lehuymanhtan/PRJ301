<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Ruby Tech</title>
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

        <h1 class="h4 text-center fw-bold mb-1">Create New Password</h1>

        <!-- Messages -->
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger auto-dismiss" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= error %>
            </div>
        <% } %>

        <% String token = (String) request.getAttribute("token"); %>
        <% String email = (String) request.getAttribute("email"); %>

        <% if (token != null && email != null) { %>
            <p class="text-center text-muted small mb-3">
                Creating new password for: <strong><%= email %></strong>
            </p>

            <form method="post" action="${pageContext.request.contextPath}/reset-password" id="resetForm">
                <input type="hidden" name="token" value="<%= token %>">

                <div class="mb-3">
                    <label for="newPassword" class="form-label fw-semibold">
                        New Password <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               id="newPassword"
                               name="newPassword"
                               class="form-control"
                               placeholder="Enter your new password"
                               required
                               minlength="3"
                               autofocus>
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePassword('newPassword', this)">Show</button>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label fw-semibold">
                        Confirm Password <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               class="form-control"
                               placeholder="Confirm your new password"
                               required
                               minlength="3">
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePassword('confirmPassword', this)">Show</button>
                    </div>
                </div>

                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-rt-primary btn-lg">
                        <i class="bi bi-key me-2"></i>Update Password
                    </button>
                </div>
            </form>

            <script>
                document.getElementById('resetForm').addEventListener('submit', function(e) {
                    const p1 = document.getElementById('newPassword').value;
                    const p2 = document.getElementById('confirmPassword').value;
                    if (p1 !== p2) {
                        e.preventDefault();
                        document.getElementById('confirmPassword').classList.add('is-invalid');
                        alert('Passwords do not match.');
                    }
                });
            </script>

        <% } else { %>
            <div class="alert alert-danger" role="alert">
                Invalid or expired reset link. Please request a new password reset.
            </div>
            <div class="d-grid">
                <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-rt-primary">
                    Request New Reset Link
                </a>
            </div>
        <% } %>

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
