<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.PointHistory, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Point History - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
    List<PointHistory> histories = (List<PointHistory>) request.getAttribute("histories");
    Integer targetUserId = (Integer) request.getAttribute("targetUserId");
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
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
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-clock-history me-2"></i>Point History</h1>
    <p class="text-muted mb-4">User #<%= targetUserId %> loyalty transaction timeline</p>

    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Back to Users</a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <% if (histories == null || histories.isEmpty()) { %>
                <div class="text-muted text-center py-5">
                    <i class="bi bi-inbox fs-1 text-secondary mb-3 d-block"></i>
                    No point history for this user.
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Date</th>
                                <th>Order</th>
                                <th>Amount (VND)</th>
                                <th>Points</th>
                                <th>Type</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (PointHistory h : histories) {
                               String badgeClass = "bg-success";
                               if ("USE".equals(h.getType())) badgeClass = "bg-warning text-dark";
                               if ("REFUND".equals(h.getType())) badgeClass = "bg-danger";
                               if ("Adjust".equals(h.getType())) badgeClass = "bg-info text-dark";
                               String ptsClass = (h.getPointsEarned() != null && h.getPointsEarned() >= 0) ? "text-success" : "text-danger";
                               String ptsSign = (h.getPointsEarned() != null && h.getPointsEarned() > 0) ? "+" : "";
                        %>
                            <tr>
                                <td><span class="fw-semibold text-primary">#<%= h.getId() %></span></td>
                                <td><span class="text-muted"><%= h.getCreatedAt() != null ? h.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "-" %></span></td>
                                <td><span class="text-muted"><%= h.getOrderId() != null ? "#" + h.getOrderId() : "-" %></span></td>
                                <td><span class="text-primary"><%= (h.getAmount() != null && h.getAmount() > 0) ? String.format("%,.0f", h.getAmount()) : "-" %></span></td>
                                <td class="fw-bold <%= ptsClass %>"><%= ptsSign %><%= h.getPointsEarned() %></td>
                                <td><span class="badge <%= badgeClass %>"><%= h.getType() %></span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
