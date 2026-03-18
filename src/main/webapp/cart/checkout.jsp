<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Cart, models.CartItem, models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - TechStore</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .checkout-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .user-welcome {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: var(--space-md);
            margin-bottom: var(--space-xl);
            padding: var(--space-md);
            background: var(--surface-tertiary);
            border-radius: var(--radius-lg);
            font-size: var(--text-sm);
        }

        .welcome-user {
            font-weight: var(--font-weight-semibold);
            color: var(--glass-primary);
        }

        .nav-links {
            display: flex;
            gap: var(--space-md);
            justify-content: center;
            flex-wrap: wrap;
        }

        .nav-links a {
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-md);
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--transition-colors);
            font-size: var(--text-sm);
        }

        .nav-links a:hover {
            background: var(--glass-primary);
            color: var(--text-inverse);
        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--space-xl);
        }

        .checkout-main {
            display: grid;
            gap: var(--space-lg);
        }

        .section-title {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            margin-bottom: var(--space-md);
            display: flex;
            align-items: center;
            gap: var(--space-2);
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-table th {
            background: var(--surface-tertiary);
            padding: var(--space-md);
            text-align: left;
            font-weight: var(--font-weight-semibold);
            font-size: var(--text-sm);
            color: var(--text-secondary);
            border-bottom: 1px solid var(--gray-200);
        }

        .order-table td {
            padding: var(--space-md);
            border-bottom: 1px solid var(--gray-100);
            color: var(--text-primary);
            font-size: var(--text-md);
        }

        .order-table tr:hover {
            background: var(--surface-secondary);
        }

        .order-table .total-row {
            background: var(--surface-tertiary);
            font-weight: var(--font-weight-semibold);
        }

        .order-table .total-row td {
            border-bottom: none;
        }

        .product-name {
            font-weight: var(--font-weight-medium);
        }

        .price-value {
            font-family: var(--font-mono);
            font-weight: var(--font-weight-medium);
        }

        .address-grid {
            display: grid;
            gap: var(--space-md);
        }

        .address-option {
            position: relative;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: var(--transition-colors);
            cursor: pointer;
            background: var(--surface-primary);
        }

        .address-option:hover {
            border-color: var(--glass-primary);
        }

        .address-option.selected {
            border-color: var(--success);
            background: var(--success-bg);
        }

        .address-option input[type="radio"] {
            position: absolute;
            top: var(--space-md);
            right: var(--space-md);
            width: 20px;
            height: 20px;
            accent-color: var(--success);
        }

        .address-details {
            margin-right: var(--space-xl);
        }

        .address-name {
            font-weight: var(--font-weight-semibold);
            font-size: var(--text-md);
            color: var(--text-primary);
            margin-bottom: var(--space-1);
        }

        .address-phone {
            font-size: var(--text-sm);
            color: var(--text-secondary);
            margin-bottom: var(--space-2);
        }

        .address-text {
            font-size: var(--text-sm);
            color: var(--text-primary);
            line-height: var(--leading-normal);
        }

        .add-address-link {
            display: inline-flex;
            align-items: center;
            gap: var(--space-1);
            color: var(--glass-primary);
            text-decoration: none;
            font-size: var(--text-sm);
            font-weight: var(--font-weight-medium);
            transition: var(--transition-colors);
        }

        .add-address-link:hover {
            text-decoration: underline;
        }

        .payment-grid {
            display: grid;
            gap: var(--space-md);
        }

        .payment-option {
            position: relative;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            transition: var(--transition-colors);
            cursor: pointer;
            background: var(--surface-primary);
            display: flex;
            align-items: center;
            gap: var(--space-md);
        }

        .payment-option:hover {
            border-color: var(--glass-primary);
        }

        .payment-option.selected {
            border-color: var(--glass-primary);
            background: var(--glass-bg);
        }

        .payment-option input[type="radio"] {
            width: 20px;
            height: 20px;
            accent-color: var(--glass-primary);
        }

        .payment-details {
            flex: 1;
        }

        .payment-name {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
            margin-bottom: var(--space-1);
        }

        .payment-desc {
            font-size: var(--text-sm);
            color: var(--text-secondary);
        }

        .vnpay-badge {
            background: linear-gradient(135deg, #005baa, #0066cc);
            color: var(--text-inverse);
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-sm);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-bold);
            letter-spacing: 0.05em;
        }

        .loyalty-section {
            background: var(--success-bg);
            border: 2px solid var(--success);
            border-radius: var(--radius-lg);
            padding: var(--space-lg);
            margin: var(--space-lg) 0;
        }

        .loyalty-toggle {
            display: flex;
            align-items: center;
            gap: var(--space-md);
            cursor: pointer;
        }

        .loyalty-checkbox {
            width: 24px;
            height: 24px;
            accent-color: var(--success);
        }

        .loyalty-balance {
            font-weight: var(--font-weight-bold);
            color: var(--success-dark);
        }

        .loyalty-savings {
            font-size: var(--text-sm);
            color: var(--success-dark);
            margin-top: var(--space-1);
        }

        .order-sidebar {
            position: sticky;
            top: var(--space-lg);
            height: fit-content;
        }

        .order-summary {
            padding: var(--space-lg);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: var(--space-md) 0;
            border-bottom: 1px solid var(--gray-100);
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-label {
            color: var(--text-secondary);
            font-size: var(--text-md);
        }

        .summary-value {
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .summary-total {
            background: var(--surface-tertiary);
            margin: var(--space-md) calc(-1 * var(--space-lg));
            padding: var(--space-md) var(--space-lg);
            border-radius: 0;
        }

        .summary-total .summary-label {
            font-size: var(--text-lg);
            font-weight: var(--font-weight-semibold);
            color: var(--text-primary);
        }

        .summary-total .summary-value {
            font-size: var(--text-xl);
            color: var(--glass-primary);
        }

        .discount-row {
            color: var(--success);
        }

        .discount-row .summary-label {
            color: var(--success-dark);
        }

        .checkout-actions {
            display: grid;
            gap: var(--space-md);
            margin-top: var(--space-lg);
        }

        .no-addresses {
            text-align: center;
            padding: var(--space-xl);
            color: var(--text-secondary);
        }

        .no-addresses-icon {
            font-size: var(--text-4xl);
            margin-bottom: var(--space-md);
        }

        @media (max-width: 768px) {
            .checkout-layout {
                grid-template-columns: 1fr;
                gap: var(--space-lg);
            }

            .order-sidebar {
                position: static;
                order: -1;
            }

            .checkout-header {
                text-align: left;
            }

            .user-welcome {
                flex-direction: column;
                text-align: center;
            }

            .nav-links {
                justify-content: center;
            }

            .order-table th:nth-child(2),
            .order-table td:nth-child(2) {
                display: none;
            }
        }
    </style>
</head>
<body class="bg-surface-secondary">

<%
    User currentUser = (User) session.getAttribute("user");
    Cart cart        = (Cart) request.getAttribute("cart");
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    double grandTotal = (cart != null) ? cart.getTotalCost() : 0;
    int userPoints = (currentUser != null) ? currentUser.getPoints() : 0;
    double maxDiscount = Math.min(userPoints, grandTotal);

    // Find default address
    UserAddress defaultAddress = null;
    if (addresses != null) {
        for (UserAddress addr : addresses) {
            if (addr.isDefault()) {
                defaultAddress = addr;
                break;
            }
        }
    }
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Checkout Header -->
        <div class="checkout-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                🛒 Secure Checkout
            </h1>
            <p class="text-secondary">
                Review your order and complete your purchase
            </p>
        </div>

        <!-- User Welcome -->
        <div class="user-welcome">
            <div>
                Welcome back, <span class="welcome-user"><%= currentUser != null ? currentUser.getName() : "Guest" %></span>!
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="${pageContext.request.contextPath}/products">Products</a>
                <a href="${pageContext.request.contextPath}/cart">Cart</a>
                <a href="${pageContext.request.contextPath}/orders">Orders</a>
                <a href="${pageContext.request.contextPath}/users">Profile</a>
                <% if (currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </div>
        </div>

        <!-- Checkout Layout -->
        <div class="checkout-layout">
            <!-- Main Checkout Form -->
            <div class="checkout-main">
                <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post">

                    <!-- Order Summary -->
                    <div class="surface-card">
                        <h2 class="section-title">📦 Order Summary</h2>
                        <div class="table-container">
                            <table class="order-table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% if (cart != null) {
                                       for (CartItem item : cart) { %>
                                    <tr>
                                        <td>
                                            <div class="product-name"><%= item.getProduct().getName() %></div>
                                        </td>
                                        <td>
                                            <span class="price-value"><%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫</span>
                                        </td>
                                        <td>
                                            <span class="badge badge--processing"><%= item.getQuantity() %></span>
                                        </td>
                                        <td>
                                            <span class="price-value"><%= String.format("%,.0f", item.getSubtotal()) %> ₫</span>
                                        </td>
                                    </tr>
                                <%  }
                                   } %>
                                    <tr class="total-row">
                                        <td colspan="3" style="text-align: right;">Order Total:</td>
                                        <td><span class="price-value"><%= String.format("%,.0f", grandTotal) %> ₫</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Shipping Address -->
                    <div class="surface-card">
                        <h2 class="section-title">📍 Shipping Address</h2>

                        <% if (addresses != null && !addresses.isEmpty()) { %>
                            <div class="address-grid">
                                <% for (UserAddress addr : addresses) { %>
                                    <label class="address-option <%= (defaultAddress != null && addr.getId().equals(defaultAddress.getId())) ? "selected" : "" %>">
                                        <input type="radio" name="addressId" value="<%= addr.getId() %>"
                                            <%= (defaultAddress != null && addr.getId().equals(defaultAddress.getId())) ? "checked" : "" %>
                                            onchange="selectAddress(this)">
                                        <div class="address-details">
                                            <div class="address-name"><%= addr.getFullName() %></div>
                                            <div class="address-phone">📞 <%= addr.getPhone() %></div>
                                            <div class="address-text">📍 <%= addr.getFormattedAddress() %></div>
                                        </div>
                                    </label>
                                <% } %>
                            </div>
                            <div class="mt-md">
                                <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="add-address-link">
                                    ➕ Add new shipping address
                                </a>
                            </div>
                        <% } else { %>
                            <div class="no-addresses">
                                <div class="no-addresses-icon">🏠</div>
                                <h3 class="text-lg font-semibold text-primary mb-md">No Address Found</h3>
                                <p class="mb-lg">You need to add a shipping address before checkout.</p>
                                <a href="${pageContext.request.contextPath}/users/addresses?fromCheckout=true" class="btn btn--primary">
                                    ➕ Add Shipping Address
                                </a>
                            </div>
                        <% } %>
                    </div>

                    <!-- Payment Method -->
                    <div class="surface-card">
                        <h2 class="section-title">💳 Payment Method</h2>
                        <div class="payment-grid">
                            <label class="payment-option selected">
                                <input type="radio" name="paymentMethod" value="COD" checked onchange="selectPayment(this)">
                                <div class="payment-details">
                                    <div class="payment-name">💰 Cash on Delivery</div>
                                    <div class="payment-desc">Pay when you receive your order</div>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="VNPAY" onchange="selectPayment(this)">
                                <div class="payment-details">
                                    <div class="payment-name">
                                        <span class="vnpay-badge">VNPAY</span>
                                        Online Payment
                                    </div>
                                    <div class="payment-desc">ATM Card • QR Code • Visa/Mastercard</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Loyalty Points -->
                    <% if (userPoints > 0) { %>
                        <div class="loyalty-section">
                            <label class="loyalty-toggle">
                                <input type="checkbox" class="loyalty-checkbox" name="usePoints" id="usePoints" onchange="updateTotal(this)">
                                <div>
                                    <div class="loyalty-balance">
                                        💎 Use <span class="points-earned"><%= String.format("%,d", userPoints) %></span> loyalty points
                                    </div>
                                    <div class="loyalty-savings">
                                        Save <span class="price-value" id="savingsAmount"><%= String.format("%,.0f", maxDiscount) %> ₫</span> on this order
                                    </div>
                                </div>
                            </label>
                        </div>
                    <% } %>

                    <!-- Checkout Actions -->
                    <div class="checkout-actions">
                        <button type="submit" class="btn btn--primary btn--lg" <% if (addresses == null || addresses.isEmpty()) { %>disabled<% } %>>
                            🔒 Place Order Securely
                        </button>
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn--secondary btn--lg">
                            ← Back to Cart
                        </a>
                    </div>
                </form>
            </div>

            <!-- Order Sidebar -->
            <div class="order-sidebar">
                <div class="surface-card order-summary">
                    <h3 class="text-lg font-semibold text-primary mb-lg">💰 Order Total</h3>

                    <div class="summary-row">
                        <span class="summary-label">Subtotal:</span>
                        <span class="summary-value"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                    </div>

                    <div class="summary-row">
                        <span class="summary-label">Shipping:</span>
                        <span class="summary-value points-earned">Free</span>
                    </div>

                    <div id="discountRow" class="summary-row discount-row" style="display: none;">
                        <span class="summary-label">Loyalty Discount:</span>
                        <span class="summary-value">-<span id="discountAmount">0</span> ₫</span>
                    </div>

                    <div class="summary-row summary-total">
                        <span class="summary-label">Total:</span>
                        <span class="summary-value" id="finalTotal"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                    </div>

                    <!-- Order Benefits -->
                    <div class="mt-lg p-4 bg-surface-secondary rounded-lg">
                        <h4 class="text-sm font-semibold text-secondary mb-2">Your Benefits:</h4>
                        <ul class="text-xs text-tertiary">
                            <li>✅ Free shipping on all orders</li>
                            <li>🔒 Secure checkout process</li>
                            <li>📦 Order tracking included</li>
                            <% if (userPoints > 0) { %>
                                <li>💎 Loyalty rewards available</li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Checkout JavaScript -->
    <script>
        // Order calculations
        const grandTotal = <%= grandTotal %>;
        const maxDiscount = <%= maxDiscount %>;

        // DOM elements
        const finalTotalElement = document.getElementById('finalTotal');
        const discountRow = document.getElementById('discountRow');
        const discountAmountElement = document.getElementById('discountAmount');
        const usePointsCheckbox = document.getElementById('usePoints');

        // Update total when loyalty points are toggled
        function updateTotal(checkbox) {
            const isUsing = checkbox.checked;
            const discount = isUsing ? maxDiscount : 0;
            const finalTotal = grandTotal - discount;

            // Animate total change
            const currentTotal = parseFloat(finalTotalElement.textContent.replace(/[^\d]/g, ''));

            if (isUsing) {
                discountRow.style.display = 'flex';
                discountAmountElement.textContent = maxDiscount.toLocaleString('vi-VN');

                // Show savings notification
                GlassUtils.showNotification(
                    `💎 You're saving ${maxDiscount.toLocaleString('vi-VN')} ₫ with loyalty points!`,
                    'success'
                );
            } else {
                discountRow.style.display = 'none';
            }

            // Animate number change
            animateValue(finalTotalElement, currentTotal, finalTotal);
        }

        // Address selection
        function selectAddress(radio) {
            document.querySelectorAll('.address-option').forEach(option => {
                option.classList.remove('selected');
            });
            radio.closest('.address-option').classList.add('selected');
        }

        // Payment selection
        function selectPayment(radio) {
            document.querySelectorAll('.payment-option').forEach(option => {
                option.classList.remove('selected');
            });
            radio.closest('.payment-option').classList.add('selected');
        }

        // Animate number values
        function animateValue(element, start, end) {
            const duration = 600;
            const startTime = performance.now();

            function updateValue(currentTime) {
                const elapsed = currentTime - startTime;
                const progress = Math.min(elapsed / duration, 1);

                const current = start + (end - start) * progress;
                element.textContent = Math.round(current).toLocaleString('vi-VN') + ' ₫';

                if (progress < 1) {
                    requestAnimationFrame(updateValue);
                }
            }

            requestAnimationFrame(updateValue);
        }

        // Form validation and submission
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const addressSelected = document.querySelector('input[name="addressId"]:checked');
            const paymentSelected = document.querySelector('input[name="paymentMethod"]:checked');

            if (!addressSelected) {
                e.preventDefault();
                GlassUtils.showNotification('Please select a shipping address', 'error');
                return;
            }

            if (!paymentSelected) {
                e.preventDefault();
                GlassUtils.showNotification('Please select a payment method', 'error');
                return;
            }

            // Show loading state
            const submitButton = this.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            submitButton.disabled = true;
            submitButton.innerHTML = '<span class="loading-spinner loading-spinner--sm"></span> Processing...';

            // Allow form submission to continue
        });

        // Page load animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate cards on load
            const cards = document.querySelectorAll('.surface-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150 + 200);
            });
        });
    </script>

</body>
</html>
