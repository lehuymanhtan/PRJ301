<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="models.Order, models.User" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Refund Request</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 20px;
                }

                h1 {
                    margin-bottom: 6px;
                }

                nav {
                    margin-bottom: 20px;
                }

                nav a {
                    margin-right: 10px;
                }

                .info-box {
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    padding: 14px;
                    max-width: 520px;
                    margin-bottom: 20px;
                    background: #fafafa;
                }

                .info-box p {
                    margin: 5px 0;
                }

                .form-group {
                    margin-bottom: 16px;
                    max-width: 520px;
                }

                label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 4px;
                    font-size: 14px;
                }

                select,
                textarea {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 3px;
                    font-size: 14px;
                    box-sizing: border-box;
                }

                textarea {
                    resize: vertical;
                    min-height: 100px;
                }

                .btn {
                    display: inline-block;
                    padding: 8px 18px;
                    text-decoration: none;
                    border: 1px solid #999;
                    border-radius: 3px;
                    font-size: 13px;
                    cursor: pointer;
                }

                .btn-submit {
                    background: #c62828;
                    color: white;
                    border-color: #c62828;
                }

                .btn-back {
                    background: #555;
                    color: white;
                    border-color: #555;
                }

                .note {
                    color: #666;
                    font-size: 13px;
                    margin-top: 4px;
                }
            </style>
        </head>

        <body>
            <% User currentUser=(User) session.getAttribute("user"); Order order=(Order) request.getAttribute("order");
                %>

                <h1>Request Refund for Order #<%= order.getId() %>
                </h1>
                <nav>
                    Welcome, <strong>
                        <%= currentUser !=null ? currentUser.getUsername() : "" %>
                    </strong> |
                    <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>">Back to
                        Order</a>
                    |
                    <a href="${pageContext.request.contextPath}/orders">My Orders</a> |
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </nav>

                <div class="info-box">
                    <p><strong>Order ID:</strong> #<%= order.getId() %>
                    </p>
                    <p><strong>Order Total:</strong>
                        <%= String.format("%,.0f", order.getTotalPrice()) %> &#8363;
                    </p>
                    <p><strong>Status:</strong>
                        <%= order.getStatus() %>
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/refund" method="post">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="orderId" value="<%= order.getId() %>">

                    <div class="form-group">
                        <label for="reason">Reason for Refund <span style="color:red">*</span></label>
                        <select name="reason" id="reason" required>
                            <option value="" disabled selected>-- Select a reason --</option>
                            <option value="Product damaged">Product damaged</option>
                            <option value="Wrong item received">Wrong item received</option>
                            <option value="Product not as described">Product not as described</option>
                            <option value="Product not received">Product not received</option>
                            <option value="Change of mind">Change of mind</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Additional Details</label>
                        <textarea name="description" id="description"
                            placeholder="Please describe the issue in detail (optional)..."></textarea>
                        <p class="note">Providing more details helps us process your refund faster.</p>
                    </div>

                    <button type="submit" class="btn btn-submit"
                        onclick="return confirm('Submit this refund request?')">Submit Refund Request</button>
                    &nbsp;
                    <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>"
                        class="btn btn-back">Cancel</a>
                </form>

        </body>

        </html>