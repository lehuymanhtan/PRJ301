<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, models.TierStatistic, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loyalty Management - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .tier-badge-bronze { background-color: #cd7f32; color: #fff; }
        .tier-badge-silver { background-color: #c0c0c0; color: #000; }
        .tier-badge-gold { background-color: #ffd700; color: #000; }
        .tier-badge-platinum { background-color: #e5e4e2; color: #000; }
        .tier-badge-diamond { background-color: #b9f2ff; color: #000; }
    </style>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
    int pointRate    = (Integer) request.getAttribute("pointRate");
    List<TierStatistic> stats = (List<TierStatistic>) request.getAttribute("stats");
    String success = request.getParameter("success");
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-star-fill text-warning me-2"></i>Loyalty Management</h1>
    <p class="text-muted mb-4">Welcome back, <strong><%= currentUser != null ? currentUser.getUsername() : "" %></strong></p>

    <!-- Success Message -->
    <% if ("updated".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>Point rate updated successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="row g-4">
        <!-- Point Conversion Rate Section -->
        <div class="col-lg-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">
                    <h5 class="card-title fw-bold text-primary mb-3"><i class="bi bi-currency-dollar me-2"></i>Point Conversion Rate</h5>
                    <p class="text-muted mb-4">
                        Current rate: <strong class="text-primary fs-5"><%= pointRate %></strong> points per 1,000 VND spent
                    </p>

                    <form method="post" action="${pageContext.request.contextPath}/admin/loyalty">
                        <input type="hidden" name="action" value="updateRate">
                        <div class="mb-3">
                            <label for="rate" class="form-label fw-semibold">New Rate <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-hash"></i></span>
                                <input type="number"
                                       id="rate"
                                       name="rate"
                                       class="form-control form-control-lg"
                                       value="<%= pointRate %>"
                                       min="1"
                                       required
                                       placeholder="Enter points per 1,000 VND">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary mt-2">
                            <i class="bi bi-device-hdd px-1"></i> Save Rate
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Members by Tier Section -->
        <div class="col-lg-6">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-body p-4">
                    <h5 class="card-title fw-bold text-primary mb-3"><i class="bi bi-people-fill me-2"></i>Members by Tier</h5>

                    <% if (stats == null || stats.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="bi bi-person-x fs-1 text-secondary mb-3 d-block"></i>
                            <p class="text-muted mb-0">No membership data available</p>
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tier Level</th>
                                        <th class="text-end">Member Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (TierStatistic s : stats) {
                                        String tierClass = s.getTier().toLowerCase().replace(" ", "-");
                                    %>
                                        <tr>
                                            <td>
                                                <span class="badge tier-badge-<%= tierClass %> px-3 py-2 fw-semibold border">
                                                    <%= s.getTier() %>
                                                </span>
                                            </td>
                                            <td class="text-end fw-bold fs-5 text-primary">
                                                <%= String.format("%,d", s.getTotal()) %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>

                    <!-- Action Links -->
                    <div class="mt-4 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary w-100">
                            <i class="bi bi-person-gear me-2"></i>Manage User Points
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
