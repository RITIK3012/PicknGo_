<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Profile - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="row">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2"></i>Menu</h5>
                    </div>
                    <div class="list-group list-group-flush">
                        <a href="/driver/dashboard" class="list-group-item list-group-item-action">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a href="/driver/profile" class="list-group-item list-group-item-action active">
                            <i class="fas fa-user-cog me-2"></i>Profile
                        </a>
                        <a href="/driver/shipments" class="list-group-item list-group-item-action">
                            <i class="fas fa-box me-2"></i>Shipments
                        </a>
                        <a href="/driver/vehicles" class="list-group-item list-group-item-action">
                            <i class="fas fa-truck me-2"></i>Vehicles
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-id-card me-2"></i>Driver Profile</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                            </div>
                        </c:if>
                        
                        <form:form action="/driver/profile/update" method="post" modelAttribute="driver" class="needs-validation" novalidate="true">
                            <form:hidden path="id" />
                            
                            <div class="mb-4">
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-3 me-3">
                                        <i class="fas fa-user fa-3x text-primary"></i>
                                    </div>
                                    <div>
                                        <h4>${driver.name}</h4>
                                        <p class="text-muted mb-0">
                                            <i class="fas fa-envelope me-2"></i>${driver.email}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Full Name</label>
                                    <form:input path="name" class="form-control" id="name" required="true" />
                                </div>
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label">Contact Number</label>
                                    <form:input path="contactNumber" class="form-control" id="contactNumber" required="true" />
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="licenseNumber" class="form-label">License Number</label>
                                    <form:input path="licenseNumber" class="form-control" id="licenseNumber" required="true" />
                                </div>
                                <div class="col-md-6">
                                    <label for="address" class="form-label">Address</label>
                                    <form:textarea path="address" class="form-control" id="address" rows="3" required="true"></form:textarea>
                                </div>
                            </div>
                            
                            <h5 class="mt-4 mb-3">Bank Information</h5>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="bankName" class="form-label">Bank Name</label>
                                    <form:input path="bankName" class="form-control" id="bankName" />
                                </div>
                                <div class="col-md-4">
                                    <label for="bankAccountNumber" class="form-label">Account Number</label>
                                    <form:input path="bankAccountNumber" class="form-control" id="bankAccountNumber" />
                                </div>
                                <div class="col-md-4">
                                    <label for="ifscCode" class="form-label">IFSC Code</label>
                                    <form:input path="ifscCode" class="form-control" id="ifscCode" />
                                </div>
                            </div>
                            
                            <h5 class="mt-4 mb-3">Security</h5>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="password" class="form-label">New Password</label>
                                    <form:password path="password" class="form-control" id="password" placeholder="Leave blank to keep current password" />
                                    <small class="text-muted">Leave blank to keep your current password</small>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html> 