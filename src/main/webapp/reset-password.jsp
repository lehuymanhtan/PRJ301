<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>${i18n.get('reset.title')}</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                background: #f0f0f0;
            }

            .box {
                background: white;
                padding: 30px 40px;
                border-radius: 6px;
                border: 1px solid #ccc;
                width: 360px;
            }

            h1 {
                margin-bottom: 10px;
                font-size: 22px;
            }

            .info {
                font-size: 13px;
                color: #666;
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 14px;
                position: relative;
            }

            label {
                display: block;
                margin-bottom: 4px;
                font-weight: bold;
            }

            input[type="password"],
            input[type="text"] {
                width: 100%;
                padding: 7px 35px 7px 7px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 3px;
            }

            .password-toggle {
                position: absolute;
                right: 8px;
                top: 31px;
                cursor: pointer;
                background: none;
                border: none;
                font-size: 18px;
                padding: 0;
            }

            button[type="submit"] {
                width: 100%;
                padding: 9px;
                background: #2e7d32;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                font-size: 15px;
            }

            button[type="submit"]:hover {
                background: #1b5e20;
            }

            .msg-error {
                color: red;
                margin-bottom: 12px;
            }

            .msg-success {
                color: green;
                margin-bottom: 12px;
            }

            .strength-meter {
                height: 5px;
                border-radius: 3px;
                margin-top: 5px;
                background: #ddd;
            }

            .strength-bar {
                height: 100%;
                border-radius: 3px;
                transition: all 0.3s;
                width: 0%;
            }

            .strength-text {
                font-size: 11px;
                margin-top: 3px;
            }

            .weak {
                background: #e74c3c;
            }

            .medium {
                background: #f39c12;
            }

            .strong {
                background: #27ae60;
            }

            .links {
                margin-top: 14px;
                font-size: 13px;
                text-align: center;
            }

            .back-link {
                font-size: 13px;
            }

            .header-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }
</style>
    </head>

    <body>
        <div class="box">
            <div class="header-actions">
                <a class="back-link" href="${pageContext.request.contextPath}/login">←
                    ${i18n.get('reset.backToLogin')}</a>
            </div>
            <h1>🔒 ${i18n.get('reset.title')}</h1>

            <% if (request.getAttribute("error") !=null) { %>
                <p class="msg-error">
                    <%= request.getAttribute("error") %>
                </p>
                <% if (request.getAttribute("token")==null) { %>
                    <div class="links">
                        <a href="${pageContext.request.contextPath}/forgot-password">${i18n.get('reset.requestNew')}</a>
                    </div>
                    <% } %>
                        <% } else if (request.getAttribute("token") !=null) { %>
                            <p class="info">${i18n.get('reset.info')}</p>

                            <form method="post" action="${pageContext.request.contextPath}/reset-password">
                                <input type="hidden" name="token" value="<%= request.getAttribute(" token") %>">

                                <div class="form-group">
                                    <label for="newPassword">${i18n.get('reset.newPassword')}</label>
                                    <input type="password" id="newPassword" name="newPassword" required autofocus>
                                    <button type="button" class="password-toggle"
                                        onclick="togglePassword('newPassword', this)">👁️</button>
                                    <div class="strength-meter">
                                        <div id="strength-bar" class="strength-bar"></div>
                                    </div>
                                    <div id="strength-text" class="strength-text"></div>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword">${i18n.get('reset.confirmPassword')}</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                    <button type="button" class="password-toggle"
                                        onclick="togglePassword('confirmPassword', this)">👁️</button>
                                </div>

                                <button type="submit">${i18n.get('reset.submit')}</button>
                            </form>
                            <% } %>

        </div>

        <script>
            function togglePassword(inputId, button) {
                const input = document.getElementById(inputId);
                if (input.type === 'password') {
                    input.type = 'text';
                    button.textContent = '🙈';
                } else {
                    input.type = 'password';
                    button.textContent = '👁️';
                }
            }

            // Password strength meter
            document.getElementById('newPassword')?.addEventListener('input', function (e) {
                const password = e.target.value;
                const strengthBar = document.getElementById('strength-bar');
                const strengthText = document.getElementById('strength-text');

                let strength = 0;
                if (password.length >= 8) strength++;
                if (password.length >= 12) strength++;
                if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
                if (/\d/.test(password)) strength++;
                if (/[^a-zA-Z0-9]/.test(password)) strength++;

                strengthBar.className = 'strength-bar';
                if (strength === 0) {
                    strengthBar.style.width = '0%';
                    strengthText.textContent = '';
                } else if (strength <= 2) {
                    strengthBar.style.width = '33%';
                    strengthBar.classList.add('weak');
                    strengthText.textContent = '${i18n.get("reset.strength.weak")}';
                    strengthText.style.color = '#e74c3c';
                } else if (strength <= 3) {
                    strengthBar.style.width = '66%';
                    strengthBar.classList.add('medium');
                    strengthText.textContent = '${i18n.get("reset.strength.medium")}';
                    strengthText.style.color = '#f39c12';
                } else {
                    strengthBar.style.width = '100%';
                    strengthBar.classList.add('strong');
                    strengthText.textContent = '${i18n.get("reset.strength.strong")}';
                    strengthText.style.color = '#27ae60';
                }
            });
        </script>
    </body>

    </html>
