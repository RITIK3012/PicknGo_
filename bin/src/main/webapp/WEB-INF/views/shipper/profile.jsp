<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipper Profile - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .profile-card {
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .profile-header {
            background-color: #4e73df;
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="card profile-card">
                    <div class="profile-header">
                        <div class="text-center">
                            <i class="fas fa-user-circle fa-5x mb-3"></i>
                            <h2>${shipper.name}</h2>
                            <p class="mb-0"><i class="fas fa-envelope me-2"></i>${shipper.email}</p>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <h4 class="card-title mb-4">Shipper Information</h4>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p><strong><i class="fas fa-id-card me-2"></i>ID:</strong> ${shipper.id}</p>
                                <p><strong><i class="fas fa-phone me-2"></i>Phone:</strong> ${shipper.contactNumber}</p>
                                <p><strong><i class="fas fa-map-marker-alt me-2"></i>Address:</strong> ${shipper.address}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong><i class="fas fa-calendar-alt me-2"></i>Joined:</strong> 
                                    <fmt:formatDate value="${shipper.createdAt}" pattern="MMMM dd, yyyy"/>
                                </p>
                                <p><strong><i class="fas fa-building me-2"></i>Company:</strong> ${shipper.companyName}</p>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="/shipper/dashboard" class="btn btn-outline-primary me-md-2">
                                <i class="fas fa-tachometer-alt me-2"></i>Back to Dashboard
                            </a>
                            <a href="/shipper/edit-profile" class="btn btn-primary">
                                <i class="fas fa-edit me-2"></i>Edit Profile
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 