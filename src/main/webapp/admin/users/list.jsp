<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('admin.userManagement')}</title>
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

                .msg-success {
                    color: green;
                    margin-bottom: 10px;
                }

                .msg-error {
                    color: red;
                    margin-bottom: 10px;
                }

                .search-form {
                    margin-bottom: 15px;
                }

                .search-form input[type="text"] {
                    padding: 5px;
                    width: 250px;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                }

                th,
                td {
                    border: 1px solid #ccc;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background: #f0f0f0;
                }

                a.btn {
                    display: inline-block;
                    padding: 4px 10px;
                    margin-right: 5px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                }

                a.btn-add {
                    background: #4caf50;
                    color: white;
                    border-color: #4caf50;
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
            <% User currentUser=(User) session.getAttribute("user"); List<User> users = (List<User>)
                    request.getAttribute("users");
                    String kw = (String) request.getAttribute("searchKeyword");
                    String success = request.getParameter("success");
                    String errParam = request.getParameter("error");
                    %>

                    <h1>${i18n.get('admin.userManagement')}</h1>
                    <nav>
                        <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                            ${i18n.get('nav.welcome')}, <strong>
                                <%= currentUser.getUsername() %>
                            </strong> |
                            <a
                                href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                            |
                            <a
                                href="${pageContext.request.contextPath}/admin/users">${i18n.get('admin.userManagement')}</a>
                            |
                            <a
                                href="${pageContext.request.contextPath}/admin/products">${i18n.get('admin.productManagement')}</a>
                            |
                            <a
                                href="${pageContext.request.contextPath}/admin/suppliers">${i18n.get('admin.supplierManagement')}</a>
                            |
                            <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                    </nav>

                    <% if ("created".equals(success)) { %>
                        <p class="msg-success">${i18n.get('admin.userCreated')}</p>
                        <% } %>
                            <% if ("updated".equals(success)) { %>
                                <p class="msg-success">${i18n.get('admin.userUpdated')}</p>
                                <% } %>
                                    <% if ("deleted".equals(success)) { %>
                                        <p class="msg-success">${i18n.get('admin.userDeleted')}</p>
                                        <% } %>
                                            <% if ("notfound".equals(errParam)) { %>
                                                <p class="msg-error">${i18n.get('admin.userNotFound')}</p>
                                                <% } %>
                                                    <% if (errParam !=null && !"notfound".equals(errParam)) { %>
                                                        <p class="msg-error">Error: <%= errParam %>
                                                        </p>
                                                        <% } %>

                                                            <div>
                                                                <a href="${pageContext.request.contextPath}/admin/users?action=create"
                                                                    class="btn btn-add">${i18n.get('admin.addUser')}</a>
                                                            </div>

                                                            <form class="search-form" method="get"
                                                                action="${pageContext.request.contextPath}/admin/users">
                                                                <input type="text" name="q"
                                                                    placeholder="${i18n.get('admin.searchByUsername')}"
                                                                    value="<%= kw != null ? kw : "" %>">
                                                                <button
                                                                    type="submit">${i18n.get('action.search')}</button>
                                                                <% if (kw !=null && !kw.isEmpty()) { %>
                                                                    <a
                                                                        href="${pageContext.request.contextPath}/admin/users">${i18n.get('action.clear')}</a>
                                                                    <% } %>
                                                            </form>

                                                            <table>
                                                                <thead>
                                                                    <tr>
                                                                        <th>${i18n.get('table.id')}</th>
                                                                        <th>${i18n.get('table.username')}</th>
                                                                        <th>${i18n.get('table.password')}</th>
                                                                        <th>${i18n.get('table.role')}</th>
                                                                        <th>${i18n.get('table.actions')}</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% if (users==null || users.isEmpty()) { %>
                                                                        <tr>
                                                                            <td colspan="5">
                                                                                ${i18n.get('admin.noUsersFound')}</td>
                                                                        </tr>
                                                                        <% } else { for (User u : users) { %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%= u.getUserId() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= u.getUsername() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= u.getPassword() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= u.getRole() %>
                                                                                </td>
                                                                                <td>
                                                                                    <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= u.getUserId() %>"
                                                                                        class="btn btn-edit">${i18n.get('action.edit')}</a>
                                                                                    <% if
                                                                                        (!u.getUserId().equals(currentUser.getUserId()))
                                                                                        { %>
                                                                                        <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=<%= u.getUserId() %>"
                                                                                            class="btn btn-del"
                                                                                            onclick="return confirm('${i18n.get('msg.confirmDelete')}'">${i18n.get('action.delete')}</a>
                                                                                        <% } %>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } %>
                                                                </tbody>
                                                            </table>
        </body>

        </html>