<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund Management - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">

<%
    User currentUser = (User) session.getAttribute("user");
    List<RefundRequest> refunds = (List<RefundRequest>) request.getAttribute("refunds");
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
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
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-arrow-counterclockwise me-2"></i>Refund Management</h1>
    <p class="text-muted mb-4">Review and process customer refund requests</p>

    <!-- Refunds Table -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Refund ID</th>
                            <th>Order</th>
                            <th>Customer</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Submitted</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (refunds != null && !refunds.isEmpty()) {
                           for (RefundRequest r : refunds) {
                       %>
                        <tr>
                            <td>
                                <span class="fw-semibold text-primary">#<%= r.getId() %></span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= r.getOrderId() %>"
                                   class="text-decoration-none fw-semibold">#<%= r.getOrderId() %></a>
                            </td>
                            <td>
                                <div class="text-muted small">User ID: <%= r.getUserId() %></div>
                            </td>
                            <td>
                                <div class="text-truncate" style="max-width: 250px;" title="<%= r.getReason() != null ? r.getReason().replace("\"", "&quot;") : "" %>">
                                    <%= r.getReason() != null && !r.getReason().isEmpty() ? r.getReason() : "<span class='text-muted fst-italic'>No reason provided</span>" %>
                                </div>
                            </td>
                            <td>
                                <%
                                    String status = r.getStatus();
                                    String badgeClass = "bg-secondary";
                                    String iconClass = "bi-journal-text";
                                    
                                    if ("Pending".equals(status)) { badgeClass = "bg-warning text-dark"; iconClass = "bi-hourglass-split"; }
                                    else if ("WaitForReturn".equals(status)) { badgeClass = "bg-info text-dark"; iconClass = "bi-box-seam"; }
                                    else if ("Verifying".equals(status)) { badgeClass = "bg-primary"; iconClass = "bi-search"; }
                                    else if ("Done".equals(status)) { badgeClass = "bg-success"; iconClass = "bi-check-circle"; }
                                    else if ("Rejected".equals(status)) { badgeClass = "bg-danger"; iconClass = "bi-x-circle"; }
                                    else if ("Cancelled".equals(status)) { badgeClass = "bg-dark"; iconClass = "bi-slash-circle"; }
                                %>
                                <span class="badge <%= badgeClass %>">
                                    <i class="bi <%= iconClass %> me-1"></i><%= status %>
                                </span>
                            </td>
                            <td>
                                <span class="text-muted small">
                                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toLocalDate().toString() : "-" %>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/refunds?action=detail&id=<%= r.getId() %>"
                                   class="btn btn-outline-primary btn-sm" title="View Details">
                                   <i class="bi bi-eye"></i> View
                                </a>
                            </td>
                        </tr>
                    <% }
                       } else { %>
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <div class="text-muted">
                                    <i class="bi bi-wallet2 fs-1 text-secondary mb-3 d-block"></i>
                                    No refund requests found.
                                    <div class="mt-2 small text-success">
                                        All customers are satisfied with their purchases! 🎉
                                    </div>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Statistics Footer -->
            <div class="card-footer bg-light border-top-0 d-flex justify-content-between align-items-center">
                <span class="text-muted small fw-semibold"><i class="bi bi-bar-chart me-1"></i>Total refund requests: <%= request.getAttribute("totalCount") != null ? String.format("%,d", request.getAttribute("totalCount")) : (refunds != null ? refunds.size() : 0) %></span>
            </div>
        </div>
    </div>

    <% 
        Long totalPages = (Long) request.getAttribute("totalPages");
        Integer pageNumber = (Integer) request.getAttribute("pageNumber");
        String queryString = "";
    %>
    <% if (totalPages != null && totalPages > 1) { %>
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
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

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
