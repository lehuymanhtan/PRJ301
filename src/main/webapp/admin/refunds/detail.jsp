<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Order, models.RefundRequest" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Refund Management - Admin</title>
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

                        <h1>Refund Request #<%= refund.getId() %>
                        </h1>
                        <nav>
                                <a href="${pageContext.request.contextPath}/admin/refunds">&#8592;
                                    Back to Refunds</a> |
                                <a
                                    href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                                |
                                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                        </nav>

                        <div class="info-box">
                            <p><strong>Refund ID:</strong> #<%= refund.getId() %>
                            </p>
                            <p><strong>Order ID:</strong> #<%= refund.getOrderId() %>
                                    &nbsp;
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= refund.getOrderId() %>"
                                        class="btn btn-order"
                                        style="padding:2px 8px; font-size:12px;">View Order</a>
                            </p>
                            <p><strong>User ID:</strong>
                                <%= refund.getUserId() %>
                            </p>
                            <% if (order !=null) { %>
                                <p><strong>Order Total:</strong>
                                    <%= String.format("%,.0f", order.getTotalPrice()) %> &#8363;
                                </p>
                                <% } %>
                                    <p><strong>Reason:</strong>
                                        <%= refund.getReason() %>
                                    </p>
                                    <% if (refund.getDescription() !=null && !refund.getDescription().isEmpty()) { %>
                                        <p><strong>Description:</strong>
                                            <%= refund.getDescription() %>
                                        </p>
                                        <% } %>
                                            <p><strong>Submitted:</strong>
                                                <%= refund.getCreatedAt() !=null ? refund.getCreatedAt().toLocalDate()
                                                    : "" %>
                                            </p>
                                            <p><strong>Status:</strong>
                                                <span class="status-badge badge-<%= status %>">
                                                    <%= status %>
                                                </span>
                                            </p>
                                            <% if (refund.getReturnAddress() !=null &&
                                                !refund.getReturnAddress().isEmpty()) { %>
                                                <p><strong>Return Address:</strong>
                                                    <%= refund.getReturnAddress() %>
                                                </p>
                                                <% } %>
                        </div>

                        <%-- Update form is hidden for terminal statuses --%>
                            <% if (!"Done".equals(status) && !"Rejected".equals(status) && !"Cancelled".equals(status))
                                { %>
                                <div class="update-form">
                                    <h2>Update Refund Status</h2>
                                    <form action="${pageContext.request.contextPath}/admin/refunds" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="<%= refund.getId() %>">

                                        <div class="form-group">
                                            <label for="statusSelect">New Status</label>
                                            <select name="status" id="statusSelect" onchange="toggleReturnAddress()"
                                                required>
                                                <option value="Pending" <%="Pending" .equals(status) ? "selected" : ""
                                                    %>>Pending
                                                </option>
                                                <option value="WaitForReturn" <%="WaitForReturn" .equals(status)
                                                    ? "selected" : "" %>>Wait for Return
                                                </option>
                                                <option value="Verifying" <%="Verifying" .equals(status) ? "selected"
                                                    : "" %>>Verifying
                                                </option>
                                                <option value="Done" <%="Done" .equals(status) ? "selected" : "" %>>Done
                                                </option>
                                                <option value="Rejected" <%="Rejected" .equals(status) ? "selected" : ""
                                                    %>>Rejected
                                                </option>
                                            </select>
                                        </div>

                                        <div class="form-group" id="returnAddressGroup">
                                            <label for="returnAddress">Return Address
                                                <span style="color:#666; font-weight:normal;">(shown to user for shipping the goods back)</span>
                                            </label>
                                            <textarea name="returnAddress" id="returnAddress"
                                                placeholder="e.g. 123 Nguyen Hue, District 1, Ho Chi Minh City"><%= refund.getReturnAddress() != null ? refund.getReturnAddress() : "" %></textarea>
                                        </div>

                                        <button type="submit"
                                            class="btn btn-save">Save Changes</button>
                                    </form>
                                </div>
                                <% } %>

                                    <a href="${pageContext.request.contextPath}/admin/refunds"
                                        class="btn btn-back">&#8592; Back to Refunds</a>

                </body>

                </html>



