<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User profileUser = (User) request.getAttribute("profileUser");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Products</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="categoriesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Categories
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="categoriesDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products">All Products</a></li>
                        <% 
                            java.util.List<models.Category> navCategories = (java.util.List<models.Category>) request.getAttribute("categories");
                            if (navCategories != null) { 
                                for (models.Category c : navCategories) { 
                        %>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/category?id=<%= c.getId() %>"><%= c.getName() %></a></li>
                        <% } } %>
                    </ul>
                </li>
            </ul>
            <form class="d-flex mx-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search product..." aria-label="Search" value="${not empty keyword ? keyword : ''}">
                <button class="btn btn-outline-light" type="submit"><i class="bi bi-search"></i></button>
            </form>
            <ul class="navbar-nav">
                <% 
                    models.User navUser = (models.User) session.getAttribute("user");
                    if (navUser != null) { 
                %>
                    <% if ("admin".equalsIgnoreCase(navUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart" title="Cart">
                            <i class="bi bi-cart3 fs-5"></i>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white opacity-75 active" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <%= navUser.getName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users">Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">Orders</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/points">Point History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Register</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4" style="max-width:680px">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Profile
        </a>
    </div>
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-pencil me-2"></i>Edit Profile</h1>
    <p class="text-muted mb-4">Update your account information</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/users">
                <input type="hidden" name="action" value="edit">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="username" class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                        <input type="text" id="username" name="username" required class="form-control"
                               value="<%= profileUser != null ? profileUser.getUsername() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="password" class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                        <input type="password" id="password" name="password" required class="form-control"
                               value="<%= profileUser != null ? profileUser.getPassword() : "" %>">
                    </div>
                    <div class="col-12">
                        <label for="name" class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                        <input type="text" id="name" name="name" required class="form-control"
                               value="<%= profileUser != null && profileUser.getName() != null ? profileUser.getName() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="gender" class="form-label fw-semibold">Gender <span class="text-danger">*</span></label>
                        <select id="gender" name="gender" required class="form-select">
                            <option value="">-- Select Gender --</option>
                            <option value="male"   <%= profileUser != null && "male".equals(profileUser.getGender())   ? "selected" : "" %>>Male</option>
                            <option value="female" <%= profileUser != null && "female".equals(profileUser.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="other"  <%= profileUser != null && "other".equals(profileUser.getGender())  ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="dateOfBirth" class="form-label fw-semibold">Date of Birth <span class="text-danger">*</span></label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" required class="form-control"
                               value="<%= profileUser != null && profileUser.getDateOfBirth() != null ? profileUser.getDateOfBirth().toString() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label fw-semibold">Phone</label>
                        <input type="text" id="phone" name="phone" class="form-control"
                               placeholder="Enter your phone number"
                               value="<%= profileUser != null && profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                    </div>
                    <div class="col-md-6">
                        <label for="email" class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                        <input type="email" id="email" name="email" required class="form-control"
                               value="<%= profileUser != null ? profileUser.getEmail() : "" %>">
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-rt-primary">
                        <i class="bi bi-floppy me-2"></i>Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-secondary">
                        <i class="bi bi-x me-1"></i>Cancel
                    </a>
                </div>
            </form>
        </div>
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
