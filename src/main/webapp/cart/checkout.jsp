<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Cart, models.CartItem, models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        table { border-collapse: collapse; width: 100%; max-width: 700px; margin-bottom: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .total-row td { font-weight: bold; }
        .summary { max-width: 600px; border: 1px solid #ccc; border-radius: 4px; padding: 16px; }
        .summary p { margin: 6px 0; }
        .payment-option { margin-bottom: 10px; }
        .payment-option label { display: flex; align-items: center; gap: 8px;
               cursor: pointer; font-size: 14px; }
        .vnpay-badge { background: #005baa; color: #fff; font-weight: bold;
               font-size: 12px; padding: 2px 7px; border-radius: 3px; letter-spacing: .5px; }
        .loyalty-box { border: 1px solid #c8e6c9; background: #f1f8e9; border-radius: 4px;
               padding: 10px; margin-bottom: 12px; }
        .loyalty-box label { display: flex; align-items: center; gap: 8px; cursor: pointer; }
        .address-section { border: 1px solid #ddd; background: #f9f9f9; border-radius: 4px;
               padding: 12px; margin-bottom: 16px; }
        .address-option { margin-bottom: 10px; padding: 10px; border: 1px solid #ddd;
               border-radius: 4px; background: white; }
        .address-option.selected { border-color: #2e7d32; background: #e8f5e9; }
        .address-option label { cursor: pointer; display: block; }
        .btn { display: inline-block; padding: 8px 16px; text-decoration: none;
               border: 1px solid #999; border-radius: 3px; cursor: pointer; font-size: 14px; }
        .btn-confirm { background: #2e7d32; color: white; border-color: #2e7d32; }
        .btn-back    { background: #555; color: white; border-color: #555; }
    </style>
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

<h1>Checkout</h1>
<nav>
    Welcome, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong> |
    <a href="${pageContext.request.contextPath}/cart">Back to Cart</a> |
    <a href="${pageContext.request.contextPath}/products">Products</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<h2>Order Summary</h2>
<table>
    <thead>
        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Subtotal</th>
        </tr>
    </thead>
    <tbody>
    <% if (cart != null) {
           for (CartItem item : cart) { %>
        <tr>
            <td><%= item.getProduct().getName() %></td>
            <td><%= String.format("%,.0f", item.getProduct().getPrice()) %> ₫</td>
            <td><%= item.getQuantity() %></td>
            <td><%= String.format("%,.0f", item.getSubtotal()) %> ₫</td>
        </tr>
    <%  }
       } %>
        <tr class="total-row">
            <td colspan="3" style="text-align:right;">Total:</td>
            <td><%= String.format("%,.0f", grandTotal) %> ₫</td>
        </tr>
    </tbody>
</table>

<div class="summary">
    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <h3 style="margin-top:0;">Shipping Address</h3>
        <div class="address-section">
            <% if (addresses != null && !addresses.isEmpty()) { %>
                <% for (UserAddress addr : addresses) { %>
                    <div class="address-option <%= (defaultAddress != null && addr.getId().equals(defaultAddress.getId())) ? "selected" : "" %>">
                        <label>
                            <input type="radio" name="addressId" value="<%= addr.getId() %>"
                                <%= (defaultAddress != null && addr.getId().equals(defaultAddress.getId())) ? "checked" : "" %>>
                            <strong><%= addr.getFullName() %></strong> - <%= addr.getPhone() %><br>
                            <span style="margin-left: 20px;"><%= addr.getFormattedAddress() %></span>
                        </label>
                    </div>
                <% } %>
                <a href="${pageContext.request.contextPath}/users/addresses?action=add" style="font-size: 13px;">+ Add new address</a>
            <% } else { %>
                <p>No addresses found. <a href="${pageContext.request.contextPath}/users/addresses">Add an address</a></p>
            <% } %>
        </div>

        <h3 style="margin-top:0;">Payment Method</h3>
        <div class="payment-option">
            <label>
                <input type="radio" name="paymentMethod" value="COD" checked>
                Cash on Delivery (COD)
            </label>
        </div>
        <div class="payment-option">
            <label>
                <input type="radio" name="paymentMethod" value="VNPAY">
                <span class="vnpay-badge">VNPAY</span>
                Online Payment (ATM / QR / Visa)
            </label>
        </div>
        <hr>
        <% if (userPoints > 0) { %>
        <div class="loyalty-box">
            <label>
                <input type="checkbox" name="usePoints" id="usePoints" onchange="updateTotal(this)">
                Use my <strong><%= userPoints %></strong> points
                &mdash; save <%= String.format("%,.0f", maxDiscount) %> ₫
            </label>
        </div>
        <% } %>
        <p><strong>Shipping:</strong> Free</p>
        <p id="totalDisplay"><strong>Total: <%= String.format("%,.0f", grandTotal) %> ₫</strong></p>
        <br>
        <button type="submit" class="btn btn-confirm">Place Order</button>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-back"
           style="margin-left:8px;">Back to Cart</a>
    </form>
</div>

<script>
var grandTotal  = <%= grandTotal %>;
var maxDiscount = <%= maxDiscount %>;

function updateTotal(cb) {
    var finalTotal = cb.checked ? (grandTotal - maxDiscount) : grandTotal;
    document.getElementById('totalDisplay').innerHTML =
        '<strong>Total: ' + finalTotal.toLocaleString('vi-VN') + ' &#8363;</strong>';
}
</script>

</body>
</html>
