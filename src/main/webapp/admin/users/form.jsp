<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        User editUser = (User) request.getAttribute("user");
        boolean isEdit = (editUser != null);
    %>
    <title><%= isEdit ? "Edit User" : "Add User" %> - Ruby Tech Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
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

<div class="container py-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Users
        </a>
    </div>
    <h1 class="h3 fw-bold mb-4"><i class="bi bi-person me-2"></i><%= isEdit ? "Edit User" : "Create User" %></h1>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-person me-2"></i>Account Details</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/users">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                        <% if (isEdit) { %><input type="hidden" name="userId" value="<%= editUser.getUserId() %>"><% } %>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                                <input type="text" id="username" name="username" class="form-control" required value="<%= isEdit ? editUser.getUsername() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                                <input type="password" id="password" name="password" class="form-control" required value="<%= isEdit ? editUser.getPassword() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="role" class="form-label fw-semibold">Role <span class="text-danger">*</span></label>
                                <select id="role" name="role" class="form-select" required>
                                    <option value="user" <%= isEdit && "user".equals(editUser.getRole()) ? "selected" : "" %>>User</option>
                                    <option value="admin" <%= isEdit && "admin".equals(editUser.getRole()) ? "selected" : "" %>>Admin</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="name" class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                <input type="text" id="name" name="name" class="form-control" required value="<%= isEdit ? editUser.getName() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="gender" class="form-label fw-semibold">Gender <span class="text-danger">*</span></label>
                                <select id="gender" name="gender" class="form-select" required>
                                    <option value="" disabled <%= !isEdit ? "selected" : "" %>>-- Select --</option>
                                    <option value="male" <%= isEdit && "male".equals(editUser.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="female" <%= isEdit && "female".equals(editUser.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="other" <%= isEdit && "other".equals(editUser.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="dateOfBirth" class="form-label fw-semibold">Date of Birth <span class="text-danger">*</span></label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" required
                                       value="<%= isEdit && editUser.getDateOfBirth() != null ? editUser.getDateOfBirth().toString() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                                <input type="email" id="email" name="email" class="form-control" required value="<%= isEdit ? editUser.getEmail() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-semibold">Phone</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="<%= isEdit && editUser.getPhone() != null ? editUser.getPhone() : "" %>">
                            </div>
                        </div>
                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn btn-rt-primary"><i class="bi bi-floppy me-2"></i><%= isEdit ? "Update User" : "Create User" %></button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary"><i class="bi bi-x me-1"></i>Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <% if (isEdit) { %>
        <div class="col-lg-5">
            <div class="card shadow-sm mb-3">
                <div class="card-header bg-navy text-white fw-bold"><i class="bi bi-gem me-2"></i>Loyalty Controls</div>
                <div class="card-body">
                    <p class="small text-muted mb-3">
                        Points: <strong class="text-orange"><%= String.format("%,d", editUser.getPoints()) %></strong> |
                        Tier: <span class="badge bg-info"><%= editUser.getMembershipTier() %></span>
                    </p>
                    <form method="post" action="${pageContext.request.contextPath}/admin/loyalty" class="mb-3">
                        <input type="hidden" name="action" value="adjustPoints">
                        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                        <label for="points" class="form-label fw-semibold small">Points Delta</label>
                        <div class="input-group">
                            <input type="number" id="points" name="points" class="form-control form-control-sm" required placeholder="e.g. 100 or -50">
                            <button type="submit" class="btn btn-sm btn-warning">Save Points</button>
                        </div>
                        <div class="form-text">Positive to add, negative to deduct.</div>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/loyalty">
                        <input type="hidden" name="action" value="changeTier">
                        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                        <label for="tier" class="form-label fw-semibold small">Change Tier</label>
                        <div class="input-group">
                            <select id="tier" name="tier" class="form-select form-select-sm">
                                <option value="Regular" <%= "Regular".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Regular</option>
                                <option value="Bronze" <%= "Bronze".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Bronze</option>
                                <option value="Silver" <%= "Silver".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Silver</option>
                                <option value="Gold" <%= "Gold".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Gold</option>
                                <option value="Platinum" <%= "Platinum".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Platinum</option>
                                <option value="Diamond" <%= "Diamond".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Diamond</option>
                            </select>
                            <button type="submit" class="btn btn-sm btn-info">Save Tier</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
