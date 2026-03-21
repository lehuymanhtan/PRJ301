<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Request #${refund.id} - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User          currentUser = (User)          session.getAttribute("user");
    RefundRequest refund      = (RefundRequest) request.getAttribute("refund");
    Order         order       = (Order)         request.getAttribute("order");
    String        status      = refund.getStatus();
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Refund Header -->
        <div class="refund-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                🔍 Refund Request #<%= refund.getId() %>
            </h1>
            <p class="text-secondary">
                Track your refund request status and details
            </p>
        </div>

        <!-- Navigation -->
        <nav class="refund-nav">
            <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>">Back to Order</a>
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <a href="${pageContext.request.contextPath}/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/users">Profile</a>
            <% if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
            <span><strong><%= currentUser != null ? currentUser.getName() : "" %></strong></span>
        </nav>

        <!-- Refund Information Card -->
        <div class="surface-card refund-info-card">
            <h2 class="text-xl font-semibold mb-lg">Refund Information</h2>

            <div class="info-grid">
                <span class="info-label">Refund ID:</span>
                <span class="info-value">#<%= refund.getId() %></span>

                <span class="info-label">Order ID:</span>
                <span class="info-value">#<%= refund.getOrderId() %></span>

                <% if (order != null) { %>
                <span class="info-label">Order Total:</span>
                <span class="info-value"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</span>
                <% } %>

                <span class="info-label">Reason:</span>
                <span class="info-value"><%= refund.getReason() %></span>

                <% if (refund.getDescription() != null && !refund.getDescription().isEmpty()) { %>
                <span class="info-label">Description:</span>
                <span class="info-value"><%= refund.getDescription() %></span>
                <% } %>

                <span class="info-label">Submitted:</span>
                <span class="info-value">
                    <%= refund.getCreatedAt() != null ? refund.getCreatedAt().toLocalDate().toString() : "" %>
                </span>

                <span class="info-label">Status:</span>
                <span class="info-value">
                    <span class="status-badge badge-<%= status.toLowerCase() %>">
                        <%
                            String statusIcon = "";
                            switch(status) {
                                case "Pending": statusIcon = "⏳"; break;
                                case "WaitForReturn": statusIcon = "📦"; break;
                                case "Verifying": statusIcon = "🔍"; break;
                                case "Done": statusIcon = "✅"; break;
                                case "Rejected": statusIcon = "❌"; break;
                                case "Cancelled": statusIcon = "🚫"; break;
                                default: statusIcon = "📋"; break;
                            }
                        %>
                        <%= statusIcon %> <%= status %>
                    </span>
                </span>
            </div>
        </div>

        <!-- Return instructions shown when admin has approved and is waiting for the return shipment -->
        <% if ("WaitForReturn".equals(status)) { %>
        <div class="surface-card return-instructions-card">
            <h3>📮 Please Return the Product</h3>
            <% if (refund.getReturnAddress() != null && !refund.getReturnAddress().isEmpty()) { %>
            <div class="mb-md">
                <span class="info-label">Return Address:</span>
                <div class="mt-2 p-3 bg-surface-tertiary rounded-md">
                    <%= refund.getReturnAddress() %>
                </div>
            </div>
            <% } %>
            <div class="instruction-box">
                <strong>📋 Instructions:</strong>
                <ul>
                    <li>📦 Pack the item(s) securely before shipping.</li>
                    <li>✍️ Please write <strong>Refund ID: #<%= refund.getId() %></strong> and
                        <strong>Order ID: #<%= refund.getOrderId() %></strong> on the
                        <em>outside</em> of the return package.</li>
                    <li>📄 Keep your shipping receipt until the refund is completed.</li>
                </ul>
            </div>
        </div>
        <% } %>

        <!-- Actions -->
        <div class="refund-actions">
            <!-- Cancel button only available when status is Pending -->
            <% if ("Pending".equals(status)) { %>
            <form action="${pageContext.request.contextPath}/refund" method="post">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id"     value="<%= refund.getId() %>">
                <button type="submit" class="btn btn--error btn--lg"
                        onclick="return confirm('⚠️ Are you sure you want to cancel this refund request?')">
                    🚫 Cancel Refund Request
                </button>
            </form>
            <% } %>
            <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>"
               class="btn btn--secondary btn--lg">
                ← Back to Order
            </a>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
