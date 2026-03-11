<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Province, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${i18n.get('province.title')}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 6px; }
        nav { margin-bottom: 20px; }
        nav a { margin-right: 10px; }
        table { border-collapse: collapse; width: 100%; max-width: 700px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .msg-success { color: green; margin-bottom: 10px; padding: 8px 12px; background: #e8f5e9; border-left: 4px solid #4caf50; }
        .msg-error   { color: red;   margin-bottom: 10px; padding: 8px 12px; background: #ffebee; border-left: 4px solid #f44336; }
        .badge-active   { background: #4caf50; color: white; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .badge-inactive { background: #9e9e9e; color: white; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .btn { display: inline-block; padding: 4px 12px; border-radius: 3px; text-decoration: none; font-size: 13px; border: 1px solid #999; cursor: pointer; }
        .btn-edit { background: #2196f3; color: white; border-color: #2196f3; }
        .btn-del  { background: #f44336; color: white; border-color: #f44336; }
        .btn-add  { background: #4caf50; color: white; border-color: #4caf50; padding: 7px 16px; font-size: 14px; }
        .empty-note { color: #777; font-style: italic; }
    </style>
</head>
<body>
<%
    @SuppressWarnings("unchecked")
    List<Province> provinces = (List<Province>) request.getAttribute("provinces");
    String success  = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>

<h1>${i18n.get('province.title')}</h1>
<nav>
    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
    <a href="${pageContext.request.contextPath}/admin/dashboard">${i18n.get('admin.dashboard')}</a> |
    <a href="${pageContext.request.contextPath}/admin/users">${i18n.get('admin.users')}</a> |
    <a href="${pageContext.request.contextPath}/logout">${i18n.get('nav.logout')}</a>
</nav>

<% if ("created".equals(success))    { %><div class="msg-success">${i18n.get('province.added')}</div><% } %>
<% if ("updated".equals(success))    { %><div class="msg-success">${i18n.get('province.updated')}</div><% } %>
<% if ("deleted".equals(success))    { %><div class="msg-success">${i18n.get('province.deleted')}</div><% } %>
<% if ("notfound".equals(errorMsg))  { %><div class="msg-error">${i18n.get('province.notFound')}</div><% } %>

<a href="${pageContext.request.contextPath}/admin/provinces?action=create" class="btn btn-add">${i18n.get('province.addNew')}</a>
<br><br>

<% if (provinces == null || provinces.isEmpty()) { %>
    <p class="empty-note">${i18n.get('province.noProvinces')}</p>
<% } else { %>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>${i18n.get('province.nameVi')}</th>
            <th>${i18n.get('province.nameEn')}</th>
            <th>${i18n.get('province.active')}</th>
            <th>${i18n.get('order.actions')}</th>
        </tr>
    </thead>
    <tbody>
    <% for (Province p : provinces) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getNameVi() %></td>
            <td><%= p.getNameEn() %></td>
            <td>
                <% if (p.isActive()) { %>
                    <span class="badge-active">${i18n.get('province.yes')}</span>
                <% } else { %>
                    <span class="badge-inactive">${i18n.get('province.no')}</span>
                <% } %>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/admin/provinces?action=edit&id=<%= p.getId() %>" class="btn btn-edit">${i18n.get('action.edit')}</a>
                <a href="${pageContext.request.contextPath}/admin/provinces?action=delete&id=<%= p.getId() %>"
                   class="btn btn-del"
                   onclick="return confirm('${i18n.get('province.deleteConfirm')}')">${i18n.get('action.delete')}</a>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>
<% } %>
</body>
</html>
