<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Order, models.RefundRequest" %>
        <%@ page import="util.I18nUtil" %>
            <% I18nUtil i18n=(I18nUtil) request.getAttribute("i18n"); if (i18n==null) i18n=new I18nUtil(request); %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>${i18n.get('admin.refundManagement')} - Admin</title>
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

                        .info-box {
                            background: white;
                            border: 1px solid #ddd;
                            border-radius: 4px;
                            padding: 16px;
                            max-width: 600px;
                            margin-bottom: 20px;
                        }

                        .info-box p {
                            margin: 6px 0;
                        }

                        .status-badge {
                            display: inline-block;
                            padding: 3px 10px;
                            border-radius: 12px;
                            font-size: 13px;
                            font-weight: bold;
                        }

                        .badge-Pending {
                            background: #fff3cd;
                            color: #856404;
                        }

                        .badge-WaitForReturn {
                            background: #cce5ff;
                            color: #004085;
                        }

                        .badge-Verifying {
                            background: #d1ecf1;
                            color: #0c5460;
                        }

                        .badge-Done {
                            background: #d4edda;
                            color: #155724;
                        }

                        .badge-Rejected {
                            background: #f8d7da;
                            color: #721c24;
                        }

                        .badge-Cancelled {
                            background: #e2e3e5;
                            color: #383d41;
                        }

                        .update-form {
                            background: white;
                            border: 1px solid #ddd;
                            border-radius: 4px;
                            padding: 16px;
                            max-width: 600px;
                            margin-bottom: 20px;
                        }

                        .update-form h2 {
                            margin: 0 0 12px;
                            font-size: 16px;
                        }

                        .form-group {
                            margin-bottom: 14px;
                        }

                        label {
                            display: block;
                            font-weight: bold;
                            margin-bottom: 4px;
                            font-size: 14px;
                        }

                        select,
                        textarea {
                            width: 100%;
                            padding: 8px;
                            border: 1px solid #ccc;
                            border-radius: 3px;
                            font-size: 14px;
                            box-sizing: border-box;
                        }

                        textarea {
                            resize: vertical;
                            min-height: 80px;
                        }

                        #returnAddressGroup {
                            display: none;
                        }

                        .btn {
                            display: inline-block;
                            padding: 6px 16px;
                            text-decoration: none;
                            border: 1px solid #999;
                            border-radius: 3px;
                            font-size: 13px;
                            cursor: pointer;
                        }

                        .btn-save {
                            background: #2e7d32;
                            color: white;
                            border-color: #2e7d32;
                        }

                        .btn-back {
                            background: #555;
                            color: white;
                            border-color: #555;
                        }

                        .btn-order {
                            background: #0277bd;
                            color: white;
                            border-color: #0277bd;
                        }
                    </style>
                    <script>
                        function toggleReturnAddress() {
                            var sel = document.getElementById("statusSelect");
                            var grp = document.getElementById("returnAddressGroup");
                            grp.style.display = (sel.value === "WaitForReturn") ? "block" : "none";
                        }
                        window.onload = function () { toggleReturnAddress(); };
                    </script>
                </head>

                <body>
                    <% RefundRequest refund=(RefundRequest) request.getAttribute("refund"); Order order=(Order)
                        request.getAttribute("order"); String status=refund.getStatus(); %>

                        <h1>${i18n.get('admin.refundDetail')} #<%= refund.getId() %>
                        </h1>
                        <nav>
                            <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
                                <a href="${pageContext.request.contextPath}/admin/refunds">&#8592;
                                    ${i18n.get('admin.backToRefunds')}</a> |
                                <a
                                    href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('nav.dashboard')}</a>
                                |
                                <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
                        </nav>

                        <div class="info-box">
                            <p><strong>${i18n.get('refund.id')}:</strong> #<%= refund.getId() %>
                            </p>
                            <p><strong>${i18n.get('refund.orderId')}:</strong> #<%= refund.getOrderId() %>
                                    &nbsp;
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= refund.getOrderId() %>"
                                        class="btn btn-order"
                                        style="padding:2px 8px; font-size:12px;">${i18n.get('admin.viewOrder')}</a>
                            </p>
                            <p><strong>${i18n.get('order.userId')}:</strong>
                                <%= refund.getUserId() %>
                            </p>
                            <% if (order !=null) { %>
                                <p><strong>${i18n.get('refund.orderTotal')}:</strong>
                                    <%= String.format("%,.0f", order.getTotalPrice()) %> ₫
                                </p>
                                <% } %>
                                    <p><strong>${i18n.get('refund.reasonLabel')}:</strong>
                                        <%= refund.getReason() %>
                                    </p>
                                    <% if (refund.getDescription() !=null && !refund.getDescription().isEmpty()) { %>
                                        <p><strong>${i18n.get('refund.description')}:</strong>
                                            <%= refund.getDescription() %>
                                        </p>
                                        <% } %>
                                            <p><strong>${i18n.get('refund.submitted')}:</strong>
                                                <%= refund.getCreatedAt() !=null ? refund.getCreatedAt().toLocalDate()
                                                    : "" %>
                                            </p>
                                            <p><strong>${i18n.get('refund.status')}:</strong>
                                                <span class="status-badge badge-<%= status %>">
                                                    <%= status %>
                                                </span>
                                            </p>
                                            <% if (refund.getReturnAddress() !=null &&
                                                !refund.getReturnAddress().isEmpty()) { %>
                                                <p><strong>${i18n.get('refund.returnAddress')}:</strong>
                                                    <%= refund.getReturnAddress() %>
                                                </p>
                                                <% } %>
                        </div>

                        <%-- Update form is hidden for terminal statuses --%>
                            <% if (!"Done".equals(status) && !"Rejected".equals(status) && !"Cancelled".equals(status))
                                { %>
                                <div class="update-form">
                                    <h2>${i18n.get('admin.updateRefundStatus')}</h2>
                                    <form action="${pageContext.request.contextPath}/admin/refunds" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="<%= refund.getId() %>">

                                        <div class="form-group">
                                            <label for="statusSelect">${i18n.get('admin.newStatus')}</label>
                                            <select name="status" id="statusSelect" onchange="toggleReturnAddress()"
                                                required>
                                                <option value="Pending" <%="Pending" .equals(status) ? "selected" : ""
                                                    %>><%= i18n.get("refund.statusPending") %>
                                                </option>
                                                <option value="WaitForReturn" <%="WaitForReturn" .equals(status)
                                                    ? "selected" : "" %>><%= i18n.get("refund.statusWaitForReturn") %>
                                                </option>
                                                <option value="Verifying" <%="Verifying" .equals(status) ? "selected"
                                                    : "" %>><%= i18n.get("refund.statusVerifying") %>
                                                </option>
                                                <option value="Done" <%="Done" .equals(status) ? "selected" : "" %>><%=
                                                        i18n.get("refund.statusDone") %>
                                                </option>
                                                <option value="Rejected" <%="Rejected" .equals(status) ? "selected" : ""
                                                    %>><%= i18n.get("refund.statusRejected") %>
                                                </option>
                                            </select>
                                        </div>

                                        <div class="form-group" id="returnAddressGroup">
                                            <label for="returnAddress">${i18n.get('admin.returnAddress')}
                                                <span style="color:#666; font-weight:normal;">(<%=
                                                        i18n.get("admin.returnAddressNote") %>)</span>
                                            </label>
                                            <textarea name="returnAddress" id="returnAddress"
                                                placeholder="e.g. 123 Nguyen Hue, District 1, Ho Chi Minh City"><%= refund.getReturnAddress() != null ? refund.getReturnAddress() : "" %></textarea>
                                        </div>

                                        <button type="submit"
                                            class="btn btn-save">${i18n.get('admin.saveChanges')}</button>
                                    </form>
                                </div>
                                <% } %>

                                    <a href="${pageContext.request.contextPath}/admin/refunds"
                                        class="btn btn-back">&#8592; ${i18n.get('admin.backToRefunds')}</a>

                </body>

                </html>