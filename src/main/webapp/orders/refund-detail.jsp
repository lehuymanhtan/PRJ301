<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Request Details - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User          currentUser = (User)          session.getAttribute("user");
    RefundRequest refund      = (RefundRequest) request.getAttribute("refund");
    Order         order       = (Order)         request.getAttribute("order");
    String        status      = refund.getStatus();
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
            <form class="d-flex mx-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search product..." aria-label="Search" value="${not empty keyword ? keyword : ''}">
                <button class="btn btn-outline-light" type="submit"><i class="bi bi-search"></i></button>
            </form>
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
        <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>"
           class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Order
        </a>
    </div>

    <h1 class="h3 fw-bold mb-1"><i class="bi bi-search me-2"></i>Refund Request #<%= refund.getId() %></h1>
    <p class="text-muted mb-4">Track your refund request status and details</p>

    <!-- Refund Info Card -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-info-circle me-2"></i>Refund Information</div>
        <div class="card-body">
            <dl class="row">
                <dt class="col-sm-3 text-muted">Refund ID:</dt>
                <dd class="col-sm-9 fw-semibold">#<%= refund.getId() %></dd>
                <dt class="col-sm-3 text-muted">Order ID:</dt>
                <dd class="col-sm-9">#<%= refund.getOrderId() %></dd>
                <% if (order != null) { %>
                <dt class="col-sm-3 text-muted">Order Total:</dt>
                <dd class="col-sm-9 fw-semibold text-orange"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</dd>
                <% } %>
                <dt class="col-sm-3 text-muted">Reason:</dt>
                <dd class="col-sm-9"><%= refund.getReason() %></dd>
                <% if (refund.getDescription() != null && !refund.getDescription().isEmpty()) { %>
                <dt class="col-sm-3 text-muted">Description:</dt>
                <dd class="col-sm-9"><%= refund.getDescription() %></dd>
                <% } %>
                <dt class="col-sm-3 text-muted">Submitted:</dt>
                <dd class="col-sm-9"><%= refund.getCreatedAt() != null ? refund.getCreatedAt().toLocalDate().toString() : "" %></dd>
                <dt class="col-sm-3 text-muted">Status:</dt>
                <dd class="col-sm-9">
                    <%
                        String sc;
                        switch(status) {
                            case "Done": sc="bg-success"; break;
                            case "Pending": sc="bg-warning text-dark"; break;
                            case "Verifying": sc="bg-info"; break;
                            case "WaitForReturn": sc="bg-primary"; break;
                            case "Rejected": case "Cancelled": sc="bg-danger"; break;
                            default: sc="bg-secondary"; break;
                        }
                    %>
                    <span class="badge <%= sc %>"><%= status %></span>
                </dd>
            </dl>
        </div>
    </div>

    <!-- Return Instructions (when admin approved, waiting for return) -->
    <% if ("WaitForReturn".equals(status)) { %>
    <div class="card shadow-sm border-warning mb-4">
        <div class="card-header bg-warning fw-bold"><i class="bi bi-box-seam me-2"></i>Please Return the Product</div>
        <div class="card-body">
            <% if (refund.getReturnAddress() != null && !refund.getReturnAddress().isEmpty()) { %>
                <p class="fw-semibold mb-1">Return Address:</p>
                <div class="bg-light rounded p-3 mb-3"><%= refund.getReturnAddress() %></div>
            <% } %>
            <ul class="mb-0">
                <li>Pack the item(s) securely before shipping.</li>
                <li>Write <strong>Refund ID: #<%= refund.getId() %></strong> and <strong>Order ID: #<%= refund.getOrderId() %></strong> on the outside of the return package.</li>
                <li>Keep your shipping receipt until the refund is completed.</li>
            </ul>
        </div>
    </div>
    <% } %>

    <!-- Actions -->
    <div class="d-flex gap-2">
        <% if ("Pending".equals(status)) { %>
        <form action="${pageContext.request.contextPath}/refund" method="post">
            <input type="hidden" name="action" value="cancel">
            <input type="hidden" name="id"     value="<%= refund.getId() %>">
            <button type="submit" class="btn btn-danger"
                    onclick="return confirm('Are you sure you want to cancel this refund request?')">
                <i class="bi bi-x-circle me-2"></i>Cancel Refund Request
            </button>
        </form>
        <% } %>
        <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= refund.getOrderId() %>"
           class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Back to Order
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
