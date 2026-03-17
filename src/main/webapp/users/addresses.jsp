<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Addresses</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .btn { display: inline-block; padding: 8px 16px; text-decoration: none; border: 1px solid #999; border-radius: 3px; cursor: pointer; font-size: 14px; }
        .btn-add { background: #2e7d32; color: white; border-color: #2e7d32; }
        .btn-edit { background: #1976d2; color: white; border-color: #1976d2; }
        .btn-delete { background: #d32f2f; color: white; border-color: #d32f2f; }
        .btn-default { background: #666; color: white; border-color: #666; }
        .address-list { margin-top: 20px; }
        .address-card { border: 1px solid #ddd; border-radius: 4px; padding: 15px; margin-bottom: 15px; background: #f9f9f9; }
        .address-card.default { border-color: #2e7d32; background: #e8f5e9; }
        .badge { display: inline-block; padding: 3px 8px; font-size: 12px; border-radius: 3px; }
        .badge-default { background: #2e7d32; color: white; }
        .success { background: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .error { background: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .info { background: #d1ecf1; color: #0c5460; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .actions { margin-top: 10px; }
    </style>
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    Boolean fromCheckout = (Boolean) request.getAttribute("fromCheckout");
%>

<h1>My Shipping Addresses</h1>
<nav>
    <a href="${pageContext.request.contextPath}/">Home</a> |
    <a href="${pageContext.request.contextPath}/users/profile">Profile</a> |
    <a href="${pageContext.request.contextPath}/orders">Orders</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if (fromCheckout != null && fromCheckout) { %>
    <div class="info">
        <strong>Note:</strong> You need at least one shipping address to checkout. Please add an address below.
    </div>
<% } %>

<% if (success != null) { %>
    <div class="success">
        <% if ("added".equals(success)) { %>
            Address added successfully!
        <% } else if ("updated".equals(success)) { %>
            Address updated successfully!
        <% } else if ("deleted".equals(success)) { %>
            Address deleted successfully!
        <% } else if ("defaultSet".equals(success)) { %>
            Default address updated!
        <% } %>
    </div>
<% } %>

<% if (error != null) { %>
    <div class="error">
        <% if ("notfound".equals(error)) { %>
            Address not found or unauthorized!
        <% } else { %>
            An error occurred!
        <% } %>
    </div>
<% } %>

<a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn-add">+ Add New Address</a>

<div class="address-list">
    <% if (addresses == null || addresses.isEmpty()) { %>
        <p>No addresses found. Please add your first shipping address.</p>
    <% } else { %>
        <% for (UserAddress addr : addresses) { %>
            <div class="address-card <%= addr.isDefault() ? "default" : "" %>">
                <strong><%= addr.getFullName() %></strong>
                <% if (addr.isDefault()) { %>
                    <span class="badge badge-default">DEFAULT</span>
                <% } %>
                <br>
                Phone: <%= addr.getPhone() %><br>
                Address: <%= addr.getFormattedAddress() %>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/users/addresses?action=edit&id=<%= addr.getId() %>" class="btn btn-edit">Edit</a>

                    <% if (!addr.isDefault()) { %>
                        <a href="${pageContext.request.contextPath}/users/addresses?action=delete&id=<%= addr.getId() %>"
                           onclick="return confirm('Are you sure you want to delete this address?');"
                           class="btn btn-delete">Delete</a>

                        <a href="${pageContext.request.contextPath}/users/addresses?action=setDefault&id=<%= addr.getId() %>"
                           class="btn btn-default">Set as Default</a>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } %>
</div>

</body>
</html>
