<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.OrderDetail, models.RefundRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    Order order        = (Order)          request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    RefundRequest refund = (RefundRequest) request.getAttribute("refund");
    String sc; switch(order.getStatus().toLowerCase()) {
        case "completed": case "delivered": sc="bg-success"; break;
        case "pending": sc="bg-warning text-dark"; break;
        case "processing": sc="bg-info"; break;
        case "shipped": sc="bg-primary"; break;
        case "cancelled": sc="bg-danger"; break;
        default: sc="bg-secondary"; break;
    }
%>
<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Orders
        </a>
    </div>
    <h1 class="h3 fw-bold mb-4"><i class="bi bi-receipt me-2"></i>Order #<%= order.getId() %></h1>

    <!-- Order Meta -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-3 text-center">
                    <div class="text-muted small">Order ID</div>
                    <div class="fw-bold text-orange fs-5">#<%= order.getId() %></div>
                </div>
                <div class="col-3 text-center">
                    <div class="text-muted small">Customer</div>
                    <div class="fw-bold">User #<%= order.getUserId() %></div>
                </div>
                <div class="col-3 text-center">
                    <div class="text-muted small">Total</div>
                    <div class="fw-bold text-orange"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</div>
                </div>
                <div class="col-3 text-center">
                    <div class="text-muted small">Status</div>
                    <span class="badge <%= sc %>"><%= order.getStatus() %></span>
                </div>
            </div>
            <% if (refund != null) { %>
            <hr>
            <div class="text-muted small">Related Refund:
                <a href="${pageContext.request.contextPath}/admin/refunds?action=detail&id=<%= refund.getId() %>">
                    #<%= refund.getId() %> — <%= refund.getStatus() %>
                </a>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Order Items -->
    <div class="card shadow-sm">
        <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-bag me-2"></i>Order Items</div>
        <div class="card-body p-0">
            <table class="table admin-table mb-0">
                <thead><tr><th>Product</th><th>Unit Price</th><th>Qty</th><th>Subtotal</th></tr></thead>
                <tbody>
                    <% if (details != null && !details.isEmpty()) {
                        double total = 0;
                        for (OrderDetail d : details) { total += d.getSubtotal(); %>
                    <tr>
                        <td><%= d.getProductName() %></td>
                        <td><%= String.format("%,.0f", d.getPrice()) %> ₫</td>
                        <td><span class="badge bg-secondary"><%= d.getQuantity() %></span></td>
                        <td class="fw-semibold"><%= String.format("%,.0f", d.getSubtotal()) %> ₫</td>
                    </tr>
                    <% } %>
                    <tr class="table-warning"><td colspan="3"><strong>Total</strong></td><td class="fw-bold text-orange"><%= String.format("%,.0f", total) %> ₫</td></tr>
                    <% } else { %>
                    <tr><td colspan="4" class="text-center py-4 text-muted">No items found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="d-flex gap-2 mt-4">
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i>Back to Orders</a>
        <a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= order.getId() %>" class="btn btn-warning"><i class="bi bi-pencil me-2"></i>Edit Status</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
