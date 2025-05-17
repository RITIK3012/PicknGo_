<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Vendor Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/resources/css/styles.css" rel="stylesheet">
    <style>
        .dashboard-card {
            transition: transform 0.3s ease;
            margin-bottom: 20px;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stats-icon {
            font-size: 3rem;
            opacity: 0.8;
        }
        
        /* Notification animation */
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
        
        .highlight-pulse {
            animation: pulse 1.5s infinite;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <!-- Add notification sounds -->
    <audio id="notification-sound" preload="auto">
        <source src="/resources/sounds/notification.mp3" type="audio/mpeg">
        <source src="/resources/sounds/notification.ogg" type="audio/ogg">
    </audio>
    
    <!-- Add hidden input with vendor ID for WebSocket subscriptions -->
    <input type="hidden" id="vendorId" value="${vendor.id}" />
    
    <div class="container py-5">
        <h1 class="mb-4 fw-bold"><i class="fas fa-building me-2"></i>Vendor Dashboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="stat-card mb-4 animate-slide-up" style="animation-delay: 0.1s">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="title">Total Drivers</div>
                            <div class="value">${drivers.size()}</div>
                        </div>
                        <div class="icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="stat-card mb-4 animate-slide-up" style="animation-delay: 0.2s">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="title">Total Shipments</div>
                            <div class="value">${shipments.size()}</div>
                        </div>
                        <div class="icon">
                            <i class="fas fa-box"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="stat-card mb-4 animate-slide-up" style="animation-delay: 0.3s">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="title">Business Type</div>
                            <div class="value">${vendor.businessType}</div>
                        </div>
                        <div class="icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="stat-card mb-4 animate-slide-up" style="animation-delay: 0.4s">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="title">Company</div>
                            <div class="value">${vendor.companyName}</div>
                        </div>
                        <div class="icon">
                            <i class="fas fa-building"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Drivers Section -->
        <div class="glass-card mb-4 animate-fade-in">
            <div class="card-header d-flex justify-content-between align-items-center" style="background: rgba(13, 110, 253, 0.25);">
                <h5 class="mb-0 fw-bold"><i class="fas fa-user-tie me-2"></i>My Drivers</h5>
                <a href="/vendor/drivers" class="btn btn-glass btn-glass-primary">Manage Drivers</a>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty drivers}">
                        <div class="table-responsive">
                            <table class="table table-glass">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Contact Number</th>
                                        <th>Verification Status</th>
                                        <th>Active Shipments</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${drivers}" var="driver" begin="0" end="4">
                                        <tr>
                                            <td>${driver.name}</td>
                                            <td>${driver.email}</td>
                                            <td>${driver.contactNumber}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${driver.verified}">
                                                        <span class="badge bg-success">Verified</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:set var="activeCount" value="0" />
                                                <c:forEach items="${shipments}" var="shipment">
                                                    <c:if test="${shipment.driver.id eq driver.id && shipment.status ne 'DELIVERED'}">
                                                        <c:set var="activeCount" value="${activeCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${activeCount}
                                            </td>
                                            <td>
                                                <a href="/vendor/driver/${driver.id}" class="btn btn-glass btn-glass-info btn-sm">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>You have no drivers assigned yet. 
                            <a href="/vendor/assign-driver" class="alert-link">Assign drivers now</a>.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Shipments Section -->
        <div class="glass-card mb-4 animate-fade-in">
            <div class="card-header d-flex justify-content-between align-items-center" style="background: rgba(40, 167, 69, 0.25);">
                <h5 class="mb-0 fw-bold"><i class="fas fa-shipping-fast me-2"></i>Shipments</h5>
                <a href="/vendor/tracking" class="btn btn-glass btn-glass-success">View All Shipments</a>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty shipments}">
                        <div class="table-responsive">
                            <table class="table table-glass">
                                <thead>
                                    <tr>
                                        <th>Tracking #</th>
                                        <th>Origin</th>
                                        <th>Destination</th>
                                        <th>Assigned Driver</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${shipments}" var="shipment" begin="0" end="4">
                                        <tr>
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.pickupAddress}</td>
                                            <td>${shipment.deliveryAddress}</td>
                                            <td>${shipment.driver.name}</td>
                                            <td>
                                                <span class="badge 
                                                    ${shipment.status eq 'DELIVERED' ? 'bg-success' : 
                                                    shipment.status eq 'IN_TRANSIT' ? 'bg-primary' :
                                                    shipment.status eq 'PICKED_UP' ? 'bg-info' :
                                                    shipment.status eq 'ASSIGNED' ? 'bg-warning' : 'bg-secondary'}">
                                                    ${shipment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="/vendor/shipment/${shipment.id}" class="btn btn-glass btn-glass-info btn-sm">
                                                    <i class="fas fa-eye"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>There are no shipments assigned to your drivers yet.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Quick Actions Section -->
        <div class="row">
            <div class="col-md-6">
                <div class="glass-card animate-fade-in">
                    <div class="card-header" style="background: rgba(33, 37, 41, 0.25);">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="d-grid gap-3">
                            <a href="/vendor/assign-driver" class="btn btn-glass btn-glass-primary">
                                <i class="fas fa-user-plus me-2"></i>Assign New Driver
                            </a>
                            <a href="/vendor/profile" class="btn btn-glass">
                                <i class="fas fa-user-edit me-2"></i>Edit Vendor Profile
                            </a>
                            <a href="/vendor/tracking" class="btn btn-glass btn-glass-success">
                                <i class="fas fa-map-marked-alt me-2"></i>Track Shipments
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="glass-card animate-fade-in">
                    <div class="card-header" style="background: rgba(33, 37, 41, 0.25);">
                        <h5 class="mb-0 fw-bold"><i class="fas fa-info-circle me-2"></i>Vendor Information</h5>
                    </div>
                    <div class="card-body p-4">
                        <ul class="list-group list-group-flush" style="background: transparent;">
                            <li class="list-group-item d-flex justify-content-between align-items-center" style="background: rgba(255, 255, 255, 0.1); margin-bottom: 8px; border-radius: 8px;">
                                <span><i class="fas fa-building me-2"></i>Company Name</span>
                                <span class="fw-bold">${vendor.companyName}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center" style="background: rgba(255, 255, 255, 0.1); margin-bottom: 8px; border-radius: 8px;">
                                <span><i class="fas fa-briefcase me-2"></i>Business Type</span>
                                <span class="fw-bold">${vendor.businessType}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center" style="background: rgba(255, 255, 255, 0.1); margin-bottom: 8px; border-radius: 8px;">
                                <span><i class="fas fa-id-card me-2"></i>Tax ID</span>
                                <span class="fw-bold">${vendor.taxId}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center" style="background: rgba(255, 255, 255, 0.1); margin-bottom: 8px; border-radius: 8px;">
                                <span><i class="fas fa-map-marker-alt me-2"></i>Business Address</span>
                                <span class="fw-bold">${vendor.businessAddress}</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center" style="background: rgba(255, 255, 255, 0.1); margin-bottom: 8px; border-radius: 8px;">
                                <span><i class="fas fa-clock me-2"></i>Operating Hours</span>
                                <span class="fw-bold">${vendor.operatingHours}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/resources/js/vendor-dashboard.js"></script>
</body>
</html> 