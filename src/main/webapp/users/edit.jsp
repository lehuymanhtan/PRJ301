<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('profile.edit')}</title>
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

                <h1>${i18n.get('profile.edit')}</h1>
                <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>

                    <% if (request.getAttribute("error") !=null) { %>
                        <p class="msg-error">
                            <%= request.getAttribute("error") %>
                        </p>
                        <% } %>

                            <form method="post" action="${pageContext.request.contextPath}/users">
                                <input type="hidden" name="action" value="edit">

                                <div class="form-group">
                                    <label for="username">${i18n.get('profile.username')} *</label>
                                    <input type="text" id="username" name="username" required
                                        value="<%= profileUser != null ? profileUser.getUsername() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="password">${i18n.get('profile.password')} *</label>
                                    <input type="password" id="password" name="password" required
                                        value="<%= profileUser != null ? profileUser.getPassword() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="name">${i18n.get('profile.fullName')} *</label>
                                    <input type="text" id="name" name="name" required
                                        value="<%= profileUser != null && profileUser.getName() != null ? profileUser.getName() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="gender">${i18n.get('profile.gender')} *</label>
                                    <select id="gender" name="gender" required>
                                        <option value="">${i18n.get('profile.selectGender')}</option>
                                        <option value="male" <%=profileUser !=null && "male"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >${i18n.get('profile.male')}</option>
                                        <option value="female" <%=profileUser !=null && "female"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >${i18n.get('profile.female')}</option>
                                        <option value="other" <%=profileUser !=null && "other"
                                            .equals(profileUser.getGender()) ? "selected" : "" %>
                                            >${i18n.get('profile.other')}</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="dateOfBirth">${i18n.get('profile.dob')} *</label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" required
                                        value="<%= profileUser != null && profileUser.getDateOfBirth() != null ? profileUser.getDateOfBirth().toString() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="phone">${i18n.get('profile.phone')}</label>
                                    <input type="text" id="phone" name="phone"
                                        value="<%= profileUser != null && profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="email">${i18n.get('profile.email')} *</label>
                                    <input type="email" id="email" name="email" required
                                        value="<%= profileUser != null ? profileUser.getEmail() : "" %>">
                                </div>

                                <p class="note">${i18n.get('profile.noteRole')}</p>

                                <div class="actions">
                                    <button type="submit">${i18n.get('profile.save')}</button>
                                    <a href="${pageContext.request.contextPath}/users">${i18n.get('profile.cancel')}</a>
                                </div>
                            </form>
        </body>

        </html>