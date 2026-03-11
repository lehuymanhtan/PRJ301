<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Province" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${i18n.get('province.formTitle')}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 20px; }
        .form-group { margin-bottom: 12px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type="text"] { padding: 6px 8px; width: 300px; }
        .checkbox-row { display: flex; align-items: center; gap: 8px; }
        .checkbox-row input { width: auto; }
        .msg-error { color: red; margin-bottom: 12px; padding: 8px 12px; background: #ffebee; border-left: 4px solid #f44336; }
        .actions { margin-top: 16px; }
        .btn { display: inline-block; padding: 7px 18px; border-radius: 3px; cursor: pointer; font-size: 14px; border: 1px solid #999; text-decoration: none; }
        .btn-save   { background: #2e7d32; color: white; border-color: #2e7d32; }
        .btn-cancel { background: #555; color: white; border-color: #555; }
    </style>
</head>
<body>
<%
    Province province = (Province) request.getAttribute("province");
    boolean isEdit = (province != null && province.getId() != null);
%>

<h1><%= isEdit ? "${i18n.get('province.editTitle')}" : "${i18n.get('province.createTitle')}" %></h1>
<nav>
    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
    <a href="${pageContext.request.contextPath}/admin/provinces">← ${i18n.get('province.backToList')}</a>
</nav>
<br>

<% if (request.getAttribute("error") != null) { %>
<div class="msg-error"><%= request.getAttribute("error") %></div>
<% } %>

<form method="post" action="${pageContext.request.contextPath}/admin/provinces">
    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "create" %>">
    <% if (isEdit) { %><input type="hidden" name="id" value="<%= province.getId() %>"><% } %>

    <div class="form-group">
        <label for="nameVi">${i18n.get('province.nameVi')} *</label>
        <input type="text" id="nameVi" name="nameVi" required maxlength="100"
               placeholder="VD: Thành phố Hồ Chí Minh"
               value="<%= province != null && province.getNameVi() != null ? province.getNameVi() : "" %>">
    </div>

    <div class="form-group">
        <label for="nameEn">${i18n.get('province.nameEn')} *</label>
        <input type="text" id="nameEn" name="nameEn" required maxlength="100"
               placeholder="E.g.: Ho Chi Minh City"
               value="<%= province != null && province.getNameEn() != null ? province.getNameEn() : "" %>">
    </div>

    <div class="form-group">
        <div class="checkbox-row">
            <input type="checkbox" id="isActive" name="isActive" value="true"
                   <%= (province == null || province.isActive()) ? "checked" : "" %>>
            <label for="isActive" style="font-weight: normal;">${i18n.get('province.active')}</label>
        </div>
    </div>

    <div class="actions">
        <button type="submit" class="btn btn-save">${i18n.get('action.save')}</button>
        <a href="${pageContext.request.contextPath}/admin/provinces" class="btn btn-cancel">${i18n.get('action.cancel')}</a>
    </div>
</form>

<script>
    // When checkbox is unchecked, send "false" so the servlet can detect it
    document.querySelector('form').addEventListener('submit', function() {
        var cb = document.getElementById('isActive');
        if (!cb.checked) {
            var hidden = document.createElement('input');
            hidden.type = 'hidden'; hidden.name = 'isActive'; hidden.value = 'false';
            this.appendChild(hidden);
        }
    });
</script>
</body>
</html>
