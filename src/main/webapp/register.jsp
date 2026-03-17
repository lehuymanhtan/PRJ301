<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center;
               align-items: flex-start; min-height: 100vh; margin: 0; background: #f0f0f0;
               padding: 30px 0; }
        .box { background: white; padding: 30px 40px; border-radius: 6px;
               border: 1px solid #ccc; width: 380px; }
        h1 { margin-bottom: 20px; font-size: 22px; }
        .form-group { margin-bottom: 14px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        label .req { color: red; margin-left: 2px; }
        input[type="text"], input[type="password"], input[type="email"],
        input[type="date"], input[type="tel"], select {
            width: 100%; padding: 7px; box-sizing: border-box;
            border: 1px solid #ccc; border-radius: 3px; }
        button { width: 100%; padding: 9px; background: #2e7d32; color: white;
                 border: none; border-radius: 3px; cursor: pointer; font-size: 15px; }
        button:hover { background: #1b5e20; }
        .msg-error { color: red; margin-bottom: 12px; }
        .links { margin-top: 14px; font-size: 13px; text-align: center; }
        .hint { font-size: 11px; color: #888; margin-top: 3px; }
    </style>
</head>
<body>
<div class="box">
    <h1>Register</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p class="msg-error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register">

        <div class="form-group">
            <label for="username">Username <span class="req">*</span></label>
            <input type="text" id="username" name="username" required autofocus
                   value="${param.username}">
        </div>

        <div class="form-group">
            <label for="password">Password <span class="req">*</span></label>
            <input type="password" id="password" name="password" required>
            <p class="hint">At least 3 characters.</p>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm Password <span class="req">*</span></label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>

        <div class="form-group">
            <label for="name">Full Name <span class="req">*</span></label>
            <input type="text" id="name" name="name" required value="${param.name}">
        </div>

        <div class="form-group">
            <label for="gender">Gender <span class="req">*</span></label>
            <select id="gender" name="gender" required>
                <option value="" disabled selected>-- Select --</option>
                <option value="male"   ${param.gender == 'male'   ? 'selected' : ''}>Male</option>
                <option value="female" ${param.gender == 'female' ? 'selected' : ''}>Female</option>
                <option value="other"  ${param.gender == 'other'  ? 'selected' : ''}>Other</option>
            </select>
        </div>

        <div class="form-group">
            <label for="dateOfBirth">Date of Birth <span class="req">*</span></label>
            <input type="date" id="dateOfBirth" name="dateOfBirth" required
                   value="${param.dateOfBirth}">
        </div>

        <div class="form-group">
            <label for="email">Email <span class="req">*</span></label>
            <input type="email" id="email" name="email" required
                   value="${param.email}">
        </div>

        <div class="form-group">
            <label for="phone">Phone No</label>
            <input type="tel" id="phone" name="phone" value="${param.phone}">
        </div>

        <button type="submit">Register</button>
    </form>

    <div class="links">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a>
    </div>
</div>
</body>
</html>
