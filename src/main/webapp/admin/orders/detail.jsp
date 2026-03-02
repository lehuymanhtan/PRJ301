<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Detail</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 12px; text-decoration: none; color: #333; }
        nav a:hover { text-decoration: underline; }
        .info-box { background: white; border: 1px solid #ddd; border-radius: 4px;
                    padding: 16px; max-width: 600px; margin-bottom: 20px; }
        .info-box p { margin: 6px 0; }
        table { border-collapse: collapse; width: 100%; max-width: 700px;
                background: white; margin-bottom: 16px; }
        th, td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; }
        th { background: #f0f0f0; }
        .btn { display: inline-block; padding: 6px 14px; text-decoration: none;
               border: 1px solid #999; border-radius: 3px; font-size: 13px; margin-right: 6px; }
        .btn-back   { background: #555; color: white; border-color: #555; }
        .btn-edit   { background: #f57c00; color: white; border-color: #f57c00; }
        .footer-total td { font-weight: bold; }
    </style>
</head>
<body>
<%
    Order          order   = (Order)          request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
%>

<h1>Order #<%= order.getId() %> Details</h1>
<nav>
    <a href="${pageContext.request.contextPath}/admin/orders">&#8592; Back to Orders</a> |
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="info-box">
    <p><strong>Order ID:</strong> #<%= order.getId() %></p>
    <p><strong>User ID:</strong> <%= order.getUserId() %></p>
    <p><strong>Total Price:</strong> <%= String.format("%,.0f", order.getTotalPrice()) %> ₫</p>
    <p><strong>Status:</strong> <%= order.getStatus() %></p>
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
        <tr class="footer-total">
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

<a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-back">Back to List</a>
<a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= order.getId() %>"
   class="btn btn-edit">Edit Status</a>

</body>
</html>
