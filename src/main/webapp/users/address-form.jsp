<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, models.Province, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= request.getAttribute("address") != null ? "Edit" : "Add" %> Address</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { margin-bottom: 10px; }
        .container { max-width: 600px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="tel"], select, textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn { display: inline-block; padding: 8px 16px; text-decoration: none; border: 1px solid #999; border-radius: 3px; cursor: pointer; font-size: 14px; }
        .btn-save { background: #2e7d32; color: white; border: none; }
        .btn-cancel { background: #666; color: white; margin-left: 10px; }
        .error { background: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .checkbox-group { display: flex; align-items: center; }
        .checkbox-group input { width: auto; margin-right: 8px; }
    </style>
</head>
<body>
<%
    UserAddress address = (UserAddress) request.getAttribute("address");
    @SuppressWarnings("unchecked")
    List<Province> provinces = (List<Province>) request.getAttribute("provinces");
    String error = (String) request.getAttribute("error");
    boolean isEdit = (address != null && address.getId() != null);
%>

<div class="container">
    <h1><%= isEdit ? "Edit" : "Add New" %> Address</h1>

    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/users/addresses" method="post">
        <% if (isEdit) { %>
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" value="<%= address.getId() %>">
        <% } %>

        <div class="form-group">
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName"
                   value="<%= address != null ? address.getFullName() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="phone">Phone:</label>
            <input type="tel" id="phone" name="phone"
                   value="<%= address != null ? address.getPhone() : "" %>"
                   pattern="^0\d{9}$" title="Phone must be 10 digits starting with 0" required>
        </div>

        <div class="form-group">
            <label for="provinceId">Province/City:</label>
            <select id="provinceId" name="provinceId" required>
                <option value="">-- Select Province --</option>
                <% if (provinces != null) {
                    for (Province prov : provinces) { %>
                        <option value="<%= prov.getId() %>"
                            <%= address != null && address.getProvinceId() != null && address.getProvinceId().equals(prov.getId()) ? "selected" : "" %>>
                            <%= prov.getNameVi() %>
                        </option>
                    <% }
                } %>
            </select>
        </div>

        <div class="form-group">
            <label for="district">District:</label>
            <input type="text" id="district" name="district"
                   value="<%= address != null ? address.getDistrict() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="ward">Ward/Commune:</label>
            <input type="text" id="ward" name="ward"
                   value="<%= address != null ? address.getWard() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="addressDetail">Address Detail (Street, House Number):</label>
            <textarea id="addressDetail" name="addressDetail" rows="2" required><%= address != null ? address.getAddressDetail() : "" %></textarea>
        </div>

        <div class="form-group checkbox-group">
            <input type="checkbox" id="isDefault" name="isDefault"
                <%= address != null && address.isDefault() ? "checked" : "" %>>
            <label for="isDefault" style="margin-bottom: 0;">Set as default address</label>
        </div>

        <button type="submit" class="btn btn-save">Save Address</button>
        <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn-cancel">Cancel</a>
    </form>
</div>

</body>
</html>
