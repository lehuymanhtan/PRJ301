<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">
<%
    User profileUser = (User) request.getAttribute("profileUser");
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Edit Header -->
        <div class="edit-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                ✏️ Edit Profile
            </h1>
            <p class="text-secondary">
                Update your account information
            </p>
        </div>

        <!-- Error Message -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="message message--error mb-lg">
                ❌ <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Edit Form Card -->
        <div class="surface-card edit-form-card">
            <form method="post" action="${pageContext.request.contextPath}/users">
                <input type="hidden" name="action" value="edit">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="username" class="form-label">Username *</label>
                        <input type="text" id="username" name="username" required
                               class="form-input"
                               value="<%= profileUser != null ? profileUser.getUsername() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Password *</label>
                        <input type="password" id="password" name="password" required
                               class="form-input"
                               value="<%= profileUser != null ? profileUser.getPassword() : "" %>">
                    </div>

                    <div class="form-group-full">
                        <label for="name" class="form-label">Full Name *</label>
                        <input type="text" id="name" name="name" required
                               class="form-input"
                               value="<%= profileUser != null && profileUser.getName() != null ? profileUser.getName() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="gender" class="form-label">Gender *</label>
                        <select id="gender" name="gender" required class="form-select">
                            <option value="">-- Select Gender --</option>
                            <option value="male"   <%= profileUser != null && "male".equals(profileUser.getGender())   ? "selected" : "" %>>👨 Male</option>
                            <option value="female" <%= profileUser != null && "female".equals(profileUser.getGender()) ? "selected" : "" %>>👩 Female</option>
                            <option value="other"  <%= profileUser != null && "other".equals(profileUser.getGender())  ? "selected" : "" %>>🏳️ Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dateOfBirth" class="form-label">Date of Birth *</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" required
                               class="form-input"
                               value="<%= profileUser != null && profileUser.getDateOfBirth() != null ? profileUser.getDateOfBirth().toString() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text" id="phone" name="phone"
                               class="form-input"
                               placeholder="Enter your phone number"
                               value="<%= profileUser != null && profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email *</label>
                        <input type="email" id="email" name="email" required
                               class="form-input"
                               value="<%= profileUser != null ? profileUser.getEmail() : "" %>">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn--primary btn--lg">
                            💾 Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/users" class="btn btn--secondary btn--lg">
                            ❌ Cancel
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>
</body>
</html>
