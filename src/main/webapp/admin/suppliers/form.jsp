<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Supplier, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <% Supplier editSupplier=(Supplier) request.getAttribute("supplier"); boolean isEdit=(editSupplier !=null);
                %>
                <title>
                    <%= isEdit ? "Edit Supplier" : "Add New Supplier" %> -
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
                        Back to Supplier List</a> |
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    |
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </nav>
                <h1>
                    <%= isEdit ? "Edit Supplier" : "Add New Supplier" %>
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
                                        <label for="name">Name <span class="req">*</span></label>
                                        <input type="text" id="name" name="name" required
                                            value="<%= isEdit ? editSupplier.getName() : "" %>">
                                    </div>

                                    <div class="form-group">
                                        <label for="phone">Phone</label>
                                        <input type="tel" id="phone" name="phone"
                                            value="<%= isEdit && editSupplier.getPhone() != null ? editSupplier.getPhone() : "" %>">
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="email" id="email" name="email"
                                            value="<%= isEdit && editSupplier.getEmail() != null ? editSupplier.getEmail() : "" %>">
                                    </div>

                                    <div class="form-group">
                                        <label for="address">Address</label>
                                        <input type="text" id="address" name="address"
                                            value="<%= isEdit && editSupplier.getAddress() != null ? editSupplier.getAddress() : "" %>">
                                    </div>

                                    <% if (isEdit) { %>
                                        <div class="form-group">
                                            <label for="status">Status</label>
                                            <select id="status" name="status">
                                                <option value="true" <%=editSupplier.isStatus() ? "selected" : "" %>
                                                    >Active
                                                </option>
                                                <option value="false" <%=!editSupplier.isStatus() ? "selected" : "" %>
                                                    >Inactive
                                                </option>
                                            </select>
                                        </div>
                                        <% } %>

                                            <div class="actions">
                                                <button type="submit">
                                                    <%= isEdit ? "Update" : "Save" %>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/suppliers">Cancel</a>
                                            </div>
                        </form>
        </body>

        </html>