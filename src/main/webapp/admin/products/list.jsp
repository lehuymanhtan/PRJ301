<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Product, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('admin.productManagement')}</title>
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
            <% User currentUser=(User) session.getAttribute("user"); List<Product> products = (List<Product>)
                    request.getAttribute("products");
                    String success = request.getParameter("success");
                    String errParam = request.getParameter("error");
                    %>

                    <h1>${i18n.get('admin.productManagement')}</h1>
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
                        <p class="msg-success">${i18n.get('admin.productCreated')}</p>
                        <% } %>
                            <% if ("updated".equals(success)) { %>
                                <p class="msg-success">${i18n.get('admin.productUpdated')}</p>
                                <% } %>
                                    <% if ("deleted".equals(success)) { %>
                                        <p class="msg-success">${i18n.get('admin.productDeleted')}</p>
                                        <% } %>
                                            <% if ("notfound".equals(errParam)) { %>
                                                <p class="msg-error">${i18n.get('admin.productNotFound')}</p>
                                                <% } %>
                                                    <% if (errParam !=null && !"notfound".equals(errParam)) { %>
                                                        <p class="msg-error">Error: <%= errParam %>
                                                        </p>
                                                        <% } %>

                                                            <div style="margin-bottom:15px;">
                                                                <a href="${pageContext.request.contextPath}/admin/products?action=create"
                                                                    class="btn btn-add">${i18n.get('admin.addProduct')}</a>
                                                            </div>

                                                            <table>
                                                                <thead>
                                                                    <tr>
                                                                        <th>${i18n.get('table.id')}</th>
                                                                        <th>${i18n.get('table.name')}</th>
                                                                        <th>${i18n.get('table.price')}</th>
                                                                        <th>${i18n.get('table.stock')}</th>
                                                                        <th>${i18n.get('table.category')}</th>
                                                                        <th>${i18n.get('table.importDate')}</th>
                                                                        <th>${i18n.get('table.supplier')}</th>
                                                                        <th>${i18n.get('table.actions')}</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% if (products==null || products.isEmpty()) { %>
                                                                        <tr>
                                                                            <td colspan="8">
                                                                                ${i18n.get('admin.noProductsFound')}
                                                                            </td>
                                                                        </tr>
                                                                        <% } else { for (Product p : products) { %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%= p.getId() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= String.format("%,.0f",
                                                                                        p.getPrice()) %> ₫
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getStock() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getCategory() !=null ?
                                                                                        p.getCategory() : "" %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getImportDate() !=null ?
                                                                                        p.getImportDate() : "" %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getSupplier() !=null ?
                                                                                        p.getSupplier().getName() : "-"
                                                                                        %>
                                                                                </td>
                                                                                <td>
                                                                                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= p.getId() %>"
                                                                                        class="btn btn-edit">${i18n.get('action.edit')}</a>
                                                                                    <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=<%= p.getId() %>"
                                                                                        class="btn btn-del"
                                                                                        onclick="return confirm('${i18n.get('msg.confirmDelete')}'">${i18n.get('action.delete')}</a>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } %>
                                                                </tbody>
                                                            </table>
        </body>

        </html>