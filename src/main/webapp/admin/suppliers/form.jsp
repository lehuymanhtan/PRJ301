<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Supplier, models.User" %>
        <%@ page import="util.I18nUtil" %>
            <% I18nUtil i18n=(I18nUtil) request.getAttribute("i18n"); if (i18n==null) i18n=new I18nUtil(request); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <% Supplier editSupplier=(Supplier) request.getAttribute("supplier"); boolean isEdit=(editSupplier
                        !=null); %>
                        <title>
                            <%= isEdit ? i18n.get("admin.editSupplierTitle") : i18n.get("admin.addSupplierTitle") %> -
                                Admin
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
                            input[type="email"],
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
                        </style>
                </head>

                <body>
                    <% User currentUser=(User) session.getAttribute("user"); %>
                        <nav>
                                <a href="${pageContext.request.contextPath}/admin/suppliers">&larr;
                                    ${i18n.get('admin.backToSuppliers')}</a> |
                                <a
                                    href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                                |
                                <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                        </nav>
                        <h1>
                            <%= isEdit ? i18n.get("admin.editSupplierTitle") : i18n.get("admin.addSupplierTitle") %>
                        </h1>

                        <% if (request.getAttribute("error") !=null) { %>
                            <p class="msg-error">
                                <%= request.getAttribute("error") %>
                            </p>
                            <% } %>

                                <form method="post" action="${pageContext.request.contextPath}/admin/suppliers">
                                    <input type="hidden" name="action" value="<%= isEdit ? " edit" : "create" %>">
                                    <% if (isEdit) { %>
                                        <input type="hidden" name="id" value="<%= editSupplier.getId() %>">
                                        <% } %>

                                            <div class="form-group">
                                                <label for="name">${i18n.get('table.name')} <span
                                                        class="req">*</span></label>
                                                <input type="text" id="name" name="name" required
                                                    value="<%= isEdit ? editSupplier.getName() : "" %>">
                                            </div>

                                            <div class="form-group">
                                                <label for="phone">${i18n.get('table.phone')}</label>
                                                <input type="tel" id="phone" name="phone"
                                                    value="<%= isEdit && editSupplier.getPhone() != null ? editSupplier.getPhone() : "" %>">
                                            </div>

                                            <div class="form-group">
                                                <label for="email">${i18n.get('table.email')}</label>
                                                <input type="email" id="email" name="email"
                                                    value="<%= isEdit && editSupplier.getEmail() != null ? editSupplier.getEmail() : "" %>">
                                            </div>

                                            <div class="form-group">
                                                <label for="address">${i18n.get('table.address')}</label>
                                                <input type="text" id="address" name="address"
                                                    value="<%= isEdit && editSupplier.getAddress() != null ? editSupplier.getAddress() : "" %>">
                                            </div>

                                            <% if (isEdit) { %>
                                                <div class="form-group">
                                                    <label for="status">${i18n.get('table.status')}</label>
                                                    <select id="status" name="status">
                                                        <option value="true" <%=editSupplier.isStatus() ? "selected"
                                                            : "" %>><%= i18n.get("supplier.active") %>
                                                        </option>
                                                        <option value="false" <%=!editSupplier.isStatus() ? "selected"
                                                            : "" %>><%= i18n.get("supplier.inactive") %>
                                                        </option>
                                                    </select>
                                                </div>
                                                <% } %>

                                                    <div class="actions">
                                                        <button type="submit">
                                                            <%= isEdit ? i18n.get("action.update") :
                                                                i18n.get("action.save") %>
                                                        </button>
                                                        <a
                                                            href="${pageContext.request.contextPath}/admin/suppliers">${i18n.get('action.cancel')}</a>
                                                    </div>
                                </form>
                </body>

                </html>
