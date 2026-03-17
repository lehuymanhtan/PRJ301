<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Supplier, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('admin.supplierManagement')}</title>
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
            <% User currentUser=(User) session.getAttribute("user"); List<Supplier> suppliers = (List<Supplier>)
                    request.getAttribute("suppliers");
                    String success = request.getParameter("success");
                    String errParam = request.getParameter("error");
                    %>

                    <h1>${i18n.get('admin.supplierManagement')}</h1>
                    <nav>
                        <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                            ${i18n.get('nav.welcome')}, <strong>
                                <%= currentUser !=null ? currentUser.getUsername() : "" %>
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
                        <p class="msg-success">${i18n.get('admin.supplierCreated')}</p>
                        <% } %>
                            <% if ("updated".equals(success)) { %>
                                <p class="msg-success">${i18n.get('admin.supplierUpdated')}</p>
                                <% } %>
                                    <% if ("deleted".equals(success)) { %>
                                        <p class="msg-success">${i18n.get('admin.supplierDeleted')}</p>
                                        <% } %>
                                            <% if ("notfound".equals(errParam)) { %>
                                                <p class="msg-error">${i18n.get('admin.supplierNotFound')}</p>
                                                <% } %>
                                                    <% if (errParam !=null && !"notfound".equals(errParam)) { %>
                                                        <p class="msg-error">Error: <%= errParam %>
                                                        </p>
                                                        <% } %>

                                                            <div style="margin-bottom:15px;">
                                                                <a href="${pageContext.request.contextPath}/admin/suppliers?action=create"
                                                                    class="btn btn-add">${i18n.get('admin.addSupplier')}</a>
                                                            </div>

                                                            <table>
                                                                <thead>
                                                                    <tr>
                                                                        <th>${i18n.get('table.id')}</th>
                                                                        <th>${i18n.get('table.name')}</th>
                                                                        <th>${i18n.get('table.phone')}</th>
                                                                        <th>${i18n.get('table.email')}</th>
                                                                        <th>${i18n.get('table.address')}</th>
                                                                        <th>${i18n.get('table.status')}</th>
                                                                        <th>${i18n.get('table.actions')}</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% if (suppliers==null || suppliers.isEmpty()) { %>
                                                                        <tr>
                                                                            <td colspan="7">
                                                                                ${i18n.get('admin.noSuppliersFound')}
                                                                            </td>
                                                                        </tr>
                                                                        <% } else { for (Supplier s : suppliers) { %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%= s.getId() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.getName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.getPhone() !=null ?
                                                                                        s.getPhone() : "" %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.getEmail() !=null ?
                                                                                        s.getEmail() : "" %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.getAddress() !=null ?
                                                                                        s.getAddress() : "" %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= s.isStatus() ? "Active"
                                                                                        : "Inactive" %>
                                                                                </td>
                                                                                <td>
                                                                                    <a href="${pageContext.request.contextPath}/admin/suppliers?action=edit&id=<%= s.getId() %>"
                                                                                        class="btn btn-edit">${i18n.get('action.edit')}</a>
                                                                                    <a href="${pageContext.request.contextPath}/admin/suppliers?action=delete&id=<%= s.getId() %>"
                                                                                        class="btn btn-del"
                                                                                        onclick="return confirm('${i18n.get('msg.confirmDelete')}'">${i18n.get('action.delete')}</a>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } %>
                                                                </tbody>
                                                            </table>
        </body>

        </html>