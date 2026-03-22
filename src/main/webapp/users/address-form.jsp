<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, models.Province, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("address") != null ? "Edit" : "Add New" %> Address - Ruby Tech</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo.png">
</head>
<body>
<%
    UserAddress address = (UserAddress) request.getAttribute("address");
    @SuppressWarnings("unchecked")
    List<Province> provinces = (List<Province>) request.getAttribute("provinces");
    String error = (String) request.getAttribute("error");
    boolean isEdit = (address != null && address.getId() != null);
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/users">Profile</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/users/addresses">Addresses</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4" style="max-width:680px">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i>Back to Addresses
        </a>
    </div>

    <h1 class="h3 fw-bold mb-1">
        <i class="bi bi-geo-alt me-2"></i><%= isEdit ? "Edit Address" : "Add New Address" %>
    </h1>
    <p class="text-muted mb-4"><%= isEdit ? "Update your address information" : "Add a new delivery address to your account" %></p>

    <% if (error != null) { %>
        <div class="alert alert-danger auto-dismiss"><i class="bi bi-exclamation-circle me-2"></i><%= error %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/users/addresses" method="post">
                <% if (isEdit) { %>
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%= address.getId() %>">
                <% } %>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="fullName" class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-control"
                               value="<%= address != null && address.getFullName() != null ? address.getFullName() : "" %>"
                               placeholder="Enter full name" required autofocus>
                    </div>
                    <div class="col-md-6">
                        <label for="phone" class="form-label fw-semibold">Phone Number <span class="text-danger">*</span></label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="<%= address != null && address.getPhone() != null ? address.getPhone() : "" %>"
                               pattern="^0\d{9}$"
                               title="Phone must be 10 digits starting with 0"
                               placeholder="0123456789" required>
                    </div>
                    <div class="col-12">
                        <label for="provinceId" class="form-label fw-semibold">Province/City <span class="text-danger">*</span></label>
                        <select id="provinceId" name="provinceId" class="form-select" required>
                            <option value="">-- Select Province --</option>
                            <% if (provinces != null) {
                                for (Province prov : provinces) { %>
                                <option value="<%= prov.getId() %>"
                                    <%= address != null && address.getProvinceId() != null && address.getProvinceId().equals(prov.getId()) ? "selected" : "" %>>
                                    <%= prov.getNameVi() %>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="district" class="form-label fw-semibold">District <span class="text-danger">*</span></label>
                        <input type="text" id="district" name="district" class="form-control"
                               value="<%= address != null && address.getDistrict() != null ? address.getDistrict() : "" %>"
                               placeholder="Enter district" required>
                    </div>
                    <div class="col-md-6">
                        <label for="ward" class="form-label fw-semibold">Ward/Commune <span class="text-danger">*</span></label>
                        <input type="text" id="ward" name="ward" class="form-control"
                               value="<%= address != null && address.getWard() != null ? address.getWard() : "" %>"
                               placeholder="Enter ward/commune" required>
                    </div>
                    <div class="col-12">
                        <label for="addressDetail" class="form-label fw-semibold">Address Detail <span class="text-danger">*</span></label>
                        <textarea id="addressDetail" name="addressDetail" class="form-control"
                                  rows="3" placeholder="Street, house number, building, etc." required><%= address != null && address.getAddressDetail() != null ? address.getAddressDetail() : "" %></textarea>
                    </div>
                    <div class="col-12">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="isDefault" name="isDefault"
                                   <%= address != null && address.isDefault() ? "checked" : "" %>>
                            <label class="form-check-label fw-semibold" for="isDefault">
                                <i class="bi bi-house me-1"></i>Set as default address
                            </label>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-rt-primary">
                        <i class="bi bi-floppy me-2"></i><%= isEdit ? "Save Changes" : "Add Address" %>
                    </button>
                    <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn-outline-secondary">
                        <i class="bi bi-x me-1"></i>Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    document.getElementById('phone').addEventListener('input', function() {
        let value = this.value.replace(/\D/g, '');
        if (value.length > 10) value = value.slice(0, 10);
        this.value = value;
    });
</script>
</body>
</html>
