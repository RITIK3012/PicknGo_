<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Available Shipments - PicknGo</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Custom Styles -->
    <link href="/resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-truck me-2"></i>Available Shipments</h1>
            <a href="/driver/dashboard" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
        
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Browse Available Shipments</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty availableShipments}">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>Tracking #</th>
                                                <th>Origin</th>
                                                <th>Destination</th>
                                                <th>Shipper</th>
                                                <th>Created</th>
                                                <th>Weight</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${availableShipments}" var="shipment">
                                                <tr id="shipment-${shipment.id}">
                                                    <td>${shipment.trackingNumber}</td>
                                                    <td>${shipment.pickupAddress}</td>
                                                    <td>${shipment.deliveryAddress}</td>
                                                    <td>${shipment.shipper.companyName}</td>
                                                    <td><fmt:formatDate value="${shipment.createdAt}" pattern="dd-MM-yyyy" /></td>
                                                    <td>${shipment.weight} kg</td>
                                                    <td class="shipment-status">${shipment.status}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${interestStatusMap[shipment.id] eq 'PENDING'}">
                                                                <span class="badge bg-warning">Interest Pending</span>
                                                            </c:when>
                                                            <c:when test="${interestStatusMap[shipment.id] eq 'ACCEPTED'}">
                                                                <span class="badge bg-success">Interest Accepted</span>
                                                            </c:when>
                                                            <c:when test="${interestStatusMap[shipment.id] eq 'REJECTED'}">
                                                                <span class="badge bg-danger">Interest Rejected</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn btn-primary btn-sm show-interest-btn" 
                                                                        data-shipment-id="${shipment.id}">
                                                                    Show Interest
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">
                                    <i class="fas fa-info-circle me-2"></i>No available shipments at the moment. Please check back later.
                                </div>
                            </c:otherwise>
                        </c:choose>
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
    
    <!-- Custom Scripts -->
    <script src="/resources/js/realtime.js"></script>
    <script src="/resources/js/showInterest.js"></script>
    
    <script>
        $(document).ready(function() {
            // Get CSRF token from meta tag
            const token = $("meta[name='_csrf']").attr("content");
            const header = $("meta[name='_csrf_header']").attr("content");
            
            // Show interest button click handler
            $('.show-interest-btn').on('click', function() {
                const shipmentId = $(this).data('shipment-id');
                const btn = $(this);
                
                // Disable button to prevent multiple clicks
                btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Processing...');
                
                // Send API request to show interest
                $.ajax({
                    url: '/driver/show-interest/' + shipmentId,
                    type: 'POST',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader(header, token);
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            // Replace button with pending badge
                            btn.replaceWith('<span class="badge bg-warning">Interest Pending</span>');
                            
                            // Show success toast
                            showNotification('Success', 'Interest shown successfully');
                        } else {
                            // Re-enable button on error
                            btn.prop('disabled', false).html('Show Interest');
                            showNotification('Error', response.message || 'Something went wrong');
                        }
                    },
                    error: function() {
                        // Re-enable button on error
                        btn.prop('disabled', false).html('Show Interest');
                        showNotification('Error', 'Failed to show interest. Please try again.');
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