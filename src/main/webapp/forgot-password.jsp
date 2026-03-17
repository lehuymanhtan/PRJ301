<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
        .container { max-width: 400px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; }
        h1 { text-align: center; color: #2c3e50; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="email"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background: #e74c3c; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #c0392b; }
        .error { background: #ffebee; color: #c62828; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .success { background: #e8f5e9; color: #2e7d32; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .info { color: #666; font-size: 13px; margin-bottom: 20px; }
        .links { text-align: center; margin-top: 15px; }
        .links a { color: #3498db; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h1>Forgot Password</h1>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null) { %>
        <div class="success"><%= success %></div>
    <% } %>

    <p class="info">Enter your email address and we'll send you a link to reset your password.</p>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <div class="form-group">
            <label for="email">Email Address:</label>
            <input type="email" id="email" name="email" required>
        </div>

        <button type="submit" class="btn">Send Reset Link</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
    </div>
</div>
</body>
</html>
