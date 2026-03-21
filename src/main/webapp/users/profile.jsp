<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- Page-specific styles -->
    </head>
<body class="bg-surface-secondary">

<%
    User profileUser = (User) request.getAttribute("profileUser");
    String success   = request.getParameter("success");

    // Tier thresholds
    int[] thresholds = {0, 10000, 20000, 50000, 100000, 200000};
    String[] tiers   = {"Regular", "Bronze", "Silver", "Gold", "Platinum", "Diamond"};
    int pts = profileUser.getPoints();
    String tier = profileUser.getMembershipTier();

    int nextThreshold = -1;
    int prevThreshold = 0;
    String nextTier   = "";
    for (int i = 0; i < tiers.length - 1; i++) {
        if (tier.equals(tiers[i])) {
            prevThreshold = thresholds[i];
            nextThreshold = thresholds[i + 1];
            nextTier      = tiers[i + 1];
            break;
        }
    }
    double pct = 100.0;
    if (nextThreshold > 0) {
        pct = Math.min(100.0, (pts - prevThreshold) * 100.0 / (nextThreshold - prevThreshold));
    }
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                Welcome back, <%= profileUser.getName() %>!
            </h1>
            <p class="text-secondary">
                Manage your account and track your loyalty progress
            </p>
        </div>

        <!-- Success Message -->
        <% if ("updated".equals(success)) { %>
            <div class="message message--success mb-lg">
                ✅ Profile updated successfully!
            </div>
        <% } %>

        <!-- Navigation -->
        <nav class="profile-nav">
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/products">Products</a>
            <a href="${pageContext.request.contextPath}/cart">Cart</a>
            <a href="${pageContext.request.contextPath}/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/users" class="active">Profile</a>
            <a href="${pageContext.request.contextPath}/users/addresses">Addresses</a>
            <a href="${pageContext.request.contextPath}/points">Point History</a>
            <% if ("admin".equalsIgnoreCase(profileUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>

        <!-- Profile Grid -->
        <div class="profile-grid">
            <!-- User Information Card -->
            <div class="surface-card">
                <h2 class="text-xl font-semibold mb-lg">Account Information</h2>

                <div class="profile-info">
                    <div class="info-item">
                        <span class="info-label">User ID</span>
                        <span class="info-value">#<%= profileUser.getUserId() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Username</span>
                        <span class="info-value">@<%= profileUser.getUsername() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Account Type</span>
                        <span class="info-value">
                            <span class="badge badge--processing">
                                <%= profileUser.getRole().substring(0,1).toUpperCase() + profileUser.getRole().substring(1) %>
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Full Name</span>
                        <span class="info-value"><%= profileUser.getName() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Gender</span>
                        <span class="info-value">
                            <%= profileUser.getGender().substring(0,1).toUpperCase() + profileUser.getGender().substring(1) %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Date of Birth</span>
                        <span class="info-value"><%= profileUser.getDateOfBirth() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Phone</span>
                        <span class="info-value">
                            <%= profileUser.getPhone() != null ? profileUser.getPhone() : "Not provided" %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value"><%= profileUser.getEmail() %></span>
                    </div>
                </div>

                <!-- Profile Actions -->
                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/users?action=edit" class="btn btn--primary btn--md">
                        ✏️ Edit Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/users?action=delete"
                       class="btn btn--error btn--md"
                       onclick="return confirm('⚠️ Delete your account? This action cannot be undone.')">
                        🗑️ Delete Account
                    </a>
                </div>
            </div>

            <!-- Loyalty System Card -->
            <div class="surface-card">
                <h2 class="text-xl font-semibold mb-lg">Loyalty Program</h2>

                <!-- Current Tier Badge -->
                <div class="text-center mb-lg">
                    <div class="tier-badge tier-badge--<%= tier.toLowerCase() %> mb-md">
                        <%= tier %> Member
                    </div>
                </div>

                <!-- Loyalty Statistics -->
                <div class="loyalty-stats">
                    <div class="loyalty-stat">
                        <span class="loyalty-stat-value"><%= String.format("%,d", pts) %></span>
                        <span class="loyalty-stat-label">Total Points</span>
                    </div>
                    <div class="loyalty-stat">
                        <span class="loyalty-stat-value">
                            <%
                                // Calculate tier level (0-5)
                                int tierLevel = 0;
                                for (int i = 0; i < tiers.length; i++) {
                                    if (tier.equals(tiers[i])) {
                                        tierLevel = i;
                                        break;
                                    }
                                }
                            %>
                            <%= tierLevel %>/5
                        </span>
                        <span class="loyalty-stat-label">Tier Level</span>
                    </div>
                    <div class="loyalty-stat">
                        <span class="loyalty-stat-value">
                            <% if (nextThreshold > 0) { %>
                                <%= String.format("%,d", nextThreshold - pts) %>
                            <% } else { %>
                                ∞
                            <% } %>
                        </span>
                        <span class="loyalty-stat-label">Points to Next</span>
                    </div>
                </div>

                <!-- Progress to Next Tier -->
                <% if (nextThreshold > 0) { %>
                    <div class="tier-progress">
                        <div class="tier-progress-label">
                            <span class="font-medium">Progress to <%= nextTier %></span>
                            <span class="tier-next">
                                <%= String.format("%,d", nextThreshold - pts) %> points needed
                            </span>
                        </div>
                        <div class="loyalty-progress">
                               <div class="loyalty-progress-fill"
                                   data-width="<%= String.format("%.1f", pct) %>%">
                            </div>
                            <div class="loyalty-progress-text">
                                <%= String.format("%.0f", pct) %>%
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="max-tier-message">
                        🏆 Congratulations! You've reached the highest tier!
                    </div>
                <% } %>

                <!-- Loyalty Actions -->
                <div class="mt-lg">
                    <a href="${pageContext.request.contextPath}/points" class="btn btn--success btn--lg w-full">
                        💎 View Point History
                    </a>
                </div>

                <!-- Tier Benefits Info -->
                <div class="mt-lg p-4 bg-surface-secondary rounded-lg">
                    <h4 class="text-sm font-semibold text-secondary mb-2">Current Tier Benefits:</h4>
                    <ul class="text-xs text-tertiary">
                        <li>• Earn 1 point per 1,000 VND spent</li>
                        <li>• Redeem points: 1 point = 1 VND discount</li>
                        <% if (tierLevel >= 1) { %><li>• Priority customer support</li><% } %>
                        <% if (tierLevel >= 2) { %><li>• Exclusive member offers</li><% } %>
                        <% if (tierLevel >= 3) { %><li>• Free shipping on all orders</li><% } %>
                        <% if (tierLevel >= 4) { %><li>• Early access to new products</li><% } %>
                        <% if (tierLevel >= 5) { %><li>• Personal shopping assistant</li><% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate progress bar
            const progressFill = document.querySelector('.loyalty-progress-fill');
            if (progressFill) {
                const targetWidth = progressFill.dataset.width;
                progressFill.style.width = '0%';

                setTimeout(() => {
                    progressFill.style.width = targetWidth;
                }, 500);
            }

            // Animate loyalty stats
            const statValues = document.querySelectorAll('.loyalty-stat-value');
            statValues.forEach((stat, index) => {
                stat.style.opacity = '0';
                stat.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    stat.style.transition = 'all 0.6s ease';
                    stat.style.opacity = '1';
                    stat.style.transform = 'translateY(0)';
                }, index * 200 + 300);
            });

            // Add hover effects to info items
            const infoItems = document.querySelectorAll('.info-item');
            infoItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.style.backgroundColor = 'var(--surface-tertiary)';
                    this.style.transform = 'translateX(4px)';
                });

                item.addEventListener('mouseleave', function() {
                    this.style.backgroundColor = 'transparent';
                    this.style.transform = 'translateX(0)';
                });
            });
        });
    </script>

</body>
</html>
