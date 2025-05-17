<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Shipment - PicknGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .tracking-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .tracking-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .timeline {
            list-style-type: none;
            position: relative;
            padding-left: 30px;
        }
        .timeline:before {
            content: ' ';
            background: #dee2e6;
            display: inline-block;
            position: absolute;
            left: 9px;
            top: 0;
            width: 2px;
            height: 100%;
        }
        .timeline > li {
            margin-bottom: 20px;
            position: relative;
        }
        .timeline > li:before {
            content: ' ';
            background: white;
            display: inline-block;
            position: absolute;
            border-radius: 50%;
            border: 2px solid #28a745;
            left: -30px;
            width: 20px;
            height: 20px;
            z-index: 1;
            top: 3px;
        }
        .timeline > li.active:before {
            background: #28a745;
        }
        #map {
            height: 400px;
            width: 100%;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="fas fa-map-marker-alt me-2"></i>Track Shipment</h1>
            <a href="/shipper/shipments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Shipments
            </a>
        </div>
        
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="card tracking-card">
                    <div class="tracking-header">
                        <h5 class="mb-0">Shipment Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Tracking Number:</h6>
                            <p class="fw-bold">${shipment.trackingNumber}</p>
                        </div>
                        <div class="mb-3">
                            <h6>Status:</h6>
                            <p>
                                <span class="badge ${shipment.status == 'DELIVERED' ? 'bg-success' : shipment.status == 'IN_TRANSIT' ? 'bg-warning text-dark' : 'bg-primary'} mb-2">
                                    ${shipment.status}
                                </span>
                            </p>
                        </div>
                        <div class="mb-3">
                            <h6>Origin:</h6>
                            <p>${shipment.originAddress}</p>
                        </div>
                        <div class="mb-3">
                            <h6>Destination:</h6>
                            <p>${shipment.destinationAddress}</p>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <h6>Weight:</h6>
                                <p>${shipment.weight} kg</p>
                            </div>
                            <div class="col-6">
                                <h6>Created:</h6>
                                <p><fmt:formatDate value="${shipment.createdAt}" pattern="MMM dd, yyyy" /></p>
                            </div>
                        </div>
                        
                        <c:if test="${shipment.status != 'DELIVERED'}">
                            <div class="d-grid gap-2">
                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#updateModal">
                                    <i class="fas fa-edit me-2"></i>Update Status
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <div class="card tracking-card">
                    <div class="tracking-header">
                        <h5 class="mb-0">Shipment Timeline</h5>
                    </div>
                    <div class="card-body">
                        <ul class="timeline">
                            <li class="active">
                                <h6>Order Created</h6>
                                <p class="text-muted mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>
                                    <fmt:formatDate value="${shipment.createdAt}" pattern="MMM dd, yyyy HH:mm" />
                                </p>
                                <p class="text-muted">Shipment registered in the system</p>
                            </li>
                            <li class="${shipment.status == 'IN_TRANSIT' || shipment.status == 'DELIVERED' ? 'active' : ''}">
                                <h6>In Transit</h6>
                                <c:if test="${shipment.status == 'IN_TRANSIT' || shipment.status == 'DELIVERED'}">
                                    <p class="text-muted mb-0">
                                        <i class="fas fa-calendar-alt me-2"></i>
                                        <fmt:formatDate value="${shipment.updatedAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </p>
                                    <p class="text-muted">Shipment is on the way</p>
                                </c:if>
                            </li>
                            <li class="${shipment.status == 'DELIVERED' ? 'active' : ''}">
                                <h6>Delivered</h6>
                                <c:if test="${shipment.status == 'DELIVERED'}">
                                    <p class="text-muted mb-0">
                                        <i class="fas fa-calendar-alt me-2"></i>
                                        <fmt:formatDate value="${shipment.updatedAt}" pattern="MMM dd, yyyy HH:mm" />
                                    </p>
                                    <p class="text-muted">Shipment has been delivered successfully</p>
                                </c:if>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card tracking-card">
                    <div class="tracking-header">
                        <h5 class="mb-0">Current Location</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${latestLocation != null}">
                                <div id="map" class="mb-3"></div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <h6>Last Updated:</h6>
                                            <p>
                                                <i class="fas fa-clock me-2"></i>
                                                <fmt:formatDate value="${latestLocation.timestamp}" pattern="MMM dd, yyyy HH:mm:ss" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <h6>Coordinates:</h6>
                                            <p>
                                                <i class="fas fa-map-marker-alt me-2"></i>
                                                ${latestLocation.latitude}, ${latestLocation.longitude}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info mb-0">
                                    <i class="fas fa-info-circle me-2"></i>No location data available for this shipment yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card tracking-card">
                    <div class="tracking-header">
                        <h5 class="mb-0">Recipient Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <h6>Recipient Name:</h6>
                                    <p>${shipment.recipientName}</p>
                                </div>
                                <div class="mb-3">
                                    <h6>Recipient Phone:</h6>
                                    <p>${shipment.recipientPhone}</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <h6>Recipient Email:</h6>
                                    <p>${shipment.recipientEmail}</p>
                                </div>
                                <div class="mb-3">
                                    <h6>Recipient Address:</h6>
                                    <p>${shipment.destinationAddress}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Update Status Modal -->
    <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateModalLabel">Update Shipment Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="/shipper/update-status/${shipment.id}" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="">Select status</option>
                                <option value="IN_TRANSIT" ${shipment.status == 'IN_TRANSIT' ? 'selected' : ''}>In Transit</option>
                                <option value="DELIVERED" ${shipment.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="notes" class="form-label">Notes (Optional)</label>
                            <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <c:if test="${latestLocation != null}">
        <script>
            function initMap() {
                const shipmentLocation = { 
                    lat: ${latestLocation.latitude}, 
                    lng: ${latestLocation.longitude} 
                };
                
                const map = new google.maps.Map(document.getElementById("map"), {
                    zoom: 15,
                    center: shipmentLocation,
                });
                
                const marker = new google.maps.Marker({
                    position: shipmentLocation,
                    map: map,
                    title: "Current location",
                    animation: google.maps.Animation.DROP,
                });
                
                const infowindow = new google.maps.InfoWindow({
                    content: "<strong>Shipment #${shipment.trackingNumber}</strong><br>Status: ${shipment.status}",
                });
                
                marker.addListener("click", () => {
                    infowindow.open(map, marker);
                });
            }
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap" async defer></script>
    </c:if>
</body>
</html> 