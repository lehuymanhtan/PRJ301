<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>${i18n.get('forgot.title')}</title>
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
            }

            label {
                display: block;
                margin-bottom: 4px;
                font-weight: bold;
            }

            input[type="email"] {
                width: 100%;
                padding: 7px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 3px;
            }

            button {
                width: 100%;
                padding: 9px;
                background: #e74c3c;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                font-size: 15px;
            }

            button:hover {
                background: #c0392b;
            }

            .msg-error {
                color: red;
                margin-bottom: 12px;
            }

            .msg-success {
                color: green;
                margin-bottom: 12px;
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
                    ${i18n.get('forgot.backToLogin')}</a>
            </div>
            <h1>🔑 ${i18n.get('forgot.title')}</h1>
            <p class="info">${i18n.get('forgot.info')}</p>

            <% if (request.getAttribute("error") !=null) { %>
                <p class="msg-error">
                    <%= request.getAttribute("error") %>
                </p>
                <% } %>
                    <% if (request.getAttribute("success") !=null) { %>
                        <p class="msg-success">
                            <%= request.getAttribute("success") %>
                        </p>
                        <% } %>

                            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                                <div class="form-group">
                                    <label for="email">${i18n.get('forgot.email')}</label>
                                    <input type="email" id="email" name="email" required autofocus>
                                </div>
                                <button type="submit">${i18n.get('forgot.submit')}</button>
                            </form>

                            <div class="links">
                                ${i18n.get('forgot.rememberPassword')} <a
                                    href="${pageContext.request.contextPath}/login">${i18n.get('forgot.loginLink')}</a>
                            </div>
        </div>
    </body>

    </html>

