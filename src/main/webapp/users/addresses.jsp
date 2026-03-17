<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, java.util.List" %>
<%!private static String esc(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace("\"", "&quot;").replace("'", "&#x27;");
}%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${i18n.get('address.title')}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        .msg-success { color: green; margin-bottom: 14px; padding: 8px 12px; background: #e8f5e9; border-left: 4px solid #4caf50; }
        .msg-error   { color: red;   margin-bottom: 14px; padding: 8px 12px; background: #ffebee; border-left: 4px solid #f44336; }
        .addr-list { display: flex; flex-direction: column; gap: 14px; max-width: 640px; }
        .addr-card {
            border: 1px solid #ccc; border-radius: 6px; padding: 14px 16px;
            position: relative; background: #fafafa;
        }
        .addr-card.default-card { border-color: #2196f3; background: #e3f2fd; }
        .badge-default {
            display: inline-block; font-size: 11px; font-weight: bold;
            background: #2196f3; color: white; padding: 2px 8px;
            border-radius: 10px; margin-left: 8px; vertical-align: middle;
        }
        .addr-name { font-weight: bold; font-size: 15px; margin-bottom: 4px; }
        .addr-detail { color: #555; font-size: 14px; margin-bottom: 2px; }
        .addr-actions { margin-top: 10px; display: flex; gap: 10px; flex-wrap: wrap; }
        .btn { display: inline-block; padding: 5px 14px; border-radius: 3px; text-decoration: none; font-size: 13px; border: 1px solid #999; cursor: pointer; }
        .btn-edit   { background: #2196f3; color: white; border-color: #2196f3; }
        .btn-del    { background: #f44336; color: white; border-color: #f44336; }
        .btn-def    { background: #ff9800; color: white; border-color: #ff9800; }
        .btn-add    { background: #4caf50; color: white; border-color: #4caf50; font-size: 14px; padding: 7px 18px; }
        .empty-state { color: #777; font-style: italic; margin-bottom: 16px; }
        .checkout-notice {
            background: #fff3e0; border-left: 4px solid #ff9800; padding: 10px 14px;
            margin-bottom: 16px; font-size: 14px;
        }
    </style>
</head>
<body>
<%
    @SuppressWarnings("unchecked")
    List<UserAddress> addresses = (List<UserAddress>) request.getAttribute("addresses");
    String lang     = (String) request.getAttribute("lang");
    String success  = request.getParameter("success");
    String errorMsg = request.getParameter("error");
    boolean noAddress = "1".equals(request.getParameter("noAddress"));
    if (lang == null) lang = "vi";
%>

<h1>${i18n.get('address.title')}</h1>
<nav>
    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
    <a href="${pageContext.request.contextPath}/users">${i18n.get('nav.myProfile')}</a> |
    <a href="${pageContext.request.contextPath}/orders">${i18n.get('nav.myOrders')}</a> |
    <a href="${pageContext.request.contextPath}/products">${i18n.get('nav.products')}</a> |
    <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
</nav>

<% if (noAddress) { %>
<div class="checkout-notice">${i18n.get('address.noAddressForCheckout')}</div>
<% } %>

<% if ("added".equals(success))      { %><div class="msg-success">${i18n.get('address.added')}</div><% } %>
<% if ("updated".equals(success))    { %><div class="msg-success">${i18n.get('address.updated')}</div><% } %>
<% if ("deleted".equals(success))    { %><div class="msg-success">${i18n.get('address.deleted')}</div><% } %>
<% if ("defaultSet".equals(success)) { %><div class="msg-success">${i18n.get('address.defaultSet')}</div><% } %>
<% if ("notfound".equals(errorMsg))  { %><div class="msg-error">${i18n.get('address.notFound')}</div><% } %>

<a href="${pageContext.request.contextPath}/users/addresses?action=add" class="btn btn-add">+ ${i18n.get('address.addNew')}</a>
<br><br>

<div class="addr-list">
<% if (addresses == null || addresses.isEmpty()) { %>
    <p class="empty-state">${i18n.get('address.noAddresses')}</p>
<% } else {
    for (UserAddress addr : addresses) {
        String provinceName = addr.getProvince() != null ? addr.getProvince().getLocalizedName(lang) : "";
%>
    <div class="addr-card <%= addr.isDefault() ? "default-card" : "" %>">
        <div class="addr-name">
            <%= esc(addr.getFullName()) %>
            <% if (addr.isDefault()) { %>
            <span class="badge-default">${i18n.get('address.default')}</span>
            <% } %>
        </div>
        <div class="addr-detail">📞 <%= esc(addr.getPhone()) %></div>
        <div class="addr-detail">
            📍 <%= esc(addr.getAddressDetail()) %>, <%= esc(addr.getWard()) %>, <%= esc(addr.getDistrict()) %>, <%= esc(provinceName) %>
        </div>
        <div class="addr-actions">
            <a href="${pageContext.request.contextPath}/users/addresses?action=edit&id=<%= addr.getId() %>" class="btn btn-edit">${i18n.get('address.edit')}</a>
            <% if (!addr.isDefault()) { %>
            <a href="${pageContext.request.contextPath}/users/addresses?action=setDefault&id=<%= addr.getId() %>" class="btn btn-def">${i18n.get('address.setDefault')}</a>
            <a href="${pageContext.request.contextPath}/users/addresses?action=delete&id=<%= addr.getId() %>"
               class="btn btn-del"
               data-confirm="${i18n.get('address.deleteConfirm')}"
               onclick="return confirm(this.dataset.confirm)">${i18n.get('address.delete')}</a>
            <% } %>
        </div>
    </div>
<% } } %>
</div>

</body>
</html>
