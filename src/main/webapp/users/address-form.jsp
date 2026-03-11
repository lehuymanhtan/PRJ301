<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, models.Province, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${i18n.get('address.formTitle')}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 20px; }
        .form-group { margin-bottom: 12px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type="text"], select { padding: 6px 8px; width: 300px; box-sizing: border-box; }
        .checkbox-row { display: flex; align-items: center; gap: 8px; }
        .checkbox-row input { width: auto; }
        .msg-error { color: red; margin-bottom: 12px; padding: 8px 12px; background: #ffebee; border-left: 4px solid #f44336; }
        .actions { margin-top: 16px; }
        .btn { display: inline-block; padding: 7px 18px; border-radius: 3px; cursor: pointer; font-size: 14px; border: 1px solid #999; text-decoration: none; }
        .btn-save   { background: #2e7d32; color: white; border-color: #2e7d32; }
        .btn-cancel { background: #555; color: white; border-color: #555; }
        .note { color: #666; font-size: 12px; margin-top: 2px; }
    </style>
</head>
<body>
<%
    @SuppressWarnings("unchecked")
    List<Province> provinces = (List<Province>) request.getAttribute("provinces");
    UserAddress address = (UserAddress) request.getAttribute("address");
    String lang  = (String) request.getAttribute("lang");
    if (lang == null) lang = "vi";
    boolean isEdit = (address != null && address.getId() != null);
    String formAction = isEdit ? "edit" : "add";
%>

<h1><%= isEdit ? "${i18n.get('address.editTitle')}" : "${i18n.get('address.addTitle')}" %></h1>
<nav>
    <%@ include file="/WEB-INF/includes/language-switcher.jsp" %>
    <a href="${pageContext.request.contextPath}/users/addresses">← ${i18n.get('address.backToList')}</a>
</nav>
<br>

<% if (request.getAttribute("error") != null) { %>
<div class="msg-error"><%= request.getAttribute("error") %></div>
<% } %>

<form method="post" action="${pageContext.request.contextPath}/users/addresses">
    <input type="hidden" name="action" value="<%= formAction %>">
    <% if (isEdit) { %><input type="hidden" name="id" value="<%= address.getId() %>"><% } %>

    <div class="form-group">
        <label for="fullName">${i18n.get('address.fullName')} *</label>
        <input type="text" id="fullName" name="fullName" required maxlength="100"
               value="<%= address != null && address.getFullName() != null ? address.getFullName() : "" %>">
    </div>

    <div class="form-group">
        <label for="phone">${i18n.get('address.phone')} *</label>
        <input type="text" id="phone" name="phone" required maxlength="15"
               placeholder="0xxxxxxxxx"
               value="<%= address != null && address.getPhone() != null ? address.getPhone() : "" %>">
        <div class="note">${i18n.get('address.phoneNote')}</div>
    </div>

    <div class="form-group">
        <label for="provinceId">${i18n.get('address.province')} *</label>
        <select id="provinceId" name="provinceId" required>
            <option value="">${i18n.get('address.selectProvince')}</option>
            <% if (provinces != null) {
                for (Province p : provinces) {
                    boolean selected = address != null && p.getId().equals(address.getProvinceId());
            %>
            <option value="<%= p.getId() %>" <%= selected ? "selected" : "" %>>
                <%= p.getLocalizedName(lang) %>
            </option>
            <% } } %>
        </select>
    </div>

    <div class="form-group">
        <label for="district">${i18n.get('address.district')} *</label>
        <input type="text" id="district" name="district" required maxlength="100"
               value="<%= address != null && address.getDistrict() != null ? address.getDistrict() : "" %>">
    </div>

    <div class="form-group">
        <label for="ward">${i18n.get('address.ward')} *</label>
        <input type="text" id="ward" name="ward" required maxlength="100"
               value="<%= address != null && address.getWard() != null ? address.getWard() : "" %>">
    </div>

    <div class="form-group">
        <label for="addressDetail">${i18n.get('address.detail')} *</label>
        <input type="text" id="addressDetail" name="addressDetail" required maxlength="255"
               placeholder="${i18n.get('address.detailPlaceholder')}"
               value="<%= address != null && address.getAddressDetail() != null ? address.getAddressDetail() : "" %>">
    </div>

    <div class="form-group">
        <div class="checkbox-row">
            <input type="checkbox" id="isDefault" name="isDefault"
                   <%= (address != null && address.isDefault()) ? "checked" : "" %>>
            <label for="isDefault" style="font-weight: normal;">${i18n.get('address.isDefault')}</label>
        </div>
    </div>

    <div class="actions">
        <button type="submit" class="btn btn-save">${i18n.get('address.save')}</button>
        <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn-cancel">${i18n.get('action.cancel')}</a>
    </div>
</form>
</body>
</html>
