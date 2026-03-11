<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Cart, models.CartItem, models.User, models.UserAddress, java.util.List" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${i18n.get('checkout.title')}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h1 {
                    margin-bottom: 6px;
                }

                nav {
                    margin-bottom: 20px;
                }

                nav a {
                    margin-right: 10px;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    max-width: 700px;
                    margin-bottom: 20px;
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

                .total-row td {
                    font-weight: bold;
                }

                .summary {
                    max-width: 400px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    padding: 16px;
                }

                .summary p {
                    margin: 6px 0;
                }

                .payment-option {
                    margin-bottom: 10px;
                }

                .payment-option label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    cursor: pointer;
                    font-size: 14px;
                }

                .vnpay-badge {
                    background: #005baa;
                    color: #fff;
                    font-weight: bold;
                    font-size: 12px;
                    padding: 2px 7px;
                    border-radius: 3px;
                    letter-spacing: .5px;
                }

                .btn {
                    display: inline-block;
                    padding: 8px 16px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    cursor: pointer;
                    font-size: 14px;
                }

                .btn-confirm {
                    background: #2e7d32;
                    color: white;
                    border-color: #2e7d32;
                }

                .btn-back {
                    background: #555;
                    color: white;
                    border-color: #555;
                }

                .address-section {
                    max-width: 700px;
                    margin-bottom: 20px;
                    background: #f9f9f9;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    padding: 14px 16px;
                }

                .address-section h3 { margin-top: 0; margin-bottom: 10px; font-size: 15px; }

                .addr-option {
                    display: flex;
                    align-items: flex-start;
                    gap: 10px;
                    padding: 8px 10px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    margin-bottom: 8px;
                    cursor: pointer;
                    background: white;
                }

                .addr-option:hover { border-color: #2196f3; background: #e3f2fd; }

                .addr-option.selected { border-color: #2196f3; background: #e3f2fd; }

                .addr-option input[type=radio] { margin-top: 3px; }

                .addr-text { flex: 1; }

                .addr-name { font-weight: bold; font-size: 14px; }

                .addr-detail { font-size: 13px; color: #555; }

                .badge-default { display: inline-block; font-size: 11px; font-weight: bold; background: #2196f3; color: white; padding: 1px 6px; border-radius: 8px; margin-left: 6px; }

                .link-add-address { font-size: 13px; color: #2196f3; text-decoration: none; }

                .link-add-address:hover { text-decoration: underline; }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user");
               Cart cart=(Cart) request.getAttribute("cart");
               double grandTotal=(cart !=null) ? cart.getTotalCost() : 0;
               @SuppressWarnings("unchecked")
               List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
               String lang = (String) request.getAttribute("lang");
               if (lang == null) lang = "vi";
               // Find default address id for pre-selection
               int defaultAddressId = -1;
               if (addresses != null) {
                   for (UserAddress a : addresses) {
                       if (a.isDefault()) { defaultAddressId = a.getId(); break; }
                   }
                   if (defaultAddressId == -1 && !addresses.isEmpty()) {
                       defaultAddressId = addresses.get(0).getId();
                   }
               }
            %>

                <h1>${i18n.get('checkout.title')}</h1>
                <nav>
                    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                        ${i18n.get('nav.welcome')}, <strong>
                            <%= currentUser !=null ? currentUser.getUsername() : "" %>
                        </strong> |
                        <a href="${pageContext.request.contextPath}/cart">${i18n.get('checkout.backToCart')}</a> |
                        <a href="${pageContext.request.contextPath}/products">${i18n.get('product.title')}</a> |
                        <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                </nav>

                <h2>${i18n.get('checkout.summary')}</h2>
                <table>
                    <thead>
                        <tr>
                            <th>${i18n.get('checkout.product')}</th>
                            <th>${i18n.get('cart.price')}</th>
                            <th>${i18n.get('checkout.qty')}</th>
                            <th>${i18n.get('cart.subtotal')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (cart !=null) { for (CartItem item : cart) { %>
                            <tr>
                                <td>
                                    <%= item.getProduct().getName() %>
                                </td>
                                <td>
                                    <%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫
                                </td>
                                <td>
                                    <%= item.getQuantity() %>
                                </td>
                                <td>
                                    <%= String.format("%,.0f", item.getSubtotal()) %> ₫
                                </td>
                            </tr>
                            <% } } %>
                                <tr class="total-row">
                                    <td colspan="3" style="text-align:right;">${i18n.get('cart.total')}:</td>
                                    <td>
                                        <%= String.format("%,.0f", grandTotal) %> ₫
                                    </td>
                                </tr>
                    </tbody>
                </table>

                <div class="summary">
                    <form action="${pageContext.request.contextPath}/checkout" method="post">

                        <%-- Address Selection Section --%>
                        <div class="address-section">
                            <h3>${i18n.get('checkout.selectAddress')}</h3>
                            <% if (addresses != null && !addresses.isEmpty()) {
                                for (UserAddress addr : addresses) {
                                    boolean isSelected = addr.getId() == defaultAddressId;
                                    String provinceName = addr.getProvince() != null ? addr.getProvince().getLocalizedName(lang) : "";
                            %>
                            <label class="addr-option <%= isSelected ? "selected" : "" %>" onclick="selectAddress(this)">
                                <input type="radio" name="addressId" value="<%= addr.getId() %>"
                                       <%= isSelected ? "checked" : "" %>
                                       onchange="selectAddress(this.closest('.addr-option'))">
                                <div class="addr-text">
                                    <div class="addr-name">
                                        <%= addr.getFullName() %> — <%= addr.getPhone() %>
                                        <% if (addr.isDefault()) { %>
                                        <span class="badge-default">${i18n.get('address.default')}</span>
                                        <% } %>
                                    </div>
                                    <div class="addr-detail">
                                        <%= addr.getAddressDetail() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= provinceName %>
                                    </div>
                                </div>
                            </label>
                            <% } } %>
                            <br>
                            <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="link-add-address">+ ${i18n.get('address.addNew')}</a>
                        </div>

                        <h3 style="margin-top:0;">${i18n.get('checkout.paymentMethod')}</h3>
                        <div class="payment-option">
                            <label>
                                <input type="radio" name="paymentMethod" value="COD" checked>
                                Cash on Delivery (COD)
                            </label>
                        </div>
                        <div class="payment-option">
                            <label>
                                <input type="radio" name="paymentMethod" value="VNPAY">
                                <span class="vnpay-badge">VNPAY</span>
                                ${i18n.get('checkout.paymentOnline')}
                            </label>
                        </div>
                        <hr>
                        <p><strong>${i18n.get('checkout.shipping')}:</strong> ${i18n.get('checkout.free')}</p>
                        <p><strong>Total: <%= String.format("%,.0f", grandTotal) %> ₫</strong></p>
                        <br>
                        <button type="submit" class="btn btn-confirm">${i18n.get('checkout.placeOrder')}</button>
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-back"
                            style="margin-left:8px;">${i18n.get('checkout.backToCart')}</a>
                    </form>
                </div>

        </body>

        <script>
            function selectAddress(card) {
                document.querySelectorAll('.addr-option').forEach(function(el) {
                    el.classList.remove('selected');
                });
                card.classList.add('selected');
            }
        </script>

        </html>