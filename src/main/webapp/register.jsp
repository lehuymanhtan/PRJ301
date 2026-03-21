<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<div class="auth-wrapper" style="padding: 2rem 1rem;">
    <div class="auth-card" style="max-width:600px;">
        <!-- Logo -->
        <div class="auth-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <h1 class="h4 text-center fw-bold mb-1">Create Your Account</h1>
        <p class="text-center text-muted small mb-4">Join thousands of satisfied customers</p>

        <!-- Error Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger auto-dismiss" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Registration Form -->
        <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
            <!-- Username -->
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">
                    Username <span class="text-danger">*</span>
                </label>
                <input type="text"
                       id="username"
                       name="username"
                       class="form-control"
                       placeholder="Choose a unique username"
                       required
                       autofocus
                       value="${param.username}">
            </div>

            <div class="row g-3">
                <!-- Password -->
                <div class="col-md-6">
                    <label for="password" class="form-label fw-semibold">
                        Password <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               placeholder="Create a password"
                               required>
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePassword('password', this)">Show</button>
                    </div>
                    <div class="form-text">Minimum 3 characters</div>
                    <div id="passwordStrength" class="form-text fw-semibold"></div>
                </div>

                <!-- Confirm Password -->
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label fw-semibold">
                        Confirm Password <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               class="form-control"
                               placeholder="Confirm your password"
                               required>
                        <button class="btn btn-outline-secondary" type="button"
                                onclick="togglePassword('confirmPassword', this)">Show</button>
                    </div>
                </div>

                <!-- Full Name -->
                <div class="col-12">
                    <label for="name" class="form-label fw-semibold">
                        Full Name <span class="text-danger">*</span>
                    </label>
                    <input type="text"
                           id="name"
                           name="name"
                           class="form-control"
                           placeholder="Enter your full name"
                           required
                           value="${param.name}">
                </div>

                <!-- Gender -->
                <div class="col-md-6">
                    <label for="gender" class="form-label fw-semibold">
                        Gender <span class="text-danger">*</span>
                    </label>
                    <select id="gender" name="gender" class="form-select" required>
                        <option value="" disabled selected>Select gender</option>
                        <option value="male" ${param.gender == 'male' ? 'selected' : ''}>Male</option>
                        <option value="female" ${param.gender == 'female' ? 'selected' : ''}>Female</option>
                        <option value="other" ${param.gender == 'other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <!-- Date of Birth -->
                <div class="col-md-6">
                    <label for="dateOfBirth" class="form-label fw-semibold">
                        Date of Birth <span class="text-danger">*</span>
                    </label>
                    <input type="date"
                           id="dateOfBirth"
                           name="dateOfBirth"
                           class="form-control"
                           required
                           value="${param.dateOfBirth}">
                </div>

                <!-- Email -->
                <div class="col-md-6">
                    <label for="email" class="form-label fw-semibold">
                        Email Address <span class="text-danger">*</span>
                    </label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-control"
                           placeholder="your@email.com"
                           required
                           value="${param.email}">
                </div>

                <!-- Phone -->
                <div class="col-md-6">
                    <label for="phone" class="form-label fw-semibold">Phone Number</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           class="form-control"
                           placeholder="Optional phone number"
                           value="${param.phone}">
                </div>
            </div>

            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-rt-primary btn-lg">
                    <i class="bi bi-person-plus me-2"></i>Create Account
                </button>
            </div>
        </form>

        <hr>
        <p class="text-center small mb-0">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-orange">Sign In</a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const passwordStrength = document.getElementById('passwordStrength');

    passwordInput.addEventListener('input', function() {
        const pw = this.value;
        if (!pw) { passwordStrength.textContent = ''; return; }
        if (pw.length < 4) { passwordStrength.textContent = 'Weak'; passwordStrength.style.color = '#dc2626'; }
        else if (pw.length < 8) { passwordStrength.textContent = 'Medium'; passwordStrength.style.color = '#d97706'; }
        else { passwordStrength.textContent = 'Strong'; passwordStrength.style.color = '#16a34a'; }
    });

    document.getElementById('registerForm').addEventListener('submit', function(e) {
        if (passwordInput.value !== confirmPasswordInput.value) {
            e.preventDefault();
            confirmPasswordInput.classList.add('is-invalid');
            alert('Passwords do not match.');
        }
    });
</script>
</body>
</html>
