<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refund Request #${refund.id}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .info-box { border: 1px solid #ccc; border-radius: 4px;
                    padding: 14px; max-width: 560px; margin-bottom: 20px; background: #fafafa; }
        .info-box p { margin: 6px 0; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 12px;
                        font-size: 13px; font-weight: bold; }
        .badge-Pending       { background: #fff3cd; color: #856404; }
        .badge-WaitForReturn { background: #cce5ff; color: #004085; }
        .badge-Verifying     { background: #d1ecf1; color: #0c5460; }
        .badge-Done          { background: #d4edda; color: #155724; }
        .badge-Rejected      { background: #f8d7da; color: #721c24; }
        .badge-Cancelled     { background: #e2e3e5; color: #383d41; }
        .return-info { border: 1px solid #bee5eb; background: #d1ecf1;
                       border-radius: 4px; padding: 14px; max-width: 560px;
                       margin-bottom: 20px; color: #0c5460; }
        .return-info h3 { margin: 0 0 10px; }
        .return-info p  { margin: 5px 0; }
        .instruction-box { background: #fff8e1; border: 1px solid #ffe082;
                           border-radius: 4px; padding: 12px; max-width: 560px;
                           margin-top: 10px; color: #5d4037; font-size: 14px; }
        .btn { display: inline-block; padding: 7px 16px; text-decoration: none;
               border: 1px solid #999; border-radius: 3px; font-size: 13px; cursor: pointer; }
        .btn-back   { background: #555;    color: white; border-color: #555; }
        .btn-cancel { background: #c62828; color: white; border-color: #c62828; }
    </style>
</head>
<body>
<%
    User          currentUser = (User)          session.getAttribute("user");
    RefundRequest refund      = (RefundRequest) request.getAttribute("refund");
    Order         order       = (Order)         request.getAttribute("order");
    String        status      = refund.getStatus();
%>

<h1>Refund Request #<%= refund.getId() %></h1>
<nav>
    Welcome, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong> |
    <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>">Back to Order</a> |
    <a href="${pageContext.request.contextPath}/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="info-box">
    <p><strong>Refund ID:</strong> #<%= refund.getId() %></p>
    <p><strong>Order ID:</strong>  #<%= refund.getOrderId() %></p>
    <% if (order != null) { %>
    <p><strong>Order Total:</strong> <%= String.format("%,.0f", order.getTotalPrice()) %> ₫</p>
    <% } %>
    <p><strong>Reason:</strong>      <%= refund.getReason() %></p>
    <% if (refund.getDescription() != null && !refund.getDescription().isEmpty()) { %>
    <p><strong>Description:</strong> <%= refund.getDescription() %></p>
    <% } %>
    <p><strong>Submitted:</strong>   <%= refund.getCreatedAt() != null
            ? refund.getCreatedAt().toLocalDate().toString() : "" %></p>
    <p><strong>Status:</strong>
        <span class="status-badge badge-<%= status %>"><%= status %></span>
    </p>
</div>

<%-- Return instructions shown when admin has approved and is waiting for the return shipment --%>
<% if ("WaitForReturn".equals(status)) { %>
<div class="return-info">
    <h3>&#9993; Please Return the Product</h3>
    <% if (refund.getReturnAddress() != null && !refund.getReturnAddress().isEmpty()) { %>
    <p><strong>Return Address:</strong></p>
    <p><%= refund.getReturnAddress() %></p>
    <% } %>
    <div class="instruction-box">
        <strong>Instructions:</strong>
        <ul style="margin: 6px 0; padding-left: 20px;">
            <li>Pack the item(s) securely before shipping.</li>
            <li>Please write <strong>Refund ID: #<%= refund.getId() %></strong> and
                <strong>Order ID: #<%= refund.getOrderId() %></strong> on the
                <em>outside</em> of the return package.</li>
            <li>Keep your shipping receipt until the refund is completed.</li>
        </ul>
    </div>
</div>
<% } %>

<%-- Cancel button only available when status is Pending --%>
<% if ("Pending".equals(status)) { %>
<form action="${pageContext.request.contextPath}/refund" method="post" style="display:inline;">
    <input type="hidden" name="action" value="cancel">
    <input type="hidden" name="id"     value="<%= refund.getId() %>">
    <button type="submit" class="btn btn-cancel"
            onclick="return confirm('Are you sure you want to cancel this refund request?')">
        Cancel Refund Request
    </button>
</form>
&nbsp;
<% } %>
<a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>"
   class="btn btn-back">&#8592; Back to Order</a>

</body>
</html>
