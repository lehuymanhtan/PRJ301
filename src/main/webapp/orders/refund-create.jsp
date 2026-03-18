<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Refund - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .refund-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .refund-nav {
            display: flex;
            justify-content: center;
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
            flex-wrap: wrap;
        }

        .refund-nav a {
            padding: var(--space-2) var(--space-4);
            border-radius: var(--radius-lg);
            color: var(--text-inverse-secondary);
            text-decoration: none;
            transition: var(--transition-colors);
            font-size: var(--text-sm);
            background: var(--glass-secondary);
            border: 1px solid var(--gray-200);
        }

        .refund-nav a:hover {
            background: var(--glass-primary);
            color: var(--text-inverse);
            transform: translateY(-1px);
        }

        .order-info-card {
            max-width: 600px;
            margin: 0 auto var(--space-xl) auto;
        }

        .refund-form-card {
            max-width: 600px;
            margin: 0 auto;
            animation: fadeInScale var(--duration-500) var(--ease-out);
        }

        .info-grid {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: var(--space-md);
            align-items: center;
        }

        .info-label {
            font-weight: var(--font-weight-semibold);
            color: var(--text-secondary);
            font-size: var(--text-sm);
        }

        .info-value {
            font-weight: var(--font-weight-medium);
            color: var(--text-primary);
        }

        .form-actions {
            display: flex;
            gap: var(--space-md);
            justify-content: center;
            margin-top: var(--space-xl);
        }

        .form-help {
            padding: var(--space-3);
            background: var(--surface-tertiary);
            border-radius: var(--radius-md);
            color: var(--text-secondary);
            font-size: var(--text-sm);
            margin-top: var(--space-md);
        }

        @media (max-width: 768px) {
            .refund-nav {
                flex-direction: column;
                align-items: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
                gap: var(--space-2);
            }

            .info-label,
            .info-value {
                text-align: left;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body class="bg-surface-secondary">
<%
    User  currentUser = (User)  session.getAttribute("user");
    Order order       = (Order) request.getAttribute("order");
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Refund Header -->
        <div class="refund-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                🔄 Request Refund
            </h1>
            <p class="text-secondary">
                Submit a refund request for Order #<%= order.getId() %>
            </p>
        </div>

        <!-- Navigation -->
        <nav class="refund-nav">
            <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>">Back to Order</a>
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

        <!-- Order Information Card -->
        <div class="surface-card order-info-card">
            <h2 class="text-xl font-semibold mb-lg">Order Information</h2>

            <div class="info-grid">
                <span class="info-label">Order ID:</span>
                <span class="info-value">#<%= order.getId() %></span>

                <span class="info-label">Order Total:</span>
                <span class="info-value"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</span>

                <span class="info-label">Order Status:</span>
                <span class="info-value">
                    <span class="badge badge--<%= order.getStatus().toLowerCase().replace(" ", "-") %>">
                        <%= order.getStatus() %>
                    </span>
                </span>
            </div>
        </div>

        <!-- Refund Form Card -->
        <div class="surface-card refund-form-card">
            <h2 class="text-xl font-semibold mb-lg">Refund Details</h2>

            <form action="${pageContext.request.contextPath}/refund" method="post">
                <input type="hidden" name="action"  value="create">
                <input type="hidden" name="orderId" value="<%= order.getId() %>">

                <div class="form-group">
                    <label for="reason" class="form-label">Reason for Refund <span class="text-error">*</span></label>
                    <select name="reason" id="reason" required class="form-select">
                        <option value="" disabled selected>🤔 Select a reason</option>
                        <option value="Product damaged">📦 Product damaged</option>
                        <option value="Wrong item received">❌ Wrong item received</option>
                        <option value="Product not as described">📝 Product not as described</option>
                        <option value="Product not received">📭 Product not received</option>
                        <option value="Change of mind">💭 Change of mind</option>
                        <option value="Other">❓ Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Additional Details</label>
                    <textarea name="description" id="description"
                              class="form-textarea"
                              placeholder="Please describe the issue in detail (optional)..."
                              rows="4"></textarea>
                    <div class="form-help">
                        💡 Providing more details helps us process your refund faster.
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn--error btn--lg"
                            onclick="return confirm('⚠️ Submit this refund request?')">
                        🔄 Submit Refund Request
                    </button>
                    <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>"
                       class="btn btn--secondary btn--lg">
                        ❌ Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

</body>
</html>
