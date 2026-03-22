<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Order, models.RefundRequest, models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refund #${refund.id} Details - Ruby Tech Admin</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <script>
        function toggleReturnAddress() {
            var sel = document.getElementById("statusSelect");
            var grp = document.getElementById("returnAddressGroup");
            grp.style.display = (sel.value === "WaitForReturn") ? "block" : "none";
        }
        window.onload = function() { toggleReturnAddress(); };
    </script>
</head>
<body class="bg-light">
<%
    User currentUser = (User) session.getAttribute("user");
    RefundRequest refund = (RefundRequest) request.getAttribute("refund");
    Order         order  = (Order)         request.getAttribute("order");
    String        status = refund.getStatus();
    
    String badgeClass = "bg-secondary";
    String iconClass = "bi-journal-text";
    
    if ("Pending".equals(status)) { badgeClass = "bg-warning text-dark"; iconClass = "bi-hourglass-split"; }
    else if ("WaitForReturn".equals(status)) { badgeClass = "bg-info text-dark"; iconClass = "bi-box-seam"; }
    else if ("Verifying".equals(status)) { badgeClass = "bg-primary"; iconClass = "bi-search"; }
    else if ("Done".equals(status)) { badgeClass = "bg-success"; iconClass = "bi-check-circle"; }
    else if ("Rejected".equals(status)) { badgeClass = "bg-danger"; iconClass = "bi-x-circle"; }
    else if ("Cancelled".equals(status)) { badgeClass = "bg-dark"; iconClass = "bi-slash-circle"; }
%>

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-rt">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="logo"> Ruby Tech Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/suppliers">Suppliers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/refunds">Refunds</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/income">Income</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/loyalty">Loyalty</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/forecast">Forecast</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Shop</a></li>
                <li class="nav-item"><span class="nav-link text-white opacity-75"><%= session.getAttribute("user") != null ? ((models.User)session.getAttribute("user")).getUsername() : "" %></span></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <h1 class="h3 fw-bold mb-1"><i class="bi bi-file-earmark-ruled me-2"></i>Refund #<%= refund.getId() %></h1>
            <p class="text-muted mb-4">Review details and update refund workflow status</p>
            
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/admin/refunds" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i>Back to Refunds</a>
            </div>

            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-0">
                    <h5 class="fw-bold m-0"><i class="bi bi-info-circle me-2 text-primary"></i>Refund Information</h5>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="text-muted small fw-semibold">Refund ID</label>
                            <div class="fw-bold fs-5">#<%= refund.getId() %></div>
                        </div>
                        <div class="col-sm-6">
                            <label class="text-muted small fw-semibold">Order ID</label>
                            <div>
                                <span class="fw-bold fs-5 me-2">#<%= refund.getOrderId() %></span>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=<%= refund.getOrderId() %>"
                                   class="text-decoration-none small"><i class="bi bi-box-arrow-up-right me-1"></i>View Order</a>
                            </div>
                        </div>
                        
                        <div class="col-sm-6">
                            <label class="text-muted small fw-semibold">Customer</label>
                            <div>User ID: <%= refund.getUserId() %></div>
                        </div>
                        
                        <% if (order != null) { %>
                        <div class="col-sm-6">
                            <label class="text-muted small fw-semibold">Order Total</label>
                            <div class="fw-bold text-success"><%= String.format("%,.0f", order.getTotalPrice()) %> ₫</div>
                        </div>
                        <% } %>
                        
                        <div class="col-12 border-top pt-3">
                            <label class="text-muted small fw-semibold">Reason</label>
                            <div><%= refund.getReason() %></div>
                        </div>
                        
                        <% if (refund.getDescription() != null && !refund.getDescription().isEmpty()) { %>
                        <div class="col-12 mt-3">
                            <label class="text-muted small fw-semibold">Description</label>
                            <div class="bg-light p-3 rounded border"><%= refund.getDescription() %></div>
                        </div>
                        <% } %>
                        
                        <div class="col-sm-6 border-top mt-3 pt-3">
                            <label class="text-muted small fw-semibold">Submitted</label>
                            <div><i class="bi bi-calendar-event me-2 text-muted"></i><%= refund.getCreatedAt() != null ? refund.getCreatedAt().toLocalDate() : "" %></div>
                        </div>
                        
                        <div class="col-sm-6 border-top mt-3 pt-3">
                            <label class="text-muted small fw-semibold">Status</label>
                            <div>
                                <span class="badge <%= badgeClass %> fs-6 px-3 py-2">
                                    <i class="bi <%= iconClass %> me-1"></i><%= status %>
                                </span>
                            </div>
                        </div>
                        
                        <% if (refund.getReturnAddress() != null && !refund.getReturnAddress().isEmpty()) { %>
                        <div class="col-12 border-top mt-3 pt-3">
                            <label class="text-muted small fw-semibold"><i class="bi bi-geo-alt me-1"></i>Return Address</label>
                            <div class="p-2 bg-light border-start border-4 border-info"><%= refund.getReturnAddress() %></div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <% if (!"Done".equals(status) && !"Rejected".equals(status) && !"Cancelled".equals(status)) { %>
            <div class="card shadow-sm border-0 border-top border-4 border-primary">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-primary border-bottom pb-2 mb-4">Update Refund Status</h5>

                    <form action="${pageContext.request.contextPath}/admin/refunds" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= refund.getId() %>">

                        <div class="mb-4">
                            <label class="form-label fw-semibold" for="statusSelect">New Status</label>
                            <select class="form-select form-select-lg" name="status" id="statusSelect" onchange="toggleReturnAddress()" required>
                                <option value="Pending"       <%="Pending"      .equals(status) ? "selected" : ""%>>Pending</option>
                                <option value="WaitForReturn" <%="WaitForReturn".equals(status) ? "selected" : ""%>>Wait for Return</option>
                                <option value="Verifying"     <%="Verifying"    .equals(status) ? "selected" : ""%>>Verifying</option>
                                <option value="Done"          <%="Done"         .equals(status) ? "selected" : ""%>>Done</option>
                                <option value="Rejected"      <%="Rejected"     .equals(status) ? "selected" : ""%>>Rejected</option>
                            </select>
                        </div>

                        <div class="mb-4" id="returnAddressGroup" style="display: none;">
                            <label class="form-label fw-semibold" for="returnAddress"><i class="bi bi-truck me-2"></i>Return Address</label>
                            <div class="form-text text-muted mb-2"><i class="bi bi-info-circle me-1"></i>Shown to customer for return shipment.</div>
                            <textarea class="form-control" name="returnAddress" id="returnAddress" rows="3"
                                      placeholder="e.g. 123 Nguyen Hue, District 1, Ho Chi Minh City"><%= refund.getReturnAddress() != null ? refund.getReturnAddress() : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-3">
                            <button type="submit" class="btn btn-success px-4"><i class="bi bi-check-lg me-2"></i>Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-secondary border d-flex align-items-center" role="alert">
                <i class="bi bi-lock-fill fs-4 me-3 text-muted"></i>
                <div>
                    <h6 class="mb-1 text-dark fw-bold">Terminal State Reached</h6>
                    <div class="text-muted small">This refund is in a terminal state (<%= status %>) and can no longer be updated.</div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
