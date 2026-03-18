<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.UserAddress, models.Province, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("address") != null ? "Edit" : "Add New" %> Address - Ruby Tech</title>

    <!-- Glassmorphism Design System -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <!-- Page-specific styles -->
    <style>
        .address-header {
            text-align: center;
            margin-bottom: var(--space-xl);
        }

        .address-form-card {
            max-width: 700px;
            margin: 0 auto;
            animation: fadeInScale var(--duration-500) var(--ease-out);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-lg);
        }

        .form-group-full {
            grid-column: 1 / -1;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: var(--space-2);
            grid-column: 1 / -1;
            padding: var(--space-md);
            background: var(--surface-tertiary);
            border-radius: var(--radius-md);
            border: 1px solid var(--border-secondary);
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
        }

        .checkbox-group label {
            margin: 0;
            font-weight: var(--font-weight-medium);
            color: var(--text-primary);
        }

        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            gap: var(--space-md);
            justify-content: center;
            margin-top: var(--space-xl);
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95) translateY(20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
                gap: var(--space-md);
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body class="bg-surface-secondary">
<%
    UserAddress address = (UserAddress) request.getAttribute("address");
    @SuppressWarnings("unchecked")
    List<Province> provinces = (List<Province>) request.getAttribute("provinces");
    String error = (String) request.getAttribute("error");
    boolean isEdit = (address != null && address.getId() != null);
%>

    <!-- Page Container -->
    <div class="page-container">
        <!-- Back Link -->
        <div class="mb-lg">
            <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn--back btn--sm">
                ← Back to Addresses
            </a>
        </div>

        <!-- Address Header -->
        <div class="address-header">
            <h1 class="text-3xl font-bold text-primary mb-md">
                <%= isEdit ? "✏️ Edit Address" : "📍 Add New Address" %>
            </h1>
            <p class="text-secondary">
                <%= isEdit ? "Update your address information" : "Add a new delivery address to your account" %>
            </p>
        </div>

        <!-- Error Message -->
        <% if (error != null) { %>
            <div class="message message--error mb-lg">
                ❌ <%= error %>
            </div>
        <% } %>

        <!-- Address Form Card -->
        <div class="surface-card address-form-card">
            <form action="${pageContext.request.contextPath}/users/addresses" method="post">
                <% if (isEdit) { %>
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%= address.getId() %>">
                <% } %>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Full Name *</label>
                        <input type="text"
                               id="fullName"
                               name="fullName"
                               class="form-input"
                               value="<%= address != null && address.getFullName() != null ? address.getFullName() : "" %>"
                               placeholder="Enter full name"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="phone" class="form-label">Phone Number *</label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               class="form-input"
                               value="<%= address != null && address.getPhone() != null ? address.getPhone() : "" %>"
                               pattern="^0\d{9}$"
                               title="Phone must be 10 digits starting with 0"
                               placeholder="0123456789"
                               required>
                    </div>

                    <div class="form-group-full">
                        <label for="provinceId" class="form-label">Province/City *</label>
                        <select id="provinceId" name="provinceId" class="form-select" required>
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
                        <label for="district" class="form-label">District *</label>
                        <input type="text"
                               id="district"
                               name="district"
                               class="form-input"
                               value="<%= address != null && address.getDistrict() != null ? address.getDistrict() : "" %>"
                               placeholder="Enter district"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="ward" class="form-label">Ward/Commune *</label>
                        <input type="text"
                               id="ward"
                               name="ward"
                               class="form-input"
                               value="<%= address != null && address.getWard() != null ? address.getWard() : "" %>"
                               placeholder="Enter ward/commune"
                               required>
                    </div>

                    <div class="form-group-full">
                        <label for="addressDetail" class="form-label">Address Detail *</label>
                        <textarea id="addressDetail"
                                  name="addressDetail"
                                  class="form-textarea"
                                  rows="3"
                                  placeholder="Street, house number, building, etc."
                                  required><%= address != null && address.getAddressDetail() != null ? address.getAddressDetail() : "" %></textarea>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox"
                               id="isDefault"
                               name="isDefault"
                               <%= address != null && address.isDefault() ? "checked" : "" %>>
                        <label for="isDefault">🏠 Set as default address</label>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn--primary btn--lg">
                            💾 <%= isEdit ? "Save Changes" : "Add Address" %>
                        </button>
                        <a href="${pageContext.request.contextPath}/users/addresses" class="btn btn--secondary btn--lg">
                            ❌ Cancel
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Glassmorphism Interactive Effects -->
    <script src="${pageContext.request.contextPath}/assets/js/glassmorphism.js"></script>

    <!-- Page-specific JavaScript -->
    <script>
        // Enhanced form validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const phoneInput = document.getElementById('phone');

            // Phone number formatting
            phoneInput.addEventListener('input', function() {
                let value = this.value.replace(/\D/g, '');
                if (value.length > 10) {
                    value = value.slice(0, 10);
                }
                this.value = value;
            });

            // Real-time validation feedback
            const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    if (this.value.trim() === '') {
                        this.classList.add('form-input--error');
                    } else {
                        this.classList.remove('form-input--error');
                    }
                });

                input.addEventListener('input', function() {
                    if (this.value.trim() !== '') {
                        this.classList.remove('form-input--error');
                    }
                });
            });

            // Auto-focus first input
            const fullNameInput = document.getElementById('fullName');
            if (fullNameInput && !fullNameInput.value) {
                fullNameInput.focus();
            }
        });
    </script>

</body>
</html>
