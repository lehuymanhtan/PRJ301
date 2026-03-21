<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    User currentUser  = (User)       session.getAttribute("user");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String msg = (String) session.getAttribute("cartMessage");
    if (msg != null) session.removeAttribute("cartMessage");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
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
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-box-seam me-2"></i>Order History</h1>
    <p class="text-muted mb-4">Track your orders and view purchase history</p>

    <% if (msg != null) { %>
        <div class="alert alert-warning auto-dismiss"><i class="bi bi-exclamation-triangle me-2"></i><%= msg %></div>
    <% } %>

    <% if (orders == null || orders.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-box" style="font-size:4rem; color:#cbd5e1"></i>
            <h3 class="mt-3 text-muted">No Orders Found</h3>
            <p class="text-muted">You haven't placed any orders yet.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-rt-primary btn-lg">
                <i class="bi bi-bag me-2"></i>Start Shopping
            </a>
        </div>
    <% } else { %>
        <!-- Summary Cards -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="card stat-card stat-card-blue text-center">
                    <div class="card-body">
                        <div class="stat-value"><%= orders.size() %></div>
                        <div class="stat-label">Total Orders</div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card stat-card-green text-center">
                    <div class="card-body">
                        <div class="stat-value"><%= orders.stream().filter(o -> "Completed".equalsIgnoreCase(o.getStatus()) || "Delivered".equalsIgnoreCase(o.getStatus())).count() %></div>
                        <div class="stat-label">Completed</div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card stat-card-orange text-center">
                    <div class="card-body">
                        <div class="stat-value"><%= orders.stream().filter(o -> "Pending".equalsIgnoreCase(o.getStatus()) || "Processing".equalsIgnoreCase(o.getStatus()) || "Shipped".equalsIgnoreCase(o.getStatus())).count() %></div>
                        <div class="stat-label">In Progress</div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card stat-card stat-card-purple text-center">
                    <div class="card-body">
                        <div class="stat-value" style="font-size:1.1rem">
                            <%= String.format("%,.0f", orders.stream().filter(o -> "Completed".equalsIgnoreCase(o.getStatus()) || "Delivered".equalsIgnoreCase(o.getStatus())).mapToDouble(Order::getTotalPrice).sum()) %> ₫
                        </div>
                        <div class="stat-label">Total Spent</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <table class="table admin-table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order o : orders) {
                            String statusColor;
                            switch(o.getStatus().toLowerCase()) {
                                case "completed": case "delivered": statusColor = "bg-success"; break;
                                case "pending": statusColor = "bg-warning text-dark"; break;
                                case "processing": statusColor = "bg-info"; break;
                                case "shipped": statusColor = "bg-primary"; break;
                                case "cancelled": statusColor = "bg-danger"; break;
                                case "refunded": statusColor = "bg-secondary"; break;
                                default: statusColor = "bg-secondary"; break;
                            }
                        %>
                        <tr>
                            <td><span class="fw-semibold">#<%= o.getId() %></span></td>
                            <td><span class="badge <%= statusColor %>"><%= o.getStatus() %></span></td>
                            <td class="fw-semibold text-orange"><%= String.format("%,.0f", o.getTotalPrice()) %> ₫</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/orders?action=detail&id=<%= o.getId() %>"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye me-1"></i>View Details
                                </a>
                            </td>
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

        <div class="mt-4 text-center">
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                <i class="bi bi-bag me-2"></i>Continue Shopping
            </a>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
