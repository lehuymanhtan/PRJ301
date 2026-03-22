<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser     = (User)             session.getAttribute("user");
    Order order          = (Order)            request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    RefundRequest refund = (RefundRequest)    request.getAttribute("refund");
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
                        <a class="nav-link dropdown-toggle text-white opacity-75 active" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
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
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to My Orders
        </a>
    </div>

    <h1 class="h3 fw-bold mb-1">
        <i class="bi bi-receipt me-2"></i>Order #<%= order.getId() %> Details
    </h1>
    <p class="text-muted mb-4">View your order information and items</p>

    <div class="row g-4">
        <!-- Order Info -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold">
                    <i class="bi bi-info-circle me-2"></i>Order Information
                </div>
                <div class="card-body">
                    <dl class="row mb-0">
                        <dt class="col-5 text-muted">Order ID:</dt>
                        <dd class="col-7 fw-semibold">#<%= order.getId() %></dd>
                        <dt class="col-5 text-muted">Status:</dt>
                        <dd class="col-7">
                            <% String sc; switch(order.getStatus().toLowerCase()) {
                                case "completed": case "delivered": sc="bg-success"; break;
                                case "pending": sc="bg-warning text-dark"; break;
                                case "processing": sc="bg-info"; break;
                                case "shipped": sc="bg-primary"; break;
                                case "cancelled": sc="bg-danger"; break;
                                default: sc="bg-secondary"; break;
                            } %>
                            <span class="badge <%= sc %>"><%= order.getStatus() %></span>
                        </dd>
                        <dt class="col-5 text-muted">Total:</dt>
                        <dd class="col-7 fw-bold text-orange"><%= String.format("%,d VND", (long)order.getTotalPrice()) %></dd>
                    </dl>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold">
                    <i class="bi bi-bag me-2"></i>Order Items
                </div>
                <div class="card-body p-0">
                    <table class="table admin-table mb-0">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Unit Price</th>
                                <th>Qty</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (details != null && !details.isEmpty()) {
                                double total = 0;
                                for (OrderDetail d : details) { total += d.getSubtotal(); %>
                            <tr>
                                <td><%= d.getProductName() %></td>
                                <td><%= String.format("%,d VND", (long)d.getPrice()) %></td>
                                <td class="text-center"><span class="badge bg-secondary"><%= d.getQuantity() %></span></td>
                                <td class="fw-semibold"><%= String.format("%,d VND", (long)d.getSubtotal()) %></td>
                            </tr>
                            <% } %>
                            <tr class="order-total-row table-warning">
                                <td colspan="3"><strong>Total</strong></td>
                                <td class="text-orange fw-bold"><%= String.format("%,d VND", (long)total) %></td>
                            </tr>
                            <% } else { %>
                            <tr><td colspan="4" class="text-center text-muted py-4">No items found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Refund Section -->
    <% if ("Delivered".equals(order.getStatus())) { %>
    <div class="card shadow-sm mt-4">
        <div class="card-header fw-bold"><i class="bi bi-arrow-counterclockwise me-2"></i>Refund</div>
        <div class="card-body">
            <% if (refund == null) { %>
                <p class="text-muted mb-3">Your order has been delivered. If you're not satisfied, you can request a refund.</p>
                <a href="${pageContext.request.contextPath}/refund?action=create&orderId=<%= order.getId() %>"
                   class="btn btn-danger">
                    <i class="bi bi-arrow-counterclockwise me-2"></i>Request Refund
                </a>
            <% } else { %>
                <div class="mb-2">
                    <span class="text-muted">Refund Request #<%= refund.getId() %>:</span>
                    <span class="badge bg-info ms-2"><%= refund.getStatus() %></span>
                </div>
                <div class="text-muted small mb-3">Reason: <%= refund.getReason() %></div>
                <a href="${pageContext.request.contextPath}/refund?action=detail&id=<%= refund.getId() %>"
                   class="btn btn-sm btn-outline-secondary">
                    <i class="bi bi-file-text me-1"></i>View Refund Details
                </a>
            <% } %>
        </div>
    </div>
    <% } %>

    <div class="mt-4 d-flex gap-2">
        <a href="${pageContext.request.contextPath}/orders" class="btn btn-rt-primary">
            <i class="bi bi-list-check me-2"></i>Back to My Orders
        </a>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
            <i class="bi bi-bag me-2"></i>Continue Shopping
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
