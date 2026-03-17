<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Edit Profile</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h1 {
                    margin-bottom: 20px;
                }

                .form-group {
                    margin-bottom: 12px;
                }

                label {
                    display: block;
                    margin-bottom: 4px;
                    font-weight: bold;
                }

                input[type="text"],
                input[type="password"],
                input[type="date"],
                input[type="email"],
                select {
                    padding: 6px;
                    width: 280px;
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

                .note {
                    color: #666;
                    font-size: 13px;
                }
            </style>
        </head>

        <body>
            <% User profileUser=(User) request.getAttribute("profileUser"); %>

                <h1>Edit Profile</h1>

                    <% if (request.getAttribute("error") !=null) { %>
                        <p class="msg-error">
                            <%= request.getAttribute("error") %>
                        </p>
                        <% } %>

                            <form method="post" action="${pageContext.request.contextPath}/users">
                                <input type="hidden" name="action" value="edit">

                                <div class="form-group">
                                    <label for="username">Username *</label>
                                    <input type="text" id="username" name="username" required
                                        value="<%= profileUser != null ? profileUser.getUsername() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="password">Password *</label>
                                    <input type="password" id="password" name="password" required
                                        value="<%= profileUser != null ? profileUser.getPassword() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="name">Full Name *</label>
                                    <input type="text" id="name" name="name" required
                                        value="<%= profileUser != null && profileUser.getName() != null ? profileUser.getName() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="gender">Gender *</label>
                                    <select id="gender" name="gender" required>
                                        <option value="">-- Select --</option>
                                        <option value="male" <%=profileUser !=null && "male"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >Male</option>
                                        <option value="female" <%=profileUser !=null && "female"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >Female</option>
                                        <option value="other" <%=profileUser !=null && "other"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >Other</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth">Date of Birth *</label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" required
                                        value="<%= profileUser != null && profileUser.getDateOfBirth() != null ? profileUser.getDateOfBirth().toString() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone</label>
                                    <input type="text" id="phone" name="phone"
                                        value="<%= profileUser != null && profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="email">Email *</label>
                                    <input type="email" id="email" name="email" required
                                        value="<%= profileUser != null ? profileUser.getEmail() : "" %>">
                                </div>

                                <p class="note">Note: role cannot be changed here.</p>

                                <div class="actions">
                                    <button type="submit">Save Changes</button>
                                    <a href="${pageContext.request.contextPath}/users">Cancel</a>
                                </div>
                            </form>
        </body>

        </html>

