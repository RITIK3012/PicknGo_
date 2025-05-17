<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipment Details - PicknGo</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Custom Styles -->
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-box me-2"></i>Shipment Details</h1>
            <a href="/shipper/shipments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
            </a>
        </div>
        
        <div class="row">
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Shipment Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Tracking Number:</div>
                            <div class="col-sm-8">${shipment.trackingNumber}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Status:</div>
                            <div class="col-sm-8">
                                <span class="badge bg-primary shipment-status">${shipment.status}</span>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Goods Type:</div>
                            <div class="col-sm-8">${shipment.goodsType}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Weight:</div>
                            <div class="col-sm-8">${shipment.weight} kg</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Quantity:</div>
                            <div class="col-sm-8">${shipment.quantity}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Price:</div>
                            <div class="col-sm-8">$${shipment.price}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Created At:</div>
                            <div class="col-sm-8"><fmt:formatDate value="${shipment.createdAt}" pattern="dd-MM-yyyy HH:mm" /></div>
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>Location Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Pickup Address:</div>
                            <div class="col-sm-8">${shipment.pickupAddress}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 fw-bold">Delivery Address:</div>
                            <div class="col-sm-8">${shipment.deliveryAddress}</div>
                        </div>
                        <c:if test="${shipment.pickupTime != null}">
                            <div class="row mb-3">
                                <div class="col-sm-4 fw-bold">Pickup Time:</div>
                                <div class="col-sm-8"><fmt:formatDate value="${shipment.pickupTime}" pattern="dd-MM-yyyy HH:mm" /></div>
                            </div>
                        </c:if>
                        <c:if test="${shipment.deliveryTime != null}">
                            <div class="row mb-3">
                                <div class="col-sm-4 fw-bold">Delivery Time:</div>
                                <div class="col-sm-8"><fmt:formatDate value="${shipment.deliveryTime}" pattern="dd-MM-yyyy HH:mm" /></div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-user-tie me-2"></i>Driver Information</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${shipment.driver != null}">
                                <div class="row mb-3">
                                    <div class="col-sm-4 fw-bold">Driver Name:</div>
                                    <div class="col-sm-8">${shipment.driver.name}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-4 fw-bold">Contact Number:</div>
                                    <div class="col-sm-8">${shipment.driver.contactNumber}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-4 fw-bold">License Number:</div>
                                    <div class="col-sm-8">${shipment.driver.licenseNumber}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">
                                    <i class="fas fa-info-circle me-2"></i>No driver assigned to this shipment yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="fas fa-users me-2"></i>Driver Interests</h5>
                    </div>
                    <div class="card-body">
                        <div id="shipment-interests">
                            <c:choose>
                                <c:when test="${not empty interests}">
                                    <div class="list-group">
                                        <c:forEach items="${interests}" var="interest">
                                            <div id="interest-${interest.id}" class="list-group-item list-group-item-action">
                                                <div class="d-flex w-100 justify-content-between align-items-center">
                                                    <div>
                                                        <h5 class="mb-1">${interest.driver.name}</h5>
                                                        <p class="mb-1">
                                                            <i class="fas fa-phone me-1"></i>${interest.driver.contactNumber} |
                                                            <i class="fas fa-id-card me-1"></i>${interest.driver.licenseNumber}
                                                        </p>
                                                        <small>
                                                            Interest shown: <fmt:formatDate value="${interest.createdAt}" pattern="dd-MM-yyyy HH:mm" />
                                                        </small>
                                                    </div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${interest.status eq 'PENDING'}">
                                                                <div class="btn-group" role="group">
                                                                    <button class="btn btn-success btn-sm accept-driver-btn" 
                                                                            data-interest-id="${interest.id}"
                                                                            title="Accept Driver">
                                                                        <i class="fas fa-check me-1"></i>Accept
                                                                    </button>
                                                                    <button class="btn btn-danger btn-sm reject-driver-btn"
                                                                            data-interest-id="${interest.id}"
                                                                            title="Reject Driver">
                                                                        <i class="fas fa-times me-1"></i>Reject
                                                                    </button>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${interest.status eq 'ACCEPTED'}">
                                                                <span class="badge bg-success interest-status">Accepted</span>
                                                            </c:when>
                                                            <c:when test="${interest.status eq 'REJECTED'}">
                                                                <span class="badge bg-danger interest-status">Rejected</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info mb-0">
                                        <i class="fas fa-info-circle me-2"></i>No drivers have shown interest in this shipment yet.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <!-- Bootstrap & jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- SockJS and STOMP for WebSocket -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stomp-websocket@2.3.4/lib/stomp.min.js"></script>
    
    <!-- Real-time updates script -->
    <script src="/js/realtime.js"></script>
    
    <script>
        $(document).ready(function() {
            // Accept driver button click handler
            $('.accept-driver-btn').on('click', function() {
                const interestId = $(this).data('interest-id');
                const btnGroup = $(this).closest('.btn-group');
                
                // Disable buttons to prevent multiple clicks
                btnGroup.find('button').prop('disabled', true);
                $(this).html('<i class="fas fa-spinner fa-spin"></i>');
                
                // Send API request to accept driver
                $.ajax({
                    url: '/shipper/accept-driver/' + interestId,
                    type: 'POST',
                    success: function(response) {
                        if (response.status === 'success') {
                            // Replace button group with accepted badge
                            btnGroup.replaceWith('<span class="badge bg-success">Accepted</span>');
                            
                            // Show success toast
                            showNotification('Success', 'Driver accepted successfully');
                            
                            // Reload page after a short delay to reflect changes
                            setTimeout(function() {
                                window.location.reload();
                            }, 1500);
                        } else {
                            // Re-enable buttons on error
                            btnGroup.find('button').prop('disabled', false);
                            btnGroup.find('.accept-driver-btn').html('<i class="fas fa-check me-1"></i>Accept');
                            showNotification('Error', response.message || 'Something went wrong');
                        }
                    },
                    error: function() {
                        // Re-enable buttons on error
                        btnGroup.find('button').prop('disabled', false);
                        btnGroup.find('.accept-driver-btn').html('<i class="fas fa-check me-1"></i>Accept');
                        showNotification('Error', 'Failed to accept driver. Please try again.');
                    }
                });
            });
            
            // Reject driver button click handler
            $('.reject-driver-btn').on('click', function() {
                const interestId = $(this).data('interest-id');
                const btnGroup = $(this).closest('.btn-group');
                
                // Disable buttons to prevent multiple clicks
                btnGroup.find('button').prop('disabled', true);
                $(this).html('<i class="fas fa-spinner fa-spin"></i>');
                
                // Send API request to reject driver
                $.ajax({
                    url: '/shipper/reject-driver/' + interestId,
                    type: 'POST',
                    success: function(response) {
                        if (response.status === 'success') {
                            // Replace button group with rejected badge
                            btnGroup.replaceWith('<span class="badge bg-danger">Rejected</span>');
                            
                            // Show success toast
                            showNotification('Success', 'Driver rejected successfully');
                        } else {
                            // Re-enable buttons on error
                            btnGroup.find('button').prop('disabled', false);
                            btnGroup.find('.reject-driver-btn').html('<i class="fas fa-times me-1"></i>Reject');
                            showNotification('Error', response.message || 'Something went wrong');
                        }
                    },
                    error: function() {
                        // Re-enable buttons on error
                        btnGroup.find('button').prop('disabled', false);
                        btnGroup.find('.reject-driver-btn').html('<i class="fas fa-times me-1"></i>Reject');
                        showNotification('Error', 'Failed to reject driver. Please try again.');
                    }
                });
            });
            
            // Initialize WebSocket connection
            <sec:authentication property="principal" var="user" />
            connectWebSocket(${user.id}, '${user.authorities[0]}');
        });
    </script>
</body>
</html> 