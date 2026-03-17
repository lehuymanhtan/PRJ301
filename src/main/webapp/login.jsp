<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center;
               align-items: center; min-height: 100vh; margin: 0; background: #f0f0f0; }
        .box { background: white; padding: 30px 40px; border-radius: 6px;
               border: 1px solid #ccc; width: 320px; }
        h1 { margin-bottom: 20px; font-size: 22px; }
        .form-group { margin-bottom: 14px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type="text"], input[type="password"] { width: 100%; padding: 7px;
               box-sizing: border-box; border: 1px solid #ccc; border-radius: 3px; }
        button { width: 100%; padding: 9px; background: #1565c0; color: white;
                 border: none; border-radius: 3px; cursor: pointer; font-size: 15px; }
        button:hover { background: #0d47a1; }
        .msg-error   { color: red;   margin-bottom: 12px; }
        .msg-success { color: green; margin-bottom: 12px; }
        .links { margin-top: 14px; font-size: 13px; text-align: center; }
        .back-link {font-size: 13px;}
    </style>
</head>
<body>
<div class="box">
    <a class="back-link" href="${pageContext.request.contextPath}/">Back to store</a>
    <h1>Login</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p class="msg-error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <p class="msg-success"><%= request.getAttribute("success") %></p>
    <% } %>
    <% String loginMsg = request.getParameter("msg");
       if ("account_deleted".equals(loginMsg)) { %>
        <p class="msg-success">Your account has been deleted.</p>
    <% } %>
    <% String successMessage = (String) session.getAttribute("successMessage");
       if (successMessage != null) { %>
        <p class="msg-success"><%= successMessage %></p>
        <% session.removeAttribute("successMessage"); %>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required autofocus>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit">Login</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
    </div>

    <div class="links">
        No account? <a href="${pageContext.request.contextPath}/register">Register</a>
    </div>
</div>
</body>
</html>
