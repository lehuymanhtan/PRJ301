<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.UserAddress, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User currentUser = (User) session.getAttribute("user");
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    String success = request.getParameter("success");
    String error   = request.getParameter("error");
    Boolean fromCheckout = (Boolean) request.getAttribute("fromCheckout");
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
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
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
        <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Profile
        </a>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h3 fw-bold mb-0"><i class="bi bi-geo-alt me-2"></i>My Shipping Addresses</h1>
            <p class="text-muted small">Manage your delivery locations</p>
        </div>
        <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn-success">
            <i class="bi bi-plus-circle me-2"></i>Add New Address
        </a>
    </div>

    <!-- Messages -->
    <% if (fromCheckout != null && fromCheckout) { %>
        <div class="alert alert-info auto-dismiss"><i class="bi bi-info-circle me-2"></i><strong>Address Required:</strong> Add an address to complete your checkout.</div>
    <% } %>
    <% if (success != null) { %>
        <div class="alert alert-success auto-dismiss">
            <i class="bi bi-check-circle me-2"></i>
            <% if ("added".equals(success)) { %>Address added successfully!
            <% } else if ("updated".equals(success)) { %>Address updated successfully!
            <% } else if ("deleted".equals(success)) { %>Address deleted successfully!
            <% } else if ("defaultSet".equals(success)) { %>Default address updated!
            <% } %>
        </div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger auto-dismiss">
            <i class="bi bi-exclamation-circle me-2"></i>
            <% if ("notfound".equals(error)) { %>Address not found or unauthorized access!
            <% } else { %>An error occurred while processing your request!
            <% } %>
        </div>
    <% } %>

    <!-- Addresses -->
    <% if (addresses == null || addresses.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="bi bi-house-door" style="font-size:4rem; color:#cbd5e1"></i>
            <h3 class="mt-3 text-muted">No Shipping Addresses Yet</h3>
            <p class="text-muted">Add your first delivery address to start shopping.</p>
            <a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn-success btn-lg">
                <i class="bi bi-plus-circle me-2"></i>Add Your First Address
            </a>
        </div>
    <% } else { %>
        <div class="row g-3">
            <% for (UserAddress addr : addresses) { %>
            <div class="col-md-6">
                <div class="card shadow-sm h-100 <%= addr.isDefault() ? "border-success" : "" %>">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <h6 class="fw-bold mb-0"><%= addr.getFullName() %></h6>
                                <small class="text-muted"><i class="bi bi-telephone me-1"></i><%= addr.getPhone() %></small>
                            </div>
                            <% if (addr.isDefault()) { %>
                                <span class="badge bg-success">Default</span>
                            <% } %>
                        </div>
                        <p class="text-muted small mb-3">
                            <i class="bi bi-geo-alt me-1"></i><%= addr.getFormattedAddress() %>
                        </p>
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${pageContext.request.contextPath}/users/addresses?action=edit&id=<%= addr.getId() %>"
                               class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-pencil me-1"></i>Edit
                            </a>
                            <% if (!addr.isDefault()) { %>
                                <a href="${pageContext.request.contextPath}/users/addresses?action=setDefault&id=<%= addr.getId() %>"
                                   class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-star me-1"></i>Set Default
                                </a>
                                <a href="${pageContext.request.contextPath}/users/addresses?action=delete&id=<%= addr.getId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Delete this address?')">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </a>
                            <% } else { %>
                                <span class="btn btn-sm btn-outline-secondary disabled">
                                    <i class="bi bi-lock me-1"></i>Protected
                                </span>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>

    <div class="mt-4 d-flex gap-2">
        <% if (fromCheckout != null && fromCheckout) { %>
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-rt-primary">
                <i class="bi bi-bag-check me-2"></i>Continue Checkout
            </a>
        <% } %>
        <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary">
            <i class="bi bi-person me-2"></i>Back to Profile
        </a>
    </div>
</div>

<footer class="bg-navy text-white mt-5 py-4">
    <div class="container text-center">
        <p class="mb-1 fw-semibold">Ruby Tech</p>
        <p class="mb-0 small text-white-50">&copy; <%= java.time.Year.now().getValue() %> Ruby Tech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
