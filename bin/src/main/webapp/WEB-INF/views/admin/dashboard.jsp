<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .dashboard-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stats-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <h1 class="mb-4">Admin Dashboard</h1>
        
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card bg-primary text-white dashboard-card">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-users me-2"></i>Shippers</h5>
                        <h2 class="display-4">${shippers.size()}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-success text-white dashboard-card">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-truck me-2"></i>Drivers</h5>
                        <h2 class="display-4">${drivers.size()}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-warning text-dark dashboard-card">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-store me-2"></i>Vendors</h5>
                        <h2 class="display-4">${vendors.size()}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-info text-dark dashboard-card">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-box me-2"></i>Shipments</h5>
                        <h2 class="display-4">${shipments.size()}</h2>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0"><i class="fas fa-cogs me-2"></i>Admin Utilities</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0"><i class="fas fa-hashtag me-2"></i>Tracking Number Generator</h5>
                                    </div>
                                    <div class="card-body">
                                        <p>Generate tracking numbers for shipments that don't have one.</p>
                                        <a href="/admin/util/generate-tracking-numbers" class="btn btn-primary" id="generateTrackingBtn">
                                            <i class="fas fa-sync me-2"></i>Generate Tracking Numbers
                                        </a>
                                        <div id="trackingResult" class="mt-3 d-none alert alert-success"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-header bg-success text-white">
                                        <h5 class="mb-0"><i class="fas fa-id-card me-2"></i>KYC Verification</h5>
                                    </div>
                                    <div class="card-body">
                                        <p>Verify KYC documents for drivers.</p>
                                        <a href="/admin/pending-kyc" class="btn btn-success">
                                            <i class="fas fa-check-circle me-2"></i>Manage KYC Verifications
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card dashboard-card">
            <div class="card-header bg-light">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Recent Shipments</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tracking Number</th>
                                <th>Shipper</th>
                                <th>Driver</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty shipments}">
                                    <tr>
                                        <td colspan="7" class="text-center">No shipments found</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${shipments}" var="shipment" end="9">
                                        <tr>
                                            <td>${shipment.id}</td>
                                            <td>${shipment.trackingNumber}</td>
                                            <td>${shipment.shipper.name}</td>
                                            <td>${shipment.driver != null ? shipment.driver.name : 'Not Assigned'}</td>
                                            <td>
                                                <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : shipment.status == 'ASSIGNED' ? 'bg-info' : 'bg-primary'}">
                                                    ${shipment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${not empty shipment.createdAt}">
                                                    <fmt:parseDate value="${shipment.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                                                </c:if>
                                            </td>
                                            <td>
                                                <a href="/admin/tracking/${shipment.id}" class="btn btn-sm btn-info">
                                                    <i class="fas fa-map-marker-alt"></i> Track
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <div class="text-end">
                    <a href="/admin/shipments" class="btn btn-primary">View All Shipments</a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const generateBtn = document.getElementById('generateTrackingBtn');
            const resultDiv = document.getElementById('trackingResult');
            
            if (generateBtn) {
                generateBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    fetch(this.href)
                        .then(response => response.text())
                        .then(data => {
                            resultDiv.textContent = data;
                            resultDiv.classList.remove('d-none');
                            
                            // Hide the result after 5 seconds
                            setTimeout(() => {
                                resultDiv.classList.add('d-none');
                            }, 5000);
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            resultDiv.textContent = 'An error occurred while generating tracking numbers.';
                            resultDiv.classList.remove('d-none', 'alert-success');
                            resultDiv.classList.add('alert-danger');
                        });
                });
            }
        });
    </script>
</body>
</html> 