<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <!-- Logo -->
        <div class="auth-logo">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Ruby Tech logo">
            <span>Ruby Tech</span>
        </div>

        <div class="text-center mb-3">
            <i class="bi bi-envelope-check" style="font-size:3rem; color:var(--rt-orange)"></i>
        </div>

        <h1 class="h4 text-center fw-bold mb-1">Verify Your Email</h1>
        <p class="text-center text-muted small mb-4">
            Enter the 6-digit code sent to your email, or click the verification link.
        </p>

        <!-- Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger auto-dismiss" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %>
            </div>
        <% } %>
        <% if (request.getAttribute("info") != null) { %>
            <div class="alert alert-info auto-dismiss" role="alert">
                <i class="bi bi-info-circle me-2"></i><%= request.getAttribute("info") %>
            </div>
        <% } %>

        <!-- Verification Form -->
        <form method="post" action="${pageContext.request.contextPath}/verify" id="verifyForm">
            <input type="hidden" name="action" value="verify">

            <div class="mb-3">
                <label for="emailDisplay" class="form-label fw-semibold">Email Address</label>
                <input type="email"
                       id="emailDisplay"
                       name="email"
                       class="form-control"
                       placeholder="Enter your email"
                       required
                       readonly
                       value="${not empty param.email ? param.email : (not empty requestScope.email ? requestScope.email : '')}">
            </div>

            <div class="mb-3">
                <label for="code" class="form-label fw-semibold">Verification Code</label>
                <input type="text"
                       id="code"
                       name="code"
                       class="form-control form-control-lg text-center fw-bold fs-4"
                       maxlength="6"
                       placeholder="000000"
                       autocomplete="one-time-code"
                       required
                       autofocus
                       style="letter-spacing:0.5rem;">
                <div class="form-text">Check your inbox and spam folder. Code expires in 24 hours.</div>
            </div>

            <div class="d-grid">
                <button type="submit" class="btn btn-rt-primary btn-lg">
                    <i class="bi bi-shield-check me-2"></i>Verify Email Address
                </button>
            </div>
        </form>

        <hr>

        <!-- Resend Form -->
        <form method="post" action="${pageContext.request.contextPath}/verify" id="resendForm">
            <input type="hidden" name="action" value="resend">
            <input type="hidden" name="email"
                   value="${not empty requestScope.email ? requestScope.email : param.email}">
            <div class="d-grid">
                <button type="submit" class="btn btn-outline-secondary" id="resendBtn">
                    <i class="bi bi-arrow-clockwise me-2"></i>Resend Verification Code
                </button>
            </div>
        </form>

        <p class="text-center small mt-3 mb-0">
            Already verified?
            <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-orange">Sign In</a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    const codeInput = document.getElementById('code');
    const verifyForm = document.getElementById('verifyForm');
    const resendBtn = document.getElementById('resendBtn');

    if (codeInput) {
        codeInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
            if (this.value.length === 6) {
                setTimeout(() => verifyForm.submit(), 400);
            }
        });
        codeInput.addEventListener('paste', function(e) {
            e.preventDefault();
            const paste = (e.clipboardData || window.clipboardData).getData('text');
            const numeric = paste.replace(/[^0-9]/g, '').slice(0, 6);
            this.value = numeric;
            if (numeric.length === 6) setTimeout(() => verifyForm.submit(), 400);
        });
    }

    document.getElementById('resendForm').addEventListener('submit', function() {
        resendBtn.disabled = true;
        let countdown = 30;
        const timer = setInterval(() => {
            resendBtn.textContent = 'Resend in ' + countdown + 's';
            countdown--;
            if (countdown < 0) {
                clearInterval(timer);
                resendBtn.innerHTML = '<i class="bi bi-arrow-clockwise me-2"></i>Resend Verification Code';
                resendBtn.disabled = false;
            }
        }, 1000);
    });
</script>
</body>
</html>
