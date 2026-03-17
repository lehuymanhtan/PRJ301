<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>My Profile</title>
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

                .profile-box {
                    border: 1px solid #ccc;
                    padding: 20px;
                    max-width: 400px;
                    border-radius: 4px;
                }

                .profile-box p {
                    margin: 8px 0;
                }

                .label {
                    font-weight: bold;
                    display: inline-block;
                    width: 100px;
                }

                .msg-success {
                    color: green;
                    margin-bottom: 10px;
                }

                .actions {
                    margin-top: 15px;
                }

                .actions a {
                    display: inline-block;
                    padding: 6px 14px;
                    margin-right: 8px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                }

                a.btn-edit {
                    background: #2196f3;
                    color: white;
                    border-color: #2196f3;
                }

                a.btn-del {
                    background: #f44336;
                    color: white;
                    border-color: #f44336;
                }
            </style>
        </head>

        <body>
            <% User profileUser=(User) request.getAttribute("profileUser"); String
                success=request.getParameter("success"); %>

                <h1>My Profile</h1>
                <nav>
                        <a href="${pageContext.request.contextPath}/users">My Profile</a> |
                        <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </nav>

                <% if ("updated".equals(success)) { %>
                    <p class="msg-success">Profile updated successfully.</p>
                    <% } %>

                        <div class="profile-box">
                            <p><span class="label">User ID:</span>
                                <%= profileUser.getUserId() %>
                            </p>
                            <p><span class="label">Username:</span>
                                <%= profileUser.getUsername() %>
                            </p>
                            <p><span class="label">Role:</span>
                                <%= profileUser.getRole() %>
                            </p>
                            <p><span class="label">Full Name:</span>
                                <%= profileUser.getName() %>
                            </p>
                            <p><span class="label">Gender:</span>
                                <%= profileUser.getGender() %>
                            </p>
                            <p><span class="label">Date of Birth:</span>
                                <%= profileUser.getDateOfBirth() %>
                            </p>
                            <p><span class="label">Phone:</span>
                                <%= profileUser.getPhone() !=null ? profileUser.getPhone() : "-" %>
                            </p>
                            <p><span class="label">Email:</span>
                                <%= profileUser.getEmail() %>
                            </p>
                        </div>

                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/users?action=edit"
                                class="btn-edit">Edit Profile</a>
                            <a href="${pageContext.request.contextPath}/users?action=delete" class="btn-del"
                                onclick="return confirm('Delete your account? This cannot be undone.')">Delete Account</a>
                        </div>
        </body>

        </html>

