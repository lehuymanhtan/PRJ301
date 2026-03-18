<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        /* Register-specific layout enhancements */
        .register-logo {
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

        .register-card {
            width: 100%;
            max-width: 480px;
            animation: fadeInScale var(--duration-500) var(--ease-out);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-md);
        }

        .form-grid .form-group--full {
            grid-column: span 2;
        }

        .form-hint {
            font-size: var(--text-xs);
            color: var(--text-inverse-tertiary);
            margin-top: var(--space-1);
            font-style: italic;
        }

        .form-footer {
            display: flex;
            flex-direction: column;
            gap: var(--space-md);
            margin-top: var(--space-xl);
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

        .password-strength {
            margin-top: var(--space-2);
            font-size: var(--text-xs);
            color: var(--text-inverse-tertiary);
        }

        .password-strength--weak { color: var(--error); }
        .password-strength--medium { color: var(--warning); }
        .password-strength--strong { color: var(--success); }

        .divider {
            margin: var(--space-lg) 0;
            color: var(--text-inverse-tertiary);
            font-size: var(--text-sm);
        }

        @media (max-width: 640px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-grid .form-group--full {
                grid-column: span 1;
            }
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
    <!-- Glass Register Container -->
    <div class="auth-container">
        <!-- Logo -->
        <div class="register-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo" style="height: 44px; width: auto;">
            <span>Ruby Tech</span>
        </div>

        <!-- Glass Registration Card -->
        <div class="glass-card register-card">
            <!-- Page Title -->
            <h1 class="text-3xl font-semibold text-center text-inverse mb-lg">
                Create Your Account
            </h1>
            <p class="text-center text-inverse-secondary mb-xl">
                Join thousands of satisfied customers
            </p>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--glass-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <!-- Registration Form -->
            <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
                <div class="form-grid">
                    <!-- Username -->
                    <div class="form-group form-group--full">
                        <label for="username" class="form-label form-label--glass">
                            Username <span class="required">*</span>
                        </label>
                        <input type="text"
                               id="username"
                               name="username"
                               class="form-input form-input--glass"
                               placeholder="Choose a unique username"
                               required
                               autofocus
                               value="${param.username}"
                               data-validation="username">
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password" class="form-label form-label--glass">
                            Password <span class="required">*</span>
                        </label>
                        <div class="password-wrapper password-wrapper--glass">
                            <input type="password"
                                   id="password"
                                   name="password"
                                   class="form-input form-input--glass"
                                   placeholder="Create a password"
                                   required
                                   data-validation="password">
                            <span class="password-toggle" onclick="togglePassword(this, 'password')">Show</span>
                        </div>
                        <div class="form-hint">Minimum 3 characters required</div>
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label form-label--glass">
                            Confirm Password <span class="required">*</span>
                        </label>
                        <div class="password-wrapper password-wrapper--glass">
                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   class="form-input form-input--glass"
                                   placeholder="Confirm your password"
                                   required
                                   data-validation="confirmPassword">
                            <span class="password-toggle" onclick="togglePassword(this, 'confirmPassword')">Show</span>
                        </div>
                    </div>

                    <!-- Full Name -->
                    <div class="form-group form-group--full">
                        <label for="name" class="form-label form-label--glass">
                            Full Name <span class="required">*</span>
                        </label>
                        <input type="text"
                               id="name"
                               name="name"
                               class="form-input form-input--glass"
                               placeholder="Enter your full name"
                               required
                               value="${param.name}">
                    </div>

                    <!-- Gender -->
                    <div class="form-group">
                        <label for="gender" class="form-label form-label--glass">
                            Gender <span class="required">*</span>
                        </label>
                        <select id="gender" name="gender" class="form-select form-select--glass" required>
                            <option value="" disabled selected>Select gender</option>
                            <option value="male" ${param.gender == 'male' ? 'selected' : ''}>Male</option>
                            <option value="female" ${param.gender == 'female' ? 'selected' : ''}>Female</option>
                            <option value="other" ${param.gender == 'other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <!-- Date of Birth -->
                    <div class="form-group">
                        <label for="dateOfBirth" class="form-label form-label--glass">
                            Date of Birth <span class="required">*</span>
                        </label>
                        <input type="date"
                               id="dateOfBirth"
                               name="dateOfBirth"
                               class="form-input form-input--glass"
                               required
                               value="${param.dateOfBirth}">
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email" class="form-label form-label--glass">
                            Email Address <span class="required">*</span>
                        </label>
                        <input type="email"
                               id="email"
                               name="email"
                               class="form-input form-input--glass"
                               placeholder="your@email.com"
                               required
                               value="${param.email}"
                               data-validation="email">
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <label for="phone" class="form-label form-label--glass">
                            Phone Number
                        </label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               class="form-input form-input--glass"
                               placeholder="Optional phone number"
                               value="${param.phone}">
                    </div>
                </div>

                <button type="submit" class="btn btn--success btn--lg mt-xl">
                    Create Account
                </button>
            </form>

            <!-- Footer Links -->
            <div class="form-footer">
                <div class="divider">• • •</div>

                <div>
                    Already have an account?
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
        // Password toggle functionality
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

        // Enhanced form validation and UX
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const passwordStrength = document.getElementById('passwordStrength');

            // Password strength indicator
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                let strength = '';
                let strengthClass = '';

                if (password.length === 0) {
                    strength = '';
                } else if (password.length < 6) {
                    strength = 'Weak password';
                    strengthClass = 'password-strength--weak';
                } else if (password.length < 10) {
                    strength = 'Medium strength';
                    strengthClass = 'password-strength--medium';
                } else {
                    strength = 'Strong password';
                    strengthClass = 'password-strength--strong';
                }

                passwordStrength.textContent = strength;
                passwordStrength.className = `password-strength ${strengthClass}`;
            });

            // Confirm password validation
            confirmPasswordInput.addEventListener('blur', function() {
                if (this.value && this.value !== passwordInput.value) {
                    this.classList.add('form-input--error');
                } else {
                    this.classList.remove('form-input--error');
                }
            });

            // Real-time validation for all required fields
            const requiredInputs = form.querySelectorAll('input[required], select[required]');
            requiredInputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.classList.add('form-input--error');
                    } else {
                        this.classList.remove('form-input--error');
                    }
                });

                input.addEventListener('input', function() {
                    if (this.classList.contains('form-input--error') && this.value.trim() !== '') {
                        this.classList.remove('form-input--error');
                    }
                });
            });

            // Email validation
            const emailInput = document.getElementById('email');
            emailInput.addEventListener('blur', function() {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (this.value && !emailRegex.test(this.value)) {
                    this.classList.add('form-input--error');
                } else if (this.value) {
                    this.classList.remove('form-input--error');
                }
            });

            // Form submission validation
            form.addEventListener('submit', function(e) {
                let hasErrors = false;

                // Check password match
                if (passwordInput.value !== confirmPasswordInput.value) {
                    confirmPasswordInput.classList.add('form-input--error');
                    hasErrors = true;
                }

                // Check all required fields
                requiredInputs.forEach(input => {
                    if (input.value.trim() === '') {
                        input.classList.add('form-input--error');
                        hasErrors = true;
                    }
                });

                if (hasErrors) {
                    e.preventDefault();
                    GlassUtils.showNotification('Please fill in all required fields correctly', 'error');
                }
            });
        });
    </script>

</body>
</html>

