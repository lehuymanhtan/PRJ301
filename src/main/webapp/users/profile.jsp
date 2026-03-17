<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .profile-box { border: 1px solid #ccc; padding: 20px; max-width: 450px; border-radius: 4px; }
        .profile-box p { margin: 8px 0; }
        .label { font-weight: bold; display: inline-block; width: 120px; }
        .msg-success { color: green; margin-bottom: 10px; }
        .actions { margin-top: 15px; }
        .actions a { display: inline-block; padding: 6px 14px; margin-right: 8px;
                     text-decoration: none; border: 1px solid #999; border-radius: 3px; }
        a.btn-edit { background: #2196f3; color: white; border-color: #2196f3; }
        a.btn-del  { background: #f44336; color: white; border-color: #f44336; }
        a.btn-pts  { background: #558b2f; color: white; border-color: #558b2f; }
        .loyalty-box { border: 1px solid #c8e6c9; background: #f1f8e9; border-radius: 4px;
               padding: 14px; max-width: 450px; margin-top: 16px; }
        .loyalty-box h3 { margin-top: 0; margin-bottom: 10px; }
        .progress-bar-bg { background: #ddd; border-radius: 4px; height: 12px; margin: 6px 0 4px; }
        .progress-bar-fill { background: #43a047; height: 12px; border-radius: 4px; }
    </style>
</head>
<body>
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

<h1>My Profile</h1>
<nav>
    <a href="${pageContext.request.contextPath}/users">My Profile</a> |
    <a href="${pageContext.request.contextPath}/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/users/addresses">Shipping Addresses</a> |
    <a href="${pageContext.request.contextPath}/points">Point History</a> |
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<% if ("updated".equals(success)) { %>
    <p class="msg-success">Profile updated successfully.</p>
<% } %>

<div class="profile-box">
    <p><span class="label">User ID:</span> <%= profileUser.getUserId() %></p>
    <p><span class="label">Username:</span> <%= profileUser.getUsername() %></p>
    <p><span class="label">Role:</span> <%= profileUser.getRole() %></p>
    <p><span class="label">Full Name:</span> <%= profileUser.getName() %></p>
    <p><span class="label">Gender:</span> <%= profileUser.getGender() %></p>
    <p><span class="label">Date of Birth:</span> <%= profileUser.getDateOfBirth() %></p>
    <p><span class="label">Phone:</span> <%= profileUser.getPhone() != null ? profileUser.getPhone() : "-" %></p>
    <p><span class="label">Email:</span> <%= profileUser.getEmail() %></p>
</div>

<div class="loyalty-box">
    <h3>Loyalty</h3>
    <p><span class="label">Tier:</span> <strong><%= tier %></strong></p>
    <p><span class="label">Points:</span> <strong><%= String.format("%,d", pts) %></strong></p>
    <% if (nextThreshold > 0) { %>
    <p style="margin:4px 0;font-size:13px;color:#555;">
        <%= String.format("%,d", nextThreshold - pts) %> pts to <%= nextTier %>
    </p>
    <div class="progress-bar-bg">
        <div class="progress-bar-fill" style="width:<%= String.format("%.1f", pct) %>%;"></div>
    </div>
    <% } else { %>
    <p style="font-size:13px;color:#2e7d32;">Maximum tier reached!</p>
    <% } %>
    <p style="margin-top:10px;">
        <a href="${pageContext.request.contextPath}/points" class="btn-pts"
           style="display:inline-block;padding:5px 12px;text-decoration:none;
                  border:1px solid #558b2f;border-radius:3px;color:white;background:#558b2f;">
            View Point History
        </a>
    </p>
</div>

<div class="actions">
    <a href="${pageContext.request.contextPath}/users?action=edit" class="btn-edit">Edit Profile</a>
    <a href="${pageContext.request.contextPath}/users?action=delete"
       class="btn-del"
       onclick="return confirm('Delete your account? This cannot be undone.')">Delete Account</a>
</div>
</body>
</html>
