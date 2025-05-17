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
    <title>Shipment Tracking - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="/resources/css/styles.css" rel="stylesheet">
    <style>
        .map-container {
            height: 400px;
            width: 100%;
            margin-bottom: 20px;
            position: relative;
        }
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        .timeline:before {
            content: '';
            position: absolute;
            top: 0;
            left: 15px;
            height: 100%;
            width: 2px;
            background-color: #dee2e6;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-marker {
            position: absolute;
            left: -30px;
            top: 0;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #fff;
            border: 2px solid #dee2e6;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1;
        }
        .timeline-marker.active {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
        }
        .timeline-marker.completed {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .timeline-content {
            padding: 15px;
            border-radius: 4px;
            background-color: #f8f9fa;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .shipment-card {
            transition: transform 0.3s ease;
            cursor: pointer;
            margin-bottom: 15px;
        }
        .shipment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .shipment-card.selected {
            border: 2px solid #007bff;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-map-marked-alt me-2"></i>Shipment Tracking</h1>
            <div>
                <a href="/vendor/dashboard" class="btn btn-primary">
                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                </a>
                <a href="/vendor/drivers" class="btn btn-secondary">
                    <i class="fas fa-users me-2"></i>Manage Drivers
                </a>
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-truck me-2"></i>Active Shipments</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:choose>
                                <c:when test="${not empty shipments}">
                                    <c:forEach items="${shipments}" var="shipment">
                                        <div class="shipment-card list-group-item list-group-item-action" data-shipment-id="${shipment.id}">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1">${shipment.trackingNumber}</h6>
                                                <small class="badge bg-${shipment.status eq 'IN_TRANSIT' ? 'primary' : 'warning'}">
                                                    ${shipment.status}
                                                </small>
                                            </div>
                                            <p class="mb-1 text-truncate"><small><i class="fas fa-map-marker-alt me-1"></i> From: ${shipment.pickupAddress}</small></p>
                                            <p class="mb-1 text-truncate"><small><i class="fas fa-map-marker me-1"></i> To: ${shipment.deliveryAddress}</small></p>
                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                <small class="text-muted">Driver: ${shipment.driver.name}</small>
                                                <small class="text-muted">
                                                    <fmt:parseDate value="${shipment.expectedDeliveryDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                                                </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group-item">
                                        <div class="alert alert-info mb-0">
                                            <i class="fas fa-info-circle me-2"></i>No active shipments found.
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-8">
                <div id="shipmentDetailPanel">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>Select a shipment from the list to view tracking details.
                    </div>
                </div>
                
                <div id="shipmentTrackingDetails" class="d-none">
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Shipment Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5 id="trackingNumber"></h5>
                                    <p class="mb-1"><strong>Status:</strong> <span id="shipmentStatus" class="badge"></span></p>
                                    <p class="mb-1"><strong>Driver:</strong> <span id="driverName"></span></p>
                                    <p class="mb-1"><strong>Driver Contact:</strong> <span id="driverContact"></span></p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Origin:</strong> <span id="pickupAddress"></span></p>
                                    <p class="mb-1"><strong>Destination:</strong> <span id="deliveryAddress"></span></p>
                                    <p class="mb-1"><strong>Expected Delivery:</strong> <span id="expectedDelivery"></span></p>
                                    <p class="mb-1"><strong>Shipper:</strong> <span id="shipperName"></span></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-map-marked-alt me-2"></i>Tracking Map</h5>
                        </div>
                        <div class="card-body">
                            <div class="map-container" id="map">
                                <div class="d-flex justify-content-center align-items-center h-100">
                                    <div class="text-center">
                                        <i class="fas fa-map-marked-alt fa-4x text-muted mb-3"></i>
                                        <h5>Map Loading...</h5>
                                        <p class="text-muted">Retrieving real-time location data</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-history me-2"></i>Shipment Timeline</h5>
                        </div>
                        <div class="card-body">
                            <div class="timeline">
                                <div class="timeline-item">
                                    <div class="timeline-marker completed">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h6>Order Placed</h6>
                                        <p class="text-muted mb-0">Shipment has been created and is waiting for pickup</p>
                                        <small class="text-muted" id="orderPlacedTime"></small>
                                    </div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-marker" id="pickedUpMarker">
                                        <i class="fas fa-truck-loading"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h6>Picked Up</h6>
                                        <p class="text-muted mb-0">Driver has picked up the shipment from origin</p>
                                        <small class="text-muted" id="pickedUpTime"></small>
                                    </div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-marker" id="inTransitMarker">
                                        <i class="fas fa-shipping-fast"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h6>In Transit</h6>
                                        <p class="text-muted mb-0">Shipment is on its way to destination</p>
                                        <small class="text-muted" id="inTransitTime"></small>
                                    </div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-marker" id="outForDeliveryMarker">
                                        <i class="fas fa-truck"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h6>Out For Delivery</h6>
                                        <p class="text-muted mb-0">Shipment is out for final delivery</p>
                                        <small class="text-muted" id="outForDeliveryTime"></small>
                                    </div>
                                </div>
                                
                                <div class="timeline-item">
                                    <div class="timeline-marker" id="deliveredMarker">
                                        <i class="fas fa-box-open"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <h6>Delivered</h6>
                                        <p class="text-muted mb-0">Shipment has been delivered to destination</p>
                                        <small class="text-muted" id="deliveredTime"></small>
                                    </div>
                                </div>
                            </div>
                        </div>
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
            // Dummy data for demo purposes - would be replaced with real API calls
            const shipmentData = {
                <c:forEach items="${shipments}" var="shipment" varStatus="status">
                    "${shipment.id}": {
                        id: ${shipment.id},
                        trackingNumber: "${shipment.trackingNumber}",
                        status: "${shipment.status}",
                        pickupAddress: "${shipment.pickupAddress}",
                        deliveryAddress: "${shipment.deliveryAddress}",
                        createdAt: "${shipment.createdAt}",
                        expectedDeliveryDate: "${shipment.expectedDeliveryDate}",
                        driver: {
                            name: "${shipment.driver.name}",
                            contactNumber: "${shipment.driver.contactNumber}"
                        },
                        shipper: {
                            name: "${shipment.shipper.companyName}"
                        },
                        timeline: {
                            orderPlaced: "${shipment.createdAt}",
                            pickedUp: "${shipment.status eq 'PICKED_UP' || shipment.status eq 'IN_TRANSIT' || shipment.status eq 'OUT_FOR_DELIVERY' || shipment.status eq 'DELIVERED' ? '2025-04-25T10:30:00' : ''}",
                            inTransit: "${shipment.status eq 'IN_TRANSIT' || shipment.status eq 'OUT_FOR_DELIVERY' || shipment.status eq 'DELIVERED' ? '2025-04-25T11:45:00' : ''}",
                            outForDelivery: "${shipment.status eq 'OUT_FOR_DELIVERY' || shipment.status eq 'DELIVERED' ? '2025-04-25T14:20:00' : ''}",
                            delivered: "${shipment.status eq 'DELIVERED' ? '2025-04-25T16:10:00' : ''}"
                        }
                    }${!status.last ? ',' : ''}
                </c:forEach>
            };
            
            // Handle shipment card click
            $('.shipment-card').click(function() {
                // Remove selection from all cards
                $('.shipment-card').removeClass('selected');
                
                // Add selection to clicked card
                $(this).addClass('selected');
                
                // Get shipment ID
                const shipmentId = $(this).data('shipment-id');
                
                // Show details panel, hide placeholder
                $('#shipmentDetailPanel').hide();
                $('#shipmentTrackingDetails').removeClass('d-none');
                
                // Update shipment details
                updateShipmentDetails(shipmentId);
            });
            
            function updateShipmentDetails(shipmentId) {
                const shipment = shipmentData[shipmentId];
                if (!shipment) return;
                
                // Update basic info
                $('#trackingNumber').text('Tracking #: ' + shipment.trackingNumber);
                $('#shipmentStatus').text(shipment.status.replace(/_/g, ' '));
                $('#shipmentStatus').removeClass().addClass('badge bg-' + getStatusClass(shipment.status));
                $('#driverName').text(shipment.driver.name);
                $('#driverContact').text(shipment.driver.contactNumber);
                $('#pickupAddress').text(shipment.pickupAddress);
                $('#deliveryAddress').text(shipment.deliveryAddress);
                
                // Format dates
                const expectedDate = new Date(shipment.expectedDeliveryDate);
                $('#expectedDelivery').text(formatDate(expectedDate));
                $('#shipperName').text(shipment.shipper.name);
                
                // Update timeline
                updateTimeline(shipment);
                
                // In a real application, you would initialize the map with actual coordinates
                initializeDummyMap();
            }
            
            function updateTimeline(shipment) {
                // Reset all markers
                $('.timeline-marker').removeClass('active completed');
                
                // Set order placed time
                if (shipment.timeline.orderPlaced) {
                    $('#orderPlacedTime').text(formatDateTime(new Date(shipment.timeline.orderPlaced)));
                    $('#orderPlacedMarker').addClass('completed');
                }
                
                // Set picked up time and status
                if (shipment.timeline.pickedUp) {
                    $('#pickedUpTime').text(formatDateTime(new Date(shipment.timeline.pickedUp)));
                    $('#pickedUpMarker').addClass('completed');
                }
                
                // Set in transit time and status
                if (shipment.timeline.inTransit) {
                    $('#inTransitTime').text(formatDateTime(new Date(shipment.timeline.inTransit)));
                    $('#inTransitMarker').addClass(shipment.status === 'IN_TRANSIT' ? 'active' : 'completed');
                }
                
                // Set out for delivery time and status
                if (shipment.timeline.outForDelivery) {
                    $('#outForDeliveryTime').text(formatDateTime(new Date(shipment.timeline.outForDelivery)));
                    $('#outForDeliveryMarker').addClass(shipment.status === 'OUT_FOR_DELIVERY' ? 'active' : 'completed');
                }
                
                // Set delivered time and status
                if (shipment.timeline.delivered) {
                    $('#deliveredTime').text(formatDateTime(new Date(shipment.timeline.delivered)));
                    $('#deliveredMarker').addClass('completed');
                }
            }
            
            function getStatusClass(status) {
                switch(status) {
                    case 'PENDING': return 'secondary';
                    case 'ACCEPTED': return 'info';
                    case 'PICKED_UP': return 'primary';
                    case 'IN_TRANSIT': return 'primary';
                    case 'OUT_FOR_DELIVERY': return 'warning';
                    case 'DELIVERED': return 'success';
                    case 'CANCELLED': return 'danger';
                    default: return 'secondary';
                }
            }
            
            function formatDate(date) {
                return date.toLocaleDateString('en-GB', {
                    day: '2-digit',
                    month: '2-digit',
                    year: 'numeric'
                });
            }
            
            function formatDateTime(date) {
                return date.toLocaleDateString('en-GB', {
                    day: '2-digit',
                    month: '2-digit',
                    year: 'numeric'
                }) + ' ' + date.toLocaleTimeString('en-GB', {
                    hour: '2-digit',
                    minute: '2-digit'
                });
            }
            
            function initializeDummyMap() {
                // In a real app, this would initialize a map with the shipment's location
                // For demo purposes, we're just showing a placeholder
                $('#map').html(`
                    <div class="d-flex justify-content-center align-items-center h-100">
                        <div class="text-center">
                            <i class="fas fa-map-marked-alt fa-4x text-primary mb-3"></i>
                            <h5>Live Tracking Map</h5>
                            <p class="text-muted">This is a placeholder for the actual map integration.</p>
                            <p class="text-muted">In a production environment, this would show the real-time location of the shipment.</p>
                        </div>
                    </div>
                `);
            }
        });
    </script>
</body>
</html> 