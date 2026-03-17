<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
        .container { max-width: 400px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; }
        h1 { text-align: center; color: #2c3e50; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="password"], input[type="email"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background: #2e7d32; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #1b5e20; }
        .error { background: #ffebee; color: #c62828; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .info { color: #666; font-size: 13px; margin-bottom: 20px; }
        .links { text-align: center; margin-top: 15px; }
        .links a { color: #3498db; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
        .password-toggle { position: relative; }
        .toggle-btn { position: absolute; right: 10px; top: 32px; cursor: pointer; color: #666; }
    </style>
</head>
<body>
<div class="container">
    <h1>Reset Password</h1>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <% String token = (String) request.getAttribute("token"); %>
    <% String email = (String) request.getAttribute("email"); %>

    <% if (token != null && email != null) { %>
        <p class="info">Enter your new password for <strong><%= email %></strong></p>

        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <input type="hidden" name="token" value="<%= token %>">

            <div class="form-group password-toggle">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required minlength="3">
                <span class="toggle-btn" onclick="togglePassword('newPassword')">👁️</span>
            </div>

            <div class="form-group password-toggle">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required minlength="3">
                <span class="toggle-btn" onclick="togglePassword('confirmPassword')">👁️</span>
            </div>

            <button type="submit" class="btn">Reset Password</button>
        </form>
    <% } %>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
    </div>
</div>

<script>
function togglePassword(id) {
    var input = document.getElementById(id);
    if (input.type === "password") {
        input.type = "text";
    } else {
        input.type = "password";
    }
}
</script>
</body>
</html>
