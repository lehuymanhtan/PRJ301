<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Order" %>
        <%@ page import="util.I18nUtil" %>
            <% I18nUtil i18n=(I18nUtil) request.getAttribute("i18n"); if (i18n==null) i18n=new I18nUtil(request); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>${i18n.get('admin.editOrderStatus')} - Admin</title>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            margin: 20px;
                            background: #f5f5f5;
                        }

                        h1 {
                            margin-bottom: 6px;
                        }

                        nav {
                            margin-bottom: 20px;
                        }

                        nav a {
                            margin-right: 12px;
                            text-decoration: none;
                            color: #333;
                        }

                        nav a:hover {
                            text-decoration: underline;
                        }

                        .form-box {
                            background: white;
                            border: 1px solid #ddd;
                            border-radius: 4px;
                            padding: 24px;
                            max-width: 420px;
                        }

                        label {
                            display: block;
                            margin-bottom: 4px;
                            font-weight: bold;
                            font-size: 13px;
                        }

                        input[type="text"],
                        select {
                            width: 100%;
                            padding: 7px 10px;
                            border: 1px solid #ccc;
                            border-radius: 3px;
                            margin-bottom: 14px;
                            font-size: 14px;
                            box-sizing: border-box;
                        }

                        .btn {
                            display: inline-block;
                            padding: 8px 18px;
                            text-decoration: none;
                            border: 1px solid #999;
                            border-radius: 3px;
                            font-size: 14px;
                            cursor: pointer;
                        }

                        .btn-save {
                            background: #2e7d32;
                            color: white;
                            border-color: #2e7d32;
                        }

                        .btn-cancel {
                            background: #555;
                            color: white;
                            border-color: #555;
                        }
                    </style>
                </head>

                <body>
                    <% Order order=(Order) request.getAttribute("order"); %>

                        <h1>${i18n.get('admin.editOrderStatus')}</h1>
                        <nav>
                            <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                                <a href="${pageContext.request.contextPath}/admin/orders">&#8592;
                                    ${i18n.get('admin.backToOrders')}</a> |
                                <a
                                    href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                                |
                                <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                        </nav>

                        <div class="form-box">
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%= order.getId() %>">

                                <label>${i18n.get('order.orderId')}</label>
                                <input type="text" value="#<%= order.getId() %>" disabled>

                                <label>${i18n.get('order.userId')}</label>
                                <input type="text" value="<%= order.getUserId() %>" disabled>

                                <label>${i18n.get('order.total')}</label>
                                <input type="text" value="$<%= order.getTotalPrice() %>" disabled>

                                <label for="status">${i18n.get('order.status')}</label>
                                <select id="status" name="status">
                                    <option value="Pending" <%="Pending" .equals(order.getStatus()) ? "selected" : "" %>
                                        ><%= i18n.get("order.pending") %>
                                    </option>
                                    <option value="Processing" <%="Processing" .equals(order.getStatus()) ? "selected"
                                        : "" %>><%= i18n.get("order.processing") %>
                                    </option>
                                    <option value="Shipped" <%="Shipped" .equals(order.getStatus()) ? "selected" : "" %>
                                        ><%= i18n.get("order.shipped") %>
                                    </option>
                                    <option value="Delivered" <%="Delivered" .equals(order.getStatus()) ? "selected"
                                        : "" %>><%= i18n.get("order.delivered") %>
                                    </option>
                                    <option value="Completed" <%="Completed" .equals(order.getStatus()) ? "selected"
                                        : "" %>><%= i18n.get("order.completed") %>
                                    </option>
                                    <option value="Cancelled" <%="Cancelled" .equals(order.getStatus()) ? "selected"
                                        : "" %>><%= i18n.get("order.cancelled") %>
                                    </option>
                                    <option value="Refunded" <%="Refunded" .equals(order.getStatus()) ? "selected" : ""
                                        %>><%= i18n.get("order.refunded") %>
                                    </option>
                                </select>

                                <button type="submit" class="btn btn-save">${i18n.get('admin.updateStatus')}</button>
                                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-cancel"
                                    style="margin-left:8px;">${i18n.get('action.cancel')}</a>
                            </form>
                        </div>

                </body>

                </html>