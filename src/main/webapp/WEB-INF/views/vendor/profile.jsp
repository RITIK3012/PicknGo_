<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Vendor Profile - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2"></i>Vendor Details</h5>
                    </div>
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <i class="fas fa-building fa-6x text-primary mb-3"></i>
                            <h4>${vendor.companyName}</h4>
                            <p class="text-muted">${vendor.businessType}</p>
                        </div>
                        <div class="d-grid">
                            <a href="/vendor/dashboard" class="btn btn-primary mb-2">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                            <a href="/vendor/drivers" class="btn btn-secondary mb-2">
                                <i class="fas fa-users me-2"></i>Manage Drivers
                            </a>
                            <a href="/vendor/tracking" class="btn btn-success">
                                <i class="fas fa-map-marked-alt me-2"></i>Track Shipments
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Contact Information</h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between">
                                <span><i class="fas fa-envelope me-2"></i>Email:</span>
                                <span class="text-muted">${vendor.email}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><i class="fas fa-phone me-2"></i>Phone:</span>
                                <span class="text-muted">${vendor.contactNumber}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><i class="fas fa-map-marker-alt me-2"></i>Address:</span>
                                <span class="text-muted">${vendor.businessAddress}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><i class="fas fa-clock me-2"></i>Hours:</span>
                                <span class="text-muted">${vendor.operatingHours}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <span><i class="fas fa-globe me-2"></i>Website:</span>
                                <span class="text-muted">${vendor.website}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-edit me-2"></i>Edit Profile</h5>
                    </div>
                    <div class="card-body">
                        <form action="/vendor/update-profile" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="${vendor.name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${vendor.email}" readonly>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="contactNumber" class="form-label">Contact Number</label>
                                    <input type="tel" class="form-control" id="contactNumber" name="contactNumber" value="${vendor.contactNumber}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="companyName" class="form-label">Company Name</label>
                                    <input type="text" class="form-control" id="companyName" name="companyName" value="${vendor.companyName}" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="businessType" class="form-label">Business Type</label>
                                    <select class="form-select" id="businessType" name="businessType" required>
                                        <option value="RESTAURANT" ${vendor.businessType == 'RESTAURANT' ? 'selected' : ''}>Restaurant</option>
                                        <option value="GROCERY" ${vendor.businessType == 'GROCERY' ? 'selected' : ''}>Grocery</option>
                                        <option value="RETAIL" ${vendor.businessType == 'RETAIL' ? 'selected' : ''}>Retail</option>
                                        <option value="WHOLESALE" ${vendor.businessType == 'WHOLESALE' ? 'selected' : ''}>Wholesale</option>
                                        <option value="ELECTRONICS" ${vendor.businessType == 'ELECTRONICS' ? 'selected' : ''}>Electronics</option>
                                        <option value="OTHER" ${vendor.businessType == 'OTHER' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="taxId" class="form-label">Tax ID</label>
                                    <input type="text" class="form-control" id="taxId" name="taxId" value="${vendor.taxId}">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="businessAddress" class="form-label">Business Address</label>
                                <textarea class="form-control" id="businessAddress" name="businessAddress" rows="3" required>${vendor.businessAddress}</textarea>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="website" class="form-label">Website</label>
                                    <input type="url" class="form-control" id="website" name="website" value="${vendor.website}">
                                </div>
                                <div class="col-md-6">
                                    <label for="operatingHours" class="form-label">Operating Hours</label>
                                    <input type="text" class="form-control" id="operatingHours" name="operatingHours" value="${vendor.operatingHours}" placeholder="e.g. Mon-Fri: 9AM-5PM">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Business Description</label>
                                <textarea class="form-control" id="description" name="description" rows="4">${vendor.description}</textarea>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="card mt-4">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="fas fa-lock me-2"></i>Change Password</h5>
                    </div>
                    <div class="card-body">
                        <form action="/vendor/update-password" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-key me-2"></i>Update Password
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html> 