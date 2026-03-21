<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    </head>
<body class="bg-gradient-auth">

    <!-- Glass Reset Password Container -->
    <div class="auth-container">
        <!-- Logo -->
        <div class="login-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <!-- Glass Reset Password Card -->
        <div class="glass-card login-card">
            <!-- Back Link -->
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/login" class="btn btn--back btn--sm">
                    ← Back to Login
                </a>
            </div>

            <!-- Page Title -->
            <h1 class="text-3xl font-semibold text-center text-inverse mb-md">
                Create New Password
            </h1>

            <!-- Messages -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="message message--glass-error">
                    <%= error %>
                </div>
            <% } %>

            <% String token = (String) request.getAttribute("token"); %>
            <% String email = (String) request.getAttribute("email"); %>

            <% if (token != null && email != null) { %>
                <p class="text-center text-inverse-secondary mb-xl">
                    Creating new password for: <strong class="text-inverse"><%= email %></strong>
                </p>

                <!-- Reset Password Form -->
                <form method="post" action="${pageContext.request.contextPath}/reset-password">
                    <input type="hidden" name="token" value="<%= token %>">

                    <div class="form-group">
                        <label for="newPassword" class="form-label form-label--glass">
                            New Password <span class="required">*</span>
                        </label>
                        <div class="password-wrapper password-wrapper--glass">
                            <input type="password"
                                   id="newPassword"
                                   name="newPassword"
                                   class="form-input form-input--glass"
                                   placeholder="Enter your new password"
                                   required
                                   minlength="3"
                                   autofocus>
                            <span class="password-toggle" onclick="togglePassword(this, 'newPassword')">Show</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword" class="form-label form-label--glass">
                            Confirm Password <span class="required">*</span>
                        </label>
                        <div class="password-wrapper password-wrapper--glass">
                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   class="form-input form-input--glass"
                                   placeholder="Confirm your new password"
                                   required
                                   minlength="3">
                            <span class="password-toggle" onclick="togglePassword(this, 'confirmPassword')">Show</span>
                        </div>
                    </div>

                    <button type="submit" class="btn btn--success btn--lg mt-lg">
                        Update Password
                    </button>
                </form>

            <% } else { %>
                <div class="message message--glass-error">
                    Invalid or expired reset link. Please request a new password reset.
                </div>
                <div class="text-center mt-lg">
                    <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn--glass-primary">
                        Request New Reset Link
                    </a>
                </div>
            <% } %>

        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        function togglePassword(element, inputId) {
            const passwordInput = document.getElementById(inputId);
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                element.textContent = "Hide";
            } else {
                passwordInput.type = "password";
                element.textContent = "Show";
            }
        }

        // Password confirmation validation
        document.addEventListener('DOMContentLoaded', function() {
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');

            if (newPasswordInput && confirmPasswordInput) {
                confirmPasswordInput.addEventListener('blur', function() {
                    if (this.value && this.value !== newPasswordInput.value) {
                        this.classList.add('form-input--error');
                    } else {
                        this.classList.remove('form-input--error');
                    }
                });
            }
        });
    </script>

</body>
</html>
