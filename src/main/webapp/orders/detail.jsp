<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.User" %>
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
    </style>
</head>
<body>
<%
    User currentUser     = (User)             session.getAttribute("user");
    Order order          = (Order)            request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
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
<a href="${pageContext.request.contextPath}/orders" class="btn btn-back">&#8592; Back to My Orders</a>

</body>
</html>
