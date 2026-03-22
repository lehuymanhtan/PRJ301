<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.PointHistory, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Point History - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    List<PointHistory> pointHistory = (List<PointHistory>) request.getAttribute("pointHistory");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Cart</a></li>
            </ul>
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
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/points">Point History</a></li>
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
        <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Profile
        </a>
    </div>

    <h1 class="h3 fw-bold mb-1"><i class="bi bi-gem me-2"></i>Point History</h1>
    <p class="text-muted mb-4">Track all your loyalty point transactions</p>

    <!-- Stats -->
    <div class="row g-3 mb-4">
        <div class="col-4">
            <div class="card stat-card stat-card-blue text-center">
                <div class="card-body">
                    <div class="stat-value"><%= String.format("%,d", currentUser.getPoints()) %></div>
                    <div class="stat-label">Current Balance</div>
                </div>
            </div>
        </div>
        <div class="col-4">
            <div class="card stat-card stat-card-orange text-center">
                <div class="card-body">
                    <div class="stat-value"><%= currentUser.getMembershipTier() %></div>
                    <div class="stat-label">Membership Tier</div>
                </div>
            </div>
        </div>
        <div class="col-4">
            <div class="card stat-card stat-card-green text-center">
                <div class="card-body">
                    <div class="stat-value"><%= request.getAttribute("totalCount") != null ? String.format("%,d", request.getAttribute("totalCount")) : (pointHistory != null ? pointHistory.size() : 0) %></div>
                    <div class="stat-label">Transactions</div>
                </div>
            </div>
        </div>
    </div>

    <!-- History Table -->
    <% if (pointHistory == null || pointHistory.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-gem" style="font-size:4rem; color:#cbd5e1"></i>
            <h3 class="mt-3 text-muted">No Point History Yet</h3>
            <p class="text-muted">Start shopping to earn loyalty points!</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-rt-primary">
                <i class="bi bi-bag me-2"></i>Start Shopping
            </a>
        </div>
    <% } else { %>
        <div class="card shadow-sm">
            <div class="card-header bg-navy text-white fw-bold">
                <i class="bi bi-clock-history me-2"></i>Transaction History
                <span class="badge bg-light text-dark ms-2"><%= request.getAttribute("totalCount") != null ? String.format("%,d", request.getAttribute("totalCount")) : pointHistory.size() %></span>
            </div>
            <div class="card-body p-0">
                <table class="table admin-table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date & Time</th>
                            <th>Order Reference</th>
                            <th>Amount (VND)</th>
                            <th>Points</th>
                            <th>Type</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (PointHistory h : pointHistory) {
                        String badgeClass;
                        String badgeText = h.getType();
                        if ("USE".equals(h.getType())) { badgeClass = "bg-warning text-dark"; badgeText = "Redeemed"; }
                        else if ("REFUND".equals(h.getType())) { badgeClass = "bg-danger"; badgeText = "Refunded"; }
                        else if ("Adjust".equals(h.getType())) { badgeClass = "bg-primary"; badgeText = "Adjusted"; }
                        else { badgeClass = "bg-success"; badgeText = "Earned"; }
                        boolean isPositive = (h.getPointsEarned() != null && h.getPointsEarned() >= 0);
                        String pointsSign = (h.getPointsEarned() != null && h.getPointsEarned() > 0) ? "+" : "";
                    %>
                    <tr>
                        <td>#<%= h.getId() %></td>
                        <td><%= h.getCreatedAt() != null ? h.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "-" %></td>
                        <td>
                            <% if (h.getOrderId() != null) { %>
                                <a href="${pageContext.request.contextPath}/orders?action=detail&orderId=<%= h.getOrderId() %>">
                                    Order #<%= h.getOrderId() %>
                                </a>
                            <% } else { %><span class="text-muted">Manual Entry</span><% } %>
                        </td>
                        <td>
                            <% if (h.getAmount() != null && h.getAmount() > 0) { %>
                                <span class="fw-semibold"><%= String.format("%,.0f", h.getAmount()) %> ₫</span>
                            <% } else { %>-<% } %>
                        </td>
                        <td>
                            <span class="fw-bold <%= isPositive ? "text-success" : "text-danger" %>">
                                <%= pointsSign %><%= h.getPointsEarned() %> pts
                            </span>
                        </td>
                        <td><span class="badge <%= badgeClass %>"><%= badgeText %></span></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    <% 
        Long totalPages = (Long) request.getAttribute("totalPages");
        Integer pageNumber = (Integer) request.getAttribute("pageNumber");
        String queryString = "";
    %>
    <% if (totalPages != null && totalPages > 1) { %>
    <nav class="mt-4">
        <ul class="pagination justify-content-center mb-0">
            <% if (pageNumber > 1) { %>
                <li class="page-item"><a class="page-link" href="?page=1<%= queryString %>">First</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber - 1 %><%= queryString %>">← Prev</a></li>
            <% } %>
            
            <%
                long startPage = Math.max(1, pageNumber - 2);
                long endPage = Math.min(totalPages, pageNumber + 2);
                
                if (startPage > 1) {
            %>
                    <li class="page-item"><a class="page-link" href="?page=1<%= queryString %>">1</a></li>
                    <% if (startPage > 2) { %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
                    <% } %>
            <%  }
                for (long i = startPage; i <= endPage; i++) {
            %>
                    <li class="page-item <%= (i == pageNumber) ? "active" : "" %>">
                        <a class="page-link" href="?page=<%= i %><%= queryString %>"><%= i %></a>
                    </li>
            <%  }
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
            %>
                        <li class="page-item disabled"><span class="page-link">...</span></li>
            <%      } %>
                    <li class="page-item"><a class="page-link" href="?page=<%= totalPages %><%= queryString %>"><%= totalPages %></a></li>
            <%  } %>

            <% if (pageNumber < totalPages) { %>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber + 1 %><%= queryString %>">Next →</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= totalPages %><%= queryString %>">Last</a></li>
            <% } %>
        </ul>
    </nav>
    <% } %>

    <% } %>

    <div class="mt-4 d-flex gap-2">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-rt-primary">
            <i class="bi bi-bag me-2"></i>Continue Shopping
        </a>
        <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary">
            <i class="bi bi-person me-2"></i>Back to Profile
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
