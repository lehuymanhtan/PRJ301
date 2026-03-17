<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, models.User, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${i18n.get('address.adminTitle')}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .user-info { background: #e3f2fd; border: 1px solid #90caf9; border-radius: 4px; padding: 10px 14px; max-width: 600px; margin-bottom: 16px; }
        .addr-card { border: 1px solid #ccc; border-radius: 6px; padding: 14px 16px; max-width: 600px; margin-bottom: 14px; background: #fafafa; }
        .addr-card.default-card { border-color: #2196f3; background: #e3f2fd; }
        .badge-default { display: inline-block; font-size: 11px; font-weight: bold; background: #2196f3; color: white; padding: 2px 8px; border-radius: 10px; margin-left: 8px; vertical-align: middle; }
        .addr-name   { font-weight: bold; font-size: 15px; margin-bottom: 4px; }
        .addr-detail { color: #555; font-size: 14px; margin-bottom: 2px; }
        .addr-actions { margin-top: 10px; display: flex; gap: 10px; }
        .msg-success { color: green; margin-bottom: 10px; padding: 8px 12px; background: #e8f5e9; border-left: 4px solid #4caf50; }
        .msg-error   { color: red;   margin-bottom: 10px; padding: 8px 12px; background: #ffebee; border-left: 4px solid #f44336; }
        .btn { display: inline-block; padding: 5px 14px; border-radius: 3px; text-decoration: none; font-size: 13px; border: 1px solid #999; cursor: pointer; }
        .btn-edit { background: #2196f3; color: white; border-color: #2196f3; }
        .btn-def  { background: #ff9800; color: white; border-color: #ff9800; }
        .empty-note { color: #777; font-style: italic; }
    </style>
</head>
<body>
<%
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    User targetUser = (User) request.getAttribute("targetUser");
    String lang     = (String) request.getAttribute("lang");
    String success  = request.getParameter("success");
    String errorMsg = request.getParameter("error");
    if (lang == null) lang = "vi";
    int uid = targetUser != null ? targetUser.getUserId() : 0;
%>

<h1>${i18n.get('address.adminTitle')}</h1>
<nav>
    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
    <a href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('admin.dashboard')}</a> |
    <a href="${pageContext.request.contextPath}/admin/users">${i18n.get('admin.userManagement')}</a> |
    <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
</nav>

<% if (targetUser != null) { %>
<div class="user-info">
    <strong>${i18n.get('profile.userId')}:</strong> <%= targetUser.getUserId() %> &nbsp;|&nbsp;
    <strong>${i18n.get('profile.username')}:</strong> <%= targetUser.getUsername() %> &nbsp;|&nbsp;
    <strong>${i18n.get('profile.fullName')}:</strong> <%= targetUser.getName() != null ? targetUser.getName() : "-" %>
</div>
<% } %>

<% if ("updated".equals(success))    { %><div class="msg-success">${i18n.get('address.updated')}</div><% } %>
<% if ("defaultSet".equals(success)) { %><div class="msg-success">${i18n.get('address.defaultSet')}</div><% } %>
<% if ("notfound".equals(errorMsg))  { %><div class="msg-error">${i18n.get('address.notFound')}</div><% } %>

<% if (addresses == null || addresses.isEmpty()) { %>
    <p class="empty-note">${i18n.get('address.noAddresses')}</p>
<% } else {
    for (UserAddress addr : addresses) {
        String provinceName = addr.getProvince() != null ? addr.getProvince().getLocalizedName(lang) : "";
%>
    <div class="addr-card <%= addr.isDefault() ? "default-card" : "" %>">
        <div class="addr-name">
            <%= addr.getFullName() %>
            <% if (addr.isDefault()) { %><span class="badge-default">${i18n.get('address.default')}</span><% } %>
        </div>
        <div class="addr-detail">📞 <%= addr.getPhone() %></div>
        <div class="addr-detail">
            📍 <%= addr.getAddressDetail() %>, <%= addr.getWard() %>, <%= addr.getDistrict() %>, <%= provinceName %>
        </div>
        <div class="addr-actions">
            <a href="${pageContext.request.contextPath}/admin/addresses?action=edit&id=<%= addr.getId() %>&userId=<%= uid %>" class="btn btn-edit">${i18n.get('action.edit')}</a>
            <% if (!addr.isDefault()) { %>
            <a href="${pageContext.request.contextPath}/admin/addresses?action=setDefault&id=<%= addr.getId() %>&userId=<%= uid %>" class="btn btn-def">${i18n.get('address.setDefault')}</a>
            <% } %>
        </div>
    </div>
<% } } %>

</body>
</html>
