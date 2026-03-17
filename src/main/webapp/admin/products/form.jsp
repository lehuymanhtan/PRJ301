<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Product, models.Supplier, models.User, java.util.List" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <% Product editProduct=(Product) request.getAttribute("product"); List<Supplier> suppliers = (List
                <Supplier>) request.getAttribute("suppliers");
                    boolean isEdit = (editProduct != null);
                    %>
                    <title>
                        <%= isEdit ? "Edit Product" : "Add New Product" %> -
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
                        input[type="number"],
                        input[type="date"],
                        select,
                        textarea {
                            padding: 6px;
                            width: 300px;
                            border: 1px solid #ccc;
                            border-radius: 3px;
                            box-sizing: border-box;
                        }

                        textarea {
                            height: 80px;
                            resize: vertical;
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
            <nav>
                <a href="${pageContext.request.contextPath}/admin/products">&larr;
                    Back to Product List</a> |
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                |
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </nav>
            <h1>
                <%= isEdit ? "Edit Product" : "Add New Product" %>
            </h1>

            <% if (request.getAttribute("error") !=null) { %>
                <p class="msg-error">
                    <%= request.getAttribute("error") %>
                </p>
                <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/admin/products">
                        <input type="hidden" name="action" value="<%= isEdit ? " edit" : "create" %>">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editProduct.getId() %>">
                            <% } %>

                                <div class="form-group">
                                    <label for="name">Name <span class="req">*</span></label>
                                    <input type="text" id="name" name="name" required
                                        value="<%= isEdit ? editProduct.getName() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="price">Price (&#8363;) <span class="req">*</span></label>
                                    <input type="number" id="price" name="price" required min="0" step="1"
                                        value="<%= isEdit ? (long)editProduct.getPrice() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="stock">Stock <span class="req">*</span></label>
                                    <input type="number" id="stock" name="stock" required min="0"
                                        value="<%= isEdit ? editProduct.getStock() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="category">Category</label>
                                    <input type="text" id="category" name="category"
                                        value="<%= isEdit && editProduct.getCategory() != null ? editProduct.getCategory() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="importDate">Import Date</label>
                                    <input type="date" id="importDate" name="importDate"
                                        value="<%= isEdit && editProduct.getImportDate() != null ? editProduct.getImportDate() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label for="description">Description</label>
                                    <textarea id="description"
                                        name="description"><%= isEdit && editProduct.getDescription() != null ? editProduct.getDescription() : "" %></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="supplierId">Supplier</label>
                                    <select id="supplierId" name="supplierId">
                                        <option value="">
                                            -- None --
                                        </option>
                                        <% if (suppliers !=null) { for (Supplier s : suppliers) { boolean
                                            selected=isEdit && editProduct.getSupplier() !=null &&
                                            editProduct.getSupplier().getId().equals(s.getId()); %>
                                            <option value="<%= s.getId() %>" <%=selected ? "selected" : "" %>>
                                                <%= s.getName() %>
                                            </option>
                                            <% } } %>
                                    </select>
                                </div>

                                <div class="actions">
                                    <button type="submit">
                                        <%= isEdit ? "Update" : "Save" %>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/products">Cancel</a>
                                </div>
                    </form>
        </body>

        </html>