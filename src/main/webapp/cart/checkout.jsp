<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Cart, models.CartItem, models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    Cart cart        = (Cart) request.getAttribute("cart");
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    double grandTotal = (cart != null) ? cart.getTotalCost() : 0;
    int userPoints = (currentUser != null) ? currentUser.getPoints() : 0;
    double maxDiscount = Math.min(userPoints, grandTotal);

    UserAddress defaultAddress = null;
    if (addresses != null) {
        for (UserAddress addr : addresses) {
            if (addr.isDefault()) { defaultAddress = addr; break; }
        }
    }
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/checkout">Checkout</a></li>
            </ul>
            <form class="d-flex mx-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search product..." aria-label="Search" value="${not empty keyword ? keyword : ''}">
                <button class="btn btn-outline-light" type="submit"><i class="bi bi-search"></i></button>
            </form>
            <ul class="navbar-nav">
                <% if (currentUser != null) { %>
                    <% if ("admin".equalsIgnoreCase(currentUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <% } %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white opacity-75" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <%= currentUser.getName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users">Profile</a></li>
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/points">Point History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-bag-check me-2"></i>Secure Checkout</h1>
    <p class="text-muted mb-4">Review your order and complete your purchase</p>

    <div class="row g-4">
        <!-- Main Checkout Form -->
        <div class="col-lg-8">
            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post">

                <!-- Order Summary Table -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-navy text-white fw-bold">
                        <i class="bi bi-box-seam me-2"></i>Order Summary
                    </div>
                    <div class="card-body p-0">
                        <table class="table admin-table mb-0">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Qty</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (cart != null) { for (CartItem item : cart) { %>
                                <tr>
                                    <td><%= item.getProduct().getName() %></td>
                                    <td><%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫</td>
                                    <td><span class="badge bg-secondary"><%= item.getQuantity() %></span></td>
                                    <td class="fw-semibold"><%= String.format("%,.0f", item.getSubtotal()) %> ₫</td>
                                </tr>
                                <% } } %>
                                <tr class="order-total-row table-warning">
                                    <td colspan="3"><strong>Order Total</strong></td>
                                    <td class="text-orange fw-bold fs-6"><%= String.format("%,.0f", grandTotal) %> ₫</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Shipping Address -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-navy text-white fw-bold">
                        <i class="bi bi-geo-alt me-2"></i>Shipping Address
                    </div>
                    <div class="card-body">
                        <% if (addresses != null && !addresses.isEmpty()) { %>
                            <% for (UserAddress addr : addresses) { %>
                                <label class="address-option">
                                    <input type="radio" name="addressId" value="<%= addr.getId() %>"
                                        <%= (defaultAddress != null && addr.getId().equals(defaultAddress.getId())) ? "checked" : "" %>>
                                    <strong><%= addr.getFullName() %></strong><br>
                                    <span class="text-muted small">
                                        <i class="bi bi-telephone me-1"></i><%= addr.getPhone() %><br>
                                        <i class="bi bi-geo-alt me-1"></i><%= addr.getFormattedAddress() %>
                                    </span>
                                </label>
                            <% } %>
                            <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn-sm btn-outline-secondary mt-2">
                                <i class="bi bi-plus-circle me-1"></i>Add new shipping address
                            </a>
                        <% } else { %>
                            <div class="text-center py-3">
                                <i class="bi bi-house-door" style="font-size:2.5rem; color:#cbd5e1"></i>
                                <h5 class="mt-2">No Address Found</h5>
                                <p class="text-muted">You need to add a shipping address before checkout.</p>
                                <a href="${pageContext.request.contextPath}/users/addresses?fromCheckout=true" class="btn btn-rt-primary">
                                    <i class="bi bi-plus-circle me-2"></i>Add Shipping Address
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Payment Method -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-navy text-white fw-bold">
                        <i class="bi bi-credit-card me-2"></i>Payment Method
                    </div>
                    <div class="card-body">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <strong>💰 Cash on Delivery</strong><br>
                            <span class="text-muted small">Pay when you receive your order</span>
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <span class="vnpay-badge">VNPAY</span> <strong>Online Payment</strong><br>
                            <span class="text-muted small">ATM Card • QR Code • Visa/Mastercard</span>
                        </label>
                    </div>
                </div>

                <!-- Loyalty Points -->
                <% if (userPoints > 0) { %>
                    <div class="loyalty-section mb-4">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" name="usePoints" id="usePoints"
                                   onchange="updateTotal(this)">
                            <label class="form-check-label fw-semibold" for="usePoints">
                                💎 Use <%= String.format("%,d", userPoints) %> loyalty points
                            </label>
                        </div>
                        <div class="text-muted small mt-1">
                            Save <span id="savingsAmount" class="fw-semibold text-success"><%= String.format("%,.0f", maxDiscount) %> ₫</span> on this order
                        </div>
                    </div>
                <% } %>

                <!-- Submit -->
                <div class="d-flex gap-3">
                    <button type="submit" class="btn btn-rt-primary btn-lg" <%= (addresses == null || addresses.isEmpty()) ? "disabled" : "" %>>
                        <i class="bi bi-lock me-2"></i>Place Order Securely
                    </button>
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary btn-lg">
                        <i class="bi bi-arrow-left me-2"></i>Back to Cart
                    </a>
                </div>
            </form>
        </div>

        <!-- Order Total Sidebar -->
        <div class="col-lg-4">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold">
                    <i class="bi bi-receipt me-2"></i>Order Total
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Subtotal:</span>
                        <span><%= String.format("%,.0f", grandTotal) %> ₫</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Shipping:</span>
                        <span class="text-success fw-semibold">Free</span>
                    </div>
                    <div id="discountRow" class="d-flex justify-content-between mb-2" style="display:none!important">
                        <span class="text-muted">Loyalty Discount:</span>
                        <span class="text-danger">-<span id="discountAmount">0</span> ₫</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="fw-bold">Total:</span>
                        <span class="fw-bold fs-5 text-orange" id="finalTotal"><%= String.format("%,.0f", grandTotal) %> ₫</span>
                    </div>
                    <ul class="list-unstyled small text-muted">
                        <li><i class="bi bi-check-circle text-success me-2"></i>Free shipping on all orders</li>
                        <li><i class="bi bi-lock text-success me-2"></i>Secure checkout process</li>
                        <li><i class="bi bi-box-seam text-success me-2"></i>Order tracking included</li>
                        <% if (userPoints > 0) { %>
                            <li><i class="bi bi-gem text-warning me-2"></i>Loyalty rewards available</li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    const grandTotal = <%= grandTotal %>;
    const maxDiscount = <%= maxDiscount %>;

    function updateTotal(checkbox) {
        const discount = checkbox.checked ? maxDiscount : 0;
        const finalTotal = grandTotal - discount;
        const discountRow = document.getElementById('discountRow');
        discountRow.style.display = checkbox.checked ? 'flex' : 'none';
        document.getElementById('discountAmount').textContent = maxDiscount.toLocaleString('vi-VN');
        animateValue(document.getElementById('finalTotal'), grandTotal, finalTotal);
    }

    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        const addressSelected = document.querySelector('input[name="addressId"]:checked');
        if (!addressSelected) {
            e.preventDefault();
            alert('Please select a shipping address.');
        }
    });
</script>
</body>
</html>
