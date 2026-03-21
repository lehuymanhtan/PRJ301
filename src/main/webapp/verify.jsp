<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-gradient-auth">

    <!-- Glass Verify Container -->
    <div class="auth-container">
        <!-- Logo -->
        <div class="verify-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <!-- Glass Verification Card -->
        <div class="glass-card verify-card">
            <!-- Verification Icon -->
            <div class="verify-icon">
                ✉️
            </div>

            <!-- Page Title -->
            <h1 class="text-3xl font-semibold text-center text-inverse mb-md">
                Verify Your Email
            </h1>
            <p class="text-center text-inverse-secondary mb-xl">
                Enter the 6-digit code sent to your email address, or click the verification link in the email.
            </p>

            <!-- Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--glass-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("info") != null) { %>
                <div class="message message--glass-success">
                    <%= request.getAttribute("info") %>
                </div>
            <% } %>

            <!-- Verification Form -->
            <form method="post" action="${pageContext.request.contextPath}/verify" id="verifyForm">
                <input type="hidden" name="action" value="verify">

                <div class="form-group">
                    <label for="email" class="form-label form-label--glass">
                        Email Address
                    </label>
                    <input type="email"
                           id="emailDisplay"
                           name="email"
                           class="form-input form-input--glass"
                           placeholder="Enter your email"
                           required
                           readonly
                           value="${not empty param.email ? param.email : (not empty requestScope.email ? requestScope.email : '')}">
                </div>

                <div class="form-group">
                    <label for="code" class="form-label form-label--glass">
                        Verification Code
                    </label>
                    <input type="text"
                           id="code"
                           name="code"
                           class="form-input form-input--glass form-input--otp"
                           maxlength="6"
                           placeholder="000000"
                           autocomplete="one-time-code"
                           required
                           autofocus>
                    <div class="form-hint">
                        Check your inbox and spam folder. Code expires in 24 hours.
                    </div>
                </div>

                <button type="submit" class="btn btn--success btn--lg">
                    Verify Email Address
                </button>
            </form>

            <!-- Divider -->
            <hr class="form-divider">

            <!-- Resend Form -->
            <form method="post" action="${pageContext.request.contextPath}/verify" id="resendForm">
                <input type="hidden" name="action" value="resend">
                <input type="hidden" name="email"
                       value="${not empty requestScope.email ? requestScope.email : param.email}">

                <button type="submit" class="btn btn--secondary btn--lg">
                    🔄 Resend Verification Code
                </button>
            </form>

            <!-- Footer Links -->
            <div class="form-footer">
                <div>
                    Already verified?
                    <a href="${pageContext.request.contextPath}/login" class="link--inverse font-medium">
                        Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        // OTP input enhancement
        document.addEventListener('DOMContentLoaded', function() {
            const codeInput = document.getElementById('code');
            const verifyForm = document.getElementById('verifyForm');
            const resendForm = document.getElementById('resendForm');

            // Auto-focus and format OTP input
            if (codeInput) {
                codeInput.addEventListener('input', function() {
                    // Only allow numbers
                    this.value = this.value.replace(/[^0-9]/g, '');

                    // Auto-submit when 6 digits entered
                    if (this.value.length === 6) {
                        setTimeout(() => {
                            verifyForm.submit();
                        }, 500);
                    }
                });

                // Prevent pasting non-numeric content
                codeInput.addEventListener('paste', function(e) {
                    e.preventDefault();
                    const paste = (e.clipboardData || window.clipboardData).getData('text');
                    const numericPaste = paste.replace(/[^0-9]/g, '').slice(0, 6);
                    this.value = numericPaste;

                    if (numericPaste.length === 6) {
                        setTimeout(() => {
                            verifyForm.submit();
                        }, 500);
                    }
                });
            }

            // Resend cooldown
            let resendCooldown = false;
            resendForm.addEventListener('submit', function(e) {
                if (resendCooldown) {
                    e.preventDefault();
                    GlassUtils.showNotification('Please wait before requesting another code', 'warning');
                    return;
                }

                resendCooldown = true;
                const submitButton = this.querySelector('button[type="submit"]');
                const originalText = submitButton.textContent;

                // Cooldown for 30 seconds
                let countdown = 30;
                submitButton.disabled = true;

                const updateButton = () => {
                    submitButton.textContent = `⏳ Resend in ${countdown}s`;
                    countdown--;

                    if (countdown < 0) {
                        submitButton.textContent = originalText;
                        submitButton.disabled = false;
                        resendCooldown = false;
                    } else {
                        setTimeout(updateButton, 1000);
                    }
                };

                setTimeout(updateButton, 1000);
            });
        });
    </script>

</body>
</html>
