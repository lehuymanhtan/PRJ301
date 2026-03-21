<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #<%= ((Order) request.getAttribute("order")).getId() %> Details - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User currentUser     = (User)             session.getAttribute("user");
    Order order          = (Order)            request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    RefundRequest refund = (RefundRequest)    request.getAttribute("refund");
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Back Link -->
        <div class="mb-lg">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn--back btn--sm">
                ← Back to My Orders
            </a>
        </div>

        <!-- Order Header -->
        <div class="order-header">
            <h1 class="order-title">📋 Order #<%= order.getId() %> Details</h1>
            <p class="order-subtitle">View your order information and items</p>
        </div>

        <!-- Navigation -->
        <div class="order-nav">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/orders">Orders</a>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/users">Profile</a>
            <span>|</span>
            <% if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                <span>|</span>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
            <span>|</span>
            <span><strong><%= currentUser != null ? currentUser.getName() : "" %></strong></span>
        </div>

        <!-- Order Information Grid -->
        <div class="order-info-grid">
            <div class="surface-card">
                <div class="order-info">
                    <h3>📦 Order Information</h3>
                    <div class="info-item">
                        <span class="info-label">Order ID:</span>
                        <span class="info-value">#<%= order.getId() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status:</span>
                        <span class="info-value"><%= order.getStatus() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Total Amount:</span>
                        <span class="info-value"><%= String.format("%,d VND", (long)order.getTotalPrice()) %></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Items Section -->
        <div class="surface-card">
            <h2 class="text-xl font-semibold text-primary mb-lg">🛍️ Order Items</h2>

            <div class="items-table-container">
                <table class="table items-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (details != null && !details.isEmpty()) {
                               double total = 0;
                               for (OrderDetail d : details) {
                                   total += d.getSubtotal(); %>
                            <tr>
                                <td class="font-medium"><%= d.getProductName() %></td>
                                <td><%= String.format("%,d VND", (long)d.getPrice()) %></td>
                                <td class="text-center"><%= d.getQuantity() %></td>
                                <td class="font-semibold"><%= String.format("%,d VND", (long)d.getSubtotal()) %></td>
                            </tr>
                        <%  } %>
                            <tr class="total-row">
                                <td colspan="3" class="text-right">Total:</td>
                                <td class="font-bold text-primary"><%= String.format("%,d VND", (long)total) %></td>
                            </tr>
                        <% } else { %>
                            <tr>
                                <td colspan="4" class="text-center text-secondary py-lg">
                                    No items found.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Refund Section -->
        <% if ("Delivered".equals(order.getStatus())) { %>
            <div class="refund-section">
                <% if (refund == null) { %>
                    <h3 class="text-lg font-semibold text-primary mb-md">🔄 Request Refund</h3>
                    <p class="text-secondary mb-lg">
                        Your order has been delivered. If you're not satisfied, you can request a refund.
                    </p>
                    <a href="${pageContext.request.contextPath}/refund?action=create&orderId=<%= order.getId() %>"
                       class="btn btn--danger">
                        🔄 Request Refund
                    </a>
                <% } else { %>
                    <h3 class="text-lg font-semibold text-primary mb-md">🔄 Refund Status</h3>
                    <div class="refund-info">
                        <div class="info-item">
                            <span class="info-label">Refund Request #<%= refund.getId() %>:</span>
                            <span class="refund-status-badge refund-status-badge--<%= refund.getStatus().toLowerCase() %>">
                                <%= refund.getStatus() %>
                            </span>
                        </div>
                        <div class="info-item mt-md">
                            <span class="info-label">Reason:</span>
                            <span class="info-value"><%= refund.getReason() %></span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/refund?action=detail&id=<%= refund.getId() %>"
                       class="btn btn--secondary btn--sm">
                        📄 View Refund Details
                    </a>
                <% } %>
            </div>
        <% } %>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn--primary btn--lg">
                📋 Back to My Orders
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn--secondary btn--lg">
                🛒 Continue Shopping
            </a>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
