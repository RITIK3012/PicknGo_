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
    <title>Assign Drivers - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/resources/css/styles.css" rel="stylesheet">
    <style>
        .driver-card {
            transition: transform 0.3s ease;
            cursor: pointer;
        }
        .driver-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .driver-card.selected {
            border: 2px solid #0d6efd;
            background-color: #f8f9ff;
        }
        .driver-img {
            height: 80px;
            width: 80px;
            object-fit: cover;
            border-radius: 50%;
            margin: 0 auto;
            border: 3px solid #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-user-plus me-2"></i>Assign Drivers</h1>
            <div>
                <a href="/vendor/drivers" class="btn btn-primary">
                    <i class="fas fa-users me-2"></i>Back to Drivers
                </a>
                <a href="/vendor/dashboard" class="btn btn-secondary">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-users me-2"></i>Available Drivers</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty availableDrivers}">
                                <p class="text-muted mb-4">Select a driver from the list below to assign to your vendor account. Only verified drivers without a current vendor assignment are shown.</p>
                                
                                <div class="row">
                                    <c:forEach items="${availableDrivers}" var="driver">
                                        <div class="col-md-6 mb-3">
                                            <div class="card driver-card" data-driver-id="${driver.id}" data-driver-name="${driver.name}">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-shrink-0">
                                                            <img src="/resources/images/driver-placeholder.jpg" alt="Driver" class="driver-img">
                                                        </div>
                                                        <div class="flex-grow-1 ms-3">
                                                            <h5 class="mb-0">${driver.name}</h5>
                                                            <p class="text-muted mb-0">${driver.email}</p>
                                                            <p class="mb-1"><small>License: ${driver.licenseNumber}</small></p>
                                                            <p class="mb-0"><small>Phone: ${driver.contactNumber}</small></p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>There are no available drivers to assign. 
                                    <p class="mb-0 mt-2">Drivers must be verified and not already assigned to another vendor.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="card sticky-top" style="top: 20px;">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-check-circle me-2"></i>Assign Selected Driver</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty availableDrivers}">
                                <div id="driverSelectionInfo">
                                    <div class="alert alert-info mb-4">
                                        <i class="fas fa-info-circle me-2"></i>Please select a driver from the list to assign them to your vendor account.
                                    </div>
                                </div>
                                
                                <div id="driverAssignmentForm" style="display: none;">
                                    <div class="alert alert-success mb-4">
                                        <i class="fas fa-check-circle me-2"></i>You've selected <strong id="selectedDriverName"></strong>
                                    </div>
                                    
                                    <form action="/vendor/assign-driver" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="hidden" id="driverId" name="driverId" value="" />
                                        
                                        <div class="mb-3">
                                            <label for="notes" class="form-label">Notes (optional)</label>
                                            <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Add any notes or special instructions for this driver..."></textarea>
                                        </div>
                                        
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="confirmAssignment" required>
                                            <label class="form-check-label" for="confirmAssignment">
                                                I confirm that I want to assign this driver to my vendor account
                                            </label>
                                        </div>
                                        
                                        <div class="d-grid">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-user-plus me-2"></i>Assign Driver
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning mb-0">
                                    <i class="fas fa-exclamation-triangle me-2"></i>No drivers are available for assignment.
                                    <p class="mb-0 mt-2">Please check back later or contact support for assistance.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Handle driver card selection
            $('.driver-card').click(function() {
                // Remove selection from all cards
                $('.driver-card').removeClass('selected');
                
                // Add selection to clicked card
                $(this).addClass('selected');
                
                // Get driver info
                const driverId = $(this).data('driver-id');
                const driverName = $(this).data('driver-name');
                
                // Update form
                $('#driverId').val(driverId);
                $('#selectedDriverName').text(driverName);
                
                // Show assignment form, hide info message
                $('#driverSelectionInfo').hide();
                $('#driverAssignmentForm').show();
            });
        });
    </script>
</body>
</html> 