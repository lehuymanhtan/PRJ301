<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Detail</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .info-box { border: 1px solid #ccc; border-radius: 4px;
                    padding: 14px; max-width: 500px; margin-bottom: 20px; }
        .info-box p { margin: 6px 0; }
        table { border-collapse: collapse; width: 100%; max-width: 700px; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
        th { background: #f0f0f0; }
        .total-row td { font-weight: bold; }
        .btn { display: inline-block; padding: 6px 14px; text-decoration: none;
               border: 1px solid #999; border-radius: 3px; font-size: 13px; }
        .btn-back { background: #555; color: white; border-color: #555; }
        .btn-refund { background: #c62828; color: white; border-color: #c62828; }
        .refund-info { border: 1px solid #bee5eb; background: #d1ecf1;
                       border-radius: 4px; padding: 12px; max-width: 500px;
                       margin-bottom: 16px; color: #0c5460; }
        .refund-info p { margin: 5px 0; }
        .badge { display: inline-block; padding: 2px 8px; border-radius: 10px;
                 font-size: 12px; font-weight: bold; }
        .badge-Pending       { background: #fff3cd; color: #856404; }
        .badge-WaitForReturn { background: #cce5ff; color: #004085; }
        .badge-Verifying     { background: #d1ecf1; color: #0c5460; }
        .badge-Done          { background: #d4edda; color: #155724; }
        .badge-Rejected      { background: #f8d7da; color: #721c24; }
        .badge-Cancelled     { background: #e2e3e5; color: #383d41; }
    </style>
</head>
<body>
<%
    User currentUser     = (User)             session.getAttribute("user");
    Order order          = (Order)            request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    RefundRequest refund = (RefundRequest)    request.getAttribute("refund");
%>

<h1>Order #<%= order.getId() %> Details</h1>
<nav>
    Welcome, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong> |
    <a href="${pageContext.request.contextPath}/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/products">Products</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="info-box">
    <p><strong>Order ID:</strong> #<%= order.getId() %></p>
    <p><strong>Status:</strong> <%= order.getStatus() %></p>
    <p><strong>Total:</strong> <%= String.format("%,.0f", order.getTotalPrice()) %> ₫</p>
</div>

<h2>Items</h2>
<table>
    <thead>
        <tr>
            <th>Product</th>
            <th>Unit Price</th>
            <th>Qty</th>
            <th>Subtotal</th>
        </tr>
    </thead>
    <tbody>
    <% if (details != null && !details.isEmpty()) {
           double total = 0;
           for (OrderDetail d : details) {
               total += d.getSubtotal(); %>
        <tr>
            <td><%= d.getProductName() %></td>
            <td><%= String.format("%,.0f", d.getPrice()) %> ₫</td>
            <td><%= d.getQuantity() %></td>
            <td><%= String.format("%,.0f", d.getSubtotal()) %> ₫</td>
        </tr>
    <%  } %>
        <tr class="total-row">
            <td colspan="3" style="text-align:right;">Total:</td>
            <td><%= String.format("%,.0f", total) %> ₫</td>
        </tr>
    <% } else { %>
        <tr>
            <td colspan="4" style="text-align:center; color:#777;">No items found.</td>
        </tr>
    <% } %>
    </tbody>
</table>

<br>
<%-- Refund section: visible only when order is Delivered --%>
<% if ("Delivered".equals(order.getStatus())) { %>
    <% if (refund == null) { %>
        <a href="${pageContext.request.contextPath}/refund?action=create&orderId=<%= order.getId() %>"
           class="btn btn-refund">&#8617; Request Refund</a>
        &nbsp;
    <% } else { %>
        <div class="refund-info">
            <p><strong>Refund Request #<%= refund.getId() %>:</strong>
                <span class="badge badge-<%= refund.getStatus() %>"><%= refund.getStatus() %></span>
            </p>
            <p>Reason: <%= refund.getReason() %></p>
            <a href="${pageContext.request.contextPath}/refund?action=detail&id=<%= refund.getId() %>"
               class="btn" style="font-size:12px;">View Refund Details</a>
        </div>
    <% } %>
<% } %>
<a href="${pageContext.request.contextPath}/orders" class="btn btn-back">&#8592; Back to My Orders</a>

</body>
</html>
