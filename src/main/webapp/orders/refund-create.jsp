<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Refund - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User  currentUser = (User)  session.getAttribute("user");
    Order order       = (Order) request.getAttribute("order");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/orders">Orders</a></li>
            </ul>
            <ul class="navbar-nav">
                <% if (currentUser != null) { %>
                    <li class="nav-item"><span class="nav-link text-white opacity-75"><%= currentUser.getName() %></span></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>"
           class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Order
        </a>
    </div>

    <h1 class="h3 fw-bold mb-1"><i class="bi bi-arrow-counterclockwise me-2"></i>Request Refund</h1>
    <p class="text-muted mb-4">Submit a refund request for Order #<%= order.getId() %></p>

    <div class="row g-4">
        <!-- Order Info -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-info-circle me-2"></i>Order Info</div>
                <div class="card-body">
                    <dl class="row mb-0">
                        <dt class="col-5 text-muted">Order ID:</dt>
                        <dd class="col-7 fw-semibold">#<%= order.getId() %></dd>
                        <dt class="col-5 text-muted">Total:</dt>
                        <dd class="col-7 fw-semibold text-orange"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</dd>
                        <dt class="col-5 text-muted">Status:</dt>
                        <dd class="col-7"><span class="badge bg-info"><%= order.getStatus() %></span></dd>
                    </dl>
                </div>
            </div>
        </div>

        <!-- Refund Form -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-pencil me-2"></i>Refund Details</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/refund" method="post">
                        <input type="hidden" name="action"  value="create">
                        <input type="hidden" name="orderId" value="<%= order.getId() %>">

                        <div class="mb-3">
                            <label for="reason" class="form-label fw-semibold">
                                Reason for Refund <span class="text-danger">*</span>
                            </label>
                            <select name="reason" id="reason" required class="form-select">
                                <option value="" disabled selected>Select a reason</option>
                                <option value="Product damaged">Product damaged</option>
                                <option value="Wrong item received">Wrong item received</option>
                                <option value="Product not as described">Product not as described</option>
                                <option value="Product not received">Product not received</option>
                                <option value="Change of mind">Change of mind</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold">Additional Details</label>
                            <textarea name="description" id="description"
                                      class="form-control"
                                      placeholder="Please describe the issue in detail (optional)..."
                                      rows="4"></textarea>
                            <div class="form-text">
                                <i class="bi bi-lightbulb text-warning me-1"></i>Providing more details helps us process your refund faster.
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-danger btn-lg"
                                    onclick="return confirm('Submit this refund request?')">
                                <i class="bi bi-arrow-counterclockwise me-2"></i>Submit Refund Request
                            </button>
                            <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= order.getId() %>"
                               class="btn btn-outline-secondary btn-lg">
                                <i class="bi bi-x me-1"></i>Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
