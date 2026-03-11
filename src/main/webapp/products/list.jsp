<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List, models.Product, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('product.title')}</title>
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

                .msg {
                    color: green;
                    margin-bottom: 12px;
                }

                .product-grid {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 16px;
                }

                .product-card {
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    padding: 16px;
                    width: 220px;
                    box-sizing: border-box;
                }

                .product-card h3 {
                    margin: 0 0 8px;
                    font-size: 15px;
                }

                .product-card .price {
                    color: #2e7d32;
                    font-weight: bold;
                    margin-bottom: 6px;
                }

                .product-card .stock-out {
                    color: #c62828;
                    font-style: italic;
                }

                .product-card .desc {
                    font-size: 12px;
                    color: #555;
                    margin-bottom: 10px;
                }

                .add-form {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .add-form input[type="number"] {
                    width: 55px;
                    padding: 4px;
                    border: 1px solid #ccc;
                    border-radius: 3px;
                }

                .btn {
                    display: inline-block;
                    padding: 5px 12px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    cursor: pointer;
                    font-size: 13px;
                }

                .btn-add {
                    background: #4caf50;
                    color: white;
                    border-color: #4caf50;
                }

                .btn-cart {
                    background: #1565c0;
                    color: white;
                    border-color: #1565c0;
                }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user"); List<Product> products = (List<Product>)
                    request.getAttribute("products");
                    String cartMessage = (String) request.getAttribute("cartMessage");
                    %>

                    <h1>${i18n.get('product.title')}</h1>
                    <nav>
                        <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                            ${i18n.get('nav.welcome')}, <% if (currentUser !=null) {%><strong>
                                    <%= currentUser.getName() %>
                                </strong> |
                                <a href="${pageContext.request.contextPath}/users">${i18n.get('nav.myProfile')}</a> |
                                <a href="${pageContext.request.contextPath}/cart">${i18n.get('nav.viewCart')}</a> |
                                <a href="${pageContext.request.contextPath}/orders">${i18n.get('nav.myOrders')}</a> |
                                <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                                <% } else { %><strong>${i18n.get('nav.guest')}</strong> |
                                    <a href="${pageContext.request.contextPath}/login">${i18n.get('nav.login')}</a>
                                    <% } %>
                    </nav>

                    <% if (cartMessage !=null) { %>
                        <p class="msg">
                            <%= cartMessage %>
                        </p>
                        <% } %>

                            <div class="product-grid">
                                <% if (products==null || products.isEmpty()) { %>
                                    <p>${i18n.get('product.noProducts')}</p>
                                    <% } else { for (Product p : products) { %>
                                        <div class="product-card">
                                            <h3>
                                                <%= p.getName() %>
                                            </h3>
                                            <div class="price">
                                                <%= String.format("%,.0f", p.getPrice()) %> ₫
                                            </div>
                                            <% if (p.getDescription() !=null && !p.getDescription().isEmpty()) { %>
                                                <div class="desc">
                                                    <%= p.getDescription() %>
                                                </div>
                                                <% } %>
                                                    <% if (p.getStock() <=0) { %>
                                                        <span class="stock-out">${i18n.get('product.outOfStock')}</span>
                                                        <% } else { %>
                                                            <div style="font-size:12px; color:#555; margin-bottom:8px;">
                                                                ${i18n.get('product.stock')}: <%= p.getStock() %>
                                                            </div>
                                                            <form class="add-form"
                                                                action="${pageContext.request.contextPath}/cart"
                                                                method="post">
                                                                <input type="hidden" name="productId"
                                                                    value="<%= p.getId() %>">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="number" name="quantity" value="1" min="1"
                                                                    max="<%= p.getStock() %>">
                                                                <button type="submit"
                                                                    class="btn btn-add">${i18n.get('product.addToCart')}</button>
                                                            </form>
                                                            <% } %>
                                        </div>
                                        <% } } %>
                            </div>

        </body>

        </html>