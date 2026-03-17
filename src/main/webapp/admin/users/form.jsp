<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <% User editUser=(User) request.getAttribute("user"); boolean isEdit=(editUser !=null); %>
                <title>
                    <%= isEdit ? "Edit User" : "Add New User" %> - Admin
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
                    Back to User List</a> |
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                |
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
            <h1>
                <%= isEdit ? "Edit User" : "Add New User" %>
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
                                    <label for="username">Username <span class="req">*</span></label>
                                    <input type="text" id="username" name="username" required
                                        value="<%= isEdit ? editUser.getUsername() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="password">Password <span class="req">*</span></label>
                                    <input type="password" id="password" name="password" required
                                        value="<%= isEdit ? editUser.getPassword() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="role">Role <span class="req">*</span></label>
                                    <select id="role" name="role" required>
                                        <option value="user" <%=isEdit && "user" .equals(editUser.getRole())
                                            ? "selected" : "" %>>User</option>
                                        <option value="admin" <%=isEdit && "admin" .equals(editUser.getRole())
                                            ? "selected" : "" %>>Admin</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="name">Full Name <span class="req">*</span></label>
                                    <input type="text" id="name" name="name" required
                                        value="<%= isEdit ? editUser.getName() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="gender">Gender <span class="req">*</span></label>
                                    <select id="gender" name="gender" required>
                                        <option value="" disabled <%=!isEdit ? "selected" : "" %>>-- Select --
                                        </option>
                                        <option value="male" <%=isEdit && "male" .equals(editUser.getGender())
                                            ? "selected" : "" %>>Male
                                        </option>
                                        <option value="female" <%=isEdit && "female" .equals(editUser.getGender())
                                            ? "selected" : "" %>>Female
                                        </option>
                                        <option value="other" <%=isEdit && "other" .equals(editUser.getGender())
                                            ? "selected" : "" %>>Other
                                        </option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth">Date of Birth <span class="req">*</span></label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" required
                                        value="<%= isEdit && editUser.getDateOfBirth() != null ? editUser.getDateOfBirth().toString() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="email">Email <span class="req">*</span></label>
                                    <input type="email" id="email" name="email" required
                                        value="<%= isEdit ? editUser.getEmail() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone</label>
                                    <input type="tel" id="phone" name="phone"
                                        value="<%= isEdit && editUser.getPhone() != null ? editUser.getPhone() : "" %>">
                                </div>

                                <div class="actions">
                                    <button type="submit">Save</button>
                                    <a href="${pageContext.request.contextPath}/admin/users">Cancel</a>
                                </div>
                    </form>
        </body>

        </html>