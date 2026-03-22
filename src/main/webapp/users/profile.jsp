<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    User profileUser = (User) request.getAttribute("profileUser");
    String success   = request.getParameter("success");

    int[] thresholds = {0, 10000, 20000, 50000, 100000, 200000};
    String[] tiers   = {"Regular", "Bronze", "Silver", "Gold", "Platinum", "Diamond"};
    int pts = profileUser.getPoints();
    String tier = profileUser.getMembershipTier();

    int nextThreshold = -1;
    int prevThreshold = 0;
    String nextTier   = "";
    int tierLevel = 0;
    for (int i = 0; i < tiers.length; i++) {
        if (tier.equals(tiers[i])) {
            tierLevel = i;
            if (i < tiers.length - 1) {
                prevThreshold = thresholds[i];
                nextThreshold = thresholds[i + 1];
                nextTier      = tiers[i + 1];
            }
            break;
        }
    }
    double pct = 100.0;
    if (nextThreshold > 0) {
        pct = Math.min(100.0, (pts - prevThreshold) * 100.0 / (nextThreshold - prevThreshold));
    }
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

<div class="container py-4">
    <h1 class="h3 fw-bold mb-1"><i class="bi bi-person-circle me-2"></i>Welcome back, <%= profileUser.getName() %>!</h1>
    <p class="text-muted mb-4">Manage your account and track your loyalty progress</p>

    <% if ("updated".equals(success)) { %>
        <div class="alert alert-success auto-dismiss"><i class="bi bi-check-circle me-2"></i>Profile updated successfully!</div>
    <% } %>

    <div class="row g-4">
        <!-- Account Info -->
        <div class="col-lg-6">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-person me-2"></i>Account Information</div>
                <div class="card-body">
                    <dl class="row">
                        <dt class="col-5 text-muted">User ID:</dt><dd class="col-7 fw-semibold">#<%= profileUser.getUserId() %></dd>
                        <dt class="col-5 text-muted">Username:</dt><dd class="col-7">@<%= profileUser.getUsername() %></dd>
                        <dt class="col-5 text-muted">Account Type:</dt>
                        <dd class="col-7"><span class="badge bg-info"><%= profileUser.getRole().substring(0,1).toUpperCase() + profileUser.getRole().substring(1) %></span></dd>
                        <dt class="col-5 text-muted">Full Name:</dt><dd class="col-7"><%= profileUser.getName() %></dd>
                        <dt class="col-5 text-muted">Gender:</dt><dd class="col-7"><%= profileUser.getGender().substring(0,1).toUpperCase() + profileUser.getGender().substring(1) %></dd>
                        <dt class="col-5 text-muted">Date of Birth:</dt><dd class="col-7"><%= profileUser.getDateOfBirth() %></dd>
                        <dt class="col-5 text-muted">Phone:</dt><dd class="col-7"><%= profileUser.getPhone() != null ? profileUser.getPhone() : "Not provided" %></dd>
                        <dt class="col-5 text-muted">Email:</dt><dd class="col-7"><%= profileUser.getEmail() %></dd>
                    </dl>
                    <div class="d-flex gap-2 mt-2">
                        <a href="${pageContext.request.contextPath}/users?action=edit" class="btn btn-rt-primary btn-sm">
                            <i class="bi bi-pencil me-1"></i>Edit Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/users?action=delete"
                           class="btn btn-outline-danger btn-sm"
                           onclick="return confirm('Delete your account? This cannot be undone.')">
                            <i class="bi bi-trash me-1"></i>Delete Account
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loyalty Program -->
        <div class="col-lg-6">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-gem me-2"></i>Loyalty Program</div>
                <div class="card-body text-center">
                    <div class="mb-3">
                        <span class="badge fs-6 px-3 py-2
                            <% if ("Diamond".equals(tier)) { %>bg-info
                            <% } else if ("Platinum".equals(tier)) { %>text-bg-secondary" style="background:#e5e4e2!important
                            <% } else if ("Gold".equals(tier)) { %>text-bg-warning
                            <% } else if ("Silver".equals(tier)) { %>bg-secondary
                            <% } else if ("Bronze".equals(tier)) { %>text-bg-warning" style="background:#cd7f32!important
                            <% } else { %>bg-secondary
                            <% } %>">
                            <i class="bi bi-award me-1"></i><%= tier %> Member
                        </span>
                    </div>
                    <div class="row text-center mb-3">
                        <div class="col-4">
                            <div class="fw-bold fs-4 text-orange"><%= String.format("%,d", pts) %></div>
                            <small class="text-muted">Total Points</small>
                        </div>
                        <div class="col-4">
                            <div class="fw-bold fs-4"><%= tierLevel %>/5</div>
                            <small class="text-muted">Tier Level</small>
                        </div>
                        <div class="col-4">
                            <div class="fw-bold fs-4">
                                <% if (nextThreshold > 0) { %><%= String.format("%,d", nextThreshold - pts) %><% } else { %>∞<% } %>
                            </div>
                            <small class="text-muted">Points to Next</small>
                        </div>
                    </div>

                    <% if (nextThreshold > 0) { %>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between small text-muted mb-1">
                            <span>Progress to <%= nextTier %></span>
                            <span><%= String.format("%.0f", pct) %>%</span>
                        </div>
                        <div class="progress" style="height:10px">
                            <div class="progress-bar bg-warning" role="progressbar"
                                 style="width:<%= String.format("%.1f", pct) %>%"></div>
                        </div>
                        <div class="small text-muted mt-1"><%= String.format("%,d", nextThreshold - pts) %> points needed</div>
                    </div>
                    <% } else { %>
                    <div class="alert alert-success small mb-3">
                        <i class="bi bi-trophy me-2"></i>Congratulations! You've reached the highest tier!
                    </div>
                    <% } %>

                    <a href="${pageContext.request.contextPath}/points" class="btn btn-rt-primary w-100 mb-3">
                        <i class="bi bi-gem me-2"></i>View Point History
                    </a>

                    <ul class="list-unstyled text-start small text-muted mb-0">
                        <li><i class="bi bi-check text-success me-1"></i>Earn 1 point per 1,000 VND spent</li>
                        <li><i class="bi bi-check text-success me-1"></i>Redeem: 1 point = 1 VND discount</li>
                        <% if (tierLevel >= 1) { %><li><i class="bi bi-check text-success me-1"></i>Priority customer support</li><% } %>
                        <% if (tierLevel >= 2) { %><li><i class="bi bi-check text-success me-1"></i>Exclusive member offers</li><% } %>
                        <% if (tierLevel >= 3) { %><li><i class="bi bi-check text-success me-1"></i>Free shipping on all orders</li><% } %>
                        <% if (tierLevel >= 4) { %><li><i class="bi bi-check text-success me-1"></i>Early access to new products</li><% } %>
                        <% if (tierLevel >= 5) { %><li><i class="bi bi-check text-success me-1"></i>Personal shopping assistant</li><% } %>
                    </ul>
                </div>
            </div>
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
