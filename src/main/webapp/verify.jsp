<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify Email</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center;
               align-items: flex-start; min-height: 100vh; margin: 0; background: #f0f0f0;
               padding: 50px 0; }
        .box { background: white; padding: 32px 40px; border-radius: 6px;
               border: 1px solid #ccc; width: 420px; }
        h1 { margin-bottom: 6px; font-size: 22px; }
        .subtitle { color: #666; font-size: 14px; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="email"] {
            width: 100%; padding: 8px; box-sizing: border-box;
            border: 1px solid #ccc; border-radius: 3px; font-size: 15px; }
        input[type="text"]#code {
            font-size: 26px; letter-spacing: 8px; text-align: center; }
        .btn-primary { width: 100%; padding: 10px; background: #2e7d32; color: white;
                       border: none; border-radius: 3px; cursor: pointer; font-size: 15px; }
        .btn-primary:hover { background: #1b5e20; }
        .btn-resend { width: 100%; padding: 8px; background: #555; color: white;
                      border: none; border-radius: 3px; cursor: pointer; font-size: 14px;
                      margin-top: 8px; }
        .btn-resend:hover { background: #333; }
        .msg-error { color: red; background: #fff0f0; border: 1px solid #ffcccc;
                     padding: 10px; border-radius: 4px; margin-bottom: 16px; }
        .msg-info  { color: #155724; background: #d4edda; border: 1px solid #c3e6cb;
                     padding: 10px; border-radius: 4px; margin-bottom: 16px; }
        .divider { border: none; border-top: 1px solid #eee; margin: 22px 0; }
        .links { margin-top: 16px; font-size: 13px; text-align: center; }
        .hint { font-size: 12px; color: #888; margin-top: 5px; }
    </style>
</head>
<body>
<div class="box">
    <h1>&#9993; Verify Your Email</h1>
    <p class="subtitle">
        Enter the 6-digit code sent to your email address,
        or click the verification link in the email.
    </p>

    <%-- Flash messages --%>
    <% if (request.getAttribute("error") != null) { %>
        <div class="msg-error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("info") != null) { %>
        <div class="msg-info"><%= request.getAttribute("info") %></div>
    <% } %>

    <%-- Verify by code form --%>
    <form method="post" action="${pageContext.request.contextPath}/verify">
        <input type="hidden" name="action" value="verify">

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="emailDisplay" name="email" required
                   value="${not empty param.email ? param.email : (not empty requestScope.email ? requestScope.email : '')}">
        </div>

        <div class="form-group">
            <label for="code">Verification Code</label>
            <input type="text" id="code" name="code" maxlength="6" placeholder="000000"
                   autocomplete="one-time-code" required>
            <p class="hint">Check your inbox (and spam folder). The code expires in 24&nbsp;hours.</p>
        </div>

        <button type="submit" class="btn-primary">Verify Email</button>
    </form>

    <hr class="divider">

    <%-- Resend form --%>
    <form method="post" action="${pageContext.request.contextPath}/verify">
        <input type="hidden" name="action" value="resend">
        <input type="hidden" name="email"
               value="${not empty requestScope.email ? requestScope.email : param.email}">
        <button type="submit" class="btn-resend">&#8635; Resend verification code</button>
    </form>

    <div class="links">
        Already verified? <a href="${pageContext.request.contextPath}/login">Login</a>
    </div>
</div>
</body>
</html>
