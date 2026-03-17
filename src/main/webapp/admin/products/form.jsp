<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Product, models.Supplier, models.User, java.util.List" %>
        <%@ page import="util.I18nUtil" %>
            <% I18nUtil i18n=(I18nUtil) request.getAttribute("i18n"); if (i18n==null) i18n=new I18nUtil(request); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <% Product editProduct=(Product) request.getAttribute("product"); List<Supplier> suppliers = (List
                        <Supplier>) request.getAttribute("suppliers");
                            boolean isEdit = (editProduct != null);
                            %>
                            <title>
                                <%= isEdit ? i18n.get("admin.editProductTitle") : i18n.get("admin.addProductTitle") %> -
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
                                ${i18n.get('admin.backToProducts')}</a> |
                            <a
                                href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                            |
                            <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                    </nav>
                    <h1>
                        <%= isEdit ? i18n.get("admin.editProductTitle") : i18n.get("admin.addProductTitle") %>
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
                                            <label for="name">${i18n.get('table.name')} <span
                                                    class="req">*</span></label>
                                            <input type="text" id="name" name="name" required
                                                value="<%= isEdit ? editProduct.getName() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="price">${i18n.get('table.price')} (₫) <span
                                                    class="req">*</span></label>
                                            <input type="number" id="price" name="price" required min="0" step="1"
                                                value="<%= isEdit ? (long)editProduct.getPrice() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="stock">${i18n.get('table.stock')} <span
                                                    class="req">*</span></label>
                                            <input type="number" id="stock" name="stock" required min="0"
                                                value="<%= isEdit ? editProduct.getStock() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="category">${i18n.get('table.category')}</label>
                                            <input type="text" id="category" name="category"
                                                value="<%= isEdit && editProduct.getCategory() != null ? editProduct.getCategory() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="importDate">${i18n.get('table.importDate')}</label>
                                            <input type="date" id="importDate" name="importDate"
                                                value="<%= isEdit && editProduct.getImportDate() != null ? editProduct.getImportDate() : "" %>">
                                        </div>

                                        <div class="form-group">
                                            <label for="description">${i18n.get('product.description')}</label>
                                            <textarea id="description"
                                                name="description"><%= isEdit && editProduct.getDescription() != null ? editProduct.getDescription() : "" %></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label for="supplierId">${i18n.get('table.supplier')}</label>
                                            <select id="supplierId" name="supplierId">
                                                <option value="">
                                                    <%= i18n.get("form.none") %>
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
                                                <%= isEdit ? i18n.get("action.update") : i18n.get("action.save") %>
                                            </button>
                                            <a
                                                href="${pageContext.request.contextPath}/admin/products">${i18n.get('action.cancel')}</a>
                                        </div>
                            </form>
                </body>

                </html>
