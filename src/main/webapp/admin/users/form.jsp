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

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <style>
        .form-shell {
            max-width: 980px;
            margin: 0 auto;
            display: grid;
            gap: var(--space-lg);
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: var(--space-md);
        }
        .form-grid .full-span { grid-column: 1 / -1; }
        .form-actions {
            display: flex;
            gap: var(--space-3);
            justify-content: flex-end;
            margin-top: var(--space-lg);
        }
        .loyalty-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: var(--space-md);
        }
        .current-tier {
            display: inline-block;
            padding: var(--space-1) var(--space-2);
            border-radius: var(--radius-full);
            background: var(--surface-tertiary);
            color: var(--text-primary);
            font-size: var(--text-xs);
            font-weight: var(--font-weight-semibold);
        }
        @media (max-width: 768px) {
            .form-grid,
            .loyalty-grid { grid-template-columns: 1fr; }
            .form-actions { justify-content: stretch; }
            .form-actions .btn { flex: 1; }
        }
    </style>
</head>
<body class="bg-surface-secondary">
<div class="admin-layout">
    <div class="admin-header">
        <div class="dashboard-header">
            <h1 class="dashboard-title"><%= isEdit ? "Edit User" : "Create User" %></h1>
            <p class="dashboard-subtitle">Update account details and loyalty profile</p>
        </div>

        <nav class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
            <a href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/admin/refunds">Refunds</a>
            <a href="${pageContext.request.contextPath}/admin/income">Income Report</a>
            <a href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a>
            <a href="${pageContext.request.contextPath}/admin/forecast">📈 Forecast</a>
            <a href="${pageContext.request.contextPath}/">Go to Shop</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </div>

    <div class="admin-content">
        <div class="form-shell">
            <% if (request.getAttribute("error") != null) { %>
                <div class="message message--danger">
                    ❌ <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <div class="surface-card surface-card--form">
                <form method="post" action="${pageContext.request.contextPath}/admin/users">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                    <% } %>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username" class="form-label">Username <span class="required">*</span></label>
                            <input type="text" id="username" name="username" class="form-input" required
                                   value="<%= isEdit ? editUser.getUsername() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password" class="form-input" required
                                   value="<%= isEdit ? editUser.getPassword() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="role" class="form-label">Role <span class="required">*</span></label>
                            <select id="role" name="role" class="form-input" required>
                                <option value="user" <%= isEdit && "user".equals(editUser.getRole()) ? "selected" : "" %>>User</option>
                                <option value="admin" <%= isEdit && "admin".equals(editUser.getRole()) ? "selected" : "" %>>Admin</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                            <input type="text" id="name" name="name" class="form-input" required
                                   value="<%= isEdit ? editUser.getName() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="gender" class="form-label">Gender <span class="required">*</span></label>
                            <select id="gender" name="gender" class="form-input" required>
                                <option value="" disabled <%= !isEdit ? "selected" : "" %>>-- Select --</option>
                                <option value="male" <%= isEdit && "male".equals(editUser.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="female" <%= isEdit && "female".equals(editUser.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="other" <%= isEdit && "other".equals(editUser.getGender()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dateOfBirth" class="form-label">Date of Birth <span class="required">*</span></label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input" required
                                   value="<%= isEdit && editUser.getDateOfBirth() != null ? editUser.getDateOfBirth().toString() : "" %>">
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email <span class="required">*</span></label>
                            <input type="email" id="email" name="email" class="form-input" required
                                   value="<%= isEdit ? editUser.getEmail() : "" %>">
                        </div>

                        <div class="form-group full-span">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-input"
                                   value="<%= isEdit && editUser.getPhone() != null ? editUser.getPhone() : "" %>">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn--secondary btn--md">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--md"><%= isEdit ? "Update User" : "Create User" %></button>
                    </div>
                </form>
            </div>

            <% if (isEdit) { %>
                <div class="surface-card">
                    <h2 class="text-xl font-semibold text-primary mb-md">Loyalty Controls</h2>
                    <p class="text-secondary mb-lg">
                        Current points: <strong class="text-primary"><%= String.format("%,d", editUser.getPoints()) %></strong>
                        | Tier: <span class="current-tier"><%= editUser.getMembershipTier() %></span>
                    </p>

                    <div class="loyalty-grid">
                        <form method="post" action="${pageContext.request.contextPath}/admin/loyalty" class="surface-card" style="margin: 0;">
                            <input type="hidden" name="action" value="adjustPoints">
                            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                            <h3 class="text-lg font-semibold text-primary mb-md">Adjust Points</h3>
                            <div class="form-group">
                                <label for="points" class="form-label">Points Delta</label>
                                <input type="number" id="points" name="points" class="form-input" required placeholder="Example: 100 or -50">
                                <div class="text-secondary mt-2">Use positive to add points, negative to deduct points.</div>
                            </div>
                            <button type="submit" class="btn btn--warning btn--sm">Save Points</button>
                        </form>

                        <form method="post" action="${pageContext.request.contextPath}/admin/loyalty" class="surface-card" style="margin: 0;">
                            <input type="hidden" name="action" value="changeTier">
                            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                            <h3 class="text-lg font-semibold text-primary mb-md">Change Tier</h3>
                            <div class="form-group">
                                <label for="tier" class="form-label">Membership Tier</label>
                                <select id="tier" name="tier" class="form-input">
                                    <option value="Regular" <%= "Regular".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Regular</option>
                                    <option value="Bronze" <%= "Bronze".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Bronze</option>
                                    <option value="Silver" <%= "Silver".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Silver</option>
                                    <option value="Gold" <%= "Gold".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Gold</option>
                                    <option value="Platinum" <%= "Platinum".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Platinum</option>
                                    <option value="Diamond" <%= "Diamond".equals(editUser.getMembershipTier()) ? "selected" : "" %>>Diamond</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn--info btn--sm">Save Tier</button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>

