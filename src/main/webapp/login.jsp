<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Login-specific layout enhancements */
        .login-logo {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            justify-content: center;
            margin-bottom: var(--space-xl);
            font-size: var(--text-2xl);
            font-weight: var(--font-weight-bold);
            color: var(--text-inverse);
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            animation: fadeInScale var(--duration-500) var(--ease-out);
        }

        .form-footer {
            display: flex;
            flex-direction: column;
            gap: var(--space-md);
            margin-top: var(--space-lg);
            text-align: center;
        }

        .form-footer a {
            color: var(--text-inverse-secondary);
            transition: var(--transition-colors);
            font-size: var(--text-md);
        }

        .form-footer a:hover {
            color: var(--text-inverse);
        }

        .divider {
            margin: var(--space-md) 0;
            color: var(--text-inverse-tertiary);
            font-size: var(--text-sm);
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95) translateY(20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }
    </style>
</head>
<body class="bg-gradient-auth">
    <!-- Glass Login Container -->
    <div class="auth-container">
        <!-- Logo -->
        <div class="login-logo">
            ⚡ TechStore
        </div>

        <!-- Glass Login Card -->
        <div class="glass-card login-card">
            <!-- Back Link -->
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/" class="btn btn--back btn--sm">
                    ← Back to Store
                </a>
            </div>

            <!-- Page Title -->
            <h1 class="text-3xl font-semibold text-center text-inverse mb-lg">
                Welcome Back
            </h1>

            <!-- Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--glass-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="message message--glass-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <% String loginMsg = request.getParameter("msg");
               if ("account_deleted".equals(loginMsg)) { %>
                <div class="message message--glass-success">
                    Your account has been deleted.
                </div>
            <% } %>

            <% String successMessage = (String) session.getAttribute("successMessage");
               if (successMessage != null) { %>
                <div class="message message--glass-success">
                    <%= successMessage %>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>

            <!-- Login Form -->
            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label for="username" class="form-label form-label--glass">
                        Username <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="username"
                           name="username"
                           class="form-input form-input--glass"
                           placeholder="Enter your username"
                           required
                           autofocus>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label form-label--glass">
                        Password <span class="required">*</span>
                    </label>
                    <div class="password-wrapper password-wrapper--glass">
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-input form-input--glass"
                               placeholder="Enter your password"
                               required>
                        <span class="password-toggle" onclick="togglePassword(this)">Show</span>
                    </div>
                </div>

                <button type="submit" class="btn btn--glass-primary btn--lg mt-lg">
                    Sign In
                </button>
            </form>

            <!-- Footer Links -->
            <div class="form-footer">
                <a href="${pageContext.request.contextPath}/forgot-password" class="link--inverse">
                    Forgot your password?
                </a>

                <div class="divider">• • •</div>

                <div>
                    Don't have an account?
                    <a href="${pageContext.request.contextPath}/register" class="link--inverse font-medium">
                        Create Account
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        // Password toggle functionality
        function togglePassword(element) {
            const passwordInput = document.getElementById("password");
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                element.textContent = "Hide";
            } else {
                passwordInput.type = "password";
                element.textContent = "Show";
            }
        }

        // Enhanced form validation feedback
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const inputs = form.querySelectorAll('input[required]');

            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.classList.add('form-input--error');
                    } else {
                        this.classList.remove('form-input--error');
                    }
                });
            });

            // Auto-focus username if empty
            const usernameInput = document.getElementById('username');
            if (usernameInput && !usernameInput.value) {
                usernameInput.focus();
            }
        });
    </script>

</body>
</html>
