<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Long totalPages  = (Long)    request.getAttribute("totalPages");
    Integer pageNumber = (Integer) request.getAttribute("pageNumber");
    Long totalCount  = (Long)    request.getAttribute("totalCount");
%>

<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo">Ruby Tech Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="nav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid py-4 px-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-bag-check me-2"></i>Order Management</h1>
    <p class="text-muted mb-3">Monitor and manage customer orders
        <% if (totalCount != null) { %><span class="badge bg-secondary ms-2"><%= String.format("%,d", totalCount) %> total</span><% } %>
    </p>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table admin-table table-hover mb-0">
                <thead><tr><th>Order ID</th><th>Customer</th><th>Total</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                    <% if (orders == null || orders.isEmpty()) { %>
                        <tr><td colspan="5" class="text-center py-4 text-muted"><i class="bi bi-bag me-2"></i>No orders found. <a href="${pageContext.request.contextPath}/">Visit the store</a></td></tr>
                    <% } else { for (Order o : orders) {
                        String sc; switch(o.getStatus().toLowerCase()) {
                            case "completed": case "delivered": sc="bg-success"; break;
                            case "pending": sc="bg-warning text-dark"; break;
                            case "processing": sc="bg-info"; break;
                            case "shipped": sc="bg-primary"; break;
                            case "cancelled": sc="bg-danger"; break;
                            default: sc="bg-secondary"; break;
                        }
                    %>
                    <tr>
                        <td><span class="fw-semibold text-orange">#<%= o.getId() %></span></td>
                        <td><small class="text-muted">User #<%= o.getUserId() %></small></td>
                        <td class="fw-semibold text-orange"><%= String.format("%,.0f", o.getTotalPrice()) %> ₫</td>
                        <td><span class="badge <%= sc %>"><%= o.getStatus() %></span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= o.getId() %>" class="btn btn-sm btn-outline-info me-1"><i class="bi bi-eye me-1"></i>View</a>
                            <a href="${pageContext.request.contextPath}/admin/orders?action=edit&id=<%= o.getId() %>" class="btn btn-sm btn-outline-warning me-1"><i class="bi bi-pencil me-1"></i>Edit</a>
                            <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/orders"
                                  onsubmit="return confirm('Delete order #<%= o.getId() %>?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= o.getId() %>">
                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash me-1"></i>Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <% if (totalPages != null && totalPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <% if (pageNumber > 1) { %>
                <li class="page-item"><a class="page-link" href="?page=1">First</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber - 1 %>">← Prev</a></li>
            <% } %>
            <li class="page-item disabled"><span class="page-link">Page <%= pageNumber %> of <%= totalPages %></span></li>
            <% if (pageNumber < totalPages) { %>
                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber + 1 %>">Next →</a></li>
                <li class="page-item"><a class="page-link" href="?page=<%= totalPages %>">Last</a></li>
            <% } %>
        </ul>
    </nav>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
