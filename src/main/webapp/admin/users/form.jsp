<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.User" %>
        <%@ page import="util.I18nUtil" %>
            <% I18nUtil i18n=(I18nUtil) request.getAttribute("i18n"); if (i18n==null) i18n=new I18nUtil(request); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <% User editUser=(User) request.getAttribute("user"); boolean isEdit=(editUser !=null); %>
                        <title>
                            <%= isEdit ? i18n.get("admin.editUserTitle") : i18n.get("admin.addUserTitle") %> - Admin
                        </title>
                        <style>
                            body {
                                font-family: Arial, sans-serif;
                                margin: 20px;
                            }

                            h1 {
                                margin-bottom: 10px;
                            }

                            nav {
                                margin-bottom: 20px;
                            }

                            nav a {
                                margin-right: 10px;
                            }

                            .form-group {
                                margin-bottom: 12px;
                            }

                            label {
                                display: block;
                                margin-bottom: 4px;
                                font-weight: bold;
                            }

                            label .req {
                                color: red;
                                margin-left: 2px;
                            }

                            input[type="text"],
                            input[type="password"],
                            input[type="email"],
                            input[type="date"],
                            input[type="tel"],
                            select {
                                padding: 6px;
                                width: 300px;
                                border: 1px solid #ccc;
                                border-radius: 3px;
                                box-sizing: border-box;
                            }

                            .msg-error {
                                color: red;
                                margin-bottom: 10px;
                            }

                            .actions {
                                margin-top: 15px;
                            }

                            .actions a {
                                margin-left: 10px;
                                text-decoration: none;
                                color: #555;
                            }

                            .hint {
                                font-size: 11px;
                                color: #888;
                                margin-top: 3px;
                            }
                        </style>
                </head>

                <body>
                    <nav>
                            <a href="${pageContext.request.contextPath}/admin/users">&larr;
                                ${i18n.get('admin.backToUsers')}</a> |
                            <a
                                href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                            |
                            <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                    </nav>
                    <h1>
                        <%= isEdit ? i18n.get("admin.editUserTitle") : i18n.get("admin.addUserTitle") %>
                    </h1>

                    <% if (request.getAttribute("error") !=null) { %>
                        <p class="msg-error">
                            <%= request.getAttribute("error") %>
                        </p>
                        <% } %>

                            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                                <input type="hidden" name="action" value="<%= isEdit ? " edit" : "create" %>">
                                <% if (isEdit) { %>
                                    <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                                    <% } %>

                                        <div class="form-group">
                                            <label for="username">${i18n.get('profile.username')} <span
                                                    class="req">*</span></label>
                                            <input type="text" id="username" name="username" required
                                                value="<%= isEdit ? editUser.getUsername() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="password">${i18n.get('profile.password')} <span
                                                    class="req">*</span></label>
                                            <input type="password" id="password" name="password" required
                                                value="<%= isEdit ? editUser.getPassword() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="role">${i18n.get('profile.role')} <span
                                                    class="req">*</span></label>
                                            <select id="role" name="role" required>
                                                <option value="user" <%=isEdit && "user" .equals(editUser.getRole())
                                                    ? "selected" : "" %>>User</option>
                                                <option value="admin" <%=isEdit && "admin" .equals(editUser.getRole())
                                                    ? "selected" : "" %>>Admin</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="name">${i18n.get('profile.fullName')} <span
                                                    class="req">*</span></label>
                                            <input type="text" id="name" name="name" required
                                                value="<%= isEdit ? editUser.getName() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="gender">${i18n.get('profile.gender')} <span
                                                    class="req">*</span></label>
                                            <select id="gender" name="gender" required>
                                                <option value="" disabled <%=!isEdit ? "selected" : "" %>><%=
                                                        i18n.get("form.select") %>
                                                </option>
                                                <option value="male" <%=isEdit && "male" .equals(editUser.getGender())
                                                    ? "selected" : "" %>><%= i18n.get("profile.male") %>
                                                </option>
                                                <option value="female" <%=isEdit && "female"
                                                    .equals(editUser.getGender()) ? "selected" : "" %>><%=
                                                        i18n.get("profile.female") %>
                                                </option>
                                                <option value="other" <%=isEdit && "other" .equals(editUser.getGender())
                                                    ? "selected" : "" %>><%= i18n.get("profile.other") %>
                                                </option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="dateOfBirth">${i18n.get('profile.dob')} <span
                                                    class="req">*</span></label>
                                            <input type="date" id="dateOfBirth" name="dateOfBirth" required
                                                value="<%= isEdit && editUser.getDateOfBirth() != null ? editUser.getDateOfBirth().toString() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="email">${i18n.get('profile.email')} <span
                                                    class="req">*</span></label>
                                            <input type="email" id="email" name="email" required
                                                value="<%= isEdit ? editUser.getEmail() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="phone">${i18n.get('profile.phone')}</label>
                                            <input type="tel" id="phone" name="phone"
                                                value="<%= isEdit && editUser.getPhone() != null ? editUser.getPhone() : "" %>">
                                        </div>

                                        <div class="actions">
                                            <button type="submit">${i18n.get('action.save')}</button>
                                            <a
                                                href="${pageContext.request.contextPath}/admin/users">${i18n.get('action.cancel')}</a>
                                        </div>
                            </form>
                </body>

                </html>
